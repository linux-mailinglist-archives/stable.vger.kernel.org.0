Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1897C328EEC
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241290AbhCATkq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:40:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:50732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241608AbhCATcx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:32:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B70264D9E;
        Mon,  1 Mar 2021 17:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619226;
        bh=T8uYsNhGsAH6UjUxChxPFndNJnrJeCc7yQlfKazzsIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XSWbjnW7bnDCWIMfbyGL2+oVEG6jye9E/x6Pkulgmo3hqqruhtMCv914qNh4J6sDl
         I3Gz4wroeEeiCd+XBeQLscaQxEQIa5XVQ3xQCQYwAByUlx221gMEaovQPFoEzbTo8l
         VzpXj/Sw2owoTxYTxD358pCX245YjZcKewqMbmt4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@cloud.ionos.com>,
        Gioh Kim <gi-oh.kim@cloud.ionos.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 378/663] RDMA/rtrs-srv: Fix stack-out-of-bounds
Date:   Mon,  1 Mar 2021 17:10:26 +0100
Message-Id: <20210301161200.557588790@linuxfoundation.org>
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

[ Upstream commit e6daa8f61d8def10f0619fe51b4c794f69598e4f ]

  BUG: KASAN: stack-out-of-bounds in _mlx4_ib_post_send+0x1bd2/0x2770 [mlx4_ib]
  Read of size 4 at addr ffff8880d5a7f980 by task kworker/0:1H/565

  CPU: 0 PID: 565 Comm: kworker/0:1H Tainted: G           O      5.4.84-storage #5.4.84-1+feature+linux+5.4.y+dbg+20201216.1319+b6b887b~deb10
  Hardware name: Supermicro H8QG6/H8QG6, BIOS 3.00       09/04/2012
  Workqueue: ib-comp-wq ib_cq_poll_work [ib_core]
  Call Trace:
   dump_stack+0x96/0xe0
   print_address_description.constprop.4+0x1f/0x300
   ? irq_work_claim+0x2e/0x50
   __kasan_report.cold.8+0x78/0x92
   ? _mlx4_ib_post_send+0x1bd2/0x2770 [mlx4_ib]
   kasan_report+0x10/0x20
   _mlx4_ib_post_send+0x1bd2/0x2770 [mlx4_ib]
   ? check_chain_key+0x1d7/0x2e0
   ? _mlx4_ib_post_recv+0x630/0x630 [mlx4_ib]
   ? lockdep_hardirqs_on+0x1a8/0x290
   ? stack_depot_save+0x218/0x56e
   ? do_profile_hits.isra.6.cold.13+0x1d/0x1d
   ? check_chain_key+0x1d7/0x2e0
   ? save_stack+0x4d/0x80
   ? save_stack+0x19/0x80
   ? __kasan_slab_free+0x125/0x170
   ? kfree+0xe7/0x3b0
   rdma_write_sg+0x5b0/0x950 [rtrs_server]

The problem is when we send imm_wr, the type should be ib_rdma_wr, so hw
driver like mlx4 can do rdma_wr(wr), so fix it by use the ib_rdma_wr as
type for imm_wr.

Fixes: 9cb837480424 ("RDMA/rtrs: server: main functionality")
Link: https://lore.kernel.org/r/20210212134525.103456-2-jinpu.wang@cloud.ionos.com
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Reviewed-by: Gioh Kim <gi-oh.kim@cloud.ionos.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-srv.c | 64 +++++++++++++-------------
 1 file changed, 33 insertions(+), 31 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.c b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
index f3f4b640b0970..75e1e89e09b38 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -232,7 +232,8 @@ static int rdma_write_sg(struct rtrs_srv_op *id)
 	dma_addr_t dma_addr = sess->dma_addr[id->msg_id];
 	struct rtrs_srv_mr *srv_mr;
 	struct rtrs_srv *srv = sess->srv;
-	struct ib_send_wr inv_wr, imm_wr;
+	struct ib_send_wr inv_wr;
+	struct ib_rdma_wr imm_wr;
 	struct ib_rdma_wr *wr = NULL;
 	enum ib_send_flags flags;
 	size_t sg_cnt;
