Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F062D469EFB
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391141AbhLFPpL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:45:11 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37242 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388157AbhLFPcW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:32:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DEEC1B81126;
        Mon,  6 Dec 2021 15:28:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EC62C34900;
        Mon,  6 Dec 2021 15:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804531;
        bh=0Bzi1B7magKOPH8sqU6AFIZ2qbfj7RA7crg0prPXjZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BvL67vZ92f6R3Bh0+MjgwowOKz8FbTI9dkOQ3MVynAASR5YL+HfvudzPBPpNNcszS
         S71l/L/HRVJKTslhN2H7wxSX2ipuA+KNyu3o7T97Kt0xklPm+LcN9KFQBI4I1nYKw4
         xRxh8vXOCRl8dPKQYLpqOAKi7XdOS/tLZxTvabDo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Ben-Ishay <benishay@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 181/207] net/mlx5e: Rename lro_timeout to packet_merge_timeout
Date:   Mon,  6 Dec 2021 15:57:15 +0100
Message-Id: <20211206145616.544507234@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Ben-Ishay <benishay@nvidia.com>

[ Upstream commit 50f477fe9933193e960785f1192be801d7cd307a ]

TIR stands for transport interface receive, the TIR object is
responsible for performing all transport related operations on
the receive side like packet processing, demultiplexing the packets
to different RQ's, etc.
lro_timeout is a field in the TIR that is used to set the timeout for lro
session, this series introduces new packet merge type, therefore rename
lro_timeout to packet_merge_timeout for all packet merge types.

Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h        | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/params.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tir.c    | 6 +++---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c   | 2 +-
 include/linux/mlx5/mlx5_ifc.h                       | 6 +++---
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 03a7a4ce5cd5e..d9d19130c1a34 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -264,7 +264,7 @@ struct mlx5e_params {
 	bool scatter_fcs_en;
 	bool rx_dim_enabled;
 	bool tx_dim_enabled;
-	u32 lro_timeout;
+	u32 packet_merge_timeout;
 	u32 pflags;
 	struct bpf_prog *xdp_prog;
 	struct mlx5e_xsk *xsk;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 3cbb596821e89..2b2b3c5cdbd5c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -173,7 +173,7 @@ struct mlx5e_lro_param mlx5e_get_lro_param(struct mlx5e_params *params)
 
 	lro_param = (struct mlx5e_lro_param) {
 		.enabled = params->lro_en,
-		.timeout = params->lro_timeout,
+		.timeout = params->packet_merge_timeout,
 	};
 
 	return lro_param;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tir.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tir.c
index de936dc4bc483..857ea09791597 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tir.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tir.c
@@ -82,9 +82,9 @@ void mlx5e_tir_builder_build_lro(struct mlx5e_tir_builder *builder,
 	if (!lro_param->enabled)
 		return;
 
-	MLX5_SET(tirc, tirc, lro_enable_mask,
-		 MLX5_TIRC_LRO_ENABLE_MASK_IPV4_LRO |
-		 MLX5_TIRC_LRO_ENABLE_MASK_IPV6_LRO);
+	MLX5_SET(tirc, tirc, packet_merge_mask,
+		 MLX5_TIRC_PACKET_MERGE_MASK_IPV4_LRO |
+		 MLX5_TIRC_PACKET_MERGE_MASK_IPV6_LRO);
 	MLX5_SET(tirc, tirc, lro_max_ip_payload_size,
 		 (MLX5E_PARAMS_DEFAULT_LRO_WQE_SZ - rough_max_l2_l3_hdr_sz) >> 8);
 	MLX5_SET(tirc, tirc, lro_timeout_period_usecs, lro_param->timeout);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 41ef6eb70a585..a9d80ffb25376 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4323,7 +4323,7 @@ void mlx5e_build_nic_params(struct mlx5e_priv *priv, struct mlx5e_xsk *xsk, u16
 		if (!mlx5e_rx_mpwqe_is_linear_skb(mdev, params, NULL))
 			params->lro_en = !slow_pci_heuristic(mdev);
 	}
-	params->lro_timeout = mlx5e_choose_lro_timeout(mdev, MLX5E_DEFAULT_LRO_TIMEOUT);
+	params->packet_merge_timeout = mlx5e_choose_lro_timeout(mdev, MLX5E_DEFAULT_LRO_TIMEOUT);
 
 	/* CQ moderation params */
 	rx_cq_period_mode = MLX5_CAP_GEN(mdev, cq_period_start_from_cqe) ?
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 993204a6c1a13..944bb9f5006c1 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -3309,8 +3309,8 @@ enum {
 };
 
 enum {
-	MLX5_TIRC_LRO_ENABLE_MASK_IPV4_LRO  = 0x1,
-	MLX5_TIRC_LRO_ENABLE_MASK_IPV6_LRO  = 0x2,
+	MLX5_TIRC_PACKET_MERGE_MASK_IPV4_LRO  = BIT(0),
+	MLX5_TIRC_PACKET_MERGE_MASK_IPV6_LRO  = BIT(1),
 };
 
 enum {
@@ -3335,7 +3335,7 @@ struct mlx5_ifc_tirc_bits {
 
 	u8         reserved_at_80[0x4];
 	u8         lro_timeout_period_usecs[0x10];
-	u8         lro_enable_mask[0x4];
+	u8         packet_merge_mask[0x4];
 	u8         lro_max_ip_payload_size[0x8];
 
 	u8         reserved_at_a0[0x40];
-- 
2.33.0



