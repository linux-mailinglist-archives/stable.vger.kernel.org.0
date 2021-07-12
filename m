Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D31C33C53C8
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348712AbhGLHz5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:55:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:37894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350702AbhGLHvN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 118166194F;
        Mon, 12 Jul 2021 07:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076062;
        bh=U2F2FPZ6+Qt+2IdVIgvPY5wBKgz4V1Wmu1GImP/l64A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bF0Ybsu9yXxE8HPwYlkRQMv4xmmo1ylWZE/DZYTeDIbMGAOT8YQ/Er9ukNQ9+LVXV
         fc5SebABzecNM+kefcCH8o4uWkCrjI5uoRfBTQo7j/Y1o/+U0TrQ5bKE39I4A3qE+m
         GNDGS8n7xuQnzEg6nJJ1UWvNpNchCJfFNNAUBih4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@cloud.ionos.com>,
        Md Haris Iqbal <haris.iqbal@cloud.ionos.com>,
        Gioh Kim <gi-oh.kim@ionos.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 483/800] RDMA/rtrs-srv: Set minimal max_send_wr and max_recv_wr
Date:   Mon, 12 Jul 2021 08:08:26 +0200
Message-Id: <20210712061018.580808894@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Wang <jinpu.wang@cloud.ionos.com>

[ Upstream commit 5e91eabf66c854f16ca2e954e5c68939bc81601e ]

Currently rtrs when create_qp use a coarse numbers (bigger in general),
which leads to hardware create more resources which only waste memory with
no benefits.

For max_send_wr, we don't really need alway max_qp_wr size when creating
qp, reduce it to cq_size.

For max_recv_wr,  cq_size is enough.

With the patch when sess_queue_depth=128, per session (2 paths) memory
consumption reduced from 188 MB to 65MB

When always_invalidate is enabled, we need send more wr, so treat it
special.

Fixes: 9cb837480424e ("RDMA/rtrs: server: main functionality")
Link: https://lore.kernel.org/r/20210614090337.29557-2-jinpu.wang@ionos.com
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Reviewed-by: Md Haris Iqbal <haris.iqbal@cloud.ionos.com>
Signed-off-by: Gioh Kim <gi-oh.kim@ionos.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-srv.c | 38 +++++++++++++++++---------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.c b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
index 62f59ccb327c..8a9099684b8e 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -1605,7 +1605,7 @@ static int create_con(struct rtrs_srv_sess *sess,
 	struct rtrs_sess *s = &sess->s;
 	struct rtrs_srv_con *con;
 
-	u32 cq_size, wr_queue_size;
+	u32 cq_size, max_send_wr, max_recv_wr, wr_limit;
 	int err, cq_vector;
 
 	con = kzalloc(sizeof(*con), GFP_KERNEL);
@@ -1626,30 +1626,42 @@ static int create_con(struct rtrs_srv_sess *sess,
 		 * All receive and all send (each requiring invalidate)
 		 * + 2 for drain and heartbeat
 		 */
-		wr_queue_size = SERVICE_CON_QUEUE_DEPTH * 3 + 2;
-		cq_size = wr_queue_size;
+		max_send_wr = SERVICE_CON_QUEUE_DEPTH * 2 + 2;
+		max_recv_wr = SERVICE_CON_QUEUE_DEPTH + 2;
+		cq_size = max_send_wr + max_recv_wr;
 	} else {
-		/*
-		 * If we have all receive requests posted and
-		 * all write requests posted and each read request
-		 * requires an invalidate request + drain
-		 * and qp gets into error state.
-		 */
-		cq_size = srv->queue_depth * 3 + 1;
 		/*
 		 * In theory we might have queue_depth * 32
 		 * outstanding requests if an unsafe global key is used
 		 * and we have queue_depth read requests each consisting
 		 * of 32 different addresses. div 3 for mlx5.
 		 */
-		wr_queue_size = sess->s.dev->ib_dev->attrs.max_qp_wr / 3;
+		wr_limit = sess->s.dev->ib_dev->attrs.max_qp_wr / 3;
+		/* when always_invlaidate enalbed, we need linv+rinv+mr+imm */
+		if (always_invalidate)
+			max_send_wr =
+				min_t(int, wr_limit,
+				      srv->queue_depth * (1 + 4) + 1);
+		else
+			max_send_wr =
+				min_t(int, wr_limit,
+				      srv->queue_depth * (1 + 2) + 1);
+
+		max_recv_wr = srv->queue_depth + 1;
+		/*
+		 * If we have all receive requests posted and
+		 * all write requests posted and each read request
+		 * requires an invalidate request + drain
+		 * and qp gets into error state.
+		 */
+		cq_size = max_send_wr + max_recv_wr;
 	}
-	atomic_set(&con->sq_wr_avail, wr_queue_size);
+	atomic_set(&con->sq_wr_avail, max_send_wr);
 	cq_vector = rtrs_srv_get_next_cq_vector(sess);
 
 	/* TODO: SOFTIRQ can be faster, but be careful with softirq context */
 	err = rtrs_cq_qp_create(&sess->s, &con->c, 1, cq_vector, cq_size,
-				 wr_queue_size, wr_queue_size,
+				 max_send_wr, max_recv_wr,
 				 IB_POLL_WORKQUEUE);
 	if (err) {
 		rtrs_err(s, "rtrs_cq_qp_create(), err: %d\n", err);
-- 
2.30.2



