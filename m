Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 231A11482FD
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:33:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391905AbgAXLcb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:32:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:51434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391819AbgAXLca (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:32:30 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F270520718;
        Fri, 24 Jan 2020 11:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865549;
        bh=hJHUkhKYduhv6dBZeWWs0w25OX+uLxbERi1ZClPiDyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=trZbseqiVklPhiyA8ELwfRrf37ohWCBHdUfas0SL9ceIEttjvOz5jwUOuLL0guyap
         j+cLn7OVNp4216Ib4O/HGp5GrikL6md9Jq5k56jiLlVn3/VkoqxyCsAvNY0pL/YQxL
         I2o+5/6KuVIAUQN/Xa21Gqmx7k+cvHQdys4Rym64=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Jin <li.jin@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 560/639] pinctrl: iproc-gpio: Fix incorrect pinconf configurations
Date:   Fri, 24 Jan 2020 10:32:10 +0100
Message-Id: <20200124093159.462589404@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Jin <li.jin@broadcom.com>

[ Upstream commit 398a1f50e3c731586182fd52b834103b0aa2f826 ]

Fix drive strength for AON/CRMU controller; fix pull-up/down setting
for CCM/CDRU controller.

Fixes: 616043d58a89 ("pinctrl: Rename gpio driver from cygnus to iproc")
Signed-off-by: Li Jin <li.jin@broadcom.com>
Link: https://lore.kernel.org/r/1567054348-19685-2-git-send-email-srinath.mannam@broadcom.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/bcm/pinctrl-iproc-gpio.c | 96 +++++++++++++++++++-----
 1 file changed, 77 insertions(+), 19 deletions(-)

diff --git a/drivers/pinctrl/bcm/pinctrl-iproc-gpio.c b/drivers/pinctrl/bcm/pinctrl-iproc-gpio.c
index b70058caee504..20b9864adce06 100644
--- a/drivers/pinctrl/bcm/pinctrl-iproc-gpio.c
+++ b/drivers/pinctrl/bcm/pinctrl-iproc-gpio.c
@@ -54,8 +54,12 @@
 /* drive strength control for ASIU GPIO */
 #define IPROC_GPIO_ASIU_DRV0_CTRL_OFFSET 0x58
 
-/* drive strength control for CCM/CRMU (AON) GPIO */
-#define IPROC_GPIO_DRV0_CTRL_OFFSET  0x00
+/* pinconf for CCM GPIO */
+#define IPROC_GPIO_PULL_DN_OFFSET   0x10
+#define IPROC_GPIO_PULL_UP_OFFSET   0x14
+
+/* pinconf for CRMU(aon) GPIO and CCM GPIO*/
+#define IPROC_GPIO_DRV_CTRL_OFFSET  0x00
 
 #define GPIO_BANK_SIZE 0x200
 #define NGPIOS_PER_BANK 32
@@ -76,6 +80,12 @@ enum iproc_pinconf_param {
 	IPROC_PINCON_MAX,
 };
 
