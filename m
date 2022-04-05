Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB134F2CA0
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350483AbiDEJ6k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344012AbiDEJQr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:16:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 850491088;
        Tue,  5 Apr 2022 02:03:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F30FB81BAE;
        Tue,  5 Apr 2022 09:03:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0AF1C385A0;
        Tue,  5 Apr 2022 09:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149404;
        bh=H/Bje5hmDtCNNdNb6F1c/bsu09pr84sD2glYE/vcp/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lGqSZZ+SrwRlUeCRMJlEEP1q3cEeBYRJIVsMrJB5xbl13lXFXMamDolvVuLMckO8k
         u6NEcE4cCkXKRRmY48fDz2xqxiqc+QEIP1WSTaCiUUFhZh8VFscDdB7AvvwzJNc6yW
         lw2NDsAVxxrDiKKI945C/LINjeLtSYfD/G22vLMI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0701/1017] pinctrl: microchip-sgpio: lock RMW access
Date:   Tue,  5 Apr 2022 09:26:54 +0200
Message-Id: <20220405070415.079501816@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

From: Michael Walle <michael@walle.cc>

[ Upstream commit 7996c5f5ec7a20b3f6b8fae93fcf3cb8f1c01743 ]

Protect any RMW access to the registers by a spinlock.

Fixes: 7e5ea974e61c ("pinctrl: pinctrl-microchip-sgpio: Add pinctrl driver for Microsemi Serial GPIO")
Signed-off-by: Michael Walle <michael@walle.cc>
Link: https://lore.kernel.org/r/20220226204507.2511633-2-michael@walle.cc
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-microchip-sgpio.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-microchip-sgpio.c b/drivers/pinctrl/pinctrl-microchip-sgpio.c
index 78765faa245a..dfa374195694 100644
--- a/drivers/pinctrl/pinctrl-microchip-sgpio.c
+++ b/drivers/pinctrl/pinctrl-microchip-sgpio.c
@@ -18,6 +18,7 @@
 #include <linux/platform_device.h>
 #include <linux/property.h>
 #include <linux/reset.h>
+#include <linux/spinlock.h>
 
 #include "core.h"
 #include "pinconf.h"
@@ -115,6 +116,7 @@ struct sgpio_priv {
 	u32 clock;
 	u32 __iomem *regs;
 	const struct sgpio_properties *properties;
+	spinlock_t lock;
 };
 
 struct sgpio_port_addr {
@@ -216,6 +218,7 @@ static void sgpio_output_set(struct sgpio_priv *priv,
 			     int value)
 {
 	unsigned int bit = SGPIO_SRC_BITS * addr->bit;
+	unsigned long flags;
 	u32 clr, set;
 
 	switch (priv->properties->arch) {
@@ -234,7 +237,10 @@ static void sgpio_output_set(struct sgpio_priv *priv,
 	default:
 		return;
 	}
+
+	spin_lock_irqsave(&priv->lock, flags);
 	sgpio_clrsetbits(priv, REG_PORT_CONFIG, addr->port, clr, set);
+	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
 static int sgpio_output_get(struct sgpio_priv *priv,
@@ -562,10 +568,13 @@ static void microchip_sgpio_irq_settype(struct irq_data *data,
 	struct sgpio_bank *bank = gpiochip_get_data(chip);
 	unsigned int gpio = irqd_to_hwirq(data);
 	struct sgpio_port_addr addr;
+	unsigned long flags;
 	u32 ena;
 
 	sgpio_pin_to_addr(bank->priv, gpio, &addr);
 
+	spin_lock_irqsave(&bank->priv->lock, flags);
+
 	/* Disable interrupt while changing type */
 	ena = sgpio_readl(bank->priv, REG_INT_ENABLE, addr.bit);
 	sgpio_writel(bank->priv, ena & ~BIT(addr.port), REG_INT_ENABLE, addr.bit);
@@ -582,6 +591,8 @@ static void microchip_sgpio_irq_settype(struct irq_data *data,
 
 	/* Possibly re-enable interrupts */
 	sgpio_writel(bank->priv, ena, REG_INT_ENABLE, addr.bit);
+
+	spin_unlock_irqrestore(&bank->priv->lock, flags);
 }
 
 static void microchip_sgpio_irq_setreg(struct irq_data *data,
@@ -592,13 +603,16 @@ static void microchip_sgpio_irq_setreg(struct irq_data *data,
 	struct sgpio_bank *bank = gpiochip_get_data(chip);
 	unsigned int gpio = irqd_to_hwirq(data);
 	struct sgpio_port_addr addr;
+	unsigned long flags;
 
 	sgpio_pin_to_addr(bank->priv, gpio, &addr);
 
+	spin_lock_irqsave(&bank->priv->lock, flags);
 	if (clear)
 		sgpio_clrsetbits(bank->priv, reg, addr.bit, BIT(addr.port), 0);
 	else
 		sgpio_clrsetbits(bank->priv, reg, addr.bit, 0, BIT(addr.port));
+	spin_unlock_irqrestore(&bank->priv->lock, flags);
 }
 
 static void microchip_sgpio_irq_mask(struct irq_data *data)
@@ -814,6 +828,7 @@ static int microchip_sgpio_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	priv->dev = dev;
+	spin_lock_init(&priv->lock);
 
 	reset = devm_reset_control_get_optional_shared(&pdev->dev, "switch");
 	if (IS_ERR(reset))
-- 
2.34.1



