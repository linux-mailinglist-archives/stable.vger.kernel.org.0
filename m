Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06285328D17
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241044AbhCATF3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:05:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:34118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238131AbhCAS7A (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:59:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33C2964F70;
        Mon,  1 Mar 2021 17:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621031;
        bh=IBFhEGq0EohZL7u6t4zYYr4AUwiudrDjRvCGg72QCZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NGUkO+e3osG9wDU0oZ7duNKVXxc4Bfmf3Op9BIiGrUdvwkJxxVB57U2lD5zTYhFZa
         VOlUxcqz2flgYvL8HN3DxSyjD2yPM+RIZZDXLABY5VN7mpQrRf5PvWxphlKHQTuk9L
         fwStOQ/DDBeIB+F3jxgZtNsxYVtw0MhF+PD3pZBw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@cloud.ionos.com>,
        Md Haris Iqbal <haris.iqbal@cloud.ionos.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 338/775] RDMA/rtrs: Extend ibtrs_cq_qp_create
Date:   Mon,  1 Mar 2021 17:08:26 +0100
Message-Id: <20210301161218.324709606@linuxfoundation.org>
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
index 67f86c405a265..719254fc83a1c 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -1511,7 +1511,7 @@ static void destroy_con(struct rtrs_clt_con *con)
 static int create_con_cq_qp(struct rtrs_clt_con *con)
 {
 	struct rtrs_clt_sess *sess = to_clt_sess(con->c.sess);
-	u16 wr_queue_size;
+	u32 wr_queue_size;
 	int err, cq_vector;
 	struct rtrs_msg_rkey_rsp *rsp;
 
@@ -1573,7 +1573,7 @@ static int create_con_cq_qp(struct rtrs_clt_con *con)
 	cq_vector = con->cpu % sess->s.dev->ib_dev->num_comp_vectors;
 	err = rtrs_cq_qp_create(&sess->s, &con->c, sess->max_send_sge,
 				 cq_vector, wr_queue_size, wr_queue_size,
-				 IB_POLL_SOFTIRQ);
+				 wr_queue_size, IB_POLL_SOFTIRQ);
 	/*
 	 * In case of error we do not bother to clean previous allocations,
 	 * since destroy_con_cq_qp() must be called.
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-pri.h b/drivers/infiniband/ulp/rtrs/rtrs-pri.h
index 3f2918671dbed..d5621e6fad1b1 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-pri.h
+++ b/drivers/infiniband/ulp/rtrs/rtrs-pri.h
@@ -303,8 +303,9 @@ int rtrs_post_rdma_write_imm_empty(struct rtrs_con *con, struct ib_cqe *cqe,
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
index c42fd470c4eb4..ed4628f032bb6 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -1586,7 +1586,7 @@ static int create_con(struct rtrs_srv_sess *sess,
 	struct rtrs_sess *s = &sess->s;
 	struct rtrs_srv_con *con;
 
-	u16 cq_size, wr_queue_size;
+	u32 cq_size, wr_queue_size;
 	int err, cq_vector;
 
 	con = kzalloc(sizeof(*con), GFP_KERNEL);
@@ -1630,7 +1630,8 @@ static int create_con(struct rtrs_srv_sess *sess,
 
 	/* TODO: SOFTIRQ can be faster, but be careful with softirq context */
 	err = rtrs_cq_qp_create(&sess->s, &con->c, 1, cq_vector, cq_size,
-				 wr_queue_size, IB_POLL_WORKQUEUE);
+				 wr_queue_size, wr_queue_size,
+				 IB_POLL_WORKQUEUE);
 	if (err) {
 		rtrs_err(s, "rtrs_cq_qp_create(), err: %d\n", err);
 		goto free_con;
diff --git a/drivers/infiniband/ulp/rtrs/rtrs.c b/drivers/infiniband/ulp/rtrs/rtrs.c
index 2e3a849e0a77c..df52427f17106 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs.c
@@ -231,14 +231,14 @@ static int create_cq(struct rtrs_con *con, int cq_vector, u16 cq_size,
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
@@ -260,8 +260,9 @@ static int create_qp(struct rtrs_con *con, struct ib_pd *pd,
 }
 
 int rtrs_cq_qp_create(struct rtrs_sess *sess, struct rtrs_con *con,
-		       u32 max_send_sge, int cq_vector, u16 cq_size,
-		       u16 wr_queue_size, enum ib_poll_context poll_ctx)
+		       u32 max_send_sge, int cq_vector, int cq_size,
+		       u32 max_send_wr, u32 max_recv_wr,
+		       enum ib_poll_context poll_ctx)
 {
 	int err;
 
@@ -269,7 +270,8 @@ int rtrs_cq_qp_create(struct rtrs_sess *sess, struct rtrs_con *con,
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



