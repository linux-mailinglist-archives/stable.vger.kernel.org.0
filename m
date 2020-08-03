Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96ACA23A66F
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728137AbgHCMZL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:25:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:49666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726854AbgHCMZC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:25:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4EF23207BB;
        Mon,  3 Aug 2020 12:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457501;
        bh=O22S31kiiQfotZ8ILAuZ9hks77MoKMu0q1cay8LAfhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L2tWD/60p2qtgR18XKFfAbhtudReZ0ELqzc6sYx7gAps/dMkcTFzs+x32BVe2sWK4
         Y8rYXJbHYS0+WOaCvKn3Bx8mwf1zKY0CcfOaf3UueRrwE1+FdBj13tbpx/ErXJmVsh
         YHSmuOk7Z03JSGzpG48h1vDTFTbyFkFVo8n2LDIY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianbo Liu <jianbol@mellanox.com>,
        Chris Mi <chrism@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 090/120] net/mlx5e: E-Switch, Add misc bit when misc fields changed for mirroring
Date:   Mon,  3 Aug 2020 14:19:08 +0200
Message-Id: <20200803121907.289040406@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121902.860751811@linuxfoundation.org>
References: <20200803121902.860751811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jianbo Liu <jianbol@mellanox.com>

[ Upstream commit 0faddfe6b7953e224a1283f89f671ef6a9ba73de ]

The modified flow_context fields in FTE must be indicated in
modify_enable bitmask. Previously, the misc bit in modify_enable is
always set as source vport must be set for each rule. So, when parsing
vxlan/gre/geneve/qinq rules, this bit is not set because those are all
from the same misc fileds that source vport fields are located at, and
we don't need to set the indicator twice.

After adding per vport tables for mirroring, misc bit is not set, then
firmware syndrome happens. To fix it, set the bit wherever misc fileds
are changed. This also makes it unnecessary to check misc fields and set
the misc bit accordingly in metadata matching, so here remove it.

Besides, flow_source must be specified for uplink because firmware
will check it and some actions are only allowed for packets received
from uplink.

Fixes: 96e326878fa5 ("net/mlx5e: Eswitch, Use per vport tables for mirroring")
Signed-off-by: Jianbo Liu <jianbol@mellanox.com>
Reviewed-by: Chris Mi <chrism@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c | 2 ++
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_gre.c    | 2 ++
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c  | 2 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c            | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 6 +++---
 5 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c
index 951ea26d96bc3..e472ed0eacfbc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c
@@ -301,6 +301,8 @@ static int mlx5e_tc_tun_parse_geneve_params(struct mlx5e_priv *priv,
 		MLX5_SET(fte_match_set_misc, misc_v, geneve_protocol_type, ETH_P_TEB);
 	}
 
+	spec->match_criteria_enable |= MLX5_MATCH_MISC_PARAMETERS;
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_gre.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_gre.c
index 58b13192df239..2805416c32a3c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_gre.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_gre.c
@@ -80,6 +80,8 @@ static int mlx5e_tc_tun_parse_gretap(struct mlx5e_priv *priv,
 			 gre_key.key, be32_to_cpu(enc_keyid.key->keyid));
 	}
 
+	spec->match_criteria_enable |= MLX5_MATCH_MISC_PARAMETERS;
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
index 37b176801bccb..038a0f1cecec6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
@@ -136,6 +136,8 @@ static int mlx5e_tc_tun_parse_vxlan(struct mlx5e_priv *priv,
 	MLX5_SET(fte_match_set_misc, misc_v, vxlan_vni,
 		 be32_to_cpu(enc_keyid.key->keyid));
 
+	spec->match_criteria_enable |= MLX5_MATCH_MISC_PARAMETERS;
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 10f705761666b..c0f54d2d49258 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2256,6 +2256,7 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
 				 match.key->vlan_priority);
 
 			*match_level = MLX5_MATCH_L2;
+			spec->match_criteria_enable |= MLX5_MATCH_MISC_PARAMETERS;
 		}
 	}
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 5d9def18ae3a7..cfc52521d7753 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -264,9 +264,6 @@ mlx5_eswitch_set_rule_source_port(struct mlx5_eswitch *esw,
 			 mlx5_eswitch_get_vport_metadata_mask());
 
 		spec->match_criteria_enable |= MLX5_MATCH_MISC_PARAMETERS_2;
-		misc = MLX5_ADDR_OF(fte_match_param, spec->match_criteria, misc_parameters);
-		if (memchr_inv(misc, 0, MLX5_ST_SZ_BYTES(fte_match_set_misc)))
-			spec->match_criteria_enable |= MLX5_MATCH_MISC_PARAMETERS;
 	} else {
 		misc = MLX5_ADDR_OF(fte_match_param, spec->match_value, misc_parameters);
 		MLX5_SET(fte_match_set_misc, misc, source_port, attr->in_rep->vport);
@@ -381,6 +378,9 @@ mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *esw,
 		flow_act.modify_hdr = attr->modify_hdr;
 
 	if (split) {
+		if (MLX5_CAP_ESW_FLOWTABLE(esw->dev, flow_source) &&
+		    attr->in_rep->vport == MLX5_VPORT_UPLINK)
+			spec->flow_context.flow_source = MLX5_FLOW_CONTEXT_FLOW_SOURCE_UPLINK;
 		fdb = esw_vport_tbl_get(esw, attr);
 	} else {
 		if (attr->chain || attr->prio)
-- 
2.25.1



