Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F11335BE5C
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238370AbhDLI55 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:57:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:44464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237922AbhDLIz7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:55:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B514161262;
        Mon, 12 Apr 2021 08:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217742;
        bh=OqS2z4EB5RekVG7ur5oVmYd0PHjoWHZc1lGpG8aaokc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Et9uMjlcB9KuUBJMeRRuY0tsMl6yCeI8vJxVrUict4xDkDvijV1TWdng561g6BWSc
         vO4O/WxK2wbAdlsIa6HgoZc9mmU/y++TL1Dt/7a0Nqe8hPkDnUZP1Op0xgVAhAHZpr
         YAXhkFRlCviiCfxWf2Vb9vrt86Zq7wu41LC9YVLQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yinjun Zhang <yinjun.zhang@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@netronome.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 127/188] nfp: flower: ignore duplicate merge hints from FW
Date:   Mon, 12 Apr 2021 10:40:41 +0200
Message-Id: <20210412084017.869016798@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yinjun Zhang <yinjun.zhang@corigine.com>

[ Upstream commit 2ea538dbee1c79f6f6c24a6f2f82986e4b7ccb78 ]

A merge hint message needs some time to process before the merged
flow actually reaches the firmware, during which we may get duplicate
merge hints if there're more than one packet that hit the pre-merged
flow. And processing duplicate merge hints will cost extra host_ctx's
which are a limited resource.

Avoid the duplicate merge by using hash table to store the sub_flows
to be merged.

