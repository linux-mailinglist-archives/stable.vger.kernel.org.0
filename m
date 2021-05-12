Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C669737CD6E
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240295AbhELQzA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:55:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:35726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243890AbhELQmM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C396961C3E;
        Wed, 12 May 2021 16:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835684;
        bh=EStRgdP/kimlmT/HkRgP/9diHzu9zuvwh7DDa2WFJGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O1gYFnHGULqzkCoWa6bSGT6C+2U2Q3znrm33JpeeZ9DwPQHCGc5ImOy6NhVm4yxey
         sAdte3m6H6rJvR1ib8fDTYn+ISiYCLG6+XODh88o8GFYEA+qZMijKe5DiIr9/d0uEL
         sdB1q/dqIjoUFyAtQfKtm2L2naD9d+9tLQ0ctw/A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 442/677] RDMA/mlx5: Zero out ODP related items in the mlx5_ib_mr
Date:   Wed, 12 May 2021 16:48:08 +0200
Message-Id: <20210512144852.027630366@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit a639e66703ee45745dc4057c7c2013ed9e1963a7 ]

All of the ODP code assumes when it calls mlx5_mr_cache_alloc() the ODP
related fields are zero'd. This is true if the MR was just allocated, but
if the MR is recycled through the cache then the values are never zero'd.

This causes a bug in the odp_stats, they don't reset when the MR is
reallocated, also is_odp_implicit is never 0'd.

So we can use memset on a block of the mlx5_ib_mr reorganize the structure
to put all the data that can be zero'd by the cache at the end.

It is organized as an anonymous struct because the next patch will make
this a union.

Delete the unused smr_info. Don't set the kernel only desc_size on the
user path. No longer any need to zero mr->parent before freeing it, the
memset() will get it now.

Fixes: a3de94e3d61e ("IB/mlx5: Introduce ODP diagnostic counters")
Link: https://lore.kernel.org/r/20210304120745.1090751-2-leon@kernel.org
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 103 ++++++++++++++++-----------
 drivers/infiniband/hw/mlx5/mr.c      |  14 ++--
 drivers/infiniband/hw/mlx5/odp.c     |   1 -
 3 files changed, 66 insertions(+), 52 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 88cc26e008fc..b085c02b53d0 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -547,11 +547,6 @@ static inline const struct mlx5_umr_wr *umr_wr(const struct ib_send_wr *wr)
 	return container_of(wr, struct mlx5_umr_wr, wr);
 }
 
-struct mlx5_shared_mr_info {
-	int mr_id;
-	struct ib_umem		*umem;
-};
-
 enum mlx5_ib_cq_pr_flags {
 	MLX5_IB_CQ_PR_FLAGS_CQE_128_PAD	= 1 << 0,
 };
