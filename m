Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 653D3541B6C
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378087AbiFGVrN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:47:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381979AbiFGVpz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:45:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78A42235260;
        Tue,  7 Jun 2022 12:07:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1CAA9B823B4;
        Tue,  7 Jun 2022 19:07:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 792E7C385A2;
        Tue,  7 Jun 2022 19:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628857;
        bh=6Bw7n5DpPSq0LsUhzO7WxUFhcxXLj80U1w2T9SxWBAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0AgIvIOOvRxHv+KDQg+ytpz1YoatdXkkfWN23Vxb0Ff9F+liOHFHYsPyxgSkPbDcI
         N+d3kH4SL4NT6hccUxTfCmN+Ilw6gOGr7LimBkDC5fRaAfd1mtCxsiBfORICqYLOX+
         ZQAzPq6foLQtiikMBAPBg4u+B+WpXCkeyqGiNHY8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Moshe Tal <moshet@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 481/879] net/mlx5e: Correct the calculation of max channels for rep
Date:   Tue,  7 Jun 2022 18:59:59 +0200
Message-Id: <20220607165016.837135001@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Moshe Tal <moshet@nvidia.com>

[ Upstream commit 6d0ba49321a40a8dada22c223bbe91c063b08db4 ]

Correct the calculation of maximum channels of rep to better utilize
the hardware resources and allow a larger scale of reps.

This will allow creation of all virtual ports configured.

Fixes: 473baf2e9e8c ("net/mlx5e: Allow profile-specific limitation on max num of channels")
Signed-off-by: Moshe Tal <moshet@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h      |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c |  9 +++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c  | 10 ++++++++--
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 8653ac0fd865..ee34e861d3af 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1221,6 +1221,7 @@ mlx5e_tx_mpwqe_supported(struct mlx5_core_dev *mdev)
 		MLX5_CAP_ETH(mdev, enhanced_multi_pkt_send_wqe);
 }
 
+int mlx5e_get_pf_num_tirs(struct mlx5_core_dev *mdev);
 int mlx5e_priv_init(struct mlx5e_priv *priv,
 		    const struct mlx5e_profile *profile,
 		    struct net_device *netdev,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index fa229998606c..72867a8ff48b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5251,6 +5251,15 @@ mlx5e_calc_max_nch(struct mlx5_core_dev *mdev, struct net_device *netdev,
 	return max_nch;
 }
 
+int mlx5e_get_pf_num_tirs(struct mlx5_core_dev *mdev)
+{
+	/* Indirect TIRS: 2 sets of TTCs (inner + outer steering)
+	 * and 1 set of direct TIRS
+	 */
+	return 2 * MLX5E_NUM_INDIR_TIRS
+		+ mlx5e_profile_max_num_channels(mdev, &mlx5e_nic_profile);
+}
+
 /* mlx5e generic netdev management API (move to en_common.c) */
 int mlx5e_priv_init(struct mlx5e_priv *priv,
 		    const struct mlx5e_profile *profile,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 6b7e7ea6ded2..a464461f1418 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -604,10 +604,16 @@ bool mlx5e_eswitch_vf_rep(const struct net_device *netdev)
 	return netdev->netdev_ops == &mlx5e_netdev_ops_rep;
 }
 
+/* One indirect TIR set for outer. Inner not supported in reps. */
+#define REP_NUM_INDIR_TIRS MLX5E_NUM_INDIR_TIRS
+
 static int mlx5e_rep_max_nch_limit(struct mlx5_core_dev *mdev)
 {
-	return (1 << MLX5_CAP_GEN(mdev, log_max_tir)) /
-		mlx5_eswitch_get_total_vports(mdev);
+	int max_tir_num = 1 << MLX5_CAP_GEN(mdev, log_max_tir);
+	int num_vports = mlx5_eswitch_get_total_vports(mdev);
+
+	return (max_tir_num - mlx5e_get_pf_num_tirs(mdev)
+		- (num_vports * REP_NUM_INDIR_TIRS)) / num_vports;
 }
 
 static void mlx5e_build_rep_params(struct net_device *netdev)
-- 
2.35.1



