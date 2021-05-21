Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD5238C675
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 14:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232292AbhEUM1u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 08:27:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:55138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229457AbhEUM1t (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 May 2021 08:27:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C6906108B;
        Fri, 21 May 2021 12:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621599986;
        bh=883ngX+0QqCsT+RVRNEdZ+EKJGalroB0CuyhKUrFV7A=;
        h=Subject:To:From:Date:From;
        b=TKpdf6q6LIqDEQ4SpU5QrPtSlRx5/mUD2tVu2bgnXWu/IiUf8p2jOljkPXDBMsIjz
         JYa8uuoc8V8KLKLN9m3kogHMxbkeqa8/OxDNsVOY+Gmv66OB6K2D3Vd+c8NaSqq2n+
         OeSUfkFaMXHUWspdwLlvZkEW46SngXnx8ZDIebig=
Subject: patch "usb: dwc3: gadget: Properly track pending and queued SG" added to usb-linus
To:     Thinh.Nguyen@synopsys.com, balbi@kernel.org,
        gregkh@linuxfoundation.org, m.grzeschik@pengutronix.de,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 21 May 2021 14:26:16 +0200
Message-ID: <162159997637163@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc3: gadget: Properly track pending and queued SG

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 25dda9fc56bd90d45f9a4516bcfa5211e61b4290 Mon Sep 17 00:00:00 2001
From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Date: Wed, 12 May 2021 20:17:09 -0700
Subject: usb: dwc3: gadget: Properly track pending and queued SG

The driver incorrectly uses req->num_pending_sgs to track both the
number of pending and queued SG entries. It only prepares the next
request if the previous is done, and it doesn't update num_pending_sgs
until there is TRB completion interrupt. This may starve the controller
of more TRBs until the num_pending_sgs is decremented.

Fix this by decrementing the num_pending_sgs after they are queued and
properly track both num_mapped_sgs and num_queued_sgs.

Fixes: c96e6725db9d ("usb: dwc3: gadget: Correct the logic for queuing sgs")
Cc: <stable@vger.kernel.org>
Reported-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Tested-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/ba24591dbcaad8f244a3e88bd449bb7205a5aec3.1620874069.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 49ca5da5e279..612825a39f82 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1244,6 +1244,7 @@ static int dwc3_prepare_trbs_sg(struct dwc3_ep *dep,
 			req->start_sg = sg_next(s);
 
 		req->num_queued_sgs++;
+		req->num_pending_sgs--;
 
 		/*
 		 * The number of pending SG entries may not correspond to the
@@ -1251,7 +1252,7 @@ static int dwc3_prepare_trbs_sg(struct dwc3_ep *dep,
 		 * don't include unused SG entries.
 		 */
 		if (length == 0) {
-			req->num_pending_sgs -= req->request.num_mapped_sgs - req->num_queued_sgs;
+			req->num_pending_sgs = 0;
 			break;
 		}
 
@@ -2873,15 +2874,15 @@ static int dwc3_gadget_ep_reclaim_trb_sg(struct dwc3_ep *dep,
 	struct dwc3_trb *trb = &dep->trb_pool[dep->trb_dequeue];
 	struct scatterlist *sg = req->sg;
 	struct scatterlist *s;
-	unsigned int pending = req->num_pending_sgs;
+	unsigned int num_queued = req->num_queued_sgs;
 	unsigned int i;
 	int ret = 0;
 
-	for_each_sg(sg, s, pending, i) {
+	for_each_sg(sg, s, num_queued, i) {
 		trb = &dep->trb_pool[dep->trb_dequeue];
 
 		req->sg = sg_next(s);
-		req->num_pending_sgs--;
+		req->num_queued_sgs--;
 
 		ret = dwc3_gadget_ep_reclaim_completed_trb(dep, req,
 				trb, event, status, true);
@@ -2904,7 +2905,7 @@ static int dwc3_gadget_ep_reclaim_trb_linear(struct dwc3_ep *dep,
 
 static bool dwc3_gadget_ep_request_completed(struct dwc3_request *req)
 {
-	return req->num_pending_sgs == 0;
+	return req->num_pending_sgs == 0 && req->num_queued_sgs == 0;
 }
 
 static int dwc3_gadget_ep_cleanup_completed_request(struct dwc3_ep *dep,
@@ -2913,7 +2914,7 @@ static int dwc3_gadget_ep_cleanup_completed_request(struct dwc3_ep *dep,
 {
 	int ret;
 
-	if (req->num_pending_sgs)
+	if (req->request.num_mapped_sgs)
 		ret = dwc3_gadget_ep_reclaim_trb_sg(dep, req, event,
 				status);
 	else
-- 
2.31.1


