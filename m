Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA90D694982
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbjBMO7m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:59:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231148AbjBMO7W (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:59:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93B8C1E1C3
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:59:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8BA30B8128D
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:58:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A950FC433EF;
        Mon, 13 Feb 2023 14:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300313;
        bh=UZOGAcmGTBilaFJYTy3xPYlOlNLCDmANFpbGsrIFXIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CbA97ZvAQm9utkCo4IX1hvpdbVWo/lvMrkGn7CcR5UZ3qkQh9qYht1p/Ps7Y+JubM
         V/40+wuKnusG8tClaPcbLAKRtl9QjO535qpcDza2Cq7skt3uIktf4vmTXh1woEa/Q7
         Dp5gpIoYipbo/8//FSsqC/chcMuky2pdlIpo+ax0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 31/67] net/mlx5e: Introduce the mlx5e_flush_rq function
Date:   Mon, 13 Feb 2023 15:49:12 +0100
Message-Id: <20230213144733.859833406@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144732.336342050@linuxfoundation.org>
References: <20230213144732.336342050@linuxfoundation.org>
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

[ Upstream commit d9ba64deb2f1ad58eb3067c7485518f3e96559ee ]

Add a function to flush an RQ: clean up descriptors, release pages and
reset the RQ. This procedure is used by the recovery flow, and it will
also be used in a following commit to free some memory when switching a
channel to the XSK mode.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 1e66220948df ("net/mlx5e: Update rx ring hw mtu upon each rx-fcs flag change")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  2 +-
 .../mellanox/mlx5/core/en/reporter_rx.c       | 23 +--------------
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 28 ++++++++++++++++++-
 3 files changed, 29 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index c22a38e5337b2..c822c3ac0544b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1002,7 +1002,7 @@ void mlx5e_activate_priv_channels(struct mlx5e_priv *priv);
 void mlx5e_deactivate_priv_channels(struct mlx5e_priv *priv);
 int mlx5e_ptp_rx_manage_fs_ctx(struct mlx5e_priv *priv, void *ctx);
 
-int mlx5e_modify_rq_state(struct mlx5e_rq *rq, int curr_state, int next_state);
+int mlx5e_flush_rq(struct mlx5e_rq *rq, int curr_state);
 void mlx5e_activate_rq(struct mlx5e_rq *rq);
 void mlx5e_deactivate_rq(struct mlx5e_rq *rq);
 void mlx5e_activate_icosq(struct mlx5e_icosq *icosq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index 0f1dbad7c9f1a..899a9a73eef68 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -129,34 +129,13 @@ static int mlx5e_rx_reporter_err_icosq_cqe_recover(void *ctx)
 	return err;
 }
 
-static int mlx5e_rq_to_ready(struct mlx5e_rq *rq, int curr_state)
-{
-	struct net_device *dev = rq->netdev;
-	int err;
-
-	err = mlx5e_modify_rq_state(rq, curr_state, MLX5_RQC_STATE_RST);
-	if (err) {
-		netdev_err(dev, "Failed to move rq 0x%x to reset\n", rq->rqn);
-		return err;
-	}
-	err = mlx5e_modify_rq_state(rq, MLX5_RQC_STATE_RST, MLX5_RQC_STATE_RDY);
-	if (err) {
-		netdev_err(dev, "Failed to move rq 0x%x to ready\n", rq->rqn);
-		return err;
-	}
-
-	return 0;
-}
-
 static int mlx5e_rx_reporter_err_rq_cqe_recover(void *ctx)
 {
 	struct mlx5e_rq *rq = ctx;
 	int err;
 
 	mlx5e_deactivate_rq(rq);
-	mlx5e_free_rx_descs(rq);
-
-	err = mlx5e_rq_to_ready(rq, MLX5_RQC_STATE_ERR);
+	err = mlx5e_flush_rq(rq, MLX5_RQC_STATE_ERR);
 	clear_bit(MLX5E_RQ_STATE_RECOVERING, &rq->state);
 	if (err)
 		return err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index be19f5cf9d150..866242ac72c29 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -672,7 +672,7 @@ int mlx5e_create_rq(struct mlx5e_rq *rq, struct mlx5e_rq_param *param)
 	return err;
 }
 
-int mlx5e_modify_rq_state(struct mlx5e_rq *rq, int curr_state, int next_state)
+static int mlx5e_modify_rq_state(struct mlx5e_rq *rq, int curr_state, int next_state)
 {
 	struct mlx5_core_dev *mdev = rq->mdev;
 
@@ -701,6 +701,32 @@ int mlx5e_modify_rq_state(struct mlx5e_rq *rq, int curr_state, int next_state)
 	return err;
 }
 
+static int mlx5e_rq_to_ready(struct mlx5e_rq *rq, int curr_state)
+{
+	struct net_device *dev = rq->netdev;
+	int err;
+
+	err = mlx5e_modify_rq_state(rq, curr_state, MLX5_RQC_STATE_RST);
+	if (err) {
+		netdev_err(dev, "Failed to move rq 0x%x to reset\n", rq->rqn);
+		return err;
+	}
+	err = mlx5e_modify_rq_state(rq, MLX5_RQC_STATE_RST, MLX5_RQC_STATE_RDY);
+	if (err) {
+		netdev_err(dev, "Failed to move rq 0x%x to ready\n", rq->rqn);
+		return err;
+	}
+
+	return 0;
+}
+
+int mlx5e_flush_rq(struct mlx5e_rq *rq, int curr_state)
+{
+	mlx5e_free_rx_descs(rq);
+
+	return mlx5e_rq_to_ready(rq, curr_state);
+}
+
 static int mlx5e_modify_rq_scatter_fcs(struct mlx5e_rq *rq, bool enable)
 {
 	struct mlx5_core_dev *mdev = rq->mdev;
-- 
2.39.0



