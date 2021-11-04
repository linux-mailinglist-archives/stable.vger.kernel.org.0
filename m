Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E584444FBB
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 08:36:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbhKDHip (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 03:38:45 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:52352 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230084AbhKDHio (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Nov 2021 03:38:44 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id BE99B4120B;
        Thu,  4 Nov 2021 07:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1636011367; bh=/CA63UR5arwsAXDCVLYSttSBde59BmSIjoOTvS8/nZw=;
        h=Date:From:Subject:To:Cc:From;
        b=aALTCRbs5pESNUZpn+aWwkGiGPfLuq2G5sfw1qJDLFPUE+W1KMcZ9cnqMB1qbPtb2
         rcIBHunlDd2+GQL/kNNEw2hDnYJsY4+7Rtrg03V8XUSeljfS85XQFxN5qcXetB48aR
         jW9+smbni1kEQ9xycj95FzyrfvYS4zxJiRMwvV7YRuzEHx+kcrPxvXudrXKGHY2XNj
         J5HYg/SN3u6SsnjP8nuZqkHimrX5t8hy3ab7mPByB9RVVctdAneqNO5HY7elXg4Qoq
         IUMKDGbitArYmVhKXY2yyAsxkAj2IXgQKpt8N8rwAsdVJf7E+ZMjYK8LolTNew/TD8
         p7EYoH5gDS/bQ==
Received: from hminas-z420 (hminas-z420.internal.synopsys.com [10.116.75.77])
        (using TLSv1 with cipher AES128-SHA (128/128 bits))
        (Client did not present a certificate)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 4BF75A005D;
        Thu,  4 Nov 2021 07:36:03 +0000 (UTC)
Received: by hminas-z420 (sSMTP sendmail emulation); Thu, 04 Nov 2021 11:36:01 +0400
Date:   Thu, 04 Nov 2021 11:36:01 +0400
Message-Id: <c356baade6e9716d312d43df08d53ae557cb8037.1636011277.git.Minas.Harutyunyan@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Subject: [PATCH] usb: dwc2: gadget: Fix ISOC flow for elapsed frames
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        stable <stable@vger.kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Added updating of request frame number for elapsed frames,
otherwise frame number will remain as previous use of request.
This will allow function driver to correctly track frames in
case of Missed ISOC occurs.

Added setting request actual length to 0 for elapsed frames.
In Slave mode when pushing data to RxFIFO by dwords, request
actual length incrementing accordingly. But before whole packet
will be pushed into RxFIFO and send to host can occurs Missed
ISOC and data will not send to host. So, in this case request
actual length should be reset to 0.

Fixes: 91bb163e1e4f ("usb: dwc2: gadget: Fix ISOC flow for BDMA and Slave")
Signed-off-by: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
---
 drivers/usb/dwc2/gadget.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index 11d85a6e0b0d..2190225bf3da 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -1198,6 +1198,8 @@ static void dwc2_hsotg_start_req(struct dwc2_hsotg *hsotg,
 			}
 			ctrl |= DXEPCTL_CNAK;
 		} else {
+			hs_req->req.frame_number = hs_ep->target_frame;
+			hs_req->req.actual = 0;
 			dwc2_hsotg_complete_request(hsotg, hs_ep, hs_req, -ENODATA);
 			return;
 		}
@@ -2857,9 +2859,12 @@ static void dwc2_gadget_handle_ep_disabled(struct dwc2_hsotg_ep *hs_ep)
 
 	do {
 		hs_req = get_ep_head(hs_ep);
-		if (hs_req)
+		if (hs_req) {
+			hs_req->req.frame_number = hs_ep->target_frame;
+			hs_req->req.actual = 0;
 			dwc2_hsotg_complete_request(hsotg, hs_ep, hs_req,
 						    -ENODATA);
+		}
 		dwc2_gadget_incr_frame_num(hs_ep);
 		/* Update current frame number value. */
 		hsotg->frame_number = dwc2_hsotg_read_frameno(hsotg);
@@ -2912,8 +2917,11 @@ static void dwc2_gadget_handle_out_token_ep_disabled(struct dwc2_hsotg_ep *ep)
 
 	while (dwc2_gadget_target_frame_elapsed(ep)) {
 		hs_req = get_ep_head(ep);
-		if (hs_req)
+		if (hs_req) {
+			hs_req->req.frame_number = ep->target_frame;
+			hs_req->req.actual = 0;
 			dwc2_hsotg_complete_request(hsotg, ep, hs_req, -ENODATA);
+		}
 
 		dwc2_gadget_incr_frame_num(ep);
 		/* Update current frame number value. */
@@ -3002,8 +3010,11 @@ static void dwc2_gadget_handle_nak(struct dwc2_hsotg_ep *hs_ep)
 
 	while (dwc2_gadget_target_frame_elapsed(hs_ep)) {
 		hs_req = get_ep_head(hs_ep);
-		if (hs_req)
+		if (hs_req) {
+			hs_req->req.frame_number = hs_ep->target_frame;
+			hs_req->req.actual = 0;
 			dwc2_hsotg_complete_request(hsotg, hs_ep, hs_req, -ENODATA);
+		}
 
 		dwc2_gadget_incr_frame_num(hs_ep);
 		/* Update current frame number value. */

base-commit: c26f1c109d21f2ea874e4a85c0c76c385b8f46cb
-- 
2.11.0

