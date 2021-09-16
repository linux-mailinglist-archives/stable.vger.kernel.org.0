Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3B4B40E584
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243501AbhIPRML (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:12:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:36120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244366AbhIPRKC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:10:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFBBF619BB;
        Thu, 16 Sep 2021 16:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810255;
        bh=eC2rf59Zmojs55nhjXME9XIek1WxD/EcBCAsFnPHhKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lCz1UDmn7Jq0K8PFcd5rnFmbG4criJ0zRajeGWQnTGuaZoWHHrUIVYXTc0PJtw3dD
         1g5aqOwiWGSj3BZtBynht84xXk7M4X5qwvztYSCcIZU3W5pqV5sgWFt7dF9SEeknWc
         ZPZrp2onMyBZNIWvZWcpMf5wJfBQfFdmQ6lw7tCk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@ionos.com>,
        Aleksei Marov <aleksei.marov@ionos.com>,
        Gioh Kim <gi-oh.kim@ionos.com>,
        Md Haris Iqbal <haris.iqbal@ionos.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 074/432] RDMA/rtrs: Enable the same selective signal for heartbeat and IO
Date:   Thu, 16 Sep 2021 17:57:03 +0200
Message-Id: <20210916155813.292698249@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Wang <jinpu.wang@ionos.com>

[ Upstream commit e2d98504c697f9c8e45b815062f8893b10808d8e ]

On idle session, because we do not do signal for heartbeat, it will
overflow the send queue after sometime.

To avoid that, we need to enable the signal for heartbeat. To do that, add
a new member signal_interval in rtrs_path, which will set min of
queue_depth and SERVICE_CON_QUEUE_DEPTH, and track it for both heartbeat
and IO, so the sq queue full accounting is correct.

