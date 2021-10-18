Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F72E4316BF
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 13:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbhJRLFv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 07:05:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:54542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229670AbhJRLFu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 07:05:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E3A160F0F;
        Mon, 18 Oct 2021 11:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634555016;
        bh=HbLKdRN2al3X5fmfIu5WQ8yIYGPOfhm67KD1OFx2UwI=;
        h=Subject:To:Cc:From:Date:From;
        b=vPtcByUOeLB90PutQk9Fyj6/CAR5vUVcopSn/ebSrvJYVMco1odwjAMAWxqtUH/ST
         tqUyuLLG9EgRDLLrnZ8k2p0LpUVU6eybbouyM3kGfyIPLcpy+CkqGYUlZ9Bin87ohb
         80vcm0lkZ2yQ1VVYSzd5t7C9RbH89ZVlQBzhfpPk=
Subject: FAILED: patch "[PATCH] net/mlx5e: Mutually exclude RX-FCS and RX-port-timestamp" failed to apply to 4.14-stable tree
To:     ayal@nvidia.com, moshe@nvidia.com, saeedm@nvidia.com,
        tariqt@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Oct 2021 13:03:33 +0200
Message-ID: <1634555013249143@kroah.com>
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

From 0bc73ad46a76ed6ece4dcacb28858e7b38561e1c Mon Sep 17 00:00:00 2001
From: Aya Levin <ayal@nvidia.com>
Date: Sun, 26 Sep 2021 17:55:41 +0300
Subject: [PATCH] net/mlx5e: Mutually exclude RX-FCS and RX-port-timestamp

Due to current HW arch limitations, RX-FCS (scattering FCS frame field
to software) and RX-port-timestamp (improved timestamp accuracy on the
receive side) can't work together.
RX-port-timestamp is not controlled by the user and it is enabled by
default when supported by the HW/FW.
This patch sets RX-port-timestamp opposite to RX-FCS configuration.

Fixes: 102722fc6832 ("net/mlx5e: Add support for RXFCS feature flag")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 336aa07313da..09c8b71b186c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3325,20 +3325,67 @@ static int set_feature_rx_all(struct net_device *netdev, bool enable)
 	return mlx5_set_port_fcs(mdev, !enable);
 }
 
+static int mlx5e_set_rx_port_ts(struct mlx5_core_dev *mdev, bool enable)
+{
+	u32 in[MLX5_ST_SZ_DW(pcmr_reg)] = {};
+	bool supported, curr_state;
+	int err;
+
+	if (!MLX5_CAP_GEN(mdev, ports_check))
+		return 0;
+
+	err = mlx5_query_ports_check(mdev, in, sizeof(in));
+	if (err)
+		return err;
+
+	supported = MLX5_GET(pcmr_reg, in, rx_ts_over_crc_cap);
+	curr_state = MLX5_GET(pcmr_reg, in, rx_ts_over_crc);
+
+	if (!supported || enable == curr_state)
+		return 0;
+
+	MLX5_SET(pcmr_reg, in, local_port, 1);
+	MLX5_SET(pcmr_reg, in, rx_ts_over_crc, enable);
+
+	return mlx5_set_ports_check(mdev, in, sizeof(in));
+}
+
 static int set_feature_rx_fcs(struct net_device *netdev, bool enable)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
+	struct mlx5e_channels *chs = &priv->channels;
+	struct mlx5_core_dev *mdev = priv->mdev;
 	int err;
 
 	mutex_lock(&priv->state_lock);
 
-	priv->channels.params.scatter_fcs_en = enable;
-	err = mlx5e_modify_channels_scatter_fcs(&priv->channels, enable);
-	if (err)
-		priv->channels.params.scatter_fcs_en = !enable;
+	if (enable) {
+		err = mlx5e_set_rx_port_ts(mdev, false);
+		if (err)
+			goto out;
 
-	mutex_unlock(&priv->state_lock);
+		chs->params.scatter_fcs_en = true;
+		err = mlx5e_modify_channels_scatter_fcs(chs, true);
+		if (err) {
+			chs->params.scatter_fcs_en = false;
+			mlx5e_set_rx_port_ts(mdev, true);
+		}
+	} else {
+		chs->params.scatter_fcs_en = false;
+		err = mlx5e_modify_channels_scatter_fcs(chs, false);
+		if (err) {
+			chs->params.scatter_fcs_en = true;
+			goto out;
+		}
+		err = mlx5e_set_rx_port_ts(mdev, true);
+		if (err) {
+			mlx5_core_warn(mdev, "Failed to set RX port timestamp %d\n", err);
+			err = 0;
+		}
+	}
 
+out:
+	mutex_unlock(&priv->state_lock);
 	return err;
 }
 
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index f3638d09ba77..993204a6c1a1 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -9475,16 +9475,22 @@ struct mlx5_ifc_pcmr_reg_bits {
 	u8         reserved_at_0[0x8];
 	u8         local_port[0x8];
 	u8         reserved_at_10[0x10];
+
 	u8         entropy_force_cap[0x1];
 	u8         entropy_calc_cap[0x1];
 	u8         entropy_gre_calc_cap[0x1];
-	u8         reserved_at_23[0x1b];
+	u8         reserved_at_23[0xf];
+	u8         rx_ts_over_crc_cap[0x1];
+	u8         reserved_at_33[0xb];
 	u8         fcs_cap[0x1];
 	u8         reserved_at_3f[0x1];
+
 	u8         entropy_force[0x1];
 	u8         entropy_calc[0x1];
 	u8         entropy_gre_calc[0x1];
-	u8         reserved_at_43[0x1b];
+	u8         reserved_at_43[0xf];
+	u8         rx_ts_over_crc[0x1];
+	u8         reserved_at_53[0xb];
 	u8         fcs_chk[0x1];
 	u8         reserved_at_5f[0x1];
 };

