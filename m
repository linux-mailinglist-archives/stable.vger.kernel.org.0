Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D170151C9B
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 22:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731382AbfFXUw7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 16:52:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:59562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729160AbfFXUw7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 16:52:59 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD6F920656;
        Mon, 24 Jun 2019 20:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561409578;
        bh=o19eShi1knbmT8O45mGE53p0LYuy/aHppkIalsxT6Ug=;
        h=Date:From:To:Subject:From;
        b=JQ4cCfFhrxUcUveBRI/PJgptslH96+P2AcK7nzNqGt1WthcmFO6CYD20Ih8VRSV1L
         /phuWxpGQWt/1vIDR9BJsp1wgKqkcULSPhax/NzYXwRM/1tJ8VkRC9NKK/YcblyY/P
         6WM6GIo0gk15mNSm3sQXmj+2ToOYoelzQ9cX26XE=
Date:   Mon, 24 Jun 2019 13:52:58 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        keescook@chromium.org, ddavenport@chromium.org
Subject:  +
 bug-fix-cut-here-for-warn_on-for-__warn_taint-architectures.patch added to
 -mm tree
Message-ID: <20190624205258.48saV%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: include/asm-generic/bug.h: fix "cut here" for WARN_ON for __WARN_TAINT architectures
has been added to the -mm tree.  Its filename is
     bug-fix-cut-here-for-warn_on-for-__warn_taint-architectures.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/bug-fix-cut-here-for-warn_on-for-__warn_taint-architectures.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/bug-fix-cut-here-for-warn_on-for-__warn_taint-architectures.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from ddavenport@chromium.org are

bug-fix-cut-here-for-warn_on-for-__warn_taint-architectures.patch

