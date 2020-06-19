Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF1D1201722
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389355AbgFSQel (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:34:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:43800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389346AbgFSOuo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:50:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF45620776;
        Fri, 19 Jun 2020 14:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578243;
        bh=53aYNnnLOlen577ZXwucOGJbWM+sEUTziXGRKAzbfxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nz1ednHjx7smIzdVE0kvDKifwmNqQKyiShufa7CVGqCH7v8LHXN0HIhIlCAX62B/n
         jNFhkjr2YIkGh7aXqs0T9AnHiwSU7M72PgrM3jMItRA+RxowCkYgjaxs2RgIcRz2QV
         jgkMPo2uMthvjXpXb/vwFIghzeVPMBmTxWL/tcko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Axtens <dja@axtens.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Gow <davidgow@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Daniel Micay <danielmicay@gmail.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Alexander Potapenko <glider@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 139/190] string.h: fix incompatibility between FORTIFY_SOURCE and KASAN
Date:   Fri, 19 Jun 2020 16:33:04 +0200
Message-Id: <20200619141640.570157748@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141633.446429600@linuxfoundation.org>
References: <20200619141633.446429600@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Axtens <dja@axtens.net>

[ Upstream commit 47227d27e2fcb01a9e8f5958d8997cf47a820afc ]

The memcmp KASAN self-test fails on a kernel with both KASAN and
FORTIFY_SOURCE.

When FORTIFY_SOURCE is on, a number of functions are replaced with
fortified versions, which attempt to check the sizes of the operands.
However, these functions often directly invoke __builtin_foo() once they
have performed the fortify check.  Using __builtins may bypass KASAN
checks if the compiler decides to inline it's own implementation as
sequence of instructions, rather than emit a function call that goes out
to a KASAN-instrumented implementation.

Why is only memcmp affected?
============================

Of the string and string-like functions that kasan_test tests, only memcmp
is replaced by an inline sequence of instructions in my testing on x86
with gcc version 9.2.1 20191008 (Ubuntu 9.2.1-9ubuntu2).

I believe this is due to compiler heuristics.  For example, if I annotate
kmalloc calls with the alloc_size annotation (and disable some fortify
compile-time checking!), the compiler will replace every memset except the
one in kmalloc_uaf_memset with inline instructions.  (I have some WIP
patches to add this annotation.)

Does this affect other functions in string.h?
=============================================

Yes. Anything that uses __builtin_* rather than __real_* could be
affected. This looks like:

 - strncpy
 - strcat
 - strlen
 - strlcpy maybe, under some circumstances?
 - strncat under some circumstances
 - memset
 - memcpy
 - memmove
 - memcmp (as noted)
 - memchr
 - strcpy

Whether a function call is emitted always depends on the compiler.  Most
bugs should get caught by FORTIFY_SOURCE, but the missed memcmp test shows
that this is not always the case.

Isn't FORTIFY_SOURCE disabled with KASAN?
========================================-

The string headers on all arches supporting KASAN disable fortify with
kasan, but only when address sanitisation is _also_ disabled.  For example
from x86:

 #if defined(CONFIG_KASAN) && !defined(__SANITIZE_ADDRESS__)
 /*
  * For files that are not instrumented (e.g. mm/slub.c) we
  * should use not instrumented version of mem* functions.
  */
 #define memcpy(dst, src, len) __memcpy(dst, src, len)
 #define memmove(dst, src, len) __memmove(dst, src, len)
 #define memset(s, c, n) __memset(s, c, n)

 #ifndef __NO_FORTIFY
 #define __NO_FORTIFY /* FORTIFY_SOURCE uses __builtin_memcpy, etc. */
 #endif

 #endif

This comes from commit 6974f0c4555e ("include/linux/string.h: add the
option of fortified string.h functions"), and doesn't work when KASAN is
enabled and the file is supposed to be sanitised - as with test_kasan.c

I'm pretty sure this is not wrong, but not as expansive it should be:

 * we shouldn't use __builtin_memcpy etc in files where we don't have
   instrumentation - it could devolve into a function call to memcpy,
   which will be instrumented. Rather, we should use __memcpy which
   by convention is not instrumented.

 * we also shouldn't be using __builtin_memcpy when we have a KASAN
   instrumented file, because it could be replaced with inline asm
   that will not be instrumented.

What is correct behaviour?
==========================

Firstly, there is some overlap between fortification and KASAN: both
provide some level of _runtime_ checking. Only fortify provides
compile-time checking.

KASAN and fortify can pick up different things at runtime:

 - Some fortify functions, notably the string functions, could easily be
   modified to consider sub-object sizes (e.g. members within a struct),
   and I have some WIP patches to do this. KASAN cannot detect these
   because it cannot insert poision between members of a struct.

 - KASAN can detect many over-reads/over-writes when the sizes of both
   operands are unknown, which fortify cannot.

So there are a couple of options:

 1) Flip the test: disable fortify in santised files and enable it in
    unsanitised files. This at least stops us missing KASAN checking, but
    we lose the fortify checking.

 2) Make the fortify code always call out to real versions. Do this only
    for KASAN, for fear of losing the inlining opportunities we get from
    __builtin_*.

