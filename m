Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9FA487D3C
	for <lists+stable@lfdr.de>; Fri,  7 Jan 2022 20:44:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbiAGTn7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jan 2022 14:43:59 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54794 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233284AbiAGTn7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jan 2022 14:43:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2BE48B82769
        for <stable@vger.kernel.org>; Fri,  7 Jan 2022 19:43:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB022C36AF4;
        Fri,  7 Jan 2022 19:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641584636;
        bh=3/20dWOwwSNZJBhLqL6LA9DAw+PK6AmauF9/RAJDr8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kJIvwmZqos7K7pa1InpJaYEK4SDmiJmjsPxdzESJqAZawqFXeZp/R0CVGKQuqoo+e
         HL0eVs9g/5Ff2dqjjwcqirUvEXHqBZ265xFbpqde7EaGON/X2jfTDHJD/+MMxEp/mb
         SCOYJjOIrT0PhafvgGYz2Igie681WIg0MHSGOt+34o2sbB9MdpaXskCFJbKYKkGMwt
         onAiUQNC2HrzjrKWGFynz6b70h7+kTPayinYNm5w/etkS58a07dQjS5D/PtdL0eSVA
         w9oVc3XgZt2W0lJV2JWt0tl9BMz9mPqbiUBiA9QF0m1lNFsAZNbWktK+J1Ku6Rh4Gn
         FXrtpPegg1hag==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
Cc:     Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        llvm@lists.linux.dev
Subject: [PATCH RFC 4.9 1/5] bug: split BUILD_BUG stuff out into <linux/build_bug.h>
Date:   Fri,  7 Jan 2022 12:43:31 -0700
Message-Id: <20220107194335.3090066-2-nathan@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220107194335.3090066-1-nathan@kernel.org>
References: <20220107194335.3090066-1-nathan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ian Abbott <abbotti@mev.co.uk>

commit bc6245e5efd70c41eaf9334b1b5e646745cb0fb3 upstream.

Including <linux/bug.h> pulls in a lot of bloat from <asm/bug.h> and
<asm-generic/bug.h> that is not needed to call the BUILD_BUG() family of
macros.  Split them out into their own header, <linux/build_bug.h>.

Also correct some checkpatch.pl errors for the BUILD_BUG_ON_ZERO() and
BUILD_BUG_ON_NULL() macros by adding parentheses around the bitfield
widths that begin with a minus sign.

Link: http://lkml.kernel.org/r/20170525120316.24473-6-abbotti@mev.co.uk
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jakub Kicinski <jakub.kicinski@netronome.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[nathan: Just take this patch, not the checkpatch.pl patches before it]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 include/linux/bug.h       | 72 +--------------------------------
 include/linux/build_bug.h | 84 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 85 insertions(+), 71 deletions(-)
 create mode 100644 include/linux/build_bug.h

diff --git a/include/linux/bug.h b/include/linux/bug.h
index 0faae96302bd..eafb6213e582 100644
--- a/include/linux/bug.h
+++ b/include/linux/bug.h
@@ -3,6 +3,7 @@
 
 #include <asm/bug.h>
 #include <linux/compiler.h>
