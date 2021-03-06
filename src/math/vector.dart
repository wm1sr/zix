part of zix;

class Vector2D {
  num x;
  num y;

  static final Vector2D ZERO = new Vector2D();

  Vector2D([this.x = 0, this.y = 0]);

  Vector2D.byAngle(num angle) {
    x = cos(angle);
    y = sin(angle);
  }

  Vector2D.byOther(Vector2D other) {
    x = other.x;
    y = other.y;
  }

  void copy(Vector2D other) {
    x = other.x;
    y = other.y;
  }

  void set(num x, num y) {
    this.x = x;
    this.y = y;
  }

  Vector2D operator +(Vector2D other) => new Vector2D(x + other.x, y + other.y);

  Vector2D operator -(Vector2D other) => new Vector2D(x - other.x, y - other.y);

  Vector2D operator *(num scalar) => new Vector2D(x * scalar, y * scalar);

  bool operator >(Vector2D other) => x.abs() + y.abs() > other.x.abs() + other.y.abs();

  void addBy(Vector2D other) {
    x += other.x;
    y += other.y;
  }

  void subtractBy(Vector2D other) {
    x -= other.x;
    y -= other.y;
  }

  void multiplyBy(num n) {
    x *= n;
    y *= n;
  }

  void divideBy(num n) {
    x /= n;
    y /= n;
  }

  void negate() {
    x = -x;
    y = -y;
  }

  void normalize() {
    num len = length();
    x /= len;
    y /= len;
  }

  Vector2D pathTo(Vector2D other) {
    return other - this;
  }

  num dot(Vector2D other) {
    return (x * other.x) + (y * other.y);
  }

  num cross(Vector2D other) {
    return (-x * other.y) + (y * other.x);
  }

  Vector2D normalized() {
    var len = length();
    return new Vector2D(x / len, y / len);
  }

  Vector2D negative() {
    return new Vector2D(-x, -y);
  }

  Vector2D perpendicular({bool clockwise: true}) {
    if (clockwise) {
      return new Vector2D(-y, x);
    }
    return new Vector2D(y, -x);
  }

  num length() {
    return sqrt(x * x + y * y);
  }

  num lengthSquared() {
    return x * x + y * y;
  }

  // @optimize : methods
  void rotate(num angle, {Vector2D origin}) {
    num c = cos(angle);
    num s = sin(angle);

    if (origin != null) {
      subtractBy(origin);
      set(x * c - y * s, x * s + y * c);
      addBy(origin);
    } else {
      set(x * c - y * s, x * s + y * c);
    }
  }

  void rotateByTransform(Transform t) {
    num c = t.angleCos,
        s = t.angleSin;

    subtractBy(t.rotationOrigin);
    set(x * c - y * s, x * s + y * c);
    addBy(t.rotationOrigin);
  }

  void rotateInverseByTransform(Transform t) {
    num c = t.angleCos,
        s = t.angleSin;

    subtractBy(t.rotationOrigin);
    set(x * c + y * s, -x * s + y * c);
    addBy(t.rotationOrigin);
  }

  void applyTransform(Transform t) {
    num s = t.angleCos,
        c = t.angleSin;

    // @optimize : methods
    subtractBy(t.rotationOrigin);
    set(x * c - y * s, x * s + y * c);
    addBy(t.rotationOrigin);
    addBy(t.translation);
  }

  num projection(Vector2D other) {
    return dot(other) / other.length();
  }

  num angle() {
    return atan2(y, x);
  }

  // possibly wrong
  num angleBetween(Vector2D other) {
    if (other.equals(Vector2D.ZERO)) return angle();

    return atan2(y * other.x - x * other.y, x * other.x + y * other.y);
  }

  num distanceTo(Vector2D other) {
    return pathTo(other).length();
  }

  num distanceSquaredTo(Vector2D other) {
    num distanceX = x - other.x,
        distanceY = y - other.y;

    return distanceX * distanceX + distanceY * distanceY;
  }

  bool equals(Vector2D other) {
    return x == other.x && y == other.y;
  }

  String toString() {
    return '[$x, $y]';
  }
}