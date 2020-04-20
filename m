Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0851B0A6E
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729204AbgDTMsM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:48:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:44496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729184AbgDTMsD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:48:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1FDA206D4;
        Mon, 20 Apr 2020 12:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386882;
        bh=QA1Pu+fudMlSNRK1ueStGrdWInKuciI08bM72ymnRqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s0uuQ98hIJ29zJ2ANX57VIoF4BLRpqoiLDQtgN5T4LabLyctf74RlghQ0ue2Md3JN
         bXvOXGu2bUXeYONsDllkp4Jp3Mvc9VhHyqMN4nA+vDYhDDY6KgONAib89EQ93ows5k
         eGfmdOcisX+YX8lfTGf61QZ5+VbXB7oMFBf6J7pM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 50/60] net/mlx5e: Use preactivate hook to set the indirection table
Date:   Mon, 20 Apr 2020 14:39:28 +0200
Message-Id: <20200420121513.877347142@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121500.490651540@linuxfoundation.org>
References: <20200420121500.490651540@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

[ Upstream commit fe867cac9e1967c553e4ac2aece5fc8675258010 ]

mlx5e_ethtool_set_channels updates the indirection table before
switching to the new channels. If the switch fails, the indirection
table is new, but the channels are old, which is wrong. Fix it by using
the preactivate hook of mlx5e_safe_switch_channels to update the
indirection table at the stage when nothing can fail anymore.

As the code that updates the indirection table is now encapsulated into
a new function, use that function in the attach flow when the driver has
to reduce the number of channels, and prepare the code for the next
commit.

Fixes: 85082dba0a ("net/mlx5e: Correctly handle RSS indirection table when changing number of channels")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h     |  1 +
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c | 10 ++--------
 .../net/ethernet/mellanox/mlx5/core/en_main.c    | 16 ++++++++++++++--
 3 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 3cb5b4321bf93..11426f94c90c6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1043,6 +1043,7 @@ int mlx5e_safe_reopen_channels(struct mlx5e_priv *priv);
 int mlx5e_safe_switch_channels(struct mlx5e_priv *priv,
 			       struct mlx5e_channels *new_chs,
 			       mlx5e_fp_preactivate preactivate);
+int mlx5e_num_channels_changed(struct mlx5e_priv *priv);
 void mlx5e_activate_priv_channels(struct mlx5e_priv *priv);
 void mlx5e_deactivate_priv_channels(struct mlx5e_priv *priv);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index c6776f308d5e6..304ddce6b0872 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -445,9 +445,7 @@ int mlx5e_ethtool_set_channels(struct mlx5e_priv *priv,
 
 	if (!test_bit(MLX5E_STATE_OPENED, &priv->state)) {
 		*cur_params = new_channels.params;
-		if (!netif_is_rxfh_configured(priv->netdev))
-			mlx5e_build_default_indir_rqt(priv->rss_params.indirection_rqt,
-						      MLX5E_INDIR_RQT_SIZE, count);
+		mlx5e_num_channels_changed(priv);
 		goto out;
 	}
 
@@ -455,12 +453,8 @@ int mlx5e_ethtool_set_channels(struct mlx5e_priv *priv,
 	if (arfs_enabled)
 		mlx5e_arfs_disable(priv);
 
-	if (!netif_is_rxfh_configured(priv->netdev))
-		mlx5e_build_default_indir_rqt(priv->rss_params.indirection_rqt,
-					      MLX5E_INDIR_RQT_SIZE, count);
-
 	/* Switch to new channels, set new parameters and close old ones */
-	err = mlx5e_safe_switch_channels(priv, &new_channels, NULL);
+	err = mlx5e_safe_switch_channels(priv, &new_channels, mlx5e_num_channels_changed);
 
 	if (arfs_enabled) {
 		int err2 = mlx5e_arfs_enable(priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index c58f02258ddfa..88ea279c29bb8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2908,6 +2908,17 @@ static void mlx5e_update_netdev_queues(struct mlx5e_priv *priv)
 	netif_set_real_num_rx_queues(netdev, num_rxqs);
 }
 
+int mlx5e_num_channels_changed(struct mlx5e_priv *priv)
+{
+	u16 count = priv->channels.params.num_channels;
+
+	if (!netif_is_rxfh_configured(priv->netdev))
+		mlx5e_build_default_indir_rqt(priv->rss_params.indirection_rqt,
+					      MLX5E_INDIR_RQT_SIZE, count);
+
+	return 0;
+}
+
 static void mlx5e_build_txq_maps(struct mlx5e_priv *priv)
 {
 	int i, ch;
@@ -5315,9 +5326,10 @@ int mlx5e_attach_netdev(struct mlx5e_priv *priv)
 	max_nch = mlx5e_get_max_num_channels(priv->mdev);
 	if (priv->channels.params.num_channels > max_nch) {
 		mlx5_core_warn(priv->mdev, "MLX5E: Reducing number of channels to %d\n", max_nch);
+		/* Reducing the number of channels - RXFH has to be reset. */
+		priv->netdev->priv_flags &= ~IFF_RXFH_CONFIGURED;
 		priv->channels.params.num_channels = max_nch;
-		mlx5e_build_default_indir_rqt(priv->rss_params.indirection_rqt,
-					      MLX5E_INDIR_RQT_SIZE, max_nch);
+		mlx5e_num_channels_changed(priv);
 	}
 
 	err = profile->init_tx(priv);
-- 
2.20.1



