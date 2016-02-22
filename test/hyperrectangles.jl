context("Hyper Cubes") do
    context("Core") do
        x = centered(HyperCube)
        @fact origin(x) --> Vec3f0(-0.5)
        @fact widths(x) --> Vec3f0(1.0)
        @fact maximum(x) --> Vec3f0(0.5)
        @fact minimum(x) --> Vec3f0(-0.5)
    end
end
context("Hyper Rectangles") do


context("constructors and containment") do
    # HyperRectangle(vals...)
    a = HyperRectangle(0,0,1,1)
    @fact a --> HyperRectangle{2,Int}(Vec(0,0),Vec(1,1))

    b = HyperRectangle(0,0,1,1,1,2)
    @fact b --> HyperRectangle{3,Int}(Vec(0,0,1),Vec(1,1,2))

    a = AABB(0,0,0,1,1,1)
    b = AABB(Vec(0,0,0),Vec(1,1,1))
    @fact a --> HyperRectangle(0,0,0,1,1,1)
    @fact a --> b

    a = HyperRectangle{4, Float64}()
    @fact a --> HyperRectangle{4, Float64}(Vec(Inf,Inf,Inf,Inf), Vec(-Inf,-Inf,-Inf,-Inf))

    a = update(a, Vec(1,2,3,4))

    @fact a --> HyperRectangle{4, Float64}(Vec(1.0,2.0,3.0,4.0),Vec4f0(0.0))
    @fact a == HyperRectangle{4, Float64}(Vec(3.0,2.0,3.0,4.0),Vec(1.0,2.0,3.0,4.0)) --> false

    a = update(a, Vec(5,6,7,8))


    b = HyperRectangle{4, Float64}(Vec(1.0,2.0,3.0,4.0),Vec4f0(4.0))
    @fact widths(b) --> Vec(4., 4., 4., 4.)
    @fact a --> b
    @fact isequal(a,b) --> true

    @fact maximum(a) --> Vec(5.0,6.0,7.0,8.0)
    @fact minimum(a) --> Vec(1.0,2.0,3.0,4.0)
    @fact origin(a) --> Vec(1.0,2.0,3.0,4.0)

    @fact_throws MethodError HyperRectangle(Vec(1.0,2.0,3.0), Vec(1.0,2.0,3.0,4.0))

    @fact (in(a,b) && in(b,a) && contains(a,b) && contains(b,a)) --> true

    c = HyperRectangle(Vec(1.1,2.1,3.1,4.1),Vec4f0(3.8))

    @fact (!in(a,c) && in(c,a) && contains(a,c) && !contains(c,a)) --> true

    #conversion
    h = HyperRectangle(0,0,1,1)
    @fact HyperRectangle{2,Float64}(h) --> HyperRectangle(0.,0.,1.,1.)

    # AABB
    a = AABB(0,0,1,1)
    @fact a --> HyperRectangle{2,Int}(Vec(0,0),Vec(1,1))

    centered_rect = centered(HyperRectangle)
    @fact centered_rect --> HyperRectangle{3,Float32}(Vec3f0(-0.5),Vec3f0(1))
    centered_rect = centered(HyperRectangle{2})
    @fact centered_rect --> HyperRectangle{2,Float32}(Vec2f0(-0.5),Vec2f0(1))

    centered_rect = centered(HyperRectangle{2, Float64})
    @fact centered_rect --> HyperRectangle{2,Float64}(Vec(-0.5, -0.5),Vec(1.,1.))

    centered_rect = centered(HyperRectangle{3, Float32})
    @fact centered_rect --> HyperRectangle{3,Float64}(Vec(-0.5,-0.5,-0.5),Vec(1.,1.,1.))


end

# Testing split function
context("Testing split function") do
    d = HyperRectangle{4, Float64}(Vec(1.0,2.0,3.0,4.0),Vec4f0(1.0))
    d1, d2 = split(d, 3, 3.5)

    @fact maximum(d1)[3] --> 3.5
    @fact minimum(d1)[3] --> 3.0
    @fact maximum(d2)[3] --> 4.0
    @fact minimum(d2)[3] --> 3.5

    d = HyperRectangle(0,0,2,2)
    d1, d2 = split(d, 1, 1)
    @fact d1 --> HyperRectangle(0,0,1,2)
    @fact d2 --> HyperRectangle(1,0,1,2)
end


