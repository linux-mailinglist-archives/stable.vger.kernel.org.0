Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA0563DD9E9
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235774AbhHBOFM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:05:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:49162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236579AbhHBODc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 10:03:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF45661205;
        Mon,  2 Aug 2021 13:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912642;
        bh=OuQAVoOXiQM5NnksAg1dmCFhWL/r1eK4RJlhED5DQ34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ymsx4WsWQm0KAnaOYdGeIslrxwFJr+RyxcqVxu+dRq8oXyGIW0xc91kP4HQsthv8s
         6xAgOGj5tz49IUylCyO/7CpdSYy19ocTixcdBnB295zUx5fTVoEzFxufnAc3Pe4QEV
         IVtkpgDStjl9ceL9rlqe/9KYB4TozCWpEBdX8dPo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dima Chumak <dchumak@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 084/104] net/mlx5e: Fix nullptr in mlx5e_hairpin_get_mdev()
Date:   Mon,  2 Aug 2021 15:45:21 +0200
Message-Id: <20210802134346.774394396@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
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
index d4b0f270b6bb..47bd20ad8108 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -424,12 +424,32 @@ static void mlx5e_detach_mod_hdr(struct mlx5e_priv *priv,
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
@@ -638,6 +658,10 @@ mlx5e_hairpin_create(struct mlx5e_priv *priv, struct mlx5_hairpin_params *params
 
 	func_mdev = priv->mdev;
 	peer_mdev = mlx5e_hairpin_get_mdev(dev_net(priv->netdev), peer_ifindex);
+	if (IS_ERR(peer_mdev)) {
+		err = PTR_ERR(peer_mdev);
+		goto create_pair_err;
+	}
 
 	pair = mlx5_core_hairpin_create(func_mdev, peer_mdev, params);
 	if (IS_ERR(pair)) {
@@ -776,6 +800,11 @@ static int mlx5e_hairpin_flow_add(struct mlx5e_priv *priv,
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



