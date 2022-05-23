Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBC8E531A3E
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241660AbiEWRjn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:39:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242952AbiEWRhv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:37:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D606351C;
        Mon, 23 May 2022 10:31:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD99B611E6;
        Mon, 23 May 2022 17:30:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0CA0C385A9;
        Mon, 23 May 2022 17:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653327040;
        bh=JtVMK1J56BWXLZvCcn/YesZxEVRZCxup/GGdgk9PEC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aG5iBD5yaBYWY0ASydJP8L1YhcTitrTOeyhwS0eji/SImztfjDy5S2nSVJG9KGdC6
         2jwhSvpWL3zNf452dkhTizW1m5dfGaa38KA8vEOeY30Lfn9VN2rAFsNh7ECwp6MQ9U
         yohSOXWgHl7imNoaDuz8j4beDUA/AhPO4YuD1z4s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Dickman <maord@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 102/158] net/mlx5: DR, Fix missing flow_source when creating multi-destination FW table
Date:   Mon, 23 May 2022 19:04:19 +0200
Message-Id: <20220523165848.231649115@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

[ Upstream commit 2c5fc6cd269ad3476da99dad02521d2af4a8e906 ]

In order to support multiple destination FTEs with SW steering
FW table is created with single FTE with multiple actions and
SW steering rule forward to it. When creating this table, flow
source isn't set according to the original FTE.

Fix this by passing the original FTE flow source to the created
FW table.

Fixes: 34583beea4b7 ("net/mlx5: DR, Create multi-destination table for SW-steering use")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/steering/dr_action.c    | 6 ++++--
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_fw.c    | 4 +++-
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h | 3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c    | 4 +++-
 drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h   | 3 ++-
 5 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index c61a5e83c78c..5d1caf97a8fc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -847,7 +847,8 @@ struct mlx5dr_action *
 mlx5dr_action_create_mult_dest_tbl(struct mlx5dr_domain *dmn,
 				   struct mlx5dr_action_dest *dests,
 				   u32 num_of_dests,
-				   bool ignore_flow_level)
+				   bool ignore_flow_level,
+				   u32 flow_source)
 {
 	struct mlx5dr_cmd_flow_destination_hw_info *hw_dests;
 	struct mlx5dr_action **ref_actions;
@@ -919,7 +920,8 @@ mlx5dr_action_create_mult_dest_tbl(struct mlx5dr_domain *dmn,
 				      reformat_req,
 				      &action->dest_tbl->fw_tbl.id,
 				      &action->dest_tbl->fw_tbl.group_id,
-				      ignore_flow_level);
+				      ignore_flow_level,
+				      flow_source);
 	if (ret)
 		goto free_action;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_fw.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_fw.c
index 68a4c32d5f34..f05ef0cd54ba 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_fw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_fw.c
@@ -104,7 +104,8 @@ int mlx5dr_fw_create_md_tbl(struct mlx5dr_domain *dmn,
 			    bool reformat_req,
 			    u32 *tbl_id,
 			    u32 *group_id,
-			    bool ignore_flow_level)
+			    bool ignore_flow_level,
+			    u32 flow_source)
 {
 	struct mlx5dr_cmd_create_flow_table_attr ft_attr = {};
 	struct mlx5dr_cmd_fte_info fte_info = {};
@@ -139,6 +140,7 @@ int mlx5dr_fw_create_md_tbl(struct mlx5dr_domain *dmn,
 	fte_info.val = val;
 	fte_info.dest_arr = dest;
 	fte_info.ignore_flow_level = ignore_flow_level;
+	fte_info.flow_context.flow_source = flow_source;
 
 	ret = mlx5dr_cmd_set_fte(dmn->mdev, 0, 0, &ft_info, *group_id, &fte_info);
 	if (ret) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 55fcb751e24a..64f41e7938e1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -1463,7 +1463,8 @@ int mlx5dr_fw_create_md_tbl(struct mlx5dr_domain *dmn,
 			    bool reformat_req,
 			    u32 *tbl_id,
 			    u32 *group_id,
-			    bool ignore_flow_level);
+			    bool ignore_flow_level,
+			    u32 flow_source);
 void mlx5dr_fw_destroy_md_tbl(struct mlx5dr_domain *dmn, u32 tbl_id,
 			      u32 group_id);
 #endif  /* _DR_TYPES_H_ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
index 3f311462bedf..05393fe11132 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
@@ -520,6 +520,7 @@ static int mlx5_cmd_dr_create_fte(struct mlx5_flow_root_namespace *ns,
 	} else if (num_term_actions > 1) {
 		bool ignore_flow_level =
 			!!(fte->action.flags & FLOW_ACT_IGNORE_FLOW_LEVEL);
+		u32 flow_source = fte->flow_context.flow_source;
 
 		if (num_actions == MLX5_FLOW_CONTEXT_ACTION_MAX ||
 		    fs_dr_num_actions == MLX5_FLOW_CONTEXT_ACTION_MAX) {
@@ -529,7 +530,8 @@ static int mlx5_cmd_dr_create_fte(struct mlx5_flow_root_namespace *ns,
 		tmp_action = mlx5dr_action_create_mult_dest_tbl(domain,
 								term_actions,
 								num_term_actions,
-								ignore_flow_level);
+								ignore_flow_level,
+								flow_source);
 		if (!tmp_action) {
 			err = -EOPNOTSUPP;
 			goto free_actions;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
index dfa223415fe2..74a7a2f4d50d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
@@ -96,7 +96,8 @@ struct mlx5dr_action *
 mlx5dr_action_create_mult_dest_tbl(struct mlx5dr_domain *dmn,
 				   struct mlx5dr_action_dest *dests,
 				   u32 num_of_dests,
-				   bool ignore_flow_level);
+				   bool ignore_flow_level,
+				   u32 flow_source);
 
 struct mlx5dr_action *mlx5dr_action_create_drop(void);
 
-- 
2.35.1



