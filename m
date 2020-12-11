Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6892D82BA
	for <lists+stable@lfdr.de>; Sat, 12 Dec 2020 00:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407158AbgLKX33 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Dec 2020 18:29:29 -0500
Received: from aposti.net ([89.234.176.197]:56376 "EHLO aposti.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407132AbgLKX3S (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Dec 2020 18:29:18 -0500
From:   Paul Cercueil <paul@crapouillou.net>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Zhou Yanjie <zhouyanjie@zoho.com>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] pinctrl: ingenic: Fix JZ4760 support
Date:   Fri, 11 Dec 2020 23:28:09 +0000
Message-Id: <20201211232810.261565-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

- JZ4760 and JZ4760B have a similar register layout as the JZ4740, and
  don't use the new register layout, which was introduced with the
  JZ4770 SoC and not the JZ4760 or JZ4760B SoCs.

- The JZ4740 code path only expected two function modes to be
  configurable for each pin, and wouldn't work with more than two. Fix
  it for the JZ4760, which has four configurable function modes.

Fixes: 0257595a5cf4 ("pinctrl: Ingenic: Add pinctrl driver for JZ4760 and JZ4760B.")
Cc: <stable@vger.kernel.org> # 5.3
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
---
 drivers/pinctrl/pinctrl-ingenic.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-ingenic.c b/drivers/pinctrl/pinctrl-ingenic.c
