Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FEFC18920E
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 00:28:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbgCQX2M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 19:28:12 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:53636 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727071AbgCQX2M (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 19:28:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584487691;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vH0CRsTj8y/okY7JcGDc5yC64/krJ2UqHIEnwKI/AOc=;
        b=jRqbbUGR/0HdqIvrQyBvaVfFlpZz3AhWXkNRQUXyUEkx993wJQslh67QdYJXcqmvk2EXSk
        MMEhOOQDSgcviftJwNhKdZWs+F+gqDJwRb8AAOnBTLwSdFrm7WxufUrwyBDBxi4rLz2f4a
        lX7xDxgFNbLJ6WF+Tnxm8hVODk8U0TU=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.4 30/48] batman-adv: Fix internal interface indices types
Date:   Wed, 18 Mar 2020 00:27:16 +0100
Message-Id: <20200317232734.6127-31-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200317232734.6127-1-sven@narfation.org>
References: <20200317232734.6127-1-sven@narfation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit f22e08932c2960f29b5e828e745c9f3fb7c1bb86 upstream.

batman-adv uses internal indices for each enabled and active interface.
It is currently used by the B.A.T.M.A.N. IV algorithm to identifify the
correct position in the ogm_cnt bitmaps.

The type for the number of enabled interfaces (which defines the next
interface index) was set to char. This type can be (depending on the
architecture) either signed (limiting batman-adv to 127 active slave
interfaces) or unsigned (limiting batman-adv to 255 active slave
interfaces).

This limit was not correctly checked when an interface was enabled and thus
an overflow happened. This was only catched on systems with the signed char
type when the B.A.T.M.A.N. IV code tried to resize its counter arrays with
a negative size.

The if_num interface index was only a s16 and therefore significantly
smaller than the ifindex (int) used by the code net code.

Both &batadv_hard_iface->if_num and &batadv_priv->num_ifaces must be
(unsigned) int to support the same number of slave interfaces as the net
core code. And the interface activation code must check the number of
active slave interfaces to avoid integer overflows.

Fixes: c6c8fea29769 ("net: Add batman-adv meshing protocol")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
---
 net/batman-adv/bat_iv_ogm.c     | 16 +++++++++-------
 net/batman-adv/hard-interface.c |  9 +++++++--
 net/batman-adv/originator.c     |  4 ++--
 net/batman-adv/originator.h     |  4 ++--
 net/batman-adv/types.h          |  8 ++++----
 5 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/net/batman-adv/bat_iv_ogm.c b/net/batman-adv/bat_iv_ogm.c
