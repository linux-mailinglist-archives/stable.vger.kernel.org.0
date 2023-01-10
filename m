Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3938866485C
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238914AbjAJSLQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:11:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238949AbjAJSKR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:10:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD01B200E
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:08:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3DF8D6186E
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:08:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5109DC433EF;
        Tue, 10 Jan 2023 18:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374112;
        bh=M2+raMIVrjpqAgnjFM8PMQbbtgP1F2s+Hk1RreFBXTE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ySgHatSCoCfNI9Nh/q7T+EC7ivjBG1pF2RDs7SfSMDruNoH71nvF6JnKcb/inlnfj
         q+cDex0IeZSAOUBuTmOx8vJ++FBcTLJ/JPJD28aDcQURnjP9uDG3KWhCw8xqvEB4Rm
         cG4WQXMuI4iW2Rk8ZXR3/ZReNZG+qWf7UJ2ccXgI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Moshe Shemesh <moshe@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 050/148] net/mlx5: E-Switch, properly handle ingress tagged packets on VST
Date:   Tue, 10 Jan 2023 19:02:34 +0100
Message-Id: <20230110180018.806353759@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Moshe Shemesh <moshe@nvidia.com>

[ Upstream commit 1f0ae22ab470946143485a02cc1cd7e05c0f9120 ]

Fix SRIOV VST mode behavior to insert cvlan when a guest tag is already
present in the frame. Previous VST mode behavior was to drop packets or
override existing tag, depending on the device version.

In this patch we fix this behavior by correctly building the HW steering
rule with a push vlan action, or for older devices we ask the FW to stack
the vlan when a vlan is already present.

Fixes: 07bab9502641 ("net/mlx5: E-Switch, Refactor eswitch ingress acl codes")
Fixes: dfcb1ed3c331 ("net/mlx5: E-Switch, Vport ingress/egress ACLs rules for VST mode")
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/esw/acl/egress_lgcy.c  |  7 +++-
 .../mellanox/mlx5/core/esw/acl/ingress_lgcy.c | 33 ++++++++++++++++---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 30 ++++++++++++-----
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  6 ++++
 include/linux/mlx5/device.h                   |  5 +++
 include/linux/mlx5/mlx5_ifc.h                 |  3 +-
 6 files changed, 68 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c
