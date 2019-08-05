Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93F2481CBF
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731283AbfHENZp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:25:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:34266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731279AbfHENZo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:25:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FCAB20644;
        Mon,  5 Aug 2019 13:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011543;
        bh=VSBuZuQ2TjME/vq/siv1SahZ1Ua+CuTdzLk6UoAYRxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G/ViWXB7FJjgD0/9lCSPfQAPU9T/WuirtTo8ZM1SfL5DbuldySbj0XZ/733l179N1
         VnHHhVKQNY//y2p+QPGoHnbPTv6mnuj1LfxfzxNOxsK2MJjDb+ZjCSjKXH+1zDyXtB
         GpIppK+Jbq5B70vCJoq80V+uHFElQsI6dyFzoDoE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Kaike Wan <kaike.wan@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.2 128/131] IB/hfi1: Drop all TID RDMA READ RESP packets after r_next_psn
Date:   Mon,  5 Aug 2019 15:03:35 +0200
Message-Id: <20190805125000.558551973@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124951.453337465@linuxfoundation.org>
References: <20190805124951.453337465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kaike Wan <kaike.wan@intel.com>

commit f4d46119f214f9a7620b0d18b153d7e0e8c90b4f upstream.

When a TID sequence error occurs while receiving TID RDMA READ RESP
packets, all packets after flow->flow_state.r_next_psn should be dropped,
including those response packets for subsequent segments.

The current implementation will drop the subsequent response packets for
the segment to complete next, but may accept packets for subsequent
segments and therefore mistakenly advance the r_next_psn fields for the
corresponding software flows. This may result in failures to complete
subsequent segments after the current segment is completed.

The fix is to only use the flow pointed by req->clear_tail for checking
KDETH PSN instead of finding a flow from the request's flow array.

Fixes: b885d5be9ca1 ("IB/hfi1: Unify the software PSN check for TID RDMA READ/WRITE")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20190715164540.74174.54702.stgit@awfm-01.aw.intel.com
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/hfi1/tid_rdma.c |   42 ----------------------------------
 1 file changed, 1 insertion(+), 41 deletions(-)

--- a/drivers/infiniband/hw/hfi1/tid_rdma.c
+++ b/drivers/infiniband/hw/hfi1/tid_rdma.c
@@ -1673,34 +1673,6 @@ static struct tid_rdma_flow *find_flow_i
 	return NULL;
 }
 
-static struct tid_rdma_flow *
-__find_flow_ranged(struct tid_rdma_request *req, u16 head, u16 tail,
-		   u32 psn, u16 *fidx)
-{
-	for ( ; CIRC_CNT(head, tail, MAX_FLOWS);
-	      tail = CIRC_NEXT(tail, MAX_FLOWS)) {
-		struct tid_rdma_flow *flow = &req->flows[tail];
-		u32 spsn, lpsn;
-
-		spsn = full_flow_psn(flow, flow->flow_state.spsn);
-		lpsn = full_flow_psn(flow, flow->flow_state.lpsn);
-
-		if (cmp_psn(psn, spsn) >= 0 && cmp_psn(psn, lpsn) <= 0) {
-			if (fidx)
-				*fidx = tail;
-			return flow;
-		}
-	}
-	return NULL;
-}
-
-static struct tid_rdma_flow *find_flow(struct tid_rdma_request *req,
-				       u32 psn, u16 *fidx)
-{
-	return __find_flow_ranged(req, req->setup_head, req->clear_tail, psn,
-				  fidx);
-}
-
 /* TID RDMA READ functions */
 u32 hfi1_build_tid_rdma_read_packet(struct rvt_swqe *wqe,
 				    struct ib_other_headers *ohdr, u32 *bth1,
@@ -2790,19 +2762,7 @@ static bool handle_read_kdeth_eflags(str
 			 * to prevent continuous Flow Sequence errors for any
 			 * packets that could be still in the fabric.
 			 */
-			flow = find_flow(req, psn, NULL);
-			if (!flow) {
-				/*
-				 * We can't find the IB PSN matching the
-				 * received KDETH PSN. The only thing we can
-				 * do at this point is report the error to
-				 * the QP.
-				 */
-				hfi1_kern_read_tid_flow_free(qp);
-				spin_unlock(&qp->s_lock);
-				rvt_rc_error(qp, IB_WC_LOC_QP_OP_ERR);
-				return ret;
-			}
+			flow = &req->flows[req->clear_tail];
 			if (priv->s_flags & HFI1_R_TID_SW_PSN) {
 				diff = cmp_psn(psn,
 					       flow->flow_state.r_next_psn);


