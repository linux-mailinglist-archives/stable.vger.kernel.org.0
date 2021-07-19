Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16E5D3CE3AC
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346573AbhGSPiy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:38:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:57480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347671AbhGSPfO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A77B261482;
        Mon, 19 Jul 2021 16:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711159;
        bh=NPdrI0ezOAiL18rjwiUHllirS9GRnTBSDr8QlUB8wYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h+e8Oa7W2iWteosy4NhwCFDCFWkRUYjkwVybW+/dBoxxSZlVKY7dNmVI1xa9NCx58
         ZSzwWLa/jax2Xj2HY/BCXHUarg2wDIU1QsOKsjJHbLEyu/xCN6YtC895Ferm8vs7jf
         mej3Y1+hrSgeAbnVfzvwLvZbfsanNAhL+5Y5ZrlM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eli Cohen <elic@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 250/351] vdpa/mlx5: Fix umem sizes assignments on VQ create
Date:   Mon, 19 Jul 2021 16:53:16 +0200
Message-Id: <20210719144953.229163716@linuxfoundation.org>
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

[ Upstream commit e3011776af16caf423f2c36d0047acd624c274fa ]

Fix copy paste bug assigning umem1 size to umem2 and umem3. The issue
was discovered when trying to use a 1:1 MR that covers the entire
address space where firmware complained that provided sizes are not
large enough. 1:1 MRs are required to support virtio_vdpa.

Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
Signed-off-by: Eli Cohen <elic@nvidia.com>
Link: https://lore.kernel.org/r/20210530090317.8284-1-elic@nvidia.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index dda5dc6f7737..e8865e6adf37 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -829,9 +829,9 @@ static int create_virtqueue(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtque
 	MLX5_SET(virtio_q, vq_ctx, umem_1_id, mvq->umem1.id);
 	MLX5_SET(virtio_q, vq_ctx, umem_1_size, mvq->umem1.size);
 	MLX5_SET(virtio_q, vq_ctx, umem_2_id, mvq->umem2.id);
-	MLX5_SET(virtio_q, vq_ctx, umem_2_size, mvq->umem1.size);
+	MLX5_SET(virtio_q, vq_ctx, umem_2_size, mvq->umem2.size);
 	MLX5_SET(virtio_q, vq_ctx, umem_3_id, mvq->umem3.id);
-	MLX5_SET(virtio_q, vq_ctx, umem_3_size, mvq->umem1.size);
+	MLX5_SET(virtio_q, vq_ctx, umem_3_size, mvq->umem3.size);
 	MLX5_SET(virtio_q, vq_ctx, pd, ndev->mvdev.res.pdn);
 	if (MLX5_CAP_DEV_VDPA_EMULATION(ndev->mvdev.mdev, eth_frame_offload_type))
 		MLX5_SET(virtio_q, vq_ctx, virtio_version_1_0, 1);
-- 
2.30.2



