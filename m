Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4A69D39E
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 18:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731987AbfHZQBx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 12:01:53 -0400
Received: from mga18.intel.com ([134.134.136.126]:25531 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731513AbfHZQBx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Aug 2019 12:01:53 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Aug 2019 09:01:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,433,1559545200"; 
   d="scan'208";a="209417063"
Received: from sedona.ch.intel.com ([10.2.136.157])
  by fmsmga002.fm.intel.com with ESMTP; 26 Aug 2019 09:01:51 -0700
Received: from awfm-01.aw.intel.com (awfm-01.aw.intel.com [10.228.212.213])
        by sedona.ch.intel.com (8.14.3/8.14.3/Standard MailSET/Hub) with ESMTP id x7QG1pVd022102;
        Mon, 26 Aug 2019 09:01:51 -0700
Received: from awfm-01.aw.intel.com (localhost [127.0.0.1])
        by awfm-01.aw.intel.com (8.14.7/8.14.7) with ESMTP id x7QG1oRV032230;
        Mon, 26 Aug 2019 12:01:50 -0400
Subject: [PATCH] IB/hfi1: Drop stale TID RDMA packets
To:     stable@vger.kernel.org
From:   Mike Marciniszyn <mike.marciniszyn@intel.com>
Cc:     linux-rdma@vger.kernel.org, stable-commits@vger.kernel.org
Date:   Mon, 26 Aug 2019 12:01:50 -0400
Message-ID: <20190826160149.32208.89081.stgit@awfm-01.aw.intel.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kaike Wan <kaike.wan@intel.com>

Upstream commit d58c1834bf0d218a0bc00f8fb44874551b21da84.

In a congested fabric with adaptive routing enabled, traces show that
the sender could receive stale TID RDMA NAK packets that contain newer
KDETH PSNs and older Verbs PSNs. If not dropped, these packets could
cause the incorrect rewinding of the software flows and the incorrect
completion of TID RDMA WRITE requests, and eventually leading to memory
corruption and kernel crash.

The current code drops stale TID RDMA ACK/NAK packets solely based
on KDETH PSNs, which may lead to erroneous processing. This patch
fixes the issue by also checking the Verbs PSN. Addition checks are
added before rewinding the TID RDMA WRITE DATA packets.

[ported to 5.2 from upstream accounting for fspsn replacing flpsn.]

Fixes: 9e93e967f7b4 ("IB/hfi1: Add a function to receive TID RDMA ACK packet")
Cc: <stable@vger.kernel.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Doug Ledford <dledford@redhat.com>
---
 0 files changed

diff --git a/drivers/infiniband/hw/hfi1/tid_rdma.c b/drivers/infiniband/hw/hfi1/tid_rdma.c
index fe7e709..8fcad80 100644
--- a/drivers/infiniband/hw/hfi1/tid_rdma.c
+++ b/drivers/infiniband/hw/hfi1/tid_rdma.c
@@ -4511,7 +4511,7 @@ void hfi1_rc_rcv_tid_rdma_ack(struct hfi1_packet *packet)
 	struct rvt_swqe *wqe;
 	struct tid_rdma_request *req;
 	struct tid_rdma_flow *flow;
-	u32 aeth, psn, req_psn, ack_psn, fspsn, resync_psn, ack_kpsn;
+	u32 aeth, psn, req_psn, ack_psn, flpsn, resync_psn, ack_kpsn;
 	unsigned long flags;
 	u16 fidx;
 
@@ -4540,6 +4540,9 @@ void hfi1_rc_rcv_tid_rdma_ack(struct hfi1_packet *packet)
 		ack_kpsn--;
 	}
 
+	if (unlikely(qp->s_acked == qp->s_tail))
+		goto ack_op_err;
+
 	wqe = rvt_get_swqe_ptr(qp, qp->s_acked);
 
 	if (wqe->wr.opcode != IB_WR_TID_RDMA_WRITE)
@@ -4552,7 +4555,8 @@ void hfi1_rc_rcv_tid_rdma_ack(struct hfi1_packet *packet)
 	trace_hfi1_tid_flow_rcv_tid_ack(qp, req->acked_tail, flow);
 
 	/* Drop stale ACK/NAK */
-	if (cmp_psn(psn, full_flow_psn(flow, flow->flow_state.spsn)) < 0)
+	if (cmp_psn(psn, full_flow_psn(flow, flow->flow_state.spsn)) < 0 ||
+	    cmp_psn(req_psn, flow->flow_state.resp_ib_psn) < 0)
 		goto ack_op_err;
 
 	while (cmp_psn(ack_kpsn,
@@ -4714,8 +4718,12 @@ void hfi1_rc_rcv_tid_rdma_ack(struct hfi1_packet *packet)
 		switch ((aeth >> IB_AETH_CREDIT_SHIFT) &
 			IB_AETH_CREDIT_MASK) {
 		case 0: /* PSN sequence error */
+			if (!req->flows)
+				break;
 			flow = &req->flows[req->acked_tail];
-			fspsn = full_flow_psn(flow, flow->flow_state.spsn);
+			flpsn = full_flow_psn(flow, flow->flow_state.lpsn);
+			if (cmp_psn(psn, flpsn) > 0)
+				break;
 			trace_hfi1_tid_flow_rcv_tid_ack(qp, req->acked_tail,
 							flow);
 			req->r_ack_psn = mask_psn(be32_to_cpu(ohdr->bth[2]));

