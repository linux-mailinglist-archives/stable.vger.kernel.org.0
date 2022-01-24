Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4F32499016
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359281AbiAXT6O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:58:14 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49486 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345444AbiAXTv7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:51:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A71960FE0;
        Mon, 24 Jan 2022 19:51:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E478C340E5;
        Mon, 24 Jan 2022 19:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053917;
        bh=JWqpxqKlVhff/kyKeh/XNYbKg6VwUJvBcSXp1JJWZ5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OsGwV+OZiIVh+zAJgO4uKYXAtoYVcllmSEel/pJph8orK49aVVLFXDz0kHHDk/c3y
         09FXitVC4sDuRh7AEKT0SWuCKVqKHwbjw5bq98oUHJMEZVWvzl/8KRpjAtuNxm6twE
         ThpZgewVOw50GZA2BMtufhZ2B5FqbPg6MLwFZoXk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 220/563] net/mlx5e: Fix page DMA map/unmap attributes
Date:   Mon, 24 Jan 2022 19:39:45 +0100
Message-Id: <20220124184032.056935072@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

[ Upstream commit 0b7cfa4082fbf550595bc0e40f05614bd83bf0cd ]

Driver initiates DMA sync, hence it may skip CPU sync. Add
DMA_ATTR_SKIP_CPU_SYNC as input attribute both to dma_map_page and
dma_unmap_page to avoid redundant sync with the CPU.
When forcing the device to work with SWIOTLB, the extra sync might cause
data corruption. The driver unmaps the whole page while the hardware
used just a part of the bounce buffer. So syncing overrides the entire
page with bounce buffer that only partially contains real data.

Fixes: bc77b240b3c5 ("net/mlx5e: Add fragmented memory support for RX multi packet WQE")
Fixes: db05815b36cb ("net/mlx5e: Add XSK zero-copy support")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.c | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c       | 7 ++++---
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.c
index 71e8d66fa1509..6692bc8333f73 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.c
@@ -11,13 +11,13 @@ static int mlx5e_xsk_map_pool(struct mlx5e_priv *priv,
 {
 	struct device *dev = mlx5_core_dma_dev(priv->mdev);
 
-	return xsk_pool_dma_map(pool, dev, 0);
+	return xsk_pool_dma_map(pool, dev, DMA_ATTR_SKIP_CPU_SYNC);
 }
 
 static void mlx5e_xsk_unmap_pool(struct mlx5e_priv *priv,
 				 struct xsk_buff_pool *pool)
 {
-	return xsk_pool_dma_unmap(pool, 0);
+	return xsk_pool_dma_unmap(pool, DMA_ATTR_SKIP_CPU_SYNC);
 }
 
 static int mlx5e_xsk_get_pools(struct mlx5e_xsk *xsk)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 117a593414537..d384403d73f69 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -276,8 +276,8 @@ static inline int mlx5e_page_alloc_pool(struct mlx5e_rq *rq,
 	if (unlikely(!dma_info->page))
 		return -ENOMEM;
 
-	dma_info->addr = dma_map_page(rq->pdev, dma_info->page, 0,
-				      PAGE_SIZE, rq->buff.map_dir);
+	dma_info->addr = dma_map_page_attrs(rq->pdev, dma_info->page, 0, PAGE_SIZE,
+					    rq->buff.map_dir, DMA_ATTR_SKIP_CPU_SYNC);
 	if (unlikely(dma_mapping_error(rq->pdev, dma_info->addr))) {
 		page_pool_recycle_direct(rq->page_pool, dma_info->page);
 		dma_info->page = NULL;
@@ -298,7 +298,8 @@ static inline int mlx5e_page_alloc(struct mlx5e_rq *rq,
 
 void mlx5e_page_dma_unmap(struct mlx5e_rq *rq, struct mlx5e_dma_info *dma_info)
 {
-	dma_unmap_page(rq->pdev, dma_info->addr, PAGE_SIZE, rq->buff.map_dir);
+	dma_unmap_page_attrs(rq->pdev, dma_info->addr, PAGE_SIZE, rq->buff.map_dir,
+			     DMA_ATTR_SKIP_CPU_SYNC);
 }
 
 void mlx5e_page_release_dynamic(struct mlx5e_rq *rq,
-- 
2.34.1



