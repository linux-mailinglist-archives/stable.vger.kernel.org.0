Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26EA028792
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390144AbfEWTUz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:20:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:57862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389064AbfEWTUx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:20:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97DB52133D;
        Thu, 23 May 2019 19:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639253;
        bh=sJCR6HYhZ9KzscP49gMvokwJoVp2qhPpZKlo1TviAT4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gl5W+dwHAOgYiPO0ZRuKEvXVs3hx4TGOlCVdw2Y+WXcLYEGu+VtOXYTgdlpeRy8uJ
         17ZE0C3BMXVUKAML+nBIQG2tCdhkzPrVTV7UkuMtZzWNA3B/DNZ37WniIn2NNmNwVv
         2UyPr/k0pNv1rJVZVkx2sEpv1l6uEG/tsbcJpsas=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.0 018/139] net/mlx5e: Fix ethtool rxfh commands when CONFIG_MLX5_EN_RXNFC is disabled
Date:   Thu, 23 May 2019 21:05:06 +0200
Message-Id: <20190523181722.984518821@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181720.120897565@linuxfoundation.org>
References: <20190523181720.120897565@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>

[ Upstream commit 8f0916c6dc5cd5e3bc52416fa2a9ff4075080180 ]

ethtool user spaces needs to know ring count via ETHTOOL_GRXRINGS when
executing (ethtool -x) which is retrieved via ethtool get_rxnfc callback,
in mlx5 this callback is disabled when CONFIG_MLX5_EN_RXNFC=n.

This patch allows only ETHTOOL_GRXRINGS command on mlx5e_get_rxnfc() when
CONFIG_MLX5_EN_RXNFC is disabled, so ethtool -x will continue working.

Fixes: fe6d86b3c316 ("net/mlx5e: Add CONFIG_MLX5_EN_RXNFC for ethtool rx nfc")
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1802,6 +1802,22 @@ static int mlx5e_flash_device(struct net
 	return mlx5e_ethtool_flash_device(priv, flash);
 }
 
+#ifndef CONFIG_MLX5_EN_RXNFC
+/* When CONFIG_MLX5_EN_RXNFC=n we only support ETHTOOL_GRXRINGS
+ * otherwise this function will be defined from en_fs_ethtool.c
+ */
+static int mlx5e_get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *info, u32 *rule_locs)
+{
+	struct mlx5e_priv *priv = netdev_priv(dev);
+
+	if (info->cmd != ETHTOOL_GRXRINGS)
+		return -EOPNOTSUPP;
+	/* ring_count is needed by ethtool -x */
+	info->data = priv->channels.params.num_channels;
+	return 0;
+}
+#endif
+
 const struct ethtool_ops mlx5e_ethtool_ops = {
 	.get_drvinfo       = mlx5e_get_drvinfo,
 	.get_link          = ethtool_op_get_link,
@@ -1820,8 +1836,8 @@ const struct ethtool_ops mlx5e_ethtool_o
 	.get_rxfh_indir_size = mlx5e_get_rxfh_indir_size,
 	.get_rxfh          = mlx5e_get_rxfh,
 	.set_rxfh          = mlx5e_set_rxfh,
-#ifdef CONFIG_MLX5_EN_RXNFC
 	.get_rxnfc         = mlx5e_get_rxnfc,
+#ifdef CONFIG_MLX5_EN_RXNFC
 	.set_rxnfc         = mlx5e_set_rxnfc,
 #endif
 	.flash_device      = mlx5e_flash_device,


