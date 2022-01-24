Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 180F6499135
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:12:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378789AbiAXUJv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:09:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376711AbiAXUDm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:03:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7002AC02B87F;
        Mon, 24 Jan 2022 11:30:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 278BBB81235;
        Mon, 24 Jan 2022 19:30:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B927C340E5;
        Mon, 24 Jan 2022 19:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052604;
        bh=nc8gMN6FupTObSdJAM/kKjoEdDwv+BPG9AeILVfjHF8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SVJYND4NJCtTOSJlHKveAw+MAU2g2oAkz/wtwnCzxxIn04LORxdUyaw4JDPIwnoz9
         ENcq51ObiR9B9I/Oy1uCWWyb6XIXl+PrQ8roXV/IYZrpBGeKINgrVWeh6HPENAgYUs
         Ja7kTEH0CUAfGZv9RjjVcG33ii1oUp59aTmRIhBw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 114/320] Revert "net/mlx5e: Block offload of outer header csum for UDP tunnels"
Date:   Mon, 24 Jan 2022 19:41:38 +0100
Message-Id: <20220124183957.584887635@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

[ Upstream commit 64050cdad0983ad8060e33c3f4b5aee2366bcebd ]

This reverts commit 6d6727dddc7f93fcc155cb8d0c49c29ae0e71122.

Although the NIC doesn't support offload of outer header CSUM, using
gso_partial_features allows offloading the tunnel's segmentation. The
driver relies on the stack CSUM calculation of the outer header. For
this, NETIF_F_GSO_UDP_TUNNEL_CSUM must be a member of the device's
features.

Fixes: 6d6727dddc7f ("net/mlx5e: Block offload of outer header csum for UDP tunnels")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index dea884c94568c..2465165cbea73 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5053,9 +5053,13 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 	}
 
 	if (mlx5_vxlan_allowed(mdev->vxlan) || mlx5_geneve_tx_allowed(mdev)) {
-		netdev->hw_features     |= NETIF_F_GSO_UDP_TUNNEL;
-		netdev->hw_enc_features |= NETIF_F_GSO_UDP_TUNNEL;
-		netdev->vlan_features |= NETIF_F_GSO_UDP_TUNNEL;
+		netdev->hw_features     |= NETIF_F_GSO_UDP_TUNNEL |
+					   NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		netdev->hw_enc_features |= NETIF_F_GSO_UDP_TUNNEL |
+					   NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		netdev->gso_partial_features = NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		netdev->vlan_features |= NETIF_F_GSO_UDP_TUNNEL |
+					 NETIF_F_GSO_UDP_TUNNEL_CSUM;
 	}
 
 	if (mlx5e_tunnel_proto_supported(mdev, IPPROTO_GRE)) {
-- 
2.34.1



