Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E485211AFFB
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:18:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731855AbfLKPS2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:18:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:46300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729513AbfLKPSV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:18:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EA7F208C3;
        Wed, 11 Dec 2019 15:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077500;
        bh=6+yjYSY49o8+g1oGXaNGGFl0LCIv+8rYNvgXwSC2khc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bIIoOSaVeEBDBSRObpF3xi+eWpqNA0wrUFrLjxf3PganS52n8s8TbBHZPn/dJ/Oe0
         /hiVuVw4rmKdbn2DYnclUXj2hiP15o2xDSuE+tC3SQlm4hEYsj7UsWAOZeKZTwv02U
         kSOf26fVcWuiBRHD598ikFQOLIF4sEa6/fj/Nw7I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Masney <masneyb@onstation.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 061/243] pinctrl: qcom: ssbi-gpio: fix gpio-hog related boot issues
Date:   Wed, 11 Dec 2019 16:03:43 +0100
Message-Id: <20191211150343.217792470@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Masney <masneyb@onstation.org>

[ Upstream commit 7ed07855773814337b9814f1c3e866df52ebce68 ]

When attempting to setup up a gpio hog, device probing will repeatedly
fail with -EPROBE_DEFERED errors. It is caused by a circular dependency
between the gpio and pinctrl frameworks. If the gpio-ranges property is
present in device tree, then the gpio framework will handle the gpio pin
registration and eliminate the circular dependency.

See Christian Lamparter's commit a86caa9ba5d7 ("pinctrl: msm: fix
gpio-hog related boot issues") for a detailed commit message that
explains the issue in much more detail. The code comment in this commit
came from Christian's commit.

I did not test this change against any hardware supported by this
particular driver, however I was able to validate this same fix works
for pinctrl-spmi-gpio.c using a LG Nexus 5 (hammerhead) phone.

Signed-off-by: Brian Masney <masneyb@onstation.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/pinctrl-ssbi-gpio.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/pinctrl/qcom/pinctrl-ssbi-gpio.c b/drivers/pinctrl/qcom/pinctrl-ssbi-gpio.c
index 0e153bae322ee..6bed433e54205 100644
--- a/drivers/pinctrl/qcom/pinctrl-ssbi-gpio.c
+++ b/drivers/pinctrl/qcom/pinctrl-ssbi-gpio.c
@@ -762,12 +762,23 @@ static int pm8xxx_gpio_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	ret = gpiochip_add_pin_range(&pctrl->chip,
-				     dev_name(pctrl->dev),
-				     0, 0, pctrl->chip.ngpio);
-	if (ret) {
-		dev_err(pctrl->dev, "failed to add pin range\n");
-		goto unregister_gpiochip;
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
+	if (!of_property_read_bool(pctrl->dev->of_node, "gpio-ranges")) {
+		ret = gpiochip_add_pin_range(&pctrl->chip, dev_name(pctrl->dev),
+					     0, 0, pctrl->chip.ngpio);
+		if (ret) {
+			dev_err(pctrl->dev, "failed to add pin range\n");
+			goto unregister_gpiochip;
+		}
 	}
 
 	platform_set_drvdata(pdev, pctrl);
-- 
2.20.1



