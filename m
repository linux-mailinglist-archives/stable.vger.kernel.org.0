Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB9C30C065
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 14:56:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233367AbhBBN4k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 08:56:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:42464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233315AbhBBNy0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:54:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 012F864FD5;
        Tue,  2 Feb 2021 13:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273474;
        bh=98rbjxgAR5G3OpCfYFTSl96R6LSqbUY+msmbIe8BH6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wCQzdsz34qY0r3dSzvwNJbOvygvrvl0ffabbQ3TCQ8t4peA4xvNy5evhxMOxj6jiB
         jzovxxa8QBCpEve6QeZBJI760DXRL2f7ptCr2i7bQAGrzIlguAuxkJWYoL6u35qlb6
         f1UA1fZhlqkghWaz4FKvP+F4DRsZi2IheHPhXIL8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 121/142] net/mlx5e: Correctly handle changing the number of queues when the interface is down
Date:   Tue,  2 Feb 2021 14:38:04 +0100
Message-Id: <20210202133002.701434154@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

[ Upstream commit 57ac4a31c48377a3e675b2a731ceacbefefcd34d ]

This commit addresses two issues related to changing the number of
queues when the channels are closed:

1. Missing call to mlx5e_num_channels_changed to update
real_num_tx_queues when the number of TCs is changed.

2. When mlx5e_num_channels_changed returns an error, the channel
parameters must be reverted.

Two Fixes: tags correspond to the first commits where these two issues
were introduced.

Fixes: 3909a12e7913 ("net/mlx5e: Fix configuration of XPS cpumasks and netdev queues in corner cases")
Fixes: fa3748775b92 ("net/mlx5e: Handle errors from netif_set_real_num_{tx,rx}_queues")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 8 +++++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c    | 7 +++++++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index f01395a9fd8df..e596f050c4316 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -444,12 +444,18 @@ int mlx5e_ethtool_set_channels(struct mlx5e_priv *priv,
 		goto out;
 	}
 
-	new_channels.params = priv->channels.params;
+	new_channels.params = *cur_params;
 	new_channels.params.num_channels = count;
 
 	if (!test_bit(MLX5E_STATE_OPENED, &priv->state)) {
+		struct mlx5e_params old_params;
+
+		old_params = *cur_params;
 		*cur_params = new_channels.params;
 		err = mlx5e_num_channels_changed(priv);
+		if (err)
+			*cur_params = old_params;
+
 		goto out;
 	}
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index ba6c75618a710..000dacaa3333c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3580,7 +3580,14 @@ static int mlx5e_setup_tc_mqprio(struct mlx5e_priv *priv,
 	new_channels.params.num_tc = tc ? tc : 1;
 
 	if (!test_bit(MLX5E_STATE_OPENED, &priv->state)) {
+		struct mlx5e_params old_params;
+
+		old_params = priv->channels.params;
 		priv->channels.params = new_channels.params;
+		err = mlx5e_num_channels_changed(priv);
+		if (err)
+			priv->channels.params = old_params;
+
 		goto out;
 	}
 
-- 
2.27.0