@@ -284,15 +285,15 @@ static int rdma_write_sg(struct rtrs_srv_op *id)
 	if (need_inval && always_invalidate) {
 		wr->wr.next = &rwr.wr;
 		rwr.wr.next = &inv_wr;
-		inv_wr.next = &imm_wr;
+		inv_wr.next = &imm_wr.wr;
 	} else if (always_invalidate) {
 		wr->wr.next = &rwr.wr;
-		rwr.wr.next = &imm_wr;
+		rwr.wr.next = &imm_wr.wr;
 	} else if (need_inval) {
 		wr->wr.next = &inv_wr;
-		inv_wr.next = &imm_wr;
+		inv_wr.next = &imm_wr.wr;
 	} else {
-		wr->wr.next = &imm_wr;
+		wr->wr.next = &imm_wr.wr;
 	}
 	/*
 	 * From time to time we have to post signaled sends,
@@ -310,7 +311,7 @@ static int rdma_write_sg(struct rtrs_srv_op *id)
 		inv_wr.ex.invalidate_rkey = rkey;
 	}
 
-	imm_wr.next = NULL;
+	imm_wr.wr.next = NULL;
 	if (always_invalidate) {
 		struct rtrs_msg_rkey_rsp *msg;
 
@@ -331,22 +332,22 @@ static int rdma_write_sg(struct rtrs_srv_op *id)
 		list.addr   = srv_mr->iu->dma_addr;
 		list.length = sizeof(*msg);
 		list.lkey   = sess->s.dev->ib_pd->local_dma_lkey;
-		imm_wr.sg_list = &list;
-		imm_wr.num_sge = 1;
-		imm_wr.opcode = IB_WR_SEND_WITH_IMM;
+		imm_wr.wr.sg_list = &list;
+		imm_wr.wr.num_sge = 1;
+		imm_wr.wr.opcode = IB_WR_SEND_WITH_IMM;
 		ib_dma_sync_single_for_device(sess->s.dev->ib_dev,
 					      srv_mr->iu->dma_addr,
 					      srv_mr->iu->size, DMA_TO_DEVICE);
 	} else {
-		imm_wr.sg_list = NULL;
-		imm_wr.num_sge = 0;
-		imm_wr.opcode = IB_WR_RDMA_WRITE_WITH_IMM;
+		imm_wr.wr.sg_list = NULL;
+		imm_wr.wr.num_sge = 0;
+		imm_wr.wr.opcode = IB_WR_RDMA_WRITE_WITH_IMM;
 	}
-	imm_wr.send_flags = flags;
-	imm_wr.ex.imm_data = cpu_to_be32(rtrs_to_io_rsp_imm(id->msg_id,
+	imm_wr.wr.send_flags = flags;
+	imm_wr.wr.ex.imm_data = cpu_to_be32(rtrs_to_io_rsp_imm(id->msg_id,
 							     0, need_inval));
 
-	imm_wr.wr_cqe   = &io_comp_cqe;
+	imm_wr.wr.wr_cqe   = &io_comp_cqe;
 	ib_dma_sync_single_for_device(sess->s.dev->ib_dev, dma_addr,
 				      offset, DMA_BIDIRECTIONAL);
 
@@ -373,7 +374,8 @@ static int send_io_resp_imm(struct rtrs_srv_con *con, struct rtrs_srv_op *id,
 {
 	struct rtrs_sess *s = con->c.sess;
 	struct rtrs_srv_sess *sess = to_srv_sess(s);
-	struct ib_send_wr inv_wr, imm_wr, *wr = NULL;
+	struct ib_send_wr inv_wr, *wr = NULL;
+	struct ib_rdma_wr imm_wr;
 	struct ib_reg_wr rwr;
 	struct rtrs_srv *srv = sess->srv;
 	struct rtrs_srv_mr *srv_mr;
@@ -410,15 +412,15 @@ static int send_io_resp_imm(struct rtrs_srv_con *con, struct rtrs_srv_op *id,
 	if (need_inval && always_invalidate) {
 		wr = &inv_wr;
 		inv_wr.next = &rwr.wr;
-		rwr.wr.next = &imm_wr;
+		rwr.wr.next = &imm_wr.wr;
 	} else if (always_invalidate) {
 		wr = &rwr.wr;
-		rwr.wr.next = &imm_wr;
+		rwr.wr.next = &imm_wr.wr;
 	} else if (need_inval) {
 		wr = &inv_wr;
-		inv_wr.next = &imm_wr;
+		inv_wr.next = &imm_wr.wr;
 	} else {
-		wr = &imm_wr;
+		wr = &imm_wr.wr;
 	}
 	/*
 	 * From time to time we have to post signalled sends,
@@ -427,13 +429,13 @@ static int send_io_resp_imm(struct rtrs_srv_con *con, struct rtrs_srv_op *id,
 	flags = (atomic_inc_return(&con->wr_cnt) % srv->queue_depth) ?
 		0 : IB_SEND_SIGNALED;
 	imm = rtrs_to_io_rsp_imm(id->msg_id, errno, need_inval);
-	imm_wr.next = NULL;
+	imm_wr.wr.next = NULL;
 	if (always_invalidate) {
 		struct ib_sge list;
 		struct rtrs_msg_rkey_rsp *msg;
 
 		srv_mr = &sess->mrs[id->msg_id];
-		rwr.wr.next = &imm_wr;
+		rwr.wr.next = &imm_wr.wr;
 		rwr.wr.opcode = IB_WR_REG_MR;
 		rwr.wr.wr_cqe = &local_reg_cqe;
 		rwr.wr.num_sge = 0;
@@ -450,21 +452,21 @@ static int send_io_resp_imm(struct rtrs_srv_con *con, struct rtrs_srv_op *id,
 		list.addr   = srv_mr->iu->dma_addr;
 		list.length = sizeof(*msg);
 		list.lkey   = sess->s.dev->ib_pd->local_dma_lkey;
-		imm_wr.sg_list = &list;
-		imm_wr.num_sge = 1;
-		imm_wr.opcode = IB_WR_SEND_WITH_IMM;
+		imm_wr.wr.sg_list = &list;
+		imm_wr.wr.num_sge = 1;
+		imm_wr.wr.opcode = IB_WR_SEND_WITH_IMM;
 		ib_dma_sync_single_for_device(sess->s.dev->ib_dev,
 					      srv_mr->iu->dma_addr,
 					      srv_mr->iu->size, DMA_TO_DEVICE);
 	} else {
-		imm_wr.sg_list = NULL;
-		imm_wr.num_sge = 0;
-		imm_wr.opcode = IB_WR_RDMA_WRITE_WITH_IMM;
+		imm_wr.wr.sg_list = NULL;
+		imm_wr.wr.num_sge = 0;
+		imm_wr.wr.opcode = IB_WR_RDMA_WRITE_WITH_IMM;
 	}
-	imm_wr.send_flags = flags;
-	imm_wr.wr_cqe   = &io_comp_cqe;
+	imm_wr.wr.send_flags = flags;
+	imm_wr.wr.wr_cqe   = &io_comp_cqe;
 
-	imm_wr.ex.imm_data = cpu_to_be32(imm);
+	imm_wr.wr.ex.imm_data = cpu_to_be32(imm);
 
 	err = ib_post_send(id->con->c.qp, wr, NULL);
 	if (unlikely(err))
-- 
2.27.0



