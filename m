Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66E4353197C
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239684AbiEWRcc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241564AbiEWR0v (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:26:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47DE77523A;
        Mon, 23 May 2022 10:22:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4256560AB8;
        Mon, 23 May 2022 17:21:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE64C385A9;
        Mon, 23 May 2022 17:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326465;
        bh=op7TVYHn5m+9M4CRry2VcLoDvpH7NSBWAe8tL1+DddU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1DXcoOzGSvoYDRqc/UB2s4q1PAnsX7vF/2RZsaTYGC3yUM2yoy+XCcXpA5JG2t6xp
         pmst/XALaSekZ7x3YLa0UrMt+xQkjf2Gi3WADIL50UO5jNuwU37Wtj4lfORclBKyiE
         RrwQyr2PwfqTnEgvVybfxZzetSlbLSZ8mLAa2elU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Dickman <maord@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 090/132] net/mlx5: DR, Fix missing flow_source when creating multi-destination FW table
Date:   Mon, 23 May 2022 19:04:59 +0200
Message-Id: <20220523165838.227792625@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165823.492309987@linuxfoundation.org>
References: <20220523165823.492309987@linuxfoundation.org>
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
index a5b9f65db23c..897c7f852123 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -846,7 +846,8 @@ struct mlx5dr_action *
 mlx5dr_action_create_mult_dest_tbl(struct mlx5dr_domain *dmn,
 				   struct mlx5dr_action_dest *dests,
 				   u32 num_of_dests,
-				   bool ignore_flow_level)
+				   bool ignore_flow_level,
+				   u32 flow_source)
 {
 	struct mlx5dr_cmd_flow_destination_hw_info *hw_dests;
 	struct mlx5dr_action **ref_actions;
@@ -914,7 +915,8 @@ mlx5dr_action_create_mult_dest_tbl(struct mlx5dr_domain *dmn,
 				      reformat_req,
 				      &action->dest_tbl->fw_tbl.id,
 				      &action->dest_tbl->fw_tbl.group_id,
-				      ignore_flow_level);
+				      ignore_flow_level,
+				      flow_source);
 	if (ret)
 		goto free_action;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_fw.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_fw.c
index 0d6f86eb248b..c74083de1801 100644
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
index 3d4e035698dd..bc206836af6a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -1394,7 +1394,8 @@ int mlx5dr_fw_create_md_tbl(struct mlx5dr_domain *dmn,
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
index 7e58f4e594b7..ae4597118f8b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
@@ -492,11 +492,13 @@ static int mlx5_cmd_dr_create_fte(struct mlx5_flow_root_namespace *ns,
 	} else if (num_term_actions > 1) {
 		bool ignore_flow_level =
 			!!(fte->action.flags & FLOW_ACT_IGNORE_FLOW_LEVEL);
+		u32 flow_source = fte->flow_context.flow_source;
 
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
index 5ef199543479..7806e5c05b67 100644
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



