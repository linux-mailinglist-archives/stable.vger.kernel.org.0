Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ADA8468B17
	for <lists+stable@lfdr.de>; Sun,  5 Dec 2021 14:35:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234161AbhLENjA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Dec 2021 08:39:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbhLENi7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Dec 2021 08:38:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25387C061714
        for <stable@vger.kernel.org>; Sun,  5 Dec 2021 05:35:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6111B80DBD
        for <stable@vger.kernel.org>; Sun,  5 Dec 2021 13:35:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00D60C341C7;
        Sun,  5 Dec 2021 13:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638711329;
        bh=mZPos6SoCxaQdDsipOs2uERvDIM3LnRw0PnVOt29t5w=;
        h=Subject:To:Cc:From:Date:From;
        b=QSmD8eql/GtaRl5d1ztqXyDHC7o5Fjl2juuZTlP2Rasl3Zw0t3EN1GaygAMICOaRW
         enJehA2qGT/FQA/hXDKaJ5omdCJZH/tdxIFUQtEkAkI2VmAgNTaBMkN9JO415cctgh
         6g+dycqjgtGduI8hhE24PHUfGGYuPTUhkxPlzUUc=
Subject: FAILED: patch "[PATCH] net/mlx5e: Sync TIR params updates against concurrent" failed to apply to 5.15-stable tree
To:     tariqt@nvidia.com, maximmi@nvidia.com, moshe@nvidia.com,
        saeedm@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 05 Dec 2021 14:35:21 +0100
Message-ID: <1638711321227200@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4cce2ccf08fbc27ae34ce0e72db15166e7b5f6a7 Mon Sep 17 00:00:00 2001
From: Tariq Toukan <tariqt@nvidia.com>
Date: Mon, 13 Sep 2021 13:54:30 +0300
Subject: [PATCH] net/mlx5e: Sync TIR params updates against concurrent
 create/modify

Transport Interface Receive (TIR) objects perform the packet processing and
reassembly and is also responsible for demultiplexing the packets into the
different RQs.

There are certain TIR context attributes that propagate to the pointed RQs
and applied to them (like packet_merge offloads (LRO/SHAMPO) and
tunneled_offload_en).  When TIRs do not agree on attributes values, a "last
one wins" policy is applied.  Hence, if not synced properly, a race between
TIR params update and a concurrent TIR create/modify operation might yield
to a mismatch between the shadow parameters in SW and the actual applied
state of the RQs in HW.

tunneled_offload_en is a fixed attribute per profile, while packet merge
offload state might be toggled and get out-of-sync. When this happens,
packet_merge offload might be working although not requested, or the
opposite.

All updates to packet_merge state and all create/modify operations of
regular redirection/steering TIRs are done under the same priv->state_lock,
so they do not run in parallel, and no race is possible.

However, there are other kind of TIRs (acceleration offloads TIRs, like TLS
TIRs) which are created on demand for each new connection without holding
the coarse priv->state_lock, hence might race.

Fix this by synchronizing all packet_merge state reads and writes against
all TIR create/modify operations. Include the modify operations of the
regular redirection steering TIRs under the new lock, for better code
layering and division of responsibilities.

Fixes: 1182f3659357 ("net/mlx5e: kTLS, Add kTLS RX HW offload support")
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.c
index 142953847996..0015a81eb9a1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.c
@@ -13,6 +13,9 @@ struct mlx5e_rx_res {
 	unsigned int max_nch;
 	u32 drop_rqn;
 
+	struct mlx5e_packet_merge_param pkt_merge_param;
+	struct rw_semaphore pkt_merge_param_sem;
+
 	struct mlx5e_rss *rss[MLX5E_MAX_NUM_RSS];
 	bool rss_active;
 	u32 rss_rqns[MLX5E_INDIR_RQT_SIZE];
@@ -392,6 +395,7 @@ static int mlx5e_rx_res_ptp_init(struct mlx5e_rx_res *res)
 	if (err)
 		goto out;
 
+	/* Separated from the channels RQs, does not share pkt_merge state with them */
 	mlx5e_tir_builder_build_rqt(builder, res->mdev->mlx5e_res.hw_objs.td.tdn,
 				    mlx5e_rqt_get_rqtn(&res->ptp.rqt),
 				    inner_ft_support);
@@ -447,6 +451,9 @@ int mlx5e_rx_res_init(struct mlx5e_rx_res *res, struct mlx5_core_dev *mdev,
 	res->max_nch = max_nch;
 	res->drop_rqn = drop_rqn;
 
+	res->pkt_merge_param = *init_pkt_merge_param;
+	init_rwsem(&res->pkt_merge_param_sem);
+
 	err = mlx5e_rx_res_rss_init_def(res, init_pkt_merge_param, init_nch);
 	if (err)
 		goto err_out;
@@ -513,7 +520,7 @@ u32 mlx5e_rx_res_get_tirn_ptp(struct mlx5e_rx_res *res)
 	return mlx5e_tir_get_tirn(&res->ptp.tir);
 }
 
-u32 mlx5e_rx_res_get_rqtn_direct(struct mlx5e_rx_res *res, unsigned int ix)
+static u32 mlx5e_rx_res_get_rqtn_direct(struct mlx5e_rx_res *res, unsigned int ix)
 {
 	return mlx5e_rqt_get_rqtn(&res->channels[ix].direct_rqt);
 }
@@ -656,6 +663,9 @@ int mlx5e_rx_res_packet_merge_set_param(struct mlx5e_rx_res *res,
 	if (!builder)
 		return -ENOMEM;
 
+	down_write(&res->pkt_merge_param_sem);
+	res->pkt_merge_param = *pkt_merge_param;
+
 	mlx5e_tir_builder_build_packet_merge(builder, pkt_merge_param);
 
 	final_err = 0;
@@ -681,6 +691,7 @@ int mlx5e_rx_res_packet_merge_set_param(struct mlx5e_rx_res *res,
 		}
 	}
 
+	up_write(&res->pkt_merge_param_sem);
 	mlx5e_tir_builder_free(builder);
 	return final_err;
 }
