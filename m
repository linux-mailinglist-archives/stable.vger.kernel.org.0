Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EDEE18B806
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728042AbgCSNH7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:07:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:51996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728037AbgCSNH6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:07:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23D71208DB;
        Thu, 19 Mar 2020 13:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623277;
        bh=CBtoYhL6joQz2ZymCK5pl4zkMbyZKZXLbzyGIGjfOC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wMkS7EQgfcS0/QO/HliBEYu6hH3Hm/4T7XIwus8C26KNYAfWvh7kRYkdjqfCnYWeJ
         ZMPH7Dbkf6qspqkBD6NhqcVmi9gMUXbtCVY7MplE53b/5duoYzIi25ig+w84lh27Li
         BM1uC8NPLl1xkBcV/vJ5xBvkxCEhsone9h2JevgA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.4 67/93] batman-adv: Fix internal interface indices types
Date:   Thu, 19 Mar 2020 14:00:11 +0100
Message-Id: <20200319123946.365408520@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123924.795019515@linuxfoundation.org>
References: <20200319123924.795019515@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/bat_iv_ogm.c     |   16 +++++++++-------
 net/batman-adv/hard-interface.c |    9 +++++++--
 net/batman-adv/originator.c     |    4 ++--
 net/batman-adv/originator.h     |    4 ++--
 net/batman-adv/types.h          |    8 ++++----
 5 files changed, 24 insertions(+), 17 deletions(-)

--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -135,7 +135,7 @@ static void batadv_iv_ogm_orig_free(stru
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
@@ -871,7 +873,7 @@ batadv_iv_ogm_slide_own_bcast_window(str
 	u32 i;
 	size_t word_index;
 	u8 *w;
-	int if_num;
+	unsigned int if_num;
 
 	for (i = 0; i < hash->size; i++) {
 		head = &hash->table[i];
@@ -982,7 +984,7 @@ batadv_iv_ogm_orig_update(struct batadv_
 	struct batadv_neigh_node *tmp_neigh_node = NULL;
 	struct batadv_neigh_node *router = NULL;
 	struct batadv_orig_node *orig_node_tmp;
-	int if_num;
+	unsigned int if_num;
 	u8 sum_orig, sum_neigh;
 	u8 *neigh_addr;
 	u8 tq_avg;
@@ -1647,9 +1649,9 @@ static void batadv_iv_ogm_process(const
 
 	if (is_my_orig) {
 		unsigned long *word;
-		int offset;
+		size_t offset;
 		s32 bit_pos;
-		s16 if_num;
+		unsigned int if_num;
 		u8 *weight;
 
 		orig_neigh_node = batadv_iv_ogm_orig_get(bat_priv,
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -493,6 +493,11 @@ int batadv_hardif_enable_interface(struc
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
@@ -600,7 +605,7 @@ void batadv_hardif_disable_interface(str
 	batadv_hardif_recalc_extra_skbroom(hard_iface->soft_iface);
 
 	/* nobody uses this interface anymore */
-	if (!bat_priv->num_ifaces) {
+	if (bat_priv->num_ifaces == 0) {
 		batadv_gw_check_client_stop(bat_priv);
 
 		if (autodel == BATADV_IF_CLEANUP_AUTO)
@@ -656,7 +661,7 @@ batadv_hardif_add_interface(struct net_d
 	if (ret)
 		goto free_if;
 
-	hard_iface->if_num = -1;
+	hard_iface->if_num = 0;
 	hard_iface->net_dev = net_dev;
 	hard_iface->soft_iface = NULL;
 	hard_iface->if_status = BATADV_IF_NOT_IN_USE;
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
--- a/net/batman-adv/originator.h
+++ b/net/batman-adv/originator.h
@@ -67,9 +67,9 @@ void batadv_orig_ifinfo_free_ref(struct
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