Fixes: b38041d50add ("RDMA/rtrs: Do not signal for heatbeat")
Link: https://lore.kernel.org/r/20210712060750.16494-4-jinpu.wang@ionos.com
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Reviewed-by: Aleksei Marov <aleksei.marov@ionos.com>
Reviewed-by: Gioh Kim <gi-oh.kim@ionos.com>
Reviewed-by: Md Haris Iqbal <haris.iqbal@ionos.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c |  7 +++++--
 drivers/infiniband/ulp/rtrs/rtrs-pri.h |  1 +
 drivers/infiniband/ulp/rtrs/rtrs-srv.c | 11 ++++++-----
 drivers/infiniband/ulp/rtrs/rtrs.c     |  7 ++++++-
 4 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index 5cb00ea08919..f023676e05e4 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -478,7 +478,7 @@ static int rtrs_post_send_rdma(struct rtrs_clt_con *con,
 	 * From time to time we have to post signalled sends,
 	 * or send queue will fill up and only QP reset can help.
 	 */
-	flags = atomic_inc_return(&con->c.wr_cnt) % sess->queue_depth ?
+	flags = atomic_inc_return(&con->c.wr_cnt) % sess->s.signal_interval ?
 			0 : IB_SEND_SIGNALED;
 
 	ib_dma_sync_single_for_device(sess->s.dev->ib_dev, req->iu->dma_addr,
@@ -680,6 +680,7 @@ static void rtrs_clt_rdma_done(struct ib_cq *cq, struct ib_wc *wc)
 	case IB_WC_RDMA_WRITE:
 		/*
 		 * post_send() RDMA write completions of IO reqs (read/write)
+		 * and hb.
 		 */
 		break;
 
@@ -1043,7 +1044,7 @@ static int rtrs_post_rdma_write_sg(struct rtrs_clt_con *con,
 	 * From time to time we have to post signalled sends,
 	 * or send queue will fill up and only QP reset can help.
 	 */
-	flags = atomic_inc_return(&con->c.wr_cnt) % sess->queue_depth ?
+	flags = atomic_inc_return(&con->c.wr_cnt) % sess->s.signal_interval ?
 			0 : IB_SEND_SIGNALED;
 
 	ib_dma_sync_single_for_device(sess->s.dev->ib_dev, req->iu->dma_addr,
@@ -1849,6 +1850,8 @@ static int rtrs_rdma_conn_established(struct rtrs_clt_con *con,
 				return -ENOMEM;
 		}
 		sess->queue_depth = queue_depth;
+		sess->s.signal_interval = min_not_zero(queue_depth,
+						(unsigned short) SERVICE_CON_QUEUE_DEPTH);
 		sess->max_hdr_size = le32_to_cpu(msg->max_hdr_size);
 		sess->max_io_size = le32_to_cpu(msg->max_io_size);
 		sess->flags = le32_to_cpu(msg->flags);
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-pri.h b/drivers/infiniband/ulp/rtrs/rtrs-pri.h
index a44a4fb1b515..b88a4944cb30 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-pri.h
+++ b/drivers/infiniband/ulp/rtrs/rtrs-pri.h
@@ -109,6 +109,7 @@ struct rtrs_sess {
 	unsigned int		con_num;
 	unsigned int		irq_con_num;
 	unsigned int		recon_cnt;
+	unsigned int		signal_interval;
 	struct rtrs_ib_dev	*dev;
 	int			dev_ref;
 	struct ib_cqe		*hb_cqe;
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.c b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
index 31b846ca0c5e..44ed15f38896 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -201,7 +201,6 @@ static int rdma_write_sg(struct rtrs_srv_op *id)
 	struct rtrs_srv_sess *sess = to_srv_sess(s);
 	dma_addr_t dma_addr = sess->dma_addr[id->msg_id];
 	struct rtrs_srv_mr *srv_mr;
-	struct rtrs_srv *srv = sess->srv;
 	struct ib_send_wr inv_wr;
 	struct ib_rdma_wr imm_wr;
 	struct ib_rdma_wr *wr = NULL;
@@ -269,7 +268,7 @@ static int rdma_write_sg(struct rtrs_srv_op *id)
 	 * From time to time we have to post signaled sends,
 	 * or send queue will fill up and only QP reset can help.
 	 */
-	flags = (atomic_inc_return(&id->con->c.wr_cnt) % srv->queue_depth) ?
+	flags = (atomic_inc_return(&id->con->c.wr_cnt) % s->signal_interval) ?
 		0 : IB_SEND_SIGNALED;
 
 	if (need_inval) {
@@ -347,7 +346,6 @@ static int send_io_resp_imm(struct rtrs_srv_con *con, struct rtrs_srv_op *id,
 	struct ib_send_wr inv_wr, *wr = NULL;
 	struct ib_rdma_wr imm_wr;
 	struct ib_reg_wr rwr;
-	struct rtrs_srv *srv = sess->srv;
 	struct rtrs_srv_mr *srv_mr;
 	bool need_inval = false;
 	enum ib_send_flags flags;
@@ -396,7 +394,7 @@ static int send_io_resp_imm(struct rtrs_srv_con *con, struct rtrs_srv_op *id,
 	 * From time to time we have to post signalled sends,
 	 * or send queue will fill up and only QP reset can help.
 	 */
-	flags = (atomic_inc_return(&con->c.wr_cnt) % srv->queue_depth) ?
+	flags = (atomic_inc_return(&con->c.wr_cnt) % s->signal_interval) ?
 		0 : IB_SEND_SIGNALED;
 	imm = rtrs_to_io_rsp_imm(id->msg_id, errno, need_inval);
 	imm_wr.wr.next = NULL;
@@ -1268,8 +1266,9 @@ static void rtrs_srv_rdma_done(struct ib_cq *cq, struct ib_wc *wc)
 	case IB_WC_SEND:
 		/*
 		 * post_send() RDMA write completions of IO reqs (read/write)
+		 * and hb.
 		 */
-		atomic_add(srv->queue_depth, &con->sq_wr_avail);
+		atomic_add(s->signal_interval, &con->sq_wr_avail);
 
 		if (unlikely(!list_empty_careful(&con->rsp_wr_wait_list)))
 			rtrs_rdma_process_wr_wait_list(con);
@@ -1659,6 +1658,8 @@ static int create_con(struct rtrs_srv_sess *sess,
 		max_send_wr = min_t(int, wr_limit,
 				    SERVICE_CON_QUEUE_DEPTH * 2 + 2);
 		max_recv_wr = max_send_wr;
+		s->signal_interval = min_not_zero(srv->queue_depth,
+						  (size_t)SERVICE_CON_QUEUE_DEPTH);
 	} else {
 		/* when always_invlaidate enalbed, we need linv+rinv+mr+imm */
 		if (always_invalidate)
diff --git a/drivers/infiniband/ulp/rtrs/rtrs.c b/drivers/infiniband/ulp/rtrs/rtrs.c
index 61919ebd92b2..a8f8affc546a 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs.c
@@ -187,10 +187,15 @@ int rtrs_post_rdma_write_imm_empty(struct rtrs_con *con, struct ib_cqe *cqe,
 				    struct ib_send_wr *head)
 {
 	struct ib_rdma_wr wr;
+	struct rtrs_sess *sess = con->sess;
+	enum ib_send_flags sflags;
+
+	sflags = (atomic_inc_return(&con->wr_cnt) % sess->signal_interval) ?
+		0 : IB_SEND_SIGNALED;
 
 	wr = (struct ib_rdma_wr) {
 		.wr.wr_cqe	= cqe,
-		.wr.send_flags	= flags,
+		.wr.send_flags	= sflags,
 		.wr.opcode	= IB_WR_RDMA_WRITE_WITH_IMM,
 		.wr.ex.imm_data	= cpu_to_be32(imm_data),
 	};
-- 
2.30.2



