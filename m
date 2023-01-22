Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4779676F5D
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbjAVPUj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:20:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbjAVPUi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:20:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68128222E0
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:20:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA58060C60
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:20:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09587C433D2;
        Sun, 22 Jan 2023 15:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400836;
        bh=UqXp53oU3zQWgoQ910DrFsF/0ayLrNVzM54tgD6afJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rL+xG2h4KyQ2ewU/DIq4lF6c3LEtFBb7DSXv0Hih2Ql37nOow4MeQcpJJe6H/NHsl
         LxiJf04cLLaB1ni2x4uWnMbohy403C+MqTzInhnu+HN37CN6M4z2E2K6w/RRi9Ma1Z
         QCnjSkL0AAttX1NU2NacJ9OCSgQDHIzQnC1QVJS0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
        Eli Cohen <elic@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 010/193] vdpa/mlx5: Avoid overwriting CVQ iotlb
Date:   Sun, 22 Jan 2023 16:02:19 +0100
Message-Id: <20230122150246.835409914@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

[ Upstream commit 38fc462f57ef4e5dc722bab6824854b105de8aa2 ]

When qemu uses different address spaces for data and control virtqueues,
the current code would overwrite the control virtqueue iotlb through the
dup_iotlb call. Fix this by referring to the address space identifier
and the group to asid mapping to determine which mapping needs to be
updated. We also move the address space logic from mlx5 net to core
directory.

Reported-by: Eugenio Pérez <eperezma@redhat.com>
Signed-off-by: Eli Cohen <elic@nvidia.com>
Message-Id: <20221114131759.57883-6-elic@nvidia.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/mlx5/core/mlx5_vdpa.h |  5 +--
 drivers/vdpa/mlx5/core/mr.c        | 44 ++++++++++++++++-----------
 drivers/vdpa/mlx5/net/mlx5_vnet.c  | 49 ++++++------------------------
 3 files changed, 39 insertions(+), 59 deletions(-)

diff --git a/drivers/vdpa/mlx5/core/mlx5_vdpa.h b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
index 6af9fdbb86b7..058fbe28107e 100644
--- a/drivers/vdpa/mlx5/core/mlx5_vdpa.h
+++ b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
@@ -116,8 +116,9 @@ int mlx5_vdpa_create_mkey(struct mlx5_vdpa_dev *mvdev, u32 *mkey, u32 *in,
 			  int inlen);
 int mlx5_vdpa_destroy_mkey(struct mlx5_vdpa_dev *mvdev, u32 mkey);
 int mlx5_vdpa_handle_set_map(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *iotlb,
-			     bool *change_map);
-int mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *iotlb);
+			     bool *change_map, unsigned int asid);
+int mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *iotlb,
+			unsigned int asid);
 void mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev);
 
 #define mlx5_vdpa_warn(__dev, format, ...)                                                         \
diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
index a639b9208d41..a4d7ee2339fa 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -511,7 +511,8 @@ void mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev)
 	mutex_unlock(&mr->mkey_mtx);
 }
 
-static int _mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *iotlb)
+static int _mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev,
+				struct vhost_iotlb *iotlb, unsigned int asid)
 {
 	struct mlx5_vdpa_mr *mr = &mvdev->mr;
 	int err;
@@ -519,42 +520,49 @@ static int _mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb
 	if (mr->initialized)
 		return 0;
 
-	if (iotlb)
-		err = create_user_mr(mvdev, iotlb);
-	else
-		err = create_dma_mr(mvdev, mr);
+	if (mvdev->group2asid[MLX5_VDPA_DATAVQ_GROUP] == asid) {
+		if (iotlb)
+			err = create_user_mr(mvdev, iotlb);
+		else
+			err = create_dma_mr(mvdev, mr);
 
-	if (err)
-		return err;
+		if (err)
+			return err;
+	}
 
-	err = dup_iotlb(mvdev, iotlb);
-	if (err)
-		goto out_err;
+	if (mvdev->group2asid[MLX5_VDPA_CVQ_GROUP] == asid) {
+		err = dup_iotlb(mvdev, iotlb);
+		if (err)
+			goto out_err;
+	}
 
 	mr->initialized = true;
 	return 0;
 
 out_err:
-	if (iotlb)
-		destroy_user_mr(mvdev, mr);
-	else
-		destroy_dma_mr(mvdev, mr);
+	if (mvdev->group2asid[MLX5_VDPA_DATAVQ_GROUP] == asid) {
+		if (iotlb)
+			destroy_user_mr(mvdev, mr);
+		else
+			destroy_dma_mr(mvdev, mr);
+	}
 
 	return err;
 }
 
