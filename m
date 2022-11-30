Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABE1463DDD3
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:30:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbiK3Say (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:30:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiK3Sav (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:30:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6C3C900D9
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:30:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4696461D05
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:30:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53A5FC433C1;
        Wed, 30 Nov 2022 18:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833048;
        bh=1zYcFXZeiDkf3JQH8BRb9q+x1R8Bm9swnLdRA/d8eTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DxgxI8Mz2SPAgVb4d1Zoi4HiAXbJePOfy+DBLTsEy9kRKIc7TJwrQNuDObwbS58g3
         H9gPv1nTzJV3XbDD/3nm0jpCLPBGfNlsfvh1n+l13DRO6issd3lnhE1SFDtFPyK78H
         COclyoyHQg021Vt7b648jKsse7xq200730H0+P54=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pawel Laszczak <pawell@cadence.com>,
        Aswath Govindraju <a-govindraju@ti.com>,
        Peter Chen <peter.chen@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 105/162] usb: cdns3: Add support for DRD CDNSP
Date:   Wed, 30 Nov 2022 19:23:06 +0100
Message-Id: <20221130180531.336943463@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawel Laszczak <pawell@cadence.com>

[ Upstream commit db8892bb1bb64b6e3d1381ac342a2ee31e1b76b6 ]

Patch adds support for Cadence DRD Super Speed Plus controller(CDNSP).
CDNSP DRD is a part of Cadence CDNSP controller.
The DRD CDNSP controller has a lot of difference on hardware level but on
software level is quite compatible with CDNS3 DRD. For this reason
CDNS3 DRD part of CDNS3 driver was reused for CDNSP driver.

Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Tested-by: Aswath Govindraju <a-govindraju@ti.com>
Signed-off-by: Peter Chen <peter.chen@nxp.com>
Stable-dep-of: 9d5333c93134 ("usb: cdns3: host: fix endless superspeed hub port reset")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/cdns3/core.c |  24 +++++++---
 drivers/usb/cdns3/core.h |   5 ++
 drivers/usb/cdns3/drd.c  | 101 +++++++++++++++++++++++++++------------
 drivers/usb/cdns3/drd.h  |  67 +++++++++++++++++++++-----
 4 files changed, 148 insertions(+), 49 deletions(-)

diff --git a/drivers/usb/cdns3/core.c b/drivers/usb/cdns3/core.c
index 6eeb7ed8e91f..8fe7420de033 100644
--- a/drivers/usb/cdns3/core.c
+++ b/drivers/usb/cdns3/core.c
@@ -97,13 +97,23 @@ static int cdns3_core_init_role(struct cdns3 *cdns)
 	 * can be restricted later depending on strap pin configuration.
 	 */
 	if (dr_mode == USB_DR_MODE_UNKNOWN) {
-		if (IS_ENABLED(CONFIG_USB_CDNS3_HOST) &&
-		    IS_ENABLED(CONFIG_USB_CDNS3_GADGET))
-			dr_mode = USB_DR_MODE_OTG;
-		else if (IS_ENABLED(CONFIG_USB_CDNS3_HOST))
-			dr_mode = USB_DR_MODE_HOST;
-		else if (IS_ENABLED(CONFIG_USB_CDNS3_GADGET))
-			dr_mode = USB_DR_MODE_PERIPHERAL;
+		if (cdns->version == CDNSP_CONTROLLER_V2) {
+			if (IS_ENABLED(CONFIG_USB_CDNSP_HOST) &&
+			    IS_ENABLED(CONFIG_USB_CDNSP_GADGET))
+				dr_mode = USB_DR_MODE_OTG;
+			else if (IS_ENABLED(CONFIG_USB_CDNSP_HOST))
+				dr_mode = USB_DR_MODE_HOST;
+			else if (IS_ENABLED(CONFIG_USB_CDNSP_GADGET))
+				dr_mode = USB_DR_MODE_PERIPHERAL;
+		} else {
+			if (IS_ENABLED(CONFIG_USB_CDNS3_HOST) &&
+			    IS_ENABLED(CONFIG_USB_CDNS3_GADGET))
+				dr_mode = USB_DR_MODE_OTG;
+			else if (IS_ENABLED(CONFIG_USB_CDNS3_HOST))
+				dr_mode = USB_DR_MODE_HOST;
+			else if (IS_ENABLED(CONFIG_USB_CDNS3_GADGET))
+				dr_mode = USB_DR_MODE_PERIPHERAL;
+		}
 	}
 
 	/*
diff --git a/drivers/usb/cdns3/core.h b/drivers/usb/cdns3/core.h
index 3176f924293a..0d87871499ea 100644
--- a/drivers/usb/cdns3/core.h
+++ b/drivers/usb/cdns3/core.h
@@ -55,7 +55,9 @@ struct cdns3_platform_data {
  * @otg_res: the resource for otg
  * @otg_v0_regs: pointer to base of v0 otg registers
  * @otg_v1_regs: pointer to base of v1 otg registers
+ * @otg_cdnsp_regs: pointer to base of CDNSP otg registers
  * @otg_regs: pointer to base of otg registers
+ * @otg_irq_regs: pointer to interrupt registers
  * @otg_irq: irq number for otg controller
  * @dev_irq: irq number for device controller
  * @wakeup_irq: irq number for wakeup event, it is optional
@@ -86,9 +88,12 @@ struct cdns3 {
 	struct resource			otg_res;
 	struct cdns3_otg_legacy_regs	*otg_v0_regs;
 	struct cdns3_otg_regs		*otg_v1_regs;
+	struct cdnsp_otg_regs		*otg_cdnsp_regs;
 	struct cdns3_otg_common_regs	*otg_regs;
+	struct cdns3_otg_irq_regs	*otg_irq_regs;
 #define CDNS3_CONTROLLER_V0	0
 #define CDNS3_CONTROLLER_V1	1
+#define CDNSP_CONTROLLER_V2	2
 	u32				version;
 	bool				phyrst_a_enable;
 
diff --git a/drivers/usb/cdns3/drd.c b/drivers/usb/cdns3/drd.c
index 38ccd29e4cde..95863d44e3e0 100644
--- a/drivers/usb/cdns3/drd.c
+++ b/drivers/usb/cdns3/drd.c
@@ -2,13 +2,12 @@
 /*
  * Cadence USBSS DRD Driver.
  *
- * Copyright (C) 2018-2019 Cadence.
+ * Copyright (C) 2018-2020 Cadence.
  * Copyright (C) 2019 Texas Instruments
  *
  * Author: Pawel Laszczak <pawell@cadence.com>
  *         Roger Quadros <rogerq@ti.com>
  *
- *
  */
 #include <linux/kernel.h>
 #include <linux/interrupt.h>
@@ -28,8 +27,9 @@
  *
  * Returns 0 on success otherwise negative errno
  */
-int cdns3_set_mode(struct cdns3 *cdns, enum usb_dr_mode mode)
+static int cdns3_set_mode(struct cdns3 *cdns, enum usb_dr_mode mode)
 {
+	u32 __iomem *override_reg;
 	u32 reg;
 
 	switch (mode) {
@@ -39,11 +39,24 @@ int cdns3_set_mode(struct cdns3 *cdns, enum usb_dr_mode mode)
 		break;
 	case USB_DR_MODE_OTG:
 		dev_dbg(cdns->dev, "Set controller to OTG mode\n");
-		if (cdns->version == CDNS3_CONTROLLER_V1) {
-			reg = readl(&cdns->otg_v1_regs->override);
+
+		if (cdns->version == CDNSP_CONTROLLER_V2)
+			override_reg = &cdns->otg_cdnsp_regs->override;
+		else if (cdns->version == CDNS3_CONTROLLER_V1)
+			override_reg = &cdns->otg_v1_regs->override;
+		else
+			override_reg = &cdns->otg_v0_regs->ctrl1;
+
+		reg = readl(override_reg);
+
+		if (cdns->version != CDNS3_CONTROLLER_V0)
 			reg |= OVERRIDE_IDPULLUP;
-			writel(reg, &cdns->otg_v1_regs->override);
+		else
+			reg |= OVERRIDE_IDPULLUP_V0;
 
+		writel(reg, override_reg);
+
+		if (cdns->version == CDNS3_CONTROLLER_V1) {
 			/*
 			 * Enable work around feature built into the
 			 * controller to address issue with RX Sensitivity
@@ -55,10 +68,6 @@ int cdns3_set_mode(struct cdns3 *cdns, enum usb_dr_mode mode)
 				reg |= PHYRST_CFG_PHYRST_A_ENABLE;
 				writel(reg, &cdns->otg_v1_regs->phyrst_cfg);
 			}
-		} else {
-			reg = readl(&cdns->otg_v0_regs->ctrl1);
-			reg |= OVERRIDE_IDPULLUP_V0;
-			writel(reg, &cdns->otg_v0_regs->ctrl1);
 		}
 
 		/*
@@ -123,7 +132,7 @@ bool cdns3_is_device(struct cdns3 *cdns)
  */
 static void cdns3_otg_disable_irq(struct cdns3 *cdns)
 {
-	writel(0, &cdns->otg_regs->ien);
+	writel(0, &cdns->otg_irq_regs->ien);
 }
 
 /**
@@ -133,7 +142,7 @@ static void cdns3_otg_disable_irq(struct cdns3 *cdns)
 static void cdns3_otg_enable_irq(struct cdns3 *cdns)
 {
 	writel(OTGIEN_ID_CHANGE_INT | OTGIEN_VBUSVALID_RISE_INT |
-	       OTGIEN_VBUSVALID_FALL_INT, &cdns->otg_regs->ien);
+	       OTGIEN_VBUSVALID_FALL_INT, &cdns->otg_irq_regs->ien);
 }
 
 /**
@@ -144,16 +153,21 @@ static void cdns3_otg_enable_irq(struct cdns3 *cdns)
  */
 int cdns3_drd_host_on(struct cdns3 *cdns)
 {
-	u32 val;
+	u32 val, ready_bit;
 	int ret;
 
 	/* Enable host mode. */
 	writel(OTGCMD_HOST_BUS_REQ | OTGCMD_OTG_DIS,
 	       &cdns->otg_regs->cmd);
 
+	if (cdns->version == CDNSP_CONTROLLER_V2)
+		ready_bit = OTGSTS_CDNSP_XHCI_READY;
+	else
+		ready_bit = OTGSTS_CDNS3_XHCI_READY;
+
 	dev_dbg(cdns->dev, "Waiting till Host mode is turned on\n");
 	ret = readl_poll_timeout_atomic(&cdns->otg_regs->sts, val,
-					val & OTGSTS_XHCI_READY, 1, 100000);
+					val & ready_bit, 1, 100000);
 
 	if (ret)
 		dev_err(cdns->dev, "timeout waiting for xhci_ready\n");
@@ -189,17 +203,22 @@ void cdns3_drd_host_off(struct cdns3 *cdns)
  */
 int cdns3_drd_gadget_on(struct cdns3 *cdns)
 {
-	int ret, val;
 	u32 reg = OTGCMD_OTG_DIS;
+	u32 ready_bit;
+	int ret, val;
 
 	/* switch OTG core */
 	writel(OTGCMD_DEV_BUS_REQ | reg, &cdns->otg_regs->cmd);
 
 	dev_dbg(cdns->dev, "Waiting till Device mode is turned on\n");
 
+	if (cdns->version == CDNSP_CONTROLLER_V2)
+		ready_bit = OTGSTS_CDNSP_DEV_READY;
+	else
+		ready_bit = OTGSTS_CDNS3_DEV_READY;
+
 	ret = readl_poll_timeout_atomic(&cdns->otg_regs->sts, val,
-					val & OTGSTS_DEV_READY,
-					1, 100000);
+					val & ready_bit, 1, 100000);
 	if (ret) {
 		dev_err(cdns->dev, "timeout waiting for dev_ready\n");
 		return ret;
@@ -244,7 +263,7 @@ static int cdns3_init_otg_mode(struct cdns3 *cdns)
 
 	cdns3_otg_disable_irq(cdns);
 	/* clear all interrupts */
-	writel(~0, &cdns->otg_regs->ivect);
+	writel(~0, &cdns->otg_irq_regs->ivect);
 
 	ret = cdns3_set_mode(cdns, USB_DR_MODE_OTG);
 	if (ret)
@@ -313,7 +332,7 @@ static irqreturn_t cdns3_drd_irq(int irq, void *data)
 	if (cdns->in_lpm)
 		return ret;
 
-	reg = readl(&cdns->otg_regs->ivect);
+	reg = readl(&cdns->otg_irq_regs->ivect);
 
 	if (!reg)
 		return IRQ_NONE;
@@ -332,7 +351,7 @@ static irqreturn_t cdns3_drd_irq(int irq, void *data)
 		ret = IRQ_WAKE_THREAD;
 	}
 
-	writel(~0, &cdns->otg_regs->ivect);
+	writel(~0, &cdns->otg_irq_regs->ivect);
 	return ret;
 }
 
@@ -347,28 +366,43 @@ int cdns3_drd_init(struct cdns3 *cdns)
 		return PTR_ERR(regs);
 
 	/* Detection of DRD version. Controller has been released
-	 * in two versions. Both are similar, but they have same changes
-	 * in register maps.
-	 * The first register in old version is command register and it's read
-	 * only, so driver should read 0 from it. On the other hand, in v1
-	 * the first register contains device ID number which is not set to 0.
-	 * Driver uses this fact to detect the proper version of
+	 * in three versions. All are very similar and are software compatible,
+	 * but they have same changes in register maps.
+	 * The first register in oldest version is command register and it's
+	 * read only. Driver should read 0 from it. On the other hand, in v1
+	 * and v2 the first register contains device ID number which is not
+	 * set to 0. Driver uses this fact to detect the proper version of
 	 * controller.
 	 */
 	cdns->otg_v0_regs = regs;
 	if (!readl(&cdns->otg_v0_regs->cmd)) {
 		cdns->version  = CDNS3_CONTROLLER_V0;
 		cdns->otg_v1_regs = NULL;
+		cdns->otg_cdnsp_regs = NULL;
 		cdns->otg_regs = regs;
+		cdns->otg_irq_regs = (struct cdns3_otg_irq_regs *)
+				     &cdns->otg_v0_regs->ien;
 		writel(1, &cdns->otg_v0_regs->simulate);
 		dev_dbg(cdns->dev, "DRD version v0 (%08x)\n",
 			 readl(&cdns->otg_v0_regs->version));
 	} else {
 		cdns->otg_v0_regs = NULL;
 		cdns->otg_v1_regs = regs;
+		cdns->otg_cdnsp_regs = regs;
+
 		cdns->otg_regs = (void *)&cdns->otg_v1_regs->cmd;
-		cdns->version  = CDNS3_CONTROLLER_V1;
-		writel(1, &cdns->otg_v1_regs->simulate);
+
+		if (cdns->otg_cdnsp_regs->did == OTG_CDNSP_DID) {
+			cdns->otg_irq_regs = (struct cdns3_otg_irq_regs *)
+					      &cdns->otg_cdnsp_regs->ien;
+			cdns->version  = CDNSP_CONTROLLER_V2;
+		} else {
+			cdns->otg_irq_regs = (struct cdns3_otg_irq_regs *)
+					      &cdns->otg_v1_regs->ien;
+			writel(1, &cdns->otg_v1_regs->simulate);
+			cdns->version  = CDNS3_CONTROLLER_V1;
+		}
+
 		dev_dbg(cdns->dev, "DRD version v1 (ID: %08x, rev: %08x)\n",
 			 readl(&cdns->otg_v1_regs->did),
 			 readl(&cdns->otg_v1_regs->rid));
@@ -378,10 +412,17 @@ int cdns3_drd_init(struct cdns3 *cdns)
 
 	/* Update dr_mode according to STRAP configuration. */
 	cdns->dr_mode = USB_DR_MODE_OTG;
-	if (state == OTGSTS_STRAP_HOST) {
+
+	if ((cdns->version == CDNSP_CONTROLLER_V2 &&
+	     state == OTGSTS_CDNSP_STRAP_HOST) ||
+	    (cdns->version != CDNSP_CONTROLLER_V2 &&
+	     state == OTGSTS_STRAP_HOST)) {
 		dev_dbg(cdns->dev, "Controller strapped to HOST\n");
 		cdns->dr_mode = USB_DR_MODE_HOST;
-	} else if (state == OTGSTS_STRAP_GADGET) {
+	} else if ((cdns->version == CDNSP_CONTROLLER_V2 &&
+		    state == OTGSTS_CDNSP_STRAP_GADGET) ||
+		   (cdns->version != CDNSP_CONTROLLER_V2 &&
+		    state == OTGSTS_STRAP_GADGET)) {
 		dev_dbg(cdns->dev, "Controller strapped to PERIPHERAL\n");
 		cdns->dr_mode = USB_DR_MODE_PERIPHERAL;
 	}
diff --git a/drivers/usb/cdns3/drd.h b/drivers/usb/cdns3/drd.h
index f1ccae285a16..a767b6893938 100644
--- a/drivers/usb/cdns3/drd.h
+++ b/drivers/usb/cdns3/drd.h
@@ -1,8 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /*
- * Cadence USB3 DRD header file.
+ * Cadence USB3 and USBSSP DRD header file.
  *
- * Copyright (C) 2018-2019 Cadence.
+ * Copyright (C) 2018-2020 Cadence.
  *
  * Author: Pawel Laszczak <pawell@cadence.com>
  */
@@ -13,7 +13,7 @@
 #include <linux/phy/phy.h>
 #include "core.h"
 
-/*  DRD register interface for version v1. */
+/*  DRD register interface for version v1 of cdns3 driver. */
 struct cdns3_otg_regs {
 	__le32 did;
 	__le32 rid;
@@ -38,7 +38,7 @@ struct cdns3_otg_regs {
 	__le32 ctrl2;
 };
 
-/*  DRD register interface for version v0. */
+/*  DRD register interface for version v0 of cdns3 driver. */
 struct cdns3_otg_legacy_regs {
 	__le32 cmd;
 	__le32 sts;
@@ -57,14 +57,45 @@ struct cdns3_otg_legacy_regs {
 	__le32 ctrl1;
 };
 
+/* DRD register interface for cdnsp driver */
+struct cdnsp_otg_regs {
+	__le32 did;
+	__le32 rid;
+	__le32 cfgs1;
+	__le32 cfgs2;
+	__le32 cmd;
+	__le32 sts;
+	__le32 state;
+	__le32 ien;
+	__le32 ivect;
+	__le32 tmr;
+	__le32 simulate;
+	__le32 adpbc_sts;
+	__le32 adp_ramp_time;
+	__le32 adpbc_ctrl1;
+	__le32 adpbc_ctrl2;
+	__le32 override;
+	__le32 vbusvalid_dbnc_cfg;
+	__le32 sessvalid_dbnc_cfg;
+	__le32 susp_timing_ctrl;
+};
+
+#define OTG_CDNSP_DID	0x0004034E
+
 /*
- * Common registers interface for both version of DRD.
+ * Common registers interface for both CDNS3 and CDNSP version of DRD.
  */
 struct cdns3_otg_common_regs {
 	__le32 cmd;
 	__le32 sts;
 	__le32 state;
-	__le32 different1;
+};
+
+/*
+ * Interrupt related registers. This registers are mapped in different
+ * location for CDNSP controller.
+ */
+struct cdns3_otg_irq_regs {
 	__le32 ien;
 	__le32 ivect;
 };
@@ -92,9 +123,9 @@ struct cdns3_otg_common_regs {
 #define OTGCMD_DEV_BUS_DROP		BIT(8)
 /* Drop the bus for Host mode*/
 #define OTGCMD_HOST_BUS_DROP		BIT(9)
-/* Power Down USBSS-DEV. */
+/* Power Down USBSS-DEV - only for CDNS3.*/
 #define OTGCMD_DEV_POWER_OFF		BIT(11)
-/* Power Down CDNSXHCI. */
+/* Power Down CDNSXHCI - only for CDNS3. */
 #define OTGCMD_HOST_POWER_OFF		BIT(12)
 
 /* OTGIEN - bitmasks */
@@ -123,20 +154,31 @@ struct cdns3_otg_common_regs {
 #define OTGSTS_OTG_NRDY_MASK		BIT(11)
 #define OTGSTS_OTG_NRDY(p)		((p) & OTGSTS_OTG_NRDY_MASK)
 /*
- * Value of the strap pins.
+ * Value of the strap pins for:
+ * CDNS3:
  * 000 - no default configuration
  * 010 - Controller initiall configured as Host
  * 100 - Controller initially configured as Device
+ * CDNSP:
+ * 000 - No default configuration.
+ * 010 - Controller initiall configured as Host.
+ * 100 - Controller initially configured as Device.
  */
 #define OTGSTS_STRAP(p)			(((p) & GENMASK(14, 12)) >> 12)
 #define OTGSTS_STRAP_NO_DEFAULT_CFG	0x00
 #define OTGSTS_STRAP_HOST_OTG		0x01
 #define OTGSTS_STRAP_HOST		0x02
 #define OTGSTS_STRAP_GADGET		0x04
+#define OTGSTS_CDNSP_STRAP_HOST		0x01
+#define OTGSTS_CDNSP_STRAP_GADGET	0x02
+
 /* Host mode is turned on. */
-#define OTGSTS_XHCI_READY		BIT(26)
+#define OTGSTS_CDNS3_XHCI_READY		BIT(26)
+#define OTGSTS_CDNSP_XHCI_READY		BIT(27)
+
 /* "Device mode is turned on .*/
-#define OTGSTS_DEV_READY		BIT(27)
+#define OTGSTS_CDNS3_DEV_READY		BIT(27)
+#define OTGSTS_CDNSP_DEV_READY		BIT(26)
 
 /* OTGSTATE- bitmasks */
 #define OTGSTATE_DEV_STATE_MASK		GENMASK(2, 0)
@@ -152,6 +194,8 @@ struct cdns3_otg_common_regs {
 #define OVERRIDE_IDPULLUP		BIT(0)
 /* Only for CDNS3_CONTROLLER_V0 version */
 #define OVERRIDE_IDPULLUP_V0		BIT(24)
+/* Vbusvalid/Sesvalid override select. */
+#define OVERRIDE_SESS_VLD_SEL		BIT(10)
 
 /* PHYRST_CFG - bitmasks */
 #define PHYRST_CFG_PHYRST_A_ENABLE     BIT(0)
@@ -170,6 +214,5 @@ int cdns3_drd_gadget_on(struct cdns3 *cdns);
 void cdns3_drd_gadget_off(struct cdns3 *cdns);
 int cdns3_drd_host_on(struct cdns3 *cdns);
 void cdns3_drd_host_off(struct cdns3 *cdns);
-int cdns3_set_mode(struct cdns3 *cdns, enum usb_dr_mode mode);
 
 #endif /* __LINUX_CDNS3_DRD */
-- 
2.35.1



