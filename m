Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20E4F4FD206
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 09:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351223AbiDLHKC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:10:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352313AbiDLHFJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:05:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1C02473AC;
        Mon, 11 Apr 2022 23:48:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9FDCF60A21;
        Tue, 12 Apr 2022 06:48:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1975C385A6;
        Tue, 12 Apr 2022 06:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746080;
        bh=5c7qbwUg4dhWQv9ZheJcLAo+7noBOw8SDyf2a6K/Dws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k3/rxo10Es0i6JtjuROMkO7YdX+y3JgwXchohxgJcq2Aop9JkntNk/tvYjaJ+WwYA
         EH2ANXZR5+iX0tjekHC7mb6EZsOJt5OI5taNs/p4yfCLM+3b+mT4gfDMENDNBL49vW
         gpt+olEEtlhLeNkcPKo9p4t4u0n80061RCsiu7Rk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eli Cohen <elic@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 154/277] vdpa/mlx5: Rename control VQ workqueue to vdpa wq
Date:   Tue, 12 Apr 2022 08:29:17 +0200
Message-Id: <20220412062946.496512297@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

[ Upstream commit 218bdd20e56cab41a68481bc10c551ae3e0a24fb ]

A subesequent patch will use the same workqueue for executing other
work not related to control VQ. Rename the workqueue and the work queue
entry used to convey information to the workqueue.

Signed-off-by: Eli Cohen <elic@nvidia.com>
Link: https://lore.kernel.org/r/20210909123635.30884-3-elic@nvidia.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/mlx5/core/mlx5_vdpa.h | 2 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c  | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/vdpa/mlx5/core/mlx5_vdpa.h b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
index 01a848adf590..81dc3d88d3dd 100644
--- a/drivers/vdpa/mlx5/core/mlx5_vdpa.h
+++ b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
@@ -63,7 +63,7 @@ struct mlx5_control_vq {
 	unsigned short head;
 };
 
-struct mlx5_ctrl_wq_ent {
+struct mlx5_vdpa_wq_ent {
 	struct work_struct work;
 	struct mlx5_vdpa_dev *mvdev;
 };
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index f77a611f592f..f769e2dc6d26 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1573,14 +1573,14 @@ static void mlx5_cvq_kick_handler(struct work_struct *work)
 {
 	virtio_net_ctrl_ack status = VIRTIO_NET_ERR;
 	struct virtio_net_ctrl_hdr ctrl;
-	struct mlx5_ctrl_wq_ent *wqent;
+	struct mlx5_vdpa_wq_ent *wqent;
 	struct mlx5_vdpa_dev *mvdev;
 	struct mlx5_control_vq *cvq;
 	struct mlx5_vdpa_net *ndev;
 	size_t read, write;
 	int err;
 
-	wqent = container_of(work, struct mlx5_ctrl_wq_ent, work);
+	wqent = container_of(work, struct mlx5_vdpa_wq_ent, work);
 	mvdev = wqent->mvdev;
 	ndev = to_mlx5_vdpa_ndev(mvdev);
 	cvq = &mvdev->cvq;
@@ -1632,7 +1632,7 @@ static void mlx5_vdpa_kick_vq(struct vdpa_device *vdev, u16 idx)
 	struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
 	struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
 	struct mlx5_vdpa_virtqueue *mvq;
-	struct mlx5_ctrl_wq_ent *wqent;
+	struct mlx5_vdpa_wq_ent *wqent;
 
 	if (!is_index_valid(mvdev, idx))
 		return;
@@ -2502,7 +2502,7 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name)
 	if (err)
 		goto err_mr;
 
-	mvdev->wq = create_singlethread_workqueue("mlx5_vdpa_ctrl_wq");
+	mvdev->wq = create_singlethread_workqueue("mlx5_vdpa_wq");
 	if (!mvdev->wq) {
 		err = -ENOMEM;
 		goto err_res2;
-- 
2.35.1