@@ -689,3 +700,31 @@ struct mlx5e_rss_params_hash mlx5e_rx_res_get_current_hash(struct mlx5e_rx_res *
 {
 	return mlx5e_rss_get_hash(res->rss[0]);
 }
+
+int mlx5e_rx_res_tls_tir_create(struct mlx5e_rx_res *res, unsigned int rxq,
+				struct mlx5e_tir *tir)
+{
+	bool inner_ft_support = res->features & MLX5E_RX_RES_FEATURE_INNER_FT;
+	struct mlx5e_tir_builder *builder;
+	u32 rqtn;
+	int err;
+
+	builder = mlx5e_tir_builder_alloc(false);
+	if (!builder)
+		return -ENOMEM;
+
+	rqtn = mlx5e_rx_res_get_rqtn_direct(res, rxq);
+
+	mlx5e_tir_builder_build_rqt(builder, res->mdev->mlx5e_res.hw_objs.td.tdn, rqtn,
+				    inner_ft_support);
+	mlx5e_tir_builder_build_direct(builder);
+	mlx5e_tir_builder_build_tls(builder);
+	down_read(&res->pkt_merge_param_sem);
+	mlx5e_tir_builder_build_packet_merge(builder, &res->pkt_merge_param);
+	err = mlx5e_tir_init(tir, builder, res->mdev, false);
+	up_read(&res->pkt_merge_param_sem);
+
+	mlx5e_tir_builder_free(builder);
+
+	return err;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.h b/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.h
index d09f7d174a51..b39b20a720e0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.h
@@ -37,9 +37,6 @@ u32 mlx5e_rx_res_get_tirn_rss(struct mlx5e_rx_res *res, enum mlx5_traffic_types
 u32 mlx5e_rx_res_get_tirn_rss_inner(struct mlx5e_rx_res *res, enum mlx5_traffic_types tt);
 u32 mlx5e_rx_res_get_tirn_ptp(struct mlx5e_rx_res *res);
 
-/* RQTN getters for modules that create their own TIRs */
-u32 mlx5e_rx_res_get_rqtn_direct(struct mlx5e_rx_res *res, unsigned int ix);
-
 /* Activate/deactivate API */
 void mlx5e_rx_res_channels_activate(struct mlx5e_rx_res *res, struct mlx5e_channels *chs);
 void mlx5e_rx_res_channels_deactivate(struct mlx5e_rx_res *res);
@@ -69,4 +66,7 @@ struct mlx5e_rss *mlx5e_rx_res_rss_get(struct mlx5e_rx_res *res, u32 rss_idx);
 /* Workaround for hairpin */
 struct mlx5e_rss_params_hash mlx5e_rx_res_get_current_hash(struct mlx5e_rx_res *res);
 
+/* Accel TIRs */
+int mlx5e_rx_res_tls_tir_create(struct mlx5e_rx_res *res, unsigned int rxq,
+				struct mlx5e_tir *tir);
 #endif /* __MLX5_EN_RX_RES_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
index a2a9f68579dd..15711814d2d2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
@@ -100,25 +100,6 @@ mlx5e_ktls_rx_resync_create_resp_list(void)
 	return resp_list;
 }
 
-static int mlx5e_ktls_create_tir(struct mlx5_core_dev *mdev, struct mlx5e_tir *tir, u32 rqtn)
-{
-	struct mlx5e_tir_builder *builder;
-	int err;
-
-	builder = mlx5e_tir_builder_alloc(false);
-	if (!builder)
-		return -ENOMEM;
-
-	mlx5e_tir_builder_build_rqt(builder, mdev->mlx5e_res.hw_objs.td.tdn, rqtn, false);
-	mlx5e_tir_builder_build_direct(builder);
-	mlx5e_tir_builder_build_tls(builder);
-	err = mlx5e_tir_init(tir, builder, mdev, false);
-
-	mlx5e_tir_builder_free(builder);
-
-	return err;
-}
-
 static void accel_rule_handle_work(struct work_struct *work)
 {
 	struct mlx5e_ktls_offload_context_rx *priv_rx;
@@ -609,7 +590,6 @@ int mlx5e_ktls_add_rx(struct net_device *netdev, struct sock *sk,
 	struct mlx5_core_dev *mdev;
 	struct mlx5e_priv *priv;
 	int rxq, err;
-	u32 rqtn;
 
 	tls_ctx = tls_get_ctx(sk);
 	priv = netdev_priv(netdev);
@@ -635,9 +615,7 @@ int mlx5e_ktls_add_rx(struct net_device *netdev, struct sock *sk,
 	priv_rx->sw_stats = &priv->tls->sw_stats;
 	mlx5e_set_ktls_rx_priv_ctx(tls_ctx, priv_rx);
 
-	rqtn = mlx5e_rx_res_get_rqtn_direct(priv->rx_res, rxq);
-
-	err = mlx5e_ktls_create_tir(mdev, &priv_rx->tir, rqtn);
+	err = mlx5e_rx_res_tls_tir_create(priv->rx_res, rxq, &priv_rx->tir);
 	if (err)
 		goto err_create_tir;
 

