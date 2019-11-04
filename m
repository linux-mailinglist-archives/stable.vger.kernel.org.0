Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1C9EEF85
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:22:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387782AbfKDV5T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:57:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:53272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388530AbfKDV5O (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:57:14 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4672A2184C;
        Mon,  4 Nov 2019 21:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904632;
        bh=0K1mygL3oJRRaNMfeI7bjrL+a8KoQGX3ZDU9u0jJ3dg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y/CK2bNCA5ibsNwtJHhqPzW7PnwK6VP2iM5FrgVsU4M2AdFFIXUZlOc/5s/erJrlo
         J0xPc2JurvRE56rgOFT+JKC6EBG0G7SMEE4Mzwmq/dej7kJpT+u5dR/nfyHzUbhK7p
         6KhLi/mBJsFC+L6HIWPIu27g8PlMcWkbes+wm/go=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Artur Petrosyan <arturp@synopsys.com>,
        Minas Harutyunyan <hminas@synopsys.com>,
        Fabrice Gasnier <fabrice.gasnier@st.com>,
        Amelie Delaunay <amelie.delaunay@st.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 016/149] usb: dwc2: fix unbalanced use of external vbus-supply
Date:   Mon,  4 Nov 2019 22:43:29 +0100
Message-Id: <20191104212135.455154039@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabrice Gasnier <fabrice.gasnier@st.com>

[ Upstream commit cd7cd0e6cedfda8da6668a4af6748f96bbb6fed4 ]

When using external vbus supply regulator, it should be enabled
synchronously with PWR bit in HPRT register. This also fixes
unbalanced use of this optional regulator (This can be reproduced
easily when unbinding the driver).

