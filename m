Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39EE9499ACD
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1573824AbiAXVqn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:46:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1456710AbiAXVjy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:39:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94BEDC0419CC;
        Mon, 24 Jan 2022 12:26:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D7DDB8122D;
        Mon, 24 Jan 2022 20:26:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BF1EC340E5;
        Mon, 24 Jan 2022 20:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056013;
        bh=4haL6oDVAPDRc3BlcbHAnynOlZ6DvAuECFWdkVDMhWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MFQyJqF/60NNqhiOCokGhjlBtTA7euyv03RIPbXbpQb3ejLS2PPufMA+DweJytTs/
         J+kMG7Cxtb+DwjWucHiZOfDRGh/5P5YtLoGGc+0DGQ+3Psiw5LuJlc8pu+BZtJGf2R
         ji6RKkYIwLu28AxeplgoqW5/UKufIf1eHnBM4Kwc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Blakey <paulb@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Eli Cohen <elic@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 342/846] net/mlx5e: Fix matching on modified inner ip_ecn bits
Date:   Mon, 24 Jan 2022 19:37:39 +0100
Message-Id: <20220124184112.719498088@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Blakey <paulb@nvidia.com>

[ Upstream commit b6dfff21a170af5c695ebaa153b7f5e297ddca03 ]

Tunnel device follows RFC 6040, and during decapsulation inner
ip_ecn might change depending on inner and outer ip_ecn as follows:

 +---------+----------------------------------------+
 |Arriving |         Arriving Outer Header          |
 |   Inner +---------+---------+---------+----------+
 |  Header | Not-ECT | ECT(0)  | ECT(1)  |   CE     |
 +---------+---------+---------+---------+----------+
 | Not-ECT | Not-ECT | Not-ECT | Not-ECT | <drop>   |
 |  ECT(0) |  ECT(0) | ECT(0)  | ECT(1)  |   CE*    |
 |  ECT(1) |  ECT(1) | ECT(1)  | ECT(1)* |   CE*    |
 |    CE   |   CE    |  CE     | CE      |   CE     |
 +---------+---------+---------+---------+----------+

Cells marked above are changed from original inner packet ip_ecn value.

Tc then matches on the modified inner ip_ecn, but hw offload which
matches the inner ip_ecn value before decap, will fail.

Fix that by mapping all the cases of outer and inner ip_ecn matching,
and only supporting cases where we know inner wouldn't be changed by
decap, or in the outer ip_ecn=CE case, inner ip_ecn didn't matter.

Fixes: bcef735c59f2 ("net/mlx5e: Offload TC matching on tos/ttl for ip tunnels")
Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Eli Cohen <elic@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 120 +++++++++++++++++-
 1 file changed, 116 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index fa461bc57baee..8b041deb25e5f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1874,6 +1874,111 @@ u8 mlx5e_tc_get_ip_version(struct mlx5_flow_spec *spec, bool outer)
 	return ip_version;
 }
 
