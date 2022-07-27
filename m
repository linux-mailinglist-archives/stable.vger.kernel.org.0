Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47C0B583075
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238035AbiG0RiV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:38:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242643AbiG0Rh5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:37:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2657853D14;
        Wed, 27 Jul 2022 09:50:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF2F6B821D5;
        Wed, 27 Jul 2022 16:50:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F9AFC433C1;
        Wed, 27 Jul 2022 16:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940606;
        bh=T6fb930px444ePCCvfwrLitz4OYLqTRU1yJPo9RUxlQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PQQOWPPkQFdX37I1A/feuVrtERy/ABHThbnCSUbsMEQuqb9WWzDi3uQVaE+nLfUbU
         GttUEP9L4NpMWraidrOrMu25QsIENuobotuesrIGOEJK7avcx3Qopg9INolg8Zu+jR
         ZPMxDhFphF7WU2Do+2x/LFPIP2aMQEpawYFwagNQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 083/158] pinctrl: armada-37xx: make irq_lock a raw spinlock to avoid invalid wait context
Date:   Wed, 27 Jul 2022 18:12:27 +0200
Message-Id: <20220727161024.829251550@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 984245b66cf32c494b1e4f95f5ed6ba16b8771eb ]

The irqchip->irq_set_type method is called by __irq_set_trigger() under
the desc->lock raw spinlock.

The armada-37xx implementation, armada_37xx_irq_set_type(), takes a
plain spinlock, the kind that becomes sleepable on RT.

Therefore, this is an invalid locking scheme for which we get a kernel
splat stating just that ("[ BUG: Invalid wait context ]"), because the
context in which the plain spinlock may sleep is atomic due to the raw
spinlock. We need to go raw spinlocks all the way.

Replace the driver's irq_lock with a raw spinlock, to disable preemption
even on RT.

Cc: <stable@vger.kernel.org> # 5.15+
Fixes: 2f227605394b ("pinctrl: armada-37xx: Add irqchip support")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://lore.kernel.org/r/20220716233745.1704677-2-vladimir.oltean@nxp.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c | 38 ++++++++++-----------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
index 226798d9c067..b920dd5237c7 100644
--- a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
@@ -101,7 +101,7 @@ struct armada_37xx_pinctrl {
 	struct device			*dev;
 	struct gpio_chip		gpio_chip;
 	struct irq_chip			irq_chip;
-	spinlock_t			irq_lock;
+	raw_spinlock_t			irq_lock;
 	struct pinctrl_desc		pctl;
 	struct pinctrl_dev		*pctl_dev;
 	struct armada_37xx_pin_group	*groups;
@@ -522,9 +522,9 @@ static void armada_37xx_irq_ack(struct irq_data *d)
 	unsigned long flags;
 
 	armada_37xx_irq_update_reg(&reg, d);
-	spin_lock_irqsave(&info->irq_lock, flags);
+	raw_spin_lock_irqsave(&info->irq_lock, flags);
 	writel(d->mask, info->base + reg);
-	spin_unlock_irqrestore(&info->irq_lock, flags);
+	raw_spin_unlock_irqrestore(&info->irq_lock, flags);
 }
 
 static void armada_37xx_irq_mask(struct irq_data *d)
@@ -535,10 +535,10 @@ static void armada_37xx_irq_mask(struct irq_data *d)
 	unsigned long flags;
 
 	armada_37xx_irq_update_reg(&reg, d);
-	spin_lock_irqsave(&info->irq_lock, flags);
+	raw_spin_lock_irqsave(&info->irq_lock, flags);
 	val = readl(info->base + reg);
 	writel(val & ~d->mask, info->base + reg);
-	spin_unlock_irqrestore(&info->irq_lock, flags);
+	raw_spin_unlock_irqrestore(&info->irq_lock, flags);
 }
 
 static void armada_37xx_irq_unmask(struct irq_data *d)
@@ -549,10 +549,10 @@ static void armada_37xx_irq_unmask(struct irq_data *d)
 	unsigned long flags;
 
 	armada_37xx_irq_update_reg(&reg, d);
-	spin_lock_irqsave(&info->irq_lock, flags);
+	raw_spin_lock_irqsave(&info->irq_lock, flags);
 	val = readl(info->base + reg);
 	writel(val | d->mask, info->base + reg);
-	spin_unlock_irqrestore(&info->irq_lock, flags);
+	raw_spin_unlock_irqrestore(&info->irq_lock, flags);
 }
 
 static int armada_37xx_irq_set_wake(struct irq_data *d, unsigned int on)