index 60a73990017c..6b4c9ffad95b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c
@@ -67,6 +67,7 @@ static void esw_acl_egress_lgcy_groups_destroy(struct mlx5_vport *vport)
 int esw_acl_egress_lgcy_setup(struct mlx5_eswitch *esw,
 			      struct mlx5_vport *vport)
 {
+	bool vst_mode_steering = esw_vst_mode_is_steering(esw);
 	struct mlx5_flow_destination drop_ctr_dst = {};
 	struct mlx5_flow_destination *dst = NULL;
 	struct mlx5_fc *drop_counter = NULL;
@@ -77,6 +78,7 @@ int esw_acl_egress_lgcy_setup(struct mlx5_eswitch *esw,
 	 */
 	int table_size = 2;
 	int dest_num = 0;
+	int actions_flag;
 	int err = 0;
 
 	if (vport->egress.legacy.drop_counter) {
@@ -119,8 +121,11 @@ int esw_acl_egress_lgcy_setup(struct mlx5_eswitch *esw,
 		  vport->vport, vport->info.vlan, vport->info.qos);
 
 	/* Allowed vlan rule */
+	actions_flag = MLX5_FLOW_CONTEXT_ACTION_ALLOW;
+	if (vst_mode_steering)
+		actions_flag |= MLX5_FLOW_CONTEXT_ACTION_VLAN_POP;
 	err = esw_egress_acl_vlan_create(esw, vport, NULL, vport->info.vlan,
-					 MLX5_FLOW_CONTEXT_ACTION_ALLOW);
+					 actions_flag);
 	if (err)
 		goto out;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c
index b1a5199260f6..093ed86a0acd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c
@@ -139,11 +139,14 @@ static void esw_acl_ingress_lgcy_groups_destroy(struct mlx5_vport *vport)
 int esw_acl_ingress_lgcy_setup(struct mlx5_eswitch *esw,
 			       struct mlx5_vport *vport)
 {
+	bool vst_mode_steering = esw_vst_mode_is_steering(esw);
 	struct mlx5_flow_destination drop_ctr_dst = {};
 	struct mlx5_flow_destination *dst = NULL;
 	struct mlx5_flow_act flow_act = {};
 	struct mlx5_flow_spec *spec = NULL;
 	struct mlx5_fc *counter = NULL;
+	bool vst_check_cvlan = false;
+	bool vst_push_cvlan = false;
 	/* The ingress acl table contains 4 groups
 	 * (2 active rules at the same time -
 	 *      1 allow rule from one of the first 3 groups.
@@ -203,7 +206,26 @@ int esw_acl_ingress_lgcy_setup(struct mlx5_eswitch *esw,
 		goto out;
 	}
 
-	if (vport->info.vlan || vport->info.qos)
+	if ((vport->info.vlan || vport->info.qos)) {
+		if (vst_mode_steering)
+			vst_push_cvlan = true;
+		else if (!MLX5_CAP_ESW(esw->dev, vport_cvlan_insert_always))
+			vst_check_cvlan = true;
+	}
+
+	if (vst_check_cvlan || vport->info.spoofchk)
+		spec->match_criteria_enable = MLX5_MATCH_OUTER_HEADERS;
+
+	/* Create ingress allow rule */
+	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_ALLOW;
+	if (vst_push_cvlan) {
+		flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH;
+		flow_act.vlan[0].prio = vport->info.qos;
+		flow_act.vlan[0].vid = vport->info.vlan;
+		flow_act.vlan[0].ethtype = ETH_P_8021Q;
+	}
+
+	if (vst_check_cvlan)
 		MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria,
 				 outer_headers.cvlan_tag);
 
@@ -218,9 +240,6 @@ int esw_acl_ingress_lgcy_setup(struct mlx5_eswitch *esw,
 		ether_addr_copy(smac_v, vport->info.mac);
 	}
 
-	/* Create ingress allow rule */
-	spec->match_criteria_enable = MLX5_MATCH_OUTER_HEADERS;
-	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_ALLOW;
 	vport->ingress.allow_rule = mlx5_add_flow_rules(vport->ingress.acl, spec,
 							&flow_act, NULL, 0);
 	if (IS_ERR(vport->ingress.allow_rule)) {
@@ -232,6 +251,9 @@ int esw_acl_ingress_lgcy_setup(struct mlx5_eswitch *esw,
 		goto out;
 	}
 
+	if (!vst_check_cvlan && !vport->info.spoofchk)
+		goto out;
+
 	memset(&flow_act, 0, sizeof(flow_act));
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_DROP;
 	/* Attach drop flow counter */
@@ -257,7 +279,8 @@ int esw_acl_ingress_lgcy_setup(struct mlx5_eswitch *esw,
 	return 0;
 
 out:
-	esw_acl_ingress_lgcy_cleanup(esw, vport);
+	if (err)
+		esw_acl_ingress_lgcy_cleanup(esw, vport);
 	kvfree(spec);
 	return err;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 59cffa49e4b5..940e893f3f09 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -161,10 +161,17 @@ static int modify_esw_vport_cvlan(struct mlx5_core_dev *dev, u16 vport,
 			 esw_vport_context.vport_cvlan_strip, 1);
 
 	if (set_flags & SET_VLAN_INSERT) {
-		/* insert only if no vlan in packet */
-		MLX5_SET(modify_esw_vport_context_in, in,
-			 esw_vport_context.vport_cvlan_insert, 1);
-
+		if (MLX5_CAP_ESW(dev, vport_cvlan_insert_always)) {
+			/* insert either if vlan exist in packet or not */
+			MLX5_SET(modify_esw_vport_context_in, in,
+				 esw_vport_context.vport_cvlan_insert,
+				 MLX5_VPORT_CVLAN_INSERT_ALWAYS);
+		} else {
+			/* insert only if no vlan in packet */
+			MLX5_SET(modify_esw_vport_context_in, in,
+				 esw_vport_context.vport_cvlan_insert,
+				 MLX5_VPORT_CVLAN_INSERT_WHEN_NO_CVLAN);
+		}
 		MLX5_SET(modify_esw_vport_context_in, in,
 			 esw_vport_context.cvlan_pcp, qos);
 		MLX5_SET(modify_esw_vport_context_in, in,
@@ -774,6 +781,7 @@ static void esw_vport_cleanup_acl(struct mlx5_eswitch *esw,
 
 static int esw_vport_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vport)
 {
+	bool vst_mode_steering = esw_vst_mode_is_steering(esw);
 	u16 vport_num = vport->vport;
 	int flags;
 	int err;
@@ -800,8 +808,9 @@ static int esw_vport_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vport)
 
 	flags = (vport->info.vlan || vport->info.qos) ?
 		SET_VLAN_STRIP | SET_VLAN_INSERT : 0;
-	modify_esw_vport_cvlan(esw->dev, vport_num, vport->info.vlan,
-			       vport->info.qos, flags);
+	if (esw->mode == MLX5_ESWITCH_OFFLOADS || !vst_mode_steering)
+		modify_esw_vport_cvlan(esw->dev, vport_num, vport->info.vlan,
+				       vport->info.qos, flags);
 
 	return 0;
 }
@@ -1806,6 +1815,7 @@ int __mlx5_eswitch_set_vport_vlan(struct mlx5_eswitch *esw,
 				  u16 vport, u16 vlan, u8 qos, u8 set_flags)
 {
 	struct mlx5_vport *evport = mlx5_eswitch_get_vport(esw, vport);
+	bool vst_mode_steering = esw_vst_mode_is_steering(esw);
 	int err = 0;
 
 	if (IS_ERR(evport))
@@ -1813,9 +1823,11 @@ int __mlx5_eswitch_set_vport_vlan(struct mlx5_eswitch *esw,
 	if (vlan > 4095 || qos > 7)
 		return -EINVAL;
 
-	err = modify_esw_vport_cvlan(esw->dev, vport, vlan, qos, set_flags);
-	if (err)
-		return err;
+	if (esw->mode == MLX5_ESWITCH_OFFLOADS || !vst_mode_steering) {
+		err = modify_esw_vport_cvlan(esw->dev, vport, vlan, qos, set_flags);
+		if (err)
+			return err;
+	}
 
 	evport->info.vlan = vlan;
 	evport->info.qos = qos;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 5ceed4e6c658..03080e8161cb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -513,6 +513,12 @@ int mlx5_eswitch_del_vlan_action(struct mlx5_eswitch *esw,
 int __mlx5_eswitch_set_vport_vlan(struct mlx5_eswitch *esw,
 				  u16 vport, u16 vlan, u8 qos, u8 set_flags);
 
+static inline bool esw_vst_mode_is_steering(struct mlx5_eswitch *esw)
+{
+	return (MLX5_CAP_ESW_EGRESS_ACL(esw->dev, pop_vlan) &&
+		MLX5_CAP_ESW_INGRESS_ACL(esw->dev, push_vlan));
+}
+
 static inline bool mlx5_eswitch_vlan_actions_supported(struct mlx5_core_dev *dev,
 						       u8 vlan_depth)
 {
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index b5f58fd37a0f..4b00221f57e2 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -1088,6 +1088,11 @@ enum {
 	MLX5_VPORT_ADMIN_STATE_AUTO  = 0x2,
 };
 
+enum {
+	MLX5_VPORT_CVLAN_INSERT_WHEN_NO_CVLAN  = 0x1,
+	MLX5_VPORT_CVLAN_INSERT_ALWAYS         = 0x3,
+};
+
 enum {
 	MLX5_L3_PROT_TYPE_IPV4		= 0,
 	MLX5_L3_PROT_TYPE_IPV6		= 1,
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 4acd5610e96b..e640c27b1b6d 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -877,7 +877,8 @@ struct mlx5_ifc_e_switch_cap_bits {
 	u8         vport_svlan_insert[0x1];
 	u8         vport_cvlan_insert_if_not_exist[0x1];
 	u8         vport_cvlan_insert_overwrite[0x1];
-	u8         reserved_at_5[0x2];
+	u8         reserved_at_5[0x1];
+	u8         vport_cvlan_insert_always[0x1];
 	u8         esw_shared_ingress_acl[0x1];
 	u8         esw_uplink_ingress_acl[0x1];
 	u8         root_ft_on_other_esw[0x1];
-- 
2.35.1



