Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4082512ECFF
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728893AbgABWXI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:23:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:44546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729212AbgABWXH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:23:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F66520863;
        Thu,  2 Jan 2020 22:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003785;
        bh=AhnK1bvALGKUOg2GGNkyvYtLRDz52vt6J4a/ZjRureY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xD6MeJZ+iBNtG98SgdJbi9AFWy549YYixSapbo6Z0Leqrv/Gp8SMXKk3b90Gq2WI6
         3T+V0W1LxHVZN1wePaLsBn+cs5ghMKNFKj4QJ5Wbys1UW/wo/kjeNJXCUKL9kD4eZA
         RvOe+m8gzrd2b01U9rZAkaUi+hOXa4Oo0WJlIp0I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 114/114] pinctrl: baytrail: Really serialize all register accesses
Date:   Thu,  2 Jan 2020 23:08:06 +0100
Message-Id: <20200102220040.608277693@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220029.183913184@linuxfoundation.org>
References: <20200102220029.183913184@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 40ecab551232972a39cdd8b6f17ede54a3fdb296 ]

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

Cc: stable@vger.kernel.org
Fixes: 39ce8150a079 ("pinctrl: baytrail: Serialize all register access")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/intel/pinctrl-baytrail.c | 81 +++++++++++++-----------
 1 file changed, 44 insertions(+), 37 deletions(-)

