Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 185E178D0E
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 15:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727391AbfG2NnT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 09:43:19 -0400
Received: from mga05.intel.com ([192.55.52.43]:59656 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726926AbfG2NnS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 09:43:18 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jul 2019 06:43:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,322,1559545200"; 
   d="scan'208";a="370495855"
Received: from saranya-h97m-d3h.iind.intel.com ([10.66.254.8])
  by fmsmga005.fm.intel.com with ESMTP; 29 Jul 2019 06:43:16 -0700
From:   Saranya Gopal <saranya.gopal@intel.com>
To:     stable@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, fei.yang@intel.com,
        john.stultz@linaro.org,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Saranya Gopal <saranya.gopal@intel.com>
Subject: [PATCH 4.19.y 1/3] usb: dwc3: gadget: add dwc3_request status tracking
Date:   Mon, 29 Jul 2019 19:13:37 +0530
Message-Id: <1564407819-10746-2-git-send-email-saranya.gopal@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1564407819-10746-1-git-send-email-saranya.gopal@intel.com>
References: <1564407819-10746-1-git-send-email-saranya.gopal@intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felipe Balbi <felipe.balbi@linux.intel.com>

[Upstream commit a3af5e3ad3f11a0001317da9e9fb78b]

This patch starts tracking dwc3_request status. A following patch will
build on top of this to prevent a request from being queued twice.

Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Saranya Gopal <saranya.gopal@intel.com>
---
 drivers/usb/dwc3/core.h   | 9 +++++++++
 drivers/usb/dwc3/gadget.c | 3 +++
 drivers/usb/dwc3/gadget.h | 2 ++
 3 files changed, 14 insertions(+)

diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 13102850..301bf94 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -843,6 +843,7 @@ struct dwc3_hwparams {
  * @num_pending_sgs: counter to pending sgs
  * @num_queued_sgs: counter to the number of sgs which already got queued
  * @remaining: amount of data remaining
+ * @status: internal dwc3 request status tracking
  * @epnum: endpoint number to which this request refers
  * @trb: pointer to struct dwc3_trb
  * @trb_dma: DMA address of @trb
@@ -863,6 +864,14 @@ struct dwc3_request {
 	unsigned		num_pending_sgs;
 	unsigned int		num_queued_sgs;
 	unsigned		remaining;
+
+	unsigned int		status;
+#define DWC3_REQUEST_STATUS_QUEUED	0
+#define DWC3_REQUEST_STATUS_STARTED	1
+#define DWC3_REQUEST_STATUS_CANCELLED	2
+#define DWC3_REQUEST_STATUS_COMPLETED	3
+#define DWC3_REQUEST_STATUS_UNKNOWN	-1
+
 	u8			epnum;
 	struct dwc3_trb		*trb;
 	dma_addr_t		trb_dma;
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index e7461c9..3f337a0 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -209,6 +209,7 @@ void dwc3_gadget_giveback(struct dwc3_ep *dep, struct dwc3_request *req,
 	struct dwc3			*dwc = dep->dwc;
 
 	dwc3_gadget_del_and_unmap_request(dep, req, status);
+	req->status = DWC3_REQUEST_STATUS_COMPLETED;
 
 	spin_unlock(&dwc->lock);
 	usb_gadget_giveback_request(&dep->endpoint, &req->request);
@@ -838,6 +839,7 @@ static struct usb_request *dwc3_gadget_ep_alloc_request(struct usb_ep *ep,
 	req->direction	= dep->direction;
 	req->epnum	= dep->number;
 	req->dep	= dep;
+	req->status	= DWC3_REQUEST_STATUS_UNKNOWN;
 
 	trace_dwc3_alloc_request(req);
 
@@ -1297,6 +1299,7 @@ static int __dwc3_gadget_ep_queue(struct dwc3_ep *dep, struct dwc3_request *req)
 	trace_dwc3_ep_queue(req);
 
 	list_add_tail(&req->list, &dep->pending_list);
+	req->status = DWC3_REQUEST_STATUS_QUEUED;
 
 	/*
 	 * NOTICE: Isochronous endpoints should NEVER be prestarted. We must
diff --git a/drivers/usb/dwc3/gadget.h b/drivers/usb/dwc3/gadget.h
index 023a473..6aebe8c 100644
--- a/drivers/usb/dwc3/gadget.h
+++ b/drivers/usb/dwc3/gadget.h
@@ -76,6 +76,7 @@ static inline void dwc3_gadget_move_started_request(struct dwc3_request *req)
 	struct dwc3_ep		*dep = req->dep;
 
 	req->started = true;
+	req->status = DWC3_REQUEST_STATUS_STARTED;
 	list_move_tail(&req->list, &dep->started_list);
 }
 
@@ -91,6 +92,7 @@ static inline void dwc3_gadget_move_cancelled_request(struct dwc3_request *req)
 	struct dwc3_ep		*dep = req->dep;
 
 	req->started = false;
+	req->status = DWC3_REQUEST_STATUS_CANCELLED;
 	list_move_tail(&req->list, &dep->cancelled_list);
 }
 
-- 
1.9.1

