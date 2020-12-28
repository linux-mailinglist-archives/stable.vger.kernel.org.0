Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA90D2E3853
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:09:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731018AbgL1NI4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:08:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:36046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731011AbgL1NIz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:08:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02C032076D;
        Mon, 28 Dec 2020 13:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160919;
        bh=PsggyikTz3ZfDUADG0zA8/DVJ2pK+14Uh7TcdsbIcjE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TSx7CPVe3IeXcllWKLh9V9Bv+kQl1tgsLpY0UZ9OdveKswcp0XkTlVU2rtHIFyg+s
         mFaU/Vcl3jMFgb+4G9pa/eGeHMCAcWNt2rMY4DGaL3YagfdKzRJguy3E3wThRKQAV1
         z3Vk66JB/QAqG8z88/Y33lbJy+xp8S6+VAvQoA5E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Baruch Siach <baruch@tkos.co.il>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 038/242] gpio: mvebu: fix potential user-after-free on probe
Date:   Mon, 28 Dec 2020 13:47:23 +0100
Message-Id: <20201228124906.543278032@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baruch Siach <baruch@tkos.co.il>

[ Upstream commit 7ee1a01e47403f72b9f38839a737692f6991263e ]

When mvebu_pwm_probe() fails IRQ domain is not released. Move pwm probe
before IRQ domain allocation. Add pwm cleanup code to the failure path.

Fixes: 757642f9a584 ("gpio: mvebu: Add limited PWM support")
Reported-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Baruch Siach <baruch@tkos.co.il>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mvebu.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/gpio/gpio-mvebu.c b/drivers/gpio/gpio-mvebu.c
index be85d4b39e997..fc762b4adcb22 100644
--- a/drivers/gpio/gpio-mvebu.c
+++ b/drivers/gpio/gpio-mvebu.c
@@ -1195,6 +1195,13 @@ static int mvebu_gpio_probe(struct platform_device *pdev)
 
 	devm_gpiochip_add_data(&pdev->dev, &mvchip->chip, mvchip);
 
+	/* Some MVEBU SoCs have simple PWM support for GPIO lines */
+	if (IS_ENABLED(CONFIG_PWM)) {
+		err = mvebu_pwm_probe(pdev, mvchip, id);
+		if (err)
+			return err;
+	}
+
 	/* Some gpio controllers do not provide irq support */
 	if (!have_irqs)
 		return 0;
@@ -1204,7 +1211,8 @@ static int mvebu_gpio_probe(struct platform_device *pdev)
 	if (!mvchip->domain) {
 		dev_err(&pdev->dev, "couldn't allocate irq domain %s (DT).\n",
 			mvchip->chip.label);
-		return -ENODEV;
+		err = -ENODEV;
+		goto err_pwm;
 	}
 
 	err = irq_alloc_domain_generic_chips(
@@ -1252,14 +1260,12 @@ static int mvebu_gpio_probe(struct platform_device *pdev)
 						 mvchip);
 	}
 
-	/* Some MVEBU SoCs have simple PWM support for GPIO lines */
-	if (IS_ENABLED(CONFIG_PWM))
-		return mvebu_pwm_probe(pdev, mvchip, id);
-
 	return 0;
 
 err_domain:
 	irq_domain_remove(mvchip->domain);
+err_pwm:
+	pwmchip_remove(&mvchip->mvpwm->chip);
 
 	return err;
 }
-- 
2.27.0