index 11f1bc90632d..a7804feb58c7 100644
--- a/drivers/pinctrl/pinctrl-ingenic.c
+++ b/drivers/pinctrl/pinctrl-ingenic.c
@@ -1689,7 +1689,7 @@ static inline bool ingenic_gpio_get_value(struct ingenic_gpio_chip *jzgc,
 static void ingenic_gpio_set_value(struct ingenic_gpio_chip *jzgc,
 				   u8 offset, int value)
 {
-	if (jzgc->jzpc->info->version >= ID_JZ4760)
+	if (jzgc->jzpc->info->version >= ID_JZ4770)
 		ingenic_gpio_set_bit(jzgc, JZ4760_GPIO_PAT0, offset, !!value);
 	else
 		ingenic_gpio_set_bit(jzgc, JZ4740_GPIO_DATA, offset, !!value);
@@ -1719,7 +1719,7 @@ static void irq_set_type(struct ingenic_gpio_chip *jzgc,
 		break;
 	}
 
-	if (jzgc->jzpc->info->version >= ID_JZ4760) {
+	if (jzgc->jzpc->info->version >= ID_JZ4770) {
 		reg1 = JZ4760_GPIO_PAT1;
 		reg2 = JZ4760_GPIO_PAT0;
 	} else {
@@ -1759,7 +1759,7 @@ static void ingenic_gpio_irq_enable(struct irq_data *irqd)
 	struct ingenic_gpio_chip *jzgc = gpiochip_get_data(gc);
 	int irq = irqd->hwirq;
 
-	if (jzgc->jzpc->info->version >= ID_JZ4760)
+	if (jzgc->jzpc->info->version >= ID_JZ4770)
 		ingenic_gpio_set_bit(jzgc, JZ4760_GPIO_INT, irq, true);
 	else
 		ingenic_gpio_set_bit(jzgc, JZ4740_GPIO_SELECT, irq, true);
@@ -1775,7 +1775,7 @@ static void ingenic_gpio_irq_disable(struct irq_data *irqd)
 
 	ingenic_gpio_irq_mask(irqd);
 
-	if (jzgc->jzpc->info->version >= ID_JZ4760)
+	if (jzgc->jzpc->info->version >= ID_JZ4770)
 		ingenic_gpio_set_bit(jzgc, JZ4760_GPIO_INT, irq, false);
 	else
 		ingenic_gpio_set_bit(jzgc, JZ4740_GPIO_SELECT, irq, false);
@@ -1800,7 +1800,7 @@ static void ingenic_gpio_irq_ack(struct irq_data *irqd)
 			irq_set_type(jzgc, irq, IRQ_TYPE_LEVEL_HIGH);
 	}
 
-	if (jzgc->jzpc->info->version >= ID_JZ4760)
+	if (jzgc->jzpc->info->version >= ID_JZ4770)
 		ingenic_gpio_set_bit(jzgc, JZ4760_GPIO_FLAG, irq, false);
 	else
 		ingenic_gpio_set_bit(jzgc, JZ4740_GPIO_DATA, irq, true);
@@ -1857,7 +1857,7 @@ static void ingenic_gpio_irq_handler(struct irq_desc *desc)
 
 	chained_irq_enter(irq_chip, desc);
 
-	if (jzgc->jzpc->info->version >= ID_JZ4760)
+	if (jzgc->jzpc->info->version >= ID_JZ4770)
 		flag = ingenic_gpio_read_reg(jzgc, JZ4760_GPIO_FLAG);
 	else
 		flag = ingenic_gpio_read_reg(jzgc, JZ4740_GPIO_FLAG);
@@ -1939,7 +1939,7 @@ static int ingenic_gpio_get_direction(struct gpio_chip *gc, unsigned int offset)
 	struct ingenic_pinctrl *jzpc = jzgc->jzpc;
 	unsigned int pin = gc->base + offset;
 
-	if (jzpc->info->version >= ID_JZ4760) {
+	if (jzpc->info->version >= ID_JZ4770) {
 		if (ingenic_get_pin_config(jzpc, pin, JZ4760_GPIO_INT) ||
 		    ingenic_get_pin_config(jzpc, pin, JZ4760_GPIO_PAT1))
 			return GPIO_LINE_DIRECTION_IN;
@@ -1997,7 +1997,7 @@ static int ingenic_pinmux_set_pin_fn(struct ingenic_pinctrl *jzpc,
 		ingenic_shadow_config_pin(jzpc, pin, JZ4760_GPIO_PAT1, func & 0x2);
 		ingenic_shadow_config_pin(jzpc, pin, JZ4760_GPIO_PAT0, func & 0x1);
 		ingenic_shadow_config_pin_load(jzpc, pin);
-	} else if (jzpc->info->version >= ID_JZ4760) {
+	} else if (jzpc->info->version >= ID_JZ4770) {
 		ingenic_config_pin(jzpc, pin, JZ4760_GPIO_INT, false);
 		ingenic_config_pin(jzpc, pin, GPIO_MSK, false);
 		ingenic_config_pin(jzpc, pin, JZ4760_GPIO_PAT1, func & 0x2);
@@ -2005,7 +2005,7 @@ static int ingenic_pinmux_set_pin_fn(struct ingenic_pinctrl *jzpc,
 	} else {
 		ingenic_config_pin(jzpc, pin, JZ4740_GPIO_FUNC, true);
 		ingenic_config_pin(jzpc, pin, JZ4740_GPIO_TRIG, func & 0x2);
-		ingenic_config_pin(jzpc, pin, JZ4740_GPIO_SELECT, func > 0);
+		ingenic_config_pin(jzpc, pin, JZ4740_GPIO_SELECT, func & 0x1);
 	}
 
 	return 0;
@@ -2062,7 +2062,7 @@ static int ingenic_pinmux_gpio_set_direction(struct pinctrl_dev *pctldev,
 		ingenic_shadow_config_pin(jzpc, pin, GPIO_MSK, true);
 		ingenic_shadow_config_pin(jzpc, pin, JZ4760_GPIO_PAT1, input);
 		ingenic_shadow_config_pin_load(jzpc, pin);
-	} else if (jzpc->info->version >= ID_JZ4760) {
+	} else if (jzpc->info->version >= ID_JZ4770) {
 		ingenic_config_pin(jzpc, pin, JZ4760_GPIO_INT, false);
 		ingenic_config_pin(jzpc, pin, GPIO_MSK, true);
 		ingenic_config_pin(jzpc, pin, JZ4760_GPIO_PAT1, input);
@@ -2092,7 +2092,7 @@ static int ingenic_pinconf_get(struct pinctrl_dev *pctldev,
 	unsigned int offt = pin / PINS_PER_GPIO_CHIP;
 	bool pull;
 
-	if (jzpc->info->version >= ID_JZ4760)
+	if (jzpc->info->version >= ID_JZ4770)
 		pull = !ingenic_get_pin_config(jzpc, pin, JZ4760_GPIO_PEN);
 	else
 		pull = !ingenic_get_pin_config(jzpc, pin, JZ4740_GPIO_PULL_DIS);
@@ -2142,7 +2142,7 @@ static void ingenic_set_bias(struct ingenic_pinctrl *jzpc,
 					REG_SET(X1830_GPIO_PEH), bias << idxh);
 		}
 
-	} else if (jzpc->info->version >= ID_JZ4760) {
+	} else if (jzpc->info->version >= ID_JZ4770) {
 		ingenic_config_pin(jzpc, pin, JZ4760_GPIO_PEN, !bias);
 	} else {
 		ingenic_config_pin(jzpc, pin, JZ4740_GPIO_PULL_DIS, !bias);
@@ -2152,7 +2152,7 @@ static void ingenic_set_bias(struct ingenic_pinctrl *jzpc,
 static void ingenic_set_output_level(struct ingenic_pinctrl *jzpc,
 				     unsigned int pin, bool high)
 {
-	if (jzpc->info->version >= ID_JZ4760)
+	if (jzpc->info->version >= ID_JZ4770)
 		ingenic_config_pin(jzpc, pin, JZ4760_GPIO_PAT0, high);
 	else
 		ingenic_config_pin(jzpc, pin, JZ4740_GPIO_DATA, high);
-- 
2.29.2

