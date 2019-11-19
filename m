Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9D55101729
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731446AbfKSFtH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:49:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:45756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730779AbfKSFtH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:49:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05DDF20721;
        Tue, 19 Nov 2019 05:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142546;
        bh=MlEi67HFMVyFzgS1oppUJqq2l7UIJn14A0fj12AmSUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SeNO5LojCQ4TUtNPd5rFjZ225IoS6Jzx2gLQPw8K3DnDORC2VCsfEmj56dJLQ9Vlf
         fmC2L/fwKjhyUIALt8teihhwBiB4hYaLZ+eEbGyEeyWUPYFLZM2wqhiqUfhh5CqlBf
         wF2LDaQ50DtJxZ9PdyH+O6jyWtdxl1RJtyLAe82I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 117/239] pinctrl: at91: dont use the same irqchip with multiple gpiochips
Date:   Tue, 19 Nov 2019 06:18:37 +0100
Message-Id: <20191119051329.066879385@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ludovic Desroches <ludovic.desroches@microchip.com>

[ Upstream commit 0c3dfa176912b5f87732545598200fb55e9c1978 ]

Sharing the same irqchip with multiple gpiochips is not a good
practice. For instance, when installing hooks, we change the state
of the irqchip. The initial state of the irqchip for the second
gpiochip to register is then disrupted.

Signed-off-by: Ludovic Desroches <ludovic.desroches@microchip.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-at91.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
index 569bc28cb9097..404711f0985aa 100644
--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -1566,16 +1566,6 @@ void at91_pinctrl_gpio_resume(void)
 #define gpio_irq_set_wake	NULL
 #endif /* CONFIG_PM */
 
-static struct irq_chip gpio_irqchip = {
-	.name		= "GPIO",
-	.irq_ack	= gpio_irq_ack,
-	.irq_disable	= gpio_irq_mask,
-	.irq_mask	= gpio_irq_mask,
-	.irq_unmask	= gpio_irq_unmask,
-	/* .irq_set_type is set dynamically */
-	.irq_set_wake	= gpio_irq_set_wake,
-};
-
 static void gpio_irq_handler(struct irq_desc *desc)
 {
 	struct irq_chip *chip = irq_desc_get_chip(desc);
@@ -1616,12 +1606,22 @@ static int at91_gpio_of_irq_setup(struct platform_device *pdev,
 	struct gpio_chip	*gpiochip_prev = NULL;
 	struct at91_gpio_chip   *prev = NULL;
 	struct irq_data		*d = irq_get_irq_data(at91_gpio->pioc_virq);
+	struct irq_chip		*gpio_irqchip;
 	int ret, i;
 
+	gpio_irqchip = devm_kzalloc(&pdev->dev, sizeof(*gpio_irqchip), GFP_KERNEL);
+	if (!gpio_irqchip)
+		return -ENOMEM;
+
 	at91_gpio->pioc_hwirq = irqd_to_hwirq(d);
 
-	/* Setup proper .irq_set_type function */
-	gpio_irqchip.irq_set_type = at91_gpio->ops->irq_type;
+	gpio_irqchip->name = "GPIO";
+	gpio_irqchip->irq_ack = gpio_irq_ack;
+	gpio_irqchip->irq_disable = gpio_irq_mask;
+	gpio_irqchip->irq_mask = gpio_irq_mask;
+	gpio_irqchip->irq_unmask = gpio_irq_unmask;
+	gpio_irqchip->irq_set_wake = gpio_irq_set_wake,
+	gpio_irqchip->irq_set_type = at91_gpio->ops->irq_type;
 
 	/* Disable irqs of this PIO controller */
 	writel_relaxed(~0, at91_gpio->regbase + PIO_IDR);
@@ -1632,7 +1632,7 @@ static int at91_gpio_of_irq_setup(struct platform_device *pdev,
 	 * interrupt.
 	 */
 	ret = gpiochip_irqchip_add(&at91_gpio->chip,
-				   &gpio_irqchip,
+				   gpio_irqchip,
 				   0,
 				   handle_edge_irq,
 				   IRQ_TYPE_NONE);
@@ -1650,7 +1650,7 @@ static int at91_gpio_of_irq_setup(struct platform_device *pdev,
 	if (!gpiochip_prev) {
 		/* Then register the chain on the parent IRQ */
 		gpiochip_set_chained_irqchip(&at91_gpio->chip,
-					     &gpio_irqchip,
+					     gpio_irqchip,
 					     at91_gpio->pioc_virq,
 					     gpio_irq_handler);
 		return 0;
-- 
2.20.1



