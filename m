Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1FBB24A087
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 15:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728504AbgHSNuW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 09:50:22 -0400
Received: from crapouillou.net ([89.234.176.41]:41790 "EHLO crapouillou.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728603AbgHSNuQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Aug 2020 09:50:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crapouillou.net;
        s=mail; t=1597845011; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZMa1miHqnp0hsyQzcWODgfb3fE7vf8/LcAi3x0FvuYM=;
        b=B0VZgs64FpdRgndxTwlzRuO717hGlf3RkMKNxRG5ecOiYfUcJn2pSz85wBWZEa3GU2t+Qn
        35fL8uQDmFKDso6uweAOaIwZ8G6wWcs9777oJb57IorSjCSXICPueiiKUoqlvu/bOqfDaS
        UB4Ubmn7+II2gNqYAp/QNTiVu5Nu8sA=
From:   Paul Cercueil <paul@crapouillou.net>
To:     gregkh <gregkh@linuxfoundation.org>
Cc:     Paul Cercueil <paul@crapouillou.net>,
        =?UTF-8?q?Jo=C3=A3o=20Henrique?= <johnnyonflame@hotmail.com>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [BACKPORT v5.4 PATCH] pinctrl: ingenic: Properly detect GPIO direction when configured for IRQ
Date:   Wed, 19 Aug 2020 15:49:53 +0200
Message-Id: <20200819134953.25842-1-paul@crapouillou.net>
In-Reply-To: <1597837696152155@kroah.com>
References: <1597837696152155@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The PAT1 register contains information about the IRQ type (edge/level)
for input GPIOs with IRQ enabled, and the direction for non-IRQ GPIOs.
So it makes sense to read it only if the GPIO has no interrupt
configured, otherwise input GPIOs configured for level IRQs are
misdetected as output GPIOs.

Fixes: ebd6651418b6 ("pinctrl: ingenic: Implement .get_direction for GPIO chips")
Reported-by: João Henrique <johnnyonflame@hotmail.com>
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200622214548.265417-2-paul@crapouillou.net
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---

Notes:
    Original git commit ID: 84e7a946da71f678affacea301f6d5cb4d9784e8

 drivers/pinctrl/pinctrl-ingenic.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-ingenic.c b/drivers/pinctrl/pinctrl-ingenic.c
index 6e2683016c1f..bfa0c5b7ad04 100644
--- a/drivers/pinctrl/pinctrl-ingenic.c
+++ b/drivers/pinctrl/pinctrl-ingenic.c
@@ -1644,7 +1644,8 @@ static int ingenic_gpio_get_direction(struct gpio_chip *gc, unsigned int offset)
 	unsigned int pin = gc->base + offset;
 
 	if (jzpc->version >= ID_JZ4760)
-		return ingenic_get_pin_config(jzpc, pin, JZ4760_GPIO_PAT1);
+		return ingenic_get_pin_config(jzpc, pin, JZ4760_GPIO_INT) ||
+			ingenic_get_pin_config(jzpc, pin, JZ4760_GPIO_PAT1);
 
 	if (ingenic_get_pin_config(jzpc, pin, JZ4740_GPIO_SELECT))
 		return true;
-- 
2.28.0

