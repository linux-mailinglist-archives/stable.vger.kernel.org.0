Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B15776AF058
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:30:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232985AbjCGSaF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:30:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232960AbjCGS3c (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:29:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F76F94D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:22:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 881DE614E8
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:22:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E880C433EF;
        Tue,  7 Mar 2023 18:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213378;
        bh=K7OAofMcBcsBizNF6JrI8agwwADP2el0GAH2cgFNZNo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c7aTpEhLekJfxC8E94rqXUq6uvlqnsGAu84Rs2DsvYRl0dbvkVLEX8nQBWTPCdP+P
         DGYrR3FZ9McOftrO/XR+N7ETv3fCUbX5lP7XK9UkM/KQ5csxDAVtNt3WN2rJqzrltN
         ptq9Eo6IfEdm5PAm7zRruwlBgPNvcDvjlxMdYGis=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yunsheng Lin <linyunsheng@huawei.com>,
        Haoyue Xu <xuhaoyue1@hisilicon.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 489/885] RDMA/rxe: cleanup some error handling in rxe_verbs.c
Date:   Tue,  7 Mar 2023 17:57:03 +0100
Message-Id: <20230307170023.711554858@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

[ Upstream commit 692373d186205dfb1b56f35f22702412d94d9420 ]

Instead of 'goto and return', just return directly to
simplify the error handling, and avoid some unnecessary
return value check.

Link: https://lore.kernel.org/r/20221028075053.3990467-1-xuhaoyue1@hisilicon.com
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Haoyue Xu <xuhaoyue1@hisilicon.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: a77a52385e9a ("RDMA/rxe: Fix missing memory barriers in rxe_queue.h")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_verbs.c | 80 ++++++++-------------------
 1 file changed, 23 insertions(+), 57 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index 88825edc7dce1..3bc0448f56deb 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -238,7 +238,6 @@ static int rxe_destroy_ah(struct ib_ah *ibah, u32 flags)
 
 static int post_one_recv(struct rxe_rq *rq, const struct ib_recv_wr *ibwr)
 {
-	int err;
 	int i;
 	u32 length;
 	struct rxe_recv_wqe *recv_wqe;
@@ -246,15 +245,11 @@ static int post_one_recv(struct rxe_rq *rq, const struct ib_recv_wr *ibwr)
 	int full;
 
 	full = queue_full(rq->queue, QUEUE_TYPE_TO_DRIVER);
-	if (unlikely(full)) {
-		err = -ENOMEM;
-		goto err1;
-	}
+	if (unlikely(full))
+		return -ENOMEM;
 
-	if (unlikely(num_sge > rq->max_sge)) {
-		err = -EINVAL;
-		goto err1;
-	}
+	if (unlikely(num_sge > rq->max_sge))
+		return -EINVAL;
 
 	length = 0;
 	for (i = 0; i < num_sge; i++)
@@ -275,9 +270,6 @@ static int post_one_recv(struct rxe_rq *rq, const struct ib_recv_wr *ibwr)
 	queue_advance_producer(rq->queue, QUEUE_TYPE_TO_DRIVER);
 
 	return 0;
-
-err1:
-	return err;
 }
 
 static int rxe_create_srq(struct ib_srq *ibsrq, struct ib_srq_init_attr *init,
@@ -343,10 +335,7 @@ static int rxe_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
 	if (err)
 		return err;
 
-	err = rxe_srq_from_attr(rxe, srq, attr, mask, &ucmd, udata);
-	if (err)
-		return err;
-	return 0;
+	return rxe_srq_from_attr(rxe, srq, attr, mask, &ucmd, udata);
 }
 
 static int rxe_query_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr)
@@ -453,11 +442,11 @@ static int rxe_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 
 	err = rxe_qp_chk_attr(rxe, qp, attr, mask);
 	if (err)
-		goto err1;
+		return err;
 
 	err = rxe_qp_from_attr(qp, attr, mask, udata);
 	if (err)
-		goto err1;
+		return err;
 
 	if ((mask & IB_QP_AV) && (attr->ah_attr.ah_flags & IB_AH_GRH))
 		qp->src_port = rdma_get_udp_sport(attr->ah_attr.grh.flow_label,
@@ -465,9 +454,6 @@ static int rxe_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 						  qp->attr.dest_qp_num);
 
 	return 0;
