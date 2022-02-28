Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCDC4C7699
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 19:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237508AbiB1SF0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 13:05:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240103AbiB1SDA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 13:03:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0257A9EB86;
        Mon, 28 Feb 2022 09:46:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3018EB815C6;
        Mon, 28 Feb 2022 17:46:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 841A1C340E7;
        Mon, 28 Feb 2022 17:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070390;
        bh=4/K4hcJ50ZxrCiXgGYxIfW5rgGGr5TwgGlun6hSng1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ihs7RvjSyep93ekE2+DBYzu3vmbiPyYqWRPrSxruaen5DOB08xf/jWr7oltJAQxcW
         FiVVUyG1gZ2qNpaCV5SQaAIFmRYX4akjfmrG/UUY2/PurQsQtCilVjNY9og20F9eof
         QtZ+jI/iKhd7V6RsF9t66rgM5qPadR9korbPbB7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.16 090/164] net/mlx5: DR, Dont allow match on IP w/o matching on full ethertype/ip_version
Date:   Mon, 28 Feb 2022 18:24:12 +0100
Message-Id: <20220228172408.008341104@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

commit ffb0753b954763d94f52c901adfe58ed0d4005e6 upstream.

Currently SMFS allows adding rule with matching on src/dst IP w/o matching
on full ethertype or ip_version, which is not supported by HW.
This patch fixes this issue and adds the check as it is done in DMFS.

Fixes: 26d688e33f88 ("net/mlx5: DR, Add Steering entry (STE) utilities")
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c |   20 +-----
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c     |   32 +++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h   |   10 +++
 3 files changed, 45 insertions(+), 17 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
@@ -13,18 +13,6 @@ static bool dr_mask_is_dmac_set(struct m
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
@@ -480,11 +468,11 @@ static int dr_matcher_set_ste_builders(s
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
 
@@ -580,11 +568,11 @@ static int dr_matcher_set_ste_builders(s
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
 
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -602,12 +602,34 @@ int mlx5dr_ste_set_action_decap_l3_list(
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
@@ -621,6 +643,14 @@ int mlx5dr_ste_build_pre_check(struct ml
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
 
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -739,6 +739,16 @@ struct mlx5dr_match_param {
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


