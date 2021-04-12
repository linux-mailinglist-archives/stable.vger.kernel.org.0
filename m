Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAB3D35C08E
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240265AbhDLJOY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:14:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:35900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240835AbhDLJLE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:11:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95CED61370;
        Mon, 12 Apr 2021 09:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218415;
        bh=qSpw+IehbHJPkTmETvNIQrdRvEi+Ge1jJVOfGcwwQyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bldUGCrM5SrsefuS/WGrx3RQ6O/FxHVH6vytJrc7CPdWonSW/xHsAKIVAGjN3G6xb
         Z/deiQgtsH7rc9av6TY1VTwWJf7ooaixnvWzHpwQ6X8vrosf8NQeiuwHvcZgtzngvw
         UcUqzKvA/kMxJPRCYvj45fO2TiKsf17uCPX3ttck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eli Cohen <elic@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 189/210] vdpa/mlx5: Fix wrong use of bit numbers
Date:   Mon, 12 Apr 2021 10:41:34 +0200
Message-Id: <20210412084022.311874428@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

[ Upstream commit 4b454a82418dd76d8c0590bb3f7a99a63ea57dc5 ]

VIRTIO_F_VERSION_1 is a bit number. Use BIT_ULL() with mask
conditionals.

Also, in mlx5_vdpa_is_little_endian() use BIT_ULL for consistency with
the rest of the code.

Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
Signed-off-by: Eli Cohen <elic@nvidia.com>
Link: https://lore.kernel.org/r/20210408091047.4269-5-elic@nvidia.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 067c3977ea8e..ac6be2d722bb 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -820,7 +820,7 @@ static int create_virtqueue(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtque
 	MLX5_SET(virtio_q, vq_ctx, event_qpn_or_msix, mvq->fwqp.mqp.qpn);
 	MLX5_SET(virtio_q, vq_ctx, queue_size, mvq->num_ent);
 	MLX5_SET(virtio_q, vq_ctx, virtio_version_1_0,
-		 !!(ndev->mvdev.actual_features & VIRTIO_F_VERSION_1));
+		 !!(ndev->mvdev.actual_features & BIT_ULL(VIRTIO_F_VERSION_1)));
 	MLX5_SET64(virtio_q, vq_ctx, desc_addr, mvq->desc_addr);
 	MLX5_SET64(virtio_q, vq_ctx, used_addr, mvq->device_addr);
 	MLX5_SET64(virtio_q, vq_ctx, available_addr, mvq->driver_addr);
@@ -1550,7 +1550,7 @@ static void teardown_virtqueues(struct mlx5_vdpa_net *ndev)
 static inline bool mlx5_vdpa_is_little_endian(struct mlx5_vdpa_dev *mvdev)
 {
 	return virtio_legacy_is_little_endian() ||
-		(mvdev->actual_features & (1ULL << VIRTIO_F_VERSION_1));
+		(mvdev->actual_features & BIT_ULL(VIRTIO_F_VERSION_1));
 }
 
 static __virtio16 cpu_to_mlx5vdpa16(struct mlx5_vdpa_dev *mvdev, u16 val)
-- 
2.30.2



