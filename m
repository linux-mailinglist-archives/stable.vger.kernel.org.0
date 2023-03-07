Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0B7C6AEF1A
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbjCGSUl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:20:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232565AbjCGSUU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:20:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78374A029F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:14:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C806661523
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:14:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFFBBC433D2;
        Tue,  7 Mar 2023 18:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212860;
        bh=V/mVsCkVxyrRCYew6Ij99PPw0z4lVOI8Rju9mxfEjos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xNclDZsjyjkI0Gq5ok1g518nTIcgSokGzt6lcOnaDkaio6idKGJgraEMvFtCyLdy0
         q6rayp9XR7dC6cVlnezo69atrJRN6ikJLJ2Bqi1K6D79sJNbwdRu2iI3yljHHzlfRz
         d0rzZIk72hPOHntKQi15GGV79Zmeo3PUIKfHhtZo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 321/885] pinctrl: renesas: rzg2l: Fix configuring the GPIO pins as interrupts
Date:   Tue,  7 Mar 2023 17:54:15 +0100
Message-Id: <20230307170016.101986734@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit 00dfe29887761405ccd23cc0aa07cb86623bb2b7 ]

On the RZ/G2UL SoC we have less number of pins compared to RZ/G2L and also
the pin configs are completely different. This patch makes sure we use the
appropriate pin configs for each SoC (which is passed as part of the OF
data) while configuring the GPIO pin as interrupts instead of using
rzg2l_gpio_configs[] for all the SoCs.

Fixes: bfc69bdbaad1 ("pinctrl: renesas: rzg2l: Add RZ/G2UL support")
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20230102221815.273719-3-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/pinctrl-rzg2l.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/pinctrl/renesas/pinctrl-rzg2l.c b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
index a43824fd9505f..ca6303fc41f98 100644
--- a/drivers/pinctrl/renesas/pinctrl-rzg2l.c
+++ b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
@@ -127,6 +127,7 @@ struct rzg2l_dedicated_configs {
 struct rzg2l_pinctrl_data {
 	const char * const *port_pins;
 	const u32 *port_pin_configs;
+	unsigned int n_ports;
 	struct rzg2l_dedicated_configs *dedicated_pins;
 	unsigned int n_port_pins;
 	unsigned int n_dedicated_pins;
@@ -1122,7 +1123,7 @@ static struct {
 	}
 };
 
-static int rzg2l_gpio_get_gpioint(unsigned int virq)
+static int rzg2l_gpio_get_gpioint(unsigned int virq, const struct rzg2l_pinctrl_data *data)
 {
 	unsigned int gpioint;
 	unsigned int i;
@@ -1131,13 +1132,13 @@ static int rzg2l_gpio_get_gpioint(unsigned int virq)
 	port = virq / 8;
 	bit = virq % 8;
 
-	if (port >= ARRAY_SIZE(rzg2l_gpio_configs) ||
-	    bit >= RZG2L_GPIO_PORT_GET_PINCNT(rzg2l_gpio_configs[port]))
+	if (port >= data->n_ports ||
+	    bit >= RZG2L_GPIO_PORT_GET_PINCNT(data->port_pin_configs[port]))
 		return -EINVAL;
 
 	gpioint = bit;
 	for (i = 0; i < port; i++)
-		gpioint += RZG2L_GPIO_PORT_GET_PINCNT(rzg2l_gpio_configs[i]);
+		gpioint += RZG2L_GPIO_PORT_GET_PINCNT(data->port_pin_configs[i]);
 
 	return gpioint;
 }
@@ -1237,7 +1238,7 @@ static int rzg2l_gpio_child_to_parent_hwirq(struct gpio_chip *gc,
 	unsigned long flags;
 	int gpioint, irq;
 
-	gpioint = rzg2l_gpio_get_gpioint(child);
+	gpioint = rzg2l_gpio_get_gpioint(child, pctrl->data);
 	if (gpioint < 0)
 		return gpioint;
 
@@ -1311,8 +1312,8 @@ static void rzg2l_init_irq_valid_mask(struct gpio_chip *gc,
 		port = offset / 8;
 		bit = offset % 8;
 
-		if (port >= ARRAY_SIZE(rzg2l_gpio_configs) ||
-		    bit >= RZG2L_GPIO_PORT_GET_PINCNT(rzg2l_gpio_configs[port]))
+		if (port >= pctrl->data->n_ports ||
+		    bit >= RZG2L_GPIO_PORT_GET_PINCNT(pctrl->data->port_pin_configs[port]))
 			clear_bit(offset, valid_mask);
 	}
 }
@@ -1517,6 +1518,7 @@ static int rzg2l_pinctrl_probe(struct platform_device *pdev)
 static struct rzg2l_pinctrl_data r9a07g043_data = {
 	.port_pins = rzg2l_gpio_names,
 	.port_pin_configs = r9a07g043_gpio_configs,
+	.n_ports = ARRAY_SIZE(r9a07g043_gpio_configs),
 	.dedicated_pins = rzg2l_dedicated_pins.common,
 	.n_port_pins = ARRAY_SIZE(r9a07g043_gpio_configs) * RZG2L_PINS_PER_PORT,
 	.n_dedicated_pins = ARRAY_SIZE(rzg2l_dedicated_pins.common),
@@ -1525,6 +1527,7 @@ static struct rzg2l_pinctrl_data r9a07g043_data = {
 static struct rzg2l_pinctrl_data r9a07g044_data = {
 	.port_pins = rzg2l_gpio_names,
 	.port_pin_configs = rzg2l_gpio_configs,
+	.n_ports = ARRAY_SIZE(rzg2l_gpio_configs),
 	.dedicated_pins = rzg2l_dedicated_pins.common,
 	.n_port_pins = ARRAY_SIZE(rzg2l_gpio_names),
 	.n_dedicated_pins = ARRAY_SIZE(rzg2l_dedicated_pins.common) +
-- 
2.39.2



