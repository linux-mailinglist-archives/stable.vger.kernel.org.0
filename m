Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A959534CA1F
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233852AbhC2IfF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:35:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:54146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232392AbhC2Idw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:33:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96F8661613;
        Mon, 29 Mar 2021 08:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006831;
        bh=nlVXogtcGBuGU8ubL0gaiYdxXyGtJjB74KMw3o2+Bz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ph+Yu/9OycREU/2NBXtz1tRjJFOTsSwfDe9MuiSxQA9mnhH7G9EgQgFct/ventjRL
         j54hgvo+9CkCjmveT22z9ZaQ57VH/dMcrNnHpxIU7YZy1OUs1Ujc8IENbH24W2erfH
         EoZQFsw4xKJJUb3RM4DCaByID+o0A/llK3jkte2A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 114/254] net/mlx5e: RX, Mind the MPWQE gaps when calculating offsets
Date:   Mon, 29 Mar 2021 09:57:10 +0200
Message-Id: <20210329075636.962743125@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

[ Upstream commit d5dd03b26ba49c4ffe67ee1937add82293c19794 ]

Since cited patch, MLX5E_REQUIRED_WQE_MTTS is not a power of two.
Hence, usage of MLX5E_LOG_ALIGNED_MPWQE_PPW should be replaced,
as it lost some accuracy. Use the designated macro to calculate
the number of required MTTs.

This makes sure the solution in cited patch works properly.

While here, un-inline mlx5e_get_mpwqe_offset(), and remove the
unused RQ parameter.

Fixes: c3c9402373fe ("net/mlx5e: Add resiliency in Striding RQ mode for packets larger than MTU")
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h      | 7 ++++---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 6 +++---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c   | 4 ++--
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 055baf3b6cb1..f258f2f9b8cf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -90,14 +90,15 @@ struct page_pool;
 				    MLX5_MPWRQ_LOG_WQE_SZ - PAGE_SHIFT : 0)
 #define MLX5_MPWRQ_PAGES_PER_WQE		BIT(MLX5_MPWRQ_WQE_PAGE_ORDER)
 
-#define MLX5_MTT_OCTW(npages) (ALIGN(npages, 8) / 2)
+#define MLX5_ALIGN_MTTS(mtts)		(ALIGN(mtts, 8))
+#define MLX5_ALIGNED_MTTS_OCTW(mtts)	((mtts) / 2)
+#define MLX5_MTT_OCTW(mtts)		(MLX5_ALIGNED_MTTS_OCTW(MLX5_ALIGN_MTTS(mtts)))
 /* Add another page to MLX5E_REQUIRED_WQE_MTTS as a buffer between
  * WQEs, This page will absorb write overflow by the hardware, when
  * receiving packets larger than MTU. These oversize packets are
  * dropped by the driver at a later stage.
  */
-#define MLX5E_REQUIRED_WQE_MTTS		(ALIGN(MLX5_MPWRQ_PAGES_PER_WQE + 1, 8))
-#define MLX5E_LOG_ALIGNED_MPWQE_PPW	(ilog2(MLX5E_REQUIRED_WQE_MTTS))
+#define MLX5E_REQUIRED_WQE_MTTS		(MLX5_ALIGN_MTTS(MLX5_MPWRQ_PAGES_PER_WQE + 1))
 #define MLX5E_REQUIRED_MTTS(wqes)	(wqes * MLX5E_REQUIRED_WQE_MTTS)
 #define MLX5E_MAX_RQ_NUM_MTTS	\
 	((1 << 16) * 2) /* So that MLX5_MTT_OCTW(num_mtts) fits into u16 */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index a2e0b548bf57..e479cce3e2b1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -305,9 +305,9 @@ static int mlx5e_create_rq_umr_mkey(struct mlx5_core_dev *mdev, struct mlx5e_rq
 				     rq->wqe_overflow.addr);
 }
 
-static inline u64 mlx5e_get_mpwqe_offset(struct mlx5e_rq *rq, u16 wqe_ix)
+static u64 mlx5e_get_mpwqe_offset(u16 wqe_ix)
 {
-	return (wqe_ix << MLX5E_LOG_ALIGNED_MPWQE_PPW) << PAGE_SHIFT;
+	return MLX5E_REQUIRED_MTTS(wqe_ix) << PAGE_SHIFT;
 }
 
 static void mlx5e_init_frags_partition(struct mlx5e_rq *rq)
@@ -547,7 +547,7 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 				mlx5_wq_ll_get_wqe(&rq->mpwqe.wq, i);
 			u32 byte_count =
 				rq->mpwqe.num_strides << rq->mpwqe.log_stride_sz;
-			u64 dma_offset = mlx5e_get_mpwqe_offset(rq, i);
+			u64 dma_offset = mlx5e_get_mpwqe_offset(i);
 
 			wqe->data[0].addr = cpu_to_be64(dma_offset + rq->buff.headroom);
 			wqe->data[0].byte_count = cpu_to_be32(byte_count);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 4864deed9dc9..b2e71a045df0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -505,7 +505,6 @@ static int mlx5e_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 	struct mlx5e_icosq *sq = rq->icosq;
 	struct mlx5_wq_cyc *wq = &sq->wq;
 	struct mlx5e_umr_wqe *umr_wqe;
-	u16 xlt_offset = ix << (MLX5E_LOG_ALIGNED_MPWQE_PPW - 1);
 	u16 pi;
 	int err;
 	int i;
@@ -536,7 +535,8 @@ static int mlx5e_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 	umr_wqe->ctrl.opmod_idx_opcode =
 		cpu_to_be32((sq->pc << MLX5_WQE_CTRL_WQE_INDEX_SHIFT) |
 			    MLX5_OPCODE_UMR);
-	umr_wqe->uctrl.xlt_offset = cpu_to_be16(xlt_offset);
+	umr_wqe->uctrl.xlt_offset =
+		cpu_to_be16(MLX5_ALIGNED_MTTS_OCTW(MLX5E_REQUIRED_MTTS(ix)));
 
 	sq->db.wqe_info[pi] = (struct mlx5e_icosq_wqe_info) {
 		.wqe_type   = MLX5E_ICOSQ_WQE_UMR_RX,
-- 
2.30.1



