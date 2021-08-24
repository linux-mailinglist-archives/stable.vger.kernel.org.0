Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26A5D3F63CB
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 18:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235006AbhHXQ6P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 12:58:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:39904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235058AbhHXQ5j (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:57:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C48B613CD;
        Tue, 24 Aug 2021 16:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824215;
        bh=g6z1Lohinjih3WRXAyaW2kqJCtU6sF3Ef+SMQxbI5dg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DWcZkwZ+JvRT7f2lRTHf7nnbXhi82wR1TYSP9ziNOS9lfaN4hxhrVagE6HeAAmjsd
         sQwy/D4Ijbss3onwolymlr3PSosv/HrWDQJsQ/YHP3bvAzRX/jUvLCzThIc0hEz5PM
         v0GwYphf2r38Gi8OwwHYjh3mOsEPiw+5z68euZm4o7ihdaXKuU78X3RJ9FtMhIBgxI
         dQ7bMLbHgLJLVPCitaAF8iWXK5y8hwlDBK2YFzhJMMinf/M9qHTmCcmGe+IBFX4gMH
         xZ4nicyr+Wzurm3aw5eNyY/eq80DLV7oEZQFU6zOeFiS00F2zlwmxvcih2IPsWySFY
         wIA6DRC8iPs4Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eli Cohen <elic@nvidia.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 047/127] vdpa/mlx5: Fix queue type selection logic
Date:   Tue, 24 Aug 2021 12:54:47 -0400
Message-Id: <20210824165607.709387-48-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

[ Upstream commit 879753c816dbbdb2a9a395aa4448d29feee92d1a ]

get_queue_type() comments that splict virtqueue is preferred, however,
the actual logic preferred packed virtqueues. Since firmware has not
supported packed virtqueues we ended up using split virtqueues as was
desired.

Since we do not advertise support for packed virtqueues, we add a check
to verify split virtqueues are indeed supported.

Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
Signed-off-by: Eli Cohen <elic@nvidia.com>
Link: https://lore.kernel.org/r/20210811053759.66752-1-elic@nvidia.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c  | 14 ++++++++++----
 include/linux/mlx5/mlx5_ifc_vdpa.h | 10 ++++++----
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index f3495386698a..103d8f70df8e 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -752,12 +752,12 @@ static int get_queue_type(struct mlx5_vdpa_net *ndev)
 	type_mask = MLX5_CAP_DEV_VDPA_EMULATION(ndev->mvdev.mdev, virtio_queue_type);
 
 	/* prefer split queue */
-	if (type_mask & MLX5_VIRTIO_EMULATION_CAP_VIRTIO_QUEUE_TYPE_PACKED)
-		return MLX5_VIRTIO_EMULATION_VIRTIO_QUEUE_TYPE_PACKED;
+	if (type_mask & MLX5_VIRTIO_EMULATION_CAP_VIRTIO_QUEUE_TYPE_SPLIT)
+		return MLX5_VIRTIO_EMULATION_VIRTIO_QUEUE_TYPE_SPLIT;
 
-	WARN_ON(!(type_mask & MLX5_VIRTIO_EMULATION_CAP_VIRTIO_QUEUE_TYPE_SPLIT));
+	WARN_ON(!(type_mask & MLX5_VIRTIO_EMULATION_CAP_VIRTIO_QUEUE_TYPE_PACKED));
 
-	return MLX5_VIRTIO_EMULATION_VIRTIO_QUEUE_TYPE_SPLIT;
+	return MLX5_VIRTIO_EMULATION_VIRTIO_QUEUE_TYPE_PACKED;
 }
 
 static bool vq_is_tx(u16 idx)
@@ -2010,6 +2010,12 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name)
 		return -ENOSPC;
 
 	mdev = mgtdev->madev->mdev;
+	if (!(MLX5_CAP_DEV_VDPA_EMULATION(mdev, virtio_queue_type) &
+	    MLX5_VIRTIO_EMULATION_CAP_VIRTIO_QUEUE_TYPE_SPLIT)) {
+		dev_warn(mdev->device, "missing support for split virtqueues\n");
+		return -EOPNOTSUPP;
+	}
+
 	/* we save one virtqueue for control virtqueue should we require it */
 	max_vqs = MLX5_CAP_DEV_VDPA_EMULATION(mdev, max_num_virtio_queues);
 	max_vqs = min_t(u32, max_vqs, MLX5_MAX_SUPPORTED_VQS);
diff --git a/include/linux/mlx5/mlx5_ifc_vdpa.h b/include/linux/mlx5/mlx5_ifc_vdpa.h
index 98b56b75c625..1a9c9d94cb59 100644
--- a/include/linux/mlx5/mlx5_ifc_vdpa.h
+++ b/include/linux/mlx5/mlx5_ifc_vdpa.h
@@ -11,13 +11,15 @@ enum {
 };
 
 enum {
-	MLX5_VIRTIO_EMULATION_CAP_VIRTIO_QUEUE_TYPE_SPLIT   = 0x1, // do I check this caps?
-	MLX5_VIRTIO_EMULATION_CAP_VIRTIO_QUEUE_TYPE_PACKED  = 0x2,
+	MLX5_VIRTIO_EMULATION_VIRTIO_QUEUE_TYPE_SPLIT   = 0,
+	MLX5_VIRTIO_EMULATION_VIRTIO_QUEUE_TYPE_PACKED  = 1,
 };
 
 enum {
-	MLX5_VIRTIO_EMULATION_VIRTIO_QUEUE_TYPE_SPLIT   = 0,
-	MLX5_VIRTIO_EMULATION_VIRTIO_QUEUE_TYPE_PACKED  = 1,
+	MLX5_VIRTIO_EMULATION_CAP_VIRTIO_QUEUE_TYPE_SPLIT =
+		BIT(MLX5_VIRTIO_EMULATION_VIRTIO_QUEUE_TYPE_SPLIT),
+	MLX5_VIRTIO_EMULATION_CAP_VIRTIO_QUEUE_TYPE_PACKED =
+		BIT(MLX5_VIRTIO_EMULATION_VIRTIO_QUEUE_TYPE_PACKED),
 };
 
 struct mlx5_ifc_virtio_q_bits {
-- 
2.30.2

