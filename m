Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7939840E586
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344622AbhIPRMM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:12:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:36054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243475AbhIPRKC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:10:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFFBA61206;
        Thu, 16 Sep 2021 16:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810252;
        bh=WXZRCbe7f1m3JIgFc3j4lOWqgP5sUSAyB7Wh3Xz7Tsc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=itVyycvfwT4bgxC6taanlw4vcJems5txSYnLktoAQOGFcbpdMwSbEPWNfTreUOb7S
         BwzXch/mciHCEI5W9eWpUES8bmOFtUBO91LDtJI4yPjAtPyoiEGG989E8HOBV/uIA/
         zEGQJ0gn5PFAuH9x6dygbi6jRKDFWtPEnw0BPo0M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@ionos.com>,
        Aleksei Marov <aleksei.marov@ionos.com>,
        Gioh Kim <gi-oh.kim@ionos.com>,
        Md Haris Iqbal <haris.iqbal@ionos.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 073/432] RDMA/rtrs: move wr_cnt from rtrs_srv_con to rtrs_con
Date:   Thu, 16 Sep 2021 17:57:02 +0200
Message-Id: <20210916155813.262533044@linuxfoundation.org>
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

[ Upstream commit a10431eff136ef15e1f9955efe369744b1294db1 ]

We need to track also the wr used for heatbeat. This is a preparation for
that, will be used in later patch.

The io_cnt in rtrs_clt is removed, use wr_cnt instead.

Link: https://lore.kernel.org/r/20210712060750.16494-3-jinpu.wang@ionos.com
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Reviewed-by: Aleksei Marov <aleksei.marov@ionos.com>
Reviewed-by: Gioh Kim <gi-oh.kim@ionos.com>
Reviewed-by: Md Haris Iqbal <haris.iqbal@ionos.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c | 7 ++++---
 drivers/infiniband/ulp/rtrs/rtrs-clt.h | 1 -
 drivers/infiniband/ulp/rtrs/rtrs-pri.h | 1 +
 drivers/infiniband/ulp/rtrs/rtrs-srv.c | 6 +++---
 drivers/infiniband/ulp/rtrs/rtrs-srv.h | 1 -
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index f2c40e50f25e..5cb00ea08919 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -478,7 +478,7 @@ static int rtrs_post_send_rdma(struct rtrs_clt_con *con,
 	 * From time to time we have to post signalled sends,
 	 * or send queue will fill up and only QP reset can help.
 	 */
-	flags = atomic_inc_return(&con->io_cnt) % sess->queue_depth ?
+	flags = atomic_inc_return(&con->c.wr_cnt) % sess->queue_depth ?
 			0 : IB_SEND_SIGNALED;
 
 	ib_dma_sync_single_for_device(sess->s.dev->ib_dev, req->iu->dma_addr,
@@ -1043,7 +1043,7 @@ static int rtrs_post_rdma_write_sg(struct rtrs_clt_con *con,
 	 * From time to time we have to post signalled sends,
 	 * or send queue will fill up and only QP reset can help.
 	 */
-	flags = atomic_inc_return(&con->io_cnt) % sess->queue_depth ?
+	flags = atomic_inc_return(&con->c.wr_cnt) % sess->queue_depth ?
 			0 : IB_SEND_SIGNALED;
 
 	ib_dma_sync_single_for_device(sess->s.dev->ib_dev, req->iu->dma_addr,
@@ -1601,7 +1601,8 @@ static int create_con(struct rtrs_clt_sess *sess, unsigned int cid)
 	con->cpu  = (cid ? cid - 1 : 0) % nr_cpu_ids;
 	con->c.cid = cid;
 	con->c.sess = &sess->s;
-	atomic_set(&con->io_cnt, 0);
+	/* Align with srv, init as 1 */
+	atomic_set(&con->c.wr_cnt, 1);
 	mutex_init(&con->con_mutex);
 
 	sess->s.con[cid] = &con->c;
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.h b/drivers/infiniband/ulp/rtrs/rtrs-clt.h
index e276a2dfcf7c..3c3ff094588c 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.h
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.h
@@ -74,7 +74,6 @@ struct rtrs_clt_con {
 	u32			queue_num;
 	unsigned int		cpu;
 	struct mutex		con_mutex;
-	atomic_t		io_cnt;
 	int			cm_err;
 };
 
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-pri.h b/drivers/infiniband/ulp/rtrs/rtrs-pri.h
index 36f184a3b676..a44a4fb1b515 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-pri.h
+++ b/drivers/infiniband/ulp/rtrs/rtrs-pri.h
@@ -96,6 +96,7 @@ struct rtrs_con {
 	struct rdma_cm_id	*cm_id;
 	unsigned int		cid;
 	int                     nr_cqe;
+	atomic_t		wr_cnt;
 };
 
 struct rtrs_sess {
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.c b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
index 3df290086169..31b846ca0c5e 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -269,7 +269,7 @@ static int rdma_write_sg(struct rtrs_srv_op *id)
 	 * From time to time we have to post signaled sends,
 	 * or send queue will fill up and only QP reset can help.
 	 */
-	flags = (atomic_inc_return(&id->con->wr_cnt) % srv->queue_depth) ?
+	flags = (atomic_inc_return(&id->con->c.wr_cnt) % srv->queue_depth) ?
 		0 : IB_SEND_SIGNALED;
 
 	if (need_inval) {
@@ -396,7 +396,7 @@ static int send_io_resp_imm(struct rtrs_srv_con *con, struct rtrs_srv_op *id,
 	 * From time to time we have to post signalled sends,
 	 * or send queue will fill up and only QP reset can help.
 	 */
-	flags = (atomic_inc_return(&con->wr_cnt) % srv->queue_depth) ?
+	flags = (atomic_inc_return(&con->c.wr_cnt) % srv->queue_depth) ?
 		0 : IB_SEND_SIGNALED;
 	imm = rtrs_to_io_rsp_imm(id->msg_id, errno, need_inval);
 	imm_wr.wr.next = NULL;
@@ -1648,7 +1648,7 @@ static int create_con(struct rtrs_srv_sess *sess,
 	con->c.cm_id = cm_id;
 	con->c.sess = &sess->s;
 	con->c.cid = cid;
-	atomic_set(&con->wr_cnt, 1);
+	atomic_set(&con->c.wr_cnt, 1);
 	wr_limit = sess->s.dev->ib_dev->attrs.max_qp_wr;
 
 	if (con->c.cid == 0) {
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.h b/drivers/infiniband/ulp/rtrs/rtrs-srv.h
index f8da2e3f0bda..6785c3b6363e 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.h
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.h
@@ -42,7 +42,6 @@ struct rtrs_srv_stats {
 
 struct rtrs_srv_con {
 	struct rtrs_con		c;
-	atomic_t		wr_cnt;
 	atomic_t		sq_wr_avail;
 	struct list_head	rsp_wr_wait_list;
 	spinlock_t		rsp_wr_wait_lock;
-- 
2.30.2



