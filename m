Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFDB3291E26
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387978AbgJRTu7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:50:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:33408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729366AbgJRTVW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:21:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4035A222E8;
        Sun, 18 Oct 2020 19:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048882;
        bh=ZV2iyvGcsmZaemKsOR5bzkZEuBopS+POiITUzkVF1e0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iCXpWid1SwvCsiqK+P4+jHPF13lHbukQeg8+icLxlGxaSTxqpyeeCwvP4iVQNsed6
         pb1v5o88VlV44TAvESkp68d4Ti40BfCf60I3s6meblMdXHcjxb4oDh9FQ/qRWj40nb
         loFxX+i62zlt0LklUj0OWgUfbgmo9q9Ak8vqWYXw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yu Chen <chenyu56@huawei.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 045/101] usb: dwc3: Add splitdisable quirk for Hisilicon Kirin Soc
Date:   Sun, 18 Oct 2020 15:19:30 -0400
Message-Id: <20201018192026.4053674-45-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192026.4053674-1-sashal@kernel.org>
References: <20201018192026.4053674-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Chen <chenyu56@huawei.com>

[ Upstream commit f580170f135af14e287560d94045624d4242d712 ]

SPLIT_BOUNDARY_DISABLE should be set for DesignWare USB3 DRD Core
of Hisilicon Kirin Soc when dwc3 core act as host.

[mchehab: dropped a dev_dbg() as only traces are now allowwed on this driver]

Signed-off-by: Yu Chen <chenyu56@huawei.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/core.c | 25 +++++++++++++++++++++++++
 drivers/usb/dwc3/core.h |  7 +++++++
 2 files changed, 32 insertions(+)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 25c686a752b0f..e476e83308bc1 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -119,6 +119,7 @@ static void __dwc3_set_mode(struct work_struct *work)
 	struct dwc3 *dwc = work_to_dwc(work);
 	unsigned long flags;
 	int ret;
+	u32 reg;
 
 	if (dwc->dr_mode != USB_DR_MODE_OTG)
 		return;
@@ -172,6 +173,11 @@ static void __dwc3_set_mode(struct work_struct *work)
 				otg_set_vbus(dwc->usb2_phy->otg, true);
 			phy_set_mode(dwc->usb2_generic_phy, PHY_MODE_USB_HOST);
 			phy_set_mode(dwc->usb3_generic_phy, PHY_MODE_USB_HOST);
+			if (dwc->dis_split_quirk) {
+				reg = dwc3_readl(dwc->regs, DWC3_GUCTL3);
+				reg |= DWC3_GUCTL3_SPLITDISABLE;
+				dwc3_writel(dwc->regs, DWC3_GUCTL3, reg);
+			}
 		}
 		break;
 	case DWC3_GCTL_PRTCAP_DEVICE:
@@ -1357,6 +1363,9 @@ static void dwc3_get_properties(struct dwc3 *dwc)
 	dwc->dis_metastability_quirk = device_property_read_bool(dev,
 				"snps,dis_metastability_quirk");
 
+	dwc->dis_split_quirk = device_property_read_bool(dev,
+				"snps,dis-split-quirk");
+
 	dwc->lpm_nyet_threshold = lpm_nyet_threshold;
 	dwc->tx_de_emphasis = tx_de_emphasis;
 
@@ -1866,10 +1875,26 @@ static int dwc3_resume(struct device *dev)
 
 	return 0;
 }
+
+static void dwc3_complete(struct device *dev)
+{
+	struct dwc3	*dwc = dev_get_drvdata(dev);
+	u32		reg;
+
+	if (dwc->current_dr_role == DWC3_GCTL_PRTCAP_HOST &&
+			dwc->dis_split_quirk) {
+		reg = dwc3_readl(dwc->regs, DWC3_GUCTL3);
+		reg |= DWC3_GUCTL3_SPLITDISABLE;
+		dwc3_writel(dwc->regs, DWC3_GUCTL3, reg);
+	}
+}
+#else
+#define dwc3_complete NULL
 #endif /* CONFIG_PM_SLEEP */
 
 static const struct dev_pm_ops dwc3_dev_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(dwc3_suspend, dwc3_resume)
+	.complete = dwc3_complete,
 	SET_RUNTIME_PM_OPS(dwc3_runtime_suspend, dwc3_runtime_resume,
 			dwc3_runtime_idle)
 };
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 013f42a2b5dcc..af5533b097133 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -138,6 +138,7 @@
 #define DWC3_GEVNTCOUNT(n)	(0xc40c + ((n) * 0x10))
 
 #define DWC3_GHWPARAMS8		0xc600
+#define DWC3_GUCTL3		0xc60c
 #define DWC3_GFLADJ		0xc630
 
 /* Device Registers */
@@ -380,6 +381,9 @@
 /* Global User Control Register 2 */
 #define DWC3_GUCTL2_RST_ACTBITLATER		BIT(14)
 
+/* Global User Control Register 3 */
+#define DWC3_GUCTL3_SPLITDISABLE		BIT(14)
+
 /* Device Configuration Register */
 #define DWC3_DCFG_DEVADDR(addr)	((addr) << 3)
 #define DWC3_DCFG_DEVADDR_MASK	DWC3_DCFG_DEVADDR(0x7f)
@@ -1052,6 +1056,7 @@ struct dwc3_scratchpad_array {
  * 	2	- No de-emphasis
  * 	3	- Reserved
  * @dis_metastability_quirk: set to disable metastability quirk.
+ * @dis_split_quirk: set to disable split boundary.
  * @imod_interval: set the interrupt moderation interval in 250ns
  *                 increments or 0 to disable.
  */
@@ -1245,6 +1250,8 @@ struct dwc3 {
 
 	unsigned		dis_metastability_quirk:1;
 
+	unsigned		dis_split_quirk:1;
+
 	u16			imod_interval;
 };
 
-- 
2.25.1

