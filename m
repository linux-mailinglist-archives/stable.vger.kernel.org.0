Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46C92531D14
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240054AbiEWRoH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:44:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242711AbiEWRhp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:37:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DAA15BE52;
        Mon, 23 May 2022 10:31:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 299EB611CB;
        Mon, 23 May 2022 17:28:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 265C8C34116;
        Mon, 23 May 2022 17:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326931;
        bh=flgFXLXgvcqitHLhOUjyuhNpWRTcqrdXR5m+Cf7zjE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cy+NF8hOOMaSALvU0pnvTijh8pc85ziWAhvRZeUO04WrRLjo+y//xKr/eFZbv2rW/
         c3GYaeLGq8pfHXCrG+vi9zqMbMwf8S/wcSEM8C2GaaqrChWoj8SNOHcylZ/5ibsmpH
         hEN4YzLCZ/gdTqkaCuG79VfbaubZDq7QkMJyntEQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 104/158] net/mlx5: DR, Ignore modify TTL on RX if device doesnt support it
Date:   Mon, 23 May 2022 19:04:21 +0200
Message-Id: <20220523165848.485323933@linuxfoundation.org>
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

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

[ Upstream commit 785d7ed295513bd3374095304b7034fd65c123b0 ]

When modifying TTL, packet's csum has to be recalculated.
Due to HW issue in ConnectX-5, csum recalculation for modify
TTL on RX is supported through a work-around that is specifically
enabled by configuration.
If the work-around isn't enabled, rather than adding an unsupported
action the modify TTL action on RX should be ignored.
Ignoring modify TTL action might result in zero actions, so in such
cases we will not convert the match STE to modify STE, as it is done
by FW in DMFS.

This patch fixes an issue where modify TTL action was ignored both
on RX and TX instead of only on RX.

Fixes: 4ff725e1d4ad ("net/mlx5: DR, Ignore modify TTL if device doesn't support it")
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/steering/dr_action.c   | 65 +++++++++++++------
 .../mellanox/mlx5/core/steering/dr_ste_v0.c   |  4 +-
 2 files changed, 48 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index 5d1caf97a8fc..8622af6d6bf8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -530,6 +530,37 @@ static int dr_action_handle_cs_recalc(struct mlx5dr_domain *dmn,
 	return 0;
 }
 
+static void dr_action_modify_ttl_adjust(struct mlx5dr_domain *dmn,
+					struct mlx5dr_ste_actions_attr *attr,
+					bool rx_rule,
+					bool *recalc_cs_required)
+{
+	*recalc_cs_required = false;
+
+	/* if device supports csum recalculation - no adjustment needed */
+	if (mlx5dr_ste_supp_ttl_cs_recalc(&dmn->info.caps))
+		return;
+
+	/* no adjustment needed on TX rules */
+	if (!rx_rule)
+		return;
+
+	if (!MLX5_CAP_ESW_FLOWTABLE(dmn->mdev, fdb_ipv4_ttl_modify)) {
+		/* Ignore the modify TTL action.
+		 * It is always kept as last HW action.
+		 */
+		attr->modify_actions--;
+		return;
+	}
+
+	if (dmn->type == MLX5DR_DOMAIN_TYPE_FDB)
+		/* Due to a HW bug on some devices, modifying TTL on RX flows
+		 * will cause an incorrect checksum calculation. In such cases
+		 * we will use a FW table to recalculate the checksum.
+		 */
+		*recalc_cs_required = true;
+}
+
 static void dr_action_print_sequence(struct mlx5dr_domain *dmn,
 				     struct mlx5dr_action *actions[],
 				     int last_idx)
@@ -649,8 +680,9 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
 		case DR_ACTION_TYP_MODIFY_HDR:
 			attr.modify_index = action->rewrite->index;
 			attr.modify_actions = action->rewrite->num_of_actions;
-			recalc_cs_required = action->rewrite->modify_ttl &&
-					     !mlx5dr_ste_supp_ttl_cs_recalc(&dmn->info.caps);
+			if (action->rewrite->modify_ttl)
+				dr_action_modify_ttl_adjust(dmn, &attr, rx_rule,
+							    &recalc_cs_required);
 			break;
 		case DR_ACTION_TYP_L2_TO_TNL_L2:
 		case DR_ACTION_TYP_L2_TO_TNL_L3:
@@ -737,12 +769,7 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
 	*new_hw_ste_arr_sz = nic_matcher->num_of_builders;
 	last_ste = ste_arr + DR_STE_SIZE * (nic_matcher->num_of_builders - 1);
 
