Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6002B593933
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344141AbiHOTTe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345028AbiHOTSA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:18:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EC1A2B198;
        Mon, 15 Aug 2022 11:39:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55AE461185;
        Mon, 15 Aug 2022 18:39:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BD4BC433B5;
        Mon, 15 Aug 2022 18:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588761;
        bh=0enAtisZHnTgdJpmSOmGCffS0I8fopq9HDOkb+WOo6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wcG4N95JEYtlzxCM15KwfMqdOLv654zOv0IrhMtoXcpOFkpkzVPvDrfdRC+XJHzWy
         a6fCkzR1TZ77khhjLMrwX0M1Tv6z9RGe7imdxQB1znkSOEIsBz9UTchAq56zKuFtrZ
         iAql2DgEkbWYx8C/rxNETtCv+x6eUhZ2dlkLUAvM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vaishali Thakkar <vaishali.thakkar@ionos.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 507/779] RDMA/rtrs: Rename rtrs_sess to rtrs_path
Date:   Mon, 15 Aug 2022 20:02:31 +0200
Message-Id: <20220815180358.926443664@linuxfoundation.org>
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

From: Vaishali Thakkar <vaishali.thakkar@ionos.com>

[ Upstream commit d9372794717f44b6e746d8fbab66763b6d753e71 ]

rtrs_sess is in fact a path. This makes it confusing and difficult to get
into the code. So let's rename the structure and related use cases of it.

Coccinelle was used to do the transformation for most of the occurrences
and remaining ones were handled manually.

Link: https://lore.kernel.org/r/20220105180708.7774-2-jinpu.wang@ionos.com
Signed-off-by: Vaishali Thakkar <vaishali.thakkar@ionos.com>
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt-stats.c |  4 +-
 drivers/infiniband/ulp/rtrs/rtrs-clt.c       | 66 ++++++-------
 drivers/infiniband/ulp/rtrs/rtrs-clt.h       |  4 +-
 drivers/infiniband/ulp/rtrs/rtrs-pri.h       | 14 +--
 drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c |  6 +-
 drivers/infiniband/ulp/rtrs/rtrs-srv.c       | 46 ++++-----
 drivers/infiniband/ulp/rtrs/rtrs-srv.h       |  2 +-
 drivers/infiniband/ulp/rtrs/rtrs.c           | 98 ++++++++++----------
 8 files changed, 120 insertions(+), 120 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt-stats.c b/drivers/infiniband/ulp/rtrs/rtrs-clt-stats.c
