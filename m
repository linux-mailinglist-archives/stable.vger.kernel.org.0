Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 147BEE54C1
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 21:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbfJYT6j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 15:58:39 -0400
Received: from mga03.intel.com ([134.134.136.65]:47295 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726189AbfJYT6j (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Oct 2019 15:58:39 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Oct 2019 12:58:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,229,1569308400"; 
   d="scan'208";a="400217801"
Received: from sedona.ch.intel.com ([10.2.136.157])
  by fmsmga006.fm.intel.com with ESMTP; 25 Oct 2019 12:58:38 -0700
Received: from awfm-01.aw.intel.com (awfm-01.aw.intel.com [10.228.212.213])
        by sedona.ch.intel.com (8.14.3/8.14.3/Standard MailSET/Hub) with ESMTP id x9PJwckl024311;
        Fri, 25 Oct 2019 12:58:38 -0700
Received: from awfm-01.aw.intel.com (localhost [127.0.0.1])
        by awfm-01.aw.intel.com (8.14.7/8.14.7) with ESMTP id x9PJwaPp111994;
        Fri, 25 Oct 2019 15:58:36 -0400
Subject: [PATCH for-rc 3/4] IB/hfi1: Calculate flow weight based on QP MTU
 for TID RDMA
From:   Dennis Dalessandro <dennis.dalessandro@intel.com>
To:     jgg@ziepe.ca, dledford@redhat.com
Cc:     linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        stable@vger.kernel.org, Kaike Wan <kaike.wan@intel.com>
Date:   Fri, 25 Oct 2019 15:58:36 -0400
Message-ID: <20191025195836.106825.77769.stgit@awfm-01.aw.intel.com>
In-Reply-To: <20191025161717.106825.14421.stgit@awfm-01.aw.intel.com>
References: <20191025161717.106825.14421.stgit@awfm-01.aw.intel.com>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kaike Wan <kaike.wan@intel.com>

For a TID RDMA WRITE request, a QP on the responder side could be put
into a queue when a hardware flow is not available. A RNR NAK will be
returned to the requester with a RNR timeout value based on the
position of the QP in the queue. The tid_rdma_flow_wt variable is used
to calculate the timeout value and is determined by using a MTU of
4096 at the module loading time. This could reduce the timeout value
by half from the desired value, leading to excessive RNR retries.

This patch fixes the issue by calculating the flow weight with the
real MTU assigned to the QP.

Fixes: 07b923701e38 ("IB/hfi1: Add functions to receive TID RDMA WRITE request")
Cc: <stable@vger.kernel.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
---
 drivers/infiniband/hw/hfi1/init.c     |    1 -
 drivers/infiniband/hw/hfi1/tid_rdma.c |   13 +++++--------
 drivers/infiniband/hw/hfi1/tid_rdma.h |    3 +--
 3 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 71cb952..26b792b 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1489,7 +1489,6 @@ static int __init hfi1_mod_init(void)
 		goto bail_dev;
 	}
 
-	hfi1_compute_tid_rdma_flow_wt();
 	/*
 	 * These must be called before the driver is registered with
 	 * the PCI subsystem.
diff --git a/drivers/infiniband/hw/hfi1/tid_rdma.c b/drivers/infiniband/hw/hfi1/tid_rdma.c
index 73bc78b..e53f542 100644
--- a/drivers/infiniband/hw/hfi1/tid_rdma.c
+++ b/drivers/infiniband/hw/hfi1/tid_rdma.c
@@ -107,8 +107,6 @@ static u32 mask_generation(u32 a)
  * C - Capcode
  */
 
-static u32 tid_rdma_flow_wt;
-
 static void tid_rdma_trigger_resume(struct work_struct *work);
 static void hfi1_kern_exp_rcv_free_flows(struct tid_rdma_request *req);
 static int hfi1_kern_exp_rcv_alloc_flows(struct tid_rdma_request *req,
@@ -3388,18 +3386,17 @@ u32 hfi1_build_tid_rdma_write_req(struct rvt_qp *qp, struct rvt_swqe *wqe,
 	return sizeof(ohdr->u.tid_rdma.w_req) / sizeof(u32);
 }
 
-void hfi1_compute_tid_rdma_flow_wt(void)
+static u32 hfi1_compute_tid_rdma_flow_wt(struct rvt_qp *qp)
 {
 	/*
 	 * Heuristic for computing the RNR timeout when waiting on the flow
 	 * queue. Rather than a computationaly expensive exact estimate of when
 	 * a flow will be available, we assume that if a QP is at position N in
 	 * the flow queue it has to wait approximately (N + 1) * (number of
-	 * segments between two sync points), assuming PMTU of 4K. The rationale
-	 * for this is that flows are released and recycled at each sync point.
+	 * segments between two sync points). The rationale for this is that
+	 * flows are released and recycled at each sync point.
 	 */
-	tid_rdma_flow_wt = MAX_TID_FLOW_PSN * enum_to_mtu(OPA_MTU_4096) /
-		TID_RDMA_MAX_SEGMENT_SIZE;
+	return (MAX_TID_FLOW_PSN * qp->pmtu) >> TID_RDMA_SEGMENT_SHIFT;
 }
 
 static u32 position_in_queue(struct hfi1_qp_priv *qpriv,
@@ -3522,7 +3519,7 @@ static void hfi1_tid_write_alloc_resources(struct rvt_qp *qp, bool intr_ctx)
 		if (qpriv->flow_state.index >= RXE_NUM_TID_FLOWS) {
 			ret = hfi1_kern_setup_hw_flow(qpriv->rcd, qp);
 			if (ret) {
-				to_seg = tid_rdma_flow_wt *
+				to_seg = hfi1_compute_tid_rdma_flow_wt(qp) *
 					position_in_queue(qpriv,
 							  &rcd->flow_queue);
 				break;
diff --git a/drivers/infiniband/hw/hfi1/tid_rdma.h b/drivers/infiniband/hw/hfi1/tid_rdma.h
index 1c53618..6e82df2 100644
--- a/drivers/infiniband/hw/hfi1/tid_rdma.h
+++ b/drivers/infiniband/hw/hfi1/tid_rdma.h
@@ -17,6 +17,7 @@
 #define TID_RDMA_MIN_SEGMENT_SIZE       BIT(18)   /* 256 KiB (for now) */
 #define TID_RDMA_MAX_SEGMENT_SIZE       BIT(18)   /* 256 KiB (for now) */
 #define TID_RDMA_MAX_PAGES              (BIT(18) >> PAGE_SHIFT)
+#define TID_RDMA_SEGMENT_SHIFT		18
 
 /*
  * Bit definitions for priv->s_flags.
@@ -274,8 +275,6 @@ u32 hfi1_build_tid_rdma_write_req(struct rvt_qp *qp, struct rvt_swqe *wqe,
 				  struct ib_other_headers *ohdr,
 				  u32 *bth1, u32 *bth2, u32 *len);
 
-void hfi1_compute_tid_rdma_flow_wt(void);
-
 void hfi1_rc_rcv_tid_rdma_write_req(struct hfi1_packet *packet);
 
 u32 hfi1_build_tid_rdma_write_resp(struct rvt_qp *qp, struct rvt_ack_entry *e,

