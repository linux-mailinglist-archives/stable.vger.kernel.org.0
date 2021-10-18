Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE984316C6
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 13:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbhJRLGY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 07:06:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:54962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229781AbhJRLGY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 07:06:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88E9360F56;
        Mon, 18 Oct 2021 11:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634555053;
        bh=ZK98QgJj2S640P3YjeXAtrus9rB8uQulb177Ctz4yb8=;
        h=Subject:To:Cc:From:Date:From;
        b=pH303plDe0oQJt92aTvnoDdHsHL+SBVoTptS/rKnlKNZ9pediPri21elju3grNlfw
         u8mYEm5Yz+VA8WJhaV+PCTq92HKDWnB4vu1CVCPA6/Qd7/kWFzbPOFCAF4R7uId880
         8DBGmQCeV3pcdRqV7M4v5Tg1O9MSqRiHuVKeBj2U=
Subject: FAILED: patch "[PATCH] net/mlx5e: Switchdev representors are not vlan challenged" failed to apply to 4.14-stable tree
To:     saeedm@nvidia.com, roid@nvidia.com, roopa@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Oct 2021 13:03:58 +0200
Message-ID: <163455503878185@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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
 

