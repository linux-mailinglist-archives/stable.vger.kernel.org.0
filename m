Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9269A1B692F
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729775AbgDWXU5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:20:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48588 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728204AbgDWXGd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:33 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvM-0004cG-Dd; Fri, 24 Apr 2020 00:06:28 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvK-00E6jV-JV; Fri, 24 Apr 2020 00:06:26 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Mika Westerberg" <mika.westerberg@linux.intel.com>,
        "Linus Walleij" <linus.walleij@linaro.org>
Date:   Fri, 24 Apr 2020 00:04:54 +0100
Message-ID: <lsq.1587683028.328988480@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 067/245] pinctrl: baytrail: Clear interrupt
 triggering from pins that are in GPIO mode
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

commit 95f0972c7e4cbf3fc68160131c5ac2f033481d00 upstream.

If the pin is already configured as GPIO and it has any of the triggering
flags set, we may get spurious interrupts depending on the state of the
pin.

Prevent this by clearing the triggering flags on such pins. However, if the
pin is also configured as "direct IRQ" we leave the flags as is. Otherwise
it will prevent interrupts that are routed directly to IO-APIC.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
[bwh: Backported to 3.16:
 - Add definition of BYT_DIRECT_IRQ_EN
 - Adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/pinctrl/pinctrl-baytrail.c
+++ b/drivers/pinctrl/pinctrl-baytrail.c
@@ -44,6 +44,7 @@
 
 /* BYT_CONF0_REG register bits */
 #define BYT_IODEN		BIT(31)
+#define BYT_DIRECT_IRQ_EN	BIT(27)
 #define BYT_TRIG_NEG		BIT(26)
 #define BYT_TRIG_POS		BIT(25)
 #define BYT_TRIG_LVL		BIT(24)
@@ -160,6 +161,19 @@ static void __iomem *byt_gpio_reg(struct
 	return vg->reg_base + reg_offset + reg;
 }
 
+static void byt_gpio_clear_triggering(struct byt_gpio *vg, unsigned offset)
+{
+	void __iomem *reg = byt_gpio_reg(&vg->chip, offset, BYT_CONF0_REG);
+	unsigned long flags;
+	u32 value;
+
+	spin_lock_irqsave(&vg->lock, flags);
+	value = readl(reg);
+	value &= ~(BYT_TRIG_POS | BYT_TRIG_NEG | BYT_TRIG_LVL);
+	writel(value, reg);
+	spin_unlock_irqrestore(&vg->lock, flags);
+}
+
 static u32 byt_get_gpio_mux(struct byt_gpio *vg, unsigned offset)
 {
 	/* SCORE pin 92-93 */
@@ -213,14 +227,8 @@ static int byt_gpio_request(struct gpio_
 static void byt_gpio_free(struct gpio_chip *chip, unsigned offset)
 {
 	struct byt_gpio *vg = to_byt_gpio(chip);
-	void __iomem *reg = byt_gpio_reg(&vg->chip, offset, BYT_CONF0_REG);
-	u32 value;
-
-	/* clear interrupt triggering */
-	value = readl(reg);
-	value &= ~(BYT_TRIG_POS | BYT_TRIG_NEG | BYT_TRIG_LVL);
-	writel(value, reg);
 
+	byt_gpio_clear_triggering(vg, offset);
 	pm_runtime_put(&vg->pdev->dev);
 }
 
@@ -496,6 +504,21 @@ static void byt_gpio_irq_init_hw(struct
 {
 	void __iomem *reg;
 	u32 base, value;
+	int i;
+
+	/*
+	 * Clear interrupt triggers for all pins that are GPIOs and
+	 * do not use direct IRQ mode. This will prevent spurious
+	 * interrupts from misconfigured pins.
+	 */
+	for (i = 0; i < vg->chip.ngpio; i++) {
+		value = readl(byt_gpio_reg(&vg->chip, i, BYT_CONF0_REG));
+		if ((value & BYT_PIN_MUX) == byt_get_gpio_mux(vg, i) &&
+		    !(value & BYT_DIRECT_IRQ_EN)) {
+			byt_gpio_clear_triggering(vg, i);
+			dev_dbg(&vg->pdev->dev, "disabling GPIO %d\n", i);
+		}
+	}
 
 	/* clear interrupt status trigger registers */
 	for (base = 0; base < vg->chip.ngpio; base += 32) {

