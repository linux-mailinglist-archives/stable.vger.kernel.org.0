Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80C3F2692BB
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 19:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726280AbgINRNg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Sep 2020 13:13:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:59536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726582AbgINNED (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Sep 2020 09:04:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0687121655;
        Mon, 14 Sep 2020 13:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600088642;
        bh=Llbw0CYSQemtqBZuEhbhie3lulMzKLoDz/N99EKFMTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YI9frMDcHbJtNOyVdE/SHhuBmoB6Qyu1f+CHtwB6k4vfet1jEvFn0WbcQ8U1jYp3J
         9bVvYXskGyRDZliMBwIGPQyXHhYP/BsfcBDe8JWs30O/1jXjX6DCbJaTezpvU3HtP3
         uWbpMZw/JLt617q8wPKztXLi36OHekIJZ3dpEOtc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Roger Quadros <rogerq@ti.com>, Jan Kiszka <jan.kiszka@siemens.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.8 03/29] phy: omap-usb2-phy: disable PHY charger detect
Date:   Mon, 14 Sep 2020 09:03:32 -0400
Message-Id: <20200914130358.1804194-3-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200914130358.1804194-1-sashal@kernel.org>
References: <20200914130358.1804194-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roger Quadros <rogerq@ti.com>

[ Upstream commit ad7a7acaedcf45071c822b6c983f9c1e084041c9 ]

AM654x PG1.0 has a silicon bug that D+ is pulled high after POR, which
could cause enumeration failure with some USB hubs.  Disabling the
USB2_PHY Charger Detect function will put D+ into the normal state.

This addresses Silicon Errata:
i2075 - "USB2PHY: USB2PHY Charger Detect is Enabled by Default Without VBUS
Presence"

Signed-off-by: Roger Quadros <rogerq@ti.com>
Tested-by: Jan Kiszka <jan.kiszka@siemens.com>
Link: https://lore.kernel.org/r/20200824075127.14902-2-rogerq@ti.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/ti/phy-omap-usb2.c | 47 +++++++++++++++++++++++++++++-----
 1 file changed, 40 insertions(+), 7 deletions(-)

diff --git a/drivers/phy/ti/phy-omap-usb2.c b/drivers/phy/ti/phy-omap-usb2.c
index cb2dd3230fa76..507f79d14adb8 100644
--- a/drivers/phy/ti/phy-omap-usb2.c
+++ b/drivers/phy/ti/phy-omap-usb2.c
@@ -22,10 +22,15 @@
 #include <linux/mfd/syscon.h>
 #include <linux/regmap.h>
 #include <linux/of_platform.h>
+#include <linux/sys_soc.h>
 
 #define USB2PHY_ANA_CONFIG1		0x4c
 #define USB2PHY_DISCON_BYP_LATCH	BIT(31)
 
+#define USB2PHY_CHRG_DET			0x14
+#define USB2PHY_CHRG_DET_USE_CHG_DET_REG	BIT(29)
+#define USB2PHY_CHRG_DET_DIS_CHG_DET		BIT(28)
+
 /* SoC Specific USB2_OTG register definitions */
 #define AM654_USB2_OTG_PD		BIT(8)
 #define AM654_USB2_VBUS_DET_EN		BIT(5)
@@ -43,6 +48,7 @@
 #define OMAP_USB2_HAS_START_SRP			BIT(0)
 #define OMAP_USB2_HAS_SET_VBUS			BIT(1)
 #define OMAP_USB2_CALIBRATE_FALSE_DISCONNECT	BIT(2)
+#define OMAP_USB2_DISABLE_CHRG_DET		BIT(3)
 
 struct omap_usb {
 	struct usb_phy		phy;
@@ -236,6 +242,13 @@ static int omap_usb_init(struct phy *x)
 		omap_usb_writel(phy->phy_base, USB2PHY_ANA_CONFIG1, val);
 	}
 
+	if (phy->flags & OMAP_USB2_DISABLE_CHRG_DET) {
+		val = omap_usb_readl(phy->phy_base, USB2PHY_CHRG_DET);
+		val |= USB2PHY_CHRG_DET_USE_CHG_DET_REG |
+		       USB2PHY_CHRG_DET_DIS_CHG_DET;
+		omap_usb_writel(phy->phy_base, USB2PHY_CHRG_DET, val);
+	}
+
 	return 0;
 }
 
@@ -329,6 +342,26 @@ static const struct of_device_id omap_usb2_id_table[] = {
 };
 MODULE_DEVICE_TABLE(of, omap_usb2_id_table);
 
+static void omap_usb2_init_errata(struct omap_usb *phy)
+{
+	static const struct soc_device_attribute am65x_sr10_soc_devices[] = {
+		{ .family = "AM65X", .revision = "SR1.0" },
+		{ /* sentinel */ }
+	};
+
+	/*
+	 * Errata i2075: USB2PHY: USB2PHY Charger Detect is Enabled by
+	 * Default Without VBUS Presence.
+	 *
+	 * AM654x SR1.0 has a silicon bug due to which D+ is pulled high after
+	 * POR, which could cause enumeration failure with some USB hubs.
+	 * Disabling the USB2_PHY Charger Detect function will put D+
+	 * into the normal state.
+	 */
+	if (soc_device_match(am65x_sr10_soc_devices))
+		phy->flags |= OMAP_USB2_DISABLE_CHRG_DET;
+}
+
 static int omap_usb2_probe(struct platform_device *pdev)
 {
 	struct omap_usb	*phy;
@@ -366,14 +399,14 @@ static int omap_usb2_probe(struct platform_device *pdev)
 	phy->mask		= phy_data->mask;
 	phy->power_on		= phy_data->power_on;
 	phy->power_off		= phy_data->power_off;
+	phy->flags		= phy_data->flags;
 
-	if (phy_data->flags & OMAP_USB2_CALIBRATE_FALSE_DISCONNECT) {
-		res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-		phy->phy_base = devm_ioremap_resource(&pdev->dev, res);
-		if (IS_ERR(phy->phy_base))
-			return PTR_ERR(phy->phy_base);
-		phy->flags |= OMAP_USB2_CALIBRATE_FALSE_DISCONNECT;
-	}
+	omap_usb2_init_errata(phy);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	phy->phy_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(phy->phy_base))
+		return PTR_ERR(phy->phy_base);
 
 	phy->syscon_phy_power = syscon_regmap_lookup_by_phandle(node,
 							"syscon-phy-power");
-- 
2.25.1

