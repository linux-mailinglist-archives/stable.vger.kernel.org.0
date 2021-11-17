Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 998AB454816
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 15:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234903AbhKQOGP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 09:06:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:60470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238051AbhKQOGO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Nov 2021 09:06:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C320F6139F;
        Wed, 17 Nov 2021 14:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637157796;
        bh=FCd9f4CY1SAiI3kRPvGzA/8X/FdPlv9T0nImsLKGnVo=;
        h=Subject:To:From:Date:From;
        b=KZU+rc4a05axTUt7HJhYOibvvBcQxEyuMG/qVvT6wQUz/qtZEseQpILZGLfIXaVWu
         u8J3lR0jFDfDho9SWvudiKfF86hXwVi2zWYPNfBdK19kB4lj5mp060NgW2NHRjBq98
         vW2ccIbCrGojAWLhauAqjCI3Tr7ZDiivMs7ku8pk=
Subject: patch "usb: dwc2: gadget: Fix ISOC flow for elapsed frames" added to usb-linus
To:     Minas.Harutyunyan@synopsys.com, gregkh@linuxfoundation.org,
        john@metanate.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 17 Nov 2021 15:03:07 +0100
Message-ID: <16371577876153@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc2: gadget: Fix ISOC flow for elapsed frames

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 7ad4a0b1d46b2612f4429a72afd8f137d7efa9a9 Mon Sep 17 00:00:00 2001
From: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Date: Thu, 4 Nov 2021 11:36:01 +0400
Subject: usb: dwc2: gadget: Fix ISOC flow for elapsed frames

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
Cc: stable <stable@vger.kernel.org>
Reviewed-by: John Keeping <john@metanate.com>
Signed-off-by: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Link: https://lore.kernel.org/r/c356baade6e9716d312d43df08d53ae557cb8037.1636011277.git.Minas.Harutyunyan@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc2/gadget.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index 4ab4a1d5062b..ab8d7dad9f56 100644
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
-- 
2.34.0


