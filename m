Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F169E37C191
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232658AbhELPBv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:01:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:43946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232023AbhELO7X (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 10:59:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1B076147F;
        Wed, 12 May 2021 14:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831399;
        bh=KM7ubF6EH87n/4rUpjIUs2UXY3jk5ByqZmOAV/N6y9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U3IOB4XEG9WcM14EGhGJsJCICnLlUyqmLXmYDpfKl/H6fyPziWGkImjVW/1rIP2vw
         YwQDEHP9aGqKgdQxDSFwUYpgm5kk6Y2gDA/TDRcgChQIKpS/Hkcf8ZQ8/f00fZTQy9
         gYDOWUHARPLSIUafRe5UfaXAdisAvma8d/Xag5Do=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Pavone <pavone@retrodev.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 104/244] m68k: mvme147,mvme16x: Dont wipe PCC timer config bits
Date:   Wed, 12 May 2021 16:47:55 +0200
Message-Id: <20210512144746.358848915@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

[ Upstream commit 43262178c043032e7c42d00de44c818ba05f9967 ]

Don't clear the timer 1 configuration bits when clearing the interrupt flag
and counter overflow. As Michael reported, "This results in no timer
interrupts being delivered after the first. Initialization then hangs
in calibrate_delay as the jiffies counter is not updated."

On mvme16x, enable the timer after requesting the irq, consistent with
mvme147.

Cc: Michael Pavone <pavone@retrodev.com>
Fixes: 7529b90d051e ("m68k: mvme147: Handle timer counter overflow")
Fixes: 19999a8b8782 ("m68k: mvme16x: Handle timer counter overflow")
Reported-and-tested-by: Michael Pavone <pavone@retrodev.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Link: https://lore.kernel.org/r/4fdaa113db089b8fb607f7dd818479f8cdcc4547.1617089871.git.fthain@telegraphics.com.au
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/include/asm/mvme147hw.h |  3 +++
 arch/m68k/mvme147/config.c        | 14 ++++++++------
 arch/m68k/mvme16x/config.c        | 14 ++++++++------
 3 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/arch/m68k/include/asm/mvme147hw.h b/arch/m68k/include/asm/mvme147hw.h
index 257b29184af9..e28eb1c0e0bf 100644
--- a/arch/m68k/include/asm/mvme147hw.h
+++ b/arch/m68k/include/asm/mvme147hw.h
@@ -66,6 +66,9 @@ struct pcc_regs {
 #define PCC_INT_ENAB		0x08
 
 #define PCC_TIMER_INT_CLR	0x80
+
+#define PCC_TIMER_TIC_EN	0x01
+#define PCC_TIMER_COC_EN	0x02
 #define PCC_TIMER_CLR_OVF	0x04
 
 #define PCC_LEVEL_ABORT		0x07
diff --git a/arch/m68k/mvme147/config.c b/arch/m68k/mvme147/config.c
index 545a1fe0e119..245376630c3d 100644
--- a/arch/m68k/mvme147/config.c
+++ b/arch/m68k/mvme147/config.c
@@ -117,8 +117,10 @@ static irqreturn_t mvme147_timer_int (int irq, void *dev_id)
 	unsigned long flags;
 
 	local_irq_save(flags);
-	m147_pcc->t1_int_cntrl = PCC_TIMER_INT_CLR;
-	m147_pcc->t1_cntrl = PCC_TIMER_CLR_OVF;
+	m147_pcc->t1_cntrl = PCC_TIMER_CLR_OVF | PCC_TIMER_COC_EN |
+			     PCC_TIMER_TIC_EN;
+	m147_pcc->t1_int_cntrl = PCC_INT_ENAB | PCC_TIMER_INT_CLR |
+				 PCC_LEVEL_TIMER1;
 	clk_total += PCC_TIMER_CYCLES;
 	timer_routine(0, NULL);
 	local_irq_restore(flags);
@@ -136,10 +138,10 @@ void mvme147_sched_init (irq_handler_t timer_routine)
 	/* Init the clock with a value */
 	/* The clock counter increments until 0xFFFF then reloads */
 	m147_pcc->t1_preload = PCC_TIMER_PRELOAD;
-	m147_pcc->t1_cntrl = 0x0;	/* clear timer */
-	m147_pcc->t1_cntrl = 0x3;	/* start timer */
-	m147_pcc->t1_int_cntrl = PCC_TIMER_INT_CLR;  /* clear pending ints */
-	m147_pcc->t1_int_cntrl = PCC_INT_ENAB|PCC_LEVEL_TIMER1;
+	m147_pcc->t1_cntrl = PCC_TIMER_CLR_OVF | PCC_TIMER_COC_EN |
+			     PCC_TIMER_TIC_EN;
+	m147_pcc->t1_int_cntrl = PCC_INT_ENAB | PCC_TIMER_INT_CLR |
+				 PCC_LEVEL_TIMER1;
 
 	clocksource_register_hz(&mvme147_clk, PCC_TIMER_CLOCK_FREQ);
 }
