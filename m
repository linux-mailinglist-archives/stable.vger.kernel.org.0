Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFEE64F138D
	for <lists+stable@lfdr.de>; Mon,  4 Apr 2022 13:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358884AbiDDLDi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 07:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236147AbiDDLDh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 07:03:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B4593D1CE
        for <stable@vger.kernel.org>; Mon,  4 Apr 2022 04:01:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A9E6160B2D
        for <stable@vger.kernel.org>; Mon,  4 Apr 2022 11:01:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1331C2BBE4;
        Mon,  4 Apr 2022 11:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649070101;
        bh=HCb8V/LWx4nQOou1s40BnxIhOFiWL0TYmCIqCURGR6g=;
        h=Subject:To:Cc:From:Date:From;
        b=U69YwdIrEd+USNTI2CZJNJQJEiVW4mdbtoln9REZnLHTquMLqry497V8vnfmcJZhS
         L600k0ahyoP6FxwDLAeSM9qra/5sL44GmKmLUSz7Tv+ugXkQKZUtkawQNPmSmtQ9Hq
         fYv6H4eRrOAtnR+/f7/6Qk/AdjO0jVfXXeVIBRYs=
Subject: FAILED: patch "[PATCH] vdpa/mlx5: Avoid processing works if workqueue was destroyed" failed to apply to 5.15-stable tree
To:     elic@nvidia.com, mst@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 Apr 2022 13:01:38 +0200
Message-ID: <16490700981919@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ad6dc1daaf29f97f23cc810d60ee01c0e83f4c6b Mon Sep 17 00:00:00 2001
From: Eli Cohen <elic@nvidia.com>
Date: Mon, 21 Mar 2022 16:13:03 +0200
Subject: [PATCH] vdpa/mlx5: Avoid processing works if workqueue was destroyed

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

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index c0f0ecb82c6f..2f4fb09f1e89 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1712,7 +1712,7 @@ static void mlx5_vdpa_kick_vq(struct vdpa_device *vdev, u16 idx)
 		return;
 
 	if (unlikely(is_ctrl_vq_idx(mvdev, idx))) {
-		if (!mvdev->cvq.ready)
+		if (!mvdev->wq || !mvdev->cvq.ready)
 			return;
 
 		wqent = kzalloc(sizeof(*wqent), GFP_ATOMIC);
@@ -2779,9 +2779,12 @@ static void mlx5_vdpa_dev_del(struct vdpa_mgmt_dev *v_mdev, struct vdpa_device *
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

