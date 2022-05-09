Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12D0651FA01
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 12:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbiEIKfq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 06:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232624AbiEIKe5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 06:34:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4B00253A97
        for <stable@vger.kernel.org>; Mon,  9 May 2022 03:30:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F33660F88
        for <stable@vger.kernel.org>; Mon,  9 May 2022 10:30:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64459C385AB;
        Mon,  9 May 2022 10:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652092252;
        bh=TA/k9polGAyg1i9gbiQWZaXHM/w5WKsrhS+LrDLx3AA=;
        h=Subject:To:Cc:From:Date:From;
        b=zxWAFdN7yRST5xNKe+R+alO3cMWhFukB66kxUk7Y14bX2t14vxaNAEBL9OSKjx8TX
         Q0crEfuBJVD6M1MlU03tMjzrb8Nvb1SnYENI+yjgUeKN7kvUtHv0MRhrq7t8iOxn0U
         iRytiZVp6E2RP+ua0BZlGAOd0VtTx/4gC8qEW3QE=
Subject: FAILED: patch "[PATCH] net/mlx5e: TC, Fix ct_clear overwriting ct action metadata" failed to apply to 5.17-stable tree
To:     lariel@nvidia.com, maord@nvidia.com, paulb@nvidia.com,
        roid@nvidia.com, saeedm@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 May 2022 12:30:50 +0200
Message-ID: <165209225021618@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.17-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 087032ee7021a22e4c7557c0ed16bfd792c3f6fe Mon Sep 17 00:00:00 2001
From: Ariel Levkovich <lariel@nvidia.com>
Date: Wed, 23 Feb 2022 21:29:17 +0200
Subject: [PATCH] net/mlx5e: TC, Fix ct_clear overwriting ct action metadata

ct_clear action is translated to clearing reg_c metadata
which holds ct state and zone information using mod header
actions.
These actions are allocated during the actions parsing, as
part of the flow attributes main mod header action list.

If ct action exists in the rule, the flow's main mod header
is used only in the post action table rule, after the ct tables
which set the ct info in the reg_c as part of the ct actions.

Therefore, if the original rule has a ct_clear action followed
by a ct action, the ct action reg_c setting will be done first and
will be followed by the ct_clear resetting reg_c and overwriting
the ct info.

Fix this by moving the ct_clear mod header actions allocation from
the ct action parsing stage to the ct action post parsing stage where
it is already known if ct_clear is followed by a ct action.
In such case, we skip the mod header actions allocation for the ct
clear since the ct action will write to reg_c anyway after clearing it.

Fixes: 806401c20a0f ("net/mlx5e: CT, Fix multiple allocations and memleak of mod acts")
Signed-off-by: Ariel Levkovich <lariel@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c
index b9d38fe807df..a829c94289c1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c
@@ -45,12 +45,41 @@ tc_act_parse_ct(struct mlx5e_tc_act_parse_state *parse_state,
 	if (mlx5e_is_eswitch_flow(parse_state->flow))
 		attr->esw_attr->split_count = attr->esw_attr->out_count;
 
-	if (!clear_action) {
+	if (clear_action) {
+		parse_state->ct_clear = true;
+	} else {
 		attr->flags |= MLX5_ATTR_FLAG_CT;
 		flow_flag_set(parse_state->flow, CT);
 		parse_state->ct = true;
 	}
-	parse_state->ct_clear = clear_action;
+
+	return 0;
+}
+
+static int
+tc_act_post_parse_ct(struct mlx5e_tc_act_parse_state *parse_state,
+		     struct mlx5e_priv *priv,
+		     struct mlx5_flow_attr *attr)
+{
+	struct mlx5e_tc_mod_hdr_acts *mod_acts = &attr->parse_attr->mod_hdr_acts;
+	int err;
+
+	/* If ct action exist, we can ignore previous ct_clear actions */
+	if (parse_state->ct)
+		return 0;
+
+	if (parse_state->ct_clear) {
+		err = mlx5_tc_ct_set_ct_clear_regs(parse_state->ct_priv, mod_acts);
+		if (err) {
+			NL_SET_ERR_MSG_MOD(parse_state->extack,
+					   "Failed to set registers for ct clear");
+			return err;
+		}
+		attr->action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
+
+		/* Prevent handling of additional, redundant clear actions */
+		parse_state->ct_clear = false;
+	}
 
 	return 0;
 }
@@ -70,5 +99,6 @@ struct mlx5e_tc_act mlx5e_tc_act_ct = {
 	.can_offload = tc_act_can_offload_ct,
 	.parse_action = tc_act_parse_ct,
 	.is_multi_table_act = tc_act_is_multi_table_act_ct,
+	.post_parse = tc_act_post_parse_ct,
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index e49f51124c74..73a1e0a4818d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -582,6 +582,12 @@ mlx5_tc_ct_entry_set_registers(struct mlx5_tc_ct_priv *ct_priv,
 	return 0;
 }
 
+int mlx5_tc_ct_set_ct_clear_regs(struct mlx5_tc_ct_priv *priv,
+				 struct mlx5e_tc_mod_hdr_acts *mod_acts)
+{
+		return mlx5_tc_ct_entry_set_registers(priv, mod_acts, 0, 0, 0, 0);
+}
+
 static int
 mlx5_tc_ct_parse_mangle_to_mod_act(struct flow_action_entry *act,
 				   char *modact)
@@ -1410,9 +1416,6 @@ mlx5_tc_ct_parse_action(struct mlx5_tc_ct_priv *priv,
 			const struct flow_action_entry *act,
 			struct netlink_ext_ack *extack)
 {
-	bool clear_action = act->ct.action & TCA_CT_ACT_CLEAR;
-	int err;
-
 	if (!priv) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "offload of ct action isn't available");
@@ -1423,17 +1426,6 @@ mlx5_tc_ct_parse_action(struct mlx5_tc_ct_priv *priv,
 	attr->ct_attr.ct_action = act->ct.action;
 	attr->ct_attr.nf_ft = act->ct.flow_table;
 
-	if (!clear_action)
-		goto out;
-
-	err = mlx5_tc_ct_entry_set_registers(priv, mod_acts, 0, 0, 0, 0);
-	if (err) {
-		NL_SET_ERR_MSG_MOD(extack, "Failed to set registers for ct clear");
-		return err;
-	}
-	attr->action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
-
-out:
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
index 36d3652bf829..00a3ba862afb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
@@ -129,6 +129,10 @@ bool
 mlx5e_tc_ct_restore_flow(struct mlx5_tc_ct_priv *ct_priv,
 			 struct sk_buff *skb, u8 zone_restore_id);
 
+int
+mlx5_tc_ct_set_ct_clear_regs(struct mlx5_tc_ct_priv *priv,
+			     struct mlx5e_tc_mod_hdr_acts *mod_acts);
+
 #else /* CONFIG_MLX5_TC_CT */
 
 static inline struct mlx5_tc_ct_priv *
@@ -170,6 +174,13 @@ mlx5_tc_ct_add_no_trk_match(struct mlx5_flow_spec *spec)
 	return 0;
 }
 
+static inline int
+mlx5_tc_ct_set_ct_clear_regs(struct mlx5_tc_ct_priv *priv,
+			     struct mlx5e_tc_mod_hdr_acts *mod_acts)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline int
 mlx5_tc_ct_parse_action(struct mlx5_tc_ct_priv *priv,
 			struct mlx5_flow_attr *attr,