diff --git a/arch/m68k/mvme16x/config.c b/arch/m68k/mvme16x/config.c
index 9bc2da69f80c..2f2c2d172b24 100644
--- a/arch/m68k/mvme16x/config.c
+++ b/arch/m68k/mvme16x/config.c
@@ -368,6 +368,7 @@ static u32 clk_total;
 #define PCCTOVR1_COC_EN      0x02
 #define PCCTOVR1_OVR_CLR     0x04
 
+#define PCCTIC1_INT_LEVEL    6
 #define PCCTIC1_INT_CLR      0x08
 #define PCCTIC1_INT_EN       0x10
 
@@ -377,8 +378,8 @@ static irqreturn_t mvme16x_timer_int (int irq, void *dev_id)
 	unsigned long flags;
 
 	local_irq_save(flags);
-	out_8(PCCTIC1, in_8(PCCTIC1) | PCCTIC1_INT_CLR);
-	out_8(PCCTOVR1, PCCTOVR1_OVR_CLR);
+	out_8(PCCTOVR1, PCCTOVR1_OVR_CLR | PCCTOVR1_TIC_EN | PCCTOVR1_COC_EN);
+	out_8(PCCTIC1, PCCTIC1_INT_EN | PCCTIC1_INT_CLR | PCCTIC1_INT_LEVEL);
 	clk_total += PCC_TIMER_CYCLES;
 	timer_routine(0, NULL);
 	local_irq_restore(flags);
@@ -392,14 +393,15 @@ void mvme16x_sched_init (irq_handler_t timer_routine)
     int irq;
 
     /* Using PCCchip2 or MC2 chip tick timer 1 */
-    out_be32(PCCTCNT1, 0);
-    out_be32(PCCTCMP1, PCC_TIMER_CYCLES);
-    out_8(PCCTOVR1, in_8(PCCTOVR1) | PCCTOVR1_TIC_EN | PCCTOVR1_COC_EN);
-    out_8(PCCTIC1, PCCTIC1_INT_EN | 6);
     if (request_irq(MVME16x_IRQ_TIMER, mvme16x_timer_int, IRQF_TIMER, "timer",
                     timer_routine))
 	panic ("Couldn't register timer int");
 
+    out_be32(PCCTCNT1, 0);
+    out_be32(PCCTCMP1, PCC_TIMER_CYCLES);
+    out_8(PCCTOVR1, PCCTOVR1_OVR_CLR | PCCTOVR1_TIC_EN | PCCTOVR1_COC_EN);
+    out_8(PCCTIC1, PCCTIC1_INT_EN | PCCTIC1_INT_CLR | PCCTIC1_INT_LEVEL);
+
     clocksource_register_hz(&mvme16x_clk, PCC_TIMER_CLOCK_FREQ);
 
     if (brdno == 0x0162 || brdno == 0x172)
-- 
2.30.2



