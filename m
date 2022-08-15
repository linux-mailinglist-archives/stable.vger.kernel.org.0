Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26E7E5939E5
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245621AbiHOT3G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245615AbiHOT0C (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:26:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 602FE3ED70;
        Mon, 15 Aug 2022 11:41:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 133DBB8105C;
        Mon, 15 Aug 2022 18:41:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 584BEC433D7;
        Mon, 15 Aug 2022 18:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588884;
        bh=YVsnVuSTYcaa9tQGwvyI6dFXD95rjra3stsjmc8dPxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AJGQ+UlWbzW+D2PIpck2a0PFYjsGdnwgCd3T2QM/79p/ztvBH3d7rKRHEvBqMlPen
         KkU/b6CQhMVaDHD8ADPtLUcSD9kS+RALz1pH2fpcHeU/OOt/fa9xS2TLTPSUnnM8QE
         gOjB1Jx1TwDWbPCqv3b2yYBr77N3r7Ro12GATWt8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiao Yang <yangx.jy@fujitsu.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 545/779] RDMA/rxe: Remove the is_user members of struct rxe_sq/rxe_rq/rxe_srq
Date:   Mon, 15 Aug 2022 20:03:09 +0200
Message-Id: <20220815180400.598735848@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiao Yang <yangx.jy@fujitsu.com>

[ Upstream commit 1cf2ce8272802e677398fab47a73713bc6e1fd5c ]

The is_user members of struct rxe_sq/rxe_rq/rxe_srq are unsed since
commit ae6e843fe08d ("RDMA/rxe: Add memory barriers to kernel queues").
In this case, it is fine to remove them directly.

Link: https://lore.kernel.org/r/20210930094813.226888-2-yangx.jy@fujitsu.com
Signed-off-by: Xiao Yang <yangx.jy@fujitsu.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_qp.c    | 2 --
 drivers/infiniband/sw/rxe/rxe_srq.c   | 1 -
 drivers/infiniband/sw/rxe/rxe_verbs.c | 3 ---
 drivers/infiniband/sw/rxe/rxe_verbs.h | 3 ---
 4 files changed, 9 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
index 0d6a3d363554..5731bc15991c 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -309,8 +309,6 @@ static int rxe_qp_init_resp(struct rxe_dev *rxe, struct rxe_qp *qp,
 	spin_lock_init(&qp->rq.producer_lock);
 	spin_lock_init(&qp->rq.consumer_lock);
 
-	qp->rq.is_user = qp->is_user;
-
 	skb_queue_head_init(&qp->resp_pkts);
 
 	rxe_init_task(rxe, &qp->resp.task, qp,
diff --git a/drivers/infiniband/sw/rxe/rxe_srq.c b/drivers/infiniband/sw/rxe/rxe_srq.c
index a9e7817e2732..eb1c4c3b3a78 100644
--- a/drivers/infiniband/sw/rxe/rxe_srq.c
+++ b/drivers/infiniband/sw/rxe/rxe_srq.c
@@ -86,7 +86,6 @@ int rxe_srq_from_init(struct rxe_dev *rxe, struct rxe_srq *srq,
 	srq->srq_num		= srq->pelem.index;
 	srq->rq.max_wr		= init->attr.max_wr;
 	srq->rq.max_sge		= init->attr.max_sge;
-	srq->rq.is_user		= srq->is_user;
 
 	srq_wqe_size		= rcv_wqe_size(srq->rq.max_sge);
 
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index 46eaa1c5d4b3..e40927cf5772 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -270,9 +270,6 @@ static int rxe_create_srq(struct ib_srq *ibsrq, struct ib_srq_init_attr *init,
 		if (udata->outlen < sizeof(*uresp))
 			return -EINVAL;
 		uresp = udata->outbuf;
-		srq->is_user = true;
-	} else {
-		srq->is_user = false;
 	}
 
 	err = rxe_srq_chk_attr(rxe, NULL, &init->attr, IB_SRQ_INIT_MASK);
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.h b/drivers/infiniband/sw/rxe/rxe_verbs.h
index d90b1d77de34..c852a9907bad 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.h
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.h
@@ -77,7 +77,6 @@ enum wqe_state {
 };
 
 struct rxe_sq {
-	bool			is_user;
 	int			max_wr;
 	int			max_sge;
 	int			max_inline;
@@ -86,7 +85,6 @@ struct rxe_sq {
 };
 
 struct rxe_rq {
-	bool			is_user;
 	int			max_wr;
 	int			max_sge;
 	spinlock_t		producer_lock; /* guard queue producer */
@@ -100,7 +98,6 @@ struct rxe_srq {
 	struct rxe_pd		*pd;
 	struct rxe_rq		rq;
 	u32			srq_num;
-	bool			is_user;
 
 	int			limit;
 	int			error;
-- 
2.35.1



