Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 204EE3CE1EB
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244330AbhGSP2Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:28:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:42112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348894AbhGSPZL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:25:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB6526008E;
        Mon, 19 Jul 2021 16:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710750;
        bh=N9tg4uOowuFl6i9wi0x5B9WKbHwNGTjWXkUqtqYIuno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=leHcqiZgOGRqy0b0k6/k7UcXqrtcKXJjRfaNxaHpYB8nRgmBf9UPyNZHxZ+Iuj6+e
         nSdkBQnYnV0K2DXVPrLqiLiYQn68foYN9EoWU0mECuvH+UeoBI/GN81spLLtjLKr/T
         /RkkCWpb4HiaD8Zg2W6y6+QlZKaISfhHqFiY86Ks=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 061/351] usb: common: usb-conn-gpio: fix NULL pointer dereference of charger
Date:   Mon, 19 Jul 2021 16:50:07 +0200
Message-Id: <20210719144946.550998180@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chunfeng Yun <chunfeng.yun@mediatek.com>

[ Upstream commit 880287910b1892ed2cb38977893b947382a09d21 ]

When power on system with OTG cable, IDDIG's interrupt arises before
the charger registration, it will cause a NULL pointer dereference,
fix the issue by registering the power supply before requesting
IDDIG/VBUS irq.

Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Link: https://lore.kernel.org/r/1621406386-18838-1-git-send-email-chunfeng.yun@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/common/usb-conn-gpio.c | 44 ++++++++++++++++++------------
 1 file changed, 26 insertions(+), 18 deletions(-)

diff --git a/drivers/usb/common/usb-conn-gpio.c b/drivers/usb/common/usb-conn-gpio.c
index 6c4e3a19f42c..c9545a4eff66 100644
--- a/drivers/usb/common/usb-conn-gpio.c
+++ b/drivers/usb/common/usb-conn-gpio.c
@@ -149,14 +149,32 @@ static int usb_charger_get_property(struct power_supply *psy,
 	return 0;
 }
 
-static int usb_conn_probe(struct platform_device *pdev)
+static int usb_conn_psy_register(struct usb_conn_info *info)
 {
-	struct device *dev = &pdev->dev;
-	struct power_supply_desc *desc;
-	struct usb_conn_info *info;
+	struct device *dev = info->dev;
+	struct power_supply_desc *desc = &info->desc;
 	struct power_supply_config cfg = {
 		.of_node = dev->of_node,
 	};
+
+	desc->name = "usb-charger";
+	desc->properties = usb_charger_properties;
+	desc->num_properties = ARRAY_SIZE(usb_charger_properties);
+	desc->get_property = usb_charger_get_property;
+	desc->type = POWER_SUPPLY_TYPE_USB;
+	cfg.drv_data = info;
+
+	info->charger = devm_power_supply_register(dev, desc, &cfg);
+	if (IS_ERR(info->charger))
+		dev_err(dev, "Unable to register charger\n");
+
+	return PTR_ERR_OR_ZERO(info->charger);
+}
+
+static int usb_conn_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct usb_conn_info *info;
 	bool need_vbus = true;
 	int ret = 0;
 
@@ -218,6 +236,10 @@ static int usb_conn_probe(struct platform_device *pdev)
 		return PTR_ERR(info->role_sw);
 	}
 
+	ret = usb_conn_psy_register(info);
+	if (ret)
+		goto put_role_sw;
+
 	if (info->id_gpiod) {
 		info->id_irq = gpiod_to_irq(info->id_gpiod);
 		if (info->id_irq < 0) {
@@ -252,20 +274,6 @@ static int usb_conn_probe(struct platform_device *pdev)
 		}
 	}
 
-	desc = &info->desc;
-	desc->name = "usb-charger";
-	desc->properties = usb_charger_properties;
-	desc->num_properties = ARRAY_SIZE(usb_charger_properties);
-	desc->get_property = usb_charger_get_property;
-	desc->type = POWER_SUPPLY_TYPE_USB;
-	cfg.drv_data = info;
-
-	info->charger = devm_power_supply_register(dev, desc, &cfg);
-	if (IS_ERR(info->charger)) {
-		dev_err(dev, "Unable to register charger\n");
-		return PTR_ERR(info->charger);
-	}
-
 	platform_set_drvdata(pdev, info);
 
 	/* Perform initial detection */
-- 
2.30.2



