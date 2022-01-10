Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6D374891CB
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239764AbiAJHgg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:36:36 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60910 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239640AbiAJHc5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:32:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E28F2B81204;
        Mon, 10 Jan 2022 07:32:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F5D1C36AE9;
        Mon, 10 Jan 2022 07:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799974;
        bh=9P1dIeqwCnSv4LDOwZYrLDkkin9SJBgZd7H6EHhP9hc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zrgf6psjfNoLYEI+NL1bOuQPV+rUX1ibYeqIyHKz4mYLfAh4FwNQapnSv8+N9PUPT
         78ep22UcL4ae8hRAnerfVEuLUfQ9KrBK6YFZ+Ncb90QM/ZmxQC0cHLMA31+lrflmjU
         Uc9UCA1Lvwp+/qjoYQIn+BI2it/vd/JJXLgPdTxU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.15 05/72] Revert "RDMA/mlx5: Fix releasing unallocated memory in dereg MR flow"
Date:   Mon, 10 Jan 2022 08:22:42 +0100
Message-Id: <20220110071821.695096216@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071821.500480371@linuxfoundation.org>
References: <20220110071821.500480371@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

commit 4163cb3d1980383220ad7043002b930995dcba33 upstream.

This patch is not the full fix and still causes to call traces
during mlx5_ib_dereg_mr().

This reverts commit f0ae4afe3d35e67db042c58a52909e06262b740f.

Fixes: f0ae4afe3d35 ("RDMA/mlx5: Fix releasing unallocated memory in dereg MR flow")
Link: https://lore.kernel.org/r/20211222101312.1358616-1-maorg@nvidia.com
Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Acked-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |    6 +++---
 drivers/infiniband/hw/mlx5/mr.c      |   28 +++++++++++++++-------------
 2 files changed, 18 insertions(+), 16 deletions(-)

--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -641,6 +641,7 @@ struct mlx5_ib_mr {
 
 	/* User MR data */
 	struct mlx5_cache_ent *cache_ent;
+	struct ib_umem *umem;
 
 	/* This is zero'd when the MR is allocated */
 	union {
@@ -652,7 +653,7 @@ struct mlx5_ib_mr {
 			struct list_head list;
 		};
 
-		/* Used only by kernel MRs */
+		/* Used only by kernel MRs (umem == NULL) */
 		struct {
 			void *descs;
 			void *descs_alloc;
@@ -674,9 +675,8 @@ struct mlx5_ib_mr {
 			int data_length;
 		};
 
-		/* Used only by User MRs */
+		/* Used only by User MRs (umem != NULL) */
 		struct {
-			struct ib_umem *umem;
 			unsigned int page_shift;
 			/* Current access_flags */
 			int access_flags;
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1911,18 +1911,19 @@ err:
 	return ret;
 }
 
-static void mlx5_free_priv_descs(struct mlx5_ib_mr *mr)
+static void
+mlx5_free_priv_descs(struct mlx5_ib_mr *mr)
 {
-	struct mlx5_ib_dev *dev = to_mdev(mr->ibmr.device);
-	int size = mr->max_descs * mr->desc_size;
-
-	if (!mr->descs)
-		return;
-
-	dma_unmap_single(&dev->mdev->pdev->dev, mr->desc_map, size,
-			 DMA_TO_DEVICE);
-	kfree(mr->descs_alloc);
-	mr->descs = NULL;
+	if (!mr->umem && mr->descs) {
+		struct ib_device *device = mr->ibmr.device;
+		int size = mr->max_descs * mr->desc_size;
+		struct mlx5_ib_dev *dev = to_mdev(device);
+
+		dma_unmap_single(&dev->mdev->pdev->dev, mr->desc_map, size,
+				 DMA_TO_DEVICE);
+		kfree(mr->descs_alloc);
+		mr->descs = NULL;
+	}
 }
 
 int mlx5_ib_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
@@ -1998,8 +1999,7 @@ int mlx5_ib_dereg_mr(struct ib_mr *ibmr,
 	if (mr->cache_ent) {
 		mlx5_mr_cache_free(dev, mr);
 	} else {
-		if (!udata)
-			mlx5_free_priv_descs(mr);
+		mlx5_free_priv_descs(mr);
 		kfree(mr);
 	}
 	return 0;
@@ -2086,6 +2086,7 @@ static struct mlx5_ib_mr *mlx5_ib_alloc_
 	if (err)
 		goto err_free_in;
 
+	mr->umem = NULL;
 	kfree(in);
 
 	return mr;
@@ -2212,6 +2213,7 @@ static struct ib_mr *__mlx5_ib_alloc_mr(
 	}
 
 	mr->ibmr.device = pd->device;
+	mr->umem = NULL;
 
 	switch (mr_type) {
 	case IB_MR_TYPE_MEM_REG:


