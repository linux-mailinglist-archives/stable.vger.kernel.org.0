Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D71096C1835
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232688AbjCTPWC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:22:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232689AbjCTPVb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:21:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7BF02E809
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:15:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 948EBB80ED7
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:15:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4829C433EF;
        Mon, 20 Mar 2023 15:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325320;
        bh=99/kRQyidI+3jcSjil8yheBmXrGm+xdRXKD0bkelDd4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mA9WWi5yk9ByzU55UKBZAL6LAiCqmC+x0A7B0uQG+/3ahXII+2uFx9HJsKuWsYIXC
         Jh1bI9lDRj7TWP0rEto3hHGqgyOwnW7pIKTdSLUGItGfv7vYSTP6Rf7cjxDXjcUDPx
         4oopwE46m8IC86MsdEns3izT8AMt1SzhmQ/XqO0o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Parav Pandit <parav@nvidia.com>,
        Daniel Jurgens <danielj@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 068/198] net/mlx5e: Dont cache tunnel offloads capability
Date:   Mon, 20 Mar 2023 15:53:26 +0100
Message-Id: <20230320145510.379689821@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

[ Upstream commit 9a92fe1db9e57ea94388a1d768e8ee42af858377 ]

When mlx5e attaches again after device health recovery, the device
capabilities might have changed by the eswitch manager.

For example in one flow when ECPF changes the eswitch mode between
legacy and switchdev, it updates the flow table tunnel capability.

The cached value is only used in one place, so just check the capability
there instead.

Fixes: 5bef709d76a2 ("net/mlx5: Enable host PF HCA after eswitch is initialized")
Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Daniel Jurgens <danielj@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h          | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c     | 4 +---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c      | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c | 1 -
 4 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 26a23047f1f3b..bc76fe6b06230 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -313,7 +313,6 @@ struct mlx5e_params {
 		} channel;
 	} mqprio;
 	bool rx_cqe_compress_def;
-	bool tunneled_offload_en;
 	struct dim_cq_moder rx_cq_moderation;
 	struct dim_cq_moder tx_cq_moderation;
 	struct mlx5e_packet_merge_param packet_merge;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 142ed2d98cd5d..609a49c1e09e6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4911,8 +4911,6 @@ void mlx5e_build_nic_params(struct mlx5e_priv *priv, struct mlx5e_xsk *xsk, u16
 	/* TX inline */
 	mlx5_query_min_inline(mdev, &params->tx_min_inline_mode);
 
-	params->tunneled_offload_en = mlx5_tunnel_inner_ft_supported(mdev);
-
 	/* AF_XDP */
 	params->xsk = xsk;
 
@@ -5216,7 +5214,7 @@ static int mlx5e_init_nic_rx(struct mlx5e_priv *priv)
 	}
 
 	features = MLX5E_RX_RES_FEATURE_PTP;
-	if (priv->channels.params.tunneled_offload_en)
+	if (mlx5_tunnel_inner_ft_supported(mdev))
 		features |= MLX5E_RX_RES_FEATURE_INNER_FT;
 	err = mlx5e_rx_res_init(priv->rx_res, priv->mdev, features,
 				priv->max_nch, priv->drop_rq.rqn,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 794cd8dfe9c91..0f744131c6869 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -707,7 +707,6 @@ static void mlx5e_build_rep_params(struct net_device *netdev)
 	mlx5e_set_rx_cq_mode_params(params, cq_period_mode);
 
 	params->mqprio.num_tc       = 1;
-	params->tunneled_offload_en = false;
 	if (rep->vport != MLX5_VPORT_UPLINK)
 		params->vlan_strip_disable = true;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 038ae0fcf9d45..aed4e896179a3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -70,7 +70,6 @@ static void mlx5i_build_nic_params(struct mlx5_core_dev *mdev,
 
 	params->packet_merge.type = MLX5E_PACKET_MERGE_NONE;
 	params->hard_mtu = MLX5_IB_GRH_BYTES + MLX5_IPOIB_HARD_LEN;
-	params->tunneled_offload_en = false;
 
 	/* CQE compression is not supported for IPoIB */
 	params->rx_cqe_compress_def = false;
-- 
2.39.2



