Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 145073CE401
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347557AbhGSPln (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:41:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:57568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347672AbhGSPfO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC061613DF;
        Mon, 19 Jul 2021 16:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711164;
        bh=nmDQb14vqsWx45S6KLOXM72coRqCzzmh9BgKba6W3uY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ot/xvJFbFGZ8f8ha2UwiGxOLb67CKBMPHlWcPzbLbVa3ZnmeZVAkM10b/UWIHDS+5
         J0tFNt4Hl7itQlLy8HHhAPEMcAXi2/9HoF8Jr8i9m4vPtgwvSlNTCLew+l+AvZDea9
         a2KF7QUklu4cI11nwt9P279Ucj0uFbgxHxCUQVwg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eli Cohen <elic@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 252/351] vdp/mlx5: Fix setting the correct dma_device
Date:   Mon, 19 Jul 2021 16:53:18 +0200
Message-Id: <20210719144953.290541145@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

[ Upstream commit 7d23dcdf213c2e5f097eb7eec3148c26eb01d59f ]

Before SF support was introduced, the DMA device was equal to
mdev->device which was in essence equal to pdev->dev.

With SF introduction this is no longer true. It has already been
handled for vhost_vdpa since the reference to the dma device can from
within mlx5_vdpa. With virtio_vdpa this broke. To fix this we set the
real dma device when initializing the device.

In addition, for the sake of consistency, previous references in the
code to the dma device are changed to vdev->dma_dev.

Fixes: d13a15d544ce5 ("vdpa/mlx5: Use the correct dma device when registering memory")
Signed-off-by: Eli Cohen <elic@nvidia.com>
Link: https://lore.kernel.org/r/20210606053150.170489-1-elic@nvidia.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/mlx5/core/mr.c       | 9 ++-------
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 2 +-
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
index 800cfd1967ad..cfa56a58b271 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -219,11 +219,6 @@ static void destroy_indirect_key(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_m
 	mlx5_vdpa_destroy_mkey(mvdev, &mkey->mkey);
 }
 
-static struct device *get_dma_device(struct mlx5_vdpa_dev *mvdev)
-{
-	return &mvdev->mdev->pdev->dev;
-}
-
 static int map_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_direct_mr *mr,
 			 struct vhost_iotlb *iotlb)
 {
@@ -239,7 +234,7 @@ static int map_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_direct_mr
 	u64 pa;
 	u64 paend;
 	struct scatterlist *sg;
-	struct device *dma = get_dma_device(mvdev);
+	struct device *dma = mvdev->vdev.dma_dev;
 
 	for (map = vhost_iotlb_itree_first(iotlb, mr->start, mr->end - 1);
 	     map; map = vhost_iotlb_itree_next(map, start, mr->end - 1)) {
@@ -298,7 +293,7 @@ err_map:
 
 static void unmap_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_direct_mr *mr)
 {
-	struct device *dma = get_dma_device(mvdev);
+	struct device *dma = mvdev->vdev.dma_dev;
 
 	destroy_direct_mr(mvdev, mr);
 	dma_unmap_sg_attrs(dma, mr->sg_head.sgl, mr->nsg, DMA_BIDIRECTIONAL, 0);
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 01eb6c100d2d..2b74e34fbdec 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -2032,7 +2032,7 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name)
 			goto err_mtu;
 	}
 
-	mvdev->vdev.dma_dev = mdev->device;
+	mvdev->vdev.dma_dev = &mdev->pdev->dev;
 	err = mlx5_vdpa_alloc_resources(&ndev->mvdev);
 	if (err)
 		goto err_mpfs;
-- 
2.30.2