index 910889dd5356..5010b81e746f 100644
--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -135,7 +135,7 @@ static void batadv_iv_ogm_orig_free(struct batadv_orig_node *orig_node)
  * Returns 0 on success, a negative error code otherwise.
  */
 static int batadv_iv_ogm_orig_add_if(struct batadv_orig_node *orig_node,
-				     int max_if_num)
+				     unsigned int max_if_num)
 {
 	void *data_ptr;
 	size_t old_size;
@@ -181,7 +181,8 @@ unlock:
  * Returns 0 on success, a negative error code otherwise.
  */
 static int batadv_iv_ogm_orig_del_if(struct batadv_orig_node *orig_node,
-				     int max_if_num, int del_if_num)
+				     unsigned int max_if_num,
+				     unsigned int del_if_num)
 {
 	int ret = -ENOMEM;
 	size_t chunk_size, if_offset;
@@ -252,7 +253,8 @@ static struct batadv_orig_node *
 batadv_iv_ogm_orig_get(struct batadv_priv *bat_priv, const u8 *addr)
 {
 	struct batadv_orig_node *orig_node;
-	int size, hash_added;
+	int hash_added;
+	size_t size;
 
 	orig_node = batadv_orig_hash_find(bat_priv, addr);
 	if (orig_node)
@@ -871,7 +873,7 @@ batadv_iv_ogm_slide_own_bcast_window(struct batadv_hard_iface *hard_iface)
 	u32 i;
 	size_t word_index;
 	u8 *w;
-	int if_num;
+	unsigned int if_num;
 
 	for (i = 0; i < hash->size; i++) {
 		head = &hash->table[i];
@@ -982,7 +984,7 @@ batadv_iv_ogm_orig_update(struct batadv_priv *bat_priv,
 	struct batadv_neigh_node *tmp_neigh_node = NULL;
 	struct batadv_neigh_node *router = NULL;
 	struct batadv_orig_node *orig_node_tmp;
-	int if_num;
+	unsigned int if_num;
 	u8 sum_orig, sum_neigh;
 	u8 *neigh_addr;
 	u8 tq_avg;
@@ -1647,9 +1649,9 @@ static void batadv_iv_ogm_process(const struct sk_buff *skb, int ogm_offset,
 
 	if (is_my_orig) {
 		unsigned long *word;
-		int offset;
+		size_t offset;
 		s32 bit_pos;
-		s16 if_num;
+		unsigned int if_num;
 		u8 *weight;
 
 		orig_neigh_node = batadv_iv_ogm_orig_get(bat_priv,
diff --git a/net/batman-adv/hard-interface.c b/net/batman-adv/hard-interface.c
index cc3be5489f5c..7c297cef20a7 100644
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -493,6 +493,11 @@ int batadv_hardif_enable_interface(struct batadv_hard_iface *hard_iface,
 	hard_iface->soft_iface = soft_iface;
 	bat_priv = netdev_priv(hard_iface->soft_iface);
 
+	if (bat_priv->num_ifaces >= UINT_MAX) {
+		ret = -ENOSPC;
+		goto err_dev;
+	}
+
 	ret = netdev_master_upper_dev_link(hard_iface->net_dev, soft_iface);
 	if (ret)
 		goto err_dev;
@@ -600,7 +605,7 @@ void batadv_hardif_disable_interface(struct batadv_hard_iface *hard_iface,
 	batadv_hardif_recalc_extra_skbroom(hard_iface->soft_iface);
 
 	/* nobody uses this interface anymore */
-	if (!bat_priv->num_ifaces) {
+	if (bat_priv->num_ifaces == 0) {
 		batadv_gw_check_client_stop(bat_priv);
 
 		if (autodel == BATADV_IF_CLEANUP_AUTO)
@@ -656,7 +661,7 @@ batadv_hardif_add_interface(struct net_device *net_dev)
 	if (ret)
 		goto free_if;
 
-	hard_iface->if_num = -1;
+	hard_iface->if_num = 0;
 	hard_iface->net_dev = net_dev;
 	hard_iface->soft_iface = NULL;
 	hard_iface->if_status = BATADV_IF_NOT_IN_USE;
diff --git a/net/batman-adv/originator.c b/net/batman-adv/originator.c
index ce5b991707d0..b3013fbc417e 100644
--- a/net/batman-adv/originator.c
+++ b/net/batman-adv/originator.c
@@ -1103,7 +1103,7 @@ out:
 }
 
 int batadv_orig_hash_add_if(struct batadv_hard_iface *hard_iface,
-			    int max_if_num)
+			    unsigned int max_if_num)
 {
 	struct batadv_priv *bat_priv = netdev_priv(hard_iface->soft_iface);
 	struct batadv_algo_ops *bao = bat_priv->bat_algo_ops;
@@ -1139,7 +1139,7 @@ err:
 }
 
 int batadv_orig_hash_del_if(struct batadv_hard_iface *hard_iface,
-			    int max_if_num)
+			    unsigned int max_if_num)
 {
 	struct batadv_priv *bat_priv = netdev_priv(hard_iface->soft_iface);
 	struct batadv_hashtable *hash = bat_priv->orig_hash;
diff --git a/net/batman-adv/originator.h b/net/batman-adv/originator.h
index a5c37882b409..65824d892a6a 100644
--- a/net/batman-adv/originator.h
+++ b/net/batman-adv/originator.h
@@ -67,9 +67,9 @@ void batadv_orig_ifinfo_free_ref(struct batadv_orig_ifinfo *orig_ifinfo);
 int batadv_orig_seq_print_text(struct seq_file *seq, void *offset);
 int batadv_orig_hardif_seq_print_text(struct seq_file *seq, void *offset);
 int batadv_orig_hash_add_if(struct batadv_hard_iface *hard_iface,
-			    int max_if_num);
+			    unsigned int max_if_num);
 int batadv_orig_hash_del_if(struct batadv_hard_iface *hard_iface,
-			    int max_if_num);
+			    unsigned int max_if_num);
 struct batadv_orig_node_vlan *
 batadv_orig_node_vlan_new(struct batadv_orig_node *orig_node,
 			  unsigned short vid);
diff --git a/net/batman-adv/types.h b/net/batman-adv/types.h
index 630777a93cdd..6dcee1991c54 100644
--- a/net/batman-adv/types.h
+++ b/net/batman-adv/types.h
@@ -103,7 +103,7 @@ struct batadv_hard_iface_bat_iv {
  */
 struct batadv_hard_iface {
 	struct list_head list;
-	s16 if_num;
+	unsigned int if_num;
 	char if_status;
 	struct net_device *net_dev;
 	u8 num_bcasts;
@@ -808,7 +808,7 @@ struct batadv_priv {
 	atomic_t bcast_seqno;
 	atomic_t bcast_queue_left;
 	atomic_t batman_queue_left;
-	char num_ifaces;
+	unsigned int num_ifaces;
 	struct kobject *mesh_obj;
 	struct dentry *debug_dir;
 	struct hlist_head forw_bat_list;
@@ -1179,9 +1179,9 @@ struct batadv_algo_ops {
 			       struct batadv_hard_iface *hard_iface);
 	void (*bat_orig_free)(struct batadv_orig_node *orig_node);
 	int (*bat_orig_add_if)(struct batadv_orig_node *orig_node,
-			       int max_if_num);
+			       unsigned int max_if_num);
 	int (*bat_orig_del_if)(struct batadv_orig_node *orig_node,
-			       int max_if_num, int del_if_num);
+			       unsigned int max_if_num, unsigned int del_if_num);
 };
 
 /**
-- 
2.20.1

