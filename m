Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08D2F36AD17
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232381AbhDZHcY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:32:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:43088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232408AbhDZHcW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:32:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EEB0061152;
        Mon, 26 Apr 2021 07:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422301;
        bh=SNOxAfji0tL/uKpYElfBbYBnwyl0/+GzvKotkrhGK20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VRgUFILzMDIU6HCT5oqAteyqen3itmcxwhhernMC7XpjyKKTWouTLYGLqLzUShaWV
         B6yvuoD+8/V+rwOiI80s9zXAnBWDvjwwxO6zdZ4O92h7WWmItSUGVXXtUB58VctSPy
         zovkVOz5UJ8FmNfWONFi714Rivkbdm25/NWpMFkE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 4.4 30/32] compiler.h: enable builtin overflow checkers and add fallback code
Date:   Mon, 26 Apr 2021 09:29:28 +0200
Message-Id: <20210426072817.574359237@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072816.574319312@linuxfoundation.org>
References: <20210426072816.574319312@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>

commit f0907827a8a9152aedac2833ed1b674a7b2a44f2 upstream.

This adds wrappers for the __builtin overflow checkers present in gcc
5.1+ as well as fallback implementations for earlier compilers. It's not
that easy to implement the fully generic __builtin_X_overflow(T1 a, T2
b, T3 *d) in macros, so the fallback code assumes that T1, T2 and T3 are
the same. We obviously don't want the wrappers to have different
semantics depending on $GCC_VERSION, so we also insist on that even when
using the builtins.

