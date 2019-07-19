Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68BE36D7EE
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 02:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbfGSAqd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 20:46:33 -0400
Received: from mga07.intel.com ([134.134.136.100]:8592 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726015AbfGSAqd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jul 2019 20:46:33 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jul 2019 17:46:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,280,1559545200"; 
   d="scan'208";a="170749011"
Received: from fei-dev-host.jf.intel.com ([10.7.198.158])
  by orsmga003.jf.intel.com with ESMTP; 18 Jul 2019 17:46:32 -0700
From:   fei.yang@intel.com
To:     felipe.balbi@linux.intel.com, john.stultz@linaro.org,
        andrzej.p@collabora.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Subject: [PATCH v3] usb: dwc3: gadget: trb_dequeue is not updated properly
Date:   Thu, 18 Jul 2019 17:46:23 -0700
Message-Id: <1563497183-7114-1-git-send-email-fei.yang@intel.com>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fei Yang <fei.yang@intel.com>

If scatter-gather operation is allowed, a large USB request is split into
multiple TRBs. These TRBs are chained up by setting DWC3_TRB_CTRL_CHN bit
except the last one which has DWC3_TRB_CTRL_IOC bit set instead.
Since only the last TRB has IOC set for the whole USB request, the
dwc3_gadget_ep_reclaim_trb_sg() gets called only once after the last TRB
completes and all the TRBs allocated for this request are supposed to be
reclaimed. However that is not what the current code does.

dwc3_gadget_ep_reclaim_trb_sg() is trying to reclaim all the TRBs in the
following for-loop,
	for_each_sg(sg, s, pending, i) {
		trb = &dep->trb_pool[dep->trb_dequeue];

                if (trb->ctrl & DWC3_TRB_CTRL_HWO)
                        break;

                req->sg = sg_next(s);
                req->num_pending_sgs--;

                ret = dwc3_gadget_ep_reclaim_completed_trb(dep, req,
                                trb, event, status, chain);
                if (ret)
                        break;
        }
but since the interrupt comes only after the last TRB completes, the
event->status has DEPEVT_STATUS_IOC bit set, so that the for-loop ends for
the first TRB due to dwc3_gadget_ep_reclaim_completed_trb() returns 1.
	if (event->status & DEPEVT_STATUS_IOC)
		return 1;

This patch addresses the issue by checking each TRB in function
dwc3_gadget_ep_reclaim_trb_sg() and maing sure the chained ones are properly
reclaimed. dwc3_gadget_ep_reclaim_completed_trb() will return 1 Only for the
last TRB.

Signed-off-by: Fei Yang <fei.yang@intel.com>
Cc: stable <stable@vger.kernel.org>
---
v2: Better solution is to reclaim chained TRBs in dwc3_gadget_ep_reclaim_trb_sg()
    and leave the last TRB to the dwc3_gadget_ep_reclaim_completed_trb().
v3: Checking DWC3_TRB_CTRL_CHN bit for each TRB instead, and making sure that
    dwc3_gadget_ep_reclaim_completed_trb() returns 1 only for the last TRB.
---
 drivers/usb/dwc3/gadget.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 173f532..88eed49 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2394,7 +2394,7 @@ static int dwc3_gadget_ep_reclaim_completed_trb(struct dwc3_ep *dep,
 	if (event->status & DEPEVT_STATUS_SHORT && !chain)
 		return 1;
 
-	if (event->status & DEPEVT_STATUS_IOC)
+	if (event->status & DEPEVT_STATUS_IOC && !chain)
 		return 1;
 
 	return 0;
@@ -2404,11 +2404,12 @@ static int dwc3_gadget_ep_reclaim_trb_sg(struct dwc3_ep *dep,
 		struct dwc3_request *req, const struct dwc3_event_depevt *event,
 		int status)
 {
-	struct dwc3_trb *trb = &dep->trb_pool[dep->trb_dequeue];
+	struct dwc3_trb *trb;
 	struct scatterlist *sg = req->sg;
 	struct scatterlist *s;
 	unsigned int pending = req->num_pending_sgs;
 	unsigned int i;
+	int chain = false;
 	int ret = 0;
 
 	for_each_sg(sg, s, pending, i) {
@@ -2419,9 +2420,13 @@ static int dwc3_gadget_ep_reclaim_trb_sg(struct dwc3_ep *dep,
 
 		req->sg = sg_next(s);
 		req->num_pending_sgs--;
+		if (trb->ctrl & DWC3_TRB_CTRL_CHN)
+			chain = true;
+		else
+			chain = false;
 
 		ret = dwc3_gadget_ep_reclaim_completed_trb(dep, req,
-				trb, event, status, true);
+				trb, event, status, chain);
 		if (ret)
 			break;
 	}
-- 
2.7.4

