Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36776126942
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727378AbfLSSf6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:35:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:52728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727368AbfLSSf5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:35:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72E6724686;
        Thu, 19 Dec 2019 18:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576780556;
        bh=1STtCvVJpTO3Clyji7skWF6q9V/tnqEw3HGtJ7bLgng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q1EZCEEE7Zh08Q04ddHXGAFTYfksaB/aVPpOPoZP9FgsZEh+havkoyY5tFBFySIRd
         VC8Ul4dsFKmGVLBIx+yaY9OofSmJZGd6P3jJizVySfxHGn082Hiehe6cMoHZA5ufsC
         0URcLQd+ZeiyZHJ4PgYUylKo278wD025TVihbAKU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Masney <masneyb@onstation.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 022/162] pinctrl: qcom: ssbi-gpio: fix gpio-hog related boot issues
Date:   Thu, 19 Dec 2019 19:32:10 +0100
Message-Id: <20191219183208.625746119@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183150.477687052@linuxfoundation.org>
References: <20191219183150.477687052@linuxfoundation.org>
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
index b1e8a2d905ff1..a0904e426c734 100644
--- a/drivers/pinctrl/qcom/pinctrl-ssbi-gpio.c
+++ b/drivers/pinctrl/qcom/pinctrl-ssbi-gpio.c
@@ -755,12 +755,23 @@ static int pm8xxx_gpio_probe(struct platform_device *pdev)
 		goto unregister_pinctrl;
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



