Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 192D0429042
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239116AbhJKOGl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:06:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:55468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241250AbhJKOEl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:04:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76459610E7;
        Mon, 11 Oct 2021 13:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960757;
        bh=in3oFeV5+CvPd52q/gJuEv/4F52qIh8xuLpBPiATuG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R0xUh3pQNhGAxPQVunZG5Y5b+QFal/bSgxFhLSSQR2yHnxJsejfd9gYROyGwu0vcl
         WehdLZEgu43ihcPdzF1eaGhl1HM9JVLU1ks1pZkznoXaUR4lx65k9RYsEQBWZlMAx/
         iEn8MAhRcOXmNhYByswpopanqytsh6G1xloTuaRs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lama Kayal <lkayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 065/151] net/mlx5e: Fix the presented RQ index in PTP stats
Date:   Mon, 11 Oct 2021 15:45:37 +0200
Message-Id: <20211011134519.943911900@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lama Kayal <lkayal@nvidia.com>

[ Upstream commit dd1979cf3c710398a9eeba4853b908fe16426814 ]

PTP-RQ counters title format contains PTP-RQ identifier, which is
mistakenly not passed to sprinft().
This leads to unexpected garbage values instead.
This patch fixes it.

Before applying the patch:
ethtool -S eth3 | grep ptp_rq
     ptp_rq15_packets: 0
     ptp_rq8_bytes: 0
     ptp_rq6_csum_complete: 0
     ptp_rq14_csum_complete_tail: 0
     ptp_rq3_csum_complete_tail_slow : 0
     ptp_rq9_csum_unnecessary: 0
     ptp_rq1_csum_unnecessary_inner: 0
     ptp_rq7_csum_none: 0
     ptp_rq10_xdp_drop: 0
     ptp_rq9_xdp_redirect: 0
     ptp_rq13_lro_packets: 0
     ptp_rq12_lro_bytes: 0
     ptp_rq10_ecn_mark: 0
     ptp_rq9_removed_vlan_packets: 0
     ptp_rq5_wqe_err: 0
     ptp_rq8_mpwqe_filler_cqes: 0
     ptp_rq2_mpwqe_filler_strides: 0
     ptp_rq5_oversize_pkts_sw_drop: 0
     ptp_rq6_buff_alloc_err: 0
     ptp_rq15_cqe_compress_blks: 0
     ptp_rq2_cqe_compress_pkts: 0
     ptp_rq2_cache_reuse: 0
     ptp_rq12_cache_full: 0
     ptp_rq11_cache_empty: 256
     ptp_rq12_cache_busy: 0
     ptp_rq11_cache_waive: 0
     ptp_rq12_congst_umr: 0
     ptp_rq11_arfs_err: 0
     ptp_rq9_recover: 0

After applying the patch:
ethtool -S eth3 | grep ptp_rq
     ptp_rq0_packets: 0
     ptp_rq0_bytes: 0
     ptp_rq0_csum_complete: 0
     ptp_rq0_csum_complete_tail: 0
     ptp_rq0_csum_complete_tail_slow : 0
     ptp_rq0_csum_unnecessary: 0
     ptp_rq0_csum_unnecessary_inner: 0
     ptp_rq0_csum_none: 0
     ptp_rq0_xdp_drop: 0
     ptp_rq0_xdp_redirect: 0
     ptp_rq0_lro_packets: 0
     ptp_rq0_lro_bytes: 0
     ptp_rq0_ecn_mark: 0
     ptp_rq0_removed_vlan_packets: 0
     ptp_rq0_wqe_err: 0
     ptp_rq0_mpwqe_filler_cqes: 0
     ptp_rq0_mpwqe_filler_strides: 0
     ptp_rq0_oversize_pkts_sw_drop: 0
     ptp_rq0_buff_alloc_err: 0
     ptp_rq0_cqe_compress_blks: 0
     ptp_rq0_cqe_compress_pkts: 0
     ptp_rq0_cache_reuse: 0
     ptp_rq0_cache_full: 0
     ptp_rq0_cache_empty: 256
     ptp_rq0_cache_busy: 0
     ptp_rq0_cache_waive: 0
     ptp_rq0_congst_umr: 0
     ptp_rq0_arfs_err: 0
     ptp_rq0_recover: 0

Fixes: a28359e922c6 ("net/mlx5e: Add PTP-RX statistics")
Signed-off-by: Lama Kayal <lkayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c   | 3 +--
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h   | 2 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c | 3 ++-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index efef4adce086..93a8fa31255d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -13,8 +13,6 @@ struct mlx5e_ptp_fs {
 	bool valid;
 };
 
-#define MLX5E_PTP_CHANNEL_IX 0
-
 struct mlx5e_ptp_params {
 	struct mlx5e_params params;
 	struct mlx5e_sq_param txq_sq_param;
@@ -505,6 +503,7 @@ static int mlx5e_init_ptp_rq(struct mlx5e_ptp *c, struct mlx5e_params *params,
 	rq->mdev         = mdev;
 	rq->hw_mtu       = MLX5E_SW2HW_MTU(params, params->sw_mtu);
 	rq->stats        = &c->priv->ptp_stats.rq;
+	rq->ix           = MLX5E_PTP_CHANNEL_IX;
 	rq->ptp_cyc2time = mlx5_rq_ts_translator(mdev);
 	err = mlx5e_rq_set_handlers(rq, params, false);
 	if (err)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
index c96668bd701c..a71a32e00ebb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
@@ -8,6 +8,8 @@
 #include "en_stats.h"
 #include <linux/ptp_classify.h>
 
+#define MLX5E_PTP_CHANNEL_IX 0
+
 struct mlx5e_ptpsq {
 	struct mlx5e_txqsq       txqsq;
 	struct mlx5e_cq          ts_cq;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 46bf78169f63..e1dd17019030 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -34,6 +34,7 @@
 #include "en.h"
 #include "en_accel/tls.h"
 #include "en_accel/en_accel.h"
+#include "en/ptp.h"
 
 static unsigned int stats_grps_num(struct mlx5e_priv *priv)
 {
@@ -2076,7 +2077,7 @@ static MLX5E_DECLARE_STATS_GRP_OP_FILL_STRS(ptp)
 	if (priv->rx_ptp_opened) {
 		for (i = 0; i < NUM_PTP_RQ_STATS; i++)
 			sprintf(data + (idx++) * ETH_GSTRING_LEN,
-				ptp_rq_stats_desc[i].format);
+				ptp_rq_stats_desc[i].format, MLX5E_PTP_CHANNEL_IX);
 	}
 	return idx;
 }
-- 
2.33.0



