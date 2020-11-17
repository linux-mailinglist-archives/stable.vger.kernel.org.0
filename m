Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2262B6345
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732587AbgKQNgd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:36:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:47456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732603AbgKQNgc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:36:32 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9065720870;
        Tue, 17 Nov 2020 13:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620191;
        bh=K5l2nrCyQiL8LA9NW/HYuvWskQN0LyQXXNbUiMVKV2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vrIVZQvthjhKE+18hP7biRmDtD2r2uqSIu3IWysnXQZ2A4NZKGYcy9nNegREUchLY
         4eZpMHeq0aUBgBeHZq0Kmygl9cAOpDIOTneK36VwqlLLM/lkk7PcSly0gnSoxJ8deX
         LoLf3x1//dy6Ikyhs1F0CmP8v99vRy/za4V3ESpc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 137/255] net/mlx5e: Protect encap route dev from concurrent release
Date:   Tue, 17 Nov 2020 14:04:37 +0100
Message-Id: <20201117122145.608926645@linuxfoundation.org>
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

From: Vlad Buslov <vladbu@nvidia.com>

[ Upstream commit 78c906e430b13d30a8cfbdef4ccbbe1686841a9e ]

In functions mlx5e_route_lookup_ipv{4|6}() route_dev can be arbitrary net
device and not necessary mlx5 eswitch port representor. As such, in order
to ensure that route_dev is not destroyed concurrent the code needs either
explicitly take reference to the device before releasing reference to
rtable instance or ensure that caller holds rtnl lock. First approach is
chosen as a fix since rtnl lock dependency was intentionally removed from
mlx5 TC layer.

To prevent unprotected usage of route_dev in encap code take a reference to
the device before releasing rt. Don't save direct pointer to the device in
mlx5_encap_entry structure and use ifindex instead. Modify users of
route_dev pointer to properly obtain the net device instance from its
ifindex.

