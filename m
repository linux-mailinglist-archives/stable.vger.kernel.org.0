Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31F6624BC41
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729117AbgHTMn3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:43:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:48206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729174AbgHTJqM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:46:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 134FE2173E;
        Thu, 20 Aug 2020 09:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916771;
        bh=UqGy7vvxiXiK4bW5cGlYb2M6G6h/OoOdR2BiW9Id6hI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1ihLJQChcB3xtdL9LbQ5EucvKZpkV055aD3zuuMZcU3bs7X7ppGSY1ag1wyML+5t7
         g9NZvKGaZJAIBIourCxjgUcxaSiDVqR/ZYIPX7HxS5jqFrTPlkWc0OedC2lvIR1a5Q
         4gZ9p66RvCCc6RMJ2GwXii+EdWHhbyFoYEt/shsE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jo=C3=A3o=20Henrique?= <johnnyonflame@hotmail.com>,
        Paul Cercueil <paul@crapouillou.net>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.4 039/152] pinctrl: ingenic: Enhance support for IRQ_TYPE_EDGE_BOTH
Date:   Thu, 20 Aug 2020 11:20:06 +0200
Message-Id: <20200820091555.657167744@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091553.615456912@linuxfoundation.org>
References: <20200820091553.615456912@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

commit 1c95348ba327fe8621d3680890c2341523d3524a upstream.

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

Fixes: e72394e2ea19 ("pinctrl: ingenic: Merge GPIO functionality")
Reported-by: João Henrique <johnnyonflame@hotmail.com>
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Tested-by: João Henrique <johnnyonflame@hotmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200622214548.265417-1-paul@crapouillou.net
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/pinctrl-ingenic.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/pinctrl/pinctrl-ingenic.c
+++ b/drivers/pinctrl/pinctrl-ingenic.c
@@ -1500,9 +1500,9 @@ static void ingenic_gpio_irq_ack(struct
 		 */
 		high = ingenic_gpio_get_value(jzgc, irq);
 		if (high)
-			irq_set_type(jzgc, irq, IRQ_TYPE_EDGE_FALLING);
+			irq_set_type(jzgc, irq, IRQ_TYPE_LEVEL_LOW);
 		else
-			irq_set_type(jzgc, irq, IRQ_TYPE_EDGE_RISING);
+			irq_set_type(jzgc, irq, IRQ_TYPE_LEVEL_HIGH);
 	}
 
 	if (jzgc->jzpc->version >= ID_JZ4760)
@@ -1538,7 +1538,7 @@ static int ingenic_gpio_irq_set_type(str
 		 */
 		bool high = ingenic_gpio_get_value(jzgc, irqd->hwirq);
 
-		type = high ? IRQ_TYPE_EDGE_FALLING : IRQ_TYPE_EDGE_RISING;
+		type = high ? IRQ_TYPE_LEVEL_LOW : IRQ_TYPE_LEVEL_HIGH;
 	}
 
 	irq_set_type(jzgc, irqd->hwirq, type);