-int mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *iotlb)
+int mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *iotlb,
+			unsigned int asid)
 {
 	int err;
 
 	mutex_lock(&mvdev->mr.mkey_mtx);
-	err = _mlx5_vdpa_create_mr(mvdev, iotlb);
+	err = _mlx5_vdpa_create_mr(mvdev, iotlb, asid);
 	mutex_unlock(&mvdev->mr.mkey_mtx);
 	return err;
 }
 
 int mlx5_vdpa_handle_set_map(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *iotlb,
-			     bool *change_map)
+			     bool *change_map, unsigned int asid)
 {
 	struct mlx5_vdpa_mr *mr = &mvdev->mr;
 	int err = 0;
@@ -566,7 +574,7 @@ int mlx5_vdpa_handle_set_map(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *io
 		*change_map = true;
 	}
 	if (!*change_map)
-		err = _mlx5_vdpa_create_mr(mvdev, iotlb);
+		err = _mlx5_vdpa_create_mr(mvdev, iotlb, asid);
 	mutex_unlock(&mr->mkey_mtx);
 
 	return err;
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 98dd8ce8af26..3a6dbbc6440d 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -2394,7 +2394,8 @@ static void restore_channels_info(struct mlx5_vdpa_net *ndev)
 	}
 }
 
-static int mlx5_vdpa_change_map(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *iotlb)
+static int mlx5_vdpa_change_map(struct mlx5_vdpa_dev *mvdev,
+				struct vhost_iotlb *iotlb, unsigned int asid)
 {
 	struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
 	int err;
@@ -2406,7 +2407,7 @@ static int mlx5_vdpa_change_map(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb
 
 	teardown_driver(ndev);
 	mlx5_vdpa_destroy_mr(mvdev);
-	err = mlx5_vdpa_create_mr(mvdev, iotlb);
+	err = mlx5_vdpa_create_mr(mvdev, iotlb, asid);
 	if (err)
 		goto err_mr;
 
@@ -2587,7 +2588,7 @@ static int mlx5_vdpa_reset(struct vdpa_device *vdev)
 	++mvdev->generation;
 
 	if (MLX5_CAP_GEN(mvdev->mdev, umem_uid_0)) {
-		if (mlx5_vdpa_create_mr(mvdev, NULL))
+		if (mlx5_vdpa_create_mr(mvdev, NULL, 0))
 			mlx5_vdpa_warn(mvdev, "create MR failed\n");
 	}
 	up_write(&ndev->reslock);
@@ -2623,41 +2624,20 @@ static u32 mlx5_vdpa_get_generation(struct vdpa_device *vdev)
 	return mvdev->generation;
 }
 
-static int set_map_control(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *iotlb)
-{
-	u64 start = 0ULL, last = 0ULL - 1;
-	struct vhost_iotlb_map *map;
-	int err = 0;
-
-	spin_lock(&mvdev->cvq.iommu_lock);
-	vhost_iotlb_reset(mvdev->cvq.iotlb);
-
-	for (map = vhost_iotlb_itree_first(iotlb, start, last); map;
-	     map = vhost_iotlb_itree_next(map, start, last)) {
-		err = vhost_iotlb_add_range(mvdev->cvq.iotlb, map->start,
-					    map->last, map->addr, map->perm);
-		if (err)
-			goto out;
-	}
-
-out:
-	spin_unlock(&mvdev->cvq.iommu_lock);
-	return err;
-}
-
-static int set_map_data(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *iotlb)
+static int set_map_data(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *iotlb,
+			unsigned int asid)
 {
 	bool change_map;
 	int err;
 
-	err = mlx5_vdpa_handle_set_map(mvdev, iotlb, &change_map);
+	err = mlx5_vdpa_handle_set_map(mvdev, iotlb, &change_map, asid);
 	if (err) {
 		mlx5_vdpa_warn(mvdev, "set map failed(%d)\n", err);
 		return err;
 	}
 
 	if (change_map)
-		err = mlx5_vdpa_change_map(mvdev, iotlb);
+		err = mlx5_vdpa_change_map(mvdev, iotlb, asid);
 
 	return err;
 }
@@ -2670,16 +2650,7 @@ static int mlx5_vdpa_set_map(struct vdpa_device *vdev, unsigned int asid,
 	int err = -EINVAL;
 
 	down_write(&ndev->reslock);
-	if (mvdev->group2asid[MLX5_VDPA_DATAVQ_GROUP] == asid) {
-		err = set_map_data(mvdev, iotlb);
-		if (err)
-			goto out;
-	}
-
-	if (mvdev->group2asid[MLX5_VDPA_CVQ_GROUP] == asid)
-		err = set_map_control(mvdev, iotlb);
-
-out:
+	err = set_map_data(mvdev, iotlb, asid);
 	up_write(&ndev->reslock);
 	return err;
 }
@@ -3182,7 +3153,7 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name,
 		goto err_mpfs;
 
 	if (MLX5_CAP_GEN(mvdev->mdev, umem_uid_0)) {
-		err = mlx5_vdpa_create_mr(mvdev, NULL);
+		err = mlx5_vdpa_create_mr(mvdev, NULL, 0);
 		if (err)
 			goto err_res;
 	}
-- 
2.35.1



