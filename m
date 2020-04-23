Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 786E61B692B
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729524AbgDWXUz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:20:55 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48598 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728205AbgDWXGd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:33 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvL-0004bC-Ee; Fri, 24 Apr 2020 00:06:27 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvK-00E6ja-Kj; Fri, 24 Apr 2020 00:06:26 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Linus Walleij" <linus.walleij@linaro.org>,
        "Mika Westerberg" <mika.westerberg@linux.intel.com>
Date:   Fri, 24 Apr 2020 00:04:55 +0100
Message-ID: <lsq.1587683028.459138453@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 068/245] pinctrl: baytrail: Rework interrupt handling
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit 31e4329f99062a06dca5a493bb4495a63b2dc6ba upstream.

Instead of handling everything in the driver's first level interrupt
handler, we can take advantage of already existing flow handlers that are
provided by the IRQ core.

This changes the functionality a bit also. Previously the driver looped
over pending interrupts in a single loop, restarting the loop if some
interrupt changed state. This caused problem with Lenovo Thinkpad 10
digitizer that it was not able to deassert the interrupt before the driver
disabled the interrupt for good (looplimit was exhausted).

Rework the interrupt handling logic a bit so that we provide proper mask,
ack and unmask operations in terms of Baytrail GPIO hardware and loop over
pending interrupts only once. If the interrupt remains asserted the first
level handler will be re-triggered automatically.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
[bwh: Backported to 3.16 as dependency of commit 39ce8150a079
 "pinctrl: baytrail: Serialize all register access":
 - Adjust filename, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/pinctrl/pinctrl-baytrail.c | 100 +++++++++++++----------
 1 file changed, 56 insertions(+), 44 deletions(-)

--- a/drivers/pinctrl/pinctrl-baytrail.c
+++ b/drivers/pinctrl/pinctrl-baytrail.c
@@ -251,23 +251,13 @@ static int byt_irq_type(struct irq_data
 	 */
 	value &= ~(BYT_TRIG_POS | BYT_TRIG_NEG | BYT_TRIG_LVL);
 
-	switch (type) {
-	case IRQ_TYPE_LEVEL_HIGH:
-		value |= BYT_TRIG_LVL;
-	case IRQ_TYPE_EDGE_RISING:
-		value |= BYT_TRIG_POS;
-		break;
-	case IRQ_TYPE_LEVEL_LOW:
-		value |= BYT_TRIG_LVL;
-	case IRQ_TYPE_EDGE_FALLING:
-		value |= BYT_TRIG_NEG;
-		break;
-	case IRQ_TYPE_EDGE_BOTH:
-		value |= (BYT_TRIG_NEG | BYT_TRIG_POS);
-		break;
-	}
 	writel(value, reg);
 
+	if (type & IRQ_TYPE_EDGE_BOTH)
+		__irq_set_handler_locked(d->irq, handle_edge_irq);
+	else if (type & IRQ_TYPE_LEVEL_MASK)
+		__irq_set_handler_locked(d->irq, handle_level_irq);
+
 	spin_unlock_irqrestore(&vg->lock, flags);
 
 	return 0;
@@ -421,54 +411,75 @@ static void byt_gpio_irq_handler(unsigne
 	struct irq_data *data = irq_desc_get_irq_data(desc);
 	struct byt_gpio *vg = irq_data_get_irq_handler_data(data);
 	struct irq_chip *chip = irq_data_get_irq_chip(data);
-	u32 base, pin, mask;
+	u32 base, pin;
 	void __iomem *reg;
-	u32 pending;
+	unsigned long pending;
 	unsigned virq;
-	int looplimit = 0;
 
 	/* check from GPIO controller which pin triggered the interrupt */
 	for (base = 0; base < vg->chip.ngpio; base += 32) {
-
 		reg = byt_gpio_reg(&vg->chip, base, BYT_INT_STAT_REG);
-
-		while ((pending = readl(reg))) {
-			pin = __ffs(pending);
-			mask = BIT(pin);
-			/* Clear before handling so we can't lose an edge */
-			writel(mask, reg);
-
+		pending = readl(reg);
+		for_each_set_bit(pin, &pending, 32) {
 			virq = irq_find_mapping(vg->domain, base + pin);
 			generic_handle_irq(virq);
-
-			/* In case bios or user sets triggering incorretly a pin
-			 * might remain in "interrupt triggered" state.
-			 */
-			if (looplimit++ > 32) {
-				dev_err(&vg->pdev->dev,
-					"Gpio %d interrupt flood, disabling\n",
-					base + pin);
-
-				reg = byt_gpio_reg(&vg->chip, base + pin,
-						   BYT_CONF0_REG);
-				mask = readl(reg);
-				mask &= ~(BYT_TRIG_NEG | BYT_TRIG_POS |
-					  BYT_TRIG_LVL);
-				writel(mask, reg);
-				mask = readl(reg); /* flush */
-				break;
-			}
 		}
 	}
 	chip->irq_eoi(data);
 }
 
+static void byt_irq_ack(struct irq_data *d)
+{
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct byt_gpio *vg = to_byt_gpio(gc);
+	unsigned offset = irqd_to_hwirq(d);
+	void __iomem *reg;
+
+	reg = byt_gpio_reg(&vg->chip, offset, BYT_INT_STAT_REG);
+	writel(BIT(offset % 32), reg);
+}
+
 static void byt_irq_unmask(struct irq_data *d)
 {
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct byt_gpio *vg = to_byt_gpio(gc);
+	unsigned offset = irqd_to_hwirq(d);
+	unsigned long flags;
+	void __iomem *reg;
+	u32 value;
+
+	spin_lock_irqsave(&vg->lock, flags);
+
+	reg = byt_gpio_reg(&vg->chip, offset, BYT_CONF0_REG);
+	value = readl(reg);
+
+	switch (irqd_get_trigger_type(d)) {
+	case IRQ_TYPE_LEVEL_HIGH:
+		value |= BYT_TRIG_LVL;
+	case IRQ_TYPE_EDGE_RISING:
+		value |= BYT_TRIG_POS;
+		break;
+	case IRQ_TYPE_LEVEL_LOW:
+		value |= BYT_TRIG_LVL;
+	case IRQ_TYPE_EDGE_FALLING:
+		value |= BYT_TRIG_NEG;
+		break;
+	case IRQ_TYPE_EDGE_BOTH:
+		value |= (BYT_TRIG_NEG | BYT_TRIG_POS);
+		break;
+	}
+
+	writel(value, reg);
+
+	spin_unlock_irqrestore(&vg->lock, flags);
 }
 
 static void byt_irq_mask(struct irq_data *d)
 {
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct byt_gpio *vg = to_byt_gpio(gc);
+
+	byt_gpio_clear_triggering(vg, irqd_to_hwirq(d));
 }
 
 static int byt_irq_reqres(struct irq_data *d)
@@ -493,6 +504,7 @@ static void byt_irq_relres(struct irq_da
 
 static struct irq_chip byt_irqchip = {
 	.name = "BYT-GPIO",
+	.irq_ack = byt_irq_ack,
 	.irq_mask = byt_irq_mask,
 	.irq_unmask = byt_irq_unmask,
 	.irq_set_type = byt_irq_type,

