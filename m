Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4723CE570
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349304AbhGSPuL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:50:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:47916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241182AbhGSPqR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:46:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CD5061396;
        Mon, 19 Jul 2021 16:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626712012;
        bh=AtJhkYiAHeyWlZ+m77O1eXeykRA1Y4rtVQqZeNNFDuw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S+WmuHvwFt4UhsxceP63kHxclIpEF2VANk0ap6W5fRUISV0d25vcLkx75m+LbF4Zf
         QFFI++S+Lmld+H0QY72YeQPZrWrTeMdyXSOKNvNUp2iCk9Fta0+gg/EIbvfCdshfQh
         eJUgLOj29NRLoicQk/l7j98ZkNlCQcjVrL/gW27M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eli Cohen <elic@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 216/292] vdpa/mlx5: Clear vq ready indication upon device reset
Date:   Mon, 19 Jul 2021 16:54:38 +0200
Message-Id: <20210719144950.094875396@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
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
index 85bcbbce1ef9..68fd117fd7a5 100644
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