Fixes: 531ef5ebea96 ("usb: dwc2: add support for host mode external
vbus supply")

Tested-by: Artur Petrosyan <arturp@synopsys.com>
Acked-by: Minas Harutyunyan <hminas@synopsys.com>
Signed-off-by: Fabrice Gasnier <fabrice.gasnier@st.com>
Signed-off-by: Amelie Delaunay <amelie.delaunay@st.com>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc2/hcd.c | 33 ++++++++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/dwc2/hcd.c b/drivers/usb/dwc2/hcd.c
index aad7edc29bddd..a5c8329fd4625 100644
--- a/drivers/usb/dwc2/hcd.c
+++ b/drivers/usb/dwc2/hcd.c
@@ -3568,6 +3568,7 @@ static int dwc2_hcd_hub_control(struct dwc2_hsotg *hsotg, u16 typereq,
 	u32 port_status;
 	u32 speed;
 	u32 pcgctl;
+	u32 pwr;
 
 	switch (typereq) {
 	case ClearHubFeature:
@@ -3616,8 +3617,11 @@ static int dwc2_hcd_hub_control(struct dwc2_hsotg *hsotg, u16 typereq,
 			dev_dbg(hsotg->dev,
 				"ClearPortFeature USB_PORT_FEAT_POWER\n");
 			hprt0 = dwc2_read_hprt0(hsotg);
+			pwr = hprt0 & HPRT0_PWR;
 			hprt0 &= ~HPRT0_PWR;
 			dwc2_writel(hsotg, hprt0, HPRT0);
+			if (pwr)
+				dwc2_vbus_supply_exit(hsotg);
 			break;
 
 		case USB_PORT_FEAT_INDICATOR:
@@ -3827,8 +3831,11 @@ static int dwc2_hcd_hub_control(struct dwc2_hsotg *hsotg, u16 typereq,
 			dev_dbg(hsotg->dev,
 				"SetPortFeature - USB_PORT_FEAT_POWER\n");
 			hprt0 = dwc2_read_hprt0(hsotg);
+			pwr = hprt0 & HPRT0_PWR;
 			hprt0 |= HPRT0_PWR;
 			dwc2_writel(hsotg, hprt0, HPRT0);
+			if (!pwr)
+				dwc2_vbus_supply_init(hsotg);
 			break;
 
 		case USB_PORT_FEAT_RESET:
@@ -3845,6 +3852,7 @@ static int dwc2_hcd_hub_control(struct dwc2_hsotg *hsotg, u16 typereq,
 			dwc2_writel(hsotg, 0, PCGCTL);
 
 			hprt0 = dwc2_read_hprt0(hsotg);
+			pwr = hprt0 & HPRT0_PWR;
 			/* Clear suspend bit if resetting from suspend state */
 			hprt0 &= ~HPRT0_SUSP;
 
@@ -3858,6 +3866,8 @@ static int dwc2_hcd_hub_control(struct dwc2_hsotg *hsotg, u16 typereq,
 				dev_dbg(hsotg->dev,
 					"In host mode, hprt0=%08x\n", hprt0);
 				dwc2_writel(hsotg, hprt0, HPRT0);
+				if (!pwr)
+					dwc2_vbus_supply_init(hsotg);
 			}
 
 			/* Clear reset bit in 10ms (FS/LS) or 50ms (HS) */
@@ -4400,6 +4410,7 @@ static int _dwc2_hcd_start(struct usb_hcd *hcd)
 	struct dwc2_hsotg *hsotg = dwc2_hcd_to_hsotg(hcd);
 	struct usb_bus *bus = hcd_to_bus(hcd);
 	unsigned long flags;
+	u32 hprt0;
 	int ret;
 
 	dev_dbg(hsotg->dev, "DWC OTG HCD START\n");
@@ -4416,12 +4427,16 @@ static int _dwc2_hcd_start(struct usb_hcd *hcd)
 
 	dwc2_hcd_reinit(hsotg);
 
-	/* enable external vbus supply before resuming root hub */
-	spin_unlock_irqrestore(&hsotg->lock, flags);
-	ret = dwc2_vbus_supply_init(hsotg);
-	if (ret)
-		return ret;
-	spin_lock_irqsave(&hsotg->lock, flags);
+	hprt0 = dwc2_read_hprt0(hsotg);
+	/* Has vbus power been turned on in dwc2_core_host_init ? */
+	if (hprt0 & HPRT0_PWR) {
+		/* Enable external vbus supply before resuming root hub */
+		spin_unlock_irqrestore(&hsotg->lock, flags);
+		ret = dwc2_vbus_supply_init(hsotg);
+		if (ret)
+			return ret;
+		spin_lock_irqsave(&hsotg->lock, flags);
+	}
 
 	/* Initialize and connect root hub if one is not already attached */
 	if (bus->root_hub) {
@@ -4443,6 +4458,7 @@ static void _dwc2_hcd_stop(struct usb_hcd *hcd)
 {
 	struct dwc2_hsotg *hsotg = dwc2_hcd_to_hsotg(hcd);
 	unsigned long flags;
+	u32 hprt0;
 
 	/* Turn off all host-specific interrupts */
 	dwc2_disable_host_interrupts(hsotg);
@@ -4451,6 +4467,7 @@ static void _dwc2_hcd_stop(struct usb_hcd *hcd)
 	synchronize_irq(hcd->irq);
 
 	spin_lock_irqsave(&hsotg->lock, flags);
+	hprt0 = dwc2_read_hprt0(hsotg);
 	/* Ensure hcd is disconnected */
 	dwc2_hcd_disconnect(hsotg, true);
 	dwc2_hcd_stop(hsotg);
@@ -4459,7 +4476,9 @@ static void _dwc2_hcd_stop(struct usb_hcd *hcd)
 	clear_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags);
 	spin_unlock_irqrestore(&hsotg->lock, flags);
 
-	dwc2_vbus_supply_exit(hsotg);
+	/* keep balanced supply init/exit by checking HPRT0_PWR */
+	if (hprt0 & HPRT0_PWR)
+		dwc2_vbus_supply_exit(hsotg);
 
 	usleep_range(1000, 3000);
 }
-- 
2.20.1