Fixes: 8af56f40e53b ("nfp: flower: offload merge flows")
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/netronome/nfp/flower/main.h  |  8 ++++
 .../ethernet/netronome/nfp/flower/metadata.c  | 16 ++++++-
 .../ethernet/netronome/nfp/flower/offload.c   | 48 ++++++++++++++++++-
 3 files changed, 69 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index caf12eec9945..56833a41f3d2 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -190,6 +190,7 @@ struct nfp_fl_internal_ports {
  * @qos_rate_limiters:	Current active qos rate limiters
  * @qos_stats_lock:	Lock on qos stats updates
  * @pre_tun_rule_cnt:	Number of pre-tunnel rules offloaded
+ * @merge_table:	Hash table to store merged flows
  */
 struct nfp_flower_priv {
 	struct nfp_app *app;
@@ -223,6 +224,7 @@ struct nfp_flower_priv {
 	unsigned int qos_rate_limiters;
 	spinlock_t qos_stats_lock; /* Protect the qos stats */
 	int pre_tun_rule_cnt;
+	struct rhashtable merge_table;
 };
 
 /**
@@ -350,6 +352,12 @@ struct nfp_fl_payload_link {
 };
 
 extern const struct rhashtable_params nfp_flower_table_params;
+extern const struct rhashtable_params merge_table_params;
+
+struct nfp_merge_info {
+	u64 parent_ctx;
+	struct rhash_head ht_node;
+};
 
 struct nfp_fl_stats_frame {
 	__be32 stats_con_id;
diff --git a/drivers/net/ethernet/netronome/nfp/flower/metadata.c b/drivers/net/ethernet/netronome/nfp/flower/metadata.c
index aa06fcb38f8b..327bb56b3ef5 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/metadata.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/metadata.c
@@ -490,6 +490,12 @@ const struct rhashtable_params nfp_flower_table_params = {
 	.automatic_shrinking	= true,
 };
 
+const struct rhashtable_params merge_table_params = {
+	.key_offset	= offsetof(struct nfp_merge_info, parent_ctx),
+	.head_offset	= offsetof(struct nfp_merge_info, ht_node),
+	.key_len	= sizeof(u64),
+};
+
 int nfp_flower_metadata_init(struct nfp_app *app, u64 host_ctx_count,
 			     unsigned int host_num_mems)
 {
@@ -506,6 +512,10 @@ int nfp_flower_metadata_init(struct nfp_app *app, u64 host_ctx_count,
 	if (err)
 		goto err_free_flow_table;
 
+	err = rhashtable_init(&priv->merge_table, &merge_table_params);
+	if (err)
+		goto err_free_stats_ctx_table;
+
 	get_random_bytes(&priv->mask_id_seed, sizeof(priv->mask_id_seed));
 
 	/* Init ring buffer and unallocated mask_ids. */
@@ -513,7 +523,7 @@ int nfp_flower_metadata_init(struct nfp_app *app, u64 host_ctx_count,
 		kmalloc_array(NFP_FLOWER_MASK_ENTRY_RS,
 			      NFP_FLOWER_MASK_ELEMENT_RS, GFP_KERNEL);
 	if (!priv->mask_ids.mask_id_free_list.buf)
-		goto err_free_stats_ctx_table;
+		goto err_free_merge_table;
 
 	priv->mask_ids.init_unallocated = NFP_FLOWER_MASK_ENTRY_RS - 1;
 
@@ -550,6 +560,8 @@ err_free_last_used:
 	kfree(priv->mask_ids.last_used);
 err_free_mask_id:
 	kfree(priv->mask_ids.mask_id_free_list.buf);
+err_free_merge_table:
+	rhashtable_destroy(&priv->merge_table);
 err_free_stats_ctx_table:
 	rhashtable_destroy(&priv->stats_ctx_table);
 err_free_flow_table:
@@ -568,6 +580,8 @@ void nfp_flower_metadata_cleanup(struct nfp_app *app)
 				    nfp_check_rhashtable_empty, NULL);
 	rhashtable_free_and_destroy(&priv->stats_ctx_table,
 				    nfp_check_rhashtable_empty, NULL);
+	rhashtable_free_and_destroy(&priv->merge_table,
+				    nfp_check_rhashtable_empty, NULL);
 	kvfree(priv->stats);
 	kfree(priv->mask_ids.mask_id_free_list.buf);
 	kfree(priv->mask_ids.last_used);
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index d72225d64a75..e95969c462e4 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1009,6 +1009,8 @@ int nfp_flower_merge_offloaded_flows(struct nfp_app *app,
 	struct netlink_ext_ack *extack = NULL;
 	struct nfp_fl_payload *merge_flow;
 	struct nfp_fl_key_ls merge_key_ls;
+	struct nfp_merge_info *merge_info;
+	u64 parent_ctx = 0;
 	int err;
 
 	ASSERT_RTNL();
@@ -1019,6 +1021,15 @@ int nfp_flower_merge_offloaded_flows(struct nfp_app *app,
 	    nfp_flower_is_merge_flow(sub_flow2))
 		return -EINVAL;
 
+	/* check if the two flows are already merged */
+	parent_ctx = (u64)(be32_to_cpu(sub_flow1->meta.host_ctx_id)) << 32;
+	parent_ctx |= (u64)(be32_to_cpu(sub_flow2->meta.host_ctx_id));
+	if (rhashtable_lookup_fast(&priv->merge_table,
+				   &parent_ctx, merge_table_params)) {
+		nfp_flower_cmsg_warn(app, "The two flows are already merged.\n");
+		return 0;
+	}
+
 	err = nfp_flower_can_merge(sub_flow1, sub_flow2);
 	if (err)
 		return err;
@@ -1060,16 +1071,33 @@ int nfp_flower_merge_offloaded_flows(struct nfp_app *app,
 	if (err)
 		goto err_release_metadata;
 
+	merge_info = kmalloc(sizeof(*merge_info), GFP_KERNEL);
+	if (!merge_info) {
+		err = -ENOMEM;
+		goto err_remove_rhash;
+	}
+	merge_info->parent_ctx = parent_ctx;
+	err = rhashtable_insert_fast(&priv->merge_table, &merge_info->ht_node,
+				     merge_table_params);
+	if (err)
+		goto err_destroy_merge_info;
+
 	err = nfp_flower_xmit_flow(app, merge_flow,
 				   NFP_FLOWER_CMSG_TYPE_FLOW_MOD);
 	if (err)
-		goto err_remove_rhash;
+		goto err_remove_merge_info;
 
 	merge_flow->in_hw = true;
 	sub_flow1->in_hw = false;
 
 	return 0;
 
+err_remove_merge_info:
+	WARN_ON_ONCE(rhashtable_remove_fast(&priv->merge_table,
+					    &merge_info->ht_node,
+					    merge_table_params));
+err_destroy_merge_info:
+	kfree(merge_info);
 err_remove_rhash:
 	WARN_ON_ONCE(rhashtable_remove_fast(&priv->flow_table,
 					    &merge_flow->fl_node,
@@ -1359,7 +1387,9 @@ nfp_flower_remove_merge_flow(struct nfp_app *app,
 {
 	struct nfp_flower_priv *priv = app->priv;
 	struct nfp_fl_payload_link *link, *temp;
+	struct nfp_merge_info *merge_info;
 	struct nfp_fl_payload *origin;
+	u64 parent_ctx = 0;
 	bool mod = false;
 	int err;
 
@@ -1396,8 +1426,22 @@ nfp_flower_remove_merge_flow(struct nfp_app *app,
 err_free_links:
 	/* Clean any links connected with the merged flow. */
 	list_for_each_entry_safe(link, temp, &merge_flow->linked_flows,
-				 merge_flow.list)
+				 merge_flow.list) {
+		u32 ctx_id = be32_to_cpu(link->sub_flow.flow->meta.host_ctx_id);
+
+		parent_ctx = (parent_ctx << 32) | (u64)(ctx_id);
 		nfp_flower_unlink_flow(link);
+	}
+
+	merge_info = rhashtable_lookup_fast(&priv->merge_table,
+					    &parent_ctx,
+					    merge_table_params);
+	if (merge_info) {
+		WARN_ON_ONCE(rhashtable_remove_fast(&priv->merge_table,
+						    &merge_info->ht_node,
+						    merge_table_params));
+		kfree(merge_info);
+	}
 
 	kfree(merge_flow->action_data);
 	kfree(merge_flow->mask_data);
-- 
2.30.2



