Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A13B9396021
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233128AbhEaOXC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:23:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:43228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232971AbhEaORg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:17:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1AD8613E4;
        Mon, 31 May 2021 13:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468619;
        bh=aEFSvsSsem7Qli/Aw9qGJLdRqG0zPZdwFN513yQQtiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g53RDwfxhemh0J2JkgSK6NFmY/rouRaXJ3vxBjkz/E1BTX4MSVcxw7YaZI/BN9/AD
         MS6Utqi/F8Skc6/AW5s8VyqerAjxw/ilgJnKwDVBQ2osbjXf4j6kOtSe7d9xJoAQUG
         d5sAbPrU7BqHWw0FUXsNZrbdxESW19fMR50eoLLo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Felipe Balbi <balbi@kernel.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 5.4 061/177] usb: dwc3: gadget: Properly track pending and queued SG
Date:   Mon, 31 May 2021 15:13:38 +0200
Message-Id: <20210531130650.013959872@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit 25dda9fc56bd90d45f9a4516bcfa5211e61b4290 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1162,6 +1162,7 @@ static void dwc3_prepare_one_trb_sg(stru
 			req->start_sg = sg_next(s);
 
 		req->num_queued_sgs++;
+		req->num_pending_sgs--;
 
 		/*
 		 * The number of pending SG entries may not correspond to the
@@ -1169,7 +1170,7 @@ static void dwc3_prepare_one_trb_sg(stru
 		 * don't include unused SG entries.
 		 */
 		if (length == 0) {
-			req->num_pending_sgs -= req->request.num_mapped_sgs - req->num_queued_sgs;
+			req->num_pending_sgs = 0;
 			break;
 		}
 
@@ -2602,15 +2603,15 @@ static int dwc3_gadget_ep_reclaim_trb_sg
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
@@ -2633,7 +2634,7 @@ static int dwc3_gadget_ep_reclaim_trb_li
 
 static bool dwc3_gadget_ep_request_completed(struct dwc3_request *req)
 {
-	return req->num_pending_sgs == 0;
+	return req->num_pending_sgs == 0 && req->num_queued_sgs == 0;
 }
 
 static int dwc3_gadget_ep_cleanup_completed_request(struct dwc3_ep *dep,
@@ -2642,7 +2643,7 @@ static int dwc3_gadget_ep_cleanup_comple
 {
 	int ret;
 
-	if (req->num_pending_sgs)
+	if (req->request.num_mapped_sgs)
 		ret = dwc3_gadget_ep_reclaim_trb_sg(dep, req, event,
 				status);
 	else


