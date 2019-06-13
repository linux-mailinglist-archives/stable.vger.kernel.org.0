Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73D614427F
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732826AbfFMQXD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:23:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:55352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731033AbfFMIh4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:37:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D405B2146F;
        Thu, 13 Jun 2019 08:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415075;
        bh=/a0mpmk+F++Irb56hdEMgOxXqHCddPGLkXPRjC/8KCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jZqhXu/lwICh17TQReV4DrsFmZDObQ2hjBAUQbh2ZUMMFF3ZuyTeOkCRYMQ+WmaBp
         2ixYS/R7WYNIS0eb1C9gmxd4iP35wG7Dyia9N56MbcCkK5pFbKoBOKSAnZyy7HbhqP
         XL4MZddvNqHcDKRI6MRpWAPEtlbflbD98Lp0aNws=
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
Subject: [PATCH 4.14 77/81] gpio: vf610: Do not share irq_chip
Date:   Thu, 13 Jun 2019 10:34:00 +0200
Message-Id: <20190613075654.646180331@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075649.074682929@linuxfoundation.org>
References: <20190613075649.074682929@linuxfoundation.org>
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
index 1309b444720e..3210fba16a9b 100644
--- a/drivers/gpio/gpio-vf610.c
+++ b/drivers/gpio/gpio-vf610.c
@@ -37,6 +37,7 @@ struct fsl_gpio_soc_data {
 
 struct vf610_gpio_port {
 	struct gpio_chip gc;
+	struct irq_chip ic;
 	void __iomem *base;
 	void __iomem *gpio_base;
 	const struct fsl_gpio_soc_data *sdata;
@@ -66,8 +67,6 @@ struct vf610_gpio_port {
 #define PORT_INT_EITHER_EDGE	0xb
 #define PORT_INT_LOGIC_ONE	0xc
 
-static struct irq_chip vf610_gpio_irq_chip;
-
 static const struct fsl_gpio_soc_data imx_data = {
 	.have_paddr = true,
 };
@@ -243,15 +242,6 @@ static int vf610_gpio_irq_set_wake(struct irq_data *d, u32 enable)
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
 	const struct of_device_id *of_id = of_match_device(vf610_gpio_dt_ids,
@@ -261,6 +251,7 @@ static int vf610_gpio_probe(struct platform_device *pdev)
 	struct vf610_gpio_port *port;
 	struct resource *iores;
 	struct gpio_chip *gc;
+	struct irq_chip *ic;
 	int i;
 	int ret;
 
@@ -297,6 +288,14 @@ static int vf610_gpio_probe(struct platform_device *pdev)
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
@@ -308,14 +307,13 @@ static int vf610_gpio_probe(struct platform_device *pdev)
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



