Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58F7F628047
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237764AbiKNNEf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:04:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237765AbiKNNEe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:04:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4346A2A246
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:04:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C744E6117E
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:04:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA424C43140;
        Mon, 14 Nov 2022 13:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431071;
        bh=DaHXbdHSVX4WF/LrP5HXXJ89pSDI3FW4lRAo8srBCIU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B115ixkbpxg7jV79EvIeeHDuqXhvKDEHN/agWCmyJoGss/48NaXtLDzsZh5V7pxwm
         xuJ01myEXnaEwviD0cLSEL50CDYZaednKguiR2aa1/R415hk3YbhQatQt64bF3mFVv
         vvOtWxsDL2Zu0KNCO43BBZgoeBI9Gl/TyP6rABMY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 090/190] net/mlx5e: Add missing sanity checks for max TX WQE size
Date:   Mon, 14 Nov 2022 13:45:14 +0100
Message-Id: <20221114124502.628027293@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
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

From: Maxim Mikityanskiy <maximmi@nvidia.com>

[ Upstream commit f9c955b4fe5c8626d11b8a9b93ccc0ba77358fec ]

The commit cited below started using the firmware capability for the
maximum TX WQE size. This commit adds an important check to verify that
the driver doesn't attempt to exceed this capability, and also restores
another check mistakenly removed in the cited commit (a WQE must not
exceed the page size).

Fixes: c27bd1718c06 ("net/mlx5e: Read max WQEBBs on the SQ from firmware")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h | 24 ++++++++++++++++++-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  7 ++++++
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   |  5 ++++
 3 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index ff8ca7a7e103..aeed165a2dec 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -11,6 +11,27 @@
 
 #define INL_HDR_START_SZ (sizeof(((struct mlx5_wqe_eth_seg *)NULL)->inline_hdr.start))
 
+/* IPSEC inline data includes:
+ * 1. ESP trailer: up to 255 bytes of padding, 1 byte for pad length, 1 byte for
+ *    next header.
+ * 2. ESP authentication data: 16 bytes for ICV.
+ */
+#define MLX5E_MAX_TX_IPSEC_DS DIV_ROUND_UP(sizeof(struct mlx5_wqe_inline_seg) + \
+					   255 + 1 + 1 + 16, MLX5_SEND_WQE_DS)
+
+/* 366 should be big enough to cover all L2, L3 and L4 headers with possible
+ * encapsulations.
+ */
+#define MLX5E_MAX_TX_INLINE_DS DIV_ROUND_UP(366 - INL_HDR_START_SZ + VLAN_HLEN, \
+					    MLX5_SEND_WQE_DS)
+
+/* Sync the calculation with mlx5e_sq_calc_wqe_attr. */
+#define MLX5E_MAX_TX_WQEBBS DIV_ROUND_UP(MLX5E_TX_WQE_EMPTY_DS_COUNT + \
+					 MLX5E_MAX_TX_INLINE_DS + \
+					 MLX5E_MAX_TX_IPSEC_DS + \
+					 MAX_SKB_FRAGS + 1, \
+					 MLX5_SEND_WQEBB_NUM_DS)
+
 #define MLX5E_RX_ERR_CQE(cqe) (get_cqe_opcode(cqe) != MLX5_CQE_RESP_SEND)
 
 static inline
@@ -424,6 +445,8 @@ mlx5e_set_eseg_swp(struct sk_buff *skb, struct mlx5_wqe_eth_seg *eseg,
 
 static inline u16 mlx5e_stop_room_for_wqe(struct mlx5_core_dev *mdev, u16 wqe_size)
 {
+	WARN_ON_ONCE(PAGE_SIZE / MLX5_SEND_WQE_BB < mlx5e_get_max_sq_wqebbs(mdev));
+
 	/* A WQE must not cross the page boundary, hence two conditions:
 	 * 1. Its size must not exceed the page size.
 	 * 2. If the WQE size is X, and the space remaining in a page is less
@@ -436,7 +459,6 @@ static inline u16 mlx5e_stop_room_for_wqe(struct mlx5_core_dev *mdev, u16 wqe_si
 		  "wqe_size %u is greater than max SQ WQEBBs %u",
 		  wqe_size, mlx5e_get_max_sq_wqebbs(mdev));
 
-
 	return MLX5E_STOP_ROOM(wqe_size);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 02eb2f0fa2ae..6cf6a81775a8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5514,6 +5514,13 @@ int mlx5e_attach_netdev(struct mlx5e_priv *priv)
 	if (priv->fs)
 		priv->fs->state_destroy = !test_bit(MLX5E_STATE_DESTROYING, &priv->state);
 
+	/* Validate the max_wqe_size_sq capability. */
+	if (WARN_ON_ONCE(mlx5e_get_max_sq_wqebbs(priv->mdev) < MLX5E_MAX_TX_WQEBBS)) {
+		mlx5_core_warn(priv->mdev, "MLX5E: Max SQ WQEBBs firmware capability: %u, needed %lu\n",
+			       mlx5e_get_max_sq_wqebbs(priv->mdev), MLX5E_MAX_TX_WQEBBS);
+		return -EIO;
+	}
+
 	/* max number of channels may have changed */
 	max_nch = mlx5e_calc_max_nch(priv->mdev, priv->netdev, profile);
 	if (priv->channels.params.num_channels > max_nch) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 4d45150a3f8e..a30e50d9969f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -304,6 +304,8 @@ static void mlx5e_sq_calc_wqe_attr(struct sk_buff *skb, const struct mlx5e_tx_at
 	u16 ds_cnt_inl = 0;
 	u16 ds_cnt_ids = 0;
 
+	/* Sync the calculation with MLX5E_MAX_TX_WQEBBS. */
+
 	if (attr->insz)
 		ds_cnt_ids = DIV_ROUND_UP(sizeof(struct mlx5_wqe_inline_seg) + attr->insz,
 					  MLX5_SEND_WQE_DS);
@@ -316,6 +318,9 @@ static void mlx5e_sq_calc_wqe_attr(struct sk_buff *skb, const struct mlx5e_tx_at
 			inl += VLAN_HLEN;
 
 		ds_cnt_inl = DIV_ROUND_UP(inl, MLX5_SEND_WQE_DS);
+		if (WARN_ON_ONCE(ds_cnt_inl > MLX5E_MAX_TX_INLINE_DS))
+			netdev_warn(skb->dev, "ds_cnt_inl = %u > max %u\n", ds_cnt_inl,
+				    (u16)MLX5E_MAX_TX_INLINE_DS);
 		ds_cnt += ds_cnt_inl;
 	}
 
-- 
2.35.1



