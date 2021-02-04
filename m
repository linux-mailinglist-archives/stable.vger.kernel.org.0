Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7988430CBFE
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 20:45:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233172AbhBBTlh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 14:41:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:42642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232971AbhBBNyh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:54:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5262D64FD7;
        Tue,  2 Feb 2021 13:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273479;
        bh=A28gzi2WDvFKHk/b98Fb/Cqxt30A78Zzq7MV7CkN7xM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=INJQbQKWuXaCHb2WS/Rgt6lK8BzV+d+qnTf8fJOJBC71oI6HQv79T4hFbGZyufz+5
         HvchjmNYRC6hESIkn2/YBBwjad9GcatmzXpzO3nRFNyXiTnJpTW/LaBtnamVUXuyfJ
         wHSWyqiW6rViuf4U6g6ki+lgftq5Nlo89wlchFNI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 123/142] net/mlx5e: Revert parameters on errors when changing MTU and LRO state without reset
Date:   Tue,  2 Feb 2021 14:38:06 +0100
Message-Id: <20210202133002.776835451@linuxfoundation.org>
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

[ Upstream commit 8355060f5ec381abda77659f91f56302203df535 ]

Sometimes, channel params are changed without recreating the channels.
It happens in two basic cases: when the channels are closed, and when
the parameter being changed doesn't affect how channels are configured.
Such changes invoke a hardware command that might fail. The whole
operation should be reverted in such cases, but the code that restores
the parameters' values in the driver was missing. This commit adds this
handling.

Fixes: 2e20a151205b ("net/mlx5e: Fail safe mtu and lro setting")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 30 +++++++++++++------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 000dacaa3333c..c9b5d7f29911e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3730,7 +3730,7 @@ static int set_feature_lro(struct net_device *netdev, bool enable)
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct mlx5_core_dev *mdev = priv->mdev;
 	struct mlx5e_channels new_channels = {};
-	struct mlx5e_params *old_params;
+	struct mlx5e_params *cur_params;
 	int err = 0;
 	bool reset;
 
@@ -3743,8 +3743,8 @@ static int set_feature_lro(struct net_device *netdev, bool enable)
 		goto out;
 	}
 
-	old_params = &priv->channels.params;
-	if (enable && !MLX5E_GET_PFLAG(old_params, MLX5E_PFLAG_RX_STRIDING_RQ)) {
+	cur_params = &priv->channels.params;
+	if (enable && !MLX5E_GET_PFLAG(cur_params, MLX5E_PFLAG_RX_STRIDING_RQ)) {
 		netdev_warn(netdev, "can't set LRO with legacy RQ\n");
 		err = -EINVAL;
 		goto out;
@@ -3752,18 +3752,23 @@ static int set_feature_lro(struct net_device *netdev, bool enable)
 
 	reset = test_bit(MLX5E_STATE_OPENED, &priv->state);
 
-	new_channels.params = *old_params;
+	new_channels.params = *cur_params;
 	new_channels.params.lro_en = enable;
 
-	if (old_params->rq_wq_type != MLX5_WQ_TYPE_CYCLIC) {
-		if (mlx5e_rx_mpwqe_is_linear_skb(mdev, old_params, NULL) ==
+	if (cur_params->rq_wq_type != MLX5_WQ_TYPE_CYCLIC) {
+		if (mlx5e_rx_mpwqe_is_linear_skb(mdev, cur_params, NULL) ==
 		    mlx5e_rx_mpwqe_is_linear_skb(mdev, &new_channels.params, NULL))
 			reset = false;
 	}
 
 	if (!reset) {
-		*old_params = new_channels.params;
+		struct mlx5e_params old_params;
+
+		old_params = *cur_params;
+		*cur_params = new_channels.params;
 		err = mlx5e_modify_tirs_lro(priv);
+		if (err)
+			*cur_params = old_params;
 		goto out;
 	}
 
@@ -4037,9 +4042,16 @@ int mlx5e_change_mtu(struct net_device *netdev, int new_mtu,
 	}
 
 	if (!reset) {
+		unsigned int old_mtu = params->sw_mtu;
+
 		params->sw_mtu = new_mtu;
-		if (preactivate)
-			preactivate(priv, NULL);
+		if (preactivate) {
+			err = preactivate(priv, NULL);
+			if (err) {
+				params->sw_mtu = old_mtu;
+				goto out;
+			}
+		}
 		netdev->mtu = params->sw_mtu;
 		goto out;
 	}
-- 
2.27.0



