Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1D749A2E5
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2366008AbiAXXwJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:52:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1843474AbiAXXED (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:04:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89AA7C06C5AC;
        Mon, 24 Jan 2022 13:15:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 275E661425;
        Mon, 24 Jan 2022 21:15:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE212C340E5;
        Mon, 24 Jan 2022 21:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058911;
        bh=jCLuVy28HwBiuUUxs7Ez/SG8B5g+9UJE++jF70kFQIw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dMKO6dQw36Sz86pGfU69dsVHVksUa6ale4o1YE4JczNWWHm4OEfRoqX78YGQ56mgs
         B0UdcZviDa3qEfPwfAWV0XGgBouXDmrHaMl59fa/94y0dcYa23/tyXWJ0627NGLHcA
         s1CeiA0Lci1EiVRXhm0rHExqcUwREluUQ147ZZBo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0410/1039] Revert "net/mlx5e: Block offload of outer header csum for GRE tunnel"
Date:   Mon, 24 Jan 2022 19:36:39 +0100
Message-Id: <20220124184139.096166047@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

[ Upstream commit 01c3fd113ef50490ffd43f78f347ef6bb008510b ]

This reverts commit 54e1217b90486c94b26f24dcee1ee5ef5372f832.

Although the NIC doesn't support offload of outer header CSUM, using
gso_partial_features allows offloading the tunnel's segmentation. The
driver relies on the stack CSUM calculation of the outer header. For
this, NETIF_F_GSO_GRE_CSUM must be a member of the device's features.

Fixes: 54e1217b9048 ("net/mlx5e: Block offload of outer header csum for GRE tunnel")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index de8acd3217c18..d92b82cdfd4e1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4799,9 +4799,12 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 	}
 
 	if (mlx5e_tunnel_proto_supported_tx(mdev, IPPROTO_GRE)) {
-		netdev->hw_features     |= NETIF_F_GSO_GRE;
-		netdev->hw_enc_features |= NETIF_F_GSO_GRE;
-		netdev->gso_partial_features |= NETIF_F_GSO_GRE;
+		netdev->hw_features     |= NETIF_F_GSO_GRE |
+					   NETIF_F_GSO_GRE_CSUM;
+		netdev->hw_enc_features |= NETIF_F_GSO_GRE |
+					   NETIF_F_GSO_GRE_CSUM;
+		netdev->gso_partial_features |= NETIF_F_GSO_GRE |
+						NETIF_F_GSO_GRE_CSUM;
 	}
 
 	if (mlx5e_tunnel_proto_supported_tx(mdev, IPPROTO_IPIP)) {
-- 
2.34.1



