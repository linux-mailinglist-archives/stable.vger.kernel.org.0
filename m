Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DBC1450E3C
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240795AbhKOSNq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:13:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:49946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240195AbhKOSHS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:07:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9105763391;
        Mon, 15 Nov 2021 17:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636998203;
        bh=qsUhvVvpqWj1FRinCia/INKCoMJlAtmLf1nO6HzJFew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q5n5CF6dcZi+4wgZJI7fP6rHHEpCjMVzmE7PXhUerDWZDTQCehXC/0JBGTtdu6LWU
         QU/b717d/za+tmN3/v9TU885Rfn4NBBuv8oIxU71QSSFnHVJIzr410xAQoDftyweAe
         +18nDzAW1GB76p5YkPa3PNOe3dBeGJEH/uq/SYO3azGSHp20e9x3Y+eILnHYO/ms8I
         hyqxVYQ5F7HBYrMN3IRis8NjfgYXPB3n5sFfdBkGeKDbSC5mLDBbnXdP0GDs4jaq6z
         8V31kZ/stnWyBC7JXd/Bg9vS7AVMOwfMZrpi+suCjGwHUt50DT9NXcoJlOoMtN16wU
         pzA/moknL++Aw==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Brian Cain <bcain@codeaurora.org>
Cc:     linux-hexagon@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        Nathan Chancellor <nathan@kernel.org>, stable@vger.kernel.org
Subject: [PATCH v2 2/3] hexagon: Clean up timer-regs.h
Date:   Mon, 15 Nov 2021 10:42:50 -0700
Message-Id: <20211115174250.1994179-3-nathan@kernel.org>
X-Mailer: git-send-email 2.34.0.rc0
In-Reply-To: <20211115174250.1994179-1-nathan@kernel.org>
References: <20211115174250.1994179-1-nathan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Cc: stable@vger.kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Brian Cain <bcain@codeaurora.org>
---
 arch/hexagon/include/asm/timer-regs.h | 26 --------------------------
 arch/hexagon/include/asm/timex.h      |  3 +--
 arch/hexagon/kernel/time.c            | 12 ++++++++++--
 3 files changed, 11 insertions(+), 30 deletions(-)
 delete mode 100644 arch/hexagon/include/asm/timer-regs.h

diff --git a/arch/hexagon/include/asm/timer-regs.h b/arch/hexagon/include/asm/timer-regs.h
deleted file mode 100644
index ee6c61423a05..000000000000
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
diff --git a/arch/hexagon/include/asm/timex.h b/arch/hexagon/include/asm/timex.h
index 8d4ec76fceb4..dfe69e118b2b 100644
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
 
diff --git a/arch/hexagon/kernel/time.c b/arch/hexagon/kernel/time.c
index feffe527ac92..febc95714d75 100644
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
@@ -80,7 +88,7 @@ static int set_next_event(unsigned long delta, struct clock_event_device *evt)
 	iowrite32(0, &rtos_timer->clear);
 
 	iowrite32(delta, &rtos_timer->match);
-	iowrite32(1 << TIMER_ENABLE, &rtos_timer->enable);
+	iowrite32(TIMER_ENABLE, &rtos_timer->enable);
 	return 0;
 }
 
-- 
2.34.0.rc0

