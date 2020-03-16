Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9A8D1875AA
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 23:31:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732770AbgCPWbW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 18:31:22 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:49156 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732766AbgCPWbV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 18:31:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584397879;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oAhPIgAxgmFEiVGcJgeLkoxBr55RDWmKfvU+AGOVclA=;
        b=yDWffo3A9VWrTB9JIJGbvoHrNICtqPyW5I6iKl5G3RYWajYWSbg5jguK9UN8vdzcmjhAk4
        Es+e1HzeI6lnc0HhY0PleSz9V2OFNvtc7zhuPp8+78b3BA5tkpn4ssNCflObC0u9xkcw6r
        /LR1Z5UDh/lpiHhXoAFva38jjvceymU=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.9 12/24] batman-adv: Fix internal interface indices types
Date:   Mon, 16 Mar 2020 23:30:53 +0100
Message-Id: <20200316223105.6333-13-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200316223105.6333-1-sven@narfation.org>
References: <20200316223105.6333-1-sven@narfation.org>
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
---
 net/batman-adv/bat_iv_ogm.c     | 24 ++++++++++++++----------
 net/batman-adv/hard-interface.c |  9 +++++++--
 net/batman-adv/originator.c     |  4 ++--
 net/batman-adv/originator.h     |  4 ++--
 net/batman-adv/types.h          | 11 ++++++-----
 5 files changed, 31 insertions(+), 21 deletions(-)