@@ -654,47 +649,69 @@ struct mlx5_ib_dm {
 	atomic64_add(value, &((mr)->odp_stats.counter_name))
 
 struct mlx5_ib_mr {
-	struct ib_mr		ibmr;
-	void			*descs;
-	dma_addr_t		desc_map;
-	int			ndescs;
-	int			data_length;
-	int			meta_ndescs;
-	int			meta_length;
-	int			max_descs;
-	int			desc_size;
-	int			access_mode;
-	unsigned int		page_shift;
-	struct mlx5_core_mkey	mmkey;
-	struct ib_umem	       *umem;
-	struct mlx5_shared_mr_info	*smr_info;
-	struct list_head	list;
-	struct mlx5_cache_ent  *cache_ent;
-	u32 out[MLX5_ST_SZ_DW(create_mkey_out)];
-	struct mlx5_core_sig_ctx    *sig;
-	void			*descs_alloc;
-	int			access_flags; /* Needed for rereg MR */
-
-	struct mlx5_ib_mr      *parent;
-	/* Needed for IB_MR_TYPE_INTEGRITY */
-	struct mlx5_ib_mr      *pi_mr;
-	struct mlx5_ib_mr      *klm_mr;
-	struct mlx5_ib_mr      *mtt_mr;
-	u64			data_iova;
-	u64			pi_iova;
-
-	/* For ODP and implicit */
-	struct xarray		implicit_children;
-	union {
-		struct list_head elm;
-		struct work_struct work;
-	} odp_destroy;
-	struct ib_odp_counters	odp_stats;
-	bool			is_odp_implicit;
+	struct ib_mr ibmr;
+	struct mlx5_core_mkey mmkey;
 
-	struct mlx5_async_work  cb_work;
+	/* User MR data */
+	struct mlx5_cache_ent *cache_ent;
+	struct ib_umem *umem;
+
+	/* This is zero'd when the MR is allocated */
+	struct {
+		/* Used only while the MR is in the cache */
+		struct {
+			u32 out[MLX5_ST_SZ_DW(create_mkey_out)];
+			struct mlx5_async_work cb_work;
+			/* Cache list element */
+			struct list_head list;
+		};
+
+		/* Used only by kernel MRs (umem == NULL) */
+		struct {
+			void *descs;
+			void *descs_alloc;
+			dma_addr_t desc_map;
+			int max_descs;
+			int ndescs;
+			int desc_size;
+			int access_mode;
+
+			/* For Kernel IB_MR_TYPE_INTEGRITY */
+			struct mlx5_core_sig_ctx *sig;
+			struct mlx5_ib_mr *pi_mr;
+			struct mlx5_ib_mr *klm_mr;
+			struct mlx5_ib_mr *mtt_mr;
+			u64 data_iova;
+			u64 pi_iova;
+			int meta_ndescs;
+			int meta_length;
+			int data_length;
+		};
+
+		/* Used only by User MRs (umem != NULL) */
+		struct {
+			unsigned int page_shift;
+			/* Current access_flags */
+			int access_flags;
+
+			/* For User ODP */
+			struct mlx5_ib_mr *parent;
+			struct xarray implicit_children;
+			union {
+				struct work_struct work;
+			} odp_destroy;
+			struct ib_odp_counters odp_stats;
+			bool is_odp_implicit;
+		};
+	};
 };
 
+/* Zero the fields in the mr that are variant depending on usage */
+static inline void mlx5_clear_mr(struct mlx5_ib_mr *mr)
+{
+	memset(mr->out, 0, sizeof(*mr) - offsetof(struct mlx5_ib_mr, out));
+}
+
 static inline bool is_odp_mr(struct mlx5_ib_mr *mr)
 {
 	return IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING) && mr->umem &&
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index db05b0e0a8d7..ea8f068a6da3 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -590,6 +590,8 @@ struct mlx5_ib_mr *mlx5_mr_cache_alloc(struct mlx5_ib_dev *dev,
 		ent->available_mrs--;
 		queue_adjust_cache_locked(ent);
 		spin_unlock_irq(&ent->lock);
+
+		mlx5_clear_mr(mr);
 	}
 	mr->access_flags = access_flags;
 	return mr;
@@ -615,16 +617,14 @@ static struct mlx5_ib_mr *get_cache_mr(struct mlx5_cache_ent *req_ent)
 			ent->available_mrs--;
 			queue_adjust_cache_locked(ent);
 			spin_unlock_irq(&ent->lock);
-			break;
+			mlx5_clear_mr(mr);
+			return mr;
 		}
 		queue_adjust_cache_locked(ent);
 		spin_unlock_irq(&ent->lock);
 	}
-
-	if (!mr)
-		req_ent->miss++;
-
-	return mr;
+	req_ent->miss++;
+	return NULL;
 }
 
 static void detach_mr_from_cache(struct mlx5_ib_mr *mr)
@@ -993,8 +993,6 @@ static struct mlx5_ib_mr *alloc_cacheable_mr(struct ib_pd *pd,
 
 	mr->ibmr.pd = pd;
 	mr->umem = umem;
-	mr->access_flags = access_flags;
-	mr->desc_size = sizeof(struct mlx5_mtt);
 	mr->mmkey.iova = iova;
 	mr->mmkey.size = umem->length;
 	mr->mmkey.pd = to_mpd(pd)->pdn;
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index b103555b1f5d..d98755e78362 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -227,7 +227,6 @@ static void free_implicit_child_mr(struct mlx5_ib_mr *mr, bool need_imr_xlt)
 
 	dma_fence_odp_mr(mr);
 
-	mr->parent = NULL;
 	mlx5_mr_cache_free(mr_to_mdev(mr), mr);
 	ib_umem_odp_release(odp);
 }
-- 
2.30.2



