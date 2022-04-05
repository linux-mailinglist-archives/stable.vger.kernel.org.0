Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE924F2DE8
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236189AbiDEI1b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:27:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239494AbiDEIUI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 288B6B18;
        Tue,  5 Apr 2022 01:14:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4AD7B81B92;
        Tue,  5 Apr 2022 08:14:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CBFDC385A0;
        Tue,  5 Apr 2022 08:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146469;
        bh=dVgbqXFyIJgEUdV3/rc2N+Kowlljr3pdXtg4KzLOn70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZFA6ljSorXmXZjANlhPFUZBDqhDqfBRoylZmfnGbyAE94v++PB8WplOf9MzHQdkDb
         wLM6OkkUP6oVFsHDcaFGFpAdonaUgrxbLs6y/KWE/oGFOOMMcPDEOESotqgueoxNgK
         1Bk+wJrLU4wg80u2DqQKfthNDRNY0fGC+J5EyAeY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0775/1126] pinctrl: microchip-sgpio: lock RMW access
Date:   Tue,  5 Apr 2022 09:25:22 +0200
Message-Id: <20220405070430.327838901@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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
index 639f1130e989..666f1e3889e0 100644
--- a/drivers/pinctrl/pinctrl-microchip-sgpio.c
+++ b/drivers/pinctrl/pinctrl-microchip-sgpio.c
@@ -19,6 +19,7 @@
 #include <linux/property.h>
 #include <linux/regmap.h>
 #include <linux/reset.h>
+#include <linux/spinlock.h>
 
 #include "core.h"
 #include "pinconf.h"
@@ -116,6 +117,7 @@ struct sgpio_priv {
 	u32 clock;
 	struct regmap *regs;
 	const struct sgpio_properties *properties;
+	spinlock_t lock;
 };
 
 struct sgpio_port_addr {
@@ -229,6 +231,7 @@ static void sgpio_output_set(struct sgpio_priv *priv,
 			     int value)
 {
 	unsigned int bit = SGPIO_SRC_BITS * addr->bit;
+	unsigned long flags;
 	u32 clr, set;
 
 	switch (priv->properties->arch) {
@@ -247,7 +250,10 @@ static void sgpio_output_set(struct sgpio_priv *priv,
 	default:
 		return;
 	}
+
+	spin_lock_irqsave(&priv->lock, flags);
 	sgpio_clrsetbits(priv, REG_PORT_CONFIG, addr->port, clr, set);
+	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
 static int sgpio_output_get(struct sgpio_priv *priv,
@@ -575,10 +581,13 @@ static void microchip_sgpio_irq_settype(struct irq_data *data,
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
@@ -595,6 +604,8 @@ static void microchip_sgpio_irq_settype(struct irq_data *data,
 
 	/* Possibly re-enable interrupts */
 	sgpio_writel(bank->priv, ena, REG_INT_ENABLE, addr.bit);
+
+	spin_unlock_irqrestore(&bank->priv->lock, flags);
 }
 
 static void microchip_sgpio_irq_setreg(struct irq_data *data,
@@ -605,13 +616,16 @@ static void microchip_sgpio_irq_setreg(struct irq_data *data,
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
@@ -833,6 +847,7 @@ static int microchip_sgpio_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	priv->dev = dev;
+	spin_lock_init(&priv->lock);
 
 	reset = devm_reset_control_get_optional_shared(&pdev->dev, "switch");
 	if (IS_ERR(reset))
-- 
2.34.1