diff --git a/net/batman-adv/bat_iv_ogm.c b/net/batman-adv/bat_iv_ogm.c
index 477ec5023488..f3de43ccdf93 100644
--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -149,7 +149,7 @@ static void batadv_iv_ogm_orig_free(struct batadv_orig_node *orig_node)
  * Return: 0 on success, a negative error code otherwise.
  */
 static int batadv_iv_ogm_orig_add_if(struct batadv_orig_node *orig_node,
-				     int max_if_num)
+				     unsigned int max_if_num)
 {
 	void *data_ptr;
 	size_t old_size;
@@ -193,7 +193,8 @@ static int batadv_iv_ogm_orig_add_if(struct batadv_orig_node *orig_node,
  */
 static void
 batadv_iv_ogm_drop_bcast_own_entry(struct batadv_orig_node *orig_node,
-				   int max_if_num, int del_if_num)
+				   unsigned int max_if_num,
+				   unsigned int del_if_num)
 {
 	size_t chunk_size;
 	size_t if_offset;
@@ -231,7 +232,8 @@ batadv_iv_ogm_drop_bcast_own_entry(struct batadv_orig_node *orig_node,
  */
 static void
 batadv_iv_ogm_drop_bcast_own_sum_entry(struct batadv_orig_node *orig_node,
-				       int max_if_num, int del_if_num)
+				       unsigned int max_if_num,
+				       unsigned int del_if_num)
 {
 	size_t if_offset;
 	void *data_ptr;
@@ -268,7 +270,8 @@ batadv_iv_ogm_drop_bcast_own_sum_entry(struct batadv_orig_node *orig_node,
  * Return: 0 on success, a negative error code otherwise.
  */
 static int batadv_iv_ogm_orig_del_if(struct batadv_orig_node *orig_node,
-				     int max_if_num, int del_if_num)
+				     unsigned int max_if_num,
+				     unsigned int del_if_num)
 {
 	spin_lock_bh(&orig_node->bat_iv.ogm_cnt_lock);
 
@@ -302,7 +305,8 @@ static struct batadv_orig_node *
 batadv_iv_ogm_orig_get(struct batadv_priv *bat_priv, const u8 *addr)
 {
 	struct batadv_orig_node *orig_node;
-	int size, hash_added;
+	int hash_added;
+	size_t size;
 
 	orig_node = batadv_orig_hash_find(bat_priv, addr);
 	if (orig_node)
@@ -898,7 +902,7 @@ batadv_iv_ogm_slide_own_bcast_window(struct batadv_hard_iface *hard_iface)
 	u32 i;
 	size_t word_index;
 	u8 *w;
-	int if_num;
+	unsigned int if_num;
 
 	for (i = 0; i < hash->size; i++) {
 		head = &hash->table[i];
@@ -1028,7 +1032,7 @@ batadv_iv_ogm_orig_update(struct batadv_priv *bat_priv,
 	struct batadv_neigh_node *tmp_neigh_node = NULL;
 	struct batadv_neigh_node *router = NULL;
 	struct batadv_orig_node *orig_node_tmp;
-	int if_num;
+	unsigned int if_num;
 	u8 sum_orig, sum_neigh;
 	u8 *neigh_addr;
 	u8 tq_avg;
@@ -1186,7 +1190,7 @@ static bool batadv_iv_ogm_calc_tq(struct batadv_orig_node *orig_node,
 	u8 total_count;
 	u8 orig_eq_count, neigh_rq_count, neigh_rq_inv, tq_own;
 	unsigned int neigh_rq_inv_cube, neigh_rq_max_cube;
-	int if_num;
+	unsigned int if_num;
 	unsigned int tq_asym_penalty, inv_asym_penalty;
 	unsigned int combined_tq;
 	unsigned int tq_iface_penalty;
@@ -1705,9 +1709,9 @@ static void batadv_iv_ogm_process(const struct sk_buff *skb, int ogm_offset,
 
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
index 8f7883b7d717..cda2b1af0d4f 100644
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -539,6 +539,11 @@ int batadv_hardif_enable_interface(struct batadv_hard_iface *hard_iface,
 	hard_iface->soft_iface = soft_iface;
 	bat_priv = netdev_priv(hard_iface->soft_iface);
 
+	if (bat_priv->num_ifaces >= UINT_MAX) {
+		ret = -ENOSPC;
+		goto err_dev;
+	}
+
 	ret = netdev_master_upper_dev_link(hard_iface->net_dev,
 					   soft_iface, NULL, NULL);
 	if (ret)
@@ -646,7 +651,7 @@ void batadv_hardif_disable_interface(struct batadv_hard_iface *hard_iface,
 	batadv_hardif_recalc_extra_skbroom(hard_iface->soft_iface);
 
 	/* nobody uses this interface anymore */
-	if (!bat_priv->num_ifaces) {
+	if (bat_priv->num_ifaces == 0) {
 		batadv_gw_check_client_stop(bat_priv);
 
 		if (autodel == BATADV_IF_CLEANUP_AUTO)
@@ -682,7 +687,7 @@ batadv_hardif_add_interface(struct net_device *net_dev)
 	if (ret)
 		goto free_if;
 
-	hard_iface->if_num = -1;
+	hard_iface->if_num = 0;
 	hard_iface->net_dev = net_dev;
 	hard_iface->soft_iface = NULL;
 	hard_iface->if_status = BATADV_IF_NOT_IN_USE;
diff --git a/net/batman-adv/originator.c b/net/batman-adv/originator.c
index 7c8d16086f0f..8466f83fc32f 100644
--- a/net/batman-adv/originator.c
+++ b/net/batman-adv/originator.c
@@ -1495,7 +1495,7 @@ int batadv_orig_dump(struct sk_buff *msg, struct netlink_callback *cb)
 }
 
 int batadv_orig_hash_add_if(struct batadv_hard_iface *hard_iface,
-			    int max_if_num)
+			    unsigned int max_if_num)
 {
 	struct batadv_priv *bat_priv = netdev_priv(hard_iface->soft_iface);
 	struct batadv_algo_ops *bao = bat_priv->algo_ops;
@@ -1530,7 +1530,7 @@ int batadv_orig_hash_add_if(struct batadv_hard_iface *hard_iface,
 }
 
 int batadv_orig_hash_del_if(struct batadv_hard_iface *hard_iface,
-			    int max_if_num)
+			    unsigned int max_if_num)
 {
 	struct batadv_priv *bat_priv = netdev_priv(hard_iface->soft_iface);
 	struct batadv_hashtable *hash = bat_priv->orig_hash;
diff --git a/net/batman-adv/originator.h b/net/batman-adv/originator.h
index ebc56183f358..fab0b2cc141d 100644
--- a/net/batman-adv/originator.h
+++ b/net/batman-adv/originator.h
@@ -78,9 +78,9 @@ int batadv_orig_seq_print_text(struct seq_file *seq, void *offset);
 int batadv_orig_dump(struct sk_buff *msg, struct netlink_callback *cb);
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
index cb66ace1db0c..1caff709e94e 100644
--- a/net/batman-adv/types.h
+++ b/net/batman-adv/types.h
@@ -139,7 +139,7 @@ struct batadv_hard_iface_bat_v {
  */
 struct batadv_hard_iface {
 	struct list_head list;
-	s16 if_num;
+	unsigned int if_num;
 	char if_status;
 	struct net_device *net_dev;
 	u8 num_bcasts;
@@ -1060,7 +1060,7 @@ struct batadv_priv {
 	atomic_t bcast_seqno;
 	atomic_t bcast_queue_left;
 	atomic_t batman_queue_left;
-	char num_ifaces;
+	unsigned int num_ifaces;
 	struct kobject *mesh_obj;
 	struct dentry *debug_dir;
 	struct hlist_head forw_bat_list;
@@ -1454,9 +1454,10 @@ struct batadv_algo_neigh_ops {
  */
 struct batadv_algo_orig_ops {
 	void (*free)(struct batadv_orig_node *orig_node);
-	int (*add_if)(struct batadv_orig_node *orig_node, int max_if_num);
-	int (*del_if)(struct batadv_orig_node *orig_node, int max_if_num,
-		      int del_if_num);
+	int (*add_if)(struct batadv_orig_node *orig_node,
+		      unsigned int max_if_num);
+	int (*del_if)(struct batadv_orig_node *orig_node,
+		      unsigned int max_if_num, unsigned int del_if_num);
 #ifdef CONFIG_BATMAN_ADV_DEBUGFS
 	void (*print)(struct batadv_priv *priv, struct seq_file *seq,
 		      struct batadv_hard_iface *hard_iface);
-- 
2.20.1

