Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D61472787B1
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728898AbgIYMtj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:49:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:53258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728904AbgIYMth (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:49:37 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E992721D91;
        Fri, 25 Sep 2020 12:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038176;
        bh=EViqmNco5zSn3+oVkIppJadYOvFpo3ek38Jg76Zkmoo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bCj2ufrmUkD9FisX37TKMgOovR66xFCno/psbZK/hDbxV2mSEbpFZYvav6IRmQo1I
         CpJDyVosaUMxbp2GbE6iNTOVQ5N/AWlZ3J6OUv7q2RFKm5yb77PnkpEaHk7tu1mXOt
         /jxGrsvteaPVdgKXVLnuK2Hh0VFGiZpe1P4R3mho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Dickman <maord@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, Raed Salem <raeds@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.8 30/56] net/mlx5e: Enable adding peer miss rules only if merged eswitch is supported
Date:   Fri, 25 Sep 2020 14:48:20 +0200
Message-Id: <20200925124732.362200914@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124727.878494124@linuxfoundation.org>
References: <20200925124727.878494124@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maor Dickman <maord@mellanox.com>

[ Upstream commit 6cec0229ab1959259e71e9a5bbe47c04577950b1 ]

The cited commit creates peer miss group during switchdev mode
initialization in order to handle miss packets correctly while in VF
LAG mode. This is done regardless of FW support of such groups which
could cause rules setups failure later on.

Fix by adding FW capability check before creating peer groups/rule.

Fixes: ac004b832128 ("net/mlx5e: E-Switch, Add peer miss rules")
Signed-off-by: Maor Dickman <maord@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Raed Salem <raeds@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c |   64 ++++++-------
 1 file changed, 34 insertions(+), 30 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1219,35 +1219,37 @@ static int esw_create_offloads_fdb_table
 	}
 	esw->fdb_table.offloads.send_to_vport_grp = g;
 
-	/* create peer esw miss group */
-	memset(flow_group_in, 0, inlen);
-
-	esw_set_flow_group_source_port(esw, flow_group_in);
-
-	if (!mlx5_eswitch_vport_match_metadata_enabled(esw)) {
-		match_criteria = MLX5_ADDR_OF(create_flow_group_in,
-					      flow_group_in,
-					      match_criteria);
-
-		MLX5_SET_TO_ONES(fte_match_param, match_criteria,
-				 misc_parameters.source_eswitch_owner_vhca_id);
-
-		MLX5_SET(create_flow_group_in, flow_group_in,
-			 source_eswitch_owner_vhca_id_valid, 1);
-	}
-
-	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, ix);
-	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index,
-		 ix + esw->total_vports - 1);
-	ix += esw->total_vports;
-
-	g = mlx5_create_flow_group(fdb, flow_group_in);
-	if (IS_ERR(g)) {
-		err = PTR_ERR(g);
-		esw_warn(dev, "Failed to create peer miss flow group err(%d)\n", err);
-		goto peer_miss_err;
+	if (MLX5_CAP_ESW(esw->dev, merged_eswitch)) {
+		/* create peer esw miss group */
+		memset(flow_group_in, 0, inlen);
+
+		esw_set_flow_group_source_port(esw, flow_group_in);
+
+		if (!mlx5_eswitch_vport_match_metadata_enabled(esw)) {
+			match_criteria = MLX5_ADDR_OF(create_flow_group_in,
+						      flow_group_in,
+						      match_criteria);
+
+			MLX5_SET_TO_ONES(fte_match_param, match_criteria,
+					 misc_parameters.source_eswitch_owner_vhca_id);
+
+			MLX5_SET(create_flow_group_in, flow_group_in,
+				 source_eswitch_owner_vhca_id_valid, 1);
+		}
+
+		MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, ix);
+		MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index,
+			 ix + esw->total_vports - 1);
+		ix += esw->total_vports;
+
+		g = mlx5_create_flow_group(fdb, flow_group_in);
+		if (IS_ERR(g)) {
+			err = PTR_ERR(g);
+			esw_warn(dev, "Failed to create peer miss flow group err(%d)\n", err);
+			goto peer_miss_err;
+		}
+		esw->fdb_table.offloads.peer_miss_grp = g;
 	}
-	esw->fdb_table.offloads.peer_miss_grp = g;
 
 	/* create miss group */
 	memset(flow_group_in, 0, inlen);
@@ -1282,7 +1284,8 @@ static int esw_create_offloads_fdb_table
 miss_rule_err:
 	mlx5_destroy_flow_group(esw->fdb_table.offloads.miss_grp);
 miss_err:
-	mlx5_destroy_flow_group(esw->fdb_table.offloads.peer_miss_grp);
+	if (MLX5_CAP_ESW(esw->dev, merged_eswitch))
+		mlx5_destroy_flow_group(esw->fdb_table.offloads.peer_miss_grp);
 peer_miss_err:
 	mlx5_destroy_flow_group(esw->fdb_table.offloads.send_to_vport_grp);
 send_vport_err:
@@ -1306,7 +1309,8 @@ static void esw_destroy_offloads_fdb_tab
 	mlx5_del_flow_rules(esw->fdb_table.offloads.miss_rule_multi);
 	mlx5_del_flow_rules(esw->fdb_table.offloads.miss_rule_uni);
 	mlx5_destroy_flow_group(esw->fdb_table.offloads.send_to_vport_grp);
-	mlx5_destroy_flow_group(esw->fdb_table.offloads.peer_miss_grp);
+	if (MLX5_CAP_ESW(esw->dev, merged_eswitch))
+		mlx5_destroy_flow_group(esw->fdb_table.offloads.peer_miss_grp);
 	mlx5_destroy_flow_group(esw->fdb_table.offloads.miss_grp);
 
 	mlx5_esw_chains_destroy(esw);


