Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6B5C50119D
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 16:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345575AbiDNNxq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345139AbiDNNpO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:45:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BA3818392;
        Thu, 14 Apr 2022 06:42:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 378D9612E6;
        Thu, 14 Apr 2022 13:42:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43F3FC385AA;
        Thu, 14 Apr 2022 13:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943768;
        bh=HsY3DRjCKJW8f2PgxoHQHpP1seqO9d0yvMdx77Gtv/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Z7eGdXTfTfL6Wuke0zNN1V0HryM/njw4MwbysSV4XlDviWzwFXw17+LtInH9+Z6f
         J1wc1GSqOfMvkjlkHQs6VOoR4BcuIchSYeRKingmLbUAtlN0X/HvS7hfnxprjFRTjW
         cBeBBWR0pj/1NkxZV1PdaizDvXeE/wE8Nka+cUdc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 275/475] pinctrl: npcm: Fix broken references to chip->parent_device
Date:   Thu, 14 Apr 2022 15:11:00 +0200
Message-Id: <20220414110902.799092604@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit f7e53e2255808ca3abcc8f38d18ad0823425e771 ]

The npcm driver has a bunch of references to the irq_chip parent_device
field, but never sets it.

Fix it by fishing that reference from somewhere else, but it is
obvious that these debug statements were never used. Also remove
an unused field in a local data structure.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Acked-by: Bartosz Golaszewski <brgl@bgdev.pl>
Link: https://lore.kernel.org/r/20220201120310.878267-11-maz@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/nuvoton/pinctrl-npcm7xx.c | 25 +++++++++++------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/pinctrl/nuvoton/pinctrl-npcm7xx.c b/drivers/pinctrl/nuvoton/pinctrl-npcm7xx.c
index 17f909d8b63a..e7dc97e099f2 100644
--- a/drivers/pinctrl/nuvoton/pinctrl-npcm7xx.c
+++ b/drivers/pinctrl/nuvoton/pinctrl-npcm7xx.c
@@ -78,7 +78,6 @@ struct npcm7xx_gpio {
 	struct gpio_chip	gc;
 	int			irqbase;
 	int			irq;
-	void			*priv;
 	struct irq_chip		irq_chip;
 	u32			pinctrl_id;
 	int (*direction_input)(struct gpio_chip *chip, unsigned offset);
@@ -226,7 +225,7 @@ static void npcmgpio_irq_handler(struct irq_desc *desc)
 	chained_irq_enter(chip, desc);
 	sts = ioread32(bank->base + NPCM7XX_GP_N_EVST);
 	en  = ioread32(bank->base + NPCM7XX_GP_N_EVEN);
-	dev_dbg(chip->parent_device, "==> got irq sts %.8x %.8x\n", sts,
+	dev_dbg(bank->gc.parent, "==> got irq sts %.8x %.8x\n", sts,
 		en);
 
 	sts &= en;
@@ -241,33 +240,33 @@ static int npcmgpio_set_irq_type(struct irq_data *d, unsigned int type)
 		gpiochip_get_data(irq_data_get_irq_chip_data(d));
 	unsigned int gpio = BIT(d->hwirq);
 
-	dev_dbg(d->chip->parent_device, "setirqtype: %u.%u = %u\n", gpio,
+	dev_dbg(bank->gc.parent, "setirqtype: %u.%u = %u\n", gpio,
 		d->irq, type);
 	switch (type) {
 	case IRQ_TYPE_EDGE_RISING:
-		dev_dbg(d->chip->parent_device, "edge.rising\n");
+		dev_dbg(bank->gc.parent, "edge.rising\n");
 		npcm_gpio_clr(&bank->gc, bank->base + NPCM7XX_GP_N_EVBE, gpio);
 		npcm_gpio_clr(&bank->gc, bank->base + NPCM7XX_GP_N_POL, gpio);
 		break;
 	case IRQ_TYPE_EDGE_FALLING:
-		dev_dbg(d->chip->parent_device, "edge.falling\n");
+		dev_dbg(bank->gc.parent, "edge.falling\n");
 		npcm_gpio_clr(&bank->gc, bank->base + NPCM7XX_GP_N_EVBE, gpio);
 		npcm_gpio_set(&bank->gc, bank->base + NPCM7XX_GP_N_POL, gpio);
 		break;
 	case IRQ_TYPE_EDGE_BOTH:
-		dev_dbg(d->chip->parent_device, "edge.both\n");
+		dev_dbg(bank->gc.parent, "edge.both\n");
 		npcm_gpio_set(&bank->gc, bank->base + NPCM7XX_GP_N_EVBE, gpio);
 		break;
 	case IRQ_TYPE_LEVEL_LOW:
-		dev_dbg(d->chip->parent_device, "level.low\n");
+		dev_dbg(bank->gc.parent, "level.low\n");
 		npcm_gpio_set(&bank->gc, bank->base + NPCM7XX_GP_N_POL, gpio);
 		break;
 	case IRQ_TYPE_LEVEL_HIGH:
-		dev_dbg(d->chip->parent_device, "level.high\n");
+		dev_dbg(bank->gc.parent, "level.high\n");
 		npcm_gpio_clr(&bank->gc, bank->base + NPCM7XX_GP_N_POL, gpio);
 		break;
 	default:
-		dev_dbg(d->chip->parent_device, "invalid irq type\n");
+		dev_dbg(bank->gc.parent, "invalid irq type\n");
 		return -EINVAL;
 	}
 
@@ -289,7 +288,7 @@ static void npcmgpio_irq_ack(struct irq_data *d)
 		gpiochip_get_data(irq_data_get_irq_chip_data(d));
 	unsigned int gpio = d->hwirq;
 
-	dev_dbg(d->chip->parent_device, "irq_ack: %u.%u\n", gpio, d->irq);
+	dev_dbg(bank->gc.parent, "irq_ack: %u.%u\n", gpio, d->irq);
 	iowrite32(BIT(gpio), bank->base + NPCM7XX_GP_N_EVST);
 }
 
@@ -301,7 +300,7 @@ static void npcmgpio_irq_mask(struct irq_data *d)
 	unsigned int gpio = d->hwirq;
 
 	/* Clear events */
-	dev_dbg(d->chip->parent_device, "irq_mask: %u.%u\n", gpio, d->irq);
+	dev_dbg(bank->gc.parent, "irq_mask: %u.%u\n", gpio, d->irq);
 	iowrite32(BIT(gpio), bank->base + NPCM7XX_GP_N_EVENC);
 }
 
@@ -313,7 +312,7 @@ static void npcmgpio_irq_unmask(struct irq_data *d)
 	unsigned int gpio = d->hwirq;
 
 	/* Enable events */
-	dev_dbg(d->chip->parent_device, "irq_unmask: %u.%u\n", gpio, d->irq);
+	dev_dbg(bank->gc.parent, "irq_unmask: %u.%u\n", gpio, d->irq);
 	iowrite32(BIT(gpio), bank->base + NPCM7XX_GP_N_EVENS);
 }
 
@@ -323,7 +322,7 @@ static unsigned int npcmgpio_irq_startup(struct irq_data *d)
 	unsigned int gpio = d->hwirq;
 
 	/* active-high, input, clear interrupt, enable interrupt */
-	dev_dbg(d->chip->parent_device, "startup: %u.%u\n", gpio, d->irq);
+	dev_dbg(gc->parent, "startup: %u.%u\n", gpio, d->irq);
 	npcmgpio_direction_input(gc, gpio);
 	npcmgpio_irq_ack(d);
 	npcmgpio_irq_unmask(d);
-- 
2.34.1



