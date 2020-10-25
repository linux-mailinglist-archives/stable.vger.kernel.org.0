Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31BB9298331
	for <lists+stable@lfdr.de>; Sun, 25 Oct 2020 19:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1418294AbgJYSuv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Oct 2020 14:50:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:52224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1418246AbgJYSuu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 25 Oct 2020 14:50:50 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA05C22260;
        Sun, 25 Oct 2020 18:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603651850;
        bh=f/wO+AUYFC4kWLBfNADwMDd1EKzdj9VspjJ/5qwp8mA=;
        h=Date:From:To:Subject:From;
        b=GDLnLGCnvMpRiD0srZ/bqpDbWNEUozklhLVEC5hXMyG5fgRuTbKG1D4BBZ3nsNVAB
         EdiqL14KcqrtbC1F6zc9U85yqphC8yNHg9aC2wUnpRKWQLVWDzOSgsZJtAkjtyRtpp
         RGVXJnLcEG6wHv7FmgiBJ6ibra0klXOlooRPj+uQ=
Date:   Sun, 25 Oct 2020 11:50:49 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        ndesaulniers@google.com, keescook@chromium.org,
        nivedita@alum.mit.edu
Subject:  + compilerh-fix-barrier_data-on-clang.patch added to -mm
 tree
Message-ID: <20201025185049.0Nu8X%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: compiler.h: fix barrier_data() on clang
has been added to the -mm tree.  Its filename is
     compilerh-fix-barrier_data-on-clang.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/compilerh-fix-barrier_data-on-clang.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/compilerh-fix-barrier_data-on-clang.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Link: https://lkml.kernel.org/r/20201014212631.207844-1-nivedita@alum.mit.edu
Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
Fixes: 815f0ddb346c ("include/linux/compiler*.h: make compiler-*.h mutually exclusive")
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-clang.h |    6 ------
 include/linux/compiler-gcc.h   |   19 -------------------
 include/linux/compiler.h       |   18 ++++++++++++++++--
 3 files changed, 16 insertions(+), 27 deletions(-)

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

Patches currently in -mm which might be from nivedita@alum.mit.edu are

compilerh-fix-barrier_data-on-clang.patch

