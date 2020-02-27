Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09B6B171D4F
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:19:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389927AbgB0OSo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:18:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:59348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389925AbgB0OSo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:18:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BDB32468F;
        Thu, 27 Feb 2020 14:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582813123;
        bh=C6Encfp0HnT/CKsLIrS/WT4CFL/BGWA8wgTy9t4wzuI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Tq7AjCF5+20U/hfY42HYRNoGy+F/ensvQyrNHdEevEFEOQZgUAOVO0/kh6iOFefC
         xFkYkgyk09G7+28PMWyErDJNz/PkS5YiZjrOLiHeYOmM+bshxqeXeWkc/EVPPdC67F
         Rd3d/3xZ0YbCANs+0ugzM/1wyDtcAwKcxTJsv6BQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.5 144/150] net/mlx5e: Reset RQ doorbell counter before moving RQ state from RST to RDY
Date:   Thu, 27 Feb 2020 14:38:01 +0100
Message-Id: <20200227132253.568018360@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132232.815448360@linuxfoundation.org>
References: <20200227132232.815448360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

commit 5ee090ed0da649b1febae2b7c285ac77d1e55a0c upstream.

Initialize RQ doorbell counters to zero prior to moving an RQ from RST
to RDY state. Per HW spec, when RQ is back to RDY state, the descriptor
ID on the completion is reset. The doorbell record must comply.

Fixes: 8276ea1353a4 ("net/mlx5e: Report and recover from CQE with error on RQ")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Reported-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h |    8 ++++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c |    3 +
 drivers/net/ethernet/mellanox/mlx5/core/wq.c      |   39 ++++++++++++++++------
 drivers/net/ethernet/mellanox/mlx5/core/wq.h      |    2 +
 4 files changed, 43 insertions(+), 9 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -179,6 +179,14 @@ mlx5e_tx_dma_unmap(struct device *pdev,
 	}
 }
 
