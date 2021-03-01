Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6142C328B0A
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:30:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237630AbhCAS1d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:27:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:39440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239755AbhCASUg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:20:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC37E652F0;
        Mon,  1 Mar 2021 17:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620395;
        bh=QaNgJiOkigIibnNgNVhZ1DM46i6nsIWKmFiVKhSXCac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eq4uQx1JliWcpr3ygMxPaMEpa2v+GTzTYoq1iVOKaD8gHOSSJz2rDq9IfmOHOSVY0
         Pxq7JsAG0VmQhhdZeeV5EJU1ZuPyPtlwZ+OaOzAYPsiF2lRG7MR/eYXiPBIEzx1bDM
         /cfoFtO3v1MiKzvASuAfPIPHx5692K8RHocH+VBk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 107/775] net/mlx5e: Change interrupt moderation channel params also when channels are closed
Date:   Mon,  1 Mar 2021 17:04:35 +0100
Message-Id: <20210301161206.949619302@linuxfoundation.org>
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

[ Upstream commit 65ba8594a238c20e458b3d2d39d91067cbffd0b1 ]

struct mlx5e_params contains fields ({rx,tx}_cq_moderation) that depend
on two things: whether DIM is enabled and the state of a private flag
(MLX5E_PFLAG_{RX,TX}_CQE_BASED_MODER). Whenever the DIM state changes,
mlx5e_reset_{rx,tx}_moderation is called to update the fields, however,
only if the channels are open. The flow where the channels are closed
misses the required update of the fields. This commit moves the calls of
mlx5e_reset_{rx,tx}_moderation, so that they run in both flows.

Fixes: ebeaf084ad5c ("net/mlx5e: Properly set default values when disabling adaptive moderation")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  | 29 +++++++++----------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index d7ff5fa45cb7d..8612c388db7d3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -597,24 +597,9 @@ int mlx5e_ethtool_set_coalesce(struct mlx5e_priv *priv,
 	tx_moder->pkts    = coal->tx_max_coalesced_frames;
 	new_channels.params.tx_dim_enabled = !!coal->use_adaptive_tx_coalesce;
 
-	if (!test_bit(MLX5E_STATE_OPENED, &priv->state)) {
-		priv->channels.params = new_channels.params;
-		goto out;
-	}
-	/* we are opened */
-
 	reset_rx = !!coal->use_adaptive_rx_coalesce != priv->channels.params.rx_dim_enabled;
 	reset_tx = !!coal->use_adaptive_tx_coalesce != priv->channels.params.tx_dim_enabled;
 
-	if (!reset_rx && !reset_tx) {
-		if (!coal->use_adaptive_rx_coalesce)
-			mlx5e_set_priv_channels_rx_coalesce(priv, coal);
-		if (!coal->use_adaptive_tx_coalesce)
-			mlx5e_set_priv_channels_tx_coalesce(priv, coal);
-		priv->channels.params = new_channels.params;
-		goto out;
-	}
-
 	if (reset_rx) {
 		u8 mode = MLX5E_GET_PFLAG(&new_channels.params,
 					  MLX5E_PFLAG_RX_CQE_BASED_MODER);
@@ -628,6 +613,20 @@ int mlx5e_ethtool_set_coalesce(struct mlx5e_priv *priv,
 		mlx5e_reset_tx_moderation(&new_channels.params, mode);
 	}
 
+	if (!test_bit(MLX5E_STATE_OPENED, &priv->state)) {
+		priv->channels.params = new_channels.params;
+		goto out;
+	}
+
+	if (!reset_rx && !reset_tx) {
+		if (!coal->use_adaptive_rx_coalesce)
+			mlx5e_set_priv_channels_rx_coalesce(priv, coal);
+		if (!coal->use_adaptive_tx_coalesce)
+			mlx5e_set_priv_channels_tx_coalesce(priv, coal);
+		priv->channels.params = new_channels.params;
+		goto out;
+	}
+
 	err = mlx5e_safe_switch_channels(priv, &new_channels, NULL, NULL);
 
 out:
-- 
2.27.0



