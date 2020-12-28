Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0B982E3A74
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:37:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390646AbgL1NhG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:37:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:37046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390641AbgL1NhF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:37:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3A71207C9;
        Mon, 28 Dec 2020 13:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162610;
        bh=NSI0TtcbDGgzvXfHX3RQC+tY4OOEILtZdDQ3LbzVD6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QtnCnq87GoxhagdLvDUmcebc9m56E+3voaQz8YLwwywL+CTwBFLGcbyh3Zz+Bv0Z4
         rj7Z1JZToe0IBJFvWdZkaKvSKUyAgvVhywq9VjIRpbUt5jwUX8LvyHeO7wo5JO9U/3
         0FX/DEC3+YW4lgmamoFCX66qOYL2VSiKbQqBXFo0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Baruch Siach <baruch@tkos.co.il>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 012/453] gpio: mvebu: fix potential user-after-free on probe
Date:   Mon, 28 Dec 2020 13:44:08 +0100
Message-Id: <20201228124937.837715222@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
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
index 6c06876943412..3985d6e1c17dc 100644
--- a/drivers/gpio/gpio-mvebu.c
+++ b/drivers/gpio/gpio-mvebu.c
@@ -1196,6 +1196,13 @@ static int mvebu_gpio_probe(struct platform_device *pdev)
 
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
@@ -1205,7 +1212,8 @@ static int mvebu_gpio_probe(struct platform_device *pdev)
 	if (!mvchip->domain) {
 		dev_err(&pdev->dev, "couldn't allocate irq domain %s (DT).\n",
 			mvchip->chip.label);
-		return -ENODEV;
+		err = -ENODEV;
+		goto err_pwm;
 	}
 
 	err = irq_alloc_domain_generic_chips(
@@ -1253,14 +1261,12 @@ static int mvebu_gpio_probe(struct platform_device *pdev)
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



