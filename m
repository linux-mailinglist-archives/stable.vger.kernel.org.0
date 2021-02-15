Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E04131BC78
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:30:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbhBOP3R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:29:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:44974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230506AbhBOP25 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:28:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFD51600EF;
        Mon, 15 Feb 2021 15:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613402896;
        bh=X7wy2ezr0jlJfmnwzBG6RnKatBfbh3Fb17dTcH/L8KI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QeoG5EJCOUm6Fn2377bkkixvkzcrgGGeVD4ybTkifR67QvcgYYgvUFBV6e0pkAYgo
         hUJxtvBi6QislAE+aDlHhFoWpz8GMVRoAcZfqOIfj2krUhn+yyfo4MYawK1yAwVyAW
         zXYZ3CTlhNZby8X/Tm5Rj+1DNoEj6fNNmtk+DrAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikita Shubin <nikita.shubin@maquefel.me>,
        Alexander Sverdlin <alexander.sverdlin@gmail.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 5.4 02/60] gpio: ep93xx: Fix single irqchip with multi gpiochips
Date:   Mon, 15 Feb 2021 16:26:50 +0100
Message-Id: <20210215152715.476298903@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152715.401453874@linuxfoundation.org>
References: <20210215152715.401453874@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikita Shubin <nikita.shubin@maquefel.me>

commit 28dc10eb77a2db7681b08e3b109764bbe469e347 upstream.

Fixes the following warnings which results in interrupts disabled on
port B/F:

gpio gpiochip1: (B): detected irqchip that is shared with multiple gpiochips: please fix the driver.
gpio gpiochip5: (F): detected irqchip that is shared with multiple gpiochips: please fix the driver.

- added separate irqchip for each interrupt capable gpiochip
- provided unique names for each irqchip

Fixes: d2b091961510 ("gpio: ep93xx: Pass irqchip when adding gpiochip")
Cc: <stable@vger.kernel.org>
Signed-off-by: Nikita Shubin <nikita.shubin@maquefel.me>
Tested-by: Alexander Sverdlin <alexander.sverdlin@gmail.com>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-ep93xx.c |   30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

--- a/drivers/gpio/gpio-ep93xx.c
+++ b/drivers/gpio/gpio-ep93xx.c
@@ -38,6 +38,7 @@
 #define EP93XX_GPIO_F_IRQ_BASE 80
 
 struct ep93xx_gpio_irq_chip {
+	struct irq_chip ic;
 	u8 irq_offset;
 	u8 int_unmasked;
 	u8 int_enabled;
@@ -263,15 +264,6 @@ static int ep93xx_gpio_irq_type(struct i
 	return 0;
 }
 
-static struct irq_chip ep93xx_gpio_irq_chip = {
-	.name		= "GPIO",
-	.irq_ack	= ep93xx_gpio_irq_ack,
-	.irq_mask_ack	= ep93xx_gpio_irq_mask_ack,
-	.irq_mask	= ep93xx_gpio_irq_mask,
-	.irq_unmask	= ep93xx_gpio_irq_unmask,
-	.irq_set_type	= ep93xx_gpio_irq_type,
-};
-
 /*************************************************************************
  * gpiolib interface for EP93xx on-chip GPIOs
  *************************************************************************/
@@ -331,6 +323,15 @@ static int ep93xx_gpio_f_to_irq(struct g
 	return EP93XX_GPIO_F_IRQ_BASE + offset;
 }
 
+static void ep93xx_init_irq_chip(struct device *dev, struct irq_chip *ic)
+{
+	ic->irq_ack = ep93xx_gpio_irq_ack;
+	ic->irq_mask_ack = ep93xx_gpio_irq_mask_ack;
+	ic->irq_mask = ep93xx_gpio_irq_mask;
+	ic->irq_unmask = ep93xx_gpio_irq_unmask;
+	ic->irq_set_type = ep93xx_gpio_irq_type;
+}
+
 static int ep93xx_gpio_add_bank(struct ep93xx_gpio_chip *egc,
 				struct platform_device *pdev,
 				struct ep93xx_gpio *epg,
@@ -352,6 +353,8 @@ static int ep93xx_gpio_add_bank(struct e
 
 	girq = &gc->irq;
 	if (bank->has_irq || bank->has_hierarchical_irq) {
+		struct irq_chip *ic;
+
 		gc->set_config = ep93xx_gpio_set_config;
 		egc->eic = devm_kcalloc(dev, 1,
 					sizeof(*egc->eic),
@@ -359,7 +362,12 @@ static int ep93xx_gpio_add_bank(struct e
 		if (!egc->eic)
 			return -ENOMEM;
 		egc->eic->irq_offset = bank->irq;
-		girq->chip = &ep93xx_gpio_irq_chip;
+		ic = &egc->eic->ic;
+		ic->name = devm_kasprintf(dev, GFP_KERNEL, "gpio-irq-%s", bank->label);
+		if (!ic->name)
+			return -ENOMEM;
+		ep93xx_init_irq_chip(dev, ic);
+		girq->chip = ic;
 	}
 
 	if (bank->has_irq) {
@@ -401,7 +409,7 @@ static int ep93xx_gpio_add_bank(struct e
 			gpio_irq = EP93XX_GPIO_F_IRQ_BASE + i;
 			irq_set_chip_data(gpio_irq, &epg->gc[5]);
 			irq_set_chip_and_handler(gpio_irq,
-						 &ep93xx_gpio_irq_chip,
+						 girq->chip,
 						 handle_level_irq);
 			irq_clear_status_flags(gpio_irq, IRQ_NOREQUEST);
 		}


