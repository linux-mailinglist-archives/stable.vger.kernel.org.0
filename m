Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 424844FD87A
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354199AbiDLHic (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353587AbiDLHZr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:25:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDC8043AE8;
        Tue, 12 Apr 2022 00:01:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8905660B65;
        Tue, 12 Apr 2022 07:01:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DAB9C385A1;
        Tue, 12 Apr 2022 07:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746916;
        bh=sUfbTdgOYaBlIvDge6G7uCvBJzdC1rRZljQx/lsDyaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AYASFbbwMFn+qQJFIeMI4b6fjWYIiXTKpk7U50MC7PdZpH/dMsPbiuOMN9gW6CUoB
         qhf8vQDJQKPacRb/8vvm2fesocbTdQ8K1EPfiBVz/Ze4zkHEJrQy5etiIPkI+wZWha
         gsD181TBWFGUluxQ78WvDIzw25uJBGUcXsg8RzSI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, Eli Cohen <elic@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 159/285] vdpa: mlx5: prevent cvq work from hogging CPU
Date:   Tue, 12 Apr 2022 08:30:16 +0200
Message-Id: <20220412062948.260582822@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
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

From: Jason Wang <jasowang@redhat.com>

[ Upstream commit 55ebf0d60e3cc6c9e8593399e185842c00e12f36 ]

A userspace triggerable infinite loop could happen in
mlx5_cvq_kick_handler() if userspace keeps sending a huge amount of
cvq requests.

Fixing this by introducing a quota and re-queue the work if we're out
of the budget (currently the implicit budget is one) . While at it,
using a per device work struct to avoid on demand memory allocation
for cvq.

Fixes: 5262912ef3cfc ("vdpa/mlx5: Add support for control VQ and MAC setting")
Signed-off-by: Jason Wang <jasowang@redhat.com>
Link: https://lore.kernel.org/r/20220329042109.4029-1-jasowang@redhat.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Eli Cohen <elic@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 57bed3d74060..be50c15609b7 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -164,6 +164,7 @@ struct mlx5_vdpa_net {
 	u32 cur_num_vqs;
 	struct notifier_block nb;
 	struct vdpa_callback config_cb;
+	struct mlx5_vdpa_wq_ent cvq_ent;
 };
 
 static void free_resources(struct mlx5_vdpa_net *ndev);
@@ -1627,10 +1628,10 @@ static void mlx5_cvq_kick_handler(struct work_struct *work)
 	ndev = to_mlx5_vdpa_ndev(mvdev);
 	cvq = &mvdev->cvq;
 	if (!(ndev->mvdev.actual_features & BIT_ULL(VIRTIO_NET_F_CTRL_VQ)))
-		goto out;
+		return;
 
 	if (!cvq->ready)
-		goto out;
+		return;
 
 	while (true) {
 		err = vringh_getdesc_iotlb(&cvq->vring, &cvq->riov, &cvq->wiov, &cvq->head,
@@ -1664,9 +1665,10 @@ static void mlx5_cvq_kick_handler(struct work_struct *work)
 
 		if (vringh_need_notify_iotlb(&cvq->vring))
 			vringh_notify(&cvq->vring);
+
+		queue_work(mvdev->wq, &wqent->work);
+		break;
 	}
-out:
-	kfree(wqent);
 }
 
 static void mlx5_vdpa_kick_vq(struct vdpa_device *vdev, u16 idx)
@@ -1674,7 +1676,6 @@ static void mlx5_vdpa_kick_vq(struct vdpa_device *vdev, u16 idx)
 	struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
 	struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
 	struct mlx5_vdpa_virtqueue *mvq;
-	struct mlx5_vdpa_wq_ent *wqent;
 
 	if (!is_index_valid(mvdev, idx))
 		return;
@@ -1683,13 +1684,7 @@ static void mlx5_vdpa_kick_vq(struct vdpa_device *vdev, u16 idx)
 		if (!mvdev->wq || !mvdev->cvq.ready)
 			return;
 
-		wqent = kzalloc(sizeof(*wqent), GFP_ATOMIC);
-		if (!wqent)
-			return;
-
-		wqent->mvdev = mvdev;
-		INIT_WORK(&wqent->work, mlx5_cvq_kick_handler);
-		queue_work(mvdev->wq, &wqent->work);
+		queue_work(mvdev->wq, &ndev->cvq_ent.work);
 		return;
 	}
 
@@ -2634,6 +2629,8 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name,
 	if (err)
 		goto err_mr;
 
+	ndev->cvq_ent.mvdev = mvdev;
+	INIT_WORK(&ndev->cvq_ent.work, mlx5_cvq_kick_handler);
 	mvdev->wq = create_singlethread_workqueue("mlx5_vdpa_wq");
 	if (!mvdev->wq) {
 		err = -ENOMEM;
-- 
2.35.1



