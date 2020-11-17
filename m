Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A423E2B6468
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:47:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732209AbgKQNhF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:37:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:47812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732695AbgKQNgr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:36:47 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 199BD221FD;
        Tue, 17 Nov 2020 13:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620206;
        bh=otJfjv/qwuqgeajwtg/hKL+gCgOGPN47nO+J57SRZbw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i9hAmskIkTQ9hOLMnYdb2Q3MWJPX65eFa1b1MJfz8blm3t3xxsIho32f0GUI00kvH
         vHP6F0VQz988mByrB443rrQamuAlnmiuXeRn8UJXajfm1EwL64njhaIch+sr0lTSSv
         J+Fcme6rNWF1VC9COhNv0ggvcp0OJKCz+yISbP+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 141/255] net/mlx5e: Fix VXLAN synchronization after function reload
Date:   Tue, 17 Nov 2020 14:04:41 +0100
Message-Id: <20201117122145.810379611@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

[ Upstream commit c5eb51adf06b2644fa28d4af886bfdcc53e288da ]

During driver reload, perform firmware tear-down which results in
firmware losing the configured VXLAN ports. These ports are still
available in the driver's database. Fix this by cleaning up driver's
VXLAN database in the nic unload flow, before firmware tear-down. With
that, minimize mlx5_vxlan_destroy() to remove only what was added in
mlx5_vxlan_create() and warn on leftover UDP ports.

Fixes: 18a2b7f969c9 ("net/mlx5: convert to new udp_tunnel infrastructure")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  1 +
 .../ethernet/mellanox/mlx5/core/lib/vxlan.c   | 23 ++++++++++++++-----
 .../ethernet/mellanox/mlx5/core/lib/vxlan.h   |  2 ++
 3 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 42ec28e298348..f399973a44eb0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5226,6 +5226,7 @@ static void mlx5e_nic_disable(struct mlx5e_priv *priv)
 
 	mlx5e_disable_async_events(priv);
 	mlx5_lag_remove(mdev);
+	mlx5_vxlan_reset_to_default(mdev->vxlan);
 }
 
 int mlx5e_update_nic_rx(struct mlx5e_priv *priv)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c
index 3315afe2f8dce..38084400ee8fa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c
@@ -167,6 +167,17 @@ struct mlx5_vxlan *mlx5_vxlan_create(struct mlx5_core_dev *mdev)
 }
 
 void mlx5_vxlan_destroy(struct mlx5_vxlan *vxlan)
+{
+	if (!mlx5_vxlan_allowed(vxlan))
+		return;
+
+	mlx5_vxlan_del_port(vxlan, IANA_VXLAN_UDP_PORT);
+	WARN_ON(!hash_empty(vxlan->htable));
+
+	kfree(vxlan);
+}
+
+void mlx5_vxlan_reset_to_default(struct mlx5_vxlan *vxlan)
 {
 	struct mlx5_vxlan_port *vxlanp;
 	struct hlist_node *tmp;
@@ -175,12 +186,12 @@ void mlx5_vxlan_destroy(struct mlx5_vxlan *vxlan)
 	if (!mlx5_vxlan_allowed(vxlan))
 		return;
 
-	/* Lockless since we are the only hash table consumers*/
 	hash_for_each_safe(vxlan->htable, bkt, tmp, vxlanp, hlist) {
-		hash_del(&vxlanp->hlist);
-		mlx5_vxlan_core_del_port_cmd(vxlan->mdev, vxlanp->udp_port);
-		kfree(vxlanp);
+		/* Don't delete default UDP port added by the HW.
+		 * Remove only user configured ports
+		 */
+		if (vxlanp->udp_port == IANA_VXLAN_UDP_PORT)
+			continue;
+		mlx5_vxlan_del_port(vxlan, vxlanp->udp_port);
 	}
-
-	kfree(vxlan);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.h
index ec766529f49b6..34ef662da35ed 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.h
@@ -56,6 +56,7 @@ void mlx5_vxlan_destroy(struct mlx5_vxlan *vxlan);
 int mlx5_vxlan_add_port(struct mlx5_vxlan *vxlan, u16 port);
 int mlx5_vxlan_del_port(struct mlx5_vxlan *vxlan, u16 port);
 bool mlx5_vxlan_lookup_port(struct mlx5_vxlan *vxlan, u16 port);
+void mlx5_vxlan_reset_to_default(struct mlx5_vxlan *vxlan);
 #else
 static inline struct mlx5_vxlan*
 mlx5_vxlan_create(struct mlx5_core_dev *mdev) { return ERR_PTR(-EOPNOTSUPP); }
@@ -63,6 +64,7 @@ static inline void mlx5_vxlan_destroy(struct mlx5_vxlan *vxlan) { return; }
 static inline int mlx5_vxlan_add_port(struct mlx5_vxlan *vxlan, u16 port) { return -EOPNOTSUPP; }
 static inline int mlx5_vxlan_del_port(struct mlx5_vxlan *vxlan, u16 port) { return -EOPNOTSUPP; }
 static inline bool mlx5_vxlan_lookup_port(struct mlx5_vxlan *vxlan, u16 port) { return false; }
+static inline void mlx5_vxlan_reset_to_default(struct mlx5_vxlan *vxlan) { return; }
 #endif
 
 #endif /* __MLX5_VXLAN_H__ */
-- 
2.27.0



