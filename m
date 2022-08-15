Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E49B594AE2
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356165AbiHPAHH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:07:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353307AbiHPAAM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:00:12 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D22F181694;
        Mon, 15 Aug 2022 13:21:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2E953CE130D;
        Mon, 15 Aug 2022 20:21:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 268A4C433D6;
        Mon, 15 Aug 2022 20:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594871;
        bh=QmQblr9lNc3Znr/KORo+y2D76PXoINXgpR7Fk5MGfV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NNQWQj4K1SjOrV0i6TdJ6/uu2sIsRpObEBeQPH8gYtqkz0ZYHT1bQg2U77306PnbY
         QtKNYPGWlE+idi66BY2Qm36l5nECKpReCUZ12/wI51uN58hiEzbOdfjpO/75OecP6+
         I3MubGiTyzTOYPoua4Uyoa9aMwwrO3zSGDY5F72U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0552/1157] net/mlx5e: Modify slow path rules to go to slow fdb
Date:   Mon, 15 Aug 2022 19:58:28 +0200
Message-Id: <20220815180501.720041214@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
index 2ce3728576d1..eb79810199d3 100644
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
@@ -475,8 +483,11 @@ esw_setup_dests(struct mlx5_flow_destination *dest,
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



