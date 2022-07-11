Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DEEB56FCCC
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233680AbiGKJsU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:48:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbiGKJrs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:47:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C555C120;
        Mon, 11 Jul 2022 02:23:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17C6361358;
        Mon, 11 Jul 2022 09:23:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A373C34115;
        Mon, 11 Jul 2022 09:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531396;
        bh=KbkTQXL5JZro2qDPXqOXRQfUSjE8Y1CE+IAeO7NGlx8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yqaJTmvD/yhLGadE7GxM5G5quOpr1Y5m2wLQXAwAlqaZoS4cs2qzIpBjm0K3epxRL
         RSr/N0l/1aD989ewtsLBZCIj+BCcWnPq3eU9zDHd7zkwwYTnCfnqCBNPsFwcFT4von
         wy2aAGMiMSTUkICSvrX873BeCXJR5lIlfibVwDEY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 050/230] net/mlx5e: Split actions_match_supported() into a sub function
Date:   Mon, 11 Jul 2022 11:05:06 +0200
Message-Id: <20220711090605.501082979@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Roi Dayan <roid@nvidia.com>

[ Upstream commit 9c1d3511a2c2fd30c991a20c670991ece4ef27c1 ]

There will probably be more checks, some for nic flows, some for fdb
flows and some are shared checks. Split it for fdb and nic to avoid
the function getting too big.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 65 +++++++++++--------
 1 file changed, 39 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index fe52db591121..3c6c7801f131 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3291,19 +3291,41 @@ static bool modify_header_match_supported(struct mlx5e_priv *priv,
 	return true;
 }
 
-static bool actions_match_supported(struct mlx5e_priv *priv,
-				    struct flow_action *flow_action,
-				    struct mlx5e_tc_flow_parse_attr *parse_attr,
-				    struct mlx5e_tc_flow *flow,
-				    struct netlink_ext_ack *extack)
+static bool
+actions_match_supported_fdb(struct mlx5e_priv *priv,
+			    struct mlx5e_tc_flow_parse_attr *parse_attr,
+			    struct mlx5e_tc_flow *flow,
+			    struct netlink_ext_ack *extack)
+{
+	bool ct_flow, ct_clear;
+
+	ct_clear = flow->attr->ct_attr.ct_action & TCA_CT_ACT_CLEAR;
+	ct_flow = flow_flag_test(flow, CT) && !ct_clear;
+
+	if (flow->attr->esw_attr->split_count && ct_flow &&
+	    !MLX5_CAP_GEN(flow->attr->esw_attr->in_mdev, reg_c_preserve)) {
+		/* All registers used by ct are cleared when using
+		 * split rules.
+		 */
+		NL_SET_ERR_MSG_MOD(extack, "Can't offload mirroring with action ct");
+		return false;
+	}
+
+	return true;
+}
+
+static bool
+actions_match_supported(struct mlx5e_priv *priv,
+			struct flow_action *flow_action,
+			struct mlx5e_tc_flow_parse_attr *parse_attr,
+			struct mlx5e_tc_flow *flow,
+			struct netlink_ext_ack *extack)
 {
-	bool ct_flow = false, ct_clear = false;
-	u32 actions;
+	u32 actions = flow->attr->action;
+	bool ct_flow, ct_clear;
 
-	ct_clear = flow->attr->ct_attr.ct_action &
-		TCA_CT_ACT_CLEAR;
+	ct_clear = flow->attr->ct_attr.ct_action & TCA_CT_ACT_CLEAR;
 	ct_flow = flow_flag_test(flow, CT) && !ct_clear;
-	actions = flow->attr->action;
 
 	if (!(actions &
 	      (MLX5_FLOW_CONTEXT_ACTION_FWD_DEST | MLX5_FLOW_CONTEXT_ACTION_DROP))) {
@@ -3311,23 +3333,14 @@ static bool actions_match_supported(struct mlx5e_priv *priv,
 		return false;
 	}
 
-	if (mlx5e_is_eswitch_flow(flow)) {
-		if (flow->attr->esw_attr->split_count && ct_flow &&
-		    !MLX5_CAP_GEN(flow->attr->esw_attr->in_mdev, reg_c_preserve)) {
-			/* All registers used by ct are cleared when using
-			 * split rules.
-			 */
-			NL_SET_ERR_MSG_MOD(extack,
-					   "Can't offload mirroring with action ct");
-			return false;
-		}
-	}
+	if (actions & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR &&
+	    !modify_header_match_supported(priv, &parse_attr->spec, flow_action,
+					   actions, ct_flow, ct_clear, extack))
+		return false;
 
-	if (actions & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)
-		return modify_header_match_supported(priv, &parse_attr->spec,
-						     flow_action, actions,
-						     ct_flow, ct_clear,
-						     extack);
+	if (mlx5e_is_eswitch_flow(flow) &&
+	    !actions_match_supported_fdb(priv, parse_attr, flow, extack))
+		return false;
 
 	return true;
 }
-- 
2.35.1



