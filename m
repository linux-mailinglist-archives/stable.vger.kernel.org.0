Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6B845C3A6
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350663AbhKXNlj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:41:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:34330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349722AbhKXNji (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:39:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 512DF6322C;
        Wed, 24 Nov 2021 12:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758597;
        bh=ugWqr8UcQFycdxLEgR2jOF0/IWWvJRmU6HdmzdRh9ok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lgEgDXzfsY4gUvIJceVaniwsi5Frnl1iXzNrLyQ+j5fRnLIqrTaxsKvqLfi7raOza
         WizLmFn2KmlU1SnUAyRN4miJaCs4XoyXMLcezHZPQOjdanqS11Xj/SvnKsKgCx+q2J
         5AtQG/+qWrRPKjlbwGJPT8ZCf9DRjbHOSVpkgafM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Brian Cain <bcain@codeaurora.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 122/154] hexagon: clean up timer-regs.h
Date:   Wed, 24 Nov 2021 12:58:38 +0100
Message-Id: <20211124115706.235276418@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

commit 51f2ec593441d3d1ebc0d478fac3ea329c7c93ac upstream.

When building allmodconfig, there is a warning about TIMER_ENABLE being
redefined:

  drivers/clocksource/timer-oxnas-rps.c:39:9: error: 'TIMER_ENABLE' macro redefined [-Werror,-Wmacro-redefined]
  #define TIMER_ENABLE            BIT(7)
          ^
  arch/hexagon/include/asm/timer-regs.h:13:9: note: previous definition is here
  #define TIMER_ENABLE            0
           ^
  1 error generated.

The values in this header are only used in one file each, if they are
used at all.  Remove the header and sink all of the constants into their
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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/hexagon/include/asm/timer-regs.h |   26 --------------------------
 arch/hexagon/include/asm/timex.h      |    3 +--
 arch/hexagon/kernel/time.c            |   12 ++++++++++--
 3 files changed, 11 insertions(+), 30 deletions(-)
 delete mode 100644 arch/hexagon/include/asm/timer-regs.h

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
--- a/arch/hexagon/include/asm/timex.h
+++ b/arch/hexagon/include/asm/timex.h
@@ -7,11 +7,10 @@
 #define _ASM_TIMEX_H
 
 #include <asm-generic/timex.h>
-#include <asm/timer-regs.h>
 #include <asm/hexagon_vm.h>
 
 /* Using TCX0 as our clock.  CLOCK_TICK_RATE scheduled to be removed. */
-#define CLOCK_TICK_RATE              TCX0_CLK_RATE
+#define CLOCK_TICK_RATE              19200
 
 #define ARCH_HAS_READ_CURRENT_TIMER
 
--- a/arch/hexagon/kernel/time.c
+++ b/arch/hexagon/kernel/time.c
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
 


