Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26185313798
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233904AbhBHP2T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:28:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:34484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233850AbhBHPXF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:23:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D01464F09;
        Mon,  8 Feb 2021 15:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797269;
        bh=jZ7ExKafJxxJlGLWKVfTaRsVizOfvA8Ossn4Vwy5mW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m9y4QV2bFrbp0Nq8iQILM11qy62ZgplVKOVmbitB9029CXj3/QPhVGpiB/Ufw2fxP
         B9Wiz+/fCwil9toaprHyTdM6kqNVPp4hv3lJ+3yhSArIt2i+0EuhlZeDUStjs01i6q
         inuXGbcRZhlQEqXreIlsR5C6OsbQ4BQCyc8c4buc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eli Cohen <elic@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 050/120] vdpa/mlx5: Restore the hardware used index after change map
Date:   Mon,  8 Feb 2021 16:00:37 +0100
Message-Id: <20210208145820.424239345@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

[ Upstream commit b35ccebe3ef76168aa2edaa35809c0232cb3578e ]

When a change of memory map occurs, the hardware resources are destroyed
and then re-created again with the new memory map. In such case, we need
to restore the hardware available and used indices. The driver failed to
restore the used index which is added here.

Also, since the driver also fails to reset the available and used
indices upon device reset, fix this here to avoid regression caused by
the fact that used index may not be zero upon device reset.

Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
Signed-off-by: Eli Cohen <elic@nvidia.com>
Link: https://lore.kernel.org/r/20210204073618.36336-1-elic@nvidia.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 81b932f72e103..c6529f7c3034a 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -77,6 +77,7 @@ struct mlx5_vq_restore_info {
 	u64 device_addr;
 	u64 driver_addr;
 	u16 avail_index;
+	u16 used_index;
 	bool ready;
 	struct vdpa_callback cb;
 	bool restore;
@@ -111,6 +112,7 @@ struct mlx5_vdpa_virtqueue {
 	u32 virtq_id;
 	struct mlx5_vdpa_net *ndev;
 	u16 avail_idx;
+	u16 used_idx;
 	int fw_state;
 
 	/* keep last in the struct */
@@ -789,6 +791,7 @@ static int create_virtqueue(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtque
 
 	obj_context = MLX5_ADDR_OF(create_virtio_net_q_in, in, obj_context);
 	MLX5_SET(virtio_net_q_object, obj_context, hw_available_index, mvq->avail_idx);
+	MLX5_SET(virtio_net_q_object, obj_context, hw_used_index, mvq->used_idx);
 	MLX5_SET(virtio_net_q_object, obj_context, queue_feature_bit_mask_12_3,
 		 get_features_12_3(ndev->mvdev.actual_features));
 	vq_ctx = MLX5_ADDR_OF(virtio_net_q_object, obj_context, virtio_q_context);
@@ -1007,6 +1010,7 @@ static int connect_qps(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *m
 struct mlx5_virtq_attr {
 	u8 state;
 	u16 available_index;
+	u16 used_index;
 };
 
 static int query_virtqueue(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *mvq,
@@ -1037,6 +1041,7 @@ static int query_virtqueue(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueu
 	memset(attr, 0, sizeof(*attr));
 	attr->state = MLX5_GET(virtio_net_q_object, obj_context, state);
 	attr->available_index = MLX5_GET(virtio_net_q_object, obj_context, hw_available_index);
+	attr->used_index = MLX5_GET(virtio_net_q_object, obj_context, hw_used_index);
 	kfree(out);
 	return 0;
 
@@ -1520,6 +1525,16 @@ static void teardown_virtqueues(struct mlx5_vdpa_net *ndev)
 	}
 }
 
+static void clear_virtqueues(struct mlx5_vdpa_net *ndev)
+{
+	int i;
+
+	for (i = ndev->mvdev.max_vqs - 1; i >= 0; i--) {
+		ndev->vqs[i].avail_idx = 0;
+		ndev->vqs[i].used_idx = 0;
+	}
+}
+
 /* TODO: cross-endian support */
 static inline bool mlx5_vdpa_is_little_endian(struct mlx5_vdpa_dev *mvdev)
 {
@@ -1595,6 +1610,7 @@ static int save_channel_info(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqu
 		return err;
 
 	ri->avail_index = attr.available_index;
+	ri->used_index = attr.used_index;
 	ri->ready = mvq->ready;
 	ri->num_ent = mvq->num_ent;
 	ri->desc_addr = mvq->desc_addr;
@@ -1639,6 +1655,7 @@ static void restore_channels_info(struct mlx5_vdpa_net *ndev)
 			continue;
 
 		mvq->avail_idx = ri->avail_index;
+		mvq->used_idx = ri->used_index;
 		mvq->ready = ri->ready;
 		mvq->num_ent = ri->num_ent;
 		mvq->desc_addr = ri->desc_addr;
@@ -1753,6 +1770,7 @@ static void mlx5_vdpa_set_status(struct vdpa_device *vdev, u8 status)
 	if (!status) {
 		mlx5_vdpa_info(mvdev, "performing device reset\n");
 		teardown_driver(ndev);
+		clear_virtqueues(ndev);
 		mlx5_vdpa_destroy_mr(&ndev->mvdev);
 		ndev->mvdev.status = 0;
 		ndev->mvdev.mlx_features = 0;
-- 
2.27.0



