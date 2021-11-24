Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B85D445C556
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353114AbhKXN4r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:56:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:45402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349824AbhKXNyn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:54:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0BD860F58;
        Wed, 24 Nov 2021 13:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759155;
        bh=5grc4UgLcXyRgqJqReVQ6SYLRxvThk+x8KxCXyIeIUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KuAIPeRGtcW7KKJHIIpFFwV9+SYFxy8oSfIm7C9BE1SGRjDyLUrXryCmQP8tTlF7T
         /OYSuEc4Tco0IWYzbeswPJlZwpt/hgcQEYlDrvDnG/NaebyF26BK5l+Jm9tKITaaoe
         if30xZraFRzuQrZC3qHVXFYAcvi5iETUDrV1bz9c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 149/279] net/mlx5e: CT, Fix multiple allocations and memleak of mod acts
Date:   Wed, 24 Nov 2021 12:57:16 +0100
Message-Id: <20211124115723.922304833@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

[ Upstream commit 806401c20a0f9c51b6c8fd7035671e6ca841f6c2 ]

CT clear action offload adds additional mod hdr actions to the
flow's original mod actions in order to clear the registers which
hold ct_state.
When such flow also includes encap action, a neigh update event
can cause the driver to unoffload the flow and then reoffload it.

Each time this happens, the ct clear handling adds that same set
of mod hdr actions to reset ct_state until the max of mod hdr
actions is reached.

Also the driver never releases the allocated mod hdr actions and
causing a memleak.

Fix above two issues by moving CT clear mod acts allocation
into the parsing actions phase and only use it when offloading the rule.
The release of mod acts will be done in the normal flow_put().

 backtrace:
    [<000000007316e2f3>] krealloc+0x83/0xd0
    [<00000000ef157de1>] mlx5e_mod_hdr_alloc+0x147/0x300 [mlx5_core]
    [<00000000970ce4ae>] mlx5e_tc_match_to_reg_set_and_get_id+0xd7/0x240 [mlx5_core]
    [<0000000067c5fa17>] mlx5e_tc_match_to_reg_set+0xa/0x20 [mlx5_core]
    [<00000000d032eb98>] mlx5_tc_ct_entry_set_registers.isra.0+0x36/0xc0 [mlx5_core]
    [<00000000fd23b869>] mlx5_tc_ct_flow_offload+0x272/0x1f10 [mlx5_core]
    [<000000004fc24acc>] mlx5e_tc_offload_fdb_rules.part.0+0x150/0x620 [mlx5_core]
    [<00000000dc741c17>] mlx5e_tc_encap_flows_add+0x489/0x690 [mlx5_core]
    [<00000000e92e49d7>] mlx5e_rep_update_flows+0x6e4/0x9b0 [mlx5_core]
    [<00000000f60f5602>] mlx5e_rep_neigh_update+0x39a/0x5d0 [mlx5_core]

Fixes: 1ef3018f5af3 ("net/mlx5e: CT: Support clear action")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    | 26 ++++++++++++-------
 .../ethernet/mellanox/mlx5/core/en/tc_ct.h    |  2 ++
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  8 ++++--
 3 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 6c949abcd2e14..bc65151321ec2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -1356,9 +1356,13 @@ mlx5_tc_ct_match_add(struct mlx5_tc_ct_priv *priv,
 int
 mlx5_tc_ct_parse_action(struct mlx5_tc_ct_priv *priv,
 			struct mlx5_flow_attr *attr,
+			struct mlx5e_tc_mod_hdr_acts *mod_acts,
 			const struct flow_action_entry *act,
 			struct netlink_ext_ack *extack)
 {
+	bool clear_action = act->ct.action & TCA_CT_ACT_CLEAR;
+	int err;
+
 	if (!priv) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "offload of ct action isn't available");
@@ -1369,6 +1373,17 @@ mlx5_tc_ct_parse_action(struct mlx5_tc_ct_priv *priv,
 	attr->ct_attr.ct_action = act->ct.action;
 	attr->ct_attr.nf_ft = act->ct.flow_table;
 
+	if (!clear_action)
+		goto out;
+
+	err = mlx5_tc_ct_entry_set_registers(priv, mod_acts, 0, 0, 0, 0);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to set registers for ct clear");
+		return err;
+	}
+	attr->action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
+
+out:
 	return 0;
 }
 
