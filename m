Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4377D3289BC
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234106AbhCASDn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:03:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:49712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239171AbhCAR6k (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:58:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9176164F69;
        Mon,  1 Mar 2021 17:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621001;
        bh=5D5Os2E3gmyiC64OXCXDIEJM2RRq3WmeRwFNxDlTmeA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aZMqLRvPFJeaYnknPu2iW2kkJ8yv4c9XmuV7My+qaTHIAaplReAXrn+TuJ6/iEwCS
         2adsj/H1gXuN9s0aff9/7h5y/8ZjXm1UxgVep3JgHfsmYEKaL4SCO6Art4aAKJajHH
         dXpfqRp13kIZquD1zxRvpS2Z6Av9SKDgHtleD7yI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 357/775] IB/mlx5: Add mutex destroy call to cap_mask_mutex mutex
Date:   Mon,  1 Mar 2021 17:08:45 +0100
Message-Id: <20210301161219.261610609@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

[ Upstream commit ab40530a2e0a7aca9a5187824c4fb072f3916e85 ]

mutex_destroy() call for device's cap_mask_mutex mutex is missing, let's
add it to annotate destruction.

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Link: https://lore.kernel.org/r/20210113121703.559778-4-leon@kernel.org
Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index aabdc07e47537..9b772457286f2 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3927,7 +3927,7 @@ static void mlx5_ib_stage_init_cleanup(struct mlx5_ib_dev *dev)
 	mlx5_ib_cleanup_multiport_master(dev);
 	WARN_ON(!xa_empty(&dev->odp_mkeys));
 	cleanup_srcu_struct(&dev->odp_srcu);
-
+	mutex_destroy(&dev->cap_mask_mutex);
 	WARN_ON(!xa_empty(&dev->sig_mrs));
 	WARN_ON(!bitmap_empty(dev->dm.memic_alloc_pages, MLX5_MAX_MEMIC_PAGES));
 }
@@ -3978,6 +3978,10 @@ static int mlx5_ib_stage_init_init(struct mlx5_ib_dev *dev)
 	dev->ib_dev.dev.parent		= mdev->device;
 	dev->ib_dev.lag_flags		= RDMA_LAG_FLAGS_HASH_ALL_SLAVES;
 
+	err = init_srcu_struct(&dev->odp_srcu);
+	if (err)
+		goto err_mp;
+
 	mutex_init(&dev->cap_mask_mutex);
 	INIT_LIST_HEAD(&dev->qp_list);
 	spin_lock_init(&dev->reset_flow_resource_lock);
@@ -3987,11 +3991,6 @@ static int mlx5_ib_stage_init_init(struct mlx5_ib_dev *dev)
 
 	spin_lock_init(&dev->dm.lock);
 	dev->dm.dev = mdev;
-
-	err = init_srcu_struct(&dev->odp_srcu);
-	if (err)
-		goto err_mp;
-
 	return 0;
 
 err_mp:
-- 
2.27.0



