Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8384FF1FB
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729589AbfKPQQR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 11:16:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:53682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728892AbfKPPrD (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:47:03 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0833520855;
        Sat, 16 Nov 2019 15:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919223;
        bh=/UtcM2CJ+MzcFJltihVFYIShK9Fi91fdbH/dA9RjkHs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XnBauPPrY73SBV8wpD2xyd2vISE6Cuob0YSM1O22s9myl0RGwSRVWbGvZ2BkXthOG
         H5iilzB4n6/rASJ/r6vM1BsQWqDTUVZE/zyoFBs3loH7y+g/YkAoNf9hFo7SSJ+VqM
         Y2XTW2rjkggV/Z2ywOAKjyKSwkHJzcE0GhHsDn8E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brian Masney <masneyb@onstation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 227/237] pinctrl: qcom: spmi-gpio: fix gpio-hog related boot issues
Date:   Sat, 16 Nov 2019 10:41:02 -0500
Message-Id: <20191116154113.7417-227-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Masney <masneyb@onstation.org>

[ Upstream commit 149a96047237574b756d872007c006acd0cc6687 ]

When attempting to setup up a gpio hog, device probing would repeatedly
fail with -EPROBE_DEFERED errors. It was caused by a circular dependency
between the gpio and pinctrl frameworks. If the gpio-ranges property is
present in device tree, then the gpio framework will handle the gpio pin
registration and eliminate the circular dependency.

See Christian Lamparter's commit a86caa9ba5d7 ("pinctrl: msm: fix
gpio-hog related boot issues") for a detailed commit message that
explains the issue in much more detail. The code comment in this commit
came from Christian's commit.

Signed-off-by: Brian Masney <masneyb@onstation.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/pinctrl-spmi-gpio.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c b/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c
index cf82db78e69e6..0c30f5eb4c714 100644
--- a/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c
+++ b/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c
@@ -1028,10 +1028,23 @@ static int pmic_gpio_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	ret = gpiochip_add_pin_range(&state->chip, dev_name(dev), 0, 0, npins);
-	if (ret) {
-		dev_err(dev, "failed to add pin range\n");
-		goto err_range;
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
+	if (!of_property_read_bool(dev->of_node, "gpio-ranges")) {
+		ret = gpiochip_add_pin_range(&state->chip, dev_name(dev), 0, 0,
+					     npins);
+		if (ret) {
+			dev_err(dev, "failed to add pin range\n");
+			goto err_range;
+		}
 	}
 
 	return 0;
-- 
2.20.1

