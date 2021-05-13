Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FFF237F197
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 05:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbhEMDSX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 23:18:23 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:55206 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230364AbhEMDSW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 23:18:22 -0400
Received: from mailhost.synopsys.com (sv1-mailhost1.synopsys.com [10.205.2.131])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id BA66DC00B7;
        Thu, 13 May 2021 03:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1620875832; bh=KEFUTDx9igpxab9D+xCbdEkP5WbQGqKnE22679/yhhk=;
        h=Date:From:Subject:To:Cc:From;
        b=gZS3vHNfGDUtYf4D452t+0bs46zEKb+opz42tRGvv2EuDbRsYou0MT4DXSrQg8mXw
         TwdrCw6oR7dUSAqwqvjjT09wV/M09MzQd6hUSpZXbXjQJZeOh4z4kb4tElVQawUch9
         Z6PhNnZn+FunFF3tyfptjJBJuqzk4L/aDXrEy9+o5z01DElY2Zec+8gjnxbeKSdNEh
         WQVYB8o2YjQ5Zty0/a6cEVvnDvKt6e5GS0ar7SVQpMsBHjrgTHa2cGGgsQnC8TUBqW
         hldv3TH0zNy1iVyWuk2WybMQFfKJGJ498SneP1XAaKQDM1EPHOL5p+miSYr/trEfWF
         A9OrjXJeAp/Jw==
Received: from lab-vbox (unknown [10.205.145.79])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id A8DF9A005E;
        Thu, 13 May 2021 03:17:09 +0000 (UTC)
Received: by lab-vbox (sSMTP sendmail emulation); Wed, 12 May 2021 20:17:09 -0700
Date:   Wed, 12 May 2021 20:17:09 -0700
Message-Id: <ba24591dbcaad8f244a3e88bd449bb7205a5aec3.1620874069.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH] usb: dwc3: gadget: Properly track pending and queued SG
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>, <stable@vger.kernel.org>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The driver incorrectly uses req->num_pending_sgs to track both the
number of pending and queued SG entries. It only prepares the next
request if the previous is done, and it doesn't update num_pending_sgs
until there is TRB completion interrupt. This may starve the controller
of more TRBs until the num_pending_sgs is decremented.

Fix this by decrementing the num_pending_sgs after they are queued and
properly track both num_mapped_sgs and num_queued_sgs.

Cc: <stable@vger.kernel.org>
Tested-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Reported-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Fixes: c96e6725db9d ("usb: dwc3: gadget: Correct the logic for queuing sgs")
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
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

base-commit: d9ff1096a840dddea3d5cfa2149ff7da9f499fb2
-- 
2.28.0

