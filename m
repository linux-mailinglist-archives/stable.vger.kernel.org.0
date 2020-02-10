Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2D93157692
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:54:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728899AbgBJMxt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:53:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:45744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729897AbgBJMmG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:42:06 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA82B20842;
        Mon, 10 Feb 2020 12:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338526;
        bh=wZcMO2tu8w2eY4XZ1yipvYTxWGcWDcjVgr/IrqJgojQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GoGt8ujRNU6OB+Fcf3iX7QHNOozphI6s+s8f445W+tLKytK+ioC1iIbjajOmaPtku
         2ccoxDi+CYXunRVSHbLFXgCJW8mKVkBw6HLl+YISkMlCjSFHi1O2Ez/fOtF2rmjalO
         Dzg7ueIoABDb5c5ije2r7otwkp7XS6DZYwEBCf+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.5 346/367] net/mlx5e: TX, Error completion is for last WQE in batch
Date:   Mon, 10 Feb 2020 04:34:19 -0800
Message-Id: <20200210122454.504171842@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

[ Upstream commit b57e66ad42d051ed31319c28ed1b62b191299a29 ]

For a cyclic work queue, when not requesting a completion per WQE,
a single CQE might indicate the completion of several WQEs.
However, in case some WQE in the batch causes an error, then an error
completion is issued, breaking the batch, and pointing to the offending
WQE in the wqe_counter field.

Hence, WQE-specific error CQE handling (like printing, breaking, etc...)
should be performed only for the last WQE in batch.

Fixes: 130c7b46c93d ("net/mlx5e: TX, Dump WQs wqe descriptors on CQE with error events")
Fixes: fd9b4be8002c ("net/mlx5e: RX, Support multiple outstanding UMR posts")
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c |   16 ++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c |   33 ++++++++++--------------
 2 files changed, 23 insertions(+), 26 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -613,13 +613,6 @@ void mlx5e_poll_ico_cq(struct mlx5e_cq *
 
 		wqe_counter = be16_to_cpu(cqe->wqe_counter);
 
-		if (unlikely(get_cqe_opcode(cqe) != MLX5_CQE_REQ)) {
-			netdev_WARN_ONCE(cq->channel->netdev,
-					 "Bad OP in ICOSQ CQE: 0x%x\n", get_cqe_opcode(cqe));
-			if (!test_and_set_bit(MLX5E_SQ_STATE_RECOVERING, &sq->state))
-				queue_work(cq->channel->priv->wq, &sq->recover_work);
-			break;
-		}
 		do {
 			struct mlx5e_sq_wqe_info *wi;
 			u16 ci;
@@ -629,6 +622,15 @@ void mlx5e_poll_ico_cq(struct mlx5e_cq *
 			ci = mlx5_wq_cyc_ctr2ix(&sq->wq, sqcc);
 			wi = &sq->db.ico_wqe[ci];
 
+			if (last_wqe && unlikely(get_cqe_opcode(cqe) != MLX5_CQE_REQ)) {
+				netdev_WARN_ONCE(cq->channel->netdev,
+						 "Bad OP in ICOSQ CQE: 0x%x\n",
+						 get_cqe_opcode(cqe));
+				if (!test_and_set_bit(MLX5E_SQ_STATE_RECOVERING, &sq->state))
+					queue_work(cq->channel->priv->wq, &sq->recover_work);
+				break;
+			}
+
 			if (likely(wi->opcode == MLX5_OPCODE_UMR)) {
 				sqcc += MLX5E_UMR_WQEBBS;
 				wi->umr.rq->mpwqe.umr_completed++;
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -451,34 +451,17 @@ bool mlx5e_poll_tx_cq(struct mlx5e_cq *c
 
 	i = 0;
 	do {
+		struct mlx5e_tx_wqe_info *wi;
 		u16 wqe_counter;
 		bool last_wqe;
+		u16 ci;
 
 		mlx5_cqwq_pop(&cq->wq);
 
 		wqe_counter = be16_to_cpu(cqe->wqe_counter);
 
-		if (unlikely(get_cqe_opcode(cqe) == MLX5_CQE_REQ_ERR)) {
-			if (!test_and_set_bit(MLX5E_SQ_STATE_RECOVERING,
-					      &sq->state)) {
-				struct mlx5e_tx_wqe_info *wi;
-				u16 ci;
-
-				ci = mlx5_wq_cyc_ctr2ix(&sq->wq, sqcc);
-				wi = &sq->db.wqe_info[ci];
-				mlx5e_dump_error_cqe(sq,
-						     (struct mlx5_err_cqe *)cqe);
-				mlx5_wq_cyc_wqe_dump(&sq->wq, ci, wi->num_wqebbs);
-				queue_work(cq->channel->priv->wq,
-					   &sq->recover_work);
-			}
-			stats->cqe_err++;
-		}
-
 		do {
-			struct mlx5e_tx_wqe_info *wi;
 			struct sk_buff *skb;
-			u16 ci;
 			int j;
 
 			last_wqe = (sqcc == wqe_counter);
@@ -516,6 +499,18 @@ bool mlx5e_poll_tx_cq(struct mlx5e_cq *c
 			napi_consume_skb(skb, napi_budget);
 		} while (!last_wqe);
 
+		if (unlikely(get_cqe_opcode(cqe) == MLX5_CQE_REQ_ERR)) {
+			if (!test_and_set_bit(MLX5E_SQ_STATE_RECOVERING,
+					      &sq->state)) {
+				mlx5e_dump_error_cqe(sq,
+						     (struct mlx5_err_cqe *)cqe);
+				mlx5_wq_cyc_wqe_dump(&sq->wq, ci, wi->num_wqebbs);
+				queue_work(cq->channel->priv->wq,
+					   &sq->recover_work);
+			}
+			stats->cqe_err++;
+		}
+
 	} while ((++i < MLX5E_TX_CQ_POLL_BUDGET) && (cqe = mlx5_cqwq_get_cqe(&cq->wq)));
 
 	stats->cqes += i;


