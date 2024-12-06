import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '자동차 애니메이션',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black87,
        colorScheme: const ColorScheme.dark(
          primary: Colors.blue,
          secondary: Colors.blueAccent,
        ),
      ),
      home: const CarAnimationPage(),
    );
  }
}

class CarAnimationPage extends StatefulWidget {
  const CarAnimationPage({super.key});

  @override
  State<CarAnimationPage> createState() => _CarAnimationPageState();
}

class _CarAnimationPageState extends State<CarAnimationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  int _randomNumber = 50;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0,
      end: 100,
    ).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _scaleAnimation = Tween<double>(
      begin: 1.7,
      end: 2.3,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _rotateAnimation = Tween<double>(
      begin: -35 * 3.14159 / 180, // -15도
      end: 25 * 3.14159 / 180, // +15도
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _startRandomNumberGenerator();
    _updateAnimationSpeed();
  }

  void _updateAnimationSpeed() {
    double duration;
    if (_randomNumber <= 50) {
      duration = 8.0 - ((_randomNumber / 50.0) * 4.0);
    } else {
      duration = 4.0 - (((_randomNumber - 50) / 50.0) * 3.0);
    }
    _controller.duration = Duration(milliseconds: (duration * 1000).round());
    _controller.repeat(reverse: true);
  }

  void _startRandomNumberGenerator() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _randomNumber = Random().nextInt(101);
        _updateAnimationSpeed();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('자동차 애니메이션'),
        backgroundColor: Colors.black54,
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.black87,
        ),
        child: Stack(
          children: [
            Positioned(
              left: 20,
              top: 20,
              child: Text(
                '현재 속: $_randomNumber',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            Center(
              child: Stack(
                children: [
                  Positioned(
                    left: MediaQuery.of(context).size.width / 2 - 50,
                    bottom: MediaQuery.of(context).size.height * 0.3,
                    child: Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateX(_rotateAnimation.value),
                      alignment: Alignment.center,
                      child: Transform.rotate(
                        angle: 90 * 3.14159 / 180,
                        child: Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Image.asset(
                            'assets/car.png',
                            width: 100,
                            height: 100,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
