Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8BB676F7A
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231280AbjAVPWN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:22:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231283AbjAVPWM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:22:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B51F22791
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:21:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B6BEB80B22
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:21:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 765DAC433AC;
        Sun, 22 Jan 2023 15:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400909;
        bh=D6s/yyyaUWdS5aQRr0KLWg1UG3ODLc97Z3aGGYAuOFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZTpQN1vk7j6V+Rpics61wnhQ7lXS47f7Pbeurm7XcTItyFVO5auFV8PrRVzMJ4R0I
         o62blBNXE+CqvWheiGnxgvive7/w1terpilGY8lTLOJGDoXT+cFyIK8AB3olgLyVZ3
         SoDp7TphiPOIAsjWIrB8yZaTh2LJYm2h/lh3Vpes=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eli Cohen <elic@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 009/193] vdpa/mlx5: Avoid using reslock in event_handler
Date:   Sun, 22 Jan 2023 16:02:18 +0100
Message-Id: <20230122150246.800880121@linuxfoundation.org>
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

[ Upstream commit 0dbc1b4ae07d003b2e88ba9d4142846320f8e349 ]

event_handler runs under atomic context and may not acquire reslock. We
can still guarantee that the handler won't be called after suspend by
clearing nb_registered, unregistering the handler and flushing the
workqueue.

Signed-off-by: Eli Cohen <elic@nvidia.com>
Message-Id: <20221114131759.57883-5-elic@nvidia.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index b06260a37680..98dd8ce8af26 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -2845,8 +2845,8 @@ static int mlx5_vdpa_suspend(struct vdpa_device *vdev)
 	int i;
 
 	down_write(&ndev->reslock);
-	mlx5_notifier_unregister(mvdev->mdev, &ndev->nb);
 	ndev->nb_registered = false;
+	mlx5_notifier_unregister(mvdev->mdev, &ndev->nb);
 	flush_workqueue(ndev->mvdev.wq);
 	for (i = 0; i < ndev->cur_num_vqs; i++) {
 		mvq = &ndev->vqs[i];
@@ -3024,7 +3024,7 @@ static void update_carrier(struct work_struct *work)
 	else
 		ndev->config.status &= cpu_to_mlx5vdpa16(mvdev, ~VIRTIO_NET_S_LINK_UP);
 
-	if (ndev->config_cb.callback)
+	if (ndev->nb_registered && ndev->config_cb.callback)
 		ndev->config_cb.callback(ndev->config_cb.private);
 
 	kfree(wqent);
@@ -3041,21 +3041,13 @@ static int event_handler(struct notifier_block *nb, unsigned long event, void *p
 		switch (eqe->sub_type) {
 		case MLX5_PORT_CHANGE_SUBTYPE_DOWN:
 		case MLX5_PORT_CHANGE_SUBTYPE_ACTIVE:
-			down_read(&ndev->reslock);
-			if (!ndev->nb_registered) {
-				up_read(&ndev->reslock);
-				return NOTIFY_DONE;
-			}
 			wqent = kzalloc(sizeof(*wqent), GFP_ATOMIC);
-			if (!wqent) {
-				up_read(&ndev->reslock);
+			if (!wqent)
 				return NOTIFY_DONE;
-			}
 
 			wqent->mvdev = &ndev->mvdev;
 			INIT_WORK(&wqent->work, update_carrier);
 			queue_work(ndev->mvdev.wq, &wqent->work);
-			up_read(&ndev->reslock);
 			ret = NOTIFY_OK;
 			break;
 		default:
@@ -3242,8 +3234,8 @@ static void mlx5_vdpa_dev_del(struct vdpa_mgmt_dev *v_mdev, struct vdpa_device *
 	struct workqueue_struct *wq;
 
 	if (ndev->nb_registered) {
-		mlx5_notifier_unregister(mvdev->mdev, &ndev->nb);
 		ndev->nb_registered = false;
+		mlx5_notifier_unregister(mvdev->mdev, &ndev->nb);
 	}
 	wq = mvdev->wq;
 	mvdev->wq = NULL;
-- 
2.35.1



