Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 029DD1060A3
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 06:50:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbfKVFut (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:50:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:55632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727877AbfKVFus (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:50:48 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98BE120731;
        Fri, 22 Nov 2019 05:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401848;
        bh=fY0cUHA/BGwsaXhpKpud9uM8lZl5kyKXm4wqjazhbmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XE5AF4ncdQR7PbJdFmvcXrJAA6iYwTnPFCgosTfgV3o+FLv8IhEf1Bo2WDsgizhcR
         eqbc8t3GWuw6670kqtzNVIqa6B3lxFwwK/y2LAHGPawEJutM2q8vH8BdDZiW2O86e0
         SbrqA9dAOdUurqj1l7RlzGU4aui8skK16w9AfjYw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin Schiller <ms@dev.tdt.de>, John Crispin <john@phrozen.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 086/219] pinctrl: xway: fix gpio-hog related boot issues
Date:   Fri, 22 Nov 2019 00:46:58 -0500
Message-Id: <20191122054911.1750-79-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Schiller <ms@dev.tdt.de>

[ Upstream commit 9b4924da4711674e62d97d4f5360446cc78337af ]

This patch is based on commit a86caa9ba5d7 ("pinctrl: msm: fix gpio-hog
related boot issues").

It fixes the issue that the gpio ranges needs to be defined before
gpiochip_add().

Therefore, we also have to swap the order of registering the pinctrl
driver and registering the gpio chip.

You also have to add the "gpio-ranges" property to the pinctrl device
node to get it finally working.

Signed-off-by: Martin Schiller <ms@dev.tdt.de>
Acked-by: John Crispin <john@phrozen.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-xway.c | 39 +++++++++++++++++++++++-----------
 1 file changed, 27 insertions(+), 12 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-xway.c b/drivers/pinctrl/pinctrl-xway.c
index 93f8bd04e7fe6..ae74b260b014b 100644
--- a/drivers/pinctrl/pinctrl-xway.c
+++ b/drivers/pinctrl/pinctrl-xway.c
@@ -1746,14 +1746,6 @@ static int pinmux_xway_probe(struct platform_device *pdev)
 	}
 	xway_pctrl_desc.pins = xway_info.pads;
 
-	/* register the gpio chip */
-	xway_chip.parent = &pdev->dev;
-	ret = devm_gpiochip_add_data(&pdev->dev, &xway_chip, NULL);
-	if (ret) {
-		dev_err(&pdev->dev, "Failed to register gpio chip\n");
-		return ret;
-	}
-
 	/* setup the data needed by pinctrl */
 	xway_pctrl_desc.name	= dev_name(&pdev->dev);
 	xway_pctrl_desc.npins	= xway_chip.ngpio;
@@ -1775,10 +1767,33 @@ static int pinmux_xway_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	/* finish with registering the gpio range in pinctrl */
-	xway_gpio_range.npins = xway_chip.ngpio;
-	xway_gpio_range.base = xway_chip.base;
-	pinctrl_add_gpio_range(xway_info.pctrl, &xway_gpio_range);
+	/* register the gpio chip */
+	xway_chip.parent = &pdev->dev;
+	xway_chip.owner = THIS_MODULE;
+	xway_chip.of_node = pdev->dev.of_node;
+	ret = devm_gpiochip_add_data(&pdev->dev, &xway_chip, NULL);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to register gpio chip\n");
+		return ret;
+	}
+
+	/*
+	 * For DeviceTree-supported systems, the gpio core checks the
+	 * pinctrl's device node for the "gpio-ranges" property.
+	 * If it is present, it takes care of adding the pin ranges
+	 * for the driver. In this case the driver can skip ahead.
+	 *
+	 * In order to remain compatible with older, existing DeviceTree
+	 * files which don't set the "gpio-ranges" property or systems that
+	 * utilize ACPI the driver has to call gpiochip_add_pin_range().
+	 */
+	if (!of_property_read_bool(pdev->dev.of_node, "gpio-ranges")) {
+		/* finish with registering the gpio range in pinctrl */
+		xway_gpio_range.npins = xway_chip.ngpio;
+		xway_gpio_range.base = xway_chip.base;
+		pinctrl_add_gpio_range(xway_info.pctrl, &xway_gpio_range);
+	}
+
 	dev_info(&pdev->dev, "Init done\n");
 	return 0;
 }
-- 
2.20.1

