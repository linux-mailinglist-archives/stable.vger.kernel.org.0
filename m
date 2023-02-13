Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2F46948E7
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbjBMOyS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:54:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230491AbjBMOyP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:54:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BCBC5274
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:54:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA2B76112D
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:54:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE4F8C433EF;
        Mon, 13 Feb 2023 14:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300052;
        bh=eAji2CxCG2+/Ju2x9/gvG0BWgsAL/Wh0kTb3uVcNwYs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n+fQgdEQDfSO+dKH8cNU4sLhzqVHqbo5gZA9F2hrnQ1cAZHzLS+BjSSEWqUTli1+J
         7pVk0jZGWtJeCHmzJXh9FowARNBTZXuJv+jWuz7tCwqymC7A+0MD7vrC6xiKkvojUd
         xWwWunb0lTmGCsSQNdMS02zUeSVbOf9ndAj3qawc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Adham Faris <afaris@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 045/114] net/mlx5e: Update rx ring hw mtu upon each rx-fcs flag change
Date:   Mon, 13 Feb 2023 15:48:00 +0100
Message-Id: <20230213144744.491447448@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adham Faris <afaris@nvidia.com>

[ Upstream commit 1e66220948df815d7b37e0ff8b4627ce10433738 ]

rq->hw_mtu is used in function en_rx.c/mlx5e_skb_from_cqe_mpwrq_linear()
to catch oversized packets. If FCS is concatenated to the end of the
packet then the check should be updated accordingly.

Rx rings initialization (mlx5e_init_rxq_rq()) invoked for every new set
of channels, as part of mlx5e_safe_switch_params(), unknowingly if it
runs with default configuration or not. Current rq->hw_mtu
initialization assumes default configuration and ignores
params->scatter_fcs_en flag state.
Fix this, by accounting for params->scatter_fcs_en flag state during
rq->hw_mtu initialization.

In addition, updating rq->hw_mtu value during ingress traffic might
lead to packets drop and oversize_pkts_sw_drop counter increase with no
good reason. Hence we remove this optimization and switch the set of
channels with a new one, to make sure we don't get false positives on
the oversize_pkts_sw_drop counter.

Fixes: 102722fc6832 ("net/mlx5e: Add support for RXFCS feature flag")
Signed-off-by: Adham Faris <afaris@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 86 ++++---------------
 1 file changed, 15 insertions(+), 71 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 4dc149ef618c4..3e0d910b085d4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -591,7 +591,8 @@ static int mlx5e_init_rxq_rq(struct mlx5e_channel *c, struct mlx5e_params *param
 	rq->ix           = c->ix;
 	rq->channel      = c;
 	rq->mdev         = mdev;
-	rq->hw_mtu       = MLX5E_SW2HW_MTU(params, params->sw_mtu);
+	rq->hw_mtu =
+		MLX5E_SW2HW_MTU(params, params->sw_mtu) - ETH_FCS_LEN * !params->scatter_fcs_en;
 	rq->xdpsq        = &c->rq_xdpsq;
 	rq->stats        = &c->priv->channel_stats[c->ix]->rq;
 	rq->ptp_cyc2time = mlx5_rq_ts_translator(mdev);
@@ -1014,35 +1015,6 @@ int mlx5e_flush_rq(struct mlx5e_rq *rq, int curr_state)
 	return mlx5e_rq_to_ready(rq, curr_state);
 }
 
-static int mlx5e_modify_rq_scatter_fcs(struct mlx5e_rq *rq, bool enable)
-{
-	struct mlx5_core_dev *mdev = rq->mdev;
-
-	void *in;
-	void *rqc;
-	int inlen;
-	int err;
-
-	inlen = MLX5_ST_SZ_BYTES(modify_rq_in);
-	in = kvzalloc(inlen, GFP_KERNEL);
-	if (!in)
-		return -ENOMEM;
-
-	rqc = MLX5_ADDR_OF(modify_rq_in, in, ctx);
-
-	MLX5_SET(modify_rq_in, in, rq_state, MLX5_RQC_STATE_RDY);
-	MLX5_SET64(modify_rq_in, in, modify_bitmask,
-		   MLX5_MODIFY_RQ_IN_MODIFY_BITMASK_SCATTER_FCS);
-	MLX5_SET(rqc, rqc, scatter_fcs, enable);
-	MLX5_SET(rqc, rqc, state, MLX5_RQC_STATE_RDY);
-
-	err = mlx5_core_modify_rq(mdev, rq->rqn, in);
-
-	kvfree(in);
-
-	return err;
-}
-
 static int mlx5e_modify_rq_vsd(struct mlx5e_rq *rq, bool vsd)
 {
 	struct mlx5_core_dev *mdev = rq->mdev;
@@ -3301,20 +3273,6 @@ static void mlx5e_cleanup_nic_tx(struct mlx5e_priv *priv)
 	mlx5e_destroy_tises(priv);
 }
 
-static int mlx5e_modify_channels_scatter_fcs(struct mlx5e_channels *chs, bool enable)
-{
-	int err = 0;
-	int i;
-
-	for (i = 0; i < chs->num; i++) {
-		err = mlx5e_modify_rq_scatter_fcs(&chs->c[i]->rq, enable);
-		if (err)
-			return err;
-	}
-
-	return 0;
-}
-
 static int mlx5e_modify_channels_vsd(struct mlx5e_channels *chs, bool vsd)
 {
 	int err;
@@ -3890,41 +3848,27 @@ static int mlx5e_set_rx_port_ts(struct mlx5_core_dev *mdev, bool enable)
 	return mlx5_set_ports_check(mdev, in, sizeof(in));
 }
 
+static int mlx5e_set_rx_port_ts_wrap(struct mlx5e_priv *priv, void *ctx)
+{
+	struct mlx5_core_dev *mdev = priv->mdev;
+	bool enable = *(bool *)ctx;
+
+	return mlx5e_set_rx_port_ts(mdev, enable);
+}
+
 static int set_feature_rx_fcs(struct net_device *netdev, bool enable)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct mlx5e_channels *chs = &priv->channels;
-	struct mlx5_core_dev *mdev = priv->mdev;
+	struct mlx5e_params new_params;
 	int err;
 
 	mutex_lock(&priv->state_lock);
 
-	if (enable) {
-		err = mlx5e_set_rx_port_ts(mdev, false);
-		if (err)
-			goto out;
-
-		chs->params.scatter_fcs_en = true;
-		err = mlx5e_modify_channels_scatter_fcs(chs, true);
-		if (err) {
-			chs->params.scatter_fcs_en = false;
-			mlx5e_set_rx_port_ts(mdev, true);
-		}
-	} else {
-		chs->params.scatter_fcs_en = false;
-		err = mlx5e_modify_channels_scatter_fcs(chs, false);
-		if (err) {
-			chs->params.scatter_fcs_en = true;
-			goto out;
-		}
-		err = mlx5e_set_rx_port_ts(mdev, true);
-		if (err) {
-			mlx5_core_warn(mdev, "Failed to set RX port timestamp %d\n", err);
-			err = 0;
-		}
-	}
-
-out:
+	new_params = chs->params;
+	new_params.scatter_fcs_en = enable;
+	err = mlx5e_safe_switch_params(priv, &new_params, mlx5e_set_rx_port_ts_wrap,
+				       &new_params.scatter_fcs_en, true);
 	mutex_unlock(&priv->state_lock);
 	return err;
 }
-- 
2.39.0



