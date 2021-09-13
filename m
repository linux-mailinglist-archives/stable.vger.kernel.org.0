Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9D5408EF4
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241100AbhIMNiX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:38:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:37704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242104AbhIMNgS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:36:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1CE95613A4;
        Mon, 13 Sep 2021 13:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539653;
        bh=xh/gitamcNyDgXTNDqWggrKSUNNDwEDh83k3KZh9/+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pp4uPV+B0Oxz09wJYsldSH6fVQtxu4CiL1MhOGThvCm5ze6I93rg9Ff22CItgIPoe
         lahp/y8te8BvxBaVwVuEIWH1MkWfGWtkxAY24m6mdL9VAdnnKWsHKiM2tH7d3VzWOM
         s3srNpXj1qZfEzJvfONHaU7B1jeCDwY1wKvPT8tY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 108/236] net/mlx5e: Prohibit inner indir TIRs in IPoIB
Date:   Mon, 13 Sep 2021 15:13:33 +0200
Message-Id: <20210913131104.009267392@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

[ Upstream commit 9c43f3865c2a03be104f1c1d5e9129c2a2bdba88 ]

TIR's rx_hash_field_selector_inner can be enabled only when
tunneled_offload_en = 1. tunneled_offload_en is filled according to the
tunneled_offload_en field in struct mlx5e_params, which is false in the
IPoIB profile. On the other hand, the IPoIB profile passes inner_ttc =
true to mlx5e_create_indirect_tirs, which potentially allows the latter
function to attempt to create inner indirect TIRs without having
tunneled_offload_en set.

This commit prohibits this behavior by passing inner_ttc = false to
mlx5e_create_indirect_tirs. The latter function won't attempt to create
inner indirect TIRs.

As inner indirect TIRs are not created in the IPoIB profile (this commit
blocks it explicitly, and even before they would have failed to be
created), the call to mlx5e_create_inner_ttc_table in
mlx5i_create_flow_steering is a no-op and can be removed.

Fixes: 46dc933cee82 ("net/mlx5e: Provide explicit directive if to create inner indirect tirs")
Fixes: 458821c72bd0 ("net/mlx5e: IPoIB, Add inner TTC table to IPoIB flow steering")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en/fs.h    |  6 ------
 .../net/ethernet/mellanox/mlx5/core/en_fs.c    | 10 +++++-----
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c  | 18 ++----------------
 3 files changed, 7 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index dc744702aee4..000ca294b0a0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -262,18 +262,12 @@ struct ttc_params {
 
 void mlx5e_set_ttc_basic_params(struct mlx5e_priv *priv, struct ttc_params *ttc_params);
 void mlx5e_set_ttc_ft_params(struct ttc_params *ttc_params);
-void mlx5e_set_inner_ttc_ft_params(struct ttc_params *ttc_params);
 
 int mlx5e_create_ttc_table(struct mlx5e_priv *priv, struct ttc_params *params,
 			   struct mlx5e_ttc_table *ttc);
 void mlx5e_destroy_ttc_table(struct mlx5e_priv *priv,
 			     struct mlx5e_ttc_table *ttc);
 
-int mlx5e_create_inner_ttc_table(struct mlx5e_priv *priv, struct ttc_params *params,
-				 struct mlx5e_ttc_table *ttc);
-void mlx5e_destroy_inner_ttc_table(struct mlx5e_priv *priv,
-				   struct mlx5e_ttc_table *ttc);
-
 void mlx5e_destroy_flow_table(struct mlx5e_flow_table *ft);
 int mlx5e_ttc_fwd_dest(struct mlx5e_priv *priv, enum mlx5e_traffic_types type,
 		       struct mlx5_flow_destination *new_dest);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index 93877becfae2..f405c256b3cd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -1138,7 +1138,7 @@ void mlx5e_set_ttc_basic_params(struct mlx5e_priv *priv,
 	ttc_params->inner_ttc = &priv->fs.inner_ttc;
 }
 
-void mlx5e_set_inner_ttc_ft_params(struct ttc_params *ttc_params)
+static void mlx5e_set_inner_ttc_ft_params(struct ttc_params *ttc_params)
 {
 	struct mlx5_flow_table_attr *ft_attr = &ttc_params->ft_attr;
 
@@ -1157,8 +1157,8 @@ void mlx5e_set_ttc_ft_params(struct ttc_params *ttc_params)
 	ft_attr->prio = MLX5E_NIC_PRIO;
 }
 
-int mlx5e_create_inner_ttc_table(struct mlx5e_priv *priv, struct ttc_params *params,
-				 struct mlx5e_ttc_table *ttc)
+static int mlx5e_create_inner_ttc_table(struct mlx5e_priv *priv, struct ttc_params *params,
+					struct mlx5e_ttc_table *ttc)
 {
 	struct mlx5e_flow_table *ft = &ttc->ft;
 	int err;
@@ -1188,8 +1188,8 @@ err:
 	return err;
 }
 
-void mlx5e_destroy_inner_ttc_table(struct mlx5e_priv *priv,
-				   struct mlx5e_ttc_table *ttc)
+static void mlx5e_destroy_inner_ttc_table(struct mlx5e_priv *priv,
+					  struct mlx5e_ttc_table *ttc)
 {
 	if (!mlx5e_tunnel_inner_ft_supported(priv->mdev))
 		return;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 97b5fcb1f406..5c6a376aa62e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -337,17 +337,6 @@ static int mlx5i_create_flow_steering(struct mlx5e_priv *priv)
 	}
 
 	mlx5e_set_ttc_basic_params(priv, &ttc_params);
-	mlx5e_set_inner_ttc_ft_params(&ttc_params);
-	for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++)
-		ttc_params.indir_tirn[tt] = priv->inner_indir_tir[tt].tirn;
-
-	err = mlx5e_create_inner_ttc_table(priv, &ttc_params, &priv->fs.inner_ttc);
-	if (err) {
-		netdev_err(priv->netdev, "Failed to create inner ttc table, err=%d\n",
-			   err);
-		goto err_destroy_arfs_tables;
-	}
-
 	mlx5e_set_ttc_ft_params(&ttc_params);
 	for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++)
 		ttc_params.indir_tirn[tt] = priv->indir_tir[tt].tirn;
@@ -356,13 +345,11 @@ static int mlx5i_create_flow_steering(struct mlx5e_priv *priv)
 	if (err) {
 		netdev_err(priv->netdev, "Failed to create ttc table, err=%d\n",
 			   err);
-		goto err_destroy_inner_ttc_table;
+		goto err_destroy_arfs_tables;
 	}
 
 	return 0;
 
-err_destroy_inner_ttc_table:
-	mlx5e_destroy_inner_ttc_table(priv, &priv->fs.inner_ttc);
 err_destroy_arfs_tables:
 	mlx5e_arfs_destroy_tables(priv);
 
@@ -372,7 +359,6 @@ err_destroy_arfs_tables:
 static void mlx5i_destroy_flow_steering(struct mlx5e_priv *priv)
 {
 	mlx5e_destroy_ttc_table(priv, &priv->fs.ttc);
-	mlx5e_destroy_inner_ttc_table(priv, &priv->fs.inner_ttc);
 	mlx5e_arfs_destroy_tables(priv);
 }
 
@@ -397,7 +383,7 @@ static int mlx5i_init_rx(struct mlx5e_priv *priv)
 	if (err)
 		goto err_destroy_indirect_rqts;
 
-	err = mlx5e_create_indirect_tirs(priv, true);
+	err = mlx5e_create_indirect_tirs(priv, false);
 	if (err)
 		goto err_destroy_direct_rqts;
 
-- 
2.30.2



