Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4004E4C7697
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 19:04:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239511AbiB1SFR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 13:05:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240553AbiB1SDj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 13:03:39 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0896ED3;
        Mon, 28 Feb 2022 09:47:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 17A7ACE1795;
        Mon, 28 Feb 2022 17:46:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1976AC340E7;
        Mon, 28 Feb 2022 17:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070407;
        bh=UZuSh1OU8WluWR2uN48A2AvG3fGWeT73zKvtCXMShvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DaBZ4O+uAfjV7l0wV9f58c0aad86wAPRKWnT/rjzm/5TtbaR8+Y8i0dgrfVNig3gH
         LPK7IQ4Pt7uz2iTV3l/c6H5r67hhcT9AazQr8RHTp3zkSUOeP7e9FdQV4K83DekcFY
         ws/4i2vOIHnAMFFvd9+dKRvCLsqrgl5oMtTEAMcI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.16 096/164] net/mlx5: DR, Fix slab-out-of-bounds in mlx5_cmd_dr_create_fte
Date:   Mon, 28 Feb 2022 18:24:18 +0100
Message-Id: <20220228172408.488479024@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

commit 0aec12d97b2036af0946e3d582144739860ac07b upstream.

When adding a rule with 32 destinations, we hit the following out-of-band
access issue:

  BUG: KASAN: slab-out-of-bounds in mlx5_cmd_dr_create_fte+0x18ee/0x1e70

This patch fixes the issue by both increasing the allocated buffers to
accommodate for the needed actions and by checking the number of actions
to prevent this issue when a rule with too many actions is provided.

Fixes: 1ffd498901c1 ("net/mlx5: DR, Increase supported num of actions to 32")
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c |   33 +++++++++++----
 1 file changed, 26 insertions(+), 7 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
@@ -222,7 +222,11 @@ static bool contain_vport_reformat_actio
 		dst->dest_attr.vport.flags & MLX5_FLOW_DEST_VPORT_REFORMAT_ID;
 }
 
-#define MLX5_FLOW_CONTEXT_ACTION_MAX  32
+/* We want to support a rule with 32 destinations, which means we need to
+ * account for 32 destinations plus usually a counter plus one more action
+ * for a multi-destination flow table.
+ */
+#define MLX5_FLOW_CONTEXT_ACTION_MAX  34
 static int mlx5_cmd_dr_create_fte(struct mlx5_flow_root_namespace *ns,
 				  struct mlx5_flow_table *ft,
 				  struct mlx5_flow_group *group,
@@ -392,9 +396,9 @@ static int mlx5_cmd_dr_create_fte(struct
 			enum mlx5_flow_destination_type type = dst->dest_attr.type;
 			u32 id;
 
-			if (num_actions == MLX5_FLOW_CONTEXT_ACTION_MAX ||
-			    num_term_actions >= MLX5_FLOW_CONTEXT_ACTION_MAX) {
-				err = -ENOSPC;
+			if (fs_dr_num_actions == MLX5_FLOW_CONTEXT_ACTION_MAX ||
+			    num_term_actions == MLX5_FLOW_CONTEXT_ACTION_MAX) {
+				err = -EOPNOTSUPP;
 				goto free_actions;
 			}
 
@@ -464,8 +468,9 @@ static int mlx5_cmd_dr_create_fte(struct
 			    MLX5_FLOW_DESTINATION_TYPE_COUNTER)
 				continue;
 
-			if (num_actions == MLX5_FLOW_CONTEXT_ACTION_MAX) {
-				err = -ENOSPC;
+			if (num_actions == MLX5_FLOW_CONTEXT_ACTION_MAX ||
+			    fs_dr_num_actions == MLX5_FLOW_CONTEXT_ACTION_MAX) {
+				err = -EOPNOTSUPP;
 				goto free_actions;
 			}
 
@@ -485,14 +490,28 @@ static int mlx5_cmd_dr_create_fte(struct
 	params.match_sz = match_sz;
 	params.match_buf = (u64 *)fte->val;
 	if (num_term_actions == 1) {
-		if (term_actions->reformat)
+		if (term_actions->reformat) {
+			if (num_actions == MLX5_FLOW_CONTEXT_ACTION_MAX) {
+				err = -EOPNOTSUPP;
+				goto free_actions;
+			}
 			actions[num_actions++] = term_actions->reformat;
+		}
 
+		if (num_actions == MLX5_FLOW_CONTEXT_ACTION_MAX) {
+			err = -EOPNOTSUPP;
+			goto free_actions;
+		}
 		actions[num_actions++] = term_actions->dest;
 	} else if (num_term_actions > 1) {
 		bool ignore_flow_level =
 			!!(fte->action.flags & FLOW_ACT_IGNORE_FLOW_LEVEL);
 
+		if (num_actions == MLX5_FLOW_CONTEXT_ACTION_MAX ||
+		    fs_dr_num_actions == MLX5_FLOW_CONTEXT_ACTION_MAX) {
+			err = -EOPNOTSUPP;
+			goto free_actions;
+		}
 		tmp_action = mlx5dr_action_create_mult_dest_tbl(domain,
 								term_actions,
 								num_term_actions,


