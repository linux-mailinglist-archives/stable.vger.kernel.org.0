Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4AE32B2BD0
	for <lists+stable@lfdr.de>; Sat, 14 Nov 2020 07:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbgKNGwC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Nov 2020 01:52:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:33428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726133AbgKNGwC (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 14 Nov 2020 01:52:02 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F344E20678;
        Sat, 14 Nov 2020 06:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605336720;
        bh=qmjfXYAslhbsSl13sr02U8QmhYHr5Cf269tigyGuZG0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=hUpx/YfG9LBQZWvetbJzWZc2MM/xa2U/xEwQFDYi1dnHecc9BQOiVEg9BG/ehbcBY
         exd7HUj2O5JTFBWlVl6jzQ9hJopwSzUx3Bd5WEH7CEp+SRj2xphIpTW0mmwdKyXjvM
         qwpCidDt2cQff9exAeMYvRDCsKljnq539sb4RUaY=
Date:   Fri, 13 Nov 2020 22:51:59 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, keescook@chromium.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        ndesaulniers@google.com, nivedita@alum.mit.edu,
        rdunlap@infradead.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 07/14] compiler.h: fix barrier_data() on clang
Message-ID: <20201114065159.-598Aj1dJ%akpm@linux-foundation.org>
In-Reply-To: <20201113225115.b24faebc85f710d5aff55aa7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arvind Sankar <nivedita@alum.mit.edu>
Subject: compiler.h: fix barrier_data() on clang

Commit 815f0ddb346c ("include/linux/compiler*.h: make compiler-*.h
mutually exclusive") neglected to copy barrier_data() from compiler-gcc.h
into compiler-clang.h.  The definition in compiler-gcc.h was really to
work around clang's more aggressive optimization, so this broke
barrier_data() on clang, and consequently memzero_explicit() as well.

For example, this results in at least the memzero_explicit() call in
lib/crypto/sha256.c:sha256_transform() being optimized away by clang.

Fix this by moving the definition of barrier_data() into compiler.h.

Also move the gcc/clang definition of barrier() into compiler.h,
__memory_barrier() is icc-specific (and barrier() is already defined using
it in compiler-intel.h) and doesn't belong in compiler.h.

[rdunlap@infradead.org: fix ALPHA builds when SMP is not enabled]
  Link: https://lkml.kernel.org/r/20201101231835.4589-1-rdunlap@infradead.org
Link: https://lkml.kernel.org/r/20201014212631.207844-1-nivedita@alum.mit.edu
Fixes: 815f0ddb346c ("include/linux/compiler*.h: make compiler-*.h mutually exclusive")
Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/barrier.h  |    1 +
 include/linux/compiler-clang.h |    6 ------
 include/linux/compiler-gcc.h   |   19 -------------------
 include/linux/compiler.h       |   18 ++++++++++++++++--
 4 files changed, 17 insertions(+), 27 deletions(-)

--- a/include/asm-generic/barrier.h~compilerh-fix-barrier_data-on-clang
+++ a/include/asm-generic/barrier.h
@@ -13,6 +13,7 @@
 
 #ifndef __ASSEMBLY__
 
+#include <linux/compiler.h>
 #include <asm/rwonce.h>
 
 #ifndef nop
--- a/include/linux/compiler-clang.h~compilerh-fix-barrier_data-on-clang
+++ a/include/linux/compiler-clang.h
@@ -60,12 +60,6 @@
 #define COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW 1
 #endif
 
-/* The following are for compatibility with GCC, from compiler-gcc.h,
- * and may be redefined here because they should not be shared with other
- * compilers, like ICC.
- */
-#define barrier() __asm__ __volatile__("" : : : "memory")
-
 #if __has_feature(shadow_call_stack)
 # define __noscs	__attribute__((__no_sanitize__("shadow-call-stack")))
 #endif
--- a/include/linux/compiler-gcc.h~compilerh-fix-barrier_data-on-clang
+++ a/include/linux/compiler-gcc.h
@@ -15,25 +15,6 @@
 # error Sorry, your version of GCC is too old - please use 4.9 or newer.
 #endif
 
-/* Optimization barrier */
-
-/* The "volatile" is due to gcc bugs */
-#define barrier() __asm__ __volatile__("": : :"memory")
-/*
- * This version is i.e. to prevent dead stores elimination on @ptr
- * where gcc and llvm may behave differently when otherwise using
- * normal barrier(): while gcc behavior gets along with a normal
- * barrier(), llvm needs an explicit input variable to be assumed
- * clobbered. The issue is as follows: while the inline asm might
- * access any memory it wants, the compiler could have fit all of
- * @ptr into memory registers instead, and since @ptr never escaped
- * from that, it proved that the inline asm wasn't touching any of
- * it. This version works well with both compilers, i.e. we're telling
- * the compiler that the inline asm absolutely may see the contents
- * of @ptr. See also: https://llvm.org/bugs/show_bug.cgi?id=15495
- */
-#define barrier_data(ptr) __asm__ __volatile__("": :"r"(ptr) :"memory")
-
 /*
  * This macro obfuscates arithmetic on a variable address so that gcc
  * shouldn't recognize the original var, and make assumptions about it.
--- a/include/linux/compiler.h~compilerh-fix-barrier_data-on-clang
+++ a/include/linux/compiler.h
@@ -80,11 +80,25 @@ void ftrace_likely_update(struct ftrace_
 
 /* Optimization barrier */
 #ifndef barrier
-# define barrier() __memory_barrier()
+/* The "volatile" is due to gcc bugs */
+# define barrier() __asm__ __volatile__("": : :"memory")
 #endif
 
 #ifndef barrier_data
-# define barrier_data(ptr) barrier()
+/*
+ * This version is i.e. to prevent dead stores elimination on @ptr
+ * where gcc and llvm may behave differently when otherwise using
+ * normal barrier(): while gcc behavior gets along with a normal
+ * barrier(), llvm needs an explicit input variable to be assumed
+ * clobbered. The issue is as follows: while the inline asm might
+ * access any memory it wants, the compiler could have fit all of
+ * @ptr into memory registers instead, and since @ptr never escaped
+ * from that, it proved that the inline asm wasn't touching any of
+ * it. This version works well with both compilers, i.e. we're telling
+ * the compiler that the inline asm absolutely may see the contents
+ * of @ptr. See also: https://llvm.org/bugs/show_bug.cgi?id=15495
+ */
+# define barrier_data(ptr) __asm__ __volatile__("": :"r"(ptr) :"memory")
 #endif
 
 /* workaround for GCC PR82365 if needed */
_
