Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9234111EC3
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:04:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729922AbfLCWvi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:51:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:43962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729916AbfLCWvi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:51:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B6D620862;
        Tue,  3 Dec 2019 22:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413496;
        bh=s9S5zjaVgM8T1TXPF/g8wAYlINzdVvQJClULL1jlvAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OB4kIi73AlhqXL1YRpeYecdqnJlZJEChaqh82Xz6BMyrQRCGPSfl9nX919myvDSdO
         IIsUsWweH+1InLWxv1bN4njKjerxqe0ecfGJboY30WdYplJdodWBR38HdKHGSijIcm
         J7/p0KFfmWhDSDE3jf7H1JgiqYl0XuYoquKHuFqE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tao Ren <taoren@fb.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 150/321] clocksource/drivers/fttmr010: Fix invalid interrupt register access
Date:   Tue,  3 Dec 2019 23:33:36 +0100
Message-Id: <20191203223434.954202398@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tao Ren <taoren@fb.com>

[ Upstream commit 86fe57fc47b17b3528fa5497fc57e158d846c4ea ]

TIMER_INTR_MASK register (Base Address of Timer + 0x38) is not designed
for masking interrupts on ast2500 chips, and it's not even listed in
ast2400 datasheet, so it's not safe to access TIMER_INTR_MASK on aspeed
chips.

Similarly, TIMER_INTR_STATE register (Base Address of Timer + 0x34) is
not interrupt status register on ast2400 and ast2500 chips. Although
there is no side effect to reset the register in fttmr010_common_init(),
it's just misleading to do so.

Besides, "count_down" is renamed to "is_aspeed" in "fttmr010" structure,
and more comments are added so the code is more readble.

Signed-off-by: Tao Ren <taoren@fb.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-fttmr010.c | 73 ++++++++++++++++------------
 1 file changed, 42 insertions(+), 31 deletions(-)

diff --git a/drivers/clocksource/timer-fttmr010.c b/drivers/clocksource/timer-fttmr010.c
index cf93f6419b514..fadff7915dd9c 100644
--- a/drivers/clocksource/timer-fttmr010.c
+++ b/drivers/clocksource/timer-fttmr010.c
@@ -21,7 +21,7 @@
 #include <linux/delay.h>
 
 /*
- * Register definitions for the timers
+ * Register definitions common for all the timer variants.
  */
 #define TIMER1_COUNT		(0x00)
 #define TIMER1_LOAD		(0x04)
@@ -36,9 +36,10 @@
 #define TIMER3_MATCH1		(0x28)
 #define TIMER3_MATCH2		(0x2c)
 #define TIMER_CR		(0x30)
-#define TIMER_INTR_STATE	(0x34)
-#define TIMER_INTR_MASK		(0x38)
 
+/*
+ * Control register (TMC30) bit fields for fttmr010/gemini/moxart timers.
+ */
 #define TIMER_1_CR_ENABLE	BIT(0)
 #define TIMER_1_CR_CLOCK	BIT(1)
 #define TIMER_1_CR_INT		BIT(2)
@@ -53,8 +54,9 @@
 #define TIMER_3_CR_UPDOWN	BIT(11)
 
 /*
- * The Aspeed AST2400 moves bits around in the control register
- * and lacks bits for setting the timer to count upwards.
+ * Control register (TMC30) bit fields for aspeed ast2400/ast2500 timers.
+ * The aspeed timers move bits around in the control register and lacks
+ * bits for setting the timer to count upwards.
  */
 #define TIMER_1_CR_ASPEED_ENABLE	BIT(0)
 #define TIMER_1_CR_ASPEED_CLOCK		BIT(1)
@@ -66,6 +68,18 @@
 #define TIMER_3_CR_ASPEED_CLOCK		BIT(9)
 #define TIMER_3_CR_ASPEED_INT		BIT(10)
 
+/*
+ * Interrupt status/mask register definitions for fttmr010/gemini/moxart
+ * timers.
+ * The registers don't exist and they are not needed on aspeed timers
+ * because:
+ *   - aspeed timer overflow interrupt is controlled by bits in Control
+ *     Register (TMC30).
+ *   - aspeed timers always generate interrupt when either one of the
+ *     Match registers equals to Status register.
+ */
+#define TIMER_INTR_STATE	(0x34)
+#define TIMER_INTR_MASK		(0x38)
 #define TIMER_1_INT_MATCH1	BIT(0)
 #define TIMER_1_INT_MATCH2	BIT(1)
 #define TIMER_1_INT_OVERFLOW	BIT(2)
