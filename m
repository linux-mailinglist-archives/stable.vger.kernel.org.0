Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7451E2042D5
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 23:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730527AbgFVVqS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 17:46:18 -0400
Received: from outils.crapouillou.net ([89.234.176.41]:34164 "EHLO
        crapouillou.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730494AbgFVVqR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jun 2020 17:46:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crapouillou.net;
        s=mail; t=1592862375; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:in-reply-to:
         references; bh=XVivtfrUoedverxihZDUvQXhbwIsW+Ph7W4Zuj41NTM=;
        b=CxR0MCFl6PJNUHCHUUF4NaLFrzu7naZvhIfn6Lm6JwoZcjditrouo7ZpcUL1rCeRFGEFjr
        kCaU21cgk8HIekGNqYAqaicVFFoGCrQgxI39HwYbNOvWv4es2JOe/xbqlEX3ayGZSJxFRM
        khfX6DY8rWyRg/gN9IxIumrcgjcGbsI=
From:   Paul Cercueil <paul@crapouillou.net>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     od@zcrc.me, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jo=C3=A3o=20Henrique?= <johnnyonflame@hotmail.com>
Subject: [PATCH 1/2] pinctrl: ingenic: Enhance support for IRQ_TYPE_EDGE_BOTH
Date:   Mon, 22 Jun 2020 23:45:47 +0200
Message-Id: <20200622214548.265417-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Ingenic SoCs don't natively support registering an interrupt for both
rising and falling edges. This has to be emulated in software.

Until now, this was emulated by switching back and forth between
IRQ_TYPE_EDGE_RISING and IRQ_TYPE_EDGE_FALLING according to the level of
the GPIO. While this worked most of the time, when used with GPIOs that
need debouncing, some events would be lost. For instance, between the
time a falling-edge interrupt happens and the interrupt handler
configures the hardware for rising-edge, the level of the pin may have
already risen, and the rising-edge event is lost.

To address that issue, instead of switching back and forth between
IRQ_TYPE_EDGE_RISING and IRQ_TYPE_EDGE_FALLING, we now switch back and
forth between IRQ_TYPE_LEVEL_LOW and IRQ_TYPE_LEVEL_HIGH. Since we
always switch in the interrupt handler, they actually permit to detect
level changes. In the example above, if the pin level rises before
switching the IRQ type from IRQ_TYPE_LEVEL_LOW to IRQ_TYPE_LEVEL_HIGH,
a new interrupt will raise as soon as the handler exits, and the
rising-edge event will be properly detected.

Cc: stable@vger.kernel.org
Fixes: e72394e2ea19 ("pinctrl: ingenic: Merge GPIO functionality")
Reported-by: João Henrique <johnnyonflame@hotmail.com>
Tested-by: João Henrique <johnnyonflame@hotmail.com>
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
---
 drivers/pinctrl/pinctrl-ingenic.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-ingenic.c b/drivers/pinctrl/pinctrl-ingenic.c
index fc0d10411aa9..241e563d5814 100644
--- a/drivers/pinctrl/pinctrl-ingenic.c
+++ b/drivers/pinctrl/pinctrl-ingenic.c
@@ -1813,9 +1813,9 @@ static void ingenic_gpio_irq_ack(struct irq_data *irqd)
 		 */
 		high = ingenic_gpio_get_value(jzgc, irq);
 		if (high)
-			irq_set_type(jzgc, irq, IRQ_TYPE_EDGE_FALLING);
+			irq_set_type(jzgc, irq, IRQ_TYPE_LEVEL_LOW);
 		else
-			irq_set_type(jzgc, irq, IRQ_TYPE_EDGE_RISING);
+			irq_set_type(jzgc, irq, IRQ_TYPE_LEVEL_HIGH);
 	}
 
 	if (jzgc->jzpc->info->version >= ID_JZ4760)
@@ -1851,7 +1851,7 @@ static int ingenic_gpio_irq_set_type(struct irq_data *irqd, unsigned int type)
 		 */
 		bool high = ingenic_gpio_get_value(jzgc, irqd->hwirq);
 
-		type = high ? IRQ_TYPE_EDGE_FALLING : IRQ_TYPE_EDGE_RISING;
+		type = high ? IRQ_TYPE_LEVEL_LOW : IRQ_TYPE_LEVEL_HIGH;
 	}
 
 	irq_set_type(jzgc, irqd->hwirq, type);
-- 
2.27.0

