Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 742F31236F0
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 21:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727231AbfLQURM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 15:17:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:41538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728703AbfLQURL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Dec 2019 15:17:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD02F206D8;
        Tue, 17 Dec 2019 20:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576613830;
        bh=+rzgUi0MUoaPaL/hzht3viN07njLZIbodXDlir2ozxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=scECi8yW+R+mZBpoPkfumzk7drIzOKsjF2ZL8q1A7RZPGL5wsZUwGYIayf5/zq7Vt
         +h1YwBVgu4ZMQX3Hqwx9C+DdnW2ozCyl34U3fASxc70rV/QAKfV9ItxPR06ArYODvA
         d5zGtUHMBL2UHkSPF7JD6lUBFGpzKYqsUIhkdMBw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.3 23/25] net/mlx5e: Fix TXQ indices to be sequential
Date:   Tue, 17 Dec 2019 21:16:22 +0100
Message-Id: <20191217200912.484352742@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191217200903.179327435@linuxfoundation.org>
References: <20191217200903.179327435@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

[ Upstream commit c55d8b108caa2ec1ae8dddd02cb9d3a740f7c838 ]

Cited patch changed (channel index, tc) => (TXQ index) mapping to be a
static one, in order to keep indices consistent when changing number of
channels or TCs.

For 32 channels (OOB) and 8 TCs, real num of TXQs is 256.
When reducing the amount of channels to 8, the real num of TXQs will be
changed to 64.
This indices method is buggy:
- Channel #0, TC 3, the TXQ index is 96.
- Index 8 is not valid, as there is no such TXQ from driver perspective
  (As it represents channel #8, TC 0, which is not valid with the above
  configuration).

As part of driver's select queue, it calls netdev_pick_tx which returns an
index in the range of real number of TXQs. Depends on the return value,
with the examples above, driver could have returned index larger than the
real number of tx queues, or crash the kernel as it tries to read invalid
address of SQ which was not allocated.

Fix that by allocating sequential TXQ indices, and hold a new mapping
between (channel index, tc) => (real TXQ index). This mapping will be
updated as part of priv channels activation, and is used in
mlx5e_select_queue to find the selected queue index.

The existing indices mapping (channel_tc2txq) is no longer needed, as it
is used only for statistics structures and can be calculated on run time.
Delete its definintion and updates.

Fixes: 8bfaf07f7806 ("net/mlx5e: Present SW stats when state is not opened")
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |    2 -
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   31 ++++++++-------------
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |    2 -
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |    2 -
 4 files changed, 15 insertions(+), 22 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -792,7 +792,7 @@ struct mlx5e_xsk {
 struct mlx5e_priv {
 	/* priv data path fields - start */
 	struct mlx5e_txqsq *txq2sq[MLX5E_MAX_NUM_CHANNELS * MLX5E_MAX_NUM_TC];
-	int channel_tc2txq[MLX5E_MAX_NUM_CHANNELS][MLX5E_MAX_NUM_TC];
+	int channel_tc2realtxq[MLX5E_MAX_NUM_CHANNELS][MLX5E_MAX_NUM_TC];
 #ifdef CONFIG_MLX5_CORE_EN_DCB
 	struct mlx5e_dcbx_dp       dcbx_dp;
 #endif
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1678,11 +1678,10 @@ static int mlx5e_open_sqs(struct mlx5e_c
 			  struct mlx5e_params *params,
 			  struct mlx5e_channel_param *cparam)
 {
-	struct mlx5e_priv *priv = c->priv;
 	int err, tc;
 
 	for (tc = 0; tc < params->num_tc; tc++) {
-		int txq_ix = c->ix + tc * priv->max_nch;
+		int txq_ix = c->ix + tc * params->num_channels;
 
 		err = mlx5e_open_txqsq(c, c->priv->tisn[tc], txq_ix,
 				       params, &cparam->sq, &c->sq[tc], tc);
@@ -2856,26 +2855,21 @@ static void mlx5e_netdev_set_tcs(struct
 		netdev_set_tc_queue(netdev, tc, nch, 0);
 }
 
-static void mlx5e_build_tc2txq_maps(struct mlx5e_priv *priv)
+static void mlx5e_build_txq_maps(struct mlx5e_priv *priv)
 {
-	int i, tc;
+	int i, ch;
 
-	for (i = 0; i < priv->max_nch; i++)
-		for (tc = 0; tc < priv->profile->max_tc; tc++)
-			priv->channel_tc2txq[i][tc] = i + tc * priv->max_nch;
-}
+	ch = priv->channels.num;
 
-static void mlx5e_build_tx2sq_maps(struct mlx5e_priv *priv)
-{
-	struct mlx5e_channel *c;
-	struct mlx5e_txqsq *sq;
-	int i, tc;
+	for (i = 0; i < ch; i++) {
+		int tc;
+
+		for (tc = 0; tc < priv->channels.params.num_tc; tc++) {
+			struct mlx5e_channel *c = priv->channels.c[i];
+			struct mlx5e_txqsq *sq = &c->sq[tc];
 
-	for (i = 0; i < priv->channels.num; i++) {
-		c = priv->channels.c[i];
-		for (tc = 0; tc < c->num_tc; tc++) {
-			sq = &c->sq[tc];
 			priv->txq2sq[sq->txq_ix] = sq;
+			priv->channel_tc2realtxq[i][tc] = i + tc * ch;
 		}
 	}
 }
@@ -2890,7 +2884,7 @@ void mlx5e_activate_priv_channels(struct
 	netif_set_real_num_tx_queues(netdev, num_txqs);
 	netif_set_real_num_rx_queues(netdev, num_rxqs);
 
-	mlx5e_build_tx2sq_maps(priv);
+	mlx5e_build_txq_maps(priv);
 	mlx5e_activate_channels(&priv->channels);
 	mlx5e_xdp_tx_enable(priv);
 	netif_tx_start_all_queues(priv->netdev);
@@ -4968,7 +4962,6 @@ static int mlx5e_nic_init(struct mlx5_co
 	if (err)
 		mlx5_core_err(mdev, "TLS initialization failed, %d\n", err);
 	mlx5e_build_nic_netdev(netdev);
-	mlx5e_build_tc2txq_maps(priv);
 
 	return 0;
 }
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -1435,7 +1435,7 @@ static int mlx5e_grp_channels_fill_strin
 			for (j = 0; j < NUM_SQ_STATS; j++)
 				sprintf(data + (idx++) * ETH_GSTRING_LEN,
 					sq_stats_desc[j].format,
-					priv->channel_tc2txq[i][tc]);
+					i + tc * max_nch);
 
 	for (i = 0; i < max_nch; i++) {
 		for (j = 0; j < NUM_XSKSQ_STATS * is_xsk; j++)
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -93,7 +93,7 @@ u16 mlx5e_select_queue(struct net_device
 	if (txq_ix >= num_channels)
 		txq_ix = priv->txq2sq[txq_ix]->ch_ix;
 
-	return priv->channel_tc2txq[txq_ix][up];
+	return priv->channel_tc2realtxq[txq_ix][up];
 }
 
 static inline int mlx5e_skb_l2_header_offset(struct sk_buff *skb)


