Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEF5F101902
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:12:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727555AbfKSFVw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:21:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:37020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727539AbfKSFVw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:21:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8941C22317;
        Tue, 19 Nov 2019 05:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574140911;
        bh=CJOh/AEurzA1JL2ub0QQllerEeJhhnzigM7uwjnATCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DqsOtqyLPHgzV5GXKB3ik+2ojlfedwY8MA8npKstKxV9a3Itrct7AVlhvr4hx6iO5
         lQiSsSSrEqB31psJno5fRC5ZsKRv+xmCjNhBuiaknqZ8hcbwNz37XRf+aoerw6Qo9X
         GbmP7Z3BJ44xYzzFwsw+ygEy4QmzYm3D6HWT/Wkc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Kaike Wan <kaike.wan@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.3 28/48] IB/hfi1: Calculate flow weight based on QP MTU for TID RDMA
Date:   Tue, 19 Nov 2019 06:19:48 +0100
Message-Id: <20191119051009.905141136@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119050946.745015350@linuxfoundation.org>
References: <20191119050946.745015350@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kaike Wan <kaike.wan@intel.com>

commit c2be3865a1763c4be39574937e1aae27e917af4d upstream.

For a TID RDMA WRITE request, a QP on the responder side could be put into
a queue when a hardware flow is not available. A RNR NAK will be returned
to the requester with a RNR timeout value based on the position of the QP
in the queue. The tid_rdma_flow_wt variable is used to calculate the
timeout value and is determined by using a MTU of 4096 at the module
loading time. This could reduce the timeout value by half from the desired
value, leading to excessive RNR retries.

This patch fixes the issue by calculating the flow weight with the real
MTU assigned to the QP.

Fixes: 07b923701e38 ("IB/hfi1: Add functions to receive TID RDMA WRITE request")
Link: https://lore.kernel.org/r/20191025195836.106825.77769.stgit@awfm-01.aw.intel.com
Cc: <stable@vger.kernel.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/hfi1/init.c     |    1 -
 drivers/infiniband/hw/hfi1/tid_rdma.c |   13 +++++--------
 drivers/infiniband/hw/hfi1/tid_rdma.h |    3 +--
 3 files changed, 6 insertions(+), 11 deletions(-)

--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1489,7 +1489,6 @@ static int __init hfi1_mod_init(void)
 		goto bail_dev;
 	}
 
-	hfi1_compute_tid_rdma_flow_wt();
 	/*
 	 * These must be called before the driver is registered with
 	 * the PCI subsystem.
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
@@ -3380,18 +3378,17 @@ u32 hfi1_build_tid_rdma_write_req(struct
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
@@ -3514,7 +3511,7 @@ static void hfi1_tid_write_alloc_resourc
 		if (qpriv->flow_state.index >= RXE_NUM_TID_FLOWS) {
 			ret = hfi1_kern_setup_hw_flow(qpriv->rcd, qp);
 			if (ret) {
-				to_seg = tid_rdma_flow_wt *
+				to_seg = hfi1_compute_tid_rdma_flow_wt(qp) *
 					position_in_queue(qpriv,
 							  &rcd->flow_queue);
 				break;
--- a/drivers/infiniband/hw/hfi1/tid_rdma.h
+++ b/drivers/infiniband/hw/hfi1/tid_rdma.h
@@ -17,6 +17,7 @@
 #define TID_RDMA_MIN_SEGMENT_SIZE       BIT(18)   /* 256 KiB (for now) */
 #define TID_RDMA_MAX_SEGMENT_SIZE       BIT(18)   /* 256 KiB (for now) */
 #define TID_RDMA_MAX_PAGES              (BIT(18) >> PAGE_SHIFT)
+#define TID_RDMA_SEGMENT_SHIFT		18
 
 /*
  * Bit definitions for priv->s_flags.
@@ -274,8 +275,6 @@ u32 hfi1_build_tid_rdma_write_req(struct
 				  struct ib_other_headers *ohdr,
 				  u32 *bth1, u32 *bth2, u32 *len);
 
-void hfi1_compute_tid_rdma_flow_wt(void);
-
 void hfi1_rc_rcv_tid_rdma_write_req(struct hfi1_packet *packet);
 
 u32 hfi1_build_tid_rdma_write_resp(struct rvt_qp *qp, struct rvt_ack_entry *e,


