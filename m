Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38018233A0A
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 22:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730130AbgG3Uvb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 16:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729166AbgG3Uva (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jul 2020 16:51:30 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D52DCC061574
        for <stable@vger.kernel.org>; Thu, 30 Jul 2020 13:51:30 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id ei10so7056856pjb.2
        for <stable@vger.kernel.org>; Thu, 30 Jul 2020 13:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=U0OUPTDRNGhh0ydoN6VkhJdiruQZ6OtwNxR4N39C4f8=;
        b=bS33mlwdf/DJIQD28epPbEI7pJZXa1xHzvIjvbrwJsYvNRprRL04EmCMO8BY7c7vyR
         ofLXj+EecJitrlsOgIRSeYox7Ze/fCWlAwsLoJGJXNxJhm1Jzit1E25lLOIc4Zq4SNtH
         vDVgxSSFKjr6Dev1jNeB+/y6/4/TPRX9evR1RJBCof4kAi7IzZUb1z4wOFHcPt1MDXS1
         UMmiVxWsDAo7fDiJWj5rZyAePJEpkaW+/xc4T//YX/DRcxFqZMlHsEZewHwkWf3ZE5Bn
         pEZzlVLo2QFc9P0WbNbGGnsimIfk/QgsbAfVHpxvfHt3Lp7csq8m7P0gUJ1850oZa06/
         oWcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=U0OUPTDRNGhh0ydoN6VkhJdiruQZ6OtwNxR4N39C4f8=;
        b=QdLzRUTaGhF17z1Nwubx2DU2DaIx2PNQmjhpEJBQdUFw60Jis1rbHUq94FyEqOM8Oa
         Nu99vePA5IO2A3oAqGUreU3c5BgdxkWI4ycWrXjYQ/XMCWriVizvyTJcHG9+DswBS1tW
         KCzJmNVqMLBiAR99Bcx1FN01Rx88z69nerG4tBDvPs9ipfp2SatqMsCHzfFLdq+XYZrv
         DHwL9On02R5Yiky7lBnLFlalqw0KPvvh0LW25t3ILFd1u5aHwdJZReXv4I8E2US5kDuo
         Iqu6q7F/WTgU3L6P2vMYoDk5QZc5sNLR+VxaQoS0BZZUAiNJqWmWOqUmBewyQQhLxlCl
         Lz1w==
X-Gm-Message-State: AOAM532HH7y5Mr2tnwRmWgRAc/xm+xGdfitzUmQ9TO4fnmNUBPP+z7F1
        kDp8TPtXddrQDw9HqwLSbYJ0+HqUQub3k1YCV70=
X-Google-Smtp-Source: ABdhPJwCEyx+wmqrFUv640p8yJy8eY2sYOEIDXEj/DD5NDhOwWleNVqKa5yzVDKQryUe9mvaALl+3zlHBVcQT43pRDg=
X-Received: by 2002:a17:90b:4d0b:: with SMTP id mw11mr923395pjb.4.1596142290243;
 Thu, 30 Jul 2020 13:51:30 -0700 (PDT)
Date:   Thu, 30 Jul 2020 13:51:10 -0700
In-Reply-To: <20200730205112.2099429-1-ndesaulniers@google.com>
Message-Id: <20200730205112.2099429-3-ndesaulniers@google.com>
Mime-Version: 1.0
References: <20200730205112.2099429-1-ndesaulniers@google.com>
X-Mailer: git-send-email 2.28.0.163.g6104cc2f0b6-goog
Subject: [PATCH 2/4] ARM: backtrace-clang: add fixup for lr dereference
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     Nathan Huckleberry <nhuck15@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        clang-built-linux@googlegroups.com,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        Lvqiang Huang <lvqiang.huang@unisoc.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Miles Chen <miles.chen@mediatek.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If the value of the link register is not correct (tail call from asm
that didn't set it, stack corruption, memory no longer mapped), then
using it for an address calculation may trigger an exception.  Without a
fixup handler, this will lead to a panic, which will unwind, which will
trigger the fault repeatedly in an infinite loop.

We don't observe such failures currently, but we have. Just to be safe,
add a fixup handler here so that at least we don't have an infinite
loop.

Cc: stable@vger.kernel.org
Fixes: commit 6dc5fd93b2f1 ("ARM: 8900/1: UNWINDER_FRAME_POINTER implementation for Clang")
Reported-by: Miles Chen <miles.chen@mediatek.com>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
---
 arch/arm/lib/backtrace-clang.S | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm/lib/backtrace-clang.S b/arch/arm/lib/backtrace-clang.S
index 5388ac664c12..40eb2215eaf4 100644
--- a/arch/arm/lib/backtrace-clang.S
+++ b/arch/arm/lib/backtrace-clang.S
@@ -146,7 +146,7 @@ for_each_frame:	tst	frame, mask		@ Check for address exceptions
 
 		tst	sv_lr, #0		@ If there's no previous lr,
 		beq	finished_setup		@ we're done.
-		ldr	r0, [sv_lr, #-4]	@ get call instruction
+prev_call:	ldr	r0, [sv_lr, #-4]	@ get call instruction
 		ldr	r3, .Lopcode+4
 		and	r2, r3, r0		@ is this a bl call
 		teq	r2, r3
@@ -206,6 +206,13 @@ finished_setup:
 		mov	r2, frame
 		bl	printk
 no_frame:	ldmfd	sp!, {r4 - r9, fp, pc}
+/*
+ * Accessing the address pointed to by the link register triggered an
+ * exception, don't try to unwind through it.
+ */
+bad_lr:		mov	sv_fp, #0
+		mov	sv_lr, #0
+		b	finished_setup
 ENDPROC(c_backtrace)
 		.pushsection __ex_table,"a"
 		.align	3
@@ -214,6 +221,7 @@ ENDPROC(c_backtrace)
 		.long	1003b, 1006b
 		.long	1004b, 1006b
 		.long   1005b, 1006b
+		.long	prev_call, bad_lr
 		.popsection
 
 .Lbad:		.asciz	"%sBacktrace aborted due to bad frame pointer <%p>\n"
-- 
2.28.0.163.g6104cc2f0b6-goog

