Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD80666C502
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231831AbjAPQAk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:00:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231892AbjAPQAb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:00:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44B4223673
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:00:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9C9CB81062
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:00:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 194B8C433D2;
        Mon, 16 Jan 2023 16:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884827;
        bh=HvaAO4+8WvwqrfKrCekjGW5CXI5W62awKG4zrILwWpA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XAdaIXJGd6o6frahZYnIDW3IhQzIebhnpRBVNai53K61v+HzSsLmVmGJx0nyPjCNr
         41rcAT17lj15LSOEjQocXwTthFF0x93nRnwiW9QyFOnJTWat1v6wZYmqt7qvO4VP+M
         NK4i2ZcyPBIPpizb3oFSrDWWndSbdRBV/pkF3ITk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dragos Tatulea <dtatulea@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 154/183] net/mlx5e: IPoIB, Block queue count configuration when sub interfaces are present
Date:   Mon, 16 Jan 2023 16:51:17 +0100
Message-Id: <20230116154809.825792238@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dragos Tatulea <dtatulea@nvidia.com>

[ Upstream commit 806a8df7126a8c05d60411eeb81057c2a8bbe7a7 ]

PKEY sub interfaces share the receive queues with the parent interface.
While setting the sub interface queue count is not supported, it is
currently possible to change the number of queues of the parent interface.
Thus we can end up with inconsistent queue sizes between the parent and its
sub interfaces.

This change disallows setting the queue count on the parent interface when
sub interfaces are present.

This is achieved by introducing an explicit reference to the parent netdev
in the mlx5i_priv of the child interface. An additional counter is also
required on the parent side to detect when sub interfaces are attached and
for proper cleanup.

The rtnl lock is taken during the ethtool op and the sub interface
ndo_init/uninit ops. There is no race here around counting the sub
interfaces, reading the sub interfaces and setting the number of
channels. The ASSERT_RTNL was added to document that.

Fixes: be98737a4faa ("net/mlx5e: Use dynamic per-channel allocations in stats")
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/ipoib/ethtool.c        | 16 +++++++-
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c | 38 +++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.h |  6 +++
 .../mellanox/mlx5/core/ipoib/ipoib_vlan.c     |  9 ++---
 4 files changed, 62 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
index c247cca154e9..eff92dc0927c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
@@ -90,9 +90,21 @@ static void mlx5i_get_ringparam(struct net_device *dev,
 static int mlx5i_set_channels(struct net_device *dev,
 			      struct ethtool_channels *ch)
 {
-	struct mlx5e_priv *priv = mlx5i_epriv(dev);
+	struct mlx5i_priv *ipriv = netdev_priv(dev);
+	struct mlx5e_priv *epriv = mlx5i_epriv(dev);
+
+	/* rtnl lock protects from race between this ethtool op and sub
+	 * interface ndo_init/uninit.
+	 */
+	ASSERT_RTNL();
+	if (ipriv->num_sub_interfaces > 0) {
+		mlx5_core_warn(epriv->mdev,
+			       "can't change number of channels for interfaces with sub interfaces (%u)\n",
+			       ipriv->num_sub_interfaces);
+		return -EINVAL;
+	}
 
-	return mlx5e_ethtool_set_channels(priv, ch);
+	return mlx5e_ethtool_set_channels(epriv, ch);
 }
 
 static void mlx5i_get_channels(struct net_device *dev,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 84f5352b0ce1..038ae0fcf9d4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -160,6 +160,44 @@ void mlx5i_get_stats(struct net_device *dev, struct rtnl_link_stats64 *stats)
 	stats->tx_dropped = sstats->tx_queue_dropped;
 }
 
+struct net_device *mlx5i_parent_get(struct net_device *netdev)
+{
+	struct mlx5e_priv *priv = mlx5i_epriv(netdev);
+	struct mlx5i_priv *ipriv, *parent_ipriv;
+	struct net_device *parent_dev;
+	int parent_ifindex;
+
+	ipriv = priv->ppriv;
+
+	parent_ifindex = netdev->netdev_ops->ndo_get_iflink(netdev);
+	parent_dev = dev_get_by_index(dev_net(netdev), parent_ifindex);
+	if (!parent_dev)
+		return NULL;
+
+	parent_ipriv = netdev_priv(parent_dev);
+
+	ASSERT_RTNL();
+	parent_ipriv->num_sub_interfaces++;
+
+	ipriv->parent_dev = parent_dev;
+
+	return parent_dev;
+}
+
+void mlx5i_parent_put(struct net_device *netdev)
+{
+	struct mlx5e_priv *priv = mlx5i_epriv(netdev);
+	struct mlx5i_priv *ipriv, *parent_ipriv;
+
+	ipriv = priv->ppriv;
+	parent_ipriv = netdev_priv(ipriv->parent_dev);
+
+	ASSERT_RTNL();
+	parent_ipriv->num_sub_interfaces--;
+
+	dev_put(ipriv->parent_dev);
+}
+
 int mlx5i_init_underlay_qp(struct mlx5e_priv *priv)
 {
 	struct mlx5_core_dev *mdev = priv->mdev;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h
index 99d46fda9f82..f3f2af972020 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h
@@ -54,9 +54,11 @@ struct mlx5i_priv {
 	struct rdma_netdev rn; /* keep this first */
 	u32 qpn;
 	bool   sub_interface;
+	u32    num_sub_interfaces;
 	u32    qkey;
 	u16    pkey_index;
 	struct mlx5i_pkey_qpn_ht *qpn_htbl;
+	struct net_device *parent_dev;
 	char  *mlx5e_priv[];
 };
 
@@ -117,5 +119,9 @@ void mlx5i_sq_xmit(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 		   struct mlx5_av *av, u32 dqpn, u32 dqkey, bool xmit_more);
 void mlx5i_get_stats(struct net_device *dev, struct rtnl_link_stats64 *stats);
 
+/* Reference management for child to parent interfaces. */
+struct net_device *mlx5i_parent_get(struct net_device *netdev);
+void mlx5i_parent_put(struct net_device *netdev);
+
 #endif /* CONFIG_MLX5_CORE_IPOIB */
 #endif /* __MLX5E_IPOB_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
index 0227a521d301..3d31c59e69d4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
@@ -158,21 +158,19 @@ static int mlx5i_pkey_dev_init(struct net_device *dev)
 	struct mlx5e_priv *priv = mlx5i_epriv(dev);
 	struct mlx5i_priv *ipriv, *parent_ipriv;
 	struct net_device *parent_dev;
-	int parent_ifindex;
 
 	ipriv = priv->ppriv;
 
-	/* Get QPN to netdevice hash table from parent */
-	parent_ifindex = dev->netdev_ops->ndo_get_iflink(dev);
-	parent_dev = dev_get_by_index(dev_net(dev), parent_ifindex);
+	/* Link to parent */
+	parent_dev = mlx5i_parent_get(dev);
 	if (!parent_dev) {
 		mlx5_core_warn(priv->mdev, "failed to get parent device\n");
 		return -EINVAL;
 	}
 
+	/* Get QPN to netdevice hash table from parent */
 	parent_ipriv = netdev_priv(parent_dev);
 	ipriv->qpn_htbl = parent_ipriv->qpn_htbl;
-	dev_put(parent_dev);
 
 	return mlx5i_dev_init(dev);
 }
@@ -184,6 +182,7 @@ static int mlx5i_pkey_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 
 static void mlx5i_pkey_dev_cleanup(struct net_device *netdev)
 {
+	mlx5i_parent_put(netdev);
 	return mlx5i_dev_cleanup(netdev);
 }
 
-- 
2.35.1