+static inline void mlx5e_rqwq_reset(struct mlx5e_rq *rq)
+{
+	if (rq->wq_type == MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ)
+		mlx5_wq_ll_reset(&rq->mpwqe.wq);
+	else
+		mlx5_wq_cyc_reset(&rq->wqe.wq);
+}
+
 /* SW parser related functions */
 
 struct mlx5e_swp_spec {
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -721,6 +721,9 @@ int mlx5e_modify_rq_state(struct mlx5e_r
 	if (!in)
 		return -ENOMEM;
 
+	if (curr_state == MLX5_RQC_STATE_RST && next_state == MLX5_RQC_STATE_RDY)
+		mlx5e_rqwq_reset(rq);
+
 	rqc = MLX5_ADDR_OF(modify_rq_in, in, ctx);
 
 	MLX5_SET(modify_rq_in, in, rq_state, curr_state);
--- a/drivers/net/ethernet/mellanox/mlx5/core/wq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/wq.c
@@ -94,6 +94,13 @@ void mlx5_wq_cyc_wqe_dump(struct mlx5_wq
 	print_hex_dump(KERN_WARNING, "", DUMP_PREFIX_OFFSET, 16, 1, wqe, len, false);
 }
 
+void mlx5_wq_cyc_reset(struct mlx5_wq_cyc *wq)
+{
+	wq->wqe_ctr = 0;
+	wq->cur_sz = 0;
+	mlx5_wq_cyc_update_db_record(wq);
+}
+
 int mlx5_wq_qp_create(struct mlx5_core_dev *mdev, struct mlx5_wq_param *param,
 		      void *qpc, struct mlx5_wq_qp *wq,
 		      struct mlx5_wq_ctrl *wq_ctrl)
@@ -192,6 +199,19 @@ err_db_free:
 	return err;
 }
 
+static void mlx5_wq_ll_init_list(struct mlx5_wq_ll *wq)
+{
+	struct mlx5_wqe_srq_next_seg *next_seg;
+	int i;
+
+	for (i = 0; i < wq->fbc.sz_m1; i++) {
+		next_seg = mlx5_wq_ll_get_wqe(wq, i);
+		next_seg->next_wqe_index = cpu_to_be16(i + 1);
+	}
+	next_seg = mlx5_wq_ll_get_wqe(wq, i);
+	wq->tail_next = &next_seg->next_wqe_index;
+}
+
 int mlx5_wq_ll_create(struct mlx5_core_dev *mdev, struct mlx5_wq_param *param,
 		      void *wqc, struct mlx5_wq_ll *wq,
 		      struct mlx5_wq_ctrl *wq_ctrl)
@@ -199,9 +219,7 @@ int mlx5_wq_ll_create(struct mlx5_core_d
 	u8 log_wq_stride = MLX5_GET(wq, wqc, log_wq_stride);
 	u8 log_wq_sz     = MLX5_GET(wq, wqc, log_wq_sz);
 	struct mlx5_frag_buf_ctrl *fbc = &wq->fbc;
-	struct mlx5_wqe_srq_next_seg *next_seg;
 	int err;
-	int i;
 
 	err = mlx5_db_alloc_node(mdev, &wq_ctrl->db, param->db_numa_node);
 	if (err) {
@@ -220,13 +238,7 @@ int mlx5_wq_ll_create(struct mlx5_core_d
 
 	mlx5_init_fbc(wq_ctrl->buf.frags, log_wq_stride, log_wq_sz, fbc);
 
-	for (i = 0; i < fbc->sz_m1; i++) {
-		next_seg = mlx5_wq_ll_get_wqe(wq, i);
-		next_seg->next_wqe_index = cpu_to_be16(i + 1);
-	}
-	next_seg = mlx5_wq_ll_get_wqe(wq, i);
-	wq->tail_next = &next_seg->next_wqe_index;
-
+	mlx5_wq_ll_init_list(wq);
 	wq_ctrl->mdev = mdev;
 
 	return 0;
@@ -237,6 +249,15 @@ err_db_free:
 	return err;
 }
 
+void mlx5_wq_ll_reset(struct mlx5_wq_ll *wq)
+{
+	wq->head = 0;
+	wq->wqe_ctr = 0;
+	wq->cur_sz = 0;
+	mlx5_wq_ll_init_list(wq);
+	mlx5_wq_ll_update_db_record(wq);
+}
+
 void mlx5_wq_destroy(struct mlx5_wq_ctrl *wq_ctrl)
 {
 	mlx5_frag_buf_free(wq_ctrl->mdev, &wq_ctrl->buf);
--- a/drivers/net/ethernet/mellanox/mlx5/core/wq.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/wq.h
@@ -80,6 +80,7 @@ int mlx5_wq_cyc_create(struct mlx5_core_
 		       void *wqc, struct mlx5_wq_cyc *wq,
 		       struct mlx5_wq_ctrl *wq_ctrl);
 void mlx5_wq_cyc_wqe_dump(struct mlx5_wq_cyc *wq, u16 ix, u8 nstrides);
+void mlx5_wq_cyc_reset(struct mlx5_wq_cyc *wq);
 
 int mlx5_wq_qp_create(struct mlx5_core_dev *mdev, struct mlx5_wq_param *param,
 		      void *qpc, struct mlx5_wq_qp *wq,
@@ -92,6 +93,7 @@ int mlx5_cqwq_create(struct mlx5_core_de
 int mlx5_wq_ll_create(struct mlx5_core_dev *mdev, struct mlx5_wq_param *param,
 		      void *wqc, struct mlx5_wq_ll *wq,
 		      struct mlx5_wq_ctrl *wq_ctrl);
+void mlx5_wq_ll_reset(struct mlx5_wq_ll *wq);
 
 void mlx5_wq_destroy(struct mlx5_wq_ctrl *wq_ctrl);
 


