Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D757541256C
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349958AbhITSpF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:45:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:56452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1382748AbhITSmT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:42:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3AF6963341;
        Mon, 20 Sep 2021 17:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159111;
        bh=49JkvU8ayYHHtf+h6HGd2/0r7wwEaHv43nyKbV7q9B4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zqG91Mo6Hj9mnTVqd8sXy5kbFmehHLx2GMfSQWLN1vO0iGQPTZkKZupqVjpBWaSBs
         Q/QnzaYn03FJ9Rj6GcpTlPJ+DjXw+qQuIpnFoRw7X93NQ73AeggG17A9CMjBdF+FkC
         5cXKUsq6Hr0ZYA/krxdwUOW5DQbW0FAn0y5XsinY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 081/168] net/mlx5e: Fix mutual exclusion between CQE compression and HW TS
Date:   Mon, 20 Sep 2021 18:43:39 +0200
Message-Id: <20210920163924.302278254@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

[ Upstream commit c91c1da72b47fc4c5e353cdd9099ba94ae07d2fa ]

Some profiles of the driver don't support a dedicated PTP-RQ, hence can't
support HW TS and CQE compression simultaneously. When HW TS is enabled
the COE compression is disabled, and should be restored when the HW TS
is turned off. Add rx_filter as an input to modifying CQE compression to
enforce this restriction.

Fixes: 256f79d13c1d ("net/mlx5e: Fix HW TS with CQE compression according to profile")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h         |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 11 ++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c    |  4 ++--
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index b1b51bbba054..3f67efbe12fc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -940,7 +940,7 @@ void mlx5e_set_rx_mode_work(struct work_struct *work);
 
 int mlx5e_hwstamp_set(struct mlx5e_priv *priv, struct ifreq *ifr);
 int mlx5e_hwstamp_get(struct mlx5e_priv *priv, struct ifreq *ifr);
-int mlx5e_modify_rx_cqe_compression_locked(struct mlx5e_priv *priv, bool val);
+int mlx5e_modify_rx_cqe_compression_locked(struct mlx5e_priv *priv, bool val, bool rx_filter);
 
 int mlx5e_vlan_rx_add_vid(struct net_device *dev, __always_unused __be16 proto,
 			  u16 vid);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index bd72572e03d1..1cc279d389d6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1882,7 +1882,7 @@ static int set_pflag_rx_cqe_based_moder(struct net_device *netdev, bool enable)
 	return set_pflag_cqe_based_moder(netdev, enable, true);
 }
 
-int mlx5e_modify_rx_cqe_compression_locked(struct mlx5e_priv *priv, bool new_val)
+int mlx5e_modify_rx_cqe_compression_locked(struct mlx5e_priv *priv, bool new_val, bool rx_filter)
 {
 	bool curr_val = MLX5E_GET_PFLAG(&priv->channels.params, MLX5E_PFLAG_RX_CQE_COMPRESS);
 	struct mlx5e_params new_params;
@@ -1894,8 +1894,7 @@ int mlx5e_modify_rx_cqe_compression_locked(struct mlx5e_priv *priv, bool new_val
 	if (curr_val == new_val)
 		return 0;
 
-	if (new_val && !priv->profile->rx_ptp_support &&
-	    priv->tstamp.rx_filter != HWTSTAMP_FILTER_NONE) {
+	if (new_val && !priv->profile->rx_ptp_support && rx_filter) {
 		netdev_err(priv->netdev,
 			   "Profile doesn't support enabling of CQE compression while hardware time-stamping is enabled.\n");
 		return -EINVAL;
@@ -1903,7 +1902,7 @@ int mlx5e_modify_rx_cqe_compression_locked(struct mlx5e_priv *priv, bool new_val
 
 	new_params = priv->channels.params;
 	MLX5E_SET_PFLAG(&new_params, MLX5E_PFLAG_RX_CQE_COMPRESS, new_val);
-	if (priv->tstamp.rx_filter != HWTSTAMP_FILTER_NONE)
+	if (rx_filter)
 		new_params.ptp_rx = new_val;
 
 	if (new_params.ptp_rx == priv->channels.params.ptp_rx)
@@ -1926,12 +1925,14 @@ static int set_pflag_rx_cqe_compress(struct net_device *netdev,
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct mlx5_core_dev *mdev = priv->mdev;
+	bool rx_filter;
 	int err;
 
 	if (!MLX5_CAP_GEN(mdev, cqe_compression))
 		return -EOPNOTSUPP;
 
-	err = mlx5e_modify_rx_cqe_compression_locked(priv, enable);
+	rx_filter = priv->tstamp.rx_filter != HWTSTAMP_FILTER_NONE;
+	err = mlx5e_modify_rx_cqe_compression_locked(priv, enable, rx_filter);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 2d53eaf3b924..fa718e71db2d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4004,14 +4004,14 @@ static int mlx5e_hwstamp_config_no_ptp_rx(struct mlx5e_priv *priv, bool rx_filte
 
 	if (!rx_filter)
 		/* Reset CQE compression to Admin default */
-		return mlx5e_modify_rx_cqe_compression_locked(priv, rx_cqe_compress_def);
+		return mlx5e_modify_rx_cqe_compression_locked(priv, rx_cqe_compress_def, false);
 
 	if (!MLX5E_GET_PFLAG(&priv->channels.params, MLX5E_PFLAG_RX_CQE_COMPRESS))
 		return 0;
 
 	/* Disable CQE compression */
 	netdev_warn(priv->netdev, "Disabling RX cqe compression\n");
-	err = mlx5e_modify_rx_cqe_compression_locked(priv, false);
+	err = mlx5e_modify_rx_cqe_compression_locked(priv, false, true);
 	if (err)
 		netdev_err(priv->netdev, "Failed disabling cqe compression err=%d\n", err);
 
-- 
2.30.2



