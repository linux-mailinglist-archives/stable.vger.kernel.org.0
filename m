Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C51B23CE3F6
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347110AbhGSPlX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:41:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:59814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347967AbhGSPfV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A7A661582;
        Mon, 19 Jul 2021 16:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711193;
        bh=we27ck4tLSX3+fkTgOo89ZYtorE2bkPKvXcTEGrtVYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fy2GPqIVkWelMrK9B0JgoxbRb/9qeKH6NYUGhld6tX6do3nJ4qKCGYBlaPHesaEfk
         trtuSey/x2IQP4cR5owlm/q4jbzdbQ/EDk5+doxI0rfUD0jYTZMP8MuOSXYDYzITKS
         yP7PVHzbQmFCmJgZRMUTxwQpSPFm7z4dh9TKKixE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eli Cohen <elic@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 262/351] vdpa/mlx5: Clear vq ready indication upon device reset
Date:   Mon, 19 Jul 2021 16:53:28 +0200
Message-Id: <20210719144953.613792020@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

[ Upstream commit e3aadf2e1614174dc81d52cbb9dabb77913b11c6 ]

After device reset, the virtqueues are not ready so clear the ready
field.

Failing to do so can result in virtio_vdpa failing to load if the device
was previously used by vhost_vdpa and the old values are ready.
virtio_vdpa expects to find VQs in "not ready" state.

Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
Signed-off-by: Eli Cohen <elic@nvidia.com>
Link: https://lore.kernel.org/r/20210606053128.170399-1-elic@nvidia.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 2b74e34fbdec..32dd5ed712cb 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1767,6 +1767,14 @@ out:
 	mutex_unlock(&ndev->reslock);
 }
 
+static void clear_vqs_ready(struct mlx5_vdpa_net *ndev)
+{
+	int i;
+
+	for (i = 0; i < ndev->mvdev.max_vqs; i++)
+		ndev->vqs[i].ready = false;
+}
+
 static void mlx5_vdpa_set_status(struct vdpa_device *vdev, u8 status)
 {
 	struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
@@ -1777,6 +1785,7 @@ static void mlx5_vdpa_set_status(struct vdpa_device *vdev, u8 status)
 	if (!status) {
 		mlx5_vdpa_info(mvdev, "performing device reset\n");
 		teardown_driver(ndev);
+		clear_vqs_ready(ndev);
 		mlx5_vdpa_destroy_mr(&ndev->mvdev);
 		ndev->mvdev.status = 0;
 		ndev->mvdev.mlx_features = 0;
-- 
2.30.2



