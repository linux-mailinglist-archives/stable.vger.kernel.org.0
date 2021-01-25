Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0AE0303354
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 05:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728404AbhAZEty (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:49:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:33734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730161AbhAYSqT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:46:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2F63230FA;
        Mon, 25 Jan 2021 18:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600349;
        bh=Kq0aYncV1wz5N8/Ipur8uGJBgZLsF/TF5GYQip7CU4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tl8xAHRWJSur/9v8C0bIA6y2ZRZhJlan0Ro5DsIN3k1ecIGDl1QBuaNayNcsvH9bw
         gAofz8AiIOtIwVsrPLN7D8Ar5IkVLlJ+Jz9halBmPTQWqnJbdWu1Iq+hUKazvQxzxn
         wnreFsje+1/k3QcDeoxioO+vFDDFSxSyx2yBDBJY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.4 67/86] pinctrl: ingenic: Fix JZ4760 support
Date:   Mon, 25 Jan 2021 19:39:49 +0100
Message-Id: <20210125183203.875160331@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183201.024962206@linuxfoundation.org>
References: <20210125183201.024962206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

commit 9a85c09a3f507b925d75cb0c7c8f364467038052 upstream.

- JZ4760 and JZ4760B have a similar register layout as the JZ4740, and
  don't use the new register layout, which was introduced with the
  JZ4770 SoC and not the JZ4760 or JZ4760B SoCs.

- The JZ4740 code path only expected two function modes to be
  configurable for each pin, and wouldn't work with more than two. Fix
  it for the JZ4760, which has four configurable function modes.

