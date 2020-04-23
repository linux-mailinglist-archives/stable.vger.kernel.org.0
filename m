Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B212B1B6936
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728261AbgDWXVW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:21:22 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48532 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728198AbgDWXGd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:33 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvM-0004bI-0R; Fri, 24 Apr 2020 00:06:28 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvK-00E6jk-TF; Fri, 24 Apr 2020 00:06:26 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Hans de Goede" <hdegoede@redhat.com>,
        "Andy Shevchenko" <andriy.shevchenko@linux.intel.com>,
        "Mika Westerberg" <mika.westerberg@linux.intel.com>
Date:   Fri, 24 Apr 2020 00:04:57 +0100
Message-ID: <lsq.1587683028.442500945@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 070/245] pinctrl: baytrail: Really serialize all
 register accesses
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

From: Hans de Goede <hdegoede@redhat.com>

commit 40ecab551232972a39cdd8b6f17ede54a3fdb296 upstream.

Commit 39ce8150a079 ("pinctrl: baytrail: Serialize all register access")
added a spinlock around all register accesses because:

"There is a hardware issue in Intel Baytrail where concurrent GPIO register
 access might result reads of 0xffffffff and writes might get dropped
 completely."

Testing has shown that this does not catch all cases, there are still
2 problems remaining

1) The original fix uses a spinlock per byt_gpio device / struct,
additional testing has shown that this is not sufficient concurent
accesses to 2 different GPIO banks also suffer from the same problem.

This commit fixes this by moving to a single global lock.

2) The original fix did not add a lock around the register accesses in
the suspend/resume handling.

Since pinctrl-baytrail.c is using normal suspend/resume handlers,
interrupts are still enabled during suspend/resume handling. Nothing
should be using the GPIOs when they are being taken down, _but_ the
GPIOs themselves may still cause interrupts, which are likely to
use (read) the triggering GPIO. So we need to protect against
concurrent GPIO register accesses in the suspend/resume handlers too.

This commit fixes this by adding the missing spin_lock / unlock calls.

The 2 fixes together fix the Acer Switch 10 SW5-012 getting completely
confused after a suspend resume. The DSDT for this device has a bug
in its _LID method which reprograms the home and power button trigger-
flags requesting both high and low _level_ interrupts so the IRQs for
these 2 GPIOs continuously fire. This combined with the saving of
registers during suspend, triggers concurrent GPIO register accesses
resulting in saving 0xffffffff as pconf0 value during suspend and then
when restoring this on resume the pinmux settings get all messed up,
resulting in various I2C busses being stuck, the wifi no longer working
and often the tablet simply not coming out of suspend at all.

