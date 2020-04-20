Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC9711B0AE5
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729177AbgDTMsB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:48:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:44466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729172AbgDTMsA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:48:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76BB0206DD;
        Mon, 20 Apr 2020 12:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386880;
        bh=vvtxPGNY4H3Zah+sQGG8PCj/JswP2BP8CzeJyE9ExMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fDUdFpeONQBrjjfdT1Lwv52jGj4UJAmxRfYFaPl1BSRONSdLYkbE4+z9yDipTzTdm
         vcrR5ExfIyDJatomlybJvjjPDl8HMEW23q6R9Wjn15GVMU2MU/Py20Nir0CgIfmTr7
         Juo1wtQ36wqSQDrSxchjTB1XRZKNhSYG2WbcyS+Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 49/60] net/mlx5e: Rename hw_modify to preactivate
Date:   Mon, 20 Apr 2020 14:39:27 +0200
Message-Id: <20200420121513.644507412@linuxfoundation.org>
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

[ Upstream commit dca147b3dce5abb5284ff747211960fd2db5ec2e ]

mlx5e_safe_switch_channels accepts a callback to be called before
activating new channels. It is intended to configure some hardware
parameters in cases where channels are recreated because some
configuration has changed.

Recently, this callback has started being used to update the driver's
internal MLX5E_STATE_XDP_OPEN flag, and the following patches also
intend to use this callback for software preparations. This patch
renames the hw_modify callback to preactivate, so that the name fits
better.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h      |  6 +++---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 14 ++++++++------
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 55ceabf077b29..3cb5b4321bf93 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1035,14 +1035,14 @@ int mlx5e_open_channels(struct mlx5e_priv *priv,
 			struct mlx5e_channels *chs);
 void mlx5e_close_channels(struct mlx5e_channels *chs);
 
-/* Function pointer to be used to modify WH settings while
+/* Function pointer to be used to modify HW or kernel settings while
  * switching channels
  */
-typedef int (*mlx5e_fp_hw_modify)(struct mlx5e_priv *priv);
+typedef int (*mlx5e_fp_preactivate)(struct mlx5e_priv *priv);
 int mlx5e_safe_reopen_channels(struct mlx5e_priv *priv);
 int mlx5e_safe_switch_channels(struct mlx5e_priv *priv,
 			       struct mlx5e_channels *new_chs,
-			       mlx5e_fp_hw_modify hw_modify);
+			       mlx5e_fp_preactivate preactivate);
 void mlx5e_activate_priv_channels(struct mlx5e_priv *priv);
 void mlx5e_deactivate_priv_channels(struct mlx5e_priv *priv);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index dc456a222c48d..c58f02258ddfa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2965,7 +2965,7 @@ void mlx5e_deactivate_priv_channels(struct mlx5e_priv *priv)
 
 static void mlx5e_switch_priv_channels(struct mlx5e_priv *priv,
 				       struct mlx5e_channels *new_chs,
-				       mlx5e_fp_hw_modify hw_modify)
+				       mlx5e_fp_preactivate preactivate)
 {
 	struct net_device *netdev = priv->netdev;
 	int new_num_txqs;
@@ -2984,9 +2984,11 @@ static void mlx5e_switch_priv_channels(struct mlx5e_priv *priv,
 
 	priv->channels = *new_chs;
 
-	/* New channels are ready to roll, modify HW settings if needed */
-	if (hw_modify)
-		hw_modify(priv);
+	/* New channels are ready to roll, call the preactivate hook if needed
+	 * to modify HW settings or update kernel parameters.
+	 */
+	if (preactivate)
+		preactivate(priv);
 
 	priv->profile->update_rx(priv);
 	mlx5e_activate_priv_channels(priv);
@@ -2998,7 +3000,7 @@ static void mlx5e_switch_priv_channels(struct mlx5e_priv *priv,
 
 int mlx5e_safe_switch_channels(struct mlx5e_priv *priv,
 			       struct mlx5e_channels *new_chs,
-			       mlx5e_fp_hw_modify hw_modify)
+			       mlx5e_fp_preactivate preactivate)
 {
 	int err;
 
@@ -3006,7 +3008,7 @@ int mlx5e_safe_switch_channels(struct mlx5e_priv *priv,
 	if (err)
 		return err;
 
-	mlx5e_switch_priv_channels(priv, new_chs, hw_modify);
+	mlx5e_switch_priv_channels(priv, new_chs, preactivate);
 	return 0;
 }
 
-- 
2.20.1



