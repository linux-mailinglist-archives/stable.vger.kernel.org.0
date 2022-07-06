Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14178568D04
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 17:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233712AbiGFPa4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 11:30:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233274AbiGFPay (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 11:30:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83DFF1EC49;
        Wed,  6 Jul 2022 08:30:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2322061FDB;
        Wed,  6 Jul 2022 15:30:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95330C3411C;
        Wed,  6 Jul 2022 15:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657121452;
        bh=iV5ZZQrFXrNWeuWkNiulO784lH1m5ZZ2FXPHiNAMDoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sWPlmUVDcS1ye1X9D6XnjUou88BtlbvOvjt31h2TBewmQvSdf69imwL/glPd8yT11
         x0U2++N4z1emzEzRD6cjyyMnYmXTuTuVGf5MqqJwdsAu3br5LlHGHfTJREzs+mT2mB
         40bcxp+WzN9nbEMvW0SJwr/zFh4kdlZpGe0s8VdxDsz1pWp5HJXlHh1rDpXdj0ZrHy
         gle+PNmijMhRxLCYVABxRNbL6t5PE/TcraAWIJdKWd4FBaVWWjL3/qHxnE3Z4qUmsF
         y8cJCUezvooPVW49yDyXWxU9yr9w2PdpvZEoPG69Pj+Xd5FFPxyjhf9/bDS3FgyQ/Y
         3pvtFpIZpyvJA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eli Cohen <elic@nvidia.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
        Sasha Levin <sashal@kernel.org>, si-wei.liu@oracle.com,
        parav@nvidia.com, virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.18 03/22] vdpa/mlx5: Initialize CVQ vringh only once
Date:   Wed,  6 Jul 2022 11:30:21 -0400
Message-Id: <20220706153041.1597639-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220706153041.1597639-1-sashal@kernel.org>
References: <20220706153041.1597639-1-sashal@kernel.org>
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
index e0de44000d92..2baab94bf806 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1963,7 +1963,6 @@ static int verify_driver_features(struct mlx5_vdpa_dev *mvdev, u64 features)
 static int setup_virtqueues(struct mlx5_vdpa_dev *mvdev)
 {
 	struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
-	struct mlx5_control_vq *cvq = &mvdev->cvq;
 	int err;
 	int i;
 
@@ -1973,16 +1972,6 @@ static int setup_virtqueues(struct mlx5_vdpa_dev *mvdev)
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
@@ -2255,6 +2244,21 @@ static void clear_vqs_ready(struct mlx5_vdpa_net *ndev)
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
@@ -2267,6 +2271,11 @@ static void mlx5_vdpa_set_status(struct vdpa_device *vdev, u8 status)
 
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

