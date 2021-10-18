Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62DC7431C64
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233563AbhJRNko (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:40:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:54246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233885AbhJRNjB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:39:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DCD961381;
        Mon, 18 Oct 2021 13:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563948;
        bh=ir5dbfz+zYqI6AoqS2crXAXXvqIJm9yc4/M5GcsdZ3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ffwxwP0gPAx1aePfYWFTVUE4rmrx5dNOe94wBy7QuGyotacwHWVUKs85b/DrXJv+r
         l4WAmZG8xVjkbzrBzSIx2m8Z5LEeplYEjYvWajBk/9O00t/ClBkhhUpU/hUXJY6HwC
         PPHTiTzqyB0vBjPkrwub4LwWFfSJhSx3Qj+KGvSs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.4 49/69] net/mlx5e: Mutually exclude RX-FCS and RX-port-timestamp
Date:   Mon, 18 Oct 2021 15:24:47 +0200
Message-Id: <20211018132331.116072515@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132329.453964125@linuxfoundation.org>
References: <20211018132329.453964125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

commit 0bc73ad46a76ed6ece4dcacb28858e7b38561e1c upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c |   57 ++++++++++++++++++++--
 include/linux/mlx5/mlx5_ifc.h                     |   10 +++
 2 files changed, 60 insertions(+), 7 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3805,20 +3805,67 @@ static int set_feature_rx_all(struct net
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
+
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
 	mutex_unlock(&priv->state_lock);
-
 	return err;
 }
 
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -8942,16 +8942,22 @@ struct mlx5_ifc_pcmr_reg_bits {
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


