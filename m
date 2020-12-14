Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0073F2DA030
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 20:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502656AbgLNTHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 14:07:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:46970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502199AbgLNRgz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:36:55 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arvind Sankar <nivedita@alum.mit.edu>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 36/36] compiler.h: fix barrier_data() on clang
Date:   Mon, 14 Dec 2020 18:28:20 +0100
Message-Id: <20201214172545.086134351@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214172543.302523401@linuxfoundation.org>
References: <20201214172543.302523401@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arvind Sankar <nivedita@alum.mit.edu>

commit 3347acc6fcd4ee71ad18a9ff9d9dac176b517329 upstream.

Commit 815f0ddb346c ("include/linux/compiler*.h: make compiler-*.h
mutually exclusive") neglected to copy barrier_data() from
compiler-gcc.h into compiler-clang.h.

The definition in compiler-gcc.h was really to work around clang's more
aggressive optimization, so this broke barrier_data() on clang, and
consequently memzero_explicit() as well.

For example, this results in at least the memzero_explicit() call in
lib/crypto/sha256.c:sha256_transform() being optimized away by clang.

Fix this by moving the definition of barrier_data() into compiler.h.

Also move the gcc/clang definition of barrier() into compiler.h,
__memory_barrier() is icc-specific (and barrier() is already defined
using it in compiler-intel.h) and doesn't belong in compiler.h.

[rdunlap@infradead.org: fix ALPHA builds when SMP is not enabled]

Link: https://lkml.kernel.org/r/20201101231835.4589-1-rdunlap@infradead.org
Fixes: 815f0ddb346c ("include/linux/compiler*.h: make compiler-*.h mutually exclusive")
Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20201014212631.207844-1-nivedita@alum.mit.edu
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[nd: backport to account for missing
  commit e506ea451254a ("compiler.h: Split {READ,WRITE}_ONCE definitions out into rwonce.h")
  commit d08b9f0ca6605 ("scs: Add support for Clang's Shadow Call Stack (SCS)")]
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/compiler-clang.h |    6 ------
 include/linux/compiler-gcc.h   |   19 -------------------
 include/linux/compiler.h       |   18 ++++++++++++++++--
 3 files changed, 16 insertions(+), 27 deletions(-)

--- a/include/linux/compiler-clang.h
+++ b/include/linux/compiler-clang.h
@@ -36,9 +36,3 @@
     __has_builtin(__builtin_sub_overflow)
 #define COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW 1
 #endif
-
-/* The following are for compatibility with GCC, from compiler-gcc.h,
- * and may be redefined here because they should not be shared with other
- * compilers, like ICC.
- */
-#define barrier() __asm__ __volatile__("" : : : "memory")
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -14,25 +14,6 @@
 # error Sorry, your compiler is too old - please upgrade it.
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
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
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


