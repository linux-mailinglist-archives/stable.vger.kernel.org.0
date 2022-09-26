Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFDD45EA114
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236201AbiIZKpO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236497AbiIZKny (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:43:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6EAD303DE;
        Mon, 26 Sep 2022 03:25:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED0DFB80682;
        Mon, 26 Sep 2022 10:25:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 450A7C433D6;
        Mon, 26 Sep 2022 10:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187903;
        bh=QGczFgAHvbSQI3rwphu6DQAbiEnCcEoB8hmQoCSCrjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qdGWieqzRJ44Q35OXgZDDknfU2PiAsQCSVYg7sfaYNnKy92VUiI76lXvSXx3/Y3Lw
         GjwxwDKWtUVTFB1vlZ+eK3SgXtCL+Dlon7X4LGBVFyohETT/LvR1pML29HEM7s5mU1
         ryy7CDDz+oqB7CV9soeWdetaqO6buvbQxYDOR5C4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 097/120] gpio: ixp4xx: Make irqchip immutable
Date:   Mon, 26 Sep 2022 12:12:10 +0200
Message-Id: <20220926100754.551266309@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100750.519221159@linuxfoundation.org>
References: <20220926100750.519221159@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 94e9bc73d85aa6ecfe249e985ff57abe0ab35f34 ]

This turns the IXP4xx GPIO irqchip into an immutable
irqchip, a bit different from the standard template due
to being hierarchical.

Tested on the IXP4xx which uses drivers/ata/pata_ixp4xx_cf.c
for a rootfs on compact flash with IRQs from this GPIO
block to the CF ATA controller.

Cc: Marc Zyngier <maz@kernel.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-ixp4xx.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-ixp4xx.c b/drivers/gpio/gpio-ixp4xx.c
index b3b050604e0b..6bd047e2ca46 100644
--- a/drivers/gpio/gpio-ixp4xx.c
+++ b/drivers/gpio/gpio-ixp4xx.c
@@ -67,6 +67,14 @@ static void ixp4xx_gpio_irq_ack(struct irq_data *d)
 	__raw_writel(BIT(d->hwirq), g->base + IXP4XX_REG_GPIS);
 }
 
+static void ixp4xx_gpio_mask_irq(struct irq_data *d)
+{
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+
+	irq_chip_mask_parent(d);
+	gpiochip_disable_irq(gc, d->hwirq);
+}
+
 static void ixp4xx_gpio_irq_unmask(struct irq_data *d)
 {
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
@@ -76,6 +84,7 @@ static void ixp4xx_gpio_irq_unmask(struct irq_data *d)
 	if (!(g->irq_edge & BIT(d->hwirq)))
 		ixp4xx_gpio_irq_ack(d);
 
+	gpiochip_enable_irq(gc, d->hwirq);
 	irq_chip_unmask_parent(d);
 }
 
@@ -153,12 +162,14 @@ static int ixp4xx_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 	return irq_chip_set_type_parent(d, IRQ_TYPE_LEVEL_HIGH);
 }
 
-static struct irq_chip ixp4xx_gpio_irqchip = {
+static const struct irq_chip ixp4xx_gpio_irqchip = {
 	.name = "IXP4GPIO",
 	.irq_ack = ixp4xx_gpio_irq_ack,
-	.irq_mask = irq_chip_mask_parent,
+	.irq_mask = ixp4xx_gpio_mask_irq,
 	.irq_unmask = ixp4xx_gpio_irq_unmask,
 	.irq_set_type = ixp4xx_gpio_irq_set_type,
+	.flags = IRQCHIP_IMMUTABLE,
+	GPIOCHIP_IRQ_RESOURCE_HELPERS,
 };
 
 static int ixp4xx_gpio_child_to_parent_hwirq(struct gpio_chip *gc,
@@ -282,7 +293,7 @@ static int ixp4xx_gpio_probe(struct platform_device *pdev)
 	g->gc.owner = THIS_MODULE;
 
 	girq = &g->gc.irq;
-	girq->chip = &ixp4xx_gpio_irqchip;
+	gpio_irq_chip_set_chip(girq, &ixp4xx_gpio_irqchip);
 	girq->fwnode = g->fwnode;
 	girq->parent_domain = parent;
 	girq->child_to_parent_hwirq = ixp4xx_gpio_child_to_parent_hwirq;
-- 
2.35.1



