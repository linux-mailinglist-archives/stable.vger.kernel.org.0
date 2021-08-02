Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 426413DD891
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235038AbhHBNxN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:53:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:58758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235033AbhHBNv5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:51:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8622F6052B;
        Mon,  2 Aug 2021 13:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912287;
        bh=4fWRaax8e3GcJXQxrv8TCa6zr8eu4IMTbjRkEKTPzxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JYNksWsPh+OW12EBVR+eMLMM71Py6IXCuD8yBkUSq3lJJ1c7VxMF+EKxMVMCFqZ8o
         PoC1mlemjjWMOtgrnVgHTXmARxk5oY25HKM4/jEtBzX/7wsOkbRhX3y8HZknHu3KVF
         wBD/wYMY34Q8KQX/FejkKNbySQ7nTZqTQwD8NoPc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dima Chumak <dchumak@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 31/40] net/mlx5e: Fix nullptr in mlx5e_hairpin_get_mdev()
Date:   Mon,  2 Aug 2021 15:45:11 +0200
Message-Id: <20210802134336.382461268@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134335.408294521@linuxfoundation.org>
References: <20210802134335.408294521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dima Chumak <dchumak@nvidia.com>

[ Upstream commit b1c2f6312c5005c928a72e668bf305a589d828d4 ]

The result of __dev_get_by_index() is not checked for NULL and then gets
dereferenced immediately.

Also, __dev_get_by_index() must be called while holding either RTNL lock
or @dev_base_lock, which isn't satisfied by mlx5e_hairpin_get_mdev() or
its callers. This makes the underlying hlist_for_each_entry() loop not
safe, and can have adverse effects in itself.

Fix by using dev_get_by_index() and handling nullptr return value when
ifindex device is not found. Update mlx5e_hairpin_get_mdev() callers to
check for possible PTR_ERR() result.

Fixes: 77ab67b7f0f9 ("net/mlx5e: Basic setup of hairpin object")
Addresses-Coverity: ("Dereference null return value")
Signed-off-by: Dima Chumak <dchumak@nvidia.com>
Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 33 +++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 9d26463f3fa5..5abc15a92cfa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -444,12 +444,32 @@ static void mlx5e_detach_mod_hdr(struct mlx5e_priv *priv,
 static
 struct mlx5_core_dev *mlx5e_hairpin_get_mdev(struct net *net, int ifindex)
 {
+	struct mlx5_core_dev *mdev;
 	struct net_device *netdev;
 	struct mlx5e_priv *priv;
 
-	netdev = __dev_get_by_index(net, ifindex);
+	netdev = dev_get_by_index(net, ifindex);
+	if (!netdev)
+		return ERR_PTR(-ENODEV);
+
 	priv = netdev_priv(netdev);
-	return priv->mdev;
+	mdev = priv->mdev;
+	dev_put(netdev);
+
+	/* Mirred tc action holds a refcount on the ifindex net_device (see
+	 * net/sched/act_mirred.c:tcf_mirred_get_dev). So, it's okay to continue using mdev
+	 * after dev_put(netdev), while we're in the context of adding a tc flow.
+	 *
+	 * The mdev pointer corresponds to the peer/out net_device of a hairpin. It is then
+	 * stored in a hairpin object, which exists until all flows, that refer to it, get
+	 * removed.
+	 *
+	 * On the other hand, after a hairpin object has been created, the peer net_device may
+	 * be removed/unbound while there are still some hairpin flows that are using it. This
+	 * case is handled by mlx5e_tc_hairpin_update_dead_peer, which is hooked to
+	 * NETDEV_UNREGISTER event of the peer net_device.
+	 */
+	return mdev;
 }
 
 static int mlx5e_hairpin_create_transport(struct mlx5e_hairpin *hp)
@@ -648,6 +668,10 @@ mlx5e_hairpin_create(struct mlx5e_priv *priv, struct mlx5_hairpin_params *params
 
 	func_mdev = priv->mdev;
 	peer_mdev = mlx5e_hairpin_get_mdev(dev_net(priv->netdev), peer_ifindex);
+	if (IS_ERR(peer_mdev)) {
+		err = PTR_ERR(peer_mdev);
+		goto create_pair_err;
+	}
 
 	pair = mlx5_core_hairpin_create(func_mdev, peer_mdev, params);
 	if (IS_ERR(pair)) {
@@ -786,6 +810,11 @@ static int mlx5e_hairpin_flow_add(struct mlx5e_priv *priv,
 	int err;
 
 	peer_mdev = mlx5e_hairpin_get_mdev(dev_net(priv->netdev), peer_ifindex);
+	if (IS_ERR(peer_mdev)) {
+		NL_SET_ERR_MSG_MOD(extack, "invalid ifindex of mirred device");
+		return PTR_ERR(peer_mdev);
+	}
+
 	if (!MLX5_CAP_GEN(priv->mdev, hairpin) || !MLX5_CAP_GEN(peer_mdev, hairpin)) {
 		NL_SET_ERR_MSG_MOD(extack, "hairpin is not supported");
 		return -EOPNOTSUPP;
-- 
2.30.2



