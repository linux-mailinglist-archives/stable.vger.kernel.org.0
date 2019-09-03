Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10E65A70B1
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730441AbfICQkq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:40:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:44662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730213AbfICQY7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:24:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B30F23431;
        Tue,  3 Sep 2019 16:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567527898;
        bh=bNbMGqAe9otMXDvcbH3us16H3ybiZym4a+BXb5+wTts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HIg1gI5BKNw/+JAjJjJ60HpubgWrgdrioNZSwWdCuFS10/TPQJz59vRit8q2OewFO
         UjRfTt0TKEBj+vMeXxUCTTrg65cmGm/2+bJyUaimHTvwSzwSnpNCtb0NOW1NHantv+
         TfEdCrUEqZlsRVkS6kBhDb/h4jQLzUq9kmBKcQVg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kaike Wan <kaike.wan@intel.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 11/23] IB/hfi1: Unreserve a flushed OPFN request
Date:   Tue,  3 Sep 2019 12:24:12 -0400
Message-Id: <20190903162424.6877-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162424.6877-1-sashal@kernel.org>
References: <20190903162424.6877-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kaike Wan <kaike.wan@intel.com>

When an OPFN request is flushed, the request is completed without
unreserving itself from the send queue. Subsequently, when a new
request is post sent, the following warning will be triggered:

WARNING: CPU: 4 PID: 8130 at rdmavt/qp.c:1761 rvt_post_send+0x72a/0x880 [rdmavt]
Call Trace:
[<ffffffffbbb61e41>] dump_stack+0x19/0x1b
[<ffffffffbb497688>] __warn+0xd8/0x100
[<ffffffffbb4977cd>] warn_slowpath_null+0x1d/0x20
[<ffffffffc01c941a>] rvt_post_send+0x72a/0x880 [rdmavt]
[<ffffffffbb4dcabe>] ? account_entity_dequeue+0xae/0xd0
[<ffffffffbb61d645>] ? __kmalloc+0x55/0x230
[<ffffffffc04e1a4c>] ib_uverbs_post_send+0x37c/0x5d0 [ib_uverbs]
[<ffffffffc04e5e36>] ? rdma_lookup_put_uobject+0x26/0x60 [ib_uverbs]
[<ffffffffc04dbce6>] ib_uverbs_write+0x286/0x460 [ib_uverbs]
[<ffffffffbb6f9457>] ? security_file_permission+0x27/0xa0
[<ffffffffbb641650>] vfs_write+0xc0/0x1f0
[<ffffffffbb64246f>] SyS_write+0x7f/0xf0
[<ffffffffbbb74ddb>] system_call_fastpath+0x22/0x27

This patch fixes the problem by moving rvt_qp_wqe_unreserve() into
rvt_qp_complete_swqe() to simplify the code and make it less
error-prone.

Fixes: ca95f802ef51 ("IB/hfi1: Unreserve a reserved request when it is completed")
Link: https://lore.kernel.org/r/20190715164528.74174.31364.stgit@awfm-01.aw.intel.com
Cc: <stable@vger.kernel.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
---
 drivers/infiniband/hw/hfi1/rc.c | 2 --
 include/rdma/rdmavt_qp.h        | 9 ++++-----
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index 235bdbc706acc..5c0d90418e8c4 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -1835,7 +1835,6 @@ void hfi1_rc_send_complete(struct rvt_qp *qp, struct hfi1_opa_header *opah)
 		    cmp_psn(qp->s_sending_psn, qp->s_sending_hpsn) <= 0)
 			break;
 		trdma_clean_swqe(qp, wqe);
-		rvt_qp_wqe_unreserve(qp, wqe);
 		trace_hfi1_qp_send_completion(qp, wqe, qp->s_last);
 		rvt_qp_complete_swqe(qp,
 				     wqe,
@@ -1882,7 +1881,6 @@ struct rvt_swqe *do_rc_completion(struct rvt_qp *qp,
 	if (cmp_psn(wqe->lpsn, qp->s_sending_psn) < 0 ||
 	    cmp_psn(qp->s_sending_psn, qp->s_sending_hpsn) > 0) {
 		trdma_clean_swqe(qp, wqe);
-		rvt_qp_wqe_unreserve(qp, wqe);
 		trace_hfi1_qp_send_completion(qp, wqe, qp->s_last);
 		rvt_qp_complete_swqe(qp,
 				     wqe,
diff --git a/include/rdma/rdmavt_qp.h b/include/rdma/rdmavt_qp.h
index 84d0f36afc2f7..85544777587db 100644
--- a/include/rdma/rdmavt_qp.h
+++ b/include/rdma/rdmavt_qp.h
@@ -540,7 +540,7 @@ static inline void rvt_qp_wqe_reserve(
 /**
  * rvt_qp_wqe_unreserve - clean reserved operation
  * @qp - the rvt qp
- * @wqe - the send wqe
+ * @flags - send wqe flags
  *
  * This decrements the reserve use count.
  *
@@ -552,11 +552,9 @@ static inline void rvt_qp_wqe_reserve(
  * the compiler does not juggle the order of the s_last
  * ring index and the decrementing of s_reserved_used.
  */
-static inline void rvt_qp_wqe_unreserve(
-	struct rvt_qp *qp,
-	struct rvt_swqe *wqe)
+static inline void rvt_qp_wqe_unreserve(struct rvt_qp *qp, int flags)
 {
-	if (unlikely(wqe->wr.send_flags & RVT_SEND_RESERVE_USED)) {
+	if (unlikely(flags & RVT_SEND_RESERVE_USED)) {
 		atomic_dec(&qp->s_reserved_used);
 		/* insure no compiler re-order up to s_last change */
 		smp_mb__after_atomic();
@@ -743,6 +741,7 @@ rvt_qp_complete_swqe(struct rvt_qp *qp,
 	u32 byte_len, last;
 	int flags = wqe->wr.send_flags;
 
+	rvt_qp_wqe_unreserve(qp, flags);
 	rvt_put_qp_swqe(qp, wqe);
 
 	need_completion =
-- 
2.20.1

