Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC51143AA9
	for <lists+stable@lfdr.de>; Tue, 21 Jan 2020 11:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbgAUKRP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jan 2020 05:17:15 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:36532 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727220AbgAUKRP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jan 2020 05:17:15 -0500
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id E906AC053B;
        Tue, 21 Jan 2020 10:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1579601833; bh=ZSnJe/sDHjqHR04nYRc/QcWb8luiF4hHfxr5i1bGYvk=;
        h=Date:From:Subject:To:Cc:From;
        b=ZeEj25cC3IAvGeq0j+5OWOxjkcJlFxaBvsNtlDToZkd4BAmZ7MhIdKbNFv3VrEgIP
         CEA/QABLY1FyXpWuE24uHdcVP/i4JsjV7U0d9brBtCSpcWh6xOB0O5PMLf7aswwX+k
         4ncNgh/J2OmLyWXU7Mz74hHzKqgJE70ahBytiEqZt9ft3uoF0sVnXROhoap03XFkRJ
         58rDC/b/VfwKMuHeBKoad22qladgA0411yx74JQouEFwlXG0AdgG1LdhftjbEBqh9u
         izC57eeyDadH/1kFWukJ1ZTkGiuKX/t5lIbt7nvBRoSS7lIB45kXiXh1n/miBLLWVP
         Op/powbuaymPw==
Received: from hminas-z420 (hminas-z420.internal.synopsys.com [10.116.126.211])
        (using TLSv1 with cipher AES128-SHA (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id B61DEA005C;
        Tue, 21 Jan 2020 10:17:08 +0000 (UTC)
Received: by hminas-z420 (sSMTP sendmail emulation); Tue, 21 Jan 2020 14:17:07 +0400
Date:   Tue, 21 Jan 2020 14:17:07 +0400
Message-Id: <283e1161d597892c0b67aeeeb5b01e829dea9ae7.1579593275.git.hminas@synopsys.com>
From:   Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Subject: [PATCH v2] usb: dwc2: Fix SET/CLEAR_FEATURE and GET_STATUS flows
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>,
        Vardan Mikayelyan <Vardan.Mikayelyan@synopsys.com>,
        Grigor Tovmasyan <Grigor.Tovmasyan@synopsys.com>,
        stable@vger.kernel.org, Jack Mitchell <ml@embed.me.uk>
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

