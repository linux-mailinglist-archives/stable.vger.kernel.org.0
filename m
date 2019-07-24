Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 198CC73C78
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392384AbfGXUJR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:09:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:49234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404932AbfGXUAx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 16:00:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36B30205C9;
        Wed, 24 Jul 2019 20:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998452;
        bh=GxwN1mmkCycNO3fHNV+ZrdYXA6d6xmqH0Z4BO14KspE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tUP2sQSfY6PbRFU0hoGEWTxM2JRLfDV+9OhFHI+mw31+yzd59HtWCjMVgBlysPAYH
         OLBlOTPLRw0o4rkS6xzzC5CB+7POtBR4sXTpFp2lJ20+CsT089XOfi7xd6KtjUrFJ4
         1E3fWHun/Do2FV+IVH4wLkxTy4294/3Iha3mH6WE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Drew Davenport <ddavenport@chromium.org>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.1 343/371] include/asm-generic/bug.h: fix "cut here" for WARN_ON for __WARN_TAINT architectures
Date:   Wed, 24 Jul 2019 21:21:35 +0200
Message-Id: <20190724191749.483685257@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Drew Davenport <ddavenport@chromium.org>

commit 6b15f678fb7d5ef54e089e6ace72f007fe6e9895 upstream.

For architectures using __WARN_TAINT, the WARN_ON macro did not print
out the "cut here" string.  The other WARN_XXX macros would print "cut
here" inside __warn_printk, which is not called for WARN_ON since it
doesn't have a message to print.

Link: http://lkml.kernel.org/r/20190624154831.163888-1-ddavenport@chromium.org
Fixes: a7bed27af194 ("bug: fix "cut here" location for __WARN_TAINT architectures")
Signed-off-by: Drew Davenport <ddavenport@chromium.org>
Acked-by: Kees Cook <keescook@chromium.org>
Tested-by: Kees Cook <keescook@chromium.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/asm-generic/bug.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
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


