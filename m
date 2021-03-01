Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFA7328D7E
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:13:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239975AbhCATMg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:12:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:38012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241042AbhCATHv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:07:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E15EA652F1;
        Mon,  1 Mar 2021 17:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620392;
        bh=6tQuBOcSMBf/r/Lu7ClQnfu6VIfyAsAgETUbur8U/js=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ce44akyI5ThUjH05mLxbzQjMeCOl8VMneZBqqGJi9D9QYRKKFrv3Mv/3aLZ/syLnB
         s3eRF2hRyR0bvGqb+fVtA1e4JtUp7h+950oT8RC63dNZX0qeWpAff6r1N0vFwkV9Wc
         T+L1kIF+nPG1MNi/ac21H2BYWj88XpU+CueiOksk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 106/775] net/mlx5e: Dont change interrupt moderation params when DIM is enabled
Date:   Mon,  1 Mar 2021 17:04:34 +0100
Message-Id: <20210301161206.898831830@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

[ Upstream commit 019f93bc4ba3a0dcb77f448ee77fc4c9c1b89565 ]

When mlx5e_ethtool_set_coalesce doesn't change DIM state
(enabled/disabled), it calls mlx5e_set_priv_channels_coalesce
unconditionally, which in turn invokes a firmware command to set
interrupt moderation parameters. It shouldn't happen while DIM manages
those parameters dynamically (it might even be happening at the same
time).

This patch fixes it by splitting mlx5e_set_priv_channels_coalesce into
two functions (for RX and TX) and calling them only when DIM is disabled
(for RX and TX respectively).

Fixes: cb3c7fd4f839 ("net/mlx5e: Support adaptive RX coalescing")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/en_ethtool.c   | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 302001d6661ea..d7ff5fa45cb7d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -525,7 +525,7 @@ static int mlx5e_get_coalesce(struct net_device *netdev,
 #define MLX5E_MAX_COAL_FRAMES		MLX5_MAX_CQ_COUNT
 
 static void
-mlx5e_set_priv_channels_coalesce(struct mlx5e_priv *priv, struct ethtool_coalesce *coal)
+mlx5e_set_priv_channels_tx_coalesce(struct mlx5e_priv *priv, struct ethtool_coalesce *coal)
 {
 	struct mlx5_core_dev *mdev = priv->mdev;
 	int tc;
@@ -540,6 +540,17 @@ mlx5e_set_priv_channels_coalesce(struct mlx5e_priv *priv, struct ethtool_coalesc
 						coal->tx_coalesce_usecs,
 						coal->tx_max_coalesced_frames);
 		}
+	}
+}
+
+static void
+mlx5e_set_priv_channels_rx_coalesce(struct mlx5e_priv *priv, struct ethtool_coalesce *coal)
+{
+	struct mlx5_core_dev *mdev = priv->mdev;
+	int i;
+
+	for (i = 0; i < priv->channels.num; ++i) {
+		struct mlx5e_channel *c = priv->channels.c[i];
 
 		mlx5_core_modify_cq_moderation(mdev, &c->rq.cq.mcq,
 					       coal->rx_coalesce_usecs,
@@ -596,7 +607,10 @@ int mlx5e_ethtool_set_coalesce(struct mlx5e_priv *priv,
 	reset_tx = !!coal->use_adaptive_tx_coalesce != priv->channels.params.tx_dim_enabled;
 
 	if (!reset_rx && !reset_tx) {
-		mlx5e_set_priv_channels_coalesce(priv, coal);
+		if (!coal->use_adaptive_rx_coalesce)
+			mlx5e_set_priv_channels_rx_coalesce(priv, coal);
+		if (!coal->use_adaptive_tx_coalesce)
+			mlx5e_set_priv_channels_tx_coalesce(priv, coal);
 		priv->channels.params = new_channels.params;
 		goto out;
 	}
-- 
2.27.0



