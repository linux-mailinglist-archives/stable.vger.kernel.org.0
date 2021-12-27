Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F189948005A
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236413AbhL0Ppt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:45:49 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:44854 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238238AbhL0Pnx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:43:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4FD1B810AA;
        Mon, 27 Dec 2021 15:43:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17E14C36AE7;
        Mon, 27 Dec 2021 15:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619830;
        bh=z5P4om6iudnX5CABZ7U1BI9o3x/jh4038ygeSt1X76M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mOWhEPuoMqbs0atYxGk4FQqGy8NZTmrmuseFhfESqq1O7yHkKyW39Ev4P+/F8rjuL
         5b1hGvV5WAazmViEXP1HjZyCFAWQ8WD5r19LZV+bE/afcqEOxgyQBBdLGLcq1O9IbC
         o2ox0aOQpfwPl38Cq1KBlHRbwCrXUe9GEVeJ5JJs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phil Elwell <phil@raspberrypi.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 052/128] pinctrl: bcm2835: Change init order for gpio hogs
Date:   Mon, 27 Dec 2021 16:30:27 +0100
Message-Id: <20211227151333.248532258@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phil Elwell <phil@raspberrypi.com>

[ Upstream commit 266423e60ea1b953fcc0cd97f3dad85857e434d1 ]

...and gpio-ranges

pinctrl-bcm2835 is a combined pinctrl/gpio driver. Currently the gpio
side is registered first, but this breaks gpio hogs (which are
configured during gpiochip_add_data). Part of the hog initialisation
is a call to pinctrl_gpio_request, and since the pinctrl driver hasn't
yet been registered this results in an -EPROBE_DEFER from which it can
never recover.

Change the initialisation sequence to register the pinctrl driver
first.

This also solves a similar problem with the gpio-ranges property, which
is required in order for released pins to be returned to inputs.

Fixes: 73345a18d464b ("pinctrl: bcm2835: Pass irqchip when adding gpiochip")
Signed-off-by: Phil Elwell <phil@raspberrypi.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20211206092237.4105895-2-phil@raspberrypi.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/bcm/pinctrl-bcm2835.c | 29 +++++++++++++++------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/pinctrl/bcm/pinctrl-bcm2835.c b/drivers/pinctrl/bcm/pinctrl-bcm2835.c
index 6e6fefeb21ead..cc39c0e18b474 100644
--- a/drivers/pinctrl/bcm/pinctrl-bcm2835.c
+++ b/drivers/pinctrl/bcm/pinctrl-bcm2835.c
@@ -1243,6 +1243,18 @@ static int bcm2835_pinctrl_probe(struct platform_device *pdev)
 		raw_spin_lock_init(&pc->irq_lock[i]);
 	}
 
+	pc->pctl_desc = *pdata->pctl_desc;
+	pc->pctl_dev = devm_pinctrl_register(dev, &pc->pctl_desc, pc);
+	if (IS_ERR(pc->pctl_dev)) {
+		gpiochip_remove(&pc->gpio_chip);
+		return PTR_ERR(pc->pctl_dev);
+	}
+
+	pc->gpio_range = *pdata->gpio_range;
+	pc->gpio_range.base = pc->gpio_chip.base;
+	pc->gpio_range.gc = &pc->gpio_chip;
+	pinctrl_add_gpio_range(pc->pctl_dev, &pc->gpio_range);
+
 	girq = &pc->gpio_chip.irq;
 	girq->chip = &bcm2835_gpio_irq_chip;
 	girq->parent_handler = bcm2835_gpio_irq_handler;
@@ -1250,8 +1262,10 @@ static int bcm2835_pinctrl_probe(struct platform_device *pdev)
 	girq->parents = devm_kcalloc(dev, BCM2835_NUM_IRQS,
 				     sizeof(*girq->parents),
 				     GFP_KERNEL);
-	if (!girq->parents)
+	if (!girq->parents) {
+		pinctrl_remove_gpio_range(pc->pctl_dev, &pc->gpio_range);
 		return -ENOMEM;
+	}
 
 	if (is_7211) {
 		pc->wake_irq = devm_kcalloc(dev, BCM2835_NUM_IRQS,
@@ -1306,21 +1320,10 @@ static int bcm2835_pinctrl_probe(struct platform_device *pdev)
 	err = gpiochip_add_data(&pc->gpio_chip, pc);
 	if (err) {
 		dev_err(dev, "could not add GPIO chip\n");
+		pinctrl_remove_gpio_range(pc->pctl_dev, &pc->gpio_range);
 		return err;
 	}
 
-	pc->pctl_desc = *pdata->pctl_desc;
-	pc->pctl_dev = devm_pinctrl_register(dev, &pc->pctl_desc, pc);
-	if (IS_ERR(pc->pctl_dev)) {
-		gpiochip_remove(&pc->gpio_chip);
-		return PTR_ERR(pc->pctl_dev);
-	}
-
-	pc->gpio_range = *pdata->gpio_range;
-	pc->gpio_range.base = pc->gpio_chip.base;
-	pc->gpio_range.gc = &pc->gpio_chip;
-	pinctrl_add_gpio_range(pc->pctl_dev, &pc->gpio_range);
-
 	return 0;
 }
 
-- 
2.34.1



