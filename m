Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4D11B6925
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728309AbgDWXU1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:20:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48642 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728220AbgDWXGd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:33 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvM-0004bO-0O; Fri, 24 Apr 2020 00:06:28 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvK-00E6jf-Lr; Fri, 24 Apr 2020 00:06:26 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Mika Westerberg" <mika.westerberg@linux.intel.com>,
        "Linus Walleij" <linus.walleij@linaro.org>
Date:   Fri, 24 Apr 2020 00:04:56 +0100
Message-ID: <lsq.1587683028.924632410@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 069/245] pinctrl: baytrail: Serialize all register access
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

commit 39ce8150a079e3ae6ed9abf26d7918a558ef7c19 upstream.

There is a hardware issue in Intel Baytrail where concurrent GPIO register
access might result reads of 0xffffffff and writes might get dropped
completely.

Prevent this from happening by taking the serializing lock in all places
where it is possible that more than one thread might be accessing the
hardware concurrently.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
[bwh: Backported to 3.16: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/pinctrl/pinctrl-baytrail.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

--- a/drivers/pinctrl/pinctrl-baytrail.c
+++ b/drivers/pinctrl/pinctrl-baytrail.c
@@ -194,6 +194,9 @@ static int byt_gpio_request(struct gpio_
 	struct byt_gpio *vg = to_byt_gpio(chip);
 	void __iomem *reg = byt_gpio_reg(chip, offset, BYT_CONF0_REG);
 	u32 value, gpio_mux;
+	unsigned long flags;
+
+	spin_lock_irqsave(&vg->lock, flags);
 
 	/*
 	 * In most cases, func pin mux 000 means GPIO function.
@@ -207,18 +210,16 @@ static int byt_gpio_request(struct gpio_
 	value = readl(reg) & BYT_PIN_MUX;
 	gpio_mux = byt_get_gpio_mux(vg, offset);
 	if (WARN_ON(gpio_mux != value)) {
-		unsigned long flags;
-
-		spin_lock_irqsave(&vg->lock, flags);
 		value = readl(reg) & ~BYT_PIN_MUX;
 		value |= gpio_mux;
 		writel(value, reg);
-		spin_unlock_irqrestore(&vg->lock, flags);
 
 		dev_warn(&vg->pdev->dev,
 			 "pin %u forcibly re-configured as GPIO\n", offset);
 	}
 
+	spin_unlock_irqrestore(&vg->lock, flags);
+
 	pm_runtime_get(&vg->pdev->dev);
 
 	return 0;
@@ -266,7 +267,15 @@ static int byt_irq_type(struct irq_data
 static int byt_gpio_get(struct gpio_chip *chip, unsigned offset)
 {
 	void __iomem *reg = byt_gpio_reg(chip, offset, BYT_VAL_REG);
-	return readl(reg) & BYT_LEVEL;
+	struct byt_gpio *vg = to_byt_gpio(chip);
+	unsigned long flags;
+	u32 val;
+
+	spin_lock_irqsave(&vg->lock, flags);
+	val = readl(reg);
+	spin_unlock_irqrestore(&vg->lock, flags);
+
+	return val & BYT_LEVEL;
 }
 
 static void byt_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
@@ -435,8 +444,10 @@ static void byt_irq_ack(struct irq_data
 	unsigned offset = irqd_to_hwirq(d);
 	void __iomem *reg;
 
+	spin_lock(&vg->lock);
 	reg = byt_gpio_reg(&vg->chip, offset, BYT_INT_STAT_REG);
 	writel(BIT(offset % 32), reg);
+	spin_unlock(&vg->lock);
 }
 
 static void byt_irq_unmask(struct irq_data *d)

