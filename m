Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08C67496E88
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 01:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235311AbiAWAMz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jan 2022 19:12:55 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40898 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235198AbiAWAMO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jan 2022 19:12:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79626B80927;
        Sun, 23 Jan 2022 00:12:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 300C9C340E4;
        Sun, 23 Jan 2022 00:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642896732;
        bh=Ew//I/En9Gd8ruRvLDwh96Ay8uzpIAJMy1X0RMRL7uw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TODSJHGea3ns31tXDMpGlBP6UsIMydwrZ2T2xIbpgqbxeJa1qrKmZgPUeXAvITBYE
         2fGu3YW4AvdPHIj6DFQv7aO55uYCqAxrod+WATTxy7+2EyJQjgIHOO62anCxpdobzM
         e75tPoJ+2cPtcdkko9hflkLyiC/hju1GkvVHOK4o3H2ll9tHJKPhFlZP09JK6t2PX2
         wfUDaqXK6QYhAfoRlk366WudK8bWtpi+MEK8y1mofQ/lmuq4eRK9dO2G8F1Sg1SDi8
         P+6W+KhkVw9PZXUWMTokkWaUoTUvbTo+HXjfCqQGOkn1HovuzvM8WD+zLH7ednP8Tg
         0doSGLUj/Iklg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eli Cohen <elic@nvidia.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Jason Wang <jasowang@redhat.com>,
        Sasha Levin <sashal@kernel.org>, parav@nvidia.com,
        xieyongji@bytedance.com, virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.16 17/19] vdpa/mlx5: Fix is_index_valid() to refer to features
Date:   Sat, 22 Jan 2022 19:11:10 -0500
Message-Id: <20220123001113.2460140-17-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220123001113.2460140-1-sashal@kernel.org>
References: <20220123001113.2460140-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

[ Upstream commit f8ae3a489b21b05c39a0a1a7734f2a0188852177 ]

Make sure the decision whether an index received through a callback is
valid or not consults the negotiated features.

The motivation for this was due to a case encountered where I shut down
the VM. After the reset operation was called features were already
clear, I got get_vq_state() call which caused out array bounds
access since is_index_valid() reported the index value.

So this is more of not hit a bug since the call shouldn't have been made
first place.

Signed-off-by: Eli Cohen <elic@nvidia.com>
Link: https://lore.kernel.org/r/20220111183400.38418-4-elic@nvidia.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Si-Wei Liu<si-wei.liu@oracle.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index d8e69340a25ae..68ace0ad659f2 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -138,10 +138,14 @@ struct mlx5_vdpa_virtqueue {
 
 static bool is_index_valid(struct mlx5_vdpa_dev *mvdev, u16 idx)
 {
-	if (unlikely(idx > mvdev->max_idx))
-		return false;
+	if (!(mvdev->actual_features & BIT_ULL(VIRTIO_NET_F_MQ))) {
+		if (!(mvdev->actual_features & BIT_ULL(VIRTIO_NET_F_CTRL_VQ)))
+			return idx < 2;
+		else
+			return idx < 3;
+	}
 
-	return true;
+	return idx <= mvdev->max_idx;
 }
 
 struct mlx5_vdpa_net {
-- 
2.34.1