There are a few problems with the 'a+b < a' idiom for checking for
overflow: For signed types, it relies on undefined behaviour and is
not actually complete (it doesn't check underflow;
e.g. INT_MIN+INT_MIN == 0 isn't caught). Due to type promotion it
is wrong for all types (signed and unsigned) narrower than
int. Similarly, when a and b does not have the same type, there are
subtle cases like

  u32 a;

  if (a + sizeof(foo) < a)
    return -EOVERFLOW;
  a += sizeof(foo);

where the test is always false on 64 bit platforms. Add to that that it
is not always possible to determine the types involved at a glance.

The new overflow.h is somewhat bulky, but that's mostly a result of
trying to be type-generic, complete (e.g. catching not only overflow
but also signed underflow) and not relying on undefined behaviour.

Linus is of course right [1] that for unsigned subtraction a-b, the
right way to check for overflow (underflow) is "b > a" and not
"__builtin_sub_overflow(a, b, &d)", but that's just one out of six cases
covered here, and included mostly for completeness.

So is it worth it? I think it is, if nothing else for the documentation
value of seeing

  if (check_add_overflow(a, b, &d))
    return -EGOAWAY;
  do_stuff_with(d);

instead of the open-coded (and possibly wrong and/or incomplete and/or
UBsan-tickling)

  if (a+b < a)
    return -EGOAWAY;
  do_stuff_with(a+b);

While gcc does recognize the 'a+b < a' idiom for testing unsigned add
overflow, it doesn't do nearly as good for unsigned multiplication
(there's also no single well-established idiom). So using
check_mul_overflow in kcalloc and friends may also make gcc generate
slightly better code.

[1] https://lkml.org/lkml/2015/11/2/658

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/compiler-clang.h |   14 ++
 include/linux/compiler-gcc.h   |    4 
 include/linux/compiler-intel.h |    4 
 include/linux/overflow.h       |  205 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 227 insertions(+)
 create mode 100644 include/linux/overflow.h

--- a/include/linux/compiler-clang.h
+++ b/include/linux/compiler-clang.h
@@ -15,3 +15,17 @@
  * with any version that can compile the kernel
  */
 #define __UNIQUE_ID(prefix) __PASTE(__PASTE(__UNIQUE_ID_, prefix), __COUNTER__)
+
+/*
+ * Not all versions of clang implement the the type-generic versions
+ * of the builtin overflow checkers. Fortunately, clang implements
+ * __has_builtin allowing us to avoid awkward version
+ * checks. Unfortunately, we don't know which version of gcc clang
+ * pretends to be, so the macro may or may not be defined.
+ */
+#undef COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW
+#if __has_builtin(__builtin_mul_overflow) && \
+    __has_builtin(__builtin_add_overflow) && \
+    __has_builtin(__builtin_sub_overflow)
+#define COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW 1
+#endif
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -321,3 +321,7 @@
  * code
  */
 #define uninitialized_var(x) x = x
+
+#if GCC_VERSION >= 50100
+#define COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW 1
+#endif
--- a/include/linux/compiler-intel.h
+++ b/include/linux/compiler-intel.h
@@ -43,3 +43,7 @@
 #define __builtin_bswap16 _bswap16
 #endif
 
+/*
+ * icc defines __GNUC__, but does not implement the builtin overflow checkers.
+ */
+#undef COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW
--- /dev/null
+++ b/include/linux/overflow.h
@@ -0,0 +1,205 @@
+/* SPDX-License-Identifier: GPL-2.0 OR MIT */
+#ifndef __LINUX_OVERFLOW_H
+#define __LINUX_OVERFLOW_H
+
+#include <linux/compiler.h>
+
+/*
+ * In the fallback code below, we need to compute the minimum and
+ * maximum values representable in a given type. These macros may also
+ * be useful elsewhere, so we provide them outside the
+ * COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW block.
+ *
+ * It would seem more obvious to do something like
+ *
+ * #define type_min(T) (T)(is_signed_type(T) ? (T)1 << (8*sizeof(T)-1) : 0)
+ * #define type_max(T) (T)(is_signed_type(T) ? ((T)1 << (8*sizeof(T)-1)) - 1 : ~(T)0)
+ *
+ * Unfortunately, the middle expressions, strictly speaking, have
+ * undefined behaviour, and at least some versions of gcc warn about
+ * the type_max expression (but not if -fsanitize=undefined is in
+ * effect; in that case, the warning is deferred to runtime...).
+ *
+ * The slightly excessive casting in type_min is to make sure the
+ * macros also produce sensible values for the exotic type _Bool. [The
+ * overflow checkers only almost work for _Bool, but that's
+ * a-feature-not-a-bug, since people shouldn't be doing arithmetic on
+ * _Bools. Besides, the gcc builtins don't allow _Bool* as third
+ * argument.]
+ *
+ * Idea stolen from
+ * https://mail-index.netbsd.org/tech-misc/2007/02/05/0000.html -
+ * credit to Christian Biere.
+ */
+#define is_signed_type(type)       (((type)(-1)) < (type)1)
+#define __type_half_max(type) ((type)1 << (8*sizeof(type) - 1 - is_signed_type(type)))
+#define type_max(T) ((T)((__type_half_max(T) - 1) + __type_half_max(T)))
+#define type_min(T) ((T)((T)-type_max(T)-(T)1))
+
+
+#ifdef COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW
+/*
+ * For simplicity and code hygiene, the fallback code below insists on
+ * a, b and *d having the same type (similar to the min() and max()
+ * macros), whereas gcc's type-generic overflow checkers accept
+ * different types. Hence we don't just make check_add_overflow an
+ * alias for __builtin_add_overflow, but add type checks similar to
+ * below.
+ */
+#define check_add_overflow(a, b, d) ({		\
+	typeof(a) __a = (a);			\
+	typeof(b) __b = (b);			\
+	typeof(d) __d = (d);			\
+	(void) (&__a == &__b);			\
+	(void) (&__a == __d);			\
+	__builtin_add_overflow(__a, __b, __d);	\
+})
+
+#define check_sub_overflow(a, b, d) ({		\
+	typeof(a) __a = (a);			\
+	typeof(b) __b = (b);			\
+	typeof(d) __d = (d);			\
+	(void) (&__a == &__b);			\
+	(void) (&__a == __d);			\
+	__builtin_sub_overflow(__a, __b, __d);	\
+})
+
+#define check_mul_overflow(a, b, d) ({		\
+	typeof(a) __a = (a);			\
+	typeof(b) __b = (b);			\
+	typeof(d) __d = (d);			\
+	(void) (&__a == &__b);			\
+	(void) (&__a == __d);			\
+	__builtin_mul_overflow(__a, __b, __d);	\
+})
+
+#else
+
+
+/* Checking for unsigned overflow is relatively easy without causing UB. */
+#define __unsigned_add_overflow(a, b, d) ({	\
+	typeof(a) __a = (a);			\
+	typeof(b) __b = (b);			\
+	typeof(d) __d = (d);			\
+	(void) (&__a == &__b);			\
+	(void) (&__a == __d);			\
+	*__d = __a + __b;			\
+	*__d < __a;				\
+})
+#define __unsigned_sub_overflow(a, b, d) ({	\
+	typeof(a) __a = (a);			\
+	typeof(b) __b = (b);			\
+	typeof(d) __d = (d);			\
+	(void) (&__a == &__b);			\
+	(void) (&__a == __d);			\
+	*__d = __a - __b;			\
+	__a < __b;				\
+})
+/*
+ * If one of a or b is a compile-time constant, this avoids a division.
+ */
+#define __unsigned_mul_overflow(a, b, d) ({		\
+	typeof(a) __a = (a);				\
+	typeof(b) __b = (b);				\
+	typeof(d) __d = (d);				\
+	(void) (&__a == &__b);				\
+	(void) (&__a == __d);				\
+	*__d = __a * __b;				\
+	__builtin_constant_p(__b) ?			\
+	  __b > 0 && __a > type_max(typeof(__a)) / __b : \
+	  __a > 0 && __b > type_max(typeof(__b)) / __a;	 \
+})
+
+/*
+ * For signed types, detecting overflow is much harder, especially if
+ * we want to avoid UB. But the interface of these macros is such that
+ * we must provide a result in *d, and in fact we must produce the
+ * result promised by gcc's builtins, which is simply the possibly
+ * wrapped-around value. Fortunately, we can just formally do the
+ * operations in the widest relevant unsigned type (u64) and then
+ * truncate the result - gcc is smart enough to generate the same code
+ * with and without the (u64) casts.
+ */
+
+/*
+ * Adding two signed integers can overflow only if they have the same
+ * sign, and overflow has happened iff the result has the opposite
+ * sign.
+ */
+#define __signed_add_overflow(a, b, d) ({	\
+	typeof(a) __a = (a);			\
+	typeof(b) __b = (b);			\
+	typeof(d) __d = (d);			\
+	(void) (&__a == &__b);			\
+	(void) (&__a == __d);			\
+	*__d = (u64)__a + (u64)__b;		\
+	(((~(__a ^ __b)) & (*__d ^ __a))	\
+		& type_min(typeof(__a))) != 0;	\
+})
+
+/*
+ * Subtraction is similar, except that overflow can now happen only
+ * when the signs are opposite. In this case, overflow has happened if
+ * the result has the opposite sign of a.
+ */
+#define __signed_sub_overflow(a, b, d) ({	\
+	typeof(a) __a = (a);			\
+	typeof(b) __b = (b);			\
+	typeof(d) __d = (d);			\
+	(void) (&__a == &__b);			\
+	(void) (&__a == __d);			\
+	*__d = (u64)__a - (u64)__b;		\
+	((((__a ^ __b)) & (*__d ^ __a))		\
+		& type_min(typeof(__a))) != 0;	\
+})
+
+/*
+ * Signed multiplication is rather hard. gcc always follows C99, so
+ * division is truncated towards 0. This means that we can write the
+ * overflow check like this:
+ *
+ * (a > 0 && (b > MAX/a || b < MIN/a)) ||
+ * (a < -1 && (b > MIN/a || b < MAX/a) ||
+ * (a == -1 && b == MIN)
+ *
+ * The redundant casts of -1 are to silence an annoying -Wtype-limits
+ * (included in -Wextra) warning: When the type is u8 or u16, the
+ * __b_c_e in check_mul_overflow obviously selects
+ * __unsigned_mul_overflow, but unfortunately gcc still parses this
+ * code and warns about the limited range of __b.
+ */
+
+#define __signed_mul_overflow(a, b, d) ({				\
+	typeof(a) __a = (a);						\
+	typeof(b) __b = (b);						\
+	typeof(d) __d = (d);						\
+	typeof(a) __tmax = type_max(typeof(a));				\
+	typeof(a) __tmin = type_min(typeof(a));				\
+	(void) (&__a == &__b);						\
+	(void) (&__a == __d);						\
+	*__d = (u64)__a * (u64)__b;					\
+	(__b > 0   && (__a > __tmax/__b || __a < __tmin/__b)) ||	\
+	(__b < (typeof(__b))-1  && (__a > __tmin/__b || __a < __tmax/__b)) || \
+	(__b == (typeof(__b))-1 && __a == __tmin);			\
+})
+
+
+#define check_add_overflow(a, b, d)					\
+	__builtin_choose_expr(is_signed_type(typeof(a)),		\
+			__signed_add_overflow(a, b, d),			\
+			__unsigned_add_overflow(a, b, d))
+
+#define check_sub_overflow(a, b, d)					\
+	__builtin_choose_expr(is_signed_type(typeof(a)),		\
+			__signed_sub_overflow(a, b, d),			\
+			__unsigned_sub_overflow(a, b, d))
+
+#define check_mul_overflow(a, b, d)					\
+	__builtin_choose_expr(is_signed_type(typeof(a)),		\
+			__signed_mul_overflow(a, b, d),			\
+			__unsigned_mul_overflow(a, b, d))
+
+
+#endif /* COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW */
+
+#endif /* __LINUX_OVERFLOW_H */


