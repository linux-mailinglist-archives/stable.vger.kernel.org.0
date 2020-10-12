Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDAB628B813
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389755AbgJLNtN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:49:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:55730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731924AbgJLNsU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:48:20 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E64EA20878;
        Mon, 12 Oct 2020 13:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510498;
        bh=ohG4jcxQpj6BX36E9+eDBoto7OXUW459oTJuDdrlIp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ANawH8kGEi59VM+S6LYA1qfUmIhhBiDEtiK4EgWZbzlgOS5y7YqANlO8Jj6Gj7K0N
         k3Jjie5QuWYUo5Ye5nawWtlWTdCbRLpkuvMs8ZnExDvU4BIoLsn6xH6oANz30jK5I9
         LWQWDb0LwTt2/oYuPSqOnWWXqYghAp5LpIXaI/do=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.8 118/124] net/mlx5e: Fix drivers declaration to support GRE offload
Date:   Mon, 12 Oct 2020 15:32:02 +0200
Message-Id: <20201012133152.560252948@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

commit 3d093bc2369003b4ce6c3522d9b383e47c40045d upstream.

Declare GRE offload support with respect to the inner protocol. Add a
list of supported inner protocols on which the driver can offload
checksum and GSO. For other protocols, inform the stack to do the needed
operations. There is no noticeable impact on GRE performance.

Fixes: 2729984149e6 ("net/mlx5e: Support TSO and TX checksum offloads for GRE tunnels")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4323,6 +4323,21 @@ void mlx5e_del_vxlan_port(struct net_dev
 	mlx5e_vxlan_queue_work(priv, be16_to_cpu(ti->port), 0);
 }
 
+static bool mlx5e_gre_tunnel_inner_proto_offload_supported(struct mlx5_core_dev *mdev,
+							   struct sk_buff *skb)
+{
+	switch (skb->inner_protocol) {
+	case htons(ETH_P_IP):
+	case htons(ETH_P_IPV6):
+	case htons(ETH_P_TEB):
+		return true;
+	case htons(ETH_P_MPLS_UC):
+	case htons(ETH_P_MPLS_MC):
+		return MLX5_CAP_ETH(mdev, tunnel_stateless_mpls_over_gre);
+	}
+	return false;
+}
+
 static netdev_features_t mlx5e_tunnel_features_check(struct mlx5e_priv *priv,
 						     struct sk_buff *skb,
 						     netdev_features_t features)
@@ -4345,7 +4360,9 @@ static netdev_features_t mlx5e_tunnel_fe
 
 	switch (proto) {
 	case IPPROTO_GRE:
-		return features;
+		if (mlx5e_gre_tunnel_inner_proto_offload_supported(priv->mdev, skb))
+			return features;
+		break;
 	case IPPROTO_IPIP:
 	case IPPROTO_IPV6:
 		if (mlx5e_tunnel_proto_supported(priv->mdev, IPPROTO_IPIP))