+/* Tunnel device follows RFC 6040, see include/net/inet_ecn.h.
+ * And changes inner ip_ecn depending on inner and outer ip_ecn as follows:
+ *      +---------+----------------------------------------+
+ *      |Arriving |         Arriving Outer Header          |
+ *      |   Inner +---------+---------+---------+----------+
+ *      |  Header | Not-ECT | ECT(0)  | ECT(1)  |   CE     |
+ *      +---------+---------+---------+---------+----------+
+ *      | Not-ECT | Not-ECT | Not-ECT | Not-ECT | <drop>   |
+ *      |  ECT(0) |  ECT(0) | ECT(0)  | ECT(1)  |   CE*    |
+ *      |  ECT(1) |  ECT(1) | ECT(1)  | ECT(1)* |   CE*    |
+ *      |    CE   |   CE    |  CE     | CE      |   CE     |
+ *      +---------+---------+---------+---------+----------+
+ *
+ * Tc matches on inner after decapsulation on tunnel device, but hw offload matches
+ * the inner ip_ecn value before hardware decap action.
+ *
+ * Cells marked are changed from original inner packet ip_ecn value during decap, and
+ * so matching those values on inner ip_ecn before decap will fail.
+ *
+ * The following helper allows offload when inner ip_ecn won't be changed by outer ip_ecn,
+ * except for the outer ip_ecn = CE, where in all cases inner ip_ecn will be changed to CE,
+ * and such we can drop the inner ip_ecn=CE match.
+ */
+
+static int mlx5e_tc_verify_tunnel_ecn(struct mlx5e_priv *priv,
+				      struct flow_cls_offload *f,
+				      bool *match_inner_ecn)
+{
+	u8 outer_ecn_mask = 0, outer_ecn_key = 0, inner_ecn_mask = 0, inner_ecn_key = 0;
+	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
+	struct netlink_ext_ack *extack = f->common.extack;
+	struct flow_match_ip match;
+
+	*match_inner_ecn = true;
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_IP)) {
+		flow_rule_match_enc_ip(rule, &match);
+		outer_ecn_key = match.key->tos & INET_ECN_MASK;
+		outer_ecn_mask = match.mask->tos & INET_ECN_MASK;
+	}
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_IP)) {
+		flow_rule_match_ip(rule, &match);
+		inner_ecn_key = match.key->tos & INET_ECN_MASK;
+		inner_ecn_mask = match.mask->tos & INET_ECN_MASK;
+	}
+
+	if (outer_ecn_mask != 0 && outer_ecn_mask != INET_ECN_MASK) {
+		NL_SET_ERR_MSG_MOD(extack, "Partial match on enc_tos ecn bits isn't supported");
+		netdev_warn(priv->netdev, "Partial match on enc_tos ecn bits isn't supported");
+		return -EOPNOTSUPP;
+	}
+
+	if (!outer_ecn_mask) {
+		if (!inner_ecn_mask)
+			return 0;
+
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Matching on tos ecn bits without also matching enc_tos ecn bits isn't supported");
+		netdev_warn(priv->netdev,
+			    "Matching on tos ecn bits without also matching enc_tos ecn bits isn't supported");
+		return -EOPNOTSUPP;
+	}
+
+	if (inner_ecn_mask && inner_ecn_mask != INET_ECN_MASK) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Partial match on tos ecn bits with match on enc_tos ecn bits isn't supported");
+		netdev_warn(priv->netdev,
+			    "Partial match on tos ecn bits with match on enc_tos ecn bits isn't supported");
+		return -EOPNOTSUPP;
+	}
+
+	if (!inner_ecn_mask)
+		return 0;
+
+	/* Both inner and outer have full mask on ecn */
+
+	if (outer_ecn_key == INET_ECN_ECT_1) {
+		/* inner ecn might change by DECAP action */
+
+		NL_SET_ERR_MSG_MOD(extack, "Match on enc_tos ecn = ECT(1) isn't supported");
+		netdev_warn(priv->netdev, "Match on enc_tos ecn = ECT(1) isn't supported");
+		return -EOPNOTSUPP;
+	}
+
+	if (outer_ecn_key != INET_ECN_CE)
+		return 0;
+
+	if (inner_ecn_key != INET_ECN_CE) {
+		/* Can't happen in software, as packet ecn will be changed to CE after decap */
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Match on tos enc_tos ecn = CE while match on tos ecn != CE isn't supported");
+		netdev_warn(priv->netdev,
+			    "Match on tos enc_tos ecn = CE while match on tos ecn != CE isn't supported");
+		return -EOPNOTSUPP;
+	}
+
+	/* outer ecn = CE, inner ecn = CE, as decap will change inner ecn to CE in anycase,
+	 * drop match on inner ecn
+	 */
+	*match_inner_ecn = false;
+
+	return 0;
+}
+
 static int parse_tunnel_attr(struct mlx5e_priv *priv,
 			     struct mlx5e_tc_flow *flow,
 			     struct mlx5_flow_spec *spec,
@@ -2067,6 +2172,7 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
 	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
 	struct flow_dissector *dissector = rule->match.dissector;
 	enum fs_flow_table_type fs_type;
+	bool match_inner_ecn = true;
 	u16 addr_type = 0;
 	u8 ip_proto = 0;
 	u8 *match_level;
@@ -2120,6 +2226,10 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
 			headers_c = get_match_inner_headers_criteria(spec);
 			headers_v = get_match_inner_headers_value(spec);
 		}
+
+		err = mlx5e_tc_verify_tunnel_ecn(priv, f, &match_inner_ecn);
+		if (err)
+			return err;
 	}
 
 	err = mlx5e_flower_parse_meta(filter_dev, f);
@@ -2341,10 +2451,12 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
 		struct flow_match_ip match;
 
 		flow_rule_match_ip(rule, &match);
-		MLX5_SET(fte_match_set_lyr_2_4, headers_c, ip_ecn,
-			 match.mask->tos & 0x3);
-		MLX5_SET(fte_match_set_lyr_2_4, headers_v, ip_ecn,
-			 match.key->tos & 0x3);
+		if (match_inner_ecn) {
+			MLX5_SET(fte_match_set_lyr_2_4, headers_c, ip_ecn,
+				 match.mask->tos & 0x3);
+			MLX5_SET(fte_match_set_lyr_2_4, headers_v, ip_ecn,
+				 match.key->tos & 0x3);
+		}
 
 		MLX5_SET(fte_match_set_lyr_2_4, headers_c, ip_dscp,
 			 match.mask->tos >> 2);
-- 
2.34.1



