Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75DED4D78D
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728582AbfFTSN7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:13:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:42100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729356AbfFTSN6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:13:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00B1D205F4;
        Thu, 20 Jun 2019 18:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054437;
        bh=DV2aLpU69ZyOtaTfZU94M4cp67Y75DYB4MdfnmLHG2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HxOQSPKzYT9FKgzgUjesz0rCIm9lKdZLWS58l+5Z1ZXMKxJhrRi1k8bGS2YdEPzFA
         +Ode84yPTbeUnc2TRkqmP4OK16MSFZYqnmVHTiPoDPyEuQ7pxCeNIjqTLOmdGQx04D
         teYtXoav60WI6KcBZebDj8FD+XrfRTtyiGbH/z6E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eli Britstein <elibr@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.1 29/98] net/mlx5e: Support tagged tunnel over bond
Date:   Thu, 20 Jun 2019 19:56:56 +0200
Message-Id: <20190620174350.447696366@linuxfoundation.org>
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

From: Eli Britstein <elibr@mellanox.com>

Stacked devices like bond interface may have a VLAN device on top of
them. Detect lag state correctly under this condition, and return the
correct routed net device, according to it the encap header is built.

Fixes: e32ee6c78efa ("net/mlx5e: Support tunnel encap over tagged Ethernet")
Signed-off-by: Eli Britstein <elibr@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -11,24 +11,25 @@ static int get_route_and_out_devs(struct
 				  struct net_device **route_dev,
 				  struct net_device **out_dev)
 {
+	struct net_device *uplink_dev, *uplink_upper, *real_dev;
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
-	struct net_device *uplink_dev, *uplink_upper;
 	bool dst_is_lag_dev;
 
+	real_dev = is_vlan_dev(dev) ? vlan_dev_real_dev(dev) : dev;
 	uplink_dev = mlx5_eswitch_uplink_get_proto_dev(esw, REP_ETH);
 	uplink_upper = netdev_master_upper_dev_get(uplink_dev);
 	dst_is_lag_dev = (uplink_upper &&
 			  netif_is_lag_master(uplink_upper) &&
-			  dev == uplink_upper &&
+			  real_dev == uplink_upper &&
 			  mlx5_lag_is_sriov(priv->mdev));
 
 	/* if the egress device isn't on the same HW e-switch or
 	 * it's a LAG device, use the uplink
 	 */
-	if (!netdev_port_same_parent_id(priv->netdev, dev) ||
+	if (!netdev_port_same_parent_id(priv->netdev, real_dev) ||
 	    dst_is_lag_dev) {
-		*route_dev = uplink_dev;
-		*out_dev = *route_dev;
+		*route_dev = dev;
+		*out_dev = uplink_dev;
 	} else {
 		*route_dev = dev;
 		if (is_vlan_dev(*route_dev))


