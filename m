Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AFB83C4A8B
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239380AbhGLGwu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:52:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:50446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240167AbhGLGuv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:50:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FEE260233;
        Mon, 12 Jul 2021 06:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072482;
        bh=BxHwDuV56DoQxQglk3mxcCOPIw5dgd0dvHM0XdlZGM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kkSzjIt+4H4paD2IIOrKq8LtoevXV5DsHw42wcS6lI4sf3mbqWjaHZji1Y7f+weBG
         7rtZSyLOUj4PZgwxBd7odUHE5rLM9Bh7IfN4Q4DoFdtipBbn5cuTTiCL+0QH1g2XwS
         Ec2sC67pA0cjuC0DFL9IkDkhJxK3mJQVp7DgtB50=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Cl=C3=A9ment=20Lassieur?= <clement@lassieur.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 511/593] usb: dwc2: Dont reset the core after setting turnaround time
Date:   Mon, 12 Jul 2021 08:11:11 +0200
Message-Id: <20210712060948.165778883@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Clément Lassieur <clement@lassieur.org>

[ Upstream commit aafe93516b8567ab5864e1f4cd3eeabc54fb0e5a ]

Every time the hub signals a reset while we (device) are hsotg->connected,
dwc2_hsotg_core_init_disconnected() is called, which in turn calls
dwc2_hs_phy_init().

GUSBCFG.USBTrdTim is cleared upon Core Soft Reset, so if
hsotg->params.phy_utmi_width is 8-bit, the value of GUSBCFG.USBTrdTim (the
default one: 0x5, corresponding to 16-bit) is always different from
hsotg->params.phy_utmi_width, thus dwc2_core_reset() is called every
time (usbcfg != usbcfg_old), which causes 2 issues:

1) The call to dwc2_core_reset() does another reset 300us after the initial
Chirp K of the first reset (which should last at least Tuch = 1ms), and
messes up the High-speed Detection Handshake: both hub and device drive
current into the D+ and D- lines at the same time.

2) GUSBCFG.USBTrdTim is cleared by the second reset, so its value is always
the default one (0x5).

Setting GUSBCFG.USBTrdTim after the potential call to dwc2_core_reset()
fixes both issues.  It is now set even when select_phy is false because the
cost of the Core Soft Reset is removed.

Fixes: 1e868545f2bb ("usb: dwc2: gadget: Move gadget phy init into core phy init")
Signed-off-by: Clément Lassieur <clement@lassieur.org>
Link: https://lore.kernel.org/r/20210603155921.940651-1-clement@lassieur.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc2/core.c | 30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/dwc2/core.c b/drivers/usb/dwc2/core.c
index fec17a2d2447..15911ac7582b 100644
--- a/drivers/usb/dwc2/core.c
+++ b/drivers/usb/dwc2/core.c
@@ -1167,15 +1167,6 @@ static int dwc2_hs_phy_init(struct dwc2_hsotg *hsotg, bool select_phy)
 		usbcfg &= ~(GUSBCFG_ULPI_UTMI_SEL | GUSBCFG_PHYIF16);
 		if (hsotg->params.phy_utmi_width == 16)
 			usbcfg |= GUSBCFG_PHYIF16;
-
-		/* Set turnaround time */
-		if (dwc2_is_device_mode(hsotg)) {
-			usbcfg &= ~GUSBCFG_USBTRDTIM_MASK;
-			if (hsotg->params.phy_utmi_width == 16)
-				usbcfg |= 5 << GUSBCFG_USBTRDTIM_SHIFT;
-			else
-				usbcfg |= 9 << GUSBCFG_USBTRDTIM_SHIFT;
-		}
 		break;
 	default:
 		dev_err(hsotg->dev, "FS PHY selected at HS!\n");
@@ -1197,6 +1188,24 @@ static int dwc2_hs_phy_init(struct dwc2_hsotg *hsotg, bool select_phy)
 	return retval;
 }
 
+static void dwc2_set_turnaround_time(struct dwc2_hsotg *hsotg)
+{
+	u32 usbcfg;
+
+	if (hsotg->params.phy_type != DWC2_PHY_TYPE_PARAM_UTMI)
+		return;
+
+	usbcfg = dwc2_readl(hsotg, GUSBCFG);
+
+	usbcfg &= ~GUSBCFG_USBTRDTIM_MASK;
+	if (hsotg->params.phy_utmi_width == 16)
+		usbcfg |= 5 << GUSBCFG_USBTRDTIM_SHIFT;
+	else
+		usbcfg |= 9 << GUSBCFG_USBTRDTIM_SHIFT;
+
+	dwc2_writel(hsotg, usbcfg, GUSBCFG);
+}
+
 int dwc2_phy_init(struct dwc2_hsotg *hsotg, bool select_phy)
 {
 	u32 usbcfg;
@@ -1214,6 +1223,9 @@ int dwc2_phy_init(struct dwc2_hsotg *hsotg, bool select_phy)
 		retval = dwc2_hs_phy_init(hsotg, select_phy);
 		if (retval)
 			return retval;
+
+		if (dwc2_is_device_mode(hsotg))
+			dwc2_set_turnaround_time(hsotg);
 	}
 
 	if (hsotg->hw_params.hs_phy_type == GHWCFG2_HS_PHY_TYPE_ULPI &&
-- 
2.30.2



