Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF241EAD0A
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729373AbgFASlv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:41:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:59594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731194AbgFASMP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:12:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03AAB20776;
        Mon,  1 Jun 2020 18:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035134;
        bh=3MbiH+TIC0GESv7kxOSLQu21rOjeujlQsTSbHoaWDCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ScouxhaYMyn5IYVvNooAe8rg+xxAUQTOufjQdYLi1IpzoKTRPy5bXHodR4min348B
         lFufya9y2GjNWPj8pDHBC5NPHn/V0aKy0WxbKGQDmIRz2jWGI5+Cp4GWM0PiGwU445
         q8xAazP9TfwSxLs8UyWWzCLEak/SLcBC6wlsjWPo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roi Dayan <roid@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.6 024/177] net/mlx5e: Fix inner tirs handling
Date:   Mon,  1 Jun 2020 19:52:42 +0200
Message-Id: <20200601174050.795075645@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174048.468952319@linuxfoundation.org>
References: <20200601174048.468952319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roi Dayan <roid@mellanox.com>

[ Upstream commit a16b8e0dcf7043bee46174bed0553cc9e36b63a5 ]

In the cited commit inner_tirs argument was added to create and destroy
inner tirs, and no indication was added to mlx5e_modify_tirs_hash()
function. In order to have a consistent handling, use
inner_indir_tir[0].tirn in tirs destroy/modify function as an indication
to whether inner tirs are created.
Inner tirs are not created for representors and before this commit,
a call to mlx5e_modify_tirs_hash() was sending HW commands to
modify non-existent inner tirs.

Fixes: 46dc933cee82 ("net/mlx5e: Provide explicit directive if to create inner indirect tirs")
Signed-off-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Vlad Buslov <vladbu@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h          |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c     |   12 +++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c      |    4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c |    4 ++--
 4 files changed, 12 insertions(+), 10 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1104,7 +1104,7 @@ void mlx5e_close_drop_rq(struct mlx5e_rq
 int mlx5e_create_indirect_rqt(struct mlx5e_priv *priv);
 
 int mlx5e_create_indirect_tirs(struct mlx5e_priv *priv, bool inner_ttc);
-void mlx5e_destroy_indirect_tirs(struct mlx5e_priv *priv, bool inner_ttc);
+void mlx5e_destroy_indirect_tirs(struct mlx5e_priv *priv);
 
 int mlx5e_create_direct_rqts(struct mlx5e_priv *priv, struct mlx5e_tir *tirs);
 void mlx5e_destroy_direct_rqts(struct mlx5e_priv *priv, struct mlx5e_tir *tirs);
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2747,7 +2747,8 @@ void mlx5e_modify_tirs_hash(struct mlx5e
 		mlx5_core_modify_tir(mdev, priv->indir_tir[tt].tirn, in, inlen);
 	}
 
-	if (!mlx5e_tunnel_inner_ft_supported(priv->mdev))
+	/* Verify inner tirs resources allocated */
+	if (!priv->inner_indir_tir[0].tirn)
 		return;
 
 	for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++) {
@@ -3394,14 +3395,15 @@ out:
 	return err;
 }
 
-void mlx5e_destroy_indirect_tirs(struct mlx5e_priv *priv, bool inner_ttc)
+void mlx5e_destroy_indirect_tirs(struct mlx5e_priv *priv)
 {
 	int i;
 
 	for (i = 0; i < MLX5E_NUM_INDIR_TIRS; i++)
 		mlx5e_destroy_tir(priv->mdev, &priv->indir_tir[i]);
 
-	if (!inner_ttc || !mlx5e_tunnel_inner_ft_supported(priv->mdev))
+	/* Verify inner tirs resources allocated */
+	if (!priv->inner_indir_tir[0].tirn)
 		return;
 
 	for (i = 0; i < MLX5E_NUM_INDIR_TIRS; i++)
@@ -5107,7 +5109,7 @@ err_destroy_xsk_rqts:
 err_destroy_direct_tirs:
 	mlx5e_destroy_direct_tirs(priv, priv->direct_tir);
 err_destroy_indirect_tirs:
-	mlx5e_destroy_indirect_tirs(priv, true);
+	mlx5e_destroy_indirect_tirs(priv);
 err_destroy_direct_rqts:
 	mlx5e_destroy_direct_rqts(priv, priv->direct_tir);
 err_destroy_indirect_rqts:
@@ -5126,7 +5128,7 @@ static void mlx5e_cleanup_nic_rx(struct
 	mlx5e_destroy_direct_tirs(priv, priv->xsk_tir);
 	mlx5e_destroy_direct_rqts(priv, priv->xsk_tir);
 	mlx5e_destroy_direct_tirs(priv, priv->direct_tir);
-	mlx5e_destroy_indirect_tirs(priv, true);
+	mlx5e_destroy_indirect_tirs(priv);
 	mlx5e_destroy_direct_rqts(priv, priv->direct_tir);
 	mlx5e_destroy_rqt(priv, &priv->indir_rqt);
 	mlx5e_close_drop_rq(&priv->drop_rq);
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1667,7 +1667,7 @@ err_destroy_ttc_table:
 err_destroy_direct_tirs:
 	mlx5e_destroy_direct_tirs(priv, priv->direct_tir);
 err_destroy_indirect_tirs:
-	mlx5e_destroy_indirect_tirs(priv, false);
+	mlx5e_destroy_indirect_tirs(priv);
 err_destroy_direct_rqts:
 	mlx5e_destroy_direct_rqts(priv, priv->direct_tir);
 err_destroy_indirect_rqts:
@@ -1684,7 +1684,7 @@ static void mlx5e_cleanup_rep_rx(struct
 	mlx5_del_flow_rules(rpriv->vport_rx_rule);
 	mlx5e_destroy_ttc_table(priv, &priv->fs.ttc);
 	mlx5e_destroy_direct_tirs(priv, priv->direct_tir);
-	mlx5e_destroy_indirect_tirs(priv, false);
+	mlx5e_destroy_indirect_tirs(priv);
 	mlx5e_destroy_direct_rqts(priv, priv->direct_tir);
 	mlx5e_destroy_rqt(priv, &priv->indir_rqt);
 	mlx5e_close_drop_rq(&priv->drop_rq);
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -396,7 +396,7 @@ static int mlx5i_init_rx(struct mlx5e_pr
 err_destroy_direct_tirs:
 	mlx5e_destroy_direct_tirs(priv, priv->direct_tir);
 err_destroy_indirect_tirs:
-	mlx5e_destroy_indirect_tirs(priv, true);
+	mlx5e_destroy_indirect_tirs(priv);
 err_destroy_direct_rqts:
 	mlx5e_destroy_direct_rqts(priv, priv->direct_tir);
 err_destroy_indirect_rqts:
@@ -412,7 +412,7 @@ static void mlx5i_cleanup_rx(struct mlx5
 {
 	mlx5i_destroy_flow_steering(priv);
 	mlx5e_destroy_direct_tirs(priv, priv->direct_tir);
-	mlx5e_destroy_indirect_tirs(priv, true);
+	mlx5e_destroy_indirect_tirs(priv);
 	mlx5e_destroy_direct_rqts(priv, priv->direct_tir);
 	mlx5e_destroy_rqt(priv, &priv->indir_rqt);
 	mlx5e_close_drop_rq(&priv->drop_rq);


