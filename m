Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 020F3198FF4
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730930AbgCaJHp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:07:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:49634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731260AbgCaJHp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:07:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0F7F20787;
        Tue, 31 Mar 2020 09:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645663;
        bh=rUDUpY2Txznbct4V9HrwCS59gMaGOM3rsv9wSGfG2/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gI7XdDrbTYx/FRZcdyqu3NWnEhU6pgMTDGrlcaIRIJZ2SYouaIETzg7jQ9Yr48+TI
         7Ve/fckSApcKbgcBywVfsMtGC2+/MyhldUjK993awYiK/YTAqZ1Runlu1RdbJI3Bqz
         QhcE8dSDmTsSkeKQI9J4BL8Fs6mg5xe7tp6dsy6k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.5 125/170] RDMA/mlx5: Fix access to wrong pointer while performing flush due to error
Date:   Tue, 31 Mar 2020 10:58:59 +0200
Message-Id: <20200331085437.186233743@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085423.990189598@linuxfoundation.org>
References: <20200331085423.990189598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

commit 950bf4f17725556bbc773a5b71e88a6c14c9ff25 upstream.

The main difference between send and receive SW completions is related to
separate treatment of WQ queue. For receive completions, the initial index
to be flushed is stored in "tail", while for send completions, it is in
deleted "last_poll".

  CPU: 54 PID: 53405 Comm: kworker/u161:0 Kdump: loaded Tainted: G           OE    --------- -t - 4.18.0-147.el8.ppc64le #1
  Workqueue: ib-comp-unb-wq ib_cq_poll_work [ib_core]
  NIP:  c000003c7c00a000 LR: c00800000e586af4 CTR: c000003c7c00a000
  REGS: c0000036cc9db940 TRAP: 0400   Tainted: G           OE    --------- -t -  (4.18.0-147.el8.ppc64le)
  MSR:  9000000010009033 <SF,HV,EE,ME,IR,DR,RI,LE>  CR: 24004488  XER: 20040000
  CFAR: c00800000e586af0 IRQMASK: 0
  GPR00: c00800000e586ab4 c0000036cc9dbbc0 c00800000e5f1a00 c0000037d8433800
  GPR04: c000003895a26800 c0000037293f2000 0000000000000201 0000000000000011
  GPR08: c000003895a26c80 c000003c7c00a000 0000000000000000 c00800000ed30438
  GPR12: c000003c7c00a000 c000003fff684b80 c00000000017c388 c00000396ec4be40
  GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
  GPR20: c00000000151e498 0000000000000010 c000003895a26848 0000000000000010
  GPR24: 0000000000000010 0000000000010000 c000003895a26800 0000000000000000
  GPR28: 0000000000000010 c0000037d8433800 c000003895a26c80 c000003895a26800
  NIP [c000003c7c00a000] 0xc000003c7c00a000
  LR [c00800000e586af4] __ib_process_cq+0xec/0x1b0 [ib_core]
  Call Trace:
  [c0000036cc9dbbc0] [c00800000e586ab4] __ib_process_cq+0xac/0x1b0 [ib_core] (unreliable)
  [c0000036cc9dbc40] [c00800000e586c88] ib_cq_poll_work+0x40/0xb0 [ib_core]
  [c0000036cc9dbc70] [c000000000171f44] process_one_work+0x2f4/0x5c0
  [c0000036cc9dbd10] [c000000000172a0c] worker_thread+0xcc/0x760
  [c0000036cc9dbdc0] [c00000000017c52c] kthread+0x1ac/0x1c0
  [c0000036cc9dbe30] [c00000000000b75c] ret_from_kernel_thread+0x5c/0x80

Fixes: 8e3b68830186 ("RDMA/mlx5: Delete unreachable handle_atomic code by simplifying SW completion")
Link: https://lore.kernel.org/r/20200318091640.44069-1-leon@kernel.org
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/mlx5/cq.c      |   27 +++++++++++++++++++++++++--
 drivers/infiniband/hw/mlx5/mlx5_ib.h |    1 +
 drivers/infiniband/hw/mlx5/qp.c      |    1 +
 3 files changed, 27 insertions(+), 2 deletions(-)

--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -330,6 +330,22 @@ static void mlx5_handle_error_cqe(struct
 		dump_cqe(dev, cqe);
 }
 
+static void handle_atomics(struct mlx5_ib_qp *qp, struct mlx5_cqe64 *cqe64,
+			   u16 tail, u16 head)
+{
+	u16 idx;
+
+	do {
+		idx = tail & (qp->sq.wqe_cnt - 1);
+		if (idx == head)
+			break;
+
+		tail = qp->sq.w_list[idx].next;
+	} while (1);
+	tail = qp->sq.w_list[idx].next;
+	qp->sq.last_poll = tail;
+}
+
 static void free_cq_buf(struct mlx5_ib_dev *dev, struct mlx5_ib_cq_buf *buf)
 {
 	mlx5_frag_buf_free(dev->mdev, &buf->frag_buf);
@@ -368,7 +384,7 @@ static void get_sig_err_item(struct mlx5
 }
 
 static void sw_comp(struct mlx5_ib_qp *qp, int num_entries, struct ib_wc *wc,
-		    int *npolled, int is_send)
+		    int *npolled, bool is_send)
 {
 	struct mlx5_ib_wq *wq;
 	unsigned int cur;
@@ -383,10 +399,16 @@ static void sw_comp(struct mlx5_ib_qp *q
 		return;
 
 	for (i = 0;  i < cur && np < num_entries; i++) {
-		wc->wr_id = wq->wrid[wq->tail & (wq->wqe_cnt - 1)];
+		unsigned int idx;
+
+		idx = (is_send) ? wq->last_poll : wq->tail;
+		idx &= (wq->wqe_cnt - 1);
+		wc->wr_id = wq->wrid[idx];
 		wc->status = IB_WC_WR_FLUSH_ERR;
 		wc->vendor_err = MLX5_CQE_SYNDROME_WR_FLUSH_ERR;
 		wq->tail++;
+		if (is_send)
+			wq->last_poll = wq->w_list[idx].next;
 		np++;
 		wc->qp = &qp->ibqp;
 		wc++;
@@ -473,6 +495,7 @@ repoll:
 		wqe_ctr = be16_to_cpu(cqe64->wqe_counter);
 		idx = wqe_ctr & (wq->wqe_cnt - 1);
 		handle_good_req(wc, cqe64, wq, idx);
+		handle_atomics(*cur_qp, cqe64, wq->last_poll, idx);
 		wc->wr_id = wq->wrid[idx];
 		wq->tail = wq->wqe_head[idx] + 1;
 		wc->status = IB_WC_SUCCESS;
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -282,6 +282,7 @@ struct mlx5_ib_wq {
 	unsigned		head;
 	unsigned		tail;
 	u16			cur_post;
+	u16			last_poll;
 	void			*cur_edge;
 };
 
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -3728,6 +3728,7 @@ static int __mlx5_ib_modify_qp(struct ib
 		qp->sq.cur_post = 0;
 		if (qp->sq.wqe_cnt)
 			qp->sq.cur_edge = get_sq_edge(&qp->sq, 0);
+		qp->sq.last_poll = 0;
 		qp->db.db[MLX5_RCV_DBR] = 0;
 		qp->db.db[MLX5_SND_DBR] = 0;
 	}