(We can't use kasan_check_{read,write}: because the fortify functions are
_extern inline_, you can't include _static_ inline functions without a
compiler warning. kasan_check_{read,write} are static inline so we can't
use them even when they would otherwise be suitable.)

Take approach 2 and call out to real versions when KASAN is enabled.

Use __underlying_foo to distinguish from __real_foo: __real_foo always
refers to the kernel's implementation of foo, __underlying_foo could be
either the kernel implementation or the __builtin_foo implementation.

This is sometimes enough to make the memcmp test succeed with
FORTIFY_SOURCE enabled. It is at least enough to get the function call
into the module. One more fix is needed to make it reliable: see the next
patch.

Fixes: 6974f0c4555e ("include/linux/string.h: add the option of fortified string.h functions")
Signed-off-by: Daniel Axtens <dja@axtens.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: David Gow <davidgow@google.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Daniel Micay <danielmicay@gmail.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Link: http://lkml.kernel.org/r/20200423154503.5103-3-dja@axtens.net
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/string.h |   60 +++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 48 insertions(+), 12 deletions(-)

--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -238,6 +238,31 @@ void __read_overflow3(void) __compiletim
 void __write_overflow(void) __compiletime_error("detected write beyond size of object passed as 1st parameter");
 
 #if !defined(__NO_FORTIFY) && defined(__OPTIMIZE__) && defined(CONFIG_FORTIFY_SOURCE)