-
-err1:
-	return err;
 }
 
 static int rxe_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
@@ -501,24 +487,21 @@ static int validate_send_wr(struct rxe_qp *qp, const struct ib_send_wr *ibwr,
 	struct rxe_sq *sq = &qp->sq;
 
 	if (unlikely(num_sge > sq->max_sge))
-		goto err1;
+		return -EINVAL;
 
 	if (unlikely(mask & WR_ATOMIC_MASK)) {
 		if (length < 8)
-			goto err1;
+			return -EINVAL;
 
 		if (atomic_wr(ibwr)->remote_addr & 0x7)
-			goto err1;
+			return -EINVAL;
 	}
 
 	if (unlikely((ibwr->send_flags & IB_SEND_INLINE) &&
 		     (length > sq->max_inline)))
-		goto err1;
+		return -EINVAL;
 
 	return 0;
-
-err1:
-	return -EINVAL;
 }
 
 static void init_send_wr(struct rxe_qp *qp, struct rxe_send_wr *wr,
@@ -735,14 +718,12 @@ static int rxe_post_recv(struct ib_qp *ibqp, const struct ib_recv_wr *wr,
 
 	if (unlikely((qp_state(qp) < IB_QPS_INIT) || !qp->valid)) {
 		*bad_wr = wr;
-		err = -EINVAL;
-		goto err1;
+		return -EINVAL;
 	}
 
 	if (unlikely(qp->srq)) {
 		*bad_wr = wr;
-		err = -EINVAL;
-		goto err1;
+		return -EINVAL;
 	}
 
 	spin_lock_irqsave(&rq->producer_lock, flags);
@@ -761,7 +742,6 @@ static int rxe_post_recv(struct ib_qp *ibqp, const struct ib_recv_wr *wr,
 	if (qp->resp.state == QP_STATE_ERROR)
 		rxe_run_task(&qp->resp.task, 1);
 
-err1:
 	return err;
 }
 
@@ -826,16 +806,9 @@ static int rxe_resize_cq(struct ib_cq *ibcq, int cqe, struct ib_udata *udata)
 
 	err = rxe_cq_chk_attr(rxe, cq, cqe, 0);
 	if (err)
-		goto err1;
-
-	err = rxe_cq_resize_queue(cq, cqe, uresp, udata);
-	if (err)
-		goto err1;
-
-	return 0;
+		return err;
 
-err1:
-	return err;
+	return rxe_cq_resize_queue(cq, cqe, uresp, udata);
 }
 
 static int rxe_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc)
@@ -921,26 +894,22 @@ static struct ib_mr *rxe_reg_user_mr(struct ib_pd *ibpd,
 	struct rxe_mr *mr;
 
 	mr = rxe_alloc(&rxe->mr_pool);
-	if (!mr) {
-		err = -ENOMEM;
-		goto err2;
-	}
-
+	if (!mr)
+		return ERR_PTR(-ENOMEM);
 
 	rxe_get(pd);
 	mr->ibmr.pd = ibpd;
 
 	err = rxe_mr_init_user(rxe, start, length, iova, access, mr);
 	if (err)
-		goto err3;
+		goto err1;
 
 	rxe_finalize(mr);
 
 	return &mr->ibmr;
 
-err3:
+err1:
 	rxe_cleanup(mr);
-err2:
 	return ERR_PTR(err);
 }
 
@@ -956,25 +925,22 @@ static struct ib_mr *rxe_alloc_mr(struct ib_pd *ibpd, enum ib_mr_type mr_type,
 		return ERR_PTR(-EINVAL);
 
 	mr = rxe_alloc(&rxe->mr_pool);
-	if (!mr) {
-		err = -ENOMEM;
-		goto err1;
-	}
+	if (!mr)
+		return ERR_PTR(-ENOMEM);
 
 	rxe_get(pd);
 	mr->ibmr.pd = ibpd;
 
 	err = rxe_mr_init_fast(max_num_sg, mr);
 	if (err)
-		goto err2;
+		goto err1;
 
 	rxe_finalize(mr);
 
 	return &mr->ibmr;
 
-err2:
-	rxe_cleanup(mr);
 err1:
+	rxe_cleanup(mr);
 	return ERR_PTR(err);
 }
 
-- 
2.39.2