@@ -1898,23 +1913,16 @@ __mlx5_tc_ct_flow_offload_clear(struct mlx5_tc_ct_priv *ct_priv,
 
 	memcpy(pre_ct_attr, attr, attr_sz);
 
-	err = mlx5_tc_ct_entry_set_registers(ct_priv, mod_acts, 0, 0, 0, 0);
-	if (err) {
-		ct_dbg("Failed to set register for ct clear");
-		goto err_set_registers;
-	}
-
 	mod_hdr = mlx5_modify_header_alloc(priv->mdev, ct_priv->ns_type,
 					   mod_acts->num_actions,
 					   mod_acts->actions);
 	if (IS_ERR(mod_hdr)) {
 		err = PTR_ERR(mod_hdr);
 		ct_dbg("Failed to add create ct clear mod hdr");
-		goto err_set_registers;
+		goto err_mod_hdr;
 	}
 
 	pre_ct_attr->modify_hdr = mod_hdr;
-	pre_ct_attr->action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
 
 	rule = mlx5_tc_rule_insert(priv, orig_spec, pre_ct_attr);
 	if (IS_ERR(rule)) {
@@ -1930,7 +1938,7 @@ __mlx5_tc_ct_flow_offload_clear(struct mlx5_tc_ct_priv *ct_priv,
 
 err_insert:
 	mlx5_modify_header_dealloc(priv->mdev, mod_hdr);
-err_set_registers:
+err_mod_hdr:
 	netdev_warn(priv->netdev,
 		    "Failed to offload ct clear flow, err %d\n", err);
 	kfree(pre_ct_attr);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
index 363329f4aac61..99662af1e41a7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
@@ -110,6 +110,7 @@ int mlx5_tc_ct_add_no_trk_match(struct mlx5_flow_spec *spec);
 int
 mlx5_tc_ct_parse_action(struct mlx5_tc_ct_priv *priv,
 			struct mlx5_flow_attr *attr,
+			struct mlx5e_tc_mod_hdr_acts *mod_acts,
 			const struct flow_action_entry *act,
 			struct netlink_ext_ack *extack);
 
@@ -172,6 +173,7 @@ mlx5_tc_ct_add_no_trk_match(struct mlx5_flow_spec *spec)
 static inline int
 mlx5_tc_ct_parse_action(struct mlx5_tc_ct_priv *priv,
 			struct mlx5_flow_attr *attr,
+			struct mlx5e_tc_mod_hdr_acts *mod_acts,
 			const struct flow_action_entry *act,
 			struct netlink_ext_ack *extack)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index d2e7b099b83ab..e3b320b6d85b9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3458,7 +3458,9 @@ static int parse_tc_nic_actions(struct mlx5e_priv *priv,
 			attr->dest_chain = act->chain_index;
 			break;
 		case FLOW_ACTION_CT:
-			err = mlx5_tc_ct_parse_action(get_ct_priv(priv), attr, act, extack);
+			err = mlx5_tc_ct_parse_action(get_ct_priv(priv), attr,
+						      &parse_attr->mod_hdr_acts,
+						      act, extack);
 			if (err)
 				return err;
 
@@ -4009,7 +4011,9 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 				NL_SET_ERR_MSG_MOD(extack, "Sample action with connection tracking is not supported");
 				return -EOPNOTSUPP;
 			}
-			err = mlx5_tc_ct_parse_action(get_ct_priv(priv), attr, act, extack);
+			err = mlx5_tc_ct_parse_action(get_ct_priv(priv), attr,
+						      &parse_attr->mod_hdr_acts,
+						      act, extack);
 			if (err)
 				return err;
 
-- 
2.33.0



