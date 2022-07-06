Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA4A2568D0F
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 17:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234001AbiGFPcw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 11:32:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234021AbiGFPc3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 11:32:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2432228712;
        Wed,  6 Jul 2022 08:32:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A299F61FBE;
        Wed,  6 Jul 2022 15:32:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B260C3411C;
        Wed,  6 Jul 2022 15:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657121524;
        bh=y6aJHwCIQHyCu5/Fc4D/l0yJ7hgPW18XIm1lCNu9rnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E2Td0r0LFkLPZIsdjvYAmMookNHwCeThctur9B1khBtajvzCTXHoHbUPdDRmnbUXw
         2Z4HShYtAY4szK7BCGlni8FMaEksfjEYIhKZiN+fSCpO3xhM5vUPsoAXIqP2pZEm+c
         nkdCTvfWPb52RhCsfWN0XHODcIOzJTauiiYLeutreCFvN6QQpAT8L6BhuRYM/UOCw4
         ok/wYSEcO8j0/mdCg45kggrGDtExsvj+k+D54M472gIrCH5tNcGX/zINV98+2hUZgX
         1QKs6v6xhZQkOITdZFL6YRXzGCKCqIF80NP8yFyirGxHatp77BhFFVVz6Aw4nRLSbz
         6Ll1EaygV57cg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eli Cohen <elic@nvidia.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
        Sasha Levin <sashal@kernel.org>, si-wei.liu@oracle.com,
        parav@nvidia.com, virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.15 03/18] vdpa/mlx5: Initialize CVQ vringh only once
Date:   Wed,  6 Jul 2022 11:31:38 -0400
Message-Id: <20220706153153.1598076-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220706153153.1598076-1-sashal@kernel.org>
References: <20220706153153.1598076-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

[ Upstream commit ace9252446ec615cd79a5f77d90edb25c0b9d024 ]

Currently, CVQ vringh is initialized inside setup_virtqueues() which is
called every time a memory update is done. This is undesirable since it
resets all the context of the vring, including the available and used
indices.

Move the initialization to mlx5_vdpa_set_status() when
VIRTIO_CONFIG_S_DRIVER_OK is set.

Signed-off-by: Eli Cohen <elic@nvidia.com>
Message-Id: <20220613075958.511064-2-elic@nvidia.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index e4258f40dcd7..26bd5bba0d89 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1896,7 +1896,6 @@ static int verify_driver_features(struct mlx5_vdpa_dev *mvdev, u64 features)
 static int setup_virtqueues(struct mlx5_vdpa_dev *mvdev)
 {
 	struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
-	struct mlx5_control_vq *cvq = &mvdev->cvq;
 	int err;
 	int i;
 
@@ -1906,16 +1905,6 @@ static int setup_virtqueues(struct mlx5_vdpa_dev *mvdev)
 			goto err_vq;
 	}
 
-	if (mvdev->actual_features & BIT_ULL(VIRTIO_NET_F_CTRL_VQ)) {
-		err = vringh_init_iotlb(&cvq->vring, mvdev->actual_features,
-					MLX5_CVQ_MAX_ENT, false,
-					(struct vring_desc *)(uintptr_t)cvq->desc_addr,
-					(struct vring_avail *)(uintptr_t)cvq->driver_addr,
-					(struct vring_used *)(uintptr_t)cvq->device_addr);
-		if (err)
-			goto err_vq;
-	}
-
 	return 0;
 
 err_vq:
@@ -2182,6 +2171,21 @@ static void clear_vqs_ready(struct mlx5_vdpa_net *ndev)
 	ndev->mvdev.cvq.ready = false;
 }
 
+static int setup_cvq_vring(struct mlx5_vdpa_dev *mvdev)
+{
+	struct mlx5_control_vq *cvq = &mvdev->cvq;
+	int err = 0;
+
+	if (mvdev->actual_features & BIT_ULL(VIRTIO_NET_F_CTRL_VQ))
+		err = vringh_init_iotlb(&cvq->vring, mvdev->actual_features,
+					MLX5_CVQ_MAX_ENT, false,
+					(struct vring_desc *)(uintptr_t)cvq->desc_addr,
+					(struct vring_avail *)(uintptr_t)cvq->driver_addr,
+					(struct vring_used *)(uintptr_t)cvq->device_addr);
+
+	return err;
+}
+
 static void mlx5_vdpa_set_status(struct vdpa_device *vdev, u8 status)
 {
 	struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
@@ -2192,6 +2196,11 @@ static void mlx5_vdpa_set_status(struct vdpa_device *vdev, u8 status)
 
 	if ((status ^ ndev->mvdev.status) & VIRTIO_CONFIG_S_DRIVER_OK) {
 		if (status & VIRTIO_CONFIG_S_DRIVER_OK) {
+			err = setup_cvq_vring(mvdev);
+			if (err) {
+				mlx5_vdpa_warn(mvdev, "failed to setup control VQ vring\n");
+				goto err_setup;
+			}
 			err = setup_driver(mvdev);
 			if (err) {
 				mlx5_vdpa_warn(mvdev, "failed to setup driver\n");
-- 
2.35.1