Fixes: 39ce8150a079 ("pinctrl: baytrail: Serialize all register access")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
[bwh: Backported to 3.16:
 - Drop changes in functions that don't exist here
 - Delete local pointers to byt_gpio that become unused
 - Adjust filename, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/pinctrl/pinctrl-baytrail.c
+++ b/drivers/pinctrl/pinctrl-baytrail.c
@@ -140,13 +140,14 @@ struct byt_gpio {
 	struct gpio_chip		chip;
 	struct irq_domain		*domain;
 	struct platform_device		*pdev;
-	spinlock_t			lock;
 	void __iomem			*reg_base;
 	struct pinctrl_gpio_range	*range;
 };
 
 #define to_byt_gpio(c)	container_of(c, struct byt_gpio, chip)
 
+static DEFINE_RAW_SPINLOCK(byt_lock);
+
 static void __iomem *byt_gpio_reg(struct gpio_chip *chip, unsigned offset,
 				 int reg)
 {
@@ -167,11 +168,11 @@ static void byt_gpio_clear_triggering(st
 	unsigned long flags;
 	u32 value;
 
-	spin_lock_irqsave(&vg->lock, flags);
+	raw_spin_lock_irqsave(&byt_lock, flags);
 	value = readl(reg);
 	value &= ~(BYT_TRIG_POS | BYT_TRIG_NEG | BYT_TRIG_LVL);
 	writel(value, reg);
-	spin_unlock_irqrestore(&vg->lock, flags);
+	raw_spin_unlock_irqrestore(&byt_lock, flags);
 }
 
 static u32 byt_get_gpio_mux(struct byt_gpio *vg, unsigned offset)
@@ -196,7 +197,7 @@ static int byt_gpio_request(struct gpio_
 	u32 value, gpio_mux;
 	unsigned long flags;
 
-	spin_lock_irqsave(&vg->lock, flags);
+	raw_spin_lock_irqsave(&byt_lock, flags);
 
 	/*
 	 * In most cases, func pin mux 000 means GPIO function.
@@ -218,7 +219,7 @@ static int byt_gpio_request(struct gpio_
 			 "pin %u forcibly re-configured as GPIO\n", offset);
 	}
 
-	spin_unlock_irqrestore(&vg->lock, flags);
+	raw_spin_unlock_irqrestore(&byt_lock, flags);
 
 	pm_runtime_get(&vg->pdev->dev);
 
@@ -244,7 +245,7 @@ static int byt_irq_type(struct irq_data
 	if (offset >= vg->chip.ngpio)
 		return -EINVAL;
 
-	spin_lock_irqsave(&vg->lock, flags);
+	raw_spin_lock_irqsave(&byt_lock, flags);
 	value = readl(reg);
 
 	/* For level trigges the BYT_TRIG_POS and BYT_TRIG_NEG bits
@@ -259,7 +260,7 @@ static int byt_irq_type(struct irq_data
 	else if (type & IRQ_TYPE_LEVEL_MASK)
 		__irq_set_handler_locked(d->irq, handle_level_irq);
 
-	spin_unlock_irqrestore(&vg->lock, flags);
+	raw_spin_unlock_irqrestore(&byt_lock, flags);
 
 	return 0;
 }
@@ -267,25 +268,23 @@ static int byt_irq_type(struct irq_data
 static int byt_gpio_get(struct gpio_chip *chip, unsigned offset)
 {
 	void __iomem *reg = byt_gpio_reg(chip, offset, BYT_VAL_REG);
-	struct byt_gpio *vg = to_byt_gpio(chip);
 	unsigned long flags;
 	u32 val;
 
-	spin_lock_irqsave(&vg->lock, flags);
+	raw_spin_lock_irqsave(&byt_lock, flags);
 	val = readl(reg);
-	spin_unlock_irqrestore(&vg->lock, flags);
+	raw_spin_unlock_irqrestore(&byt_lock, flags);
 
 	return val & BYT_LEVEL;
 }
 
 static void byt_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
 {
-	struct byt_gpio *vg = to_byt_gpio(chip);
 	void __iomem *reg = byt_gpio_reg(chip, offset, BYT_VAL_REG);
 	unsigned long flags;
 	u32 old_val;
 
-	spin_lock_irqsave(&vg->lock, flags);
+	raw_spin_lock_irqsave(&byt_lock, flags);
 
 	old_val = readl(reg);
 
@@ -294,23 +293,22 @@ static void byt_gpio_set(struct gpio_chi
 	else
 		writel(old_val & ~BYT_LEVEL, reg);
 
-	spin_unlock_irqrestore(&vg->lock, flags);
+	raw_spin_unlock_irqrestore(&byt_lock, flags);
 }
 
 static int byt_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
 {
-	struct byt_gpio *vg = to_byt_gpio(chip);
 	void __iomem *reg = byt_gpio_reg(chip, offset, BYT_VAL_REG);
 	unsigned long flags;
 	u32 value;
 
-	spin_lock_irqsave(&vg->lock, flags);
+	raw_spin_lock_irqsave(&byt_lock, flags);
 
 	value = readl(reg) | BYT_DIR_MASK;
 	value &= ~BYT_INPUT_EN;		/* active low */
 	writel(value, reg);
 
-	spin_unlock_irqrestore(&vg->lock, flags);
+	raw_spin_unlock_irqrestore(&byt_lock, flags);
 
 	return 0;
 }
@@ -318,12 +316,11 @@ static int byt_gpio_direction_input(stru
 static int byt_gpio_direction_output(struct gpio_chip *chip,
 				     unsigned gpio, int value)
 {
-	struct byt_gpio *vg = to_byt_gpio(chip);
 	void __iomem *reg = byt_gpio_reg(chip, gpio, BYT_VAL_REG);
 	unsigned long flags;
 	u32 reg_val;
 
-	spin_lock_irqsave(&vg->lock, flags);
+	raw_spin_lock_irqsave(&byt_lock, flags);
 
 	reg_val = readl(reg) | BYT_DIR_MASK;
 	reg_val &= ~(BYT_OUTPUT_EN | BYT_INPUT_EN);
@@ -333,7 +330,7 @@ static int byt_gpio_direction_output(str
 	else
 		writel(reg_val & ~BYT_LEVEL, reg);
 
-	spin_unlock_irqrestore(&vg->lock, flags);
+	raw_spin_unlock_irqrestore(&byt_lock, flags);
 
 	return 0;
 }
@@ -345,7 +342,7 @@ static void byt_gpio_dbg_show(struct seq
 	unsigned long flags;
 	u32 conf0, val, offs;
 
-	spin_lock_irqsave(&vg->lock, flags);
+	raw_spin_lock_irqsave(&byt_lock, flags);
 
 	for (i = 0; i < vg->chip.ngpio; i++) {
 		const char *pull_str = NULL;
@@ -406,7 +403,7 @@ static void byt_gpio_dbg_show(struct seq
 
 		seq_puts(s, "\n");
 	}
-	spin_unlock_irqrestore(&vg->lock, flags);
+	raw_spin_unlock_irqrestore(&byt_lock, flags);
 }
 
 static int byt_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
@@ -444,10 +441,10 @@ static void byt_irq_ack(struct irq_data
 	unsigned offset = irqd_to_hwirq(d);
 	void __iomem *reg;
 
-	spin_lock(&vg->lock);
+	raw_spin_lock(&byt_lock);
 	reg = byt_gpio_reg(&vg->chip, offset, BYT_INT_STAT_REG);
 	writel(BIT(offset % 32), reg);
-	spin_unlock(&vg->lock);
+	raw_spin_unlock(&byt_lock);
 }
 
 static void byt_irq_unmask(struct irq_data *d)
@@ -459,7 +456,7 @@ static void byt_irq_unmask(struct irq_da
 	void __iomem *reg;
 	u32 value;
 
-	spin_lock_irqsave(&vg->lock, flags);
+	raw_spin_lock_irqsave(&byt_lock, flags);
 
 	reg = byt_gpio_reg(&vg->chip, offset, BYT_CONF0_REG);
 	value = readl(reg);
@@ -482,7 +479,7 @@ static void byt_irq_unmask(struct irq_da
 
 	writel(value, reg);
 
-	spin_unlock_irqrestore(&vg->lock, flags);
+	raw_spin_unlock_irqrestore(&byt_lock, flags);
 }
 
 static void byt_irq_mask(struct irq_data *d)
@@ -613,8 +610,6 @@ static int byt_gpio_probe(struct platfor
 	if (IS_ERR(vg->reg_base))
 		return PTR_ERR(vg->reg_base);
 
-	spin_lock_init(&vg->lock);
-
 	gc = &vg->chip;
 	gc->label = dev_name(&pdev->dev);
 	gc->owner = THIS_MODULE;

