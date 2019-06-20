Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B14B54D798
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729048AbfFTSNr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:13:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:41818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729016AbfFTSNr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:13:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1D7621537;
        Thu, 20 Jun 2019 18:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054426;
        bh=OBMJoiPQaTvsnD2GfHaSCrxzr14ZOG3EferDDf6RBQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w73ZQo8LJHFhnKWWhEf1/4iKU6X/4FQVOqXgvti1W4J1CrO/TIspA6cMv2d8mprkD
         JYAwbzmzgqvNgETlTkAlkfXFhk+Cb4XH3Y+BNC7BPBI5io/jgadgN2JjtgQbHTpcvN
         NMX/+KD93wcrl7N4MlEnGYDuM4cpaORFXvPwcsZc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Mi <chrism@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.1 25/98] net/mlx5e: Add ndo_set_feature for uplink representor
Date:   Thu, 20 Jun 2019 19:56:52 +0200
Message-Id: <20190620174350.308579831@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174349.443386789@linuxfoundation.org>
References: <20190620174349.443386789@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Mi <chrism@mellanox.com>

After we have a dedicated uplink representor, the new netdev ops
doesn't support ndo_set_feature. Because of that, we can't change
some features, eg. rxvlan. Now add it back.

In this patch, I also do a cleanup for the features flag handling,
eg. remove duplicate NETIF_F_HW_TC flag setting.

Fixes: aec002f6f82c ("net/mlx5e: Uninstantiate esw manager vport netdev on switchdev mode")
Signed-off-by: Chris Mi <chrism@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Vlad Buslov <vladbu@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h      |    1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c |    3 +--
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c  |   10 ++++++----
 3 files changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1059,6 +1059,7 @@ void mlx5e_del_vxlan_port(struct net_dev
 netdev_features_t mlx5e_features_check(struct sk_buff *skb,
 				       struct net_device *netdev,
 				       netdev_features_t features);
+int mlx5e_set_features(struct net_device *netdev, netdev_features_t features);
 #ifdef CONFIG_MLX5_ESWITCH
 int mlx5e_set_vf_mac(struct net_device *dev, int vf, u8 *mac);
 int mlx5e_set_vf_rate(struct net_device *dev, int vf, int min_tx_rate, int max_tx_rate);
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3698,8 +3698,7 @@ static int mlx5e_handle_feature(struct n
 	return 0;
 }
 
-static int mlx5e_set_features(struct net_device *netdev,
-			      netdev_features_t features)
+int mlx5e_set_features(struct net_device *netdev, netdev_features_t features)
 {
 	netdev_features_t oper_features = netdev->features;
 	int err = 0;
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1350,6 +1350,7 @@ static const struct net_device_ops mlx5e
 	.ndo_get_vf_stats        = mlx5e_get_vf_stats,
 	.ndo_set_vf_vlan         = mlx5e_uplink_rep_set_vf_vlan,
 	.ndo_get_port_parent_id	 = mlx5e_rep_get_port_parent_id,
+	.ndo_set_features        = mlx5e_set_features,
 };
 
 bool mlx5e_eswitch_rep(struct net_device *netdev)
@@ -1423,10 +1424,9 @@ static void mlx5e_build_rep_netdev(struc
 
 	netdev->watchdog_timeo    = 15 * HZ;
 
+	netdev->features       |= NETIF_F_NETNS_LOCAL;
 
-	netdev->features	 |= NETIF_F_HW_TC | NETIF_F_NETNS_LOCAL;
-	netdev->hw_features      |= NETIF_F_HW_TC;
-
+	netdev->hw_features    |= NETIF_F_HW_TC;
 	netdev->hw_features    |= NETIF_F_SG;
 	netdev->hw_features    |= NETIF_F_IP_CSUM;
 	netdev->hw_features    |= NETIF_F_IPV6_CSUM;
@@ -1435,7 +1435,9 @@ static void mlx5e_build_rep_netdev(struc
 	netdev->hw_features    |= NETIF_F_TSO6;
 	netdev->hw_features    |= NETIF_F_RXCSUM;
 
-	if (rep->vport != MLX5_VPORT_UPLINK)
+	if (rep->vport == MLX5_VPORT_UPLINK)
+		netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_RX;
+	else
 		netdev->features |= NETIF_F_VLAN_CHALLENGED;
 
 	netdev->features |= netdev->hw_features;


