Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0612E403D
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502106AbgL1OTh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:19:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:54902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502107AbgL1OTg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:19:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D010206D4;
        Mon, 28 Dec 2020 14:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165136;
        bh=yc0hZNOKlgsQGCmuGr8ozOHMQXfNzGnkzwNI4C/Z3u8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SdwNaWXAYSKN5J78uzaDbT/eFti07rrfaGQxINmI1uDLMDZlj2IY9pY1ThqFAvJOp
         inLMKxH0ACVrb/aIXMpXT1cyz+FAjVLyXrioWJTqp/K1tlQEifDqWpeetH57r9O9vL
         e3TI3TgFnwnfDIYCf5vj5S6Yzo1Xis0Wmdy/YRWQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikita Shubin <nikita.shubin@maquefel.me>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 425/717] gpiolib: irq hooks: fix recursion in gpiochip_irq_unmask
Date:   Mon, 28 Dec 2020 13:47:03 +0100
Message-Id: <20201228125041.326234535@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikita Shubin <nikita.shubin@maquefel.me>

[ Upstream commit 9d5522199505c761575c8ea31dcfd9a2a8d73614 ]

irqchip shared with multiple gpiochips, leads to recursive call of
gpiochip_irq_mask/gpiochip_irq_unmask which was assigned to
rqchip->irq_mask/irqchip->irq_unmask, these happens becouse of
only irqchip->irq_enable == gpiochip_irq_enable is checked.

Let's add an additional check to make sure shared irqchip is detected
even if irqchip->irq_enable wasn't defined.

Fixes: a8173820f441 ("gpio: gpiolib: Allow GPIO IRQs to lazy disable")
Signed-off-by: Nikita Shubin <nikita.shubin@maquefel.me>
Link: https://lore.kernel.org/r/20201210070514.13238-1-nikita.shubin@maquefel.me
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 6e3c4d7a7d146..4ad3c4b276dcf 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1477,7 +1477,8 @@ static void gpiochip_set_irq_hooks(struct gpio_chip *gc)
 	if (WARN_ON(gc->irq.irq_enable))
 		return;
 	/* Check if the irqchip already has this hook... */
-	if (irqchip->irq_enable == gpiochip_irq_enable) {
+	if (irqchip->irq_enable == gpiochip_irq_enable ||
+		irqchip->irq_mask == gpiochip_irq_mask) {
 		/*
 		 * ...and if so, give a gentle warning that this is bad
 		 * practice.
-- 
2.27.0



