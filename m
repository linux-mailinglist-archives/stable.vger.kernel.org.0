Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA2DA328D1C
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234786AbhCATFm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:05:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:34096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233279AbhCAS6y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:58:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3346664F1C;
        Mon,  1 Mar 2021 17:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620954;
        bh=1F7ck/3wjoa4dDJPfgOwWSGvKCymVpt0yOBc9uqESIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IsOreFzqrx5lk6rcbUB2Tcfk6u31I5KoBbC8hwDqgmuu1pmmTzh25JUdyNDS6Llyl
         +PNxha6irotXs85iqkfU9dsodPnWICpTdcAWvK33H6YJekVWW9fefQad3OOkKE57Og
         9kw3ZQHLFdscYoquRssnQlNQWlEtY84wI63DEyik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@cloud.ionos.com>,
        Md Haris Iqbal <haris.iqbal@cloud.ionos.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 341/775] RDMA/rtrs-clt: Set mininum limit when create QP
Date:   Mon,  1 Mar 2021 17:08:29 +0100
Message-Id: <20210301161218.469484983@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Wang <jinpu.wang@cloud.ionos.com>

[ Upstream commit f47e4e3e71724f625958b0059f6c8ac5d44d27ef ]

Currently rtrs when create_qp use a coarse numbers (bigger in general),
which leads to hardware create more resources which only waste memory
with no benefits.

- SERVICE con,
For max_send_wr/max_recv_wr, it's 2 times SERVICE_CON_QUEUE_DEPTH + 2

- IO con
For max_send_wr/max_recv_wr, it's sess->queue_depth * 3 + 1

Fixes: 6a98d71daea1 ("RDMA/rtrs: client: main functionality")
Link: https://lore.kernel.org/r/20201217141915.56989-6-jinpu.wang@cloud.ionos.com
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Reviewed-by: Md Haris Iqbal <haris.iqbal@cloud.ionos.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index 719254fc83a1c..b3fb5fb93815f 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -1511,7 +1511,7 @@ static void destroy_con(struct rtrs_clt_con *con)
 static int create_con_cq_qp(struct rtrs_clt_con *con)
 {
 	struct rtrs_clt_sess *sess = to_clt_sess(con->c.sess);
-	u32 wr_queue_size;
+	u32 max_send_wr, max_recv_wr, cq_size;
 	int err, cq_vector;
 	struct rtrs_msg_rkey_rsp *rsp;
 
@@ -1523,7 +1523,8 @@ static int create_con_cq_qp(struct rtrs_clt_con *con)
 		 * + 2 for drain and heartbeat
 		 * in case qp gets into error state
 		 */
-		wr_queue_size = SERVICE_CON_QUEUE_DEPTH * 3 + 2;
+		max_send_wr = SERVICE_CON_QUEUE_DEPTH * 2 + 2;
+		max_recv_wr = SERVICE_CON_QUEUE_DEPTH * 2 + 2;
 		/* We must be the first here */
 		if (WARN_ON(sess->s.dev))
 			return -EINVAL;
@@ -1555,25 +1556,29 @@ static int create_con_cq_qp(struct rtrs_clt_con *con)
 
 		/* Shared between connections */
 		sess->s.dev_ref++;
-		wr_queue_size =
+		max_send_wr =
 			min_t(int, sess->s.dev->ib_dev->attrs.max_qp_wr,
 			      /* QD * (REQ + RSP + FR REGS or INVS) + drain */
 			      sess->queue_depth * 3 + 1);
+		max_recv_wr =
+			min_t(int, sess->s.dev->ib_dev->attrs.max_qp_wr,
+			      sess->queue_depth * 3 + 1);
 	}
 	/* alloc iu to recv new rkey reply when server reports flags set */
 	if (sess->flags == RTRS_MSG_NEW_RKEY_F || con->c.cid == 0) {
-		con->rsp_ius = rtrs_iu_alloc(wr_queue_size, sizeof(*rsp),
+		con->rsp_ius = rtrs_iu_alloc(max_recv_wr, sizeof(*rsp),
 					      GFP_KERNEL, sess->s.dev->ib_dev,
 					      DMA_FROM_DEVICE,
 					      rtrs_clt_rdma_done);
 		if (!con->rsp_ius)
 			return -ENOMEM;
-		con->queue_size = wr_queue_size;
+		con->queue_size = max_recv_wr;
 	}
+	cq_size = max_send_wr + max_recv_wr;
 	cq_vector = con->cpu % sess->s.dev->ib_dev->num_comp_vectors;
 	err = rtrs_cq_qp_create(&sess->s, &con->c, sess->max_send_sge,
-				 cq_vector, wr_queue_size, wr_queue_size,
-				 wr_queue_size, IB_POLL_SOFTIRQ);
+				 cq_vector, cq_size, max_send_wr,
+				 max_recv_wr, IB_POLL_SOFTIRQ);
 	/*
 	 * In case of error we do not bother to clean previous allocations,
 	 * since destroy_con_cq_qp() must be called.
-- 
2.27.0



