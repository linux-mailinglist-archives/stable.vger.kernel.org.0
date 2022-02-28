Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAA6E4C7698
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 19:04:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235400AbiB1SFS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 13:05:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240259AbiB1SDU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 13:03:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79E0CB18B3;
        Mon, 28 Feb 2022 09:46:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5611B6091F;
        Mon, 28 Feb 2022 17:46:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69D0AC340E7;
        Mon, 28 Feb 2022 17:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070401;
        bh=qbmjpcWNVj53TVhbOFEs/inJ8zdkb3L0ffvYVAtsvbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AMpbli+lpey/sJSbwIazSbW0RiEIPcmABD7csSfu38o7TgvSVAPXTL4aUuP2wCOtP
         dmGXCNtQKVImhp78Ceq4juxCNO+b3dmMRFBGfO8ozsOn1T5efryt/bxLpXBl2kJ9OS
         6PHDPnlh+X+T6yjxmZhw2zB77jEKx9yN5co8BO3M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Dickman <maord@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.16 094/164] net/mlx5e: MPLSoUDP decap, fix check for unsupported matches
Date:   Mon, 28 Feb 2022 18:24:16 +0100
Message-Id: <20220228172408.318773563@linuxfoundation.org>
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

From: Maor Dickman <maord@nvidia.com>

commit fdc18e4e4bded2a08638cdcd22dc087a64b9ddad upstream.

Currently offload of rule on bareudp device require tunnel key
in order to match on mpls fields and without it the mpls fields
are ignored, this is incorrect due to the fact udp tunnel doesn't
have key to match on.

Fix by returning error in case flow is matching on tunnel key.

Fixes: 72046a91d134 ("net/mlx5e: Allow to match on mpls parameters")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_mplsoudp.c |   28 ++++-------
 1 file changed, 11 insertions(+), 17 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_mplsoudp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_mplsoudp.c
@@ -60,37 +60,31 @@ static int parse_tunnel(struct mlx5e_pri
 			void *headers_v)
 {
 	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
-	struct flow_match_enc_keyid enc_keyid;
 	struct flow_match_mpls match;
 	void *misc2_c;
 	void *misc2_v;
 
-	misc2_c = MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
-			       misc_parameters_2);
-	misc2_v = MLX5_ADDR_OF(fte_match_param, spec->match_value,
-			       misc_parameters_2);
-
-	if (!flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_MPLS))
-		return 0;
-
-	if (!flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_KEYID))
-		return 0;
-
-	flow_rule_match_enc_keyid(rule, &enc_keyid);
-
-	if (!enc_keyid.mask->keyid)
-		return 0;
-
 	if (!MLX5_CAP_ETH(priv->mdev, tunnel_stateless_mpls_over_udp) &&
 	    !(MLX5_CAP_GEN(priv->mdev, flex_parser_protocols) & MLX5_FLEX_PROTO_CW_MPLS_UDP))
 		return -EOPNOTSUPP;
 
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_KEYID))
+		return -EOPNOTSUPP;
+
+	if (!flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_MPLS))
+		return 0;
+
 	flow_rule_match_mpls(rule, &match);
 
 	/* Only support matching the first LSE */
 	if (match.mask->used_lses != 1)
 		return -EOPNOTSUPP;
 
+	misc2_c = MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
+			       misc_parameters_2);
+	misc2_v = MLX5_ADDR_OF(fte_match_param, spec->match_value,
+			       misc_parameters_2);
+
 	MLX5_SET(fte_match_set_misc2, misc2_c,
 		 outer_first_mpls_over_udp.mpls_label,
 		 match.mask->ls[0].mpls_label);


