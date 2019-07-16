Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E69496B25F
	for <lists+stable@lfdr.de>; Wed, 17 Jul 2019 01:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389054AbfGPXaT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jul 2019 19:30:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:51878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728235AbfGPXaT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jul 2019 19:30:19 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7456218A4;
        Tue, 16 Jul 2019 23:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563319819;
        bh=ojLw1nPS1zCSwclhSePwEnHSaWvBnWy4hx3P3xxmgcw=;
        h=Date:From:To:Subject:From;
        b=HJnIfhG9YTvCBT9ww9WxgEP7W+KLANc4B3hjDFiIrg/ixEFFchpsKIL5J77D5jAR/
         K22p0eKqmrlhdcU90xBLj0bFKdLVo+ofsuiOp7uJusqOITLKM1d557rYkNX5miXcey
         p/xZe74GISIBKZOTurwNTRwy+N2CtSAuBQIwqL6U=
Date:   Tue, 16 Jul 2019 16:30:18 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, ddavenport@chromium.org,
        keescook@chromium.org, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 088/100] include/asm-generic/bug.h: fix "cut here"
 for WARN_ON for __WARN_TAINT architectures
Message-ID: <20190716233018.UQwhCsJUA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Drew Davenport <ddavenport@chromium.org>
Subject: include/asm-generic/bug.h: fix "cut here" for WARN_ON for __WARN_TAINT architectures

For architectures using __WARN_TAINT, the WARN_ON macro did not print out
the "cut here" string.  The other WARN_XXX macros would print "cut here"
inside __warn_printk, which is not called for WARN_ON since it doesn't
have a message to print.

Link: http://lkml.kernel.org/r/20190624154831.163888-1-ddavenport@chromium.org
Fixes: a7bed27af194 ("bug: fix "cut here" location for __WARN_TAINT architectures")
Signed-off-by: Drew Davenport <ddavenport@chromium.org>
Acked-by: Kees Cook <keescook@chromium.org>
Tested-by: Kees Cook <keescook@chromium.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/bug.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/include/asm-generic/bug.h~bug-fix-cut-here-for-warn_on-for-__warn_taint-architectures
+++ a/include/asm-generic/bug.h
@@ -104,8 +104,10 @@ extern void warn_slowpath_null(const cha
 	warn_slowpath_fmt_taint(__FILE__, __LINE__, taint, arg)
 #else
 extern __printf(1, 2) void __warn_printk(const char *fmt, ...);
-#define __WARN()		__WARN_TAINT(TAINT_WARN)
-#define __WARN_printf(arg...)	do { __warn_printk(arg); __WARN(); } while (0)
+#define __WARN() do { \
+	printk(KERN_WARNING CUT_HERE); __WARN_TAINT(TAINT_WARN); \
+} while (0)
+#define __WARN_printf(arg...)	__WARN_printf_taint(TAINT_WARN, arg)
 #define __WARN_printf_taint(taint, arg...)				\
 	do { __warn_printk(arg); __WARN_TAINT(taint); } while (0)
 #endif
_
