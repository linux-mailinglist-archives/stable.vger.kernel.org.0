Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C36DB3289AD
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239129AbhCASDK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:03:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:49700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238881AbhCAR4Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:56:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B24A9651BB;
        Mon,  1 Mar 2021 17:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618976;
        bh=HssBzU3IbWvUrlztyklOVtQaz83U78MCFo49Y59TRvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QhV38tjgYxB9VbY15Es5HZ/E1R9zQyHF92yPsbLfRszQ2kgWJWTzDDy0U0ah/o+ED
         qEUSUPlme2LA1c7dPuBaHrK79sHcXAmBM1/51HUjhAG3GPc5zcU5FXDnPzYdZbt3zg
         ulZ6Su5WpM1uGongehtSlYIuX/4UoUGKqpBvfd6Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@cloud.ionos.com>,
        Md Haris Iqbal <haris.iqbal@cloud.ionos.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 286/663] RDMA/rtrs: Extend ibtrs_cq_qp_create
Date:   Mon,  1 Mar 2021 17:08:54 +0100
Message-Id: <20210301161155.978182357@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Wang <jinpu.wang@cloud.ionos.com>

[ Upstream commit 7490fd1fe836ba3c7eda7a4b1cfd9e44389ffda5 ]

rtrs does not have same limit for both max_send_wr and max_recv_wr,
To allow client and server set different values, export in a separate
parameter for rtrs_cq_qp_create.

Also fix the type accordingly, u32 should be used instead of u16.

Fixes: c0894b3ea69d ("RDMA/rtrs: core: lib functions shared between client and server modules")
Link: https://lore.kernel.org/r/20201217141915.56989-2-jinpu.wang@cloud.ionos.com
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Reviewed-by: Md Haris Iqbal <haris.iqbal@cloud.ionos.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c |  4 ++--
 drivers/infiniband/ulp/rtrs/rtrs-pri.h |  5 +++--
 drivers/infiniband/ulp/rtrs/rtrs-srv.c |  5 +++--
 drivers/infiniband/ulp/rtrs/rtrs.c     | 14 ++++++++------
 4 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index d54a77ebe1184..141cc70b8353f 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -1516,7 +1516,7 @@ static void destroy_con(struct rtrs_clt_con *con)
 static int create_con_cq_qp(struct rtrs_clt_con *con)
 {
 	struct rtrs_clt_sess *sess = to_clt_sess(con->c.sess);
-	u16 wr_queue_size;
+	u32 wr_queue_size;
 	int err, cq_vector;
 	struct rtrs_msg_rkey_rsp *rsp;
 
@@ -1586,7 +1586,7 @@ static int create_con_cq_qp(struct rtrs_clt_con *con)
 	cq_vector = con->cpu % sess->s.dev->ib_dev->num_comp_vectors;
 	err = rtrs_cq_qp_create(&sess->s, &con->c, sess->max_send_sge,
 				 cq_vector, wr_queue_size, wr_queue_size,
-				 IB_POLL_SOFTIRQ);
+				 wr_queue_size, IB_POLL_SOFTIRQ);
 	/*
 	 * In case of error we do not bother to clean previous allocations,
 	 * since destroy_con_cq_qp() must be called.
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-pri.h b/drivers/infiniband/ulp/rtrs/rtrs-pri.h
index b8e43dc4d95ab..32de7ad4a0764 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-pri.h
+++ b/drivers/infiniband/ulp/rtrs/rtrs-pri.h
@@ -304,8 +304,9 @@ int rtrs_post_rdma_write_imm_empty(struct rtrs_con *con, struct ib_cqe *cqe,
 				   struct ib_send_wr *head);
 
 int rtrs_cq_qp_create(struct rtrs_sess *rtrs_sess, struct rtrs_con *con,
-		      u32 max_send_sge, int cq_vector, u16 cq_size,
-		      u16 wr_queue_size, enum ib_poll_context poll_ctx);
+		      u32 max_send_sge, int cq_vector, int cq_size,
+		      u32 max_send_wr, u32 max_recv_wr,
+		      enum ib_poll_context poll_ctx);
 void rtrs_cq_qp_destroy(struct rtrs_con *con);
 
 void rtrs_init_hb(struct rtrs_sess *sess, struct ib_cqe *cqe,
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.c b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
index 1cb778aff3c59..ffc6fbb4baa5e 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -1601,7 +1601,7 @@ static int create_con(struct rtrs_srv_sess *sess,
 	struct rtrs_sess *s = &sess->s;
 	struct rtrs_srv_con *con;
 
-	u16 cq_size, wr_queue_size;
+	u32 cq_size, wr_queue_size;
 	int err, cq_vector;
 
 	con = kzalloc(sizeof(*con), GFP_KERNEL);
@@ -1645,7 +1645,8 @@ static int create_con(struct rtrs_srv_sess *sess,
 
 	/* TODO: SOFTIRQ can be faster, but be careful with softirq context */
 	err = rtrs_cq_qp_create(&sess->s, &con->c, 1, cq_vector, cq_size,
-				 wr_queue_size, IB_POLL_WORKQUEUE);
+				 wr_queue_size, wr_queue_size,
+				 IB_POLL_WORKQUEUE);
 	if (err) {
 		rtrs_err(s, "rtrs_cq_qp_create(), err: %d\n", err);
 		goto free_con;
diff --git a/drivers/infiniband/ulp/rtrs/rtrs.c b/drivers/infiniband/ulp/rtrs/rtrs.c
index ff1093d6e4bc9..23e5452e10c46 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs.c
@@ -246,14 +246,14 @@ static int create_cq(struct rtrs_con *con, int cq_vector, u16 cq_size,
 }
 
 static int create_qp(struct rtrs_con *con, struct ib_pd *pd,
-		     u16 wr_queue_size, u32 max_sge)
+		     u32 max_send_wr, u32 max_recv_wr, u32 max_sge)
 {
 	struct ib_qp_init_attr init_attr = {NULL};
 	struct rdma_cm_id *cm_id = con->cm_id;
 	int ret;
 
-	init_attr.cap.max_send_wr = wr_queue_size;
-	init_attr.cap.max_recv_wr = wr_queue_size;
+	init_attr.cap.max_send_wr = max_send_wr;
+	init_attr.cap.max_recv_wr = max_recv_wr;
 	init_attr.cap.max_recv_sge = 1;
 	init_attr.event_handler = qp_event_handler;
 	init_attr.qp_context = con;
@@ -275,8 +275,9 @@ static int create_qp(struct rtrs_con *con, struct ib_pd *pd,
 }
 
 int rtrs_cq_qp_create(struct rtrs_sess *sess, struct rtrs_con *con,
-		       u32 max_send_sge, int cq_vector, u16 cq_size,
-		       u16 wr_queue_size, enum ib_poll_context poll_ctx)
+		       u32 max_send_sge, int cq_vector, int cq_size,
+		       u32 max_send_wr, u32 max_recv_wr,
+		       enum ib_poll_context poll_ctx)
 {
 	int err;
 
@@ -284,7 +285,8 @@ int rtrs_cq_qp_create(struct rtrs_sess *sess, struct rtrs_con *con,
 	if (err)
 		return err;
 
-	err = create_qp(con, sess->dev->ib_pd, wr_queue_size, max_send_sge);
+	err = create_qp(con, sess->dev->ib_pd, max_send_wr, max_recv_wr,
+			max_send_sge);
 	if (err) {
 		ib_free_cq(con->cq);
 		con->cq = NULL;
-- 
2.27.0



