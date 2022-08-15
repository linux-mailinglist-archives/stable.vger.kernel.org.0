Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57C58594FC4
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbiHPEcZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:32:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbiHPEcE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:32:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C681165726;
        Mon, 15 Aug 2022 13:22:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4B37B80EAD;
        Mon, 15 Aug 2022 20:22:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3428C433C1;
        Mon, 15 Aug 2022 20:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594965;
        bh=iNo/LO41dBsaQDRtTqkiOLvpSgWW5TzPoPLvvxIj5bo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OdAMSm5VUg2Czd3EcQMWEY9NqyAaMFM/iRWe11k0CQl/AuqLr19Zsidc+qynIIrXa
         94oawwP6AZdKlh6zeyoOogUG6JrooSYHukX9NuNOqDLieoXKCSe5NV6+f1zuvSV+7j
         MVbiR6Q3zVQ2n8QUo/311wGHVAOuHNOpLcTiAJjs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0613/1157] usb: host: ohci-at91: add support to enter suspend using SMC
Date:   Mon, 15 Aug 2022 19:59:29 +0200
Message-Id: <20220815180504.170811259@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Clément Léger <clement.leger@bootlin.com>

[ Upstream commit 1e073e3ed9ff9ec14e7e360ed89a81256d895588 ]

When Linux is running under OP-TEE, the SFR is set as secured and thus
the AT91_OHCIICR_USB_SUSPEND register isn't accessible. Add a SMC to
do the appropriate call to suspend the controller.
The SMC id is fetched from the device-tree property
"microchip,suspend-smc-id". if present, then the syscon regmap is not
used to enter suspend and a SMC is issued.

Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Clément Léger <clement.leger@bootlin.com>
Link: https://lore.kernel.org/r/20220607133454.727063-1-clement.leger@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/ohci-at91.c | 69 ++++++++++++++++++++++++------------
 1 file changed, 46 insertions(+), 23 deletions(-)

diff --git a/drivers/usb/host/ohci-at91.c b/drivers/usb/host/ohci-at91.c
index a24aea3d2759..98326465e2dc 100644
--- a/drivers/usb/host/ohci-at91.c
+++ b/drivers/usb/host/ohci-at91.c
@@ -13,6 +13,7 @@
  * This file is licenced under the GPL.
  */
 
+#include <linux/arm-smccc.h>
 #include <linux/clk.h>
 #include <linux/dma-mapping.h>
 #include <linux/gpio/consumer.h>
@@ -55,6 +56,7 @@ struct ohci_at91_priv {
 	bool clocked;
 	bool wakeup;		/* Saved wake-up state for resume */
 	struct regmap *sfr_regmap;
+	u32 suspend_smc_id;
 };
 /* interface and function clocks; sometimes also an AHB clock */
 
@@ -135,6 +137,19 @@ static void at91_stop_hc(struct platform_device *pdev)
 
 static void usb_hcd_at91_remove (struct usb_hcd *, struct platform_device *);
 
+static u32 at91_dt_suspend_smc(struct device *dev)
+{
+	u32 suspend_smc_id;
+
+	if (!dev->of_node)
+		return 0;
+
+	if (of_property_read_u32(dev->of_node, "microchip,suspend-smc-id", &suspend_smc_id))
+		return 0;
+
+	return suspend_smc_id;
+}
+
 static struct regmap *at91_dt_syscon_sfr(void)
 {
 	struct regmap *regmap;
@@ -215,9 +230,13 @@ static int usb_hcd_at91_probe(const struct hc_driver *driver,
 		goto err;
 	}
 
-	ohci_at91->sfr_regmap = at91_dt_syscon_sfr();
-	if (!ohci_at91->sfr_regmap)
-		dev_dbg(dev, "failed to find sfr node\n");
+	ohci_at91->suspend_smc_id = at91_dt_suspend_smc(dev);
+	if (!ohci_at91->suspend_smc_id)  {
+		dev_dbg(dev, "failed to find sfr suspend smc id, using regmap\n");
+		ohci_at91->sfr_regmap = at91_dt_syscon_sfr();
+		if (!ohci_at91->sfr_regmap)
+			dev_dbg(dev, "failed to find sfr node\n");
+	}
 
 	board = hcd->self.controller->platform_data;
 	ohci = hcd_to_ohci(hcd);
@@ -303,24 +322,30 @@ static int ohci_at91_hub_status_data(struct usb_hcd *hcd, char *buf)
 	return length;
 }
 