+#include <linux/build_bug.h>
 
 enum bug_trap_type {
 	BUG_TRAP_TYPE_NONE = 0,
@@ -13,80 +14,9 @@ enum bug_trap_type {
 struct pt_regs;
 
 #ifdef __CHECKER__
-#define __BUILD_BUG_ON_NOT_POWER_OF_2(n) (0)
-#define BUILD_BUG_ON_NOT_POWER_OF_2(n) (0)
-#define BUILD_BUG_ON_ZERO(e) (0)
-#define BUILD_BUG_ON_NULL(e) ((void*)0)
-#define BUILD_BUG_ON_INVALID(e) (0)
-#define BUILD_BUG_ON_MSG(cond, msg) (0)
-#define BUILD_BUG_ON(condition) (0)
-#define BUILD_BUG() (0)
 #define MAYBE_BUILD_BUG_ON(cond) (0)
 #else /* __CHECKER__ */
 
-/* Force a compilation error if a constant expression is not a power of 2 */
-#define __BUILD_BUG_ON_NOT_POWER_OF_2(n)	\
-	BUILD_BUG_ON(((n) & ((n) - 1)) != 0)
-#define BUILD_BUG_ON_NOT_POWER_OF_2(n)			\
-	BUILD_BUG_ON((n) == 0 || (((n) & ((n) - 1)) != 0))
-
-/* Force a compilation error if condition is true, but also produce a
-   result (of value 0 and type size_t), so the expression can be used
-   e.g. in a structure initializer (or where-ever else comma expressions
-   aren't permitted). */
-#define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:-!!(e); }))
-#define BUILD_BUG_ON_NULL(e) ((void *)sizeof(struct { int:-!!(e); }))
-
-/*
- * BUILD_BUG_ON_INVALID() permits the compiler to check the validity of the
- * expression but avoids the generation of any code, even if that expression
- * has side-effects.
- */
-#define BUILD_BUG_ON_INVALID(e) ((void)(sizeof((__force long)(e))))
-
-/**
- * BUILD_BUG_ON_MSG - break compile if a condition is true & emit supplied
- *		      error message.
- * @condition: the condition which the compiler should know is false.
- *
- * See BUILD_BUG_ON for description.
- */
-#define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
-
-/**
- * BUILD_BUG_ON - break compile if a condition is true.
- * @condition: the condition which the compiler should know is false.
- *
- * If you have some code which relies on certain constants being equal, or
- * some other compile-time-evaluated condition, you should use BUILD_BUG_ON to
- * detect if someone changes it.
- *
- * The implementation uses gcc's reluctance to create a negative array, but gcc
- * (as of 4.4) only emits that error for obvious cases (e.g. not arguments to
- * inline functions).  Luckily, in 4.3 they added the "error" function
- * attribute just for this type of case.  Thus, we use a negative sized array
- * (should always create an error on gcc versions older than 4.4) and then call
- * an undefined function with the error attribute (should always create an
- * error on gcc 4.3 and later).  If for some reason, neither creates a
- * compile-time error, we'll still have a link-time error, which is harder to
- * track down.
- */
-#ifndef __OPTIMIZE__
-#define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
-#else
-#define BUILD_BUG_ON(condition) \
-	BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
-#endif
-
-/**
- * BUILD_BUG - break compile if used.
- *
- * If you have some code that you expect the compiler to eliminate at
- * build time, you should use BUILD_BUG to detect if it is
- * unexpectedly used.
- */
-#define BUILD_BUG() BUILD_BUG_ON_MSG(1, "BUILD_BUG failed")
-
 #define MAYBE_BUILD_BUG_ON(cond)			\
 	do {						\
 		if (__builtin_constant_p((cond)))       \
diff --git a/include/linux/build_bug.h b/include/linux/build_bug.h
new file mode 100644
index 000000000000..b7d22d60008a
--- /dev/null
+++ b/include/linux/build_bug.h
@@ -0,0 +1,84 @@
+#ifndef _LINUX_BUILD_BUG_H
+#define _LINUX_BUILD_BUG_H
+
+#include <linux/compiler.h>
+
+#ifdef __CHECKER__
+#define __BUILD_BUG_ON_NOT_POWER_OF_2(n) (0)
+#define BUILD_BUG_ON_NOT_POWER_OF_2(n) (0)
+#define BUILD_BUG_ON_ZERO(e) (0)
+#define BUILD_BUG_ON_NULL(e) ((void *)0)
+#define BUILD_BUG_ON_INVALID(e) (0)
+#define BUILD_BUG_ON_MSG(cond, msg) (0)
+#define BUILD_BUG_ON(condition) (0)
+#define BUILD_BUG() (0)
+#else /* __CHECKER__ */
+
+/* Force a compilation error if a constant expression is not a power of 2 */
+#define __BUILD_BUG_ON_NOT_POWER_OF_2(n)	\
+	BUILD_BUG_ON(((n) & ((n) - 1)) != 0)
+#define BUILD_BUG_ON_NOT_POWER_OF_2(n)			\
+	BUILD_BUG_ON((n) == 0 || (((n) & ((n) - 1)) != 0))
+
+/*
+ * Force a compilation error if condition is true, but also produce a
+ * result (of value 0 and type size_t), so the expression can be used
+ * e.g. in a structure initializer (or where-ever else comma expressions
+ * aren't permitted).
+ */
+#define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:(-!!(e)); }))
+#define BUILD_BUG_ON_NULL(e) ((void *)sizeof(struct { int:(-!!(e)); }))
+
+/*
+ * BUILD_BUG_ON_INVALID() permits the compiler to check the validity of the
+ * expression but avoids the generation of any code, even if that expression
+ * has side-effects.
+ */
+#define BUILD_BUG_ON_INVALID(e) ((void)(sizeof((__force long)(e))))
+
+/**
+ * BUILD_BUG_ON_MSG - break compile if a condition is true & emit supplied
+ *		      error message.
+ * @condition: the condition which the compiler should know is false.
+ *
+ * See BUILD_BUG_ON for description.
+ */
+#define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
+
+/**
+ * BUILD_BUG_ON - break compile if a condition is true.
+ * @condition: the condition which the compiler should know is false.
+ *
+ * If you have some code which relies on certain constants being equal, or
+ * some other compile-time-evaluated condition, you should use BUILD_BUG_ON to
+ * detect if someone changes it.
+ *
+ * The implementation uses gcc's reluctance to create a negative array, but gcc
+ * (as of 4.4) only emits that error for obvious cases (e.g. not arguments to
+ * inline functions).  Luckily, in 4.3 they added the "error" function
+ * attribute just for this type of case.  Thus, we use a negative sized array
+ * (should always create an error on gcc versions older than 4.4) and then call
+ * an undefined function with the error attribute (should always create an
+ * error on gcc 4.3 and later).  If for some reason, neither creates a
+ * compile-time error, we'll still have a link-time error, which is harder to
+ * track down.
+ */
+#ifndef __OPTIMIZE__
+#define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
+#else
+#define BUILD_BUG_ON(condition) \
+	BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
+#endif
+
+/**
+ * BUILD_BUG - break compile if used.
+ *
+ * If you have some code that you expect the compiler to eliminate at
+ * build time, you should use BUILD_BUG to detect if it is
+ * unexpectedly used.
+ */
+#define BUILD_BUG() BUILD_BUG_ON_MSG(1, "BUILD_BUG failed")
+
+#endif	/* __CHECKER__ */
+
+#endif	/* _LINUX_BUILD_BUG_H */
-- 
2.34.1

