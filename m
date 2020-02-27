Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BDFE171D44
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:19:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389406AbgB0OTX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:19:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:59910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389993AbgB0OTP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:19:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86EDB2468F;
        Thu, 27 Feb 2020 14:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582813155;
        bh=arbXllttc7sXYByydEClyO69CaPDVAGy+H48oV7qm04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xs1QEeTPRO3nJfp7eKrW65Dsa6JPcb3agwwG0NkAK90X1RldgZrwjfHaOqGZqKeaz
         XJw+5p0/I9Ke0wrxBxxt++bugd3KOGvpqkCKuo9X4YP8vuCEeEdAM6/FGvhj9L6AUC
         4keWC0Zs94WccgoFAsGhohHEux/GXq2bRYGO//RA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmytro Linkin <dmitrolin@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.5 146/150] net/mlx5e: Dont clear the whole vf config when switching modes
Date:   Thu, 27 Feb 2020 14:38:03 +0100
Message-Id: <20200227132253.848331877@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132232.815448360@linuxfoundation.org>
References: <20200227132232.815448360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmytro Linkin <dmitrolin@mellanox.com>

commit 383de108157c881074f32914b61125e299820bd2 upstream.

There is no need to reset all vf config (except link state) between
legacy and switchdev modes changes.
Also, set link state to AUTO, when legacy enabled.

Fixes: 3b83b6c2e024 ("net/mlx5e: Clear VF config when switching modes")
Signed-off-by: Dmytro Linkin <dmitrolin@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c          |    6 +++++-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c |    4 ++--
 2 files changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -456,12 +456,16 @@ static void esw_destroy_legacy_table(str
 
 static int esw_legacy_enable(struct mlx5_eswitch *esw)
 {
-	int ret;
+	struct mlx5_vport *vport;
+	int ret, i;
 
 	ret = esw_create_legacy_table(esw);
 	if (ret)
 		return ret;
 
+	mlx5_esw_for_each_vf_vport(esw, i, vport, esw->esw_funcs.num_vfs)
+		vport->info.link_state = MLX5_VPORT_ADMIN_STATE_AUTO;
+
 	ret = mlx5_eswitch_enable_pf_vf_vports(esw, MLX5_LEGACY_SRIOV_VPORT_EVENTS);
 	if (ret)
 		esw_destroy_legacy_table(esw);
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1377,7 +1377,7 @@ static int esw_offloads_start(struct mlx
 		return -EINVAL;
 	}
 
-	mlx5_eswitch_disable(esw, true);
+	mlx5_eswitch_disable(esw, false);
 	mlx5_eswitch_update_num_of_vfs(esw, esw->dev->priv.sriov.num_vfs);
 	err = mlx5_eswitch_enable(esw, MLX5_ESWITCH_OFFLOADS);
 	if (err) {
@@ -2271,7 +2271,7 @@ static int esw_offloads_stop(struct mlx5
 {
 	int err, err1;
 
-	mlx5_eswitch_disable(esw, true);
+	mlx5_eswitch_disable(esw, false);
 	err = mlx5_eswitch_enable(esw, MLX5_ESWITCH_LEGACY);
 	if (err) {
 		NL_SET_ERR_MSG_MOD(extack, "Failed setting eswitch to legacy");


