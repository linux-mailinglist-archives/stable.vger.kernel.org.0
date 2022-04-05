Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 238454F3246
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238267AbiDEIoA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:44:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241241AbiDEIc5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D95C95FEA;
        Tue,  5 Apr 2022 01:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88274B81BC0;
        Tue,  5 Apr 2022 08:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5098C385A1;
        Tue,  5 Apr 2022 08:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147418;
        bh=FS92GdhlqFolm6H9zkgGxTMyWEWC8GNBnkat2V1mfM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tW5YSbbNQeiUQy3ZXSkGrjbY9Hw8XL9I/XEWdAOhISb931KFIpjZzZ5kghfPLrwyp
         kxo1XR0R3jfIF3wF+HmsObIfvg9QpeB8VU1RoTt74+tIre/oh8EU2KKHoYWB5nQ/Eu
         dRkP8Dd+Pd/vEHfZir+b/G+dQli8eYIJlC8bLaXQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eli Cohen <elic@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 5.17 1116/1126] vdpa/mlx5: Avoid processing works if workqueue was destroyed
Date:   Tue,  5 Apr 2022 09:31:03 +0200
Message-Id: <20220405070440.188924327@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

commit ad6dc1daaf29f97f23cc810d60ee01c0e83f4c6b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1669,7 +1669,7 @@ static void mlx5_vdpa_kick_vq(struct vdp
 		return;
 
 	if (unlikely(is_ctrl_vq_idx(mvdev, idx))) {
-		if (!mvdev->cvq.ready)
+		if (!mvdev->wq || !mvdev->cvq.ready)
 			return;
 
 		wqent = kzalloc(sizeof(*wqent), GFP_ATOMIC);
@@ -2707,9 +2707,12 @@ static void mlx5_vdpa_dev_del(struct vdp
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


