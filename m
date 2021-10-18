Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9734316C5
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 13:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbhJRLGV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 07:06:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:54930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229843AbhJRLGV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 07:06:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E74EB60F0F;
        Mon, 18 Oct 2021 11:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634555050;
        bh=5b9crE6mrabLR7Xm7UkCPVxe8/wiX4PJe04NQs3rYtc=;
        h=Subject:To:Cc:From:Date:From;
        b=aTgX9cCDRxDcXd8tiHZx1bNh769mjEo1y5nxPCLORRudfu+CoeNestkHC1AMT0CqM
         dQJ3SWcFR7kASOgYhSUffwd3VwSE0xZlD3O0s2jpzbXpGG5Vm8/7XYn7uBmy0weQFY
         Twr32/izrqV6iNs93A+a7rmqqtP33MHl29jkMSZE=
Subject: FAILED: patch "[PATCH] net/mlx5e: Switchdev representors are not vlan challenged" failed to apply to 5.4-stable tree
To:     saeedm@nvidia.com, roid@nvidia.com, roopa@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Oct 2021 13:03:57 +0200
Message-ID: <163455503713075@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b2107cdc43d8601f2cadfba990ae844cc1f44e68 Mon Sep 17 00:00:00 2001
From: Saeed Mahameed <saeedm@nvidia.com>
Date: Mon, 4 Oct 2021 21:20:25 -0700
Subject: [PATCH] net/mlx5e: Switchdev representors are not vlan challenged

Before this patch, mlx5 representors advertised the
NETIF_F_VLAN_CHALLENGED bit, this could lead to missing features when
using reps with vxlan/bridge and maybe other virtual interfaces,
when such interfaces inherit this bit and block vlan usage in their
topology.

Example:
$ip link add dev bridge type bridge
 # add representor interface to the bridge
$ip link set dev pf0hpf master
$ip link add link bridge name vlan10 type vlan id 10 protocol 802.1q
Error: 8021q: VLANs not supported on device.

Reps are perfectly capable of handling vlan traffic, although they don't
implement vlan_{add,kill}_vid ndos, hence, remove
NETIF_F_VLAN_CHALLENGED advertisement.

Fixes: cb67b832921c ("net/mlx5e: Introduce SRIOV VF representors")
Reported-by: Roopa Prabhu <roopa@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 3dd1101cc693..0439203fc7d9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -643,7 +643,6 @@ static void mlx5e_build_rep_netdev(struct net_device *netdev,
 	netdev->hw_features    |= NETIF_F_RXCSUM;
 
 	netdev->features |= netdev->hw_features;
-	netdev->features |= NETIF_F_VLAN_CHALLENGED;
 	netdev->features |= NETIF_F_NETNS_LOCAL;
 }
 

