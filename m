Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33CFA450EF3
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:22:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236808AbhKOSWL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:22:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:60614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241331AbhKOST2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:19:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0D6A63404;
        Mon, 15 Nov 2021 17:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636998701;
        bh=QuAXkpeEU0m93Dao6LH4uF6Oe4k5AJBkcWeQkGczcL4=;
        h=Date:From:To:Subject:From;
        b=csUNuL0LfDXXK5ehJ1gqlYWrf1D+uEEdmoowXlhvihM+/7x57E8nD6Spj0kW9SZON
         dtR/whXNxv9xo/IOlc3pKAKlv+fFEz96zvOwXlp4vVffJyhjnAySuaPDrpHddzwCRs
         gC7fGtePpBbtIPp3QAvJtxqiSN5Z1YuPJz0uXmDc=
Date:   Mon, 15 Nov 2021 09:51:40 -0800
From:   akpm@linux-foundation.org
To:     bcain@codeaurora.org, mm-commits@vger.kernel.org,
        nathan@kernel.org, ndesaulniers@google.com, stable@vger.kernel.org
Subject:  + hexagon-clean-up-timer-regsh.patch added to -mm tree
Message-ID: <20211115175140.G-zskVVSq%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: hexagon: clean up timer-regs.h
has been added to the -mm tree.  Its filename is
     hexagon-clean-up-timer-regsh.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hexagon-clean-up-timer-regsh.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hexagon-clean-up-timer-regsh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: hexagon: clean up timer-regs.h

When building allmodconfig, there is a warning about TIMER_ENABLE being
redefined:

 drivers/clocksource/timer-oxnas-rps.c:39:9: error: 'TIMER_ENABLE' macro redefined [-Werror,-Wmacro-redefined]
 #define TIMER_ENABLE            BIT(7)
         ^
 ./arch/hexagon/include/asm/timer-regs.h:13:9: note: previous definition is here
 #define TIMER_ENABLE            0
         ^
 1 error generated.

The values in this header are only used in one file each, if they are
used at all. Remove the header and sink all of the constants into their
respective files.

TCX0_CLK_RATE is only used in arch/hexagon/include/asm/timex.h

TIMER_ENABLE, RTOS_TIMER_INT, RTOS_TIMER_REGS_ADDR are only used in
arch/hexagon/kernel/time.c.

SLEEP_CLK_RATE and TIMER_CLR_ON_MATCH have both been unused since the
file's introduction in commit 71e4a47f32f4 ("Hexagon: Add time and timer
functions").

TIMER_ENABLE is redefined as BIT(0) so the shift is moved into the
definition, rather than its use.

Link: https://lkml.kernel.org/r/20211115174250.1994179-3-nathan@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Brian Cain <bcain@codeaurora.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/hexagon/include/asm/timer-regs.h |   26 ------------------------
 arch/hexagon/include/asm/timex.h      |    3 --
 arch/hexagon/kernel/time.c            |   12 +++++++++--
 3 files changed, 11 insertions(+), 30 deletions(-)

--- a/arch/hexagon/include/asm/timer-regs.h
+++ /dev/null
@@ -1,26 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * Timer support for Hexagon
- *
- * Copyright (c) 2010-2011, The Linux Foundation. All rights reserved.
- */
-
-#ifndef _ASM_TIMER_REGS_H
-#define _ASM_TIMER_REGS_H
-
-/*  This stuff should go into a platform specific file  */
-#define TCX0_CLK_RATE		19200
-#define TIMER_ENABLE		0
-#define TIMER_CLR_ON_MATCH	1
-
-/*
- * 8x50 HDD Specs 5-8.  Simulator co-sim not fixed until
- * release 1.1, and then it's "adjustable" and probably not defaulted.
- */
-#define RTOS_TIMER_INT		3
-#ifdef CONFIG_HEXAGON_COMET
-#define RTOS_TIMER_REGS_ADDR	0xAB000000UL
-#endif
-#define SLEEP_CLK_RATE		32000
-
-#endif
--- a/arch/hexagon/include/asm/timex.h~hexagon-clean-up-timer-regsh
+++ a/arch/hexagon/include/asm/timex.h
@@ -7,11 +7,10 @@
 #define _ASM_TIMEX_H
 
 #include <asm-generic/timex.h>
-#include <asm/timer-regs.h>
 #include <asm/hexagon_vm.h>
 
 /* Using TCX0 as our clock.  CLOCK_TICK_RATE scheduled to be removed. */
-#define CLOCK_TICK_RATE              TCX0_CLK_RATE
+#define CLOCK_TICK_RATE              19200
 
 #define ARCH_HAS_READ_CURRENT_TIMER
 
--- a/arch/hexagon/kernel/time.c~hexagon-clean-up-timer-regsh
+++ a/arch/hexagon/kernel/time.c
@@ -17,9 +17,10 @@
 #include <linux/of_irq.h>
 #include <linux/module.h>
 
-#include <asm/timer-regs.h>
 #include <asm/hexagon_vm.h>
 
+#define TIMER_ENABLE		BIT(0)
+
 /*
  * For the clocksource we need:
  *	pcycle frequency (600MHz)
@@ -33,6 +34,13 @@ cycles_t	pcycle_freq_mhz;
 cycles_t	thread_freq_mhz;
 cycles_t	sleep_clk_freq;
 
+/*
+ * 8x50 HDD Specs 5-8.  Simulator co-sim not fixed until
+ * release 1.1, and then it's "adjustable" and probably not defaulted.
+ */
+#define RTOS_TIMER_INT		3
+#define RTOS_TIMER_REGS_ADDR	0xAB000000UL
+
 static struct resource rtos_timer_resources[] = {
 	{
 		.start	= RTOS_TIMER_REGS_ADDR,
@@ -80,7 +88,7 @@ static int set_next_event(unsigned long
 	iowrite32(0, &rtos_timer->clear);
 
 	iowrite32(delta, &rtos_timer->match);
-	iowrite32(1 << TIMER_ENABLE, &rtos_timer->enable);
+	iowrite32(TIMER_ENABLE, &rtos_timer->enable);
 	return 0;
 }
 
_

Patches currently in -mm which might be from nathan@kernel.org are

hexagon-export-raw-i-o-routines-for-modules.patch
hexagon-clean-up-timer-regsh.patch
hexagon-ignore-vmlinuxlds.patch

