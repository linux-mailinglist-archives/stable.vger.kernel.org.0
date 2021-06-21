Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3E113AEF74
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232211AbhFUQiv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:38:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:55204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232296AbhFUQhJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:37:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A74961421;
        Mon, 21 Jun 2021 16:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292918;
        bh=4X2/9wtd1+Rg1rY65WpgQucz5GudgJI3ZMxX7snrEbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NWtanz7kyh/SikQBNVv7NgH5AHcbgYDF1fqTaRZmtE2sTpc0q0hcILW9krv3u2N8V
         vfrpRBVt0q3RkvLeGYsXP6Jn8CVWNqoLyz48BGyceLuajzG7Hyl/aTwS86Rk/A0THf
         zb674wftTgPlRshPU/BfGD/K2CPJSKkYjln0n4gQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huy Nguyen <huyn@nvidia.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 033/178] net/mlx5e: Remove dependency in IPsec initialization flows
Date:   Mon, 21 Jun 2021 18:14:07 +0200
Message-Id: <20210621154923.069066848@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huy Nguyen <huyn@nvidia.com>

[ Upstream commit 8ad893e516a77209a1818a2072d2027d87db809f ]

Currently, IPsec feature is disabled because mlx5e_build_nic_netdev
is required to be called after mlx5e_ipsec_init. This requirement is
invalid as mlx5e_build_nic_netdev and mlx5e_ipsec_init initialize
independent resources.

Remove ipsec pointer check in mlx5e_build_nic_netdev so that the
two functions can be called at any order.

Fixes: 547eede070eb ("net/mlx5e: IPSec, Innova IPSec offload infrastructure")
Signed-off-by: Huy Nguyen <huyn@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 3d45341e2216..26f7fab109d9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -532,9 +532,6 @@ void mlx5e_ipsec_build_netdev(struct mlx5e_priv *priv)
 	struct mlx5_core_dev *mdev = priv->mdev;
 	struct net_device *netdev = priv->netdev;
 
-	if (!priv->ipsec)
-		return;
-
 	if (!(mlx5_accel_ipsec_device_caps(mdev) & MLX5_ACCEL_IPSEC_CAP_ESP) ||
 	    !MLX5_CAP_ETH(mdev, swp)) {
 		mlx5_core_dbg(mdev, "mlx5e: ESP and SWP offload not supported\n");
-- 
2.30.2