-	/* Due to a HW bug in some devices, modifying TTL on RX flows will
-	 * cause an incorrect checksum calculation. In this case we will
-	 * use a FW table to recalculate.
-	 */
-	if (dmn->type == MLX5DR_DOMAIN_TYPE_FDB &&
-	    rx_rule && recalc_cs_required && dest_action) {
+	if (recalc_cs_required && dest_action) {
 		ret = dr_action_handle_cs_recalc(dmn, dest_action, &attr.final_icm_addr);
 		if (ret) {
 			mlx5dr_err(dmn,
@@ -1562,12 +1589,6 @@ dr_action_modify_check_is_ttl_modify(const void *sw_action)
 	return sw_field == MLX5_ACTION_IN_FIELD_OUT_IP_TTL;
 }
 
-static bool dr_action_modify_ttl_ignore(struct mlx5dr_domain *dmn)
-{
-	return !mlx5dr_ste_supp_ttl_cs_recalc(&dmn->info.caps) &&
-	       !MLX5_CAP_ESW_FLOWTABLE(dmn->mdev, fdb_ipv4_ttl_modify);
-}
-
 static int dr_actions_convert_modify_header(struct mlx5dr_action *action,
 					    u32 max_hw_actions,
 					    u32 num_sw_actions,
@@ -1579,6 +1600,7 @@ static int dr_actions_convert_modify_header(struct mlx5dr_action *action,
 	const struct mlx5dr_ste_action_modify_field *hw_dst_action_info;
 	const struct mlx5dr_ste_action_modify_field *hw_src_action_info;
 	struct mlx5dr_domain *dmn = action->rewrite->dmn;
+	__be64 *modify_ttl_sw_action = NULL;
 	int ret, i, hw_idx = 0;
 	__be64 *sw_action;
 	__be64 hw_action;
@@ -1591,8 +1613,14 @@ static int dr_actions_convert_modify_header(struct mlx5dr_action *action,
 	action->rewrite->allow_rx = 1;
 	action->rewrite->allow_tx = 1;
 
-	for (i = 0; i < num_sw_actions; i++) {
-		sw_action = &sw_actions[i];
+	for (i = 0; i < num_sw_actions || modify_ttl_sw_action; i++) {
+		/* modify TTL is handled separately, as a last action */
+		if (i == num_sw_actions) {
+			sw_action = modify_ttl_sw_action;
+			modify_ttl_sw_action = NULL;
+		} else {
+			sw_action = &sw_actions[i];
+		}
 
 		ret = dr_action_modify_check_field_limitation(action,
 							      sw_action);
@@ -1601,10 +1629,9 @@ static int dr_actions_convert_modify_header(struct mlx5dr_action *action,
 
 		if (!(*modify_ttl) &&
 		    dr_action_modify_check_is_ttl_modify(sw_action)) {
-			if (dr_action_modify_ttl_ignore(dmn))
-				continue;
-
+			modify_ttl_sw_action = sw_action;
 			*modify_ttl = true;
+			continue;
 		}
 
 		/* Convert SW action to HW action */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
index 2d62950f7a29..134c8484c901 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
@@ -419,7 +419,7 @@ dr_ste_v0_set_actions_tx(struct mlx5dr_domain *dmn,
 	 * encapsulation. The reason for that is that we support
 	 * modify headers for outer headers only
 	 */
-	if (action_type_set[DR_ACTION_TYP_MODIFY_HDR]) {
+	if (action_type_set[DR_ACTION_TYP_MODIFY_HDR] && attr->modify_actions) {
 		dr_ste_v0_set_entry_type(last_ste, DR_STE_TYPE_MODIFY_PKT);
 		dr_ste_v0_set_rewrite_actions(last_ste,
 					      attr->modify_actions,
@@ -511,7 +511,7 @@ dr_ste_v0_set_actions_rx(struct mlx5dr_domain *dmn,
 		}
 	}
 
-	if (action_type_set[DR_ACTION_TYP_MODIFY_HDR]) {
+	if (action_type_set[DR_ACTION_TYP_MODIFY_HDR] && attr->modify_actions) {
 		if (dr_ste_v0_get_entry_type(last_ste) == DR_STE_TYPE_MODIFY_PKT)
 			dr_ste_v0_arr_init_next(&last_ste,
 						added_stes,
-- 
2.35.1



