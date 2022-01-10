Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61E194890E3
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:28:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239736AbiAJH0i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:26:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239408AbiAJHZd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:25:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4966BC06118C;
        Sun,  9 Jan 2022 23:24:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E68C7B81202;
        Mon, 10 Jan 2022 07:24:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CECAAC36AE9;
        Mon, 10 Jan 2022 07:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799489;
        bh=s7rnVr5OME000+dtzOD1eD/jS3lCf4zVfsB22ELGaOE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f5griIuruvzbymli3YEFbUkNnRwj31gvutQ08hFHs8KG7BoEbmZgQ+pg7B9byWbAL
         xQJBdKuRA5zibVJ8xMXxqyb6tmSkuHyZ34KaK9k7k9uXbyXepdIpwCDfX3xCqY5rtO
         N4xDLhtophZ/hBM0oxxyvsrWWFjJOychlSlxIUag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Abbott <abbotti@mev.co.uk>,
        Michal Nazarewicz <mina86@mina86.com>,
        Kees Cook <keescook@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 4.9 11/21] bug: split BUILD_BUG stuff out into <linux/build_bug.h>
Date:   Mon, 10 Jan 2022 08:22:58 +0100
Message-Id: <20220110071813.184161884@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071812.806606886@linuxfoundation.org>
References: <20220110071812.806606886@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/bug.h       |   72 ---------------------------------------
 include/linux/build_bug.h |   84 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 85 insertions(+), 71 deletions(-)
 create mode 100644 include/linux/build_bug.h

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


