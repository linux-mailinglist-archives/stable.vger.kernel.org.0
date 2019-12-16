Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF18121171
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 18:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbfLPROL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:14:11 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:58078 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725836AbfLPROL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 12:14:11 -0500
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id D5D6B4050A;
        Mon, 16 Dec 2019 17:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1576516450; bh=Ze4KUxhffmc/MRG7wxI0xDoZKYAmtigmJlJeWv/ELP4=;
        h=Date:From:Subject:To:Cc:From;
        b=Ql8kWOycCt0eh28MGwiQcCFKl36rkGboLlVC73xvisPo6SkaqSYftR2r3OAleW69S
         tXsEpNokf5+RznFDQ+1t0ltJuEqmW4VLwWGM7KGDGFA9fVAdnGYItrANEXrICl63PQ
         T15yk9+49bJBBOmNUDYtc7WHL8ngEdre+Pe0WKSETsUCteSHx4fISh/xC7JLcRvtYH
         iw2IUURCrXYr05ar75WvdhZzm9yG/Zw+VEMw2meT7ubWurhCO7QDYwR29CLnh6XYRa
         Dfv96BCrgx4wyWDv3ggq8QCw9RmS/gKCX5lfuek+k5qGqhmcnDTi7m3Gje6Jrx1+Ov
         /GPMW6JqwTMvA==
Received: from hminas-z420 (hminas-z420.internal.synopsys.com [10.116.126.211])
        (using TLSv1 with cipher AES128-SHA (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 083ADA0075;
        Mon, 16 Dec 2019 17:14:05 +0000 (UTC)
Received: by hminas-z420 (sSMTP sendmail emulation); Mon, 16 Dec 2019 21:14:04 +0400
Date:   Mon, 16 Dec 2019 21:14:04 +0400
Message-Id: <38a93a8deedd76dbc22bb1e41b4fc998f3750c95.1576516371.git.hminas@synopsys.com>
From:   Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Subject: [PATCH v2] usb: dwc2: Fix SET/CLEAR_FEATURE and GET_STATUS flows
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>, stable@vger.kernel.org,
        Jack Mitchell <ml@embed.me.uk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SET/CLEAR_FEATURE for Remote Wakeup allowance not handled correctly.
GET_STATUS handling provided not correct data on DATA Stage.
Issue seen when gadget's dr_mode set to "otg" mode and connected
to MacOS.
Both are fixed and tested using USBCV Ch.9 tests.

Signed-off-by: Minas Harutyunyan <hminas@synopsys.com>
Fixes: fa389a6d7726 ("usb: dwc2: gadget: Add remote_wakeup_allowed flag")
Tested-by: Jack Mitchell <ml@embed.me.uk>
Cc: stable@vger.kernel.org
---
Changes in v2:
- Add Fixes tag
- Add Tested-by tag

Signed-off-by: Minas Harutyunyan <hminas@synopsys.com>
---
 drivers/usb/dwc2/gadget.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index 6be10e496e10..3a6176c22371 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -1632,6 +1632,7 @@ static int dwc2_hsotg_process_req_status(struct dwc2_hsotg *hsotg,
 	struct dwc2_hsotg_ep *ep0 = hsotg->eps_out[0];
 	struct dwc2_hsotg_ep *ep;
 	__le16 reply;
+	u16 status;
 	int ret;
 
 	dev_dbg(hsotg->dev, "%s: USB_REQ_GET_STATUS\n", __func__);
@@ -1643,11 +1644,10 @@ static int dwc2_hsotg_process_req_status(struct dwc2_hsotg *hsotg,
 
 	switch (ctrl->bRequestType & USB_RECIP_MASK) {
 	case USB_RECIP_DEVICE:
-		/*
-		 * bit 0 => self powered
-		 * bit 1 => remote wakeup
-		 */
-		reply = cpu_to_le16(0);
+		status = 1 << USB_DEVICE_SELF_POWERED;
+		status |= hsotg->remote_wakeup_allowed <<
+			  USB_DEVICE_REMOTE_WAKEUP;
+		reply = cpu_to_le16(status);
 		break;
 
 	case USB_RECIP_INTERFACE:
@@ -1758,7 +1758,10 @@ static int dwc2_hsotg_process_req_feature(struct dwc2_hsotg *hsotg,
 	case USB_RECIP_DEVICE:
 		switch (wValue) {
 		case USB_DEVICE_REMOTE_WAKEUP:
-			hsotg->remote_wakeup_allowed = 1;
+			if (set)
+				hsotg->remote_wakeup_allowed = 1;
+			else
+				hsotg->remote_wakeup_allowed = 0;
 			break;
 
 		case USB_DEVICE_TEST_MODE:
@@ -1768,16 +1771,17 @@ static int dwc2_hsotg_process_req_feature(struct dwc2_hsotg *hsotg,
 				return -EINVAL;
 
 			hsotg->test_mode = wIndex >> 8;
-			ret = dwc2_hsotg_send_reply(hsotg, ep0, NULL, 0);
-			if (ret) {
-				dev_err(hsotg->dev,
-					"%s: failed to send reply\n", __func__);
-				return ret;
-			}
 			break;
 		default:
 			return -ENOENT;
 		}
+
+		ret = dwc2_hsotg_send_reply(hsotg, ep0, NULL, 0);
+		if (ret) {
+			dev_err(hsotg->dev,
+				"%s: failed to send reply\n", __func__);
+			return ret;
+		}
 		break;
 
 	case USB_RECIP_ENDPOINT:
-- 
2.11.0

