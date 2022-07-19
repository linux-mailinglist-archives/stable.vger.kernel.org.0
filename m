Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40420579E81
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 15:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242676AbiGSNBf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 09:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239253AbiGSNAz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 09:00:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FDAB8AB2E;
        Tue, 19 Jul 2022 05:26:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88B2561952;
        Tue, 19 Jul 2022 12:25:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 563DAC341CA;
        Tue, 19 Jul 2022 12:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233558;
        bh=/S6x7j4GeD6BA8IPzugJ9G79b1PK+pDLuFUQotHkM9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mOSgrgtSofwePLiCfn2JB0Hoj+mHRd9D0EHxIBWop5XwSOwQUWnCqW5bytWaNgJNc
         gokzrOGH3tRcpk4342CDZyJDEeFGZLBtF0S5QvZWqGOW4HHBaAmHS27z/U6+d0Wp9E
         +H17aHTPHnEDEA6C0pcY6fXu/iAKsmIucQlHt33Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eli Cohen <elic@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 163/231] vdpa/mlx5: Initialize CVQ vringh only once
Date:   Tue, 19 Jul 2022 13:54:08 +0200
Message-Id: <20220719114727.905548361@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
 drivers/vdpa/mlx5/net/mlx5_vnet.c |   31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1965,7 +1965,6 @@ static int verify_driver_features(struct
 static int setup_virtqueues(struct mlx5_vdpa_dev *mvdev)
 {
 	struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
-	struct mlx5_control_vq *cvq = &mvdev->cvq;
 	int err;
 	int i;
 
@@ -1975,16 +1974,6 @@ static int setup_virtqueues(struct mlx5_
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
@@ -2257,6 +2246,21 @@ static void clear_vqs_ready(struct mlx5_
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
@@ -2269,6 +2273,11 @@ static void mlx5_vdpa_set_status(struct
 
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


