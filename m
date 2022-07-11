Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B643056FCC3
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233137AbiGKJr7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233617AbiGKJrc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:47:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35CC65C955;
        Mon, 11 Jul 2022 02:23:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B04ADB80E6D;
        Mon, 11 Jul 2022 09:23:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CE56C34115;
        Mon, 11 Jul 2022 09:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531385;
        bh=3cja/hQNCOn4PAFMjDouotW5Db/OIZC/dXKK3WM6m0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Tfmm++Cn493USQc/yHmaPTzwLwLxI35ewBJ2B3zhj44htUMC5ktAEMJGYvyFoGiI
         +WF/gqOw6uaNP6dHqKhK3hvg3T5ZwQpt0UTkJ1gPHh0lQxCt/WKRLpKIKr1LDQkUJ4
         lgX5O5L7I1Rl4zLA+cYjPpflR0Jejh2kr9e9aih0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eli Cohen <elic@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 084/230] vdpa/mlx5: Avoid processing works if workqueue was destroyed
Date:   Mon, 11 Jul 2022 11:05:40 +0200
Message-Id: <20220711090606.456720798@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

[ Upstream commit ad6dc1daaf29f97f23cc810d60ee01c0e83f4c6b ]

If mlx5_vdpa gets unloaded while a VM is running, the workqueue will be
destroyed. However, vhost might still have reference to the kick
function and might attempt to push new works. This could lead to null
pointer dereference.

To fix this, set mvdev->wq to NULL just before destroying and verify
that the workqueue is not NULL in mlx5_vdpa_kick_vq before attempting to
push a new work.

Fixes: 5262912ef3cf ("vdpa/mlx5: Add support for control VQ and MAC setting")
Signed-off-by: Eli Cohen <elic@nvidia.com>
Link: https://lore.kernel.org/r/20220321141303.9586-1-elic@nvidia.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 174895372e7f..467a349dc26c 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1641,7 +1641,7 @@ static void mlx5_vdpa_kick_vq(struct vdpa_device *vdev, u16 idx)
 		return;
 
 	if (unlikely(is_ctrl_vq_idx(mvdev, idx))) {
-		if (!mvdev->cvq.ready)
+		if (!mvdev->wq || !mvdev->cvq.ready)
 			return;
 
 		queue_work(mvdev->wq, &ndev->cvq_ent.work);
@@ -2626,9 +2626,12 @@ static void mlx5_vdpa_dev_del(struct vdpa_mgmt_dev *v_mdev, struct vdpa_device *
 	struct mlx5_vdpa_mgmtdev *mgtdev = container_of(v_mdev, struct mlx5_vdpa_mgmtdev, mgtdev);
 	struct mlx5_vdpa_dev *mvdev = to_mvdev(dev);
 	struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
+	struct workqueue_struct *wq;
 
 	mlx5_notifier_unregister(mvdev->mdev, &ndev->nb);
-	destroy_workqueue(mvdev->wq);
+	wq = mvdev->wq;
+	mvdev->wq = NULL;
+	destroy_workqueue(wq);
 	_vdpa_unregister_device(dev);
 	mgtdev->ndev = NULL;
 }
-- 
2.35.1