@@ -80,7 +94,7 @@
 struct fttmr010 {
 	void __iomem *base;
 	unsigned int tick_rate;
-	bool count_down;
+	bool is_aspeed;
 	u32 t1_enable_val;
 	struct clock_event_device clkevt;
 #ifdef CONFIG_ARM
@@ -130,7 +144,7 @@ static int fttmr010_timer_set_next_event(unsigned long cycles,
 	cr &= ~fttmr010->t1_enable_val;
 	writel(cr, fttmr010->base + TIMER_CR);
 
-	if (fttmr010->count_down) {
+	if (fttmr010->is_aspeed) {
 		/*
 		 * ASPEED Timer Controller will load TIMER1_LOAD register
 		 * into TIMER1_COUNT register when the timer is re-enabled.
@@ -175,16 +189,17 @@ static int fttmr010_timer_set_oneshot(struct clock_event_device *evt)
 
 	/* Setup counter start from 0 or ~0 */
 	writel(0, fttmr010->base + TIMER1_COUNT);
-	if (fttmr010->count_down)
+	if (fttmr010->is_aspeed) {
 		writel(~0, fttmr010->base + TIMER1_LOAD);
-	else
+	} else {
 		writel(0, fttmr010->base + TIMER1_LOAD);
 
-	/* Enable interrupt */
-	cr = readl(fttmr010->base + TIMER_INTR_MASK);
-	cr &= ~(TIMER_1_INT_OVERFLOW | TIMER_1_INT_MATCH2);
-	cr |= TIMER_1_INT_MATCH1;
-	writel(cr, fttmr010->base + TIMER_INTR_MASK);
+		/* Enable interrupt */
+		cr = readl(fttmr010->base + TIMER_INTR_MASK);
+		cr &= ~(TIMER_1_INT_OVERFLOW | TIMER_1_INT_MATCH2);
+		cr |= TIMER_1_INT_MATCH1;
+		writel(cr, fttmr010->base + TIMER_INTR_MASK);
+	}
 
 	return 0;
 }
@@ -201,9 +216,8 @@ static int fttmr010_timer_set_periodic(struct clock_event_device *evt)
 	writel(cr, fttmr010->base + TIMER_CR);
 
 	/* Setup timer to fire at 1/HZ intervals. */
-	if (fttmr010->count_down) {
+	if (fttmr010->is_aspeed) {
 		writel(period, fttmr010->base + TIMER1_LOAD);
-		writel(0, fttmr010->base + TIMER1_MATCH1);
 	} else {
 		cr = 0xffffffff - (period - 1);
 		writel(cr, fttmr010->base + TIMER1_COUNT);
@@ -281,23 +295,21 @@ static int __init fttmr010_common_init(struct device_node *np, bool is_aspeed)
 	}
 
 	/*
-	 * The Aspeed AST2400 moves bits around in the control register,
-	 * otherwise it works the same.
+	 * The Aspeed timers move bits around in the control register.
 	 */
 	if (is_aspeed) {
 		fttmr010->t1_enable_val = TIMER_1_CR_ASPEED_ENABLE |
 			TIMER_1_CR_ASPEED_INT;
-		/* Downward not available */
-		fttmr010->count_down = true;
+		fttmr010->is_aspeed = true;
 	} else {
 		fttmr010->t1_enable_val = TIMER_1_CR_ENABLE | TIMER_1_CR_INT;
-	}
 
-	/*
-	 * Reset the interrupt mask and status
-	 */
-	writel(TIMER_INT_ALL_MASK, fttmr010->base + TIMER_INTR_MASK);
-	writel(0, fttmr010->base + TIMER_INTR_STATE);
+		/*
+		 * Reset the interrupt mask and status
+		 */
+		writel(TIMER_INT_ALL_MASK, fttmr010->base + TIMER_INTR_MASK);
+		writel(0, fttmr010->base + TIMER_INTR_STATE);
+	}
 
 	/*
 	 * Enable timer 1 count up, timer 2 count up, except on Aspeed,
@@ -306,9 +318,8 @@ static int __init fttmr010_common_init(struct device_node *np, bool is_aspeed)
 	if (is_aspeed)
 		val = TIMER_2_CR_ASPEED_ENABLE;
 	else {
-		val = TIMER_2_CR_ENABLE;
-		if (!fttmr010->count_down)
-			val |= TIMER_1_CR_UPDOWN | TIMER_2_CR_UPDOWN;
+		val = TIMER_2_CR_ENABLE | TIMER_1_CR_UPDOWN |
+			TIMER_2_CR_UPDOWN;
 	}
 	writel(val, fttmr010->base + TIMER_CR);
 
@@ -321,7 +332,7 @@ static int __init fttmr010_common_init(struct device_node *np, bool is_aspeed)
 	writel(0, fttmr010->base + TIMER2_MATCH1);
 	writel(0, fttmr010->base + TIMER2_MATCH2);
 
-	if (fttmr010->count_down) {
+	if (fttmr010->is_aspeed) {
 		writel(~0, fttmr010->base + TIMER2_LOAD);
 		clocksource_mmio_init(fttmr010->base + TIMER2_COUNT,
 				      "FTTMR010-TIMER2",
@@ -371,7 +382,7 @@ static int __init fttmr010_common_init(struct device_node *np, bool is_aspeed)
 
 #ifdef CONFIG_ARM
 	/* Also use this timer for delays */
-	if (fttmr010->count_down)
+	if (fttmr010->is_aspeed)
 		fttmr010->delay_timer.read_current_timer =
 			fttmr010_read_current_timer_down;
 	else
-- 
2.20.1



