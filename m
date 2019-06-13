Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 732A043F52
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 17:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732079AbfFMP4H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 11:56:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:38868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731531AbfFMIv0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:51:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 743AB2147A;
        Thu, 13 Jun 2019 08:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415885;
        bh=nRQm/OlsU6qlSd0WMhJZYlZHR7l0FvrSL1hpQ80ECOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BSAIVJr6dwRhrhFBYWTiQXUpOSt4iWaauSkgCfHLkWf+K6yuxp1dkyZ3CnsfsQwaJ
         AMNI80vaF1nOW5wZYuV+P9//rV51MZwMOpd/Nxc34yDHdEZsfXUqvBMH8KYi2/LkNV
         /kjr5pyWD2zsAF7r7kvlggglur8bAeWEZAMc0hS0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrey Smirnov <andrew.smirnov@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Chris Healy <cphealy@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Fabio Estevam <festevam@gmail.com>, linux-gpio@vger.kernel.org,
        linux-imx@nxp.com, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 150/155] gpio: vf610: Do not share irq_chip
Date:   Thu, 13 Jun 2019 10:34:22 +0200
Message-Id: <20190613075701.244231707@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 338aa10750ba24d04beeaf5dc5efc032e5cf343f ]

Fix the warning produced by gpiochip_set_irq_hooks() by allocating a
dedicated IRQ chip per GPIO chip/port.

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc: Chris Healy <cphealy@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Fabio Estevam <festevam@gmail.com>
Cc: linux-gpio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-imx@nxp.com
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-vf610.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/gpio/gpio-vf610.c b/drivers/gpio/gpio-vf610.c
index 541fa6ac399d..7e9451f47efe 100644
--- a/drivers/gpio/gpio-vf610.c
+++ b/drivers/gpio/gpio-vf610.c
@@ -29,6 +29,7 @@ struct fsl_gpio_soc_data {
 
 struct vf610_gpio_port {
 	struct gpio_chip gc;
+	struct irq_chip ic;
 	void __iomem *base;
 	void __iomem *gpio_base;
 	const struct fsl_gpio_soc_data *sdata;
@@ -60,8 +61,6 @@ struct vf610_gpio_port {
 #define PORT_INT_EITHER_EDGE	0xb
 #define PORT_INT_LOGIC_ONE	0xc
 
-static struct irq_chip vf610_gpio_irq_chip;
-
 static const struct fsl_gpio_soc_data imx_data = {
 	.have_paddr = true,
 };
@@ -237,15 +236,6 @@ static int vf610_gpio_irq_set_wake(struct irq_data *d, u32 enable)
 	return 0;
 }
 
-static struct irq_chip vf610_gpio_irq_chip = {
-	.name		= "gpio-vf610",
-	.irq_ack	= vf610_gpio_irq_ack,
-	.irq_mask	= vf610_gpio_irq_mask,
-	.irq_unmask	= vf610_gpio_irq_unmask,
-	.irq_set_type	= vf610_gpio_irq_set_type,
-	.irq_set_wake	= vf610_gpio_irq_set_wake,
-};
-
 static int vf610_gpio_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -253,6 +243,7 @@ static int vf610_gpio_probe(struct platform_device *pdev)
 	struct vf610_gpio_port *port;
 	struct resource *iores;
 	struct gpio_chip *gc;
+	struct irq_chip *ic;
 	int i;
 	int ret;
 
@@ -316,6 +307,14 @@ static int vf610_gpio_probe(struct platform_device *pdev)
 	gc->direction_output = vf610_gpio_direction_output;
 	gc->set = vf610_gpio_set;
 
+	ic = &port->ic;
+	ic->name = "gpio-vf610";
+	ic->irq_ack = vf610_gpio_irq_ack;
+	ic->irq_mask = vf610_gpio_irq_mask;
+	ic->irq_unmask = vf610_gpio_irq_unmask;
+	ic->irq_set_type = vf610_gpio_irq_set_type;
+	ic->irq_set_wake = vf610_gpio_irq_set_wake;
+
 	ret = gpiochip_add_data(gc, port);
 	if (ret < 0)
 		return ret;
@@ -327,14 +326,13 @@ static int vf610_gpio_probe(struct platform_device *pdev)
 	/* Clear the interrupt status register for all GPIO's */
 	vf610_gpio_writel(~0, port->base + PORT_ISFR);
 
-	ret = gpiochip_irqchip_add(gc, &vf610_gpio_irq_chip, 0,
-				   handle_edge_irq, IRQ_TYPE_NONE);
+	ret = gpiochip_irqchip_add(gc, ic, 0, handle_edge_irq, IRQ_TYPE_NONE);
 	if (ret) {
 		dev_err(dev, "failed to add irqchip\n");
 		gpiochip_remove(gc);
 		return ret;
 	}
-	gpiochip_set_chained_irqchip(gc, &vf610_gpio_irq_chip, port->irq,
+	gpiochip_set_chained_irqchip(gc, ic, port->irq,
 				     vf610_gpio_irq_handler);
 
 	return 0;
-- 
2.20.1



