Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A13A8F486B
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 12:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390303AbfKHL4l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:56:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:60828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391107AbfKHLp2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:45:28 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0902D222C2;
        Fri,  8 Nov 2019 11:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213527;
        bh=MlEi67HFMVyFzgS1oppUJqq2l7UIJn14A0fj12AmSUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iwKgGOEemQu648HN+q0GdVG75pa6F53HKP63slZIv8YpoRDcUx8LNPUaWZvf8Hp/F
         sbWlkb33wS/3sYIV4aJa/m7mxLBOhoK2ckpCZtnPTqOZsCY25z5w56im9/xjH18A4y
         K2tYud3OTO7G/yKclShcusjYjotw0Hj4aJaGRtB0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ludovic Desroches <ludovic.desroches@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 091/103] pinctrl: at91: don't use the same irqchip with multiple gpiochips
Date:   Fri,  8 Nov 2019 06:42:56 -0500
Message-Id: <20191108114310.14363-91-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114310.14363-1-sashal@kernel.org>
References: <20191108114310.14363-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