-static int ohci_at91_port_suspend(struct regmap *regmap, u8 set)
+static int ohci_at91_port_suspend(struct ohci_at91_priv *ohci_at91, u8 set)
 {
+	struct regmap *regmap = ohci_at91->sfr_regmap;
 	u32 regval;
 	int ret;
 
-	if (!regmap)
-		return 0;
+	if (ohci_at91->suspend_smc_id) {
+		struct arm_smccc_res res;
 
-	ret = regmap_read(regmap, AT91_SFR_OHCIICR, &regval);
-	if (ret)
-		return ret;
+		arm_smccc_smc(ohci_at91->suspend_smc_id, set, 0, 0, 0, 0, 0, 0, &res);
+		if (res.a0)
+			return -EINVAL;
+	} else if (regmap) {
+		ret = regmap_read(regmap, AT91_SFR_OHCIICR, &regval);
+		if (ret)
+			return ret;
 
-	if (set)
-		regval |= AT91_OHCIICR_USB_SUSPEND;
-	else
-		regval &= ~AT91_OHCIICR_USB_SUSPEND;
+		if (set)
+			regval |= AT91_OHCIICR_USB_SUSPEND;
+		else
+			regval &= ~AT91_OHCIICR_USB_SUSPEND;
 
-	regmap_write(regmap, AT91_SFR_OHCIICR, regval);
+		regmap_write(regmap, AT91_SFR_OHCIICR, regval);
+	}
 
 	return 0;
 }
@@ -357,9 +382,8 @@ static int ohci_at91_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 
 		case USB_PORT_FEAT_SUSPEND:
 			dev_dbg(hcd->self.controller, "SetPortFeat: SUSPEND\n");
-			if (valid_port(wIndex) && ohci_at91->sfr_regmap) {
-				ohci_at91_port_suspend(ohci_at91->sfr_regmap,
-						       1);
+			if (valid_port(wIndex)) {
+				ohci_at91_port_suspend(ohci_at91, 1);
 				return 0;
 			}
 			break;
@@ -400,9 +424,8 @@ static int ohci_at91_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 
 		case USB_PORT_FEAT_SUSPEND:
 			dev_dbg(hcd->self.controller, "ClearPortFeature: SUSPEND\n");
-			if (valid_port(wIndex) && ohci_at91->sfr_regmap) {
-				ohci_at91_port_suspend(ohci_at91->sfr_regmap,
-						       0);
+			if (valid_port(wIndex)) {
+				ohci_at91_port_suspend(ohci_at91, 0);
 				return 0;
 			}
 			break;
@@ -630,10 +653,10 @@ ohci_hcd_at91_drv_suspend(struct device *dev)
 		/* flush the writes */
 		(void) ohci_readl (ohci, &ohci->regs->control);
 		msleep(1);
-		ohci_at91_port_suspend(ohci_at91->sfr_regmap, 1);
+		ohci_at91_port_suspend(ohci_at91, 1);
 		at91_stop_clock(ohci_at91);
 	} else {
-		ohci_at91_port_suspend(ohci_at91->sfr_regmap, 1);
+		ohci_at91_port_suspend(ohci_at91, 1);
 	}
 
 	return ret;
@@ -645,7 +668,7 @@ ohci_hcd_at91_drv_resume(struct device *dev)
 	struct usb_hcd	*hcd = dev_get_drvdata(dev);
 	struct ohci_at91_priv *ohci_at91 = hcd_to_ohci_at91_priv(hcd);
 
-	ohci_at91_port_suspend(ohci_at91->sfr_regmap, 0);
+	ohci_at91_port_suspend(ohci_at91, 0);
 
 	if (ohci_at91->wakeup)
 		disable_irq_wake(hcd->irq);
-- 
2.35.1



