Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E656370BF6
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232562AbhEBOE5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:04:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:49376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232167AbhEBOEa (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:04:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84AEE613CB;
        Sun,  2 May 2021 14:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964218;
        bh=ghJ82DARUY6O9i1fuSNoLym3W4oLNzpszz+gqBXV0YA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mF82UU18/rYTTHegBJJhTtOStGePN2+Y7YEefzOtslhqTeHCXxS6IKhaHIW4Lg1n8
         pwxgkEJ9cx9eDcGL4yKvnDeUy9+3OrGvyJxV296V2IQf68K71jgQlaaoCr9+9wy127
         irUiZN2TYL+zraHJiRgJTQaI1AKnjCIrF9j9lf4dxATuPGWTjiPgdicZovXDIQ7Fw2
         BlN1DZq20+Vey9pTjJH1RB0EfwlSsM0+8clgTpq4GnOiCGdTQAePJ4It0wwhzQAwv+
         EYuxyRiLA5ioFXl/xPDtOFi1s1t+IVjrJiCx0GeifjSthWdBUoYbCMg4DpuZikfo4E
         zhrf3V21NyJOw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 16/79] usb: dwc3: gadget: Remove invalid low-speed setting
Date:   Sun,  2 May 2021 10:02:13 -0400
Message-Id: <20210502140316.2718705-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140316.2718705-1-sashal@kernel.org>
References: <20210502140316.2718705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

[ Upstream commit 0c59f678fcfc6dd53ba493915794636a230bc4cc ]

None of the DWC_usb3x IPs (and all their versions) supports low-speed
setting in device mode. In the early days, our "Early Adopter Edition"
DWC_usb3 databook shows that the controller may be configured to operate
in low-speed, but it was revised on release. Let's remove this invalid
speed setting to avoid any confusion.

Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/258b1c7fbb966454f4c4c2c1367508998498fc30.1615509438.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/core.c   | 1 -
 drivers/usb/dwc3/core.h   | 2 --
 drivers/usb/dwc3/gadget.c | 8 --------
 3 files changed, 11 deletions(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index f2448d0a9d39..677a9778c49a 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -1385,7 +1385,6 @@ static void dwc3_check_params(struct dwc3 *dwc)
 
 	/* Check the maximum_speed parameter */
 	switch (dwc->maximum_speed) {
-	case USB_SPEED_LOW:
 	case USB_SPEED_FULL:
 	case USB_SPEED_HIGH:
 		break;
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 052b20d52651..19ffab828d9c 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -396,7 +396,6 @@
 #define DWC3_DCFG_SUPERSPEED	(4 << 0)
 #define DWC3_DCFG_HIGHSPEED	(0 << 0)
 #define DWC3_DCFG_FULLSPEED	BIT(0)
-#define DWC3_DCFG_LOWSPEED	(2 << 0)
 
 #define DWC3_DCFG_NUMP_SHIFT	17
 #define DWC3_DCFG_NUMP(n)	(((n) >> DWC3_DCFG_NUMP_SHIFT) & 0x1f)
@@ -490,7 +489,6 @@
 #define DWC3_DSTS_SUPERSPEED		(4 << 0)
 #define DWC3_DSTS_HIGHSPEED		(0 << 0)
 #define DWC3_DSTS_FULLSPEED		BIT(0)
-#define DWC3_DSTS_LOWSPEED		(2 << 0)
 
 /* Device Generic Command Register */
 #define DWC3_DGCMD_SET_LMP		0x01
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index c7ef218e7a8c..04950ac0704b 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2113,9 +2113,6 @@ static void __dwc3_gadget_set_speed(struct dwc3 *dwc)
 		reg |= DWC3_DCFG_SUPERSPEED;
 	} else {
 		switch (speed) {
-		case USB_SPEED_LOW:
-			reg |= DWC3_DCFG_LOWSPEED;
-			break;
 		case USB_SPEED_FULL:
 			reg |= DWC3_DCFG_FULLSPEED;
 			break;
@@ -3448,11 +3445,6 @@ static void dwc3_gadget_conndone_interrupt(struct dwc3 *dwc)
 		dwc->gadget->ep0->maxpacket = 64;
 		dwc->gadget->speed = USB_SPEED_FULL;
 		break;
-	case DWC3_DSTS_LOWSPEED:
-		dwc3_gadget_ep0_desc.wMaxPacketSize = cpu_to_le16(8);
-		dwc->gadget->ep0->maxpacket = 8;
-		dwc->gadget->speed = USB_SPEED_LOW;
-		break;
 	}
 
 	dwc->eps[1]->endpoint.maxpacket = dwc->gadget->ep0->maxpacket;
-- 
2.30.2