Fixes: 61086f391044 ("net/mlx5e: Protect encap hash table with mutex")
Fixes: 6707f74be862 ("net/mlx5e: Update hw flows when encap source mac changed")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/en/rep/tc.c   |  6 +-
 .../ethernet/mellanox/mlx5/core/en/tc_tun.c   | 72 ++++++++++++-------
 .../net/ethernet/mellanox/mlx5/core/en_rep.h  |  2 +-
 3 files changed, 52 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index 79cc42d88eec6..38ea249159f60 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -107,12 +107,16 @@ void mlx5e_rep_update_flows(struct mlx5e_priv *priv,
 		mlx5e_tc_encap_flows_del(priv, e, &flow_list);
 
 	if (neigh_connected && !(e->flags & MLX5_ENCAP_ENTRY_VALID)) {
+		struct net_device *route_dev;
+
 		ether_addr_copy(e->h_dest, ha);
 		ether_addr_copy(eth->h_dest, ha);
 		/* Update the encap source mac, in case that we delete
 		 * the flows when encap source mac changed.
 		 */
-		ether_addr_copy(eth->h_source, e->route_dev->dev_addr);
+		route_dev = __dev_get_by_index(dev_net(priv->netdev), e->route_dev_ifindex);
+		if (route_dev)
+			ether_addr_copy(eth->h_source, route_dev->dev_addr);
 
 		mlx5e_tc_encap_flows_add(priv, e, &flow_list);
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index 7cce85faa16fa..90930e54b6f28 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -77,13 +77,13 @@ static int get_route_and_out_devs(struct mlx5e_priv *priv,
 	return 0;
 }
 
-static int mlx5e_route_lookup_ipv4(struct mlx5e_priv *priv,
-				   struct net_device *mirred_dev,
-				   struct net_device **out_dev,
-				   struct net_device **route_dev,
-				   struct flowi4 *fl4,
-				   struct neighbour **out_n,
-				   u8 *out_ttl)
+static int mlx5e_route_lookup_ipv4_get(struct mlx5e_priv *priv,
+				       struct net_device *mirred_dev,
+				       struct net_device **out_dev,
+				       struct net_device **route_dev,
+				       struct flowi4 *fl4,
+				       struct neighbour **out_n,
+				       u8 *out_ttl)
 {
 	struct neighbour *n;
 	struct rtable *rt;
@@ -117,18 +117,28 @@ static int mlx5e_route_lookup_ipv4(struct mlx5e_priv *priv,
 		ip_rt_put(rt);
 		return ret;
 	}
+	dev_hold(*route_dev);
 
 	if (!(*out_ttl))
 		*out_ttl = ip4_dst_hoplimit(&rt->dst);
 	n = dst_neigh_lookup(&rt->dst, &fl4->daddr);
 	ip_rt_put(rt);
-	if (!n)
+	if (!n) {
+		dev_put(*route_dev);
 		return -ENOMEM;
+	}
 
 	*out_n = n;
 	return 0;
 }
 
+static void mlx5e_route_lookup_ipv4_put(struct net_device *route_dev,
+					struct neighbour *n)
+{
+	neigh_release(n);
+	dev_put(route_dev);
+}
+
 static const char *mlx5e_netdev_kind(struct net_device *dev)
 {
 	if (dev->rtnl_link_ops)
@@ -193,8 +203,8 @@ int mlx5e_tc_tun_create_header_ipv4(struct mlx5e_priv *priv,
 	fl4.saddr = tun_key->u.ipv4.src;
 	ttl = tun_key->ttl;
 
-	err = mlx5e_route_lookup_ipv4(priv, mirred_dev, &out_dev, &route_dev,
-				      &fl4, &n, &ttl);
+	err = mlx5e_route_lookup_ipv4_get(priv, mirred_dev, &out_dev, &route_dev,
+					  &fl4, &n, &ttl);
 	if (err)
 		return err;
 
@@ -223,7 +233,7 @@ int mlx5e_tc_tun_create_header_ipv4(struct mlx5e_priv *priv,
 	e->m_neigh.family = n->ops->family;
 	memcpy(&e->m_neigh.dst_ip, n->primary_key, n->tbl->key_len);
 	e->out_dev = out_dev;
-	e->route_dev = route_dev;
+	e->route_dev_ifindex = route_dev->ifindex;
 
 	/* It's important to add the neigh to the hash table before checking
 	 * the neigh validity state. So if we'll get a notification, in case the
@@ -278,7 +288,7 @@ int mlx5e_tc_tun_create_header_ipv4(struct mlx5e_priv *priv,
 
 	e->flags |= MLX5_ENCAP_ENTRY_VALID;
 	mlx5e_rep_queue_neigh_stats_work(netdev_priv(out_dev));
-	neigh_release(n);
+	mlx5e_route_lookup_ipv4_put(route_dev, n);
 	return err;
 
 destroy_neigh_entry:
@@ -286,18 +296,18 @@ destroy_neigh_entry:
 free_encap:
 	kfree(encap_header);
 release_neigh:
-	neigh_release(n);
+	mlx5e_route_lookup_ipv4_put(route_dev, n);
 	return err;
 }
 
 #if IS_ENABLED(CONFIG_INET) && IS_ENABLED(CONFIG_IPV6)
-static int mlx5e_route_lookup_ipv6(struct mlx5e_priv *priv,
-				   struct net_device *mirred_dev,
-				   struct net_device **out_dev,
-				   struct net_device **route_dev,
-				   struct flowi6 *fl6,
-				   struct neighbour **out_n,
-				   u8 *out_ttl)
+static int mlx5e_route_lookup_ipv6_get(struct mlx5e_priv *priv,
+				       struct net_device *mirred_dev,
+				       struct net_device **out_dev,
+				       struct net_device **route_dev,
+				       struct flowi6 *fl6,
+				       struct neighbour **out_n,
+				       u8 *out_ttl)
 {
 	struct dst_entry *dst;
 	struct neighbour *n;
@@ -318,15 +328,25 @@ static int mlx5e_route_lookup_ipv6(struct mlx5e_priv *priv,
 		return ret;
 	}
 
+	dev_hold(*route_dev);
 	n = dst_neigh_lookup(dst, &fl6->daddr);
 	dst_release(dst);
-	if (!n)
+	if (!n) {
+		dev_put(*route_dev);
 		return -ENOMEM;
+	}
 
 	*out_n = n;
 	return 0;
 }
 
+static void mlx5e_route_lookup_ipv6_put(struct net_device *route_dev,
+					struct neighbour *n)
+{
+	neigh_release(n);
+	dev_put(route_dev);
+}
+
 int mlx5e_tc_tun_create_header_ipv6(struct mlx5e_priv *priv,
 				    struct net_device *mirred_dev,
 				    struct mlx5e_encap_entry *e)
@@ -348,8 +368,8 @@ int mlx5e_tc_tun_create_header_ipv6(struct mlx5e_priv *priv,
 	fl6.daddr = tun_key->u.ipv6.dst;
 	fl6.saddr = tun_key->u.ipv6.src;
 
-	err = mlx5e_route_lookup_ipv6(priv, mirred_dev, &out_dev, &route_dev,
-				      &fl6, &n, &ttl);
+	err = mlx5e_route_lookup_ipv6_get(priv, mirred_dev, &out_dev, &route_dev,
+					  &fl6, &n, &ttl);
 	if (err)
 		return err;
 
@@ -378,7 +398,7 @@ int mlx5e_tc_tun_create_header_ipv6(struct mlx5e_priv *priv,
 	e->m_neigh.family = n->ops->family;
 	memcpy(&e->m_neigh.dst_ip, n->primary_key, n->tbl->key_len);
 	e->out_dev = out_dev;
-	e->route_dev = route_dev;
+	e->route_dev_ifindex = route_dev->ifindex;
 
 	/* It's importent to add the neigh to the hash table before checking
 	 * the neigh validity state. So if we'll get a notification, in case the
@@ -433,7 +453,7 @@ int mlx5e_tc_tun_create_header_ipv6(struct mlx5e_priv *priv,
 
 	e->flags |= MLX5_ENCAP_ENTRY_VALID;
 	mlx5e_rep_queue_neigh_stats_work(netdev_priv(out_dev));
-	neigh_release(n);
+	mlx5e_route_lookup_ipv6_put(route_dev, n);
 	return err;
 
 destroy_neigh_entry:
@@ -441,7 +461,7 @@ destroy_neigh_entry:
 free_encap:
 	kfree(encap_header);
 release_neigh:
-	neigh_release(n);
+	mlx5e_route_lookup_ipv6_put(route_dev, n);
 	return err;
 }
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
index 0d1562e20118c..963a6d98840ac 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -187,7 +187,7 @@ struct mlx5e_encap_entry {
 	unsigned char h_dest[ETH_ALEN];	/* destination eth addr	*/
 
 	struct net_device *out_dev;
-	struct net_device *route_dev;
+	int route_dev_ifindex;
 	struct mlx5e_tc_tunnel *tunnel;
 	int reformat_type;
 	u8 flags;
-- 
2.27.0



