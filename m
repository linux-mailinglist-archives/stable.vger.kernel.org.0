Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA9F483339
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:35:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234548AbiACOfU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:35:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235092AbiACOck (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:32:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79DCFC07E5E7;
        Mon,  3 Jan 2022 06:31:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C4A861122;
        Mon,  3 Jan 2022 14:31:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0530EC36AEB;
        Mon,  3 Jan 2022 14:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220295;
        bh=gX3xaCYqn/o8ZWptSwV9PaL5uN/NK5MpPRXQRyd/Z1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cQm7USC6ViazyLhEsicsUtPXPpas9QPVuft/3FHNY8GA+ZsCHBBNik40xX4i6KAhm
         yfttNW8Hyd8cVN84OMW3z497u5WqFiEhlkn2oDVZ45nMs/2bjMFQFEp9t5V75r6MmH
         PRpGv0fW0u76sCUuORNTajXKSbJKTH3xXkQsQUcE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 24/73] net/mlx5e: Use tc sample stubs instead of ifdefs in source file
Date:   Mon,  3 Jan 2022 15:23:45 +0100
Message-Id: <20220103142057.692420083@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142056.911344037@linuxfoundation.org>
References: <20220103142056.911344037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

[ Upstream commit f3e02e479debb37777696c9f984f75152beeb56d ]

Instead of having sparse ifdefs in source files use a single
ifdef in the tc sample header file and use stubs.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/en/rep/tc.c   |  2 --
 .../mellanox/mlx5/core/en/tc/sample.h         | 27 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 12 ---------
 3 files changed, 27 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index de03684528bbf..8451940c16ab9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -647,9 +647,7 @@ static void mlx5e_restore_skb_sample(struct mlx5e_priv *priv, struct sk_buff *sk
 			   "Failed to restore tunnel info for sampled packet\n");
 		return;
 	}
-#if IS_ENABLED(CONFIG_MLX5_TC_SAMPLE)
 	mlx5e_tc_sample_skb(skb, mapped_obj);
-#endif /* CONFIG_MLX5_TC_SAMPLE */
 	mlx5_rep_tc_post_napi_receive(tc_priv);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.h
index db0146df9b303..9ef8a49d78014 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.h
@@ -19,6 +19,8 @@ struct mlx5e_sample_attr {
 	struct mlx5e_sample_flow *sample_flow;
 };
 
+#if IS_ENABLED(CONFIG_MLX5_TC_SAMPLE)
+
 void mlx5e_tc_sample_skb(struct sk_buff *skb, struct mlx5_mapped_obj *mapped_obj);
 
 struct mlx5_flow_handle *
@@ -38,4 +40,29 @@ mlx5e_tc_sample_init(struct mlx5_eswitch *esw, struct mlx5e_post_act *post_act);
 void
 mlx5e_tc_sample_cleanup(struct mlx5e_tc_psample *tc_psample);
 
+#else /* CONFIG_MLX5_TC_SAMPLE */
+
+static inline struct mlx5_flow_handle *
+mlx5e_tc_sample_offload(struct mlx5e_tc_psample *tc_psample,
+			struct mlx5_flow_spec *spec,
+			struct mlx5_flow_attr *attr,
+			u32 tunnel_id)
+{ return ERR_PTR(-EOPNOTSUPP); }
+
+static inline void
+mlx5e_tc_sample_unoffload(struct mlx5e_tc_psample *tc_psample,
+			  struct mlx5_flow_handle *rule,
+			  struct mlx5_flow_attr *attr) {}
+
+static inline struct mlx5e_tc_psample *
+mlx5e_tc_sample_init(struct mlx5_eswitch *esw, struct mlx5e_post_act *post_act)
+{ return ERR_PTR(-EOPNOTSUPP); }
+
+static inline void
+mlx5e_tc_sample_cleanup(struct mlx5e_tc_psample *tc_psample) {}
+
+static inline void
+mlx5e_tc_sample_skb(struct sk_buff *skb, struct mlx5_mapped_obj *mapped_obj) {}
+
+#endif /* CONFIG_MLX5_TC_SAMPLE */
 #endif /* __MLX5_EN_TC_SAMPLE_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index e3b320b6d85b9..e7736421d1bc2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -248,7 +248,6 @@ get_ct_priv(struct mlx5e_priv *priv)
 	return priv->fs.tc.ct;
 }
 