+
+#ifdef CONFIG_KASAN
+extern void *__underlying_memchr(const void *p, int c, __kernel_size_t size) __RENAME(memchr);
+extern int __underlying_memcmp(const void *p, const void *q, __kernel_size_t size) __RENAME(memcmp);
+extern void *__underlying_memcpy(void *p, const void *q, __kernel_size_t size) __RENAME(memcpy);
+extern void *__underlying_memmove(void *p, const void *q, __kernel_size_t size) __RENAME(memmove);
+extern void *__underlying_memset(void *p, int c, __kernel_size_t size) __RENAME(memset);
+extern char *__underlying_strcat(char *p, const char *q) __RENAME(strcat);
+extern char *__underlying_strcpy(char *p, const char *q) __RENAME(strcpy);
+extern __kernel_size_t __underlying_strlen(const char *p) __RENAME(strlen);
+extern char *__underlying_strncat(char *p, const char *q, __kernel_size_t count) __RENAME(strncat);
+extern char *__underlying_strncpy(char *p, const char *q, __kernel_size_t size) __RENAME(strncpy);
+#else
+#define __underlying_memchr	__builtin_memchr
+#define __underlying_memcmp	__builtin_memcmp
+#define __underlying_memcpy	__builtin_memcpy
+#define __underlying_memmove	__builtin_memmove
+#define __underlying_memset	__builtin_memset
+#define __underlying_strcat	__builtin_strcat
+#define __underlying_strcpy	__builtin_strcpy
+#define __underlying_strlen	__builtin_strlen
+#define __underlying_strncat	__builtin_strncat
+#define __underlying_strncpy	__builtin_strncpy
+#endif
+
 __FORTIFY_INLINE char *strncpy(char *p, const char *q, __kernel_size_t size)
 {
 	size_t p_size = __builtin_object_size(p, 0);
@@ -245,14 +270,14 @@ __FORTIFY_INLINE char *strncpy(char *p,
 		__write_overflow();
 	if (p_size < size)
 		fortify_panic(__func__);
-	return __builtin_strncpy(p, q, size);
+	return __underlying_strncpy(p, q, size);
 }
 
 __FORTIFY_INLINE char *strcat(char *p, const char *q)
 {
 	size_t p_size = __builtin_object_size(p, 0);
 	if (p_size == (size_t)-1)
-		return __builtin_strcat(p, q);
+		return __underlying_strcat(p, q);
 	if (strlcat(p, q, p_size) >= p_size)
 		fortify_panic(__func__);
 	return p;
@@ -266,7 +291,7 @@ __FORTIFY_INLINE __kernel_size_t strlen(
 	/* Work around gcc excess stack consumption issue */
 	if (p_size == (size_t)-1 ||
 	    (__builtin_constant_p(p[p_size - 1]) && p[p_size - 1] == '\0'))
-		return __builtin_strlen(p);
+		return __underlying_strlen(p);
 	ret = strnlen(p, p_size);
 	if (p_size <= ret)
 		fortify_panic(__func__);
@@ -299,7 +324,7 @@ __FORTIFY_INLINE size_t strlcpy(char *p,
 			__write_overflow();
 		if (len >= p_size)
 			fortify_panic(__func__);
-		__builtin_memcpy(p, q, len);
+		__underlying_memcpy(p, q, len);
 		p[len] = '\0';
 	}
 	return ret;
@@ -312,12 +337,12 @@ __FORTIFY_INLINE char *strncat(char *p,
 	size_t p_size = __builtin_object_size(p, 0);
 	size_t q_size = __builtin_object_size(q, 0);
 	if (p_size == (size_t)-1 && q_size == (size_t)-1)
-		return __builtin_strncat(p, q, count);
+		return __underlying_strncat(p, q, count);
 	p_len = strlen(p);
 	copy_len = strnlen(q, count);
 	if (p_size < p_len + copy_len + 1)
 		fortify_panic(__func__);
-	__builtin_memcpy(p + p_len, q, copy_len);
+	__underlying_memcpy(p + p_len, q, copy_len);
 	p[p_len + copy_len] = '\0';
 	return p;
 }
@@ -329,7 +354,7 @@ __FORTIFY_INLINE void *memset(void *p, i
 		__write_overflow();
 	if (p_size < size)
 		fortify_panic(__func__);
-	return __builtin_memset(p, c, size);
+	return __underlying_memset(p, c, size);
 }
 
 __FORTIFY_INLINE void *memcpy(void *p, const void *q, __kernel_size_t size)
@@ -344,7 +369,7 @@ __FORTIFY_INLINE void *memcpy(void *p, c
 	}
 	if (p_size < size || q_size < size)
 		fortify_panic(__func__);
-	return __builtin_memcpy(p, q, size);
+	return __underlying_memcpy(p, q, size);
 }
 
 __FORTIFY_INLINE void *memmove(void *p, const void *q, __kernel_size_t size)
@@ -359,7 +384,7 @@ __FORTIFY_INLINE void *memmove(void *p,
 	}
 	if (p_size < size || q_size < size)
 		fortify_panic(__func__);
-	return __builtin_memmove(p, q, size);
+	return __underlying_memmove(p, q, size);
 }
 
 extern void *__real_memscan(void *, int, __kernel_size_t) __RENAME(memscan);
@@ -385,7 +410,7 @@ __FORTIFY_INLINE int memcmp(const void *
 	}
 	if (p_size < size || q_size < size)
 		fortify_panic(__func__);
-	return __builtin_memcmp(p, q, size);
+	return __underlying_memcmp(p, q, size);
 }
 
 __FORTIFY_INLINE void *memchr(const void *p, int c, __kernel_size_t size)
@@ -395,7 +420,7 @@ __FORTIFY_INLINE void *memchr(const void
 		__read_overflow();
 	if (p_size < size)
 		fortify_panic(__func__);
-	return __builtin_memchr(p, c, size);
+	return __underlying_memchr(p, c, size);
 }
 
 void *__real_memchr_inv(const void *s, int c, size_t n) __RENAME(memchr_inv);
@@ -426,11 +451,22 @@ __FORTIFY_INLINE char *strcpy(char *p, c
 	size_t p_size = __builtin_object_size(p, 0);
 	size_t q_size = __builtin_object_size(q, 0);
 	if (p_size == (size_t)-1 && q_size == (size_t)-1)
-		return __builtin_strcpy(p, q);
+		return __underlying_strcpy(p, q);
 	memcpy(p, q, strlen(q) + 1);
 	return p;
 }
 
+/* Don't use these outside the FORITFY_SOURCE implementation */
+#undef __underlying_memchr
+#undef __underlying_memcmp
+#undef __underlying_memcpy
+#undef __underlying_memmove
+#undef __underlying_memset
+#undef __underlying_strcat
+#undef __underlying_strcpy
+#undef __underlying_strlen
+#undef __underlying_strncat
+#undef __underlying_strncpy
 #endif
 
 /**


