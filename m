Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4214C49C5
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 16:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242419AbiBYP43 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 10:56:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241307AbiBYP43 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 10:56:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CDD31D8326
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 07:55:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA38C61A55
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 15:55:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD177C340F0;
        Fri, 25 Feb 2022 15:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645804556;
        bh=feOAWUfvuuZWabC+Il6CqbklQUzSuP2xewsNfMQ3V0A=;
        h=Subject:To:Cc:From:Date:From;
        b=hkhmb8s+TmRwuvhxBlsqgkoSnO48eeKEU+f+7Q7+KUTPW/k69PaeTHOuhTOluwUEP
         Lx3rhtKuxp7LOE60LwE5QXayjvjR7yN9b9OpcNMxNoiIv9GvPjvGfubPNNf3IyBlu3
         4mw9g/mXAn7Jl8NoyGbN1uDwOLbWeMZoN+uO4DGw=
Subject: FAILED: patch "[PATCH] net/mlx5: DR, Don't allow match on IP w/o matching on full" failed to apply to 5.4-stable tree
To:     kliteyn@nvidia.com, saeedm@nvidia.com, valex@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 25 Feb 2022 16:55:46 +0100
Message-ID: <16458045462501@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ffb0753b954763d94f52c901adfe58ed0d4005e6 Mon Sep 17 00:00:00 2001
From: Yevgeny Kliteynik <kliteyn@nvidia.com>
Date: Thu, 13 Jan 2022 14:52:48 +0200
Subject: [PATCH] net/mlx5: DR, Don't allow match on IP w/o matching on full
 ethertype/ip_version

Currently SMFS allows adding rule with matching on src/dst IP w/o matching
on full ethertype or ip_version, which is not supported by HW.
This patch fixes this issue and adds the check as it is done in DMFS.

Fixes: 26d688e33f88 ("net/mlx5: DR, Add Steering entry (STE) utilities")
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
index e87cf498c77b..38971fe1dfe1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
@@ -13,18 +13,6 @@ static bool dr_mask_is_dmac_set(struct mlx5dr_match_spec *spec)
 	return (spec->dmac_47_16 || spec->dmac_15_0);
 }
 
-static bool dr_mask_is_src_addr_set(struct mlx5dr_match_spec *spec)
-{
-	return (spec->src_ip_127_96 || spec->src_ip_95_64 ||
-		spec->src_ip_63_32 || spec->src_ip_31_0);
-}
-
-static bool dr_mask_is_dst_addr_set(struct mlx5dr_match_spec *spec)
-{
-	return (spec->dst_ip_127_96 || spec->dst_ip_95_64 ||
-		spec->dst_ip_63_32 || spec->dst_ip_31_0);
-}
-
 static bool dr_mask_is_l3_base_set(struct mlx5dr_match_spec *spec)
 {
 	return (spec->ip_protocol || spec->frag || spec->tcp_flags ||
@@ -503,11 +491,11 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_matcher *matcher,
 						    &mask, inner, rx);
 
 		if (outer_ipv == DR_RULE_IPV6) {
-			if (dr_mask_is_dst_addr_set(&mask.outer))
+			if (DR_MASK_IS_DST_IP_SET(&mask.outer))
 				mlx5dr_ste_build_eth_l3_ipv6_dst(ste_ctx, &sb[idx++],
 								 &mask, inner, rx);
 
-			if (dr_mask_is_src_addr_set(&mask.outer))
+			if (DR_MASK_IS_SRC_IP_SET(&mask.outer))
 				mlx5dr_ste_build_eth_l3_ipv6_src(ste_ctx, &sb[idx++],
 								 &mask, inner, rx);
 
@@ -610,11 +598,11 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_matcher *matcher,
 						    &mask, inner, rx);
 
 		if (inner_ipv == DR_RULE_IPV6) {
-			if (dr_mask_is_dst_addr_set(&mask.inner))
+			if (DR_MASK_IS_DST_IP_SET(&mask.inner))
 				mlx5dr_ste_build_eth_l3_ipv6_dst(ste_ctx, &sb[idx++],
 								 &mask, inner, rx);
 
-			if (dr_mask_is_src_addr_set(&mask.inner))
+			if (DR_MASK_IS_SRC_IP_SET(&mask.inner))
 				mlx5dr_ste_build_eth_l3_ipv6_src(ste_ctx, &sb[idx++],
 								 &mask, inner, rx);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index 7e61742e58a0..187e29b409b6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -602,12 +602,34 @@ int mlx5dr_ste_set_action_decap_l3_list(struct mlx5dr_ste_ctx *ste_ctx,
 						 used_hw_action_num);
 }
 
+static int dr_ste_build_pre_check_spec(struct mlx5dr_domain *dmn,
+				       struct mlx5dr_match_spec *spec)
+{
+	if (spec->ip_version) {
+		if (spec->ip_version != 0xf) {
+			mlx5dr_err(dmn,
+				   "Partial ip_version mask with src/dst IP is not supported\n");
+			return -EINVAL;
+		}
+	} else if (spec->ethertype != 0xffff &&
+		   (DR_MASK_IS_SRC_IP_SET(spec) || DR_MASK_IS_DST_IP_SET(spec))) {
+		mlx5dr_err(dmn,
+			   "Partial/no ethertype mask with src/dst IP is not supported\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 int mlx5dr_ste_build_pre_check(struct mlx5dr_domain *dmn,
 			       u8 match_criteria,
 			       struct mlx5dr_match_param *mask,
 			       struct mlx5dr_match_param *value)
 {
-	if (!value && (match_criteria & DR_MATCHER_CRITERIA_MISC)) {
+	if (value)
+		return 0;
+
+	if (match_criteria & DR_MATCHER_CRITERIA_MISC) {
 		if (mask->misc.source_port && mask->misc.source_port != 0xffff) {
 			mlx5dr_err(dmn,
 				   "Partial mask source_port is not supported\n");
@@ -621,6 +643,14 @@ int mlx5dr_ste_build_pre_check(struct mlx5dr_domain *dmn,
 		}
 	}
 
+	if ((match_criteria & DR_MATCHER_CRITERIA_OUTER) &&
+	    dr_ste_build_pre_check_spec(dmn, &mask->outer))
+		return -EINVAL;
+
+	if ((match_criteria & DR_MATCHER_CRITERIA_INNER) &&
+	    dr_ste_build_pre_check_spec(dmn, &mask->inner))
+		return -EINVAL;
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 1b3d484b99be..55fcb751e24a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -798,6 +798,16 @@ struct mlx5dr_match_param {
 				       (_misc3)->icmpv4_code || \
 				       (_misc3)->icmpv4_header_data)
 
+#define DR_MASK_IS_SRC_IP_SET(_spec) ((_spec)->src_ip_127_96 || \
+				      (_spec)->src_ip_95_64  || \
+				      (_spec)->src_ip_63_32  || \
+				      (_spec)->src_ip_31_0)
+
+#define DR_MASK_IS_DST_IP_SET(_spec) ((_spec)->dst_ip_127_96 || \
+				      (_spec)->dst_ip_95_64  || \
+				      (_spec)->dst_ip_63_32  || \
+				      (_spec)->dst_ip_31_0)
+
 struct mlx5dr_esw_caps {
 	u64 drop_icm_address_rx;
 	u64 drop_icm_address_tx;