-#if IS_ENABLED(CONFIG_MLX5_TC_SAMPLE)
 static struct mlx5e_tc_psample *
 get_sample_priv(struct mlx5e_priv *priv)
 {
@@ -265,7 +264,6 @@ get_sample_priv(struct mlx5e_priv *priv)
 
 	return NULL;
 }
-#endif
 
 struct mlx5_flow_handle *
 mlx5_tc_rule_insert(struct mlx5e_priv *priv,
@@ -1148,11 +1146,9 @@ mlx5e_tc_offload_fdb_rules(struct mlx5_eswitch *esw,
 		rule = mlx5_tc_ct_flow_offload(get_ct_priv(flow->priv),
 					       flow, spec, attr,
 					       mod_hdr_acts);
-#if IS_ENABLED(CONFIG_MLX5_TC_SAMPLE)
 	} else if (flow_flag_test(flow, SAMPLE)) {
 		rule = mlx5e_tc_sample_offload(get_sample_priv(flow->priv), spec, attr,
 					       mlx5e_tc_get_flow_tun_id(flow));
-#endif
 	} else {
 		rule = mlx5_eswitch_add_offloaded_rule(esw, spec, attr);
 	}
@@ -1188,12 +1184,10 @@ void mlx5e_tc_unoffload_fdb_rules(struct mlx5_eswitch *esw,
 		return;
 	}
 
-#if IS_ENABLED(CONFIG_MLX5_TC_SAMPLE)
 	if (flow_flag_test(flow, SAMPLE)) {
 		mlx5e_tc_sample_unoffload(get_sample_priv(flow->priv), flow->rule[0], attr);
 		return;
 	}
-#endif
 
 	if (attr->esw_attr->split_count)
 		mlx5_eswitch_del_fwd_rule(esw, flow->rule[1], attr);
@@ -5014,9 +5008,7 @@ int mlx5e_tc_esw_init(struct rhashtable *tc_ht)
 					       MLX5_FLOW_NAMESPACE_FDB,
 					       uplink_priv->post_act);
 
-#if IS_ENABLED(CONFIG_MLX5_TC_SAMPLE)
 	uplink_priv->tc_psample = mlx5e_tc_sample_init(esw, uplink_priv->post_act);
-#endif
 
 	mapping_id = mlx5_query_nic_system_image_guid(esw->dev);
 
@@ -5060,9 +5052,7 @@ err_ht_init:
 err_enc_opts_mapping:
 	mapping_destroy(uplink_priv->tunnel_mapping);
 err_tun_mapping:
-#if IS_ENABLED(CONFIG_MLX5_TC_SAMPLE)
 	mlx5e_tc_sample_cleanup(uplink_priv->tc_psample);
-#endif
 	mlx5_tc_ct_clean(uplink_priv->ct_priv);
 	netdev_warn(priv->netdev,
 		    "Failed to initialize tc (eswitch), err: %d", err);
@@ -5082,9 +5072,7 @@ void mlx5e_tc_esw_cleanup(struct rhashtable *tc_ht)
 	mapping_destroy(uplink_priv->tunnel_enc_opts_mapping);
 	mapping_destroy(uplink_priv->tunnel_mapping);
 
-#if IS_ENABLED(CONFIG_MLX5_TC_SAMPLE)
 	mlx5e_tc_sample_cleanup(uplink_priv->tc_psample);
-#endif
 	mlx5_tc_ct_clean(uplink_priv->ct_priv);
 	mlx5e_tc_post_act_destroy(uplink_priv->post_act);
 }
-- 
2.34.1



