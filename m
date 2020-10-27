Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8E4229C021
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:12:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1816986AbgJ0RLh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:11:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:33210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1786275AbgJ0O7u (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:59:50 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 157A522264;
        Tue, 27 Oct 2020 14:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810789;
        bh=wzPKckH4yCgJFXIaBy9KM+e75EOhjvAR1sKZUZks3Z0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WT4sBUCsmz4EUfaRFGNV6akh4mi0CjZ2C9J72c59tkgQGIa3/NBxRApEhE7M25vzl
         HWKytFsuGX79W+oUCzCxpo+bOWtW2KqOjz62ptyYkMi/OYhlCwWbiDD7KqbjpmPZCA
         MrUP/yvPSut7+f8EUt2/h6DPwys11hLwyy/pqv58=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Thinh Nguyen <thinhn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 264/633] usb: dwc3: core: Properly default unspecified speed
Date:   Tue, 27 Oct 2020 14:50:07 +0100
Message-Id: <20201027135535.049965114@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

[ Upstream commit b574ce3ee45937f4a01edc98c59213bfc7effe50 ]

If the maximum_speed is not specified, default the device speed base on
its HW capability. Don't prematurely check HW capability before
validating the maximum_speed device property. The device property takes
precedence in dwc->maximum_speed.

Fixes: 0e1e5c47f7a9 ("usb: dwc3: add support for USB 2.0-only core configuration")
Reported-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Signed-off-by: Thinh Nguyen <thinhn@synopsys.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/core.c | 35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 25c686a752b0f..7c5a18f9f66c8 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -930,13 +930,6 @@ static int dwc3_core_init(struct dwc3 *dwc)
 	 */
 	dwc3_writel(dwc->regs, DWC3_GUID, LINUX_VERSION_CODE);
 
-	/* Handle USB2.0-only core configuration */
-	if (DWC3_GHWPARAMS3_SSPHY_IFC(dwc->hwparams.hwparams3) ==
-			DWC3_GHWPARAMS3_SSPHY_IFC_DIS) {
-		if (dwc->maximum_speed == USB_SPEED_SUPER)
-			dwc->maximum_speed = USB_SPEED_HIGH;
-	}
-
 	ret = dwc3_phy_setup(dwc);
 	if (ret)
 		goto err0;
@@ -1382,6 +1375,8 @@ bool dwc3_has_imod(struct dwc3 *dwc)
 static void dwc3_check_params(struct dwc3 *dwc)
 {
 	struct device *dev = dwc->dev;
+	unsigned int hwparam_gen =
+		DWC3_GHWPARAMS3_SSPHY_IFC(dwc->hwparams.hwparams3);
 
 	/* Check for proper value of imod_interval */
 	if (dwc->imod_interval && !dwc3_has_imod(dwc)) {
@@ -1413,17 +1408,23 @@ static void dwc3_check_params(struct dwc3 *dwc)
 			dwc->maximum_speed);
 		/* fall through */
 	case USB_SPEED_UNKNOWN:
-		/* default to superspeed */
-		dwc->maximum_speed = USB_SPEED_SUPER;
-
-		/*
-		 * default to superspeed plus if we are capable.
-		 */
-		if ((DWC3_IP_IS(DWC31) || DWC3_IP_IS(DWC32)) &&
-		    (DWC3_GHWPARAMS3_SSPHY_IFC(dwc->hwparams.hwparams3) ==
-		     DWC3_GHWPARAMS3_SSPHY_IFC_GEN2))
+		switch (hwparam_gen) {
+		case DWC3_GHWPARAMS3_SSPHY_IFC_GEN2:
 			dwc->maximum_speed = USB_SPEED_SUPER_PLUS;
-
+			break;
+		case DWC3_GHWPARAMS3_SSPHY_IFC_GEN1:
+			if (DWC3_IP_IS(DWC32))
+				dwc->maximum_speed = USB_SPEED_SUPER_PLUS;
+			else
+				dwc->maximum_speed = USB_SPEED_SUPER;
+			break;
+		case DWC3_GHWPARAMS3_SSPHY_IFC_DIS:
+			dwc->maximum_speed = USB_SPEED_HIGH;
+			break;
+		default:
+			dwc->maximum_speed = USB_SPEED_SUPER;
+			break;
+		}
 		break;
 	}
 }
-- 
2.25.1