@@ -563,14 +563,14 @@ static int armada_37xx_irq_set_wake(struct irq_data *d, unsigned int on)
 	unsigned long flags;
 
 	armada_37xx_irq_update_reg(&reg, d);
-	spin_lock_irqsave(&info->irq_lock, flags);
+	raw_spin_lock_irqsave(&info->irq_lock, flags);
 	val = readl(info->base + reg);
 	if (on)
 		val |= (BIT(d->hwirq % GPIO_PER_REG));
 	else
 		val &= ~(BIT(d->hwirq % GPIO_PER_REG));
 	writel(val, info->base + reg);
-	spin_unlock_irqrestore(&info->irq_lock, flags);
+	raw_spin_unlock_irqrestore(&info->irq_lock, flags);
 
 	return 0;
 }
@@ -582,7 +582,7 @@ static int armada_37xx_irq_set_type(struct irq_data *d, unsigned int type)
 	u32 val, reg = IRQ_POL;
 	unsigned long flags;
 
-	spin_lock_irqsave(&info->irq_lock, flags);
+	raw_spin_lock_irqsave(&info->irq_lock, flags);
 	armada_37xx_irq_update_reg(&reg, d);
 	val = readl(info->base + reg);
 	switch (type) {
@@ -606,11 +606,11 @@ static int armada_37xx_irq_set_type(struct irq_data *d, unsigned int type)
 		break;
 	}
 	default:
-		spin_unlock_irqrestore(&info->irq_lock, flags);
+		raw_spin_unlock_irqrestore(&info->irq_lock, flags);
 		return -EINVAL;
 	}
 	writel(val, info->base + reg);
-	spin_unlock_irqrestore(&info->irq_lock, flags);
+	raw_spin_unlock_irqrestore(&info->irq_lock, flags);
 
 	return 0;
 }
@@ -625,7 +625,7 @@ static int armada_37xx_edge_both_irq_swap_pol(struct armada_37xx_pinctrl *info,
 
 	regmap_read(info->regmap, INPUT_VAL + 4*reg_idx, &l);
 
-	spin_lock_irqsave(&info->irq_lock, flags);
+	raw_spin_lock_irqsave(&info->irq_lock, flags);
 	p = readl(info->base + IRQ_POL + 4 * reg_idx);
 	if ((p ^ l) & (1 << bit_num)) {
 		/*
@@ -646,7 +646,7 @@ static int armada_37xx_edge_both_irq_swap_pol(struct armada_37xx_pinctrl *info,
 		ret = -1;
 	}
 
-	spin_unlock_irqrestore(&info->irq_lock, flags);
+	raw_spin_unlock_irqrestore(&info->irq_lock, flags);
 	return ret;
 }
 
@@ -663,11 +663,11 @@ static void armada_37xx_irq_handler(struct irq_desc *desc)
 		u32 status;
 		unsigned long flags;
 
-		spin_lock_irqsave(&info->irq_lock, flags);
+		raw_spin_lock_irqsave(&info->irq_lock, flags);
 		status = readl_relaxed(info->base + IRQ_STATUS + 4 * i);
 		/* Manage only the interrupt that was enabled */
 		status &= readl_relaxed(info->base + IRQ_EN + 4 * i);
-		spin_unlock_irqrestore(&info->irq_lock, flags);
+		raw_spin_unlock_irqrestore(&info->irq_lock, flags);
 		while (status) {
 			u32 hwirq = ffs(status) - 1;
 			u32 virq = irq_find_mapping(d, hwirq +
@@ -694,12 +694,12 @@ static void armada_37xx_irq_handler(struct irq_desc *desc)
 
 update_status:
 			/* Update status in case a new IRQ appears */
-			spin_lock_irqsave(&info->irq_lock, flags);
+			raw_spin_lock_irqsave(&info->irq_lock, flags);
 			status = readl_relaxed(info->base +
 					       IRQ_STATUS + 4 * i);
 			/* Manage only the interrupt that was enabled */
 			status &= readl_relaxed(info->base + IRQ_EN + 4 * i);
-			spin_unlock_irqrestore(&info->irq_lock, flags);
+			raw_spin_unlock_irqrestore(&info->irq_lock, flags);
 		}
 	}
 	chained_irq_exit(chip, desc);
@@ -730,7 +730,7 @@ static int armada_37xx_irqchip_register(struct platform_device *pdev,
 	struct device *dev = &pdev->dev;
 	unsigned int i, nr_irq_parent;
 
-	spin_lock_init(&info->irq_lock);
+	raw_spin_lock_init(&info->irq_lock);
 
 	nr_irq_parent = of_irq_count(np);
 	if (!nr_irq_parent) {
-- 
2.35.1