index 5e780bdd763d..40b4d6dd4924 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt-stats.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt-stats.c
@@ -13,7 +13,7 @@
 
 void rtrs_clt_update_wc_stats(struct rtrs_clt_con *con)
 {
-	struct rtrs_clt_sess *sess = to_clt_sess(con->c.sess);
+	struct rtrs_clt_sess *sess = to_clt_sess(con->c.path);
 	struct rtrs_clt_stats *stats = sess->stats;
 	struct rtrs_clt_stats_pcpu *s;
 	int cpu;
@@ -174,7 +174,7 @@ static inline void rtrs_clt_update_rdma_stats(struct rtrs_clt_stats *stats,
 void rtrs_clt_update_all_stats(struct rtrs_clt_io_req *req, int dir)
 {
 	struct rtrs_clt_con *con = req->con;
-	struct rtrs_clt_sess *sess = to_clt_sess(con->c.sess);
+	struct rtrs_clt_sess *sess = to_clt_sess(con->c.path);
 	struct rtrs_clt_stats *stats = sess->stats;
 	unsigned int len;
 
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index be96701cf281..5e73127f2adc 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -298,7 +298,7 @@ static bool rtrs_clt_change_state_from_to(struct rtrs_clt_sess *sess,
 
 static void rtrs_rdma_error_recovery(struct rtrs_clt_con *con)
 {
-	struct rtrs_clt_sess *sess = to_clt_sess(con->c.sess);
+	struct rtrs_clt_sess *sess = to_clt_sess(con->c.path);
 
 	if (rtrs_clt_change_state_from_to(sess,
 					   RTRS_CLT_CONNECTED,
@@ -330,7 +330,7 @@ static void rtrs_clt_fast_reg_done(struct ib_cq *cq, struct ib_wc *wc)
 	struct rtrs_clt_con *con = to_clt_con(wc->qp->qp_context);
 
 	if (wc->status != IB_WC_SUCCESS) {
-		rtrs_err(con->c.sess, "Failed IB_WR_REG_MR: %s\n",
+		rtrs_err(con->c.path, "Failed IB_WR_REG_MR: %s\n",
 			  ib_wc_status_msg(wc->status));
 		rtrs_rdma_error_recovery(con);
 	}
@@ -350,7 +350,7 @@ static void rtrs_clt_inv_rkey_done(struct ib_cq *cq, struct ib_wc *wc)
 	struct rtrs_clt_con *con = to_clt_con(wc->qp->qp_context);
 
 	if (wc->status != IB_WC_SUCCESS) {
-		rtrs_err(con->c.sess, "Failed IB_WR_LOCAL_INV: %s\n",
+		rtrs_err(con->c.path, "Failed IB_WR_LOCAL_INV: %s\n",
 			  ib_wc_status_msg(wc->status));
 		rtrs_rdma_error_recovery(con);
 	}
@@ -387,7 +387,7 @@ static void complete_rdma_req(struct rtrs_clt_io_req *req, int errno,
 		return;
 	if (WARN_ON(!req->con))
 		return;
-	sess = to_clt_sess(con->c.sess);
+	sess = to_clt_sess(con->c.path);
 
 	if (req->sg_cnt) {
 		if (req->dir == DMA_FROM_DEVICE && req->need_inv) {
@@ -417,7 +417,7 @@ static void complete_rdma_req(struct rtrs_clt_io_req *req, int errno,
 			refcount_inc(&req->ref);
 			err = rtrs_inv_rkey(req);
 			if (err) {
-				rtrs_err(con->c.sess, "Send INV WR key=%#x: %d\n",
+				rtrs_err(con->c.path, "Send INV WR key=%#x: %d\n",
 					  req->mr->rkey, err);
 			} else if (can_wait) {
 				wait_for_completion(&req->inv_comp);
@@ -445,7 +445,7 @@ static void complete_rdma_req(struct rtrs_clt_io_req *req, int errno,
 	req->con = NULL;
 
 	if (errno) {
-		rtrs_err_rl(con->c.sess, "IO request failed: error=%d path=%s [%s:%u] notify=%d\n",
+		rtrs_err_rl(con->c.path, "IO request failed: error=%d path=%s [%s:%u] notify=%d\n",
 			    errno, kobject_name(&sess->kobj), sess->hca_name,
 			    sess->hca_port, notify);
 	}
@@ -459,12 +459,12 @@ static int rtrs_post_send_rdma(struct rtrs_clt_con *con,
 				struct rtrs_rbuf *rbuf, u32 off,
 				u32 imm, struct ib_send_wr *wr)
 {
-	struct rtrs_clt_sess *sess = to_clt_sess(con->c.sess);
+	struct rtrs_clt_sess *sess = to_clt_sess(con->c.path);
 	enum ib_send_flags flags;
 	struct ib_sge sge;
 
 	if (!req->sg_size) {
-		rtrs_wrn(con->c.sess,
+		rtrs_wrn(con->c.path,
 			 "Doing RDMA Write failed, no data supplied\n");
 		return -EINVAL;
 	}
@@ -507,21 +507,21 @@ static void rtrs_clt_recv_done(struct rtrs_clt_con *con, struct ib_wc *wc)
 {
 	struct rtrs_iu *iu;
 	int err;
-	struct rtrs_clt_sess *sess = to_clt_sess(con->c.sess);
+	struct rtrs_clt_sess *sess = to_clt_sess(con->c.path);
 
 	WARN_ON((sess->flags & RTRS_MSG_NEW_RKEY_F) == 0);
 	iu = container_of(wc->wr_cqe, struct rtrs_iu,
 			  cqe);
 	err = rtrs_iu_post_recv(&con->c, iu);
 	if (err) {
-		rtrs_err(con->c.sess, "post iu failed %d\n", err);
+		rtrs_err(con->c.path, "post iu failed %d\n", err);
 		rtrs_rdma_error_recovery(con);
 	}
 }
 
 static void rtrs_clt_rkey_rsp_done(struct rtrs_clt_con *con, struct ib_wc *wc)
 {
-	struct rtrs_clt_sess *sess = to_clt_sess(con->c.sess);
+	struct rtrs_clt_sess *sess = to_clt_sess(con->c.path);
 	struct rtrs_msg_rkey_rsp *msg;
 	u32 imm_type, imm_payload;
 	bool w_inval = false;
@@ -534,7 +534,7 @@ static void rtrs_clt_rkey_rsp_done(struct rtrs_clt_con *con, struct ib_wc *wc)
 	iu = container_of(wc->wr_cqe, struct rtrs_iu, cqe);
 
 	if (wc->byte_len < sizeof(*msg)) {
-		rtrs_err(con->c.sess, "rkey response is malformed: size %d\n",
+		rtrs_err(con->c.path, "rkey response is malformed: size %d\n",
 			  wc->byte_len);
 		goto out;
 	}
@@ -600,7 +600,7 @@ static int rtrs_post_recv_empty_x2(struct rtrs_con *con, struct ib_cqe *cqe)
 static void rtrs_clt_rdma_done(struct ib_cq *cq, struct ib_wc *wc)
 {
 	struct rtrs_clt_con *con = to_clt_con(wc->qp->qp_context);
-	struct rtrs_clt_sess *sess = to_clt_sess(con->c.sess);
+	struct rtrs_clt_sess *sess = to_clt_sess(con->c.path);
 	u32 imm_type, imm_payload;
 	bool w_inval = false;
 	int err;
@@ -646,7 +646,7 @@ static void rtrs_clt_rdma_done(struct ib_cq *cq, struct ib_wc *wc)
 			if (sess->flags & RTRS_MSG_NEW_RKEY_F)
 				return  rtrs_clt_recv_done(con, wc);
 		} else {
-			rtrs_wrn(con->c.sess, "Unknown IMM type %u\n",
+			rtrs_wrn(con->c.path, "Unknown IMM type %u\n",
 				  imm_type);
 		}
 		if (w_inval)
@@ -658,7 +658,7 @@ static void rtrs_clt_rdma_done(struct ib_cq *cq, struct ib_wc *wc)
 		else
 			err = rtrs_post_recv_empty(&con->c, &io_comp_cqe);
 		if (err) {
-			rtrs_err(con->c.sess, "rtrs_post_recv_empty(): %d\n",
+			rtrs_err(con->c.path, "rtrs_post_recv_empty(): %d\n",
 				  err);
 			rtrs_rdma_error_recovery(con);
 		}
@@ -693,7 +693,7 @@ static void rtrs_clt_rdma_done(struct ib_cq *cq, struct ib_wc *wc)
 static int post_recv_io(struct rtrs_clt_con *con, size_t q_size)
 {
 	int err, i;
-	struct rtrs_clt_sess *sess = to_clt_sess(con->c.sess);
+	struct rtrs_clt_sess *sess = to_clt_sess(con->c.path);
 
 	for (i = 0; i < q_size; i++) {
 		if (sess->flags & RTRS_MSG_NEW_RKEY_F) {
@@ -1013,7 +1013,7 @@ static int rtrs_post_rdma_write_sg(struct rtrs_clt_con *con,
 				   u32 size, u32 imm, struct ib_send_wr *wr,
 				   struct ib_send_wr *tail)
 {
-	struct rtrs_clt_sess *sess = to_clt_sess(con->c.sess);
+	struct rtrs_clt_sess *sess = to_clt_sess(con->c.path);
 	struct ib_sge *sge = req->sge;
 	enum ib_send_flags flags;
 	struct scatterlist *sg;
@@ -1074,7 +1074,7 @@ static int rtrs_map_sg_fr(struct rtrs_clt_io_req *req, size_t count)
 static int rtrs_clt_write_req(struct rtrs_clt_io_req *req)
 {
 	struct rtrs_clt_con *con = req->con;
-	struct rtrs_sess *s = con->c.sess;
+	struct rtrs_path *s = con->c.path;
 	struct rtrs_clt_sess *sess = to_clt_sess(s);
 	struct rtrs_msg_rdma_write *msg;
 
@@ -1168,7 +1168,7 @@ static int rtrs_clt_write_req(struct rtrs_clt_io_req *req)
 static int rtrs_clt_read_req(struct rtrs_clt_io_req *req)
 {
 	struct rtrs_clt_con *con = req->con;
-	struct rtrs_sess *s = con->c.sess;
+	struct rtrs_path *s = con->c.path;
 	struct rtrs_clt_sess *sess = to_clt_sess(s);
 	struct rtrs_msg_rdma_read *msg;
 	struct rtrs_ib_dev *dev = sess->s.dev;
@@ -1601,7 +1601,7 @@ static int create_con(struct rtrs_clt_sess *sess, unsigned int cid)
 	/* Map first two connections to the first CPU */
 	con->cpu  = (cid ? cid - 1 : 0) % nr_cpu_ids;
 	con->c.cid = cid;
-	con->c.sess = &sess->s;
+	con->c.path = &sess->s;
 	/* Align with srv, init as 1 */
 	atomic_set(&con->c.wr_cnt, 1);
 	mutex_init(&con->con_mutex);
@@ -1613,7 +1613,7 @@ static int create_con(struct rtrs_clt_sess *sess, unsigned int cid)
 
 static void destroy_con(struct rtrs_clt_con *con)
 {
-	struct rtrs_clt_sess *sess = to_clt_sess(con->c.sess);
+	struct rtrs_clt_sess *sess = to_clt_sess(con->c.path);
 
 	sess->s.con[con->c.cid] = NULL;
 	mutex_destroy(&con->con_mutex);
@@ -1622,7 +1622,7 @@ static void destroy_con(struct rtrs_clt_con *con)
 
 static int create_con_cq_qp(struct rtrs_clt_con *con)
 {
-	struct rtrs_clt_sess *sess = to_clt_sess(con->c.sess);
+	struct rtrs_clt_sess *sess = to_clt_sess(con->c.path);
 	u32 max_send_wr, max_recv_wr, cq_num, max_send_sge, wr_limit;
 	int err, cq_vector;
 	struct rtrs_msg_rkey_rsp *rsp;
@@ -1711,7 +1711,7 @@ static int create_con_cq_qp(struct rtrs_clt_con *con)
 
 static void destroy_con_cq_qp(struct rtrs_clt_con *con)
 {
-	struct rtrs_clt_sess *sess = to_clt_sess(con->c.sess);
+	struct rtrs_clt_sess *sess = to_clt_sess(con->c.path);
 
 	/*
 	 * Be careful here: destroy_con_cq_qp() can be called even
@@ -1745,7 +1745,7 @@ static void destroy_cm(struct rtrs_clt_con *con)
 
 static int rtrs_rdma_addr_resolved(struct rtrs_clt_con *con)
 {
-	struct rtrs_sess *s = con->c.sess;
+	struct rtrs_path *s = con->c.path;
 	int err;
 
 	mutex_lock(&con->con_mutex);
@@ -1764,7 +1764,7 @@ static int rtrs_rdma_addr_resolved(struct rtrs_clt_con *con)
 
 static int rtrs_rdma_route_resolved(struct rtrs_clt_con *con)
 {
-	struct rtrs_clt_sess *sess = to_clt_sess(con->c.sess);
+	struct rtrs_clt_sess *sess = to_clt_sess(con->c.path);
 	struct rtrs_clt *clt = sess->clt;
 	struct rtrs_msg_conn_req msg;
 	struct rdma_conn_param param;
@@ -1799,7 +1799,7 @@ static int rtrs_rdma_route_resolved(struct rtrs_clt_con *con)
 static int rtrs_rdma_conn_established(struct rtrs_clt_con *con,
 				       struct rdma_cm_event *ev)
 {
-	struct rtrs_clt_sess *sess = to_clt_sess(con->c.sess);
+	struct rtrs_clt_sess *sess = to_clt_sess(con->c.path);
 	struct rtrs_clt *clt = sess->clt;
 	const struct rtrs_msg_conn_rsp *msg;
 	u16 version, queue_depth;
@@ -1887,7 +1887,7 @@ static int rtrs_rdma_conn_established(struct rtrs_clt_con *con,
 
 static inline void flag_success_on_conn(struct rtrs_clt_con *con)
 {
-	struct rtrs_clt_sess *sess = to_clt_sess(con->c.sess);
+	struct rtrs_clt_sess *sess = to_clt_sess(con->c.path);
 
 	atomic_inc(&sess->connected_cnt);
 	con->cm_err = 1;
@@ -1896,7 +1896,7 @@ static inline void flag_success_on_conn(struct rtrs_clt_con *con)
 static int rtrs_rdma_conn_rejected(struct rtrs_clt_con *con,
 				    struct rdma_cm_event *ev)
 {
-	struct rtrs_sess *s = con->c.sess;
+	struct rtrs_path *s = con->c.path;
 	const struct rtrs_msg_conn_rsp *msg;
 	const char *rej_msg;
 	int status, errno;
@@ -1937,7 +1937,7 @@ static inline void flag_error_on_conn(struct rtrs_clt_con *con, int cm_err)
 	if (con->cm_err == 1) {
 		struct rtrs_clt_sess *sess;
 
-		sess = to_clt_sess(con->c.sess);
+		sess = to_clt_sess(con->c.path);
 		if (atomic_dec_and_test(&sess->connected_cnt))
 
 			wake_up(&sess->state_wq);
@@ -1949,7 +1949,7 @@ static int rtrs_clt_rdma_cm_handler(struct rdma_cm_id *cm_id,
 				     struct rdma_cm_event *ev)
 {
 	struct rtrs_clt_con *con = cm_id->context;
-	struct rtrs_sess *s = con->c.sess;
+	struct rtrs_path *s = con->c.path;
 	struct rtrs_clt_sess *sess = to_clt_sess(s);
 	int cm_err = 0;
 
@@ -2020,7 +2020,7 @@ static int rtrs_clt_rdma_cm_handler(struct rdma_cm_id *cm_id,
 
 static int create_cm(struct rtrs_clt_con *con)
 {
-	struct rtrs_sess *s = con->c.sess;
+	struct rtrs_path *s = con->c.path;
 	struct rtrs_clt_sess *sess = to_clt_sess(s);
 	struct rdma_cm_id *cm_id;
 	int err;
@@ -2375,7 +2375,7 @@ static int init_conns(struct rtrs_clt_sess *sess)
 static void rtrs_clt_info_req_done(struct ib_cq *cq, struct ib_wc *wc)
 {
 	struct rtrs_clt_con *con = to_clt_con(wc->qp->qp_context);
-	struct rtrs_clt_sess *sess = to_clt_sess(con->c.sess);
+	struct rtrs_clt_sess *sess = to_clt_sess(con->c.path);
 	struct rtrs_iu *iu;
 
 	iu = container_of(wc->wr_cqe, struct rtrs_iu, cqe);
@@ -2456,7 +2456,7 @@ static int process_info_rsp(struct rtrs_clt_sess *sess,
 static void rtrs_clt_info_rsp_done(struct ib_cq *cq, struct ib_wc *wc)
 {
 	struct rtrs_clt_con *con = to_clt_con(wc->qp->qp_context);
-	struct rtrs_clt_sess *sess = to_clt_sess(con->c.sess);
+	struct rtrs_clt_sess *sess = to_clt_sess(con->c.path);
 	struct rtrs_msg_info_rsp *msg;
 	enum rtrs_clt_state state;
 	struct rtrs_iu *iu;
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.h b/drivers/infiniband/ulp/rtrs/rtrs-clt.h
index 9dc819885ec7..d616f325bc40 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.h
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.h
@@ -125,7 +125,7 @@ struct rtrs_rbuf {
 };
 
 struct rtrs_clt_sess {
-	struct rtrs_sess	s;
+	struct rtrs_path	s;
 	struct rtrs_clt	*clt;
 	wait_queue_head_t	state_wq;
 	enum rtrs_clt_state	state;
@@ -186,7 +186,7 @@ static inline struct rtrs_clt_con *to_clt_con(struct rtrs_con *c)
 	return container_of(c, struct rtrs_clt_con, c);
 }
 
-static inline struct rtrs_clt_sess *to_clt_sess(struct rtrs_sess *s)
+static inline struct rtrs_clt_sess *to_clt_sess(struct rtrs_path *s)
 {
 	return container_of(s, struct rtrs_clt_sess, s);
 }
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-pri.h b/drivers/infiniband/ulp/rtrs/rtrs-pri.h
index e39267bccce8..fad06c707b9b 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-pri.h
+++ b/drivers/infiniband/ulp/rtrs/rtrs-pri.h
@@ -91,7 +91,7 @@ struct rtrs_ib_dev {
 };
 
 struct rtrs_con {
-	struct rtrs_sess	*sess;
+	struct rtrs_path	*path;
 	struct ib_qp		*qp;
 	struct ib_cq		*cq;
 	struct rdma_cm_id	*cm_id;
@@ -101,7 +101,7 @@ struct rtrs_con {
 	atomic_t		sq_wr_avail;
 };
 
-struct rtrs_sess {
+struct rtrs_path {
 	struct list_head	entry;
 	struct sockaddr_storage dst_addr;
 	struct sockaddr_storage src_addr;
@@ -314,19 +314,19 @@ int rtrs_iu_post_rdma_write_imm(struct rtrs_con *con, struct rtrs_iu *iu,
 
 int rtrs_post_recv_empty(struct rtrs_con *con, struct ib_cqe *cqe);
 
-int rtrs_cq_qp_create(struct rtrs_sess *sess, struct rtrs_con *con,
+int rtrs_cq_qp_create(struct rtrs_path *path, struct rtrs_con *con,
 		      u32 max_send_sge, int cq_vector, int nr_cqe,
 		      u32 max_send_wr, u32 max_recv_wr,
 		      enum ib_poll_context poll_ctx);
 void rtrs_cq_qp_destroy(struct rtrs_con *con);
 
-void rtrs_init_hb(struct rtrs_sess *sess, struct ib_cqe *cqe,
+void rtrs_init_hb(struct rtrs_path *path, struct ib_cqe *cqe,
 		  unsigned int interval_ms, unsigned int missed_max,
 		  void (*err_handler)(struct rtrs_con *con),
 		  struct workqueue_struct *wq);
-void rtrs_start_hb(struct rtrs_sess *sess);
-void rtrs_stop_hb(struct rtrs_sess *sess);
-void rtrs_send_hb_ack(struct rtrs_sess *sess);
+void rtrs_start_hb(struct rtrs_path *path);
+void rtrs_stop_hb(struct rtrs_path *path);
+void rtrs_send_hb_ack(struct rtrs_path *path);
 
 void rtrs_rdma_dev_pd_init(enum ib_pd_flags pd_flags,
 			   struct rtrs_rdma_dev_pd *pool);
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c b/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c
index 20efd44297fb..aedddc416003 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c
@@ -37,7 +37,7 @@ static ssize_t rtrs_srv_disconnect_store(struct kobject *kobj,
 					  const char *buf, size_t count)
 {
 	struct rtrs_srv_sess *sess;
-	struct rtrs_sess *s;
+	struct rtrs_path *s;
 	char str[MAXHOSTNAMELEN];
 
 	sess = container_of(kobj, struct rtrs_srv_sess, kobj);
@@ -230,7 +230,7 @@ static struct kobj_type ktype_stats = {
 static int rtrs_srv_create_stats_files(struct rtrs_srv_sess *sess)
 {
 	int err;
-	struct rtrs_sess *s = &sess->s;
+	struct rtrs_path *s = &sess->s;
 
 	err = kobject_init_and_add(&sess->stats->kobj_stats, &ktype_stats,
 				   &sess->kobj, "stats");
@@ -258,7 +258,7 @@ static int rtrs_srv_create_stats_files(struct rtrs_srv_sess *sess)
 int rtrs_srv_create_sess_files(struct rtrs_srv_sess *sess)
 {
 	struct rtrs_srv *srv = sess->srv;
-	struct rtrs_sess *s = &sess->s;
+	struct rtrs_path *s = &sess->s;
 	char str[NAME_MAX];
 	int err;
 	struct rtrs_addr path = {
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.c b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
index 7df71f8cf149..de4f214233b6 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -62,7 +62,7 @@ static inline struct rtrs_srv_con *to_srv_con(struct rtrs_con *c)
 	return container_of(c, struct rtrs_srv_con, c);
 }
 
-static inline struct rtrs_srv_sess *to_srv_sess(struct rtrs_sess *s)
+static inline struct rtrs_srv_sess *to_srv_sess(struct rtrs_path *s)
 {
 	return container_of(s, struct rtrs_srv_sess, s);
 }
@@ -180,7 +180,7 @@ static inline void rtrs_srv_put_ops_ids(struct rtrs_srv_sess *sess)
 static void rtrs_srv_reg_mr_done(struct ib_cq *cq, struct ib_wc *wc)
 {
 	struct rtrs_srv_con *con = to_srv_con(wc->qp->qp_context);
-	struct rtrs_sess *s = con->c.sess;
+	struct rtrs_path *s = con->c.path;
 	struct rtrs_srv_sess *sess = to_srv_sess(s);
 
 	if (wc->status != IB_WC_SUCCESS) {
@@ -197,7 +197,7 @@ static struct ib_cqe local_reg_cqe = {
 
 static int rdma_write_sg(struct rtrs_srv_op *id)
 {
-	struct rtrs_sess *s = id->con->c.sess;
+	struct rtrs_path *s = id->con->c.path;
 	struct rtrs_srv_sess *sess = to_srv_sess(s);
 	dma_addr_t dma_addr = sess->dma_addr[id->msg_id];
 	struct rtrs_srv_mr *srv_mr;
@@ -341,7 +341,7 @@ static int rdma_write_sg(struct rtrs_srv_op *id)
 static int send_io_resp_imm(struct rtrs_srv_con *con, struct rtrs_srv_op *id,
 			    int errno)
 {
-	struct rtrs_sess *s = con->c.sess;
+	struct rtrs_path *s = con->c.path;
 	struct rtrs_srv_sess *sess = to_srv_sess(s);
 	struct ib_send_wr inv_wr, *wr = NULL;
 	struct ib_rdma_wr imm_wr;
@@ -482,14 +482,14 @@ bool rtrs_srv_resp_rdma(struct rtrs_srv_op *id, int status)
 {
 	struct rtrs_srv_sess *sess;
 	struct rtrs_srv_con *con;
-	struct rtrs_sess *s;
+	struct rtrs_path *s;
 	int err;
 
 	if (WARN_ON(!id))
 		return true;
 
 	con = id->con;
-	s = con->c.sess;
+	s = con->c.path;
 	sess = to_srv_sess(s);
 
 	id->status = status;
@@ -564,7 +564,7 @@ static void unmap_cont_bufs(struct rtrs_srv_sess *sess)
 static int map_cont_bufs(struct rtrs_srv_sess *sess)
 {
 	struct rtrs_srv *srv = sess->srv;
-	struct rtrs_sess *ss = &sess->s;
+	struct rtrs_path *ss = &sess->s;
 	int i, mri, err, mrs_num;
 	unsigned int chunk_bits;
 	int chunks_per_mr = 1;
@@ -677,7 +677,7 @@ static int map_cont_bufs(struct rtrs_srv_sess *sess)
 
 static void rtrs_srv_hb_err_handler(struct rtrs_con *c)
 {
-	close_sess(to_srv_sess(c->sess));
+	close_sess(to_srv_sess(c->path));
 }
 
 static void rtrs_srv_init_hb(struct rtrs_srv_sess *sess)
@@ -702,7 +702,7 @@ static void rtrs_srv_stop_hb(struct rtrs_srv_sess *sess)
 static void rtrs_srv_info_rsp_done(struct ib_cq *cq, struct ib_wc *wc)
 {
 	struct rtrs_srv_con *con = to_srv_con(wc->qp->qp_context);
-	struct rtrs_sess *s = con->c.sess;
+	struct rtrs_path *s = con->c.path;
 	struct rtrs_srv_sess *sess = to_srv_sess(s);
 	struct rtrs_iu *iu;
 
@@ -788,7 +788,7 @@ static int rtrs_rdma_do_reject(struct rdma_cm_id *cm_id, int errno);
 static int process_info_req(struct rtrs_srv_con *con,
 			    struct rtrs_msg_info_req *msg)
 {
-	struct rtrs_sess *s = con->c.sess;
+	struct rtrs_path *s = con->c.path;
 	struct rtrs_srv_sess *sess = to_srv_sess(s);
 	struct ib_send_wr *reg_wr = NULL;
 	struct rtrs_msg_info_rsp *rsp;
@@ -889,7 +889,7 @@ static int process_info_req(struct rtrs_srv_con *con,
 static void rtrs_srv_info_req_done(struct ib_cq *cq, struct ib_wc *wc)
 {
 	struct rtrs_srv_con *con = to_srv_con(wc->qp->qp_context);
-	struct rtrs_sess *s = con->c.sess;
+	struct rtrs_path *s = con->c.path;
 	struct rtrs_srv_sess *sess = to_srv_sess(s);
 	struct rtrs_msg_info_req *msg;
 	struct rtrs_iu *iu;
@@ -932,7 +932,7 @@ static void rtrs_srv_info_req_done(struct ib_cq *cq, struct ib_wc *wc)
 
 static int post_recv_info_req(struct rtrs_srv_con *con)
 {
-	struct rtrs_sess *s = con->c.sess;
+	struct rtrs_path *s = con->c.path;
 	struct rtrs_srv_sess *sess = to_srv_sess(s);
 	struct rtrs_iu *rx_iu;
 	int err;
@@ -969,7 +969,7 @@ static int post_recv_io(struct rtrs_srv_con *con, size_t q_size)
 static int post_recv_sess(struct rtrs_srv_sess *sess)
 {
 	struct rtrs_srv *srv = sess->srv;
-	struct rtrs_sess *s = &sess->s;
+	struct rtrs_path *s = &sess->s;
 	size_t q_size;
 	int err, cid;
 
@@ -993,7 +993,7 @@ static void process_read(struct rtrs_srv_con *con,
 			 struct rtrs_msg_rdma_read *msg,
 			 u32 buf_id, u32 off)
 {
-	struct rtrs_sess *s = con->c.sess;
+	struct rtrs_path *s = con->c.path;
 	struct rtrs_srv_sess *sess = to_srv_sess(s);
 	struct rtrs_srv *srv = sess->srv;
 	struct rtrs_srv_ctx *ctx = srv->ctx;
@@ -1051,7 +1051,7 @@ static void process_write(struct rtrs_srv_con *con,
 			  struct rtrs_msg_rdma_write *req,
 			  u32 buf_id, u32 off)
 {
-	struct rtrs_sess *s = con->c.sess;
+	struct rtrs_path *s = con->c.path;
 	struct rtrs_srv_sess *sess = to_srv_sess(s);
 	struct rtrs_srv *srv = sess->srv;
 	struct rtrs_srv_ctx *ctx = srv->ctx;
@@ -1102,7 +1102,7 @@ static void process_write(struct rtrs_srv_con *con,
 static void process_io_req(struct rtrs_srv_con *con, void *msg,
 			   u32 id, u32 off)
 {
-	struct rtrs_sess *s = con->c.sess;
+	struct rtrs_path *s = con->c.path;
 	struct rtrs_srv_sess *sess = to_srv_sess(s);
 	struct rtrs_msg_rdma_hdr *hdr;
 	unsigned int type;
@@ -1137,7 +1137,7 @@ static void rtrs_srv_inv_rkey_done(struct ib_cq *cq, struct ib_wc *wc)
 	struct rtrs_srv_mr *mr =
 		container_of(wc->wr_cqe, typeof(*mr), inv_cqe);
 	struct rtrs_srv_con *con = to_srv_con(wc->qp->qp_context);
-	struct rtrs_sess *s = con->c.sess;
+	struct rtrs_path *s = con->c.path;
 	struct rtrs_srv_sess *sess = to_srv_sess(s);
 	struct rtrs_srv *srv = sess->srv;
 	u32 msg_id, off;
@@ -1194,7 +1194,7 @@ static void rtrs_rdma_process_wr_wait_list(struct rtrs_srv_con *con)
 static void rtrs_srv_rdma_done(struct ib_cq *cq, struct ib_wc *wc)
 {
 	struct rtrs_srv_con *con = to_srv_con(wc->qp->qp_context);
-	struct rtrs_sess *s = con->c.sess;
+	struct rtrs_path *s = con->c.path;
 	struct rtrs_srv_sess *sess = to_srv_sess(s);
 	struct rtrs_srv *srv = sess->srv;
 	u32 imm_type, imm_payload;
@@ -1633,7 +1633,7 @@ static int create_con(struct rtrs_srv_sess *sess,
 		      unsigned int cid)
 {
 	struct rtrs_srv *srv = sess->srv;
-	struct rtrs_sess *s = &sess->s;
+	struct rtrs_path *s = &sess->s;
 	struct rtrs_srv_con *con;
 
 	u32 cq_num, max_send_wr, max_recv_wr, wr_limit;
@@ -1648,7 +1648,7 @@ static int create_con(struct rtrs_srv_sess *sess,
 	spin_lock_init(&con->rsp_wr_wait_lock);
 	INIT_LIST_HEAD(&con->rsp_wr_wait_list);
 	con->c.cm_id = cm_id;
-	con->c.sess = &sess->s;
+	con->c.path = &sess->s;
 	con->c.cid = cid;
 	atomic_set(&con->c.wr_cnt, 1);
 	wr_limit = sess->s.dev->ib_dev->attrs.max_qp_wr;
@@ -1859,7 +1859,7 @@ static int rtrs_rdma_connect(struct rdma_cm_id *cm_id,
 	mutex_lock(&srv->paths_mutex);
 	sess = __find_sess(srv, &msg->sess_uuid);
 	if (sess) {
-		struct rtrs_sess *s = &sess->s;
+		struct rtrs_path *s = &sess->s;
 
 		/* Session already holds a reference */
 		put_srv(srv);
@@ -1938,12 +1938,12 @@ static int rtrs_srv_rdma_cm_handler(struct rdma_cm_id *cm_id,
 				     struct rdma_cm_event *ev)
 {
 	struct rtrs_srv_sess *sess = NULL;
-	struct rtrs_sess *s = NULL;
+	struct rtrs_path *s = NULL;
 
 	if (ev->event != RDMA_CM_EVENT_CONNECT_REQUEST) {
 		struct rtrs_con *c = cm_id->context;
 
-		s = c->sess;
+		s = c->path;
 		sess = to_srv_sess(s);
 	}
 
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.h b/drivers/infiniband/ulp/rtrs/rtrs-srv.h
index 9d8d2a91a235..f0fbd8bf8871 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.h
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.h
@@ -72,7 +72,7 @@ struct rtrs_srv_mr {
 };
 
 struct rtrs_srv_sess {
-	struct rtrs_sess	s;
+	struct rtrs_path	s;
 	struct rtrs_srv	*srv;
 	struct work_struct	close_work;
 	enum rtrs_srv_state	state;
diff --git a/drivers/infiniband/ulp/rtrs/rtrs.c b/drivers/infiniband/ulp/rtrs/rtrs.c
index 37952c8e768c..4da889103a5f 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs.c
@@ -69,16 +69,16 @@ EXPORT_SYMBOL_GPL(rtrs_iu_free);
 
 int rtrs_iu_post_recv(struct rtrs_con *con, struct rtrs_iu *iu)
 {
-	struct rtrs_sess *sess = con->sess;
+	struct rtrs_path *path = con->path;
 	struct ib_recv_wr wr;
 	struct ib_sge list;
 
 	list.addr   = iu->dma_addr;
 	list.length = iu->size;
-	list.lkey   = sess->dev->ib_pd->local_dma_lkey;
+	list.lkey   = path->dev->ib_pd->local_dma_lkey;
 
 	if (list.length == 0) {
-		rtrs_wrn(con->sess,
+		rtrs_wrn(con->path,
 			  "Posting receive work request failed, sg list is empty\n");
 		return -EINVAL;
 	}
@@ -126,7 +126,7 @@ static int rtrs_post_send(struct ib_qp *qp, struct ib_send_wr *head,
 int rtrs_iu_post_send(struct rtrs_con *con, struct rtrs_iu *iu, size_t size,
 		       struct ib_send_wr *head)
 {
-	struct rtrs_sess *sess = con->sess;
+	struct rtrs_path *path = con->path;
 	struct ib_send_wr wr;
 	struct ib_sge list;
 
@@ -135,7 +135,7 @@ int rtrs_iu_post_send(struct rtrs_con *con, struct rtrs_iu *iu, size_t size,
 
 	list.addr   = iu->dma_addr;
 	list.length = size;
-	list.lkey   = sess->dev->ib_pd->local_dma_lkey;
+	list.lkey   = path->dev->ib_pd->local_dma_lkey;
 
 	wr = (struct ib_send_wr) {
 		.wr_cqe     = &iu->cqe,
@@ -188,11 +188,11 @@ static int rtrs_post_rdma_write_imm_empty(struct rtrs_con *con,
 					  struct ib_send_wr *head)
 {
 	struct ib_rdma_wr wr;
-	struct rtrs_sess *sess = con->sess;
+	struct rtrs_path *path = con->path;
 	enum ib_send_flags sflags;
 
 	atomic_dec_if_positive(&con->sq_wr_avail);
-	sflags = (atomic_inc_return(&con->wr_cnt) % sess->signal_interval) ?
+	sflags = (atomic_inc_return(&con->wr_cnt) % path->signal_interval) ?
 		0 : IB_SEND_SIGNALED;
 
 	wr = (struct ib_rdma_wr) {
@@ -211,12 +211,12 @@ static void qp_event_handler(struct ib_event *ev, void *ctx)
 
 	switch (ev->event) {
 	case IB_EVENT_COMM_EST:
-		rtrs_info(con->sess, "QP event %s (%d) received\n",
+		rtrs_info(con->path, "QP event %s (%d) received\n",
 			   ib_event_msg(ev->event), ev->event);
 		rdma_notify(con->cm_id, IB_EVENT_COMM_EST);
 		break;
 	default:
-		rtrs_info(con->sess, "Unhandled QP event %s (%d) received\n",
+		rtrs_info(con->path, "Unhandled QP event %s (%d) received\n",
 			   ib_event_msg(ev->event), ev->event);
 		break;
 	}
@@ -224,7 +224,7 @@ static void qp_event_handler(struct ib_event *ev, void *ctx)
 
 static bool is_pollqueue(struct rtrs_con *con)
 {
-	return con->cid >= con->sess->irq_con_num;
+	return con->cid >= con->path->irq_con_num;
 }
 
 static int create_cq(struct rtrs_con *con, int cq_vector, int nr_cqe,
@@ -240,7 +240,7 @@ static int create_cq(struct rtrs_con *con, int cq_vector, int nr_cqe,
 		cq = ib_cq_pool_get(cm_id->device, nr_cqe, cq_vector, poll_ctx);
 
 	if (IS_ERR(cq)) {
-		rtrs_err(con->sess, "Creating completion queue failed, errno: %ld\n",
+		rtrs_err(con->path, "Creating completion queue failed, errno: %ld\n",
 			  PTR_ERR(cq));
 		return PTR_ERR(cq);
 	}
@@ -271,7 +271,7 @@ static int create_qp(struct rtrs_con *con, struct ib_pd *pd,
 
 	ret = rdma_create_qp(cm_id, pd, &init_attr);
 	if (ret) {
-		rtrs_err(con->sess, "Creating QP failed, err: %d\n", ret);
+		rtrs_err(con->path, "Creating QP failed, err: %d\n", ret);
 		return ret;
 	}
 	con->qp = cm_id->qp;
@@ -290,7 +290,7 @@ static void destroy_cq(struct rtrs_con *con)
 	con->cq = NULL;
 }
 
-int rtrs_cq_qp_create(struct rtrs_sess *sess, struct rtrs_con *con,
+int rtrs_cq_qp_create(struct rtrs_path *path, struct rtrs_con *con,
 		       u32 max_send_sge, int cq_vector, int nr_cqe,
 		       u32 max_send_wr, u32 max_recv_wr,
 		       enum ib_poll_context poll_ctx)
@@ -301,13 +301,13 @@ int rtrs_cq_qp_create(struct rtrs_sess *sess, struct rtrs_con *con,
 	if (err)
 		return err;
 
-	err = create_qp(con, sess->dev->ib_pd, max_send_wr, max_recv_wr,
+	err = create_qp(con, path->dev->ib_pd, max_send_wr, max_recv_wr,
 			max_send_sge);
 	if (err) {
 		destroy_cq(con);
 		return err;
 	}
-	con->sess = sess;
+	con->path = path;
 
 	return 0;
 }
@@ -323,24 +323,24 @@ void rtrs_cq_qp_destroy(struct rtrs_con *con)
 }
 EXPORT_SYMBOL_GPL(rtrs_cq_qp_destroy);
 
-static void schedule_hb(struct rtrs_sess *sess)
+static void schedule_hb(struct rtrs_path *path)
 {
-	queue_delayed_work(sess->hb_wq, &sess->hb_dwork,
-			   msecs_to_jiffies(sess->hb_interval_ms));
+	queue_delayed_work(path->hb_wq, &path->hb_dwork,
+			   msecs_to_jiffies(path->hb_interval_ms));
 }
 
-void rtrs_send_hb_ack(struct rtrs_sess *sess)
+void rtrs_send_hb_ack(struct rtrs_path *path)
 {
-	struct rtrs_con *usr_con = sess->con[0];
+	struct rtrs_con *usr_con = path->con[0];
 	u32 imm;
 	int err;
 
 	imm = rtrs_to_imm(RTRS_HB_ACK_IMM, 0);
-	err = rtrs_post_rdma_write_imm_empty(usr_con, sess->hb_cqe, imm,
+	err = rtrs_post_rdma_write_imm_empty(usr_con, path->hb_cqe, imm,
 					     NULL);
 	if (err) {
-		rtrs_err(sess, "send HB ACK failed, errno: %d\n", err);
-		sess->hb_err_handler(usr_con);
+		rtrs_err(path, "send HB ACK failed, errno: %d\n", err);
+		path->hb_err_handler(usr_con);
 		return;
 	}
 }
@@ -349,63 +349,63 @@ EXPORT_SYMBOL_GPL(rtrs_send_hb_ack);
 static void hb_work(struct work_struct *work)
 {
 	struct rtrs_con *usr_con;
-	struct rtrs_sess *sess;
+	struct rtrs_path *path;
 	u32 imm;
 	int err;
 
-	sess = container_of(to_delayed_work(work), typeof(*sess), hb_dwork);
-	usr_con = sess->con[0];
+	path = container_of(to_delayed_work(work), typeof(*path), hb_dwork);
+	usr_con = path->con[0];
 
-	if (sess->hb_missed_cnt > sess->hb_missed_max) {
-		rtrs_err(sess, "HB missed max reached.\n");
-		sess->hb_err_handler(usr_con);
+	if (path->hb_missed_cnt > path->hb_missed_max) {
+		rtrs_err(path, "HB missed max reached.\n");
+		path->hb_err_handler(usr_con);
 		return;
 	}
-	if (sess->hb_missed_cnt++) {
+	if (path->hb_missed_cnt++) {
 		/* Reschedule work without sending hb */
-		schedule_hb(sess);
+		schedule_hb(path);
 		return;
 	}
 
-	sess->hb_last_sent = ktime_get();
+	path->hb_last_sent = ktime_get();
 
 	imm = rtrs_to_imm(RTRS_HB_MSG_IMM, 0);
-	err = rtrs_post_rdma_write_imm_empty(usr_con, sess->hb_cqe, imm,
+	err = rtrs_post_rdma_write_imm_empty(usr_con, path->hb_cqe, imm,
 					     NULL);
 	if (err) {
-		rtrs_err(sess, "HB send failed, errno: %d\n", err);
-		sess->hb_err_handler(usr_con);
+		rtrs_err(path, "HB send failed, errno: %d\n", err);
+		path->hb_err_handler(usr_con);
 		return;
 	}
 
-	schedule_hb(sess);
+	schedule_hb(path);
 }
 
-void rtrs_init_hb(struct rtrs_sess *sess, struct ib_cqe *cqe,
+void rtrs_init_hb(struct rtrs_path *path, struct ib_cqe *cqe,
 		  unsigned int interval_ms, unsigned int missed_max,
 		  void (*err_handler)(struct rtrs_con *con),
 		  struct workqueue_struct *wq)
 {
-	sess->hb_cqe = cqe;
-	sess->hb_interval_ms = interval_ms;
-	sess->hb_err_handler = err_handler;
-	sess->hb_wq = wq;
-	sess->hb_missed_max = missed_max;
-	sess->hb_missed_cnt = 0;
-	INIT_DELAYED_WORK(&sess->hb_dwork, hb_work);
+	path->hb_cqe = cqe;
+	path->hb_interval_ms = interval_ms;
+	path->hb_err_handler = err_handler;
+	path->hb_wq = wq;
+	path->hb_missed_max = missed_max;
+	path->hb_missed_cnt = 0;
+	INIT_DELAYED_WORK(&path->hb_dwork, hb_work);
 }
 EXPORT_SYMBOL_GPL(rtrs_init_hb);
 
-void rtrs_start_hb(struct rtrs_sess *sess)
+void rtrs_start_hb(struct rtrs_path *path)
 {
-	schedule_hb(sess);
+	schedule_hb(path);
 }
 EXPORT_SYMBOL_GPL(rtrs_start_hb);
 
-void rtrs_stop_hb(struct rtrs_sess *sess)
+void rtrs_stop_hb(struct rtrs_path *path)
 {
-	cancel_delayed_work_sync(&sess->hb_dwork);
-	sess->hb_missed_cnt = 0;
+	cancel_delayed_work_sync(&path->hb_dwork);
+	path->hb_missed_cnt = 0;
 }
 EXPORT_SYMBOL_GPL(rtrs_stop_hb);
 
-- 
2.35.1