+enum iproc_pinconf_ctrl_type {
+	IOCTRL_TYPE_AON = 1,
+	IOCTRL_TYPE_CDRU,
+	IOCTRL_TYPE_INVALID,
+};
+
 /*
  * Iproc GPIO core
  *
@@ -100,6 +110,7 @@ struct iproc_gpio {
 
 	void __iomem *base;
 	void __iomem *io_ctrl;
+	enum iproc_pinconf_ctrl_type io_ctrl_type;
 
 	raw_spinlock_t lock;
 
@@ -461,20 +472,44 @@ static const struct pinctrl_ops iproc_pctrl_ops = {
 static int iproc_gpio_set_pull(struct iproc_gpio *chip, unsigned gpio,
 				bool disable, bool pull_up)
 {
+	void __iomem *base;
 	unsigned long flags;
+	unsigned int shift;
+	u32 val_1, val_2;
 
 	raw_spin_lock_irqsave(&chip->lock, flags);
-
-	if (disable) {
-		iproc_set_bit(chip, IPROC_GPIO_RES_EN_OFFSET, gpio, false);
+	if (chip->io_ctrl_type == IOCTRL_TYPE_CDRU) {
+		base = chip->io_ctrl;
+		shift = IPROC_GPIO_SHIFT(gpio);
+
+		val_1 = readl(base + IPROC_GPIO_PULL_UP_OFFSET);
+		val_2 = readl(base + IPROC_GPIO_PULL_DN_OFFSET);
+		if (disable) {
+			/* no pull-up or pull-down */
+			val_1 &= ~BIT(shift);
+			val_2 &= ~BIT(shift);
+		} else if (pull_up) {
+			val_1 |= BIT(shift);
+			val_2 &= ~BIT(shift);
+		} else {
+			val_1 &= ~BIT(shift);
+			val_2 |= BIT(shift);
+		}
+		writel(val_1, base + IPROC_GPIO_PULL_UP_OFFSET);
+		writel(val_2, base + IPROC_GPIO_PULL_DN_OFFSET);
 	} else {
-		iproc_set_bit(chip, IPROC_GPIO_PAD_RES_OFFSET, gpio,
-			       pull_up);
-		iproc_set_bit(chip, IPROC_GPIO_RES_EN_OFFSET, gpio, true);
+		if (disable) {
+			iproc_set_bit(chip, IPROC_GPIO_RES_EN_OFFSET, gpio,
+				      false);
+		} else {
+			iproc_set_bit(chip, IPROC_GPIO_PAD_RES_OFFSET, gpio,
+				      pull_up);
+			iproc_set_bit(chip, IPROC_GPIO_RES_EN_OFFSET, gpio,
+				      true);
+		}
 	}
 
 	raw_spin_unlock_irqrestore(&chip->lock, flags);
-
 	dev_dbg(chip->dev, "gpio:%u set pullup:%d\n", gpio, pull_up);
 
 	return 0;
