Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAC3D3031B3
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 03:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbhAYSt1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:49:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:35388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730617AbhAYSsN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:48:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 961DF20719;
        Mon, 25 Jan 2021 18:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600453;
        bh=I4Ggq71HLMxfwbyBqwuhkQztkEwcKE0EWT3rCLpybCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v5KJK7pnaXAuBxG1tcDQGdol+WYM3eTFoz0owWyP0dQdk0pB4OeViYT5dzPgPlgrS
         k+aZ0ZLDUt0beagsexwnavu6VKClcuMJibpW4gnNmwCtwj2hEVKuAPImfFhsSOahux
         7tFzA9sse5CNKmZd96r5BYas7laVhOmOLv6K1pnc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.10 020/199] pinctrl: ingenic: Fix JZ4760 support
Date:   Mon, 25 Jan 2021 19:37:22 +0100
Message-Id: <20210125183217.111672597@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
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
 drivers/pinctrl/pinctrl-ingenic.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- a/drivers/pinctrl/pinctrl-ingenic.c
+++ b/drivers/pinctrl/pinctrl-ingenic.c
@@ -2052,7 +2052,7 @@ static inline bool ingenic_gpio_get_valu
 static void ingenic_gpio_set_value(struct ingenic_gpio_chip *jzgc,
 				   u8 offset, int value)
 {
-	if (jzgc->jzpc->info->version >= ID_JZ4760)
+	if (jzgc->jzpc->info->version >= ID_JZ4770)
 		ingenic_gpio_set_bit(jzgc, JZ4760_GPIO_PAT0, offset, !!value);
 	else
 		ingenic_gpio_set_bit(jzgc, JZ4740_GPIO_DATA, offset, !!value);
@@ -2082,7 +2082,7 @@ static void irq_set_type(struct ingenic_
 		break;
 	}
 
-	if (jzgc->jzpc->info->version >= ID_JZ4760) {
+	if (jzgc->jzpc->info->version >= ID_JZ4770) {
 		reg1 = JZ4760_GPIO_PAT1;
 		reg2 = JZ4760_GPIO_PAT0;
 	} else {
@@ -2122,7 +2122,7 @@ static void ingenic_gpio_irq_enable(stru
 	struct ingenic_gpio_chip *jzgc = gpiochip_get_data(gc);
 	int irq = irqd->hwirq;
 
-	if (jzgc->jzpc->info->version >= ID_JZ4760)
+	if (jzgc->jzpc->info->version >= ID_JZ4770)
 		ingenic_gpio_set_bit(jzgc, JZ4760_GPIO_INT, irq, true);
 	else
 		ingenic_gpio_set_bit(jzgc, JZ4740_GPIO_SELECT, irq, true);
@@ -2138,7 +2138,7 @@ static void ingenic_gpio_irq_disable(str
 
 	ingenic_gpio_irq_mask(irqd);
 
-	if (jzgc->jzpc->info->version >= ID_JZ4760)
+	if (jzgc->jzpc->info->version >= ID_JZ4770)
 		ingenic_gpio_set_bit(jzgc, JZ4760_GPIO_INT, irq, false);
 	else
 		ingenic_gpio_set_bit(jzgc, JZ4740_GPIO_SELECT, irq, false);
@@ -2163,7 +2163,7 @@ static void ingenic_gpio_irq_ack(struct
 			irq_set_type(jzgc, irq, IRQ_TYPE_LEVEL_HIGH);
 	}
 
-	if (jzgc->jzpc->info->version >= ID_JZ4760)
+	if (jzgc->jzpc->info->version >= ID_JZ4770)
 		ingenic_gpio_set_bit(jzgc, JZ4760_GPIO_FLAG, irq, false);
 	else
 		ingenic_gpio_set_bit(jzgc, JZ4740_GPIO_DATA, irq, true);
@@ -2220,7 +2220,7 @@ static void ingenic_gpio_irq_handler(str
 
 	chained_irq_enter(irq_chip, desc);
 
-	if (jzgc->jzpc->info->version >= ID_JZ4760)
+	if (jzgc->jzpc->info->version >= ID_JZ4770)
 		flag = ingenic_gpio_read_reg(jzgc, JZ4760_GPIO_FLAG);
 	else
 		flag = ingenic_gpio_read_reg(jzgc, JZ4740_GPIO_FLAG);
@@ -2302,7 +2302,7 @@ static int ingenic_gpio_get_direction(st
 	struct ingenic_pinctrl *jzpc = jzgc->jzpc;
 	unsigned int pin = gc->base + offset;
 
-	if (jzpc->info->version >= ID_JZ4760) {
+	if (jzpc->info->version >= ID_JZ4770) {
 		if (ingenic_get_pin_config(jzpc, pin, JZ4760_GPIO_INT) ||
 		    ingenic_get_pin_config(jzpc, pin, JZ4760_GPIO_PAT1))
 			return GPIO_LINE_DIRECTION_IN;
@@ -2360,7 +2360,7 @@ static int ingenic_pinmux_set_pin_fn(str
 		ingenic_shadow_config_pin(jzpc, pin, JZ4760_GPIO_PAT1, func & 0x2);
 		ingenic_shadow_config_pin(jzpc, pin, JZ4760_GPIO_PAT0, func & 0x1);
 		ingenic_shadow_config_pin_load(jzpc, pin);
-	} else if (jzpc->info->version >= ID_JZ4760) {
+	} else if (jzpc->info->version >= ID_JZ4770) {
 		ingenic_config_pin(jzpc, pin, JZ4760_GPIO_INT, false);
 		ingenic_config_pin(jzpc, pin, GPIO_MSK, false);
 		ingenic_config_pin(jzpc, pin, JZ4760_GPIO_PAT1, func & 0x2);
@@ -2368,7 +2368,7 @@ static int ingenic_pinmux_set_pin_fn(str
 	} else {
 		ingenic_config_pin(jzpc, pin, JZ4740_GPIO_FUNC, true);
 		ingenic_config_pin(jzpc, pin, JZ4740_GPIO_TRIG, func & 0x2);
-		ingenic_config_pin(jzpc, pin, JZ4740_GPIO_SELECT, func > 0);
+		ingenic_config_pin(jzpc, pin, JZ4740_GPIO_SELECT, func & 0x1);
 	}
 
 	return 0;
@@ -2418,7 +2418,7 @@ static int ingenic_pinmux_gpio_set_direc
 		ingenic_shadow_config_pin(jzpc, pin, GPIO_MSK, true);
 		ingenic_shadow_config_pin(jzpc, pin, JZ4760_GPIO_PAT1, input);
 		ingenic_shadow_config_pin_load(jzpc, pin);
-	} else if (jzpc->info->version >= ID_JZ4760) {
+	} else if (jzpc->info->version >= ID_JZ4770) {
 		ingenic_config_pin(jzpc, pin, JZ4760_GPIO_INT, false);
 		ingenic_config_pin(jzpc, pin, GPIO_MSK, true);
 		ingenic_config_pin(jzpc, pin, JZ4760_GPIO_PAT1, input);
@@ -2448,7 +2448,7 @@ static int ingenic_pinconf_get(struct pi
 	unsigned int offt = pin / PINS_PER_GPIO_CHIP;
 	bool pull;
 
-	if (jzpc->info->version >= ID_JZ4760)
+	if (jzpc->info->version >= ID_JZ4770)
 		pull = !ingenic_get_pin_config(jzpc, pin, JZ4760_GPIO_PEN);
 	else
 		pull = !ingenic_get_pin_config(jzpc, pin, JZ4740_GPIO_PULL_DIS);
@@ -2498,7 +2498,7 @@ static void ingenic_set_bias(struct inge
 					REG_SET(X1830_GPIO_PEH), bias << idxh);
 		}
 
-	} else if (jzpc->info->version >= ID_JZ4760) {
+	} else if (jzpc->info->version >= ID_JZ4770) {
 		ingenic_config_pin(jzpc, pin, JZ4760_GPIO_PEN, !bias);
 	} else {
 		ingenic_config_pin(jzpc, pin, JZ4740_GPIO_PULL_DIS, !bias);
@@ -2508,7 +2508,7 @@ static void ingenic_set_bias(struct inge
 static void ingenic_set_output_level(struct ingenic_pinctrl *jzpc,
 				     unsigned int pin, bool high)
 {
-	if (jzpc->info->version >= ID_JZ4760)
+	if (jzpc->info->version >= ID_JZ4770)
 		ingenic_config_pin(jzpc, pin, JZ4760_GPIO_PAT0, high);
 	else
 		ingenic_config_pin(jzpc, pin, JZ4740_GPIO_DATA, high);