Fixes: 0257595a5cf4 ("pinctrl: Ingenic: Add pinctrl driver for JZ4760 and JZ4760B.")
Cc: <stable@vger.kernel.org> # 5.3
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Link: https://lore.kernel.org/r/20201211232810.261565-1-paul@crapouillou.net
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/pinctrl/pinctrl-ingenic.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/drivers/pinctrl/pinctrl-ingenic.c
+++ b/drivers/pinctrl/pinctrl-ingenic.c
@@ -1378,7 +1378,7 @@ static inline bool ingenic_gpio_get_valu
 static void ingenic_gpio_set_value(struct ingenic_gpio_chip *jzgc,
 				   u8 offset, int value)
 {
-	if (jzgc->jzpc->version >= ID_JZ4760)
+	if (jzgc->jzpc->version >= ID_JZ4770)
 		ingenic_gpio_set_bit(jzgc, JZ4760_GPIO_PAT0, offset, !!value);
 	else
 		ingenic_gpio_set_bit(jzgc, JZ4740_GPIO_DATA, offset, !!value);
@@ -1389,7 +1389,7 @@ static void irq_set_type(struct ingenic_
 {
 	u8 reg1, reg2;
 
-	if (jzgc->jzpc->version >= ID_JZ4760) {
+	if (jzgc->jzpc->version >= ID_JZ4770) {
 		reg1 = JZ4760_GPIO_PAT1;
 		reg2 = JZ4760_GPIO_PAT0;
 	} else {
@@ -1464,7 +1464,7 @@ static void ingenic_gpio_irq_enable(stru
 	struct ingenic_gpio_chip *jzgc = gpiochip_get_data(gc);
 	int irq = irqd->hwirq;
 
-	if (jzgc->jzpc->version >= ID_JZ4760)
+	if (jzgc->jzpc->version >= ID_JZ4770)
 		ingenic_gpio_set_bit(jzgc, JZ4760_GPIO_INT, irq, true);
 	else
 		ingenic_gpio_set_bit(jzgc, JZ4740_GPIO_SELECT, irq, true);
@@ -1480,7 +1480,7 @@ static void ingenic_gpio_irq_disable(str
 
 	ingenic_gpio_irq_mask(irqd);
 
-	if (jzgc->jzpc->version >= ID_JZ4760)
+	if (jzgc->jzpc->version >= ID_JZ4770)
 		ingenic_gpio_set_bit(jzgc, JZ4760_GPIO_INT, irq, false);
 	else
 		ingenic_gpio_set_bit(jzgc, JZ4740_GPIO_SELECT, irq, false);
@@ -1505,7 +1505,7 @@ static void ingenic_gpio_irq_ack(struct
 			irq_set_type(jzgc, irq, IRQ_TYPE_LEVEL_HIGH);
 	}
 
-	if (jzgc->jzpc->version >= ID_JZ4760)
+	if (jzgc->jzpc->version >= ID_JZ4770)
 		ingenic_gpio_set_bit(jzgc, JZ4760_GPIO_FLAG, irq, false);
 	else
 		ingenic_gpio_set_bit(jzgc, JZ4740_GPIO_DATA, irq, true);
@@ -1562,7 +1562,7 @@ static void ingenic_gpio_irq_handler(str
 
 	chained_irq_enter(irq_chip, desc);
 
-	if (jzgc->jzpc->version >= ID_JZ4760)
+	if (jzgc->jzpc->version >= ID_JZ4770)
 		flag = ingenic_gpio_read_reg(jzgc, JZ4760_GPIO_FLAG);
 	else
 		flag = ingenic_gpio_read_reg(jzgc, JZ4740_GPIO_FLAG);
@@ -1643,7 +1643,7 @@ static int ingenic_gpio_get_direction(st
 	struct ingenic_pinctrl *jzpc = jzgc->jzpc;
 	unsigned int pin = gc->base + offset;
 
-	if (jzpc->version >= ID_JZ4760)
+	if (jzpc->version >= ID_JZ4770)
 		return ingenic_get_pin_config(jzpc, pin, JZ4760_GPIO_INT) ||
 			ingenic_get_pin_config(jzpc, pin, JZ4760_GPIO_PAT1);
 
@@ -1676,7 +1676,7 @@ static int ingenic_pinmux_set_pin_fn(str
 		ingenic_shadow_config_pin(jzpc, pin, JZ4760_GPIO_PAT1, func & 0x2);
 		ingenic_shadow_config_pin(jzpc, pin, JZ4760_GPIO_PAT0, func & 0x1);
 		ingenic_shadow_config_pin_load(jzpc, pin);
-	} else if (jzpc->version >= ID_JZ4760) {
+	} else if (jzpc->version >= ID_JZ4770) {
 		ingenic_config_pin(jzpc, pin, JZ4760_GPIO_INT, false);
 		ingenic_config_pin(jzpc, pin, GPIO_MSK, false);
 		ingenic_config_pin(jzpc, pin, JZ4760_GPIO_PAT1, func & 0x2);
@@ -1684,7 +1684,7 @@ static int ingenic_pinmux_set_pin_fn(str
 	} else {
 		ingenic_config_pin(jzpc, pin, JZ4740_GPIO_FUNC, true);
 		ingenic_config_pin(jzpc, pin, JZ4740_GPIO_TRIG, func & 0x2);
-		ingenic_config_pin(jzpc, pin, JZ4740_GPIO_SELECT, func > 0);
+		ingenic_config_pin(jzpc, pin, JZ4740_GPIO_SELECT, func & 0x1);
 	}
 
 	return 0;
@@ -1734,7 +1734,7 @@ static int ingenic_pinmux_gpio_set_direc
 		ingenic_shadow_config_pin(jzpc, pin, GPIO_MSK, true);
 		ingenic_shadow_config_pin(jzpc, pin, JZ4760_GPIO_PAT1, input);
 		ingenic_shadow_config_pin_load(jzpc, pin);
-	} else if (jzpc->version >= ID_JZ4760) {
+	} else if (jzpc->version >= ID_JZ4770) {
 		ingenic_config_pin(jzpc, pin, JZ4760_GPIO_INT, false);
 		ingenic_config_pin(jzpc, pin, GPIO_MSK, true);
 		ingenic_config_pin(jzpc, pin, JZ4760_GPIO_PAT1, input);
@@ -1764,7 +1764,7 @@ static int ingenic_pinconf_get(struct pi
 	unsigned int offt = pin / PINS_PER_GPIO_CHIP;
 	bool pull;
 
-	if (jzpc->version >= ID_JZ4760)
+	if (jzpc->version >= ID_JZ4770)
 		pull = !ingenic_get_pin_config(jzpc, pin, JZ4760_GPIO_PEN);
 	else
 		pull = !ingenic_get_pin_config(jzpc, pin, JZ4740_GPIO_PULL_DIS);
@@ -1796,7 +1796,7 @@ static int ingenic_pinconf_get(struct pi
 static void ingenic_set_bias(struct ingenic_pinctrl *jzpc,
 		unsigned int pin, bool enabled)
 {
-	if (jzpc->version >= ID_JZ4760)
+	if (jzpc->version >= ID_JZ4770)
 		ingenic_config_pin(jzpc, pin, JZ4760_GPIO_PEN, !enabled);
 	else
 		ingenic_config_pin(jzpc, pin, JZ4740_GPIO_PULL_DIS, !enabled);


