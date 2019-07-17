Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 109566C256
	for <lists+stable@lfdr.de>; Wed, 17 Jul 2019 22:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbfGQUxS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 16:53:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:32450 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726063AbfGQUxS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 16:53:18 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jul 2019 13:53:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,275,1559545200"; 
   d="scan'208";a="170366132"
Received: from fei-dev-host.jf.intel.com ([10.7.198.158])
  by orsmga003.jf.intel.com with ESMTP; 17 Jul 2019 13:53:17 -0700
From:   fei.yang@intel.com
To:     felipe.balbi@linux.intel.com, john.stultz@linaro.org,
        andrzej.p@collabora.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Subject: [PATCH V2] usb: dwc3: gadget: trb_dequeue is not updated properly
Date:   Wed, 17 Jul 2019 13:53:08 -0700
Message-Id: <1563396788-126034-1-git-send-email-fei.yang@intel.com>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fei Yang <fei.yang@intel.com>

If scatter-gather operation is allowed, a large USB request would be split
into multiple TRBs. These TRBs are chained up by setting DWC3_TRB_CTRL_CHN
bit except the last one which has DWC3_TRB_CTRL_IOC bit set instead.
Since only the last TRB has IOC set, dwc3_gadget_ep_reclaim_completed_trb()
would be called only once for the whole USB request, thus all the TRBs need
to be reclaimed within this single call. However that is not what the current
code does.

This patch addresses the issue by checking each TRB in function
dwc3_gadget_ep_reclaim_trb_sg() and reclaiming the chained ones right there.
Only the last TRB gets passed to dwc3_gadget_ep_reclaim_completed_trb(). This
would guarantee all TRBs are reclaimed and trb_dequeue/num_trbs are updated
properly.

Signed-off-by: Fei Yang <fei.yang@intel.com>
Cc: stable <stable@vger.kernel.org>
---

V2: Better solution is to reclaim chained TRBs in dwc3_gadget_ep_reclaim_trb_sg()
    and leave the last TRB to the dwc3_gadget_ep_reclaim_completed_trb().

---

 drivers/usb/dwc3/gadget.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 173f532..c0662c2 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2404,7 +2404,7 @@ static int dwc3_gadget_ep_reclaim_trb_sg(struct dwc3_ep *dep,
 		struct dwc3_request *req, const struct dwc3_event_depevt *event,
 		int status)
 {
-	struct dwc3_trb *trb = &dep->trb_pool[dep->trb_dequeue];
+	struct dwc3_trb *trb;
 	struct scatterlist *sg = req->sg;
 	struct scatterlist *s;
 	unsigned int pending = req->num_pending_sgs;
@@ -2419,7 +2419,15 @@ static int dwc3_gadget_ep_reclaim_trb_sg(struct dwc3_ep *dep,
 
 		req->sg = sg_next(s);
 		req->num_pending_sgs--;
+		if (!(trb->ctrl & DWC3_TRB_CTRL_IOC)) {
+			/* reclaim the TRB without calling
+			 * dwc3_gadget_ep_reclaim_completed_trb */
+			dwc3_ep_inc_deq(dep);
+			req->num_trbs--;
+			continue;
+		}
 
+		/* Only the last TRB in the sg list would reach here */
 		ret = dwc3_gadget_ep_reclaim_completed_trb(dep, req,
 				trb, event, status, true);
 		if (ret)
-- 
2.7.4

