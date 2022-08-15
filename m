Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B96D59420B
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231545AbiHOVTY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344456AbiHOVR3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:17:29 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5C745724D;
        Mon, 15 Aug 2022 12:20:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CEBA5CE12C8;
        Mon, 15 Aug 2022 19:20:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7892DC433C1;
        Mon, 15 Aug 2022 19:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591238;
        bh=2AIfHgwfeBKdGos6JvHSPfX/PD5vFVUIM0rHUicTW30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bnKuzD7F04uozYGDNJCVKa5cqu09nGg1XSyI+/+Kyy0HFZPaJzZVWdTlxNQk43krF
         TbntEMD+iLD7n4TmhUyQpSMAU7DegdQvLsFkVJQ5ULUhlnY047hjTuuK9xoD1l4aSW
         gnzzmOnI2PHjVxKwaRk8GSWw0oySSrDyCk97zv/o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0516/1095] net/mlx5e: Modify slow path rules to go to slow fdb
Date:   Mon, 15 Aug 2022 19:58:35 +0200
Message-Id: <20220815180450.888719957@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

[ Upstream commit c0063a43700fa8c98cac2637aa1afcf40bb9e403 ]

While extending available range of supported chains/prios referenced commit
also modified slow path rules to go to FT chain instead of actual slow FDB.
However neither of existing users of the MLX5_ATTR_FLAG_SLOW_PATH
flag (tunnel encap entries with invalid encap and flows with trap action)
need to match on FT chain. After bridge offload was implemented packets of
such flows can also be matched by bridge priority tables which is
undesirable. Restore slow path flows implementation to redirect packets to
slow_fdb.

Fixes: 278d51f24330 ("net/mlx5: E-Switch, Increase number of chains and priorities")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/eswitch_offloads.c     | 23 ++++++++++++++-----
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 796d97bcf1aa..c6546613f7d8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -230,10 +230,8 @@ esw_setup_ft_dest(struct mlx5_flow_destination *dest,
 }
 
 static void
-esw_setup_slow_path_dest(struct mlx5_flow_destination *dest,
-			 struct mlx5_flow_act *flow_act,
-			 struct mlx5_fs_chains *chains,
-			 int i)
+esw_setup_accept_dest(struct mlx5_flow_destination *dest, struct mlx5_flow_act *flow_act,
+		      struct mlx5_fs_chains *chains, int i)
 {
 	if (mlx5_chains_ignore_flow_level_supported(chains))
 		flow_act->flags |= FLOW_ACT_IGNORE_FLOW_LEVEL;
@@ -241,6 +239,16 @@ esw_setup_slow_path_dest(struct mlx5_flow_destination *dest,
 	dest[i].ft = mlx5_chains_get_tc_end_ft(chains);
 }
 
+static void
+esw_setup_slow_path_dest(struct mlx5_flow_destination *dest, struct mlx5_flow_act *flow_act,
+			 struct mlx5_eswitch *esw, int i)
+{
+	if (MLX5_CAP_ESW_FLOWTABLE_FDB(esw->dev, ignore_flow_level))
+		flow_act->flags |= FLOW_ACT_IGNORE_FLOW_LEVEL;
+	dest[i].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+	dest[i].ft = esw->fdb_table.offloads.slow_fdb;
+}
+
 static int
 esw_setup_chain_dest(struct mlx5_flow_destination *dest,
 		     struct mlx5_flow_act *flow_act,
@@ -473,8 +481,11 @@ esw_setup_dests(struct mlx5_flow_destination *dest,
 	} else if (attr->dest_ft) {
 		esw_setup_ft_dest(dest, flow_act, esw, attr, spec, *i);
 		(*i)++;
-	} else if (mlx5e_tc_attr_flags_skip(attr->flags)) {
-		esw_setup_slow_path_dest(dest, flow_act, chains, *i);
+	} else if (attr->flags & MLX5_ATTR_FLAG_SLOW_PATH) {
+		esw_setup_slow_path_dest(dest, flow_act, esw, *i);
+		(*i)++;
+	} else if (attr->flags & MLX5_ATTR_FLAG_ACCEPT) {
+		esw_setup_accept_dest(dest, flow_act, chains, *i);
 		(*i)++;
 	} else if (attr->dest_chain) {
 		err = esw_setup_chain_dest(dest, flow_act, chains, attr->dest_chain,
-- 
2.35.1