context("Test distance functions") do
    a = HyperRectangle(Vec(0.0,0.0), Vec(1.0, 1.0))
    b = HyperRectangle(Vec(2.0,3.0), Vec(1.0, 1.0))
    p = Vec(2.5, 1.5)

    # Rect - Rect
    @fact min_dist_dim(a, b, 1) --> 1.0
    @fact min_dist_dim(a, b, 2) --> 2.0
    @fact max_dist_dim(a, b, 1) --> 3.0
    @fact max_dist_dim(a, b, 2) --> 4.0

    @fact min_euclideansq(a, b) --> 5.0
    @fact max_euclideansq(a, b) --> 25.0
    @fact minmax_euclideansq(a, b) --> (5.0, 25.0)

    @fact min_euclidean(a, b) --> sqrt(5.0)
    @fact max_euclidean(a, b) --> sqrt(25.0)
    @fact minmax_euclidean(a, b) --> (sqrt(5.0), sqrt(25.0))

    # Rect - Point
    @fact min_dist_dim(a, p, 1) --> 1.5
    @fact max_dist_dim(a, p, 1) --> 2.5
    @fact minmax_dist_dim(a, p, 1) --> (1.5, 2.5)

    @fact min_dist_dim(a, p, 2) --> 0.5
    @fact max_dist_dim(a, p, 2) --> 1.5
    @fact minmax_dist_dim(a, p, 2) --> (0.5, 1.5)

    @fact min_euclideansq(a, p) --> 2.5
    @fact max_euclideansq(a, p) --> 8.5
    @fact minmax_euclideansq(a, p) --> (2.5, 8.5)

    @fact min_euclidean(a, p) --> sqrt(2.5)
    @fact max_euclidean(a, p) --> sqrt(8.5)
    @fact minmax_euclidean(a, p) --> (sqrt(2.5), sqrt(8.5))

    p2 = Vec(0.75, 0.75)
    @fact min_dist_dim(a, p2, 1) --> 0.0
    @fact min_dist_dim(a, p2, 2) --> 0.0

    b2  = HyperRectangle(Vec(0.25, 0.25), Vec(0.75,0.75))
    @fact min_dist_dim(a, b2, 1) --> 0
    @fact min_dist_dim(a, b2, 2) --> 0
end

context("set operations") do
    a = HyperRectangle(Vec(0,0),Vec(1,1))
    b = HyperRectangle(Vec(1,1),Vec(1,1))

    @fact union(a,b) --> union(b,a)
    @fact union(a,b) --> HyperRectangle(Vec(0,0), Vec(2,2))
    @fact intersect(a,b) --> intersect(b,a)
    @fact intersect(a,b) --> HyperRectangle(Vec(1,1), Vec(0,0))
    @fact diff(a,b) --> a
    @fact diff(b,a) --> b

    c = HyperRectangle(Vec(0,0),Vec(2,2))
    d = HyperRectangle(Vec(1,1),Vec(2,2))
    @fact union(c,d) --> union(d,c)
    @fact union(c,d) --> HyperRectangle(Vec(0,0), Vec(3,3))
    @fact intersect(c,d) --> intersect(d,c)
    @fact intersect(c,d) --> HyperRectangle(Vec(1,1), Vec(1,1))
    @fact diff(c,d) --> c
    @fact diff(d,c) --> d

end

# fact relations
context("relations") do
    a = HyperRectangle(Vec(0,0),Vec(1,1))
    b = HyperRectangle(Vec(1,1),Vec(1,1))
    c = HyperRectangle(Vec(0,0),Vec(2,2))
    d = HyperRectangle(Vec(1,1),Vec(2,2))
    e = HyperRectangle(Vec(3,3),Vec(1,1))
    d = HyperRectangle(Vec(0.25,0.25),Vec(0.5,0.5))
    f = HyperRectangle(Vec(0.9,0.9), Vec(1.1,1.1))

    @fact (finishes(b,c) && !finishes(c,b)) --> true
    @fact (!finishes(a,b)) --> true
    @fact (meets(a,b) && !meets(b,a)) --> true
    @fact (before(a,e) && !before(e,a)) --> true
    @fact (during(d,a) && !during(a,d)) --> true
    @fact (starts(a,c) && !starts(c,a)) --> true
    @fact (!starts(a,b)) --> true
    @fact (!overlaps(a,b) && !overlaps(b,a)) --> true
    @fact (overlaps(a,f) && !overlaps(f,a)) --> true
end

context("point membership") do
    a = HyperRectangle{4, Float64}(Vec(1.0,2.0,3.0,4.0),Vec4f0(4.0))
    @fact (in(Vec(4,5,6,7),a) && contains(a,Vec(4,5,6,7))) --> true
    @fact (in(Vec(5,6,7,8),a) && contains(a,Vec(5,6,7,8))) --> true
    @fact (!in(Vec(6,7,8,9),a) && !contains(a,Vec(6,7,8,9))) --> true
end

context("from Points") do
    a = HyperRectangle([Point(1,1), Point(2,3), Point(4,5), Point(0,-1)])
    @fact a --> HyperRectangle(0,-1,4,6)
    a = HyperRectangle{3,Int}([Point(1,1), Point(2,3), Point(4,5), Point(0,-1)])
    @fact a --> HyperRectangle(0,-1,0,4,6,0)
end

context("transforms") do
    t = Mat((1,0,0),(0,1,0),(1,2,0))
    h = t*HyperRectangle(0,0,1,1)
    @fact h --> HyperRectangle(1,2,1,1)
    t = Mat((0,1),(1,0))
    h = t*HyperRectangle(0,0,1,2)
    @fact h --> HyperRectangle(0,0,2,1)
end

end