@@ -483,14 +518,35 @@ static int iproc_gpio_set_pull(struct iproc_gpio *chip, unsigned gpio,
 static void iproc_gpio_get_pull(struct iproc_gpio *chip, unsigned gpio,
 				 bool *disable, bool *pull_up)
 {
+	void __iomem *base;
 	unsigned long flags;
+	unsigned int shift;
+	u32 val_1, val_2;
 
 	raw_spin_lock_irqsave(&chip->lock, flags);
-	*disable = !iproc_get_bit(chip, IPROC_GPIO_RES_EN_OFFSET, gpio);
-	*pull_up = iproc_get_bit(chip, IPROC_GPIO_PAD_RES_OFFSET, gpio);
+	if (chip->io_ctrl_type == IOCTRL_TYPE_CDRU) {
+		base = chip->io_ctrl;
+		shift = IPROC_GPIO_SHIFT(gpio);
+
+		val_1 = readl(base + IPROC_GPIO_PULL_UP_OFFSET) & BIT(shift);
+		val_2 = readl(base + IPROC_GPIO_PULL_DN_OFFSET) & BIT(shift);
+
+		*pull_up = val_1 ? true : false;
+		*disable = (val_1 | val_2) ? false : true;
+
+	} else {
+		*disable = !iproc_get_bit(chip, IPROC_GPIO_RES_EN_OFFSET, gpio);
+		*pull_up = iproc_get_bit(chip, IPROC_GPIO_PAD_RES_OFFSET, gpio);
+	}
 	raw_spin_unlock_irqrestore(&chip->lock, flags);
 }
 
+#define DRV_STRENGTH_OFFSET(gpio, bit, type)  ((type) == IOCTRL_TYPE_AON ? \
+	((2 - (bit)) * 4 + IPROC_GPIO_DRV_CTRL_OFFSET) : \
+	((type) == IOCTRL_TYPE_CDRU) ? \
+	((bit) * 4 + IPROC_GPIO_DRV_CTRL_OFFSET) : \
+	((bit) * 4 + IPROC_GPIO_REG(gpio, IPROC_GPIO_ASIU_DRV0_CTRL_OFFSET)))
+
 static int iproc_gpio_set_strength(struct iproc_gpio *chip, unsigned gpio,
 				    unsigned strength)
 {
@@ -505,11 +561,8 @@ static int iproc_gpio_set_strength(struct iproc_gpio *chip, unsigned gpio,
 
 	if (chip->io_ctrl) {
 		base = chip->io_ctrl;
-		offset = IPROC_GPIO_DRV0_CTRL_OFFSET;
 	} else {
 		base = chip->base;
-		offset = IPROC_GPIO_REG(gpio,
-					 IPROC_GPIO_ASIU_DRV0_CTRL_OFFSET);
 	}
 
 	shift = IPROC_GPIO_SHIFT(gpio);
@@ -520,11 +573,11 @@ static int iproc_gpio_set_strength(struct iproc_gpio *chip, unsigned gpio,
 	raw_spin_lock_irqsave(&chip->lock, flags);
 	strength = (strength / 2) - 1;
 	for (i = 0; i < GPIO_DRV_STRENGTH_BITS; i++) {
+		offset = DRV_STRENGTH_OFFSET(gpio, i, chip->io_ctrl_type);
 		val = readl(base + offset);
 		val &= ~BIT(shift);
 		val |= ((strength >> i) & 0x1) << shift;
 		writel(val, base + offset);
-		offset += 4;
 	}
 	raw_spin_unlock_irqrestore(&chip->lock, flags);
 
@@ -541,11 +594,8 @@ static int iproc_gpio_get_strength(struct iproc_gpio *chip, unsigned gpio,
 
 	if (chip->io_ctrl) {
 		base = chip->io_ctrl;
-		offset = IPROC_GPIO_DRV0_CTRL_OFFSET;
 	} else {
 		base = chip->base;
-		offset = IPROC_GPIO_REG(gpio,
-					 IPROC_GPIO_ASIU_DRV0_CTRL_OFFSET);
 	}
 
 	shift = IPROC_GPIO_SHIFT(gpio);
@@ -553,10 +603,10 @@ static int iproc_gpio_get_strength(struct iproc_gpio *chip, unsigned gpio,
 	raw_spin_lock_irqsave(&chip->lock, flags);
 	*strength = 0;
 	for (i = 0; i < GPIO_DRV_STRENGTH_BITS; i++) {
+		offset = DRV_STRENGTH_OFFSET(gpio, i, chip->io_ctrl_type);
 		val = readl(base + offset) & BIT(shift);
 		val >>= shift;
 		*strength += (val << i);
-		offset += 4;
 	}
 
 	/* convert to mA */
@@ -734,6 +784,7 @@ static int iproc_gpio_probe(struct platform_device *pdev)
 	u32 ngpios, pinconf_disable_mask = 0;
 	int irq, ret;
 	bool no_pinconf = false;
+	enum iproc_pinconf_ctrl_type io_ctrl_type = IOCTRL_TYPE_INVALID;
 
 	/* NSP does not support drive strength config */
 	if (of_device_is_compatible(dev->of_node, "brcm,iproc-nsp-gpio"))
@@ -764,8 +815,15 @@ static int iproc_gpio_probe(struct platform_device *pdev)
 			dev_err(dev, "unable to map I/O memory\n");
 			return PTR_ERR(chip->io_ctrl);
 		}
+		if (of_device_is_compatible(dev->of_node,
+					    "brcm,cygnus-ccm-gpio"))
+			io_ctrl_type = IOCTRL_TYPE_CDRU;
+		else
+			io_ctrl_type = IOCTRL_TYPE_AON;
 	}
 
+	chip->io_ctrl_type = io_ctrl_type;
+
 	if (of_property_read_u32(dev->of_node, "ngpios", &ngpios)) {
 		dev_err(&pdev->dev, "missing ngpios DT property\n");
 		return -ENODEV;
-- 
2.20.1



