Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9AF99BF1
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389177AbfHVR3j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:29:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:51898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404709AbfHVR0W (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:26:22 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24A8123400;
        Thu, 22 Aug 2019 17:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494781;
        bh=1ef54Wz6oTG9M9lo7GxIVZQNAACCAZay0ehgnDw6om4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jdxA+tmKnbTYN4dQJ9NLaJjHfC20kX0tZe+3Y85+RG40v/nZEh7ORLVly3BAlr/VZ
         y0F7QdFbCHNUqpV5Q+rSa/awHJZzYmQduZl9k7UOZalx8j9m9hsjsUx3ZLiiwe8bV/
         ZbwosgChe+5PCPDgKdIXW9RuKrZD9RltPHeRBW0s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guy Levi <guyle@mellanox.com>,
        Moni Shoua <monis@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 47/85] IB/mlx5: Fix MR registration flow to use UMR properly
Date:   Thu, 22 Aug 2019 10:19:20 -0700
Message-Id: <20190822171733.330417503@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171731.012687054@linuxfoundation.org>
References: <20190822171731.012687054@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit e5366d309a772fef264ec85e858f9ea46f939848 ]

Driver shouldn't allow to use UMR to register a MR when
umr_modify_atomic_disabled is set. Otherwise it will always end up with a
failure in the post send flow which sets the UMR WQE to modify atomic access
right.

Fixes: c8d75a980fab ("IB/mlx5: Respect new UMR capabilities")
Signed-off-by: Guy Levi <guyle@mellanox.com>
Reviewed-by: Moni Shoua <monis@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Link: https://lore.kernel.org/r/20190731081929.32559-1-leon@kernel.org
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mr.c | 27 +++++++++------------------
 1 file changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 9bab4fb65c688..bd1fdadf7ba01 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -51,22 +51,12 @@ static void clean_mr(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr);
 static void dereg_mr(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr);
 static int mr_cache_max_order(struct mlx5_ib_dev *dev);
 static int unreg_umr(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr);
-static bool umr_can_modify_entity_size(struct mlx5_ib_dev *dev)
-{
-	return !MLX5_CAP_GEN(dev->mdev, umr_modify_entity_size_disabled);
-}
 
 static bool umr_can_use_indirect_mkey(struct mlx5_ib_dev *dev)
 {
 	return !MLX5_CAP_GEN(dev->mdev, umr_indirect_mkey_disabled);
 }
 
-static bool use_umr(struct mlx5_ib_dev *dev, int order)
-{
-	return order <= mr_cache_max_order(dev) &&
-		umr_can_modify_entity_size(dev);
-}
-
 static int destroy_mkey(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)
 {
 	int err = mlx5_core_destroy_mkey(dev->mdev, &mr->mmkey);
@@ -1305,7 +1295,7 @@ struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 {
 	struct mlx5_ib_dev *dev = to_mdev(pd->device);
 	struct mlx5_ib_mr *mr = NULL;
-	bool populate_mtts = false;
+	bool use_umr;
 	struct ib_umem *umem;
 	int page_shift;
 	int npages;
@@ -1338,29 +1328,30 @@ struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	if (err < 0)
 		return ERR_PTR(err);
 
-	if (use_umr(dev, order)) {
+	use_umr = !MLX5_CAP_GEN(dev->mdev, umr_modify_entity_size_disabled) &&
+		  (!MLX5_CAP_GEN(dev->mdev, umr_modify_atomic_disabled) ||
+		   !MLX5_CAP_GEN(dev->mdev, atomic));
+
+	if (order <= mr_cache_max_order(dev) && use_umr) {
 		mr = alloc_mr_from_cache(pd, umem, virt_addr, length, ncont,
 					 page_shift, order, access_flags);
 		if (PTR_ERR(mr) == -EAGAIN) {
 			mlx5_ib_dbg(dev, "cache empty for order %d\n", order);
 			mr = NULL;
 		}
-		populate_mtts = false;
 	} else if (!MLX5_CAP_GEN(dev->mdev, umr_extended_translation_offset)) {
 		if (access_flags & IB_ACCESS_ON_DEMAND) {
 			err = -EINVAL;
 			pr_err("Got MR registration for ODP MR > 512MB, not supported for Connect-IB\n");
 			goto error;
 		}
-		populate_mtts = true;
+		use_umr = false;
 	}
 
 	if (!mr) {
-		if (!umr_can_modify_entity_size(dev))
-			populate_mtts = true;
 		mutex_lock(&dev->slow_path_mutex);
 		mr = reg_create(NULL, pd, virt_addr, length, umem, ncont,
-				page_shift, access_flags, populate_mtts);
+				page_shift, access_flags, !use_umr);
 		mutex_unlock(&dev->slow_path_mutex);
 	}
 
@@ -1378,7 +1369,7 @@ struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	update_odp_mr(mr);
 #endif
 
-	if (!populate_mtts) {
+	if (use_umr) {
 		int update_xlt_flags = MLX5_IB_UPD_XLT_ENABLE;
 
 		if (access_flags & IB_ACCESS_ON_DEMAND)
-- 
2.20.1