diff --git a/drivers/pinctrl/intel/pinctrl-baytrail.c b/drivers/pinctrl/intel/pinctrl-baytrail.c
index f38d596efa05..021e28ff1194 100644
--- a/drivers/pinctrl/intel/pinctrl-baytrail.c
+++ b/drivers/pinctrl/intel/pinctrl-baytrail.c
@@ -196,7 +196,6 @@ struct byt_gpio {
 	struct platform_device *pdev;
 	struct pinctrl_dev *pctl_dev;
 	struct pinctrl_desc pctl_desc;
-	raw_spinlock_t lock;
 	const struct byt_pinctrl_soc_data *soc_data;
 	struct byt_community *communities_copy;
 	struct byt_gpio_pin_context *saved_context;
@@ -707,6 +706,8 @@ static const struct byt_pinctrl_soc_data *byt_soc_data[] = {
 	NULL,
 };
 
+static DEFINE_RAW_SPINLOCK(byt_lock);
+
 static struct byt_community *byt_get_community(struct byt_gpio *vg,
 					       unsigned int pin)
 {
@@ -848,7 +849,7 @@ static void byt_set_group_simple_mux(struct byt_gpio *vg,
 	unsigned long flags;
 	int i;
 
-	raw_spin_lock_irqsave(&vg->lock, flags);
+	raw_spin_lock_irqsave(&byt_lock, flags);
 
 	for (i = 0; i < group.npins; i++) {
 		void __iomem *padcfg0;
@@ -868,7 +869,7 @@ static void byt_set_group_simple_mux(struct byt_gpio *vg,
 		writel(value, padcfg0);
 	}
 
-	raw_spin_unlock_irqrestore(&vg->lock, flags);
+	raw_spin_unlock_irqrestore(&byt_lock, flags);
 }
 
 static void byt_set_group_mixed_mux(struct byt_gpio *vg,
@@ -878,7 +879,7 @@ static void byt_set_group_mixed_mux(struct byt_gpio *vg,
 	unsigned long flags;
 	int i;
 
-	raw_spin_lock_irqsave(&vg->lock, flags);
+	raw_spin_lock_irqsave(&byt_lock, flags);
 
 	for (i = 0; i < group.npins; i++) {
 		void __iomem *padcfg0;
@@ -898,7 +899,7 @@ static void byt_set_group_mixed_mux(struct byt_gpio *vg,
 		writel(value, padcfg0);
 	}
 
-	raw_spin_unlock_irqrestore(&vg->lock, flags);
+	raw_spin_unlock_irqrestore(&byt_lock, flags);
 }
 
 static int byt_set_mux(struct pinctrl_dev *pctldev, unsigned int func_selector,
@@ -947,11 +948,11 @@ static void byt_gpio_clear_triggering(struct byt_gpio *vg, unsigned int offset)
 	unsigned long flags;
 	u32 value;
 
-	raw_spin_lock_irqsave(&vg->lock, flags);
+	raw_spin_lock_irqsave(&byt_lock, flags);
 	value = readl(reg);
 	value &= ~(BYT_TRIG_POS | BYT_TRIG_NEG | BYT_TRIG_LVL);
 	writel(value, reg);
-	raw_spin_unlock_irqrestore(&vg->lock, flags);
+	raw_spin_unlock_irqrestore(&byt_lock, flags);
 }
 
 static int byt_gpio_request_enable(struct pinctrl_dev *pctl_dev,
@@ -963,7 +964,7 @@ static int byt_gpio_request_enable(struct pinctrl_dev *pctl_dev,
 	u32 value, gpio_mux;
 	unsigned long flags;
 
-	raw_spin_lock_irqsave(&vg->lock, flags);
+	raw_spin_lock_irqsave(&byt_lock, flags);
 
 	/*
 	 * In most cases, func pin mux 000 means GPIO function.
@@ -985,7 +986,7 @@ static int byt_gpio_request_enable(struct pinctrl_dev *pctl_dev,
 			 "pin %u forcibly re-configured as GPIO\n", offset);
 	}
 
-	raw_spin_unlock_irqrestore(&vg->lock, flags);
+	raw_spin_unlock_irqrestore(&byt_lock, flags);
 
 	pm_runtime_get(&vg->pdev->dev);
 
@@ -1013,7 +1014,7 @@ static int byt_gpio_set_direction(struct pinctrl_dev *pctl_dev,
 	unsigned long flags;
 	u32 value;
 
-	raw_spin_lock_irqsave(&vg->lock, flags);
+	raw_spin_lock_irqsave(&byt_lock, flags);
 
 	value = readl(val_reg);
 	value &= ~BYT_DIR_MASK;
@@ -1030,7 +1031,7 @@ static int byt_gpio_set_direction(struct pinctrl_dev *pctl_dev,
 		     "Potential Error: Setting GPIO with direct_irq_en to output");
 	writel(value, val_reg);
 
-	raw_spin_unlock_irqrestore(&vg->lock, flags);
+	raw_spin_unlock_irqrestore(&byt_lock, flags);
 
 	return 0;
 }
@@ -1099,11 +1100,11 @@ static int byt_pin_config_get(struct pinctrl_dev *pctl_dev, unsigned int offset,
 	u32 conf, pull, val, debounce;
 	u16 arg = 0;
 
-	raw_spin_lock_irqsave(&vg->lock, flags);
+	raw_spin_lock_irqsave(&byt_lock, flags);
 	conf = readl(conf_reg);
 	pull = conf & BYT_PULL_ASSIGN_MASK;
 	val = readl(val_reg);
-	raw_spin_unlock_irqrestore(&vg->lock, flags);
+	raw_spin_unlock_irqrestore(&byt_lock, flags);
 
 	switch (param) {
 	case PIN_CONFIG_BIAS_DISABLE:
@@ -1130,9 +1131,9 @@ static int byt_pin_config_get(struct pinctrl_dev *pctl_dev, unsigned int offset,
 		if (!(conf & BYT_DEBOUNCE_EN))
 			return -EINVAL;
 
-		raw_spin_lock_irqsave(&vg->lock, flags);
+		raw_spin_lock_irqsave(&byt_lock, flags);
 		debounce = readl(db_reg);
-		raw_spin_unlock_irqrestore(&vg->lock, flags);
+		raw_spin_unlock_irqrestore(&byt_lock, flags);
 
 		switch (debounce & BYT_DEBOUNCE_PULSE_MASK) {
 		case BYT_DEBOUNCE_PULSE_375US:
@@ -1184,7 +1185,7 @@ static int byt_pin_config_set(struct pinctrl_dev *pctl_dev,
 	u32 conf, val, debounce;
 	int i, ret = 0;
 
-	raw_spin_lock_irqsave(&vg->lock, flags);
+	raw_spin_lock_irqsave(&byt_lock, flags);
 
 	conf = readl(conf_reg);
 	val = readl(val_reg);
@@ -1292,7 +1293,7 @@ static int byt_pin_config_set(struct pinctrl_dev *pctl_dev,
 	if (!ret)
 		writel(conf, conf_reg);
 
-	raw_spin_unlock_irqrestore(&vg->lock, flags);
+	raw_spin_unlock_irqrestore(&byt_lock, flags);
 
 	return ret;
 }
@@ -1317,9 +1318,9 @@ static int byt_gpio_get(struct gpio_chip *chip, unsigned offset)
 	unsigned long flags;
 	u32 val;
 
-	raw_spin_lock_irqsave(&vg->lock, flags);
+	raw_spin_lock_irqsave(&byt_lock, flags);
 	val = readl(reg);
-	raw_spin_unlock_irqrestore(&vg->lock, flags);
+	raw_spin_unlock_irqrestore(&byt_lock, flags);
 
 	return !!(val & BYT_LEVEL);
 }
@@ -1334,13 +1335,13 @@ static void byt_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
 	if (!reg)
 		return;
 
-	raw_spin_lock_irqsave(&vg->lock, flags);
+	raw_spin_lock_irqsave(&byt_lock, flags);
 	old_val = readl(reg);
 	if (value)
 		writel(old_val | BYT_LEVEL, reg);
 	else
 		writel(old_val & ~BYT_LEVEL, reg);
-	raw_spin_unlock_irqrestore(&vg->lock, flags);
+	raw_spin_unlock_irqrestore(&byt_lock, flags);
 }
 
 static int byt_gpio_get_direction(struct gpio_chip *chip, unsigned int offset)
@@ -1353,9 +1354,9 @@ static int byt_gpio_get_direction(struct gpio_chip *chip, unsigned int offset)
 	if (!reg)
 		return -EINVAL;
 
-	raw_spin_lock_irqsave(&vg->lock, flags);
+	raw_spin_lock_irqsave(&byt_lock, flags);
 	value = readl(reg);
-	raw_spin_unlock_irqrestore(&vg->lock, flags);
+	raw_spin_unlock_irqrestore(&byt_lock, flags);
 
 	if (!(value & BYT_OUTPUT_EN))
 		return GPIOF_DIR_OUT;
@@ -1398,14 +1399,14 @@ static void byt_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 		const char *label;
 		unsigned int pin;
 
-		raw_spin_lock_irqsave(&vg->lock, flags);
+		raw_spin_lock_irqsave(&byt_lock, flags);
 		pin = vg->soc_data->pins[i].number;
 		reg = byt_gpio_reg(vg, pin, BYT_CONF0_REG);
 		if (!reg) {
 			seq_printf(s,
 				   "Could not retrieve pin %i conf0 reg\n",
 				   pin);
-			raw_spin_unlock_irqrestore(&vg->lock, flags);
+			raw_spin_unlock_irqrestore(&byt_lock, flags);
 			continue;
 		}
 		conf0 = readl(reg);
@@ -1414,11 +1415,11 @@ static void byt_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 		if (!reg) {
 			seq_printf(s,
 				   "Could not retrieve pin %i val reg\n", pin);
-			raw_spin_unlock_irqrestore(&vg->lock, flags);
+			raw_spin_unlock_irqrestore(&byt_lock, flags);
 			continue;
 		}
 		val = readl(reg);
-		raw_spin_unlock_irqrestore(&vg->lock, flags);
+		raw_spin_unlock_irqrestore(&byt_lock, flags);
 
 		comm = byt_get_community(vg, pin);
 		if (!comm) {
@@ -1502,9 +1503,9 @@ static void byt_irq_ack(struct irq_data *d)
 	if (!reg)
 		return;
 
-	raw_spin_lock(&vg->lock);
+	raw_spin_lock(&byt_lock);
 	writel(BIT(offset % 32), reg);
-	raw_spin_unlock(&vg->lock);
+	raw_spin_unlock(&byt_lock);
 }
 
 static void byt_irq_mask(struct irq_data *d)
@@ -1528,7 +1529,7 @@ static void byt_irq_unmask(struct irq_data *d)
 	if (!reg)
 		return;
 
-	raw_spin_lock_irqsave(&vg->lock, flags);
+	raw_spin_lock_irqsave(&byt_lock, flags);
 	value = readl(reg);
 
 	switch (irqd_get_trigger_type(d)) {
@@ -1551,7 +1552,7 @@ static void byt_irq_unmask(struct irq_data *d)
 
 	writel(value, reg);
 
-	raw_spin_unlock_irqrestore(&vg->lock, flags);
+	raw_spin_unlock_irqrestore(&byt_lock, flags);
 }
 
 static int byt_irq_type(struct irq_data *d, unsigned int type)
@@ -1565,7 +1566,7 @@ static int byt_irq_type(struct irq_data *d, unsigned int type)
 	if (!reg || offset >= vg->chip.ngpio)
 		return -EINVAL;
 
-	raw_spin_lock_irqsave(&vg->lock, flags);
+	raw_spin_lock_irqsave(&byt_lock, flags);
 	value = readl(reg);
 
 	WARN(value & BYT_DIRECT_IRQ_EN,
@@ -1587,7 +1588,7 @@ static int byt_irq_type(struct irq_data *d, unsigned int type)
 	else if (type & IRQ_TYPE_LEVEL_MASK)
 		irq_set_handler_locked(d, handle_level_irq);
 
-	raw_spin_unlock_irqrestore(&vg->lock, flags);
+	raw_spin_unlock_irqrestore(&byt_lock, flags);
 
 	return 0;
 }
@@ -1623,9 +1624,9 @@ static void byt_gpio_irq_handler(struct irq_desc *desc)
 			continue;
 		}
 
-		raw_spin_lock(&vg->lock);
+		raw_spin_lock(&byt_lock);
 		pending = readl(reg);
-		raw_spin_unlock(&vg->lock);
+		raw_spin_unlock(&byt_lock);
 		for_each_set_bit(pin, &pending, 32) {
 			virq = irq_find_mapping(vg->chip.irq.domain, base + pin);
 			generic_handle_irq(virq);
@@ -1828,8 +1829,6 @@ static int byt_pinctrl_probe(struct platform_device *pdev)
 		return PTR_ERR(vg->pctl_dev);
 	}
 
-	raw_spin_lock_init(&vg->lock);
-
 	ret = byt_gpio_probe(vg);
 	if (ret)
 		return ret;
@@ -1845,8 +1844,11 @@ static int byt_gpio_suspend(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct byt_gpio *vg = platform_get_drvdata(pdev);
+	unsigned long flags;
 	int i;
 
+	raw_spin_lock_irqsave(&byt_lock, flags);
+
 	for (i = 0; i < vg->soc_data->npins; i++) {
 		void __iomem *reg;
 		u32 value;
@@ -1867,6 +1869,7 @@ static int byt_gpio_suspend(struct device *dev)
 		vg->saved_context[i].val = value;
 	}
 
+	raw_spin_unlock_irqrestore(&byt_lock, flags);
 	return 0;
 }
 
@@ -1874,8 +1877,11 @@ static int byt_gpio_resume(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct byt_gpio *vg = platform_get_drvdata(pdev);
+	unsigned long flags;
 	int i;
 
+	raw_spin_lock_irqsave(&byt_lock, flags);
+
 	for (i = 0; i < vg->soc_data->npins; i++) {
 		void __iomem *reg;
 		u32 value;
@@ -1913,6 +1919,7 @@ static int byt_gpio_resume(struct device *dev)
 		}
 	}
 
+	raw_spin_unlock_irqrestore(&byt_lock, flags);
 	return 0;
 }
 #endif
-- 
2.20.1



