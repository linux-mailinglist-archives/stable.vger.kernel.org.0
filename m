Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9135A4F43CB
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 00:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383383AbiDEMZq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:25:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241021AbiDEKzc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:55:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C4A8102B;
        Tue,  5 Apr 2022 03:28:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE3F16142E;
        Tue,  5 Apr 2022 10:28:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92F20C385A0;
        Tue,  5 Apr 2022 10:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649154513;
        bh=/gBRFV/KUVLrQvam7Ao342OkLF00RV0p97mSQq2uZWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I7QXrLaWpLO+OXkws4ULHefGlL8bzKv6PlX7gG6tEdl6gv0vpdfQp12tNUj+xmwfu
         fuC6poT0/L1ZcLXQew7aWECvcP9AvP+sASz0+MEJidrt9Ww2BecHnQRQXf0s+H65UO
         dcTq+0+a6LQX74VfvMCbshcrgjMXMGp4BLWdE6W4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 5.10 575/599] batman-adv: Check ptr for NULL before reducing its refcnt
Date:   Tue,  5 Apr 2022 09:34:29 +0200
Message-Id: <20220405070315.954004430@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Sven Eckelmann <sven@narfation.org>

commit 6340dcbd619450c1bb55eb999e554e4f0e6dab0a upstream.

The commit b37a46683739 ("netdevice: add the case if dev is NULL") changed
the way how the NULL check for net_devices have to be handled when trying
to reduce its reference counter. Before this commit, it was the
responsibility of the caller to check whether the object is NULL or not.
But it was changed to behave more like kfree. Now the callee has to handle
the NULL-case.

The batman-adv code was scanned via cocinelle for similar places. These
were changed to use the paradigm

  @@
  identifier E, T, R, C;
  identifier put;
  @@
   void put(struct T *E)
   {
  +	if (!E)
  +		return;
  	kref_put(&E->C, R);
   }

Functions which were used in other sources files were moved to the header
to allow the compiler to inline the NULL check and the kref_put call.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/bridge_loop_avoidance.c |    6 ++
 net/batman-adv/distributed-arp-table.c |    3 +
 net/batman-adv/gateway_client.c        |   12 ----
 net/batman-adv/gateway_client.h        |   16 +++++
 net/batman-adv/hard-interface.h        |    3 +
 net/batman-adv/network-coding.c        |    6 ++
 net/batman-adv/originator.c            |   72 ++----------------------
 net/batman-adv/originator.h            |   96 ++++++++++++++++++++++++++++++---
 net/batman-adv/soft-interface.c        |   15 -----
 net/batman-adv/soft-interface.h        |   16 +++++
 net/batman-adv/tp_meter.c              |    3 +
 net/batman-adv/translation-table.c     |   22 +++----
 net/batman-adv/translation-table.h     |   18 +++++-
 net/batman-adv/tvlv.c                  |    6 ++
 14 files changed, 181 insertions(+), 113 deletions(-)

--- a/net/batman-adv/bridge_loop_avoidance.c
+++ b/net/batman-adv/bridge_loop_avoidance.c
@@ -164,6 +164,9 @@ static void batadv_backbone_gw_release(s
  */
 static void batadv_backbone_gw_put(struct batadv_bla_backbone_gw *backbone_gw)
 {
+	if (!backbone_gw)
+		return;
+
 	kref_put(&backbone_gw->refcount, batadv_backbone_gw_release);
 }
 
@@ -199,6 +202,9 @@ static void batadv_claim_release(struct
  */
 static void batadv_claim_put(struct batadv_bla_claim *claim)
 {
+	if (!claim)
+		return;
+
 	kref_put(&claim->refcount, batadv_claim_release);
 }
 
--- a/net/batman-adv/distributed-arp-table.c
+++ b/net/batman-adv/distributed-arp-table.c
@@ -128,6 +128,9 @@ static void batadv_dat_entry_release(str
  */
 static void batadv_dat_entry_put(struct batadv_dat_entry *dat_entry)
 {
+	if (!dat_entry)
+		return;
+
 	kref_put(&dat_entry->refcount, batadv_dat_entry_release);
 }
 
--- a/net/batman-adv/gateway_client.c
+++ b/net/batman-adv/gateway_client.c
@@ -60,7 +60,7 @@
  *  after rcu grace period
  * @ref: kref pointer of the gw_node
  */
-static void batadv_gw_node_release(struct kref *ref)
+void batadv_gw_node_release(struct kref *ref)
 {
 	struct batadv_gw_node *gw_node;
 
@@ -71,16 +71,6 @@ static void batadv_gw_node_release(struc
 }
 
 /**
- * batadv_gw_node_put() - decrement the gw_node refcounter and possibly release
- *  it
- * @gw_node: gateway node to free
- */
-void batadv_gw_node_put(struct batadv_gw_node *gw_node)
-{
-	kref_put(&gw_node->refcount, batadv_gw_node_release);
-}
-
-/**
  * batadv_gw_get_selected_gw_node() - Get currently selected gateway
  * @bat_priv: the bat priv with all the soft interface information
  *
--- a/net/batman-adv/gateway_client.h
+++ b/net/batman-adv/gateway_client.h
@@ -9,6 +9,7 @@
 
 #include "main.h"
 
+#include <linux/kref.h>
 #include <linux/netlink.h>
 #include <linux/seq_file.h>
 #include <linux/skbuff.h>
@@ -28,7 +29,7 @@ void batadv_gw_node_update(struct batadv
 void batadv_gw_node_delete(struct batadv_priv *bat_priv,
 			   struct batadv_orig_node *orig_node);
 void batadv_gw_node_free(struct batadv_priv *bat_priv);
-void batadv_gw_node_put(struct batadv_gw_node *gw_node);
+void batadv_gw_node_release(struct kref *ref);
 struct batadv_gw_node *
 batadv_gw_get_selected_gw_node(struct batadv_priv *bat_priv);
 int batadv_gw_client_seq_print_text(struct seq_file *seq, void *offset);
@@ -40,4 +41,17 @@ batadv_gw_dhcp_recipient_get(struct sk_b
 struct batadv_gw_node *batadv_gw_node_get(struct batadv_priv *bat_priv,
 					  struct batadv_orig_node *orig_node);
 
+/**
+ * batadv_gw_node_put() - decrement the gw_node refcounter and possibly release
+ *  it
+ * @gw_node: gateway node to free
+ */
+static inline void batadv_gw_node_put(struct batadv_gw_node *gw_node)
+{
+	if (!gw_node)
+		return;
+
+	kref_put(&gw_node->refcount, batadv_gw_node_release);
+}
+
 #endif /* _NET_BATMAN_ADV_GATEWAY_CLIENT_H_ */
--- a/net/batman-adv/hard-interface.h
+++ b/net/batman-adv/hard-interface.h
@@ -113,6 +113,9 @@ int batadv_hardif_no_broadcast(struct ba
  */
 static inline void batadv_hardif_put(struct batadv_hard_iface *hard_iface)
 {
+	if (!hard_iface)
+		return;
+
 	kref_put(&hard_iface->refcount, batadv_hardif_release);
 }
 
--- a/net/batman-adv/network-coding.c
+++ b/net/batman-adv/network-coding.c
@@ -222,6 +222,9 @@ static void batadv_nc_node_release(struc
  */
 static void batadv_nc_node_put(struct batadv_nc_node *nc_node)
 {
+	if (!nc_node)
+		return;
+
 	kref_put(&nc_node->refcount, batadv_nc_node_release);
 }
 
@@ -246,6 +249,9 @@ static void batadv_nc_path_release(struc
  */
 static void batadv_nc_path_put(struct batadv_nc_path *nc_path)
 {
+	if (!nc_path)
+		return;
+
 	kref_put(&nc_path->refcount, batadv_nc_path_release);
 }
 
--- a/net/batman-adv/originator.c
+++ b/net/batman-adv/originator.c
@@ -178,7 +178,7 @@ out:
  *  and queue for free after rcu grace period
  * @ref: kref pointer of the originator-vlan object
  */
-static void batadv_orig_node_vlan_release(struct kref *ref)
+void batadv_orig_node_vlan_release(struct kref *ref)
 {
 	struct batadv_orig_node_vlan *orig_vlan;
 
@@ -188,16 +188,6 @@ static void batadv_orig_node_vlan_releas
 }
 
 /**
- * batadv_orig_node_vlan_put() - decrement the refcounter and possibly release
- *  the originator-vlan object
- * @orig_vlan: the originator-vlan object to release
- */
-void batadv_orig_node_vlan_put(struct batadv_orig_node_vlan *orig_vlan)
-{
-	kref_put(&orig_vlan->refcount, batadv_orig_node_vlan_release);
-}
-
-/**
  * batadv_originator_init() - Initialize all originator structures
  * @bat_priv: the bat priv with all the soft interface information
  *
@@ -232,7 +222,7 @@ err:
  *  free after rcu grace period
  * @ref: kref pointer of the neigh_ifinfo
  */
-static void batadv_neigh_ifinfo_release(struct kref *ref)
+void batadv_neigh_ifinfo_release(struct kref *ref)
 {
 	struct batadv_neigh_ifinfo *neigh_ifinfo;
 
@@ -245,21 +235,11 @@ static void batadv_neigh_ifinfo_release(
 }
 
 /**
- * batadv_neigh_ifinfo_put() - decrement the refcounter and possibly release
- *  the neigh_ifinfo
- * @neigh_ifinfo: the neigh_ifinfo object to release
- */
-void batadv_neigh_ifinfo_put(struct batadv_neigh_ifinfo *neigh_ifinfo)
-{
-	kref_put(&neigh_ifinfo->refcount, batadv_neigh_ifinfo_release);
-}
-
-/**
  * batadv_hardif_neigh_release() - release hardif neigh node from lists and
  *  queue for free after rcu grace period
  * @ref: kref pointer of the neigh_node
  */
-static void batadv_hardif_neigh_release(struct kref *ref)
+void batadv_hardif_neigh_release(struct kref *ref)
 {
 	struct batadv_hardif_neigh_node *hardif_neigh;
 
@@ -275,21 +255,11 @@ static void batadv_hardif_neigh_release(
 }
 
 /**
- * batadv_hardif_neigh_put() - decrement the hardif neighbors refcounter
- *  and possibly release it
- * @hardif_neigh: hardif neigh neighbor to free
- */
-void batadv_hardif_neigh_put(struct batadv_hardif_neigh_node *hardif_neigh)
-{
-	kref_put(&hardif_neigh->refcount, batadv_hardif_neigh_release);
-}
-
-/**
  * batadv_neigh_node_release() - release neigh_node from lists and queue for
  *  free after rcu grace period
  * @ref: kref pointer of the neigh_node
  */
-static void batadv_neigh_node_release(struct kref *ref)
+void batadv_neigh_node_release(struct kref *ref)
 {
 	struct hlist_node *node_tmp;
 	struct batadv_neigh_node *neigh_node;
@@ -310,16 +280,6 @@ static void batadv_neigh_node_release(st
 }
 
 /**
- * batadv_neigh_node_put() - decrement the neighbors refcounter and possibly
- *  release it
- * @neigh_node: neigh neighbor to free
- */
-void batadv_neigh_node_put(struct batadv_neigh_node *neigh_node)
-{
-	kref_put(&neigh_node->refcount, batadv_neigh_node_release);
-}
-
-/**
  * batadv_orig_router_get() - router to the originator depending on iface
  * @orig_node: the orig node for the router
  * @if_outgoing: the interface where the payload packet has been received or
@@ -851,7 +811,7 @@ int batadv_hardif_neigh_dump(struct sk_b
  *  free after rcu grace period
  * @ref: kref pointer of the orig_ifinfo
  */
-static void batadv_orig_ifinfo_release(struct kref *ref)
+void batadv_orig_ifinfo_release(struct kref *ref)
 {
 	struct batadv_orig_ifinfo *orig_ifinfo;
 	struct batadv_neigh_node *router;
@@ -870,16 +830,6 @@ static void batadv_orig_ifinfo_release(s
 }
 
 /**
- * batadv_orig_ifinfo_put() - decrement the refcounter and possibly release
- *  the orig_ifinfo
- * @orig_ifinfo: the orig_ifinfo object to release
- */
-void batadv_orig_ifinfo_put(struct batadv_orig_ifinfo *orig_ifinfo)
-{
-	kref_put(&orig_ifinfo->refcount, batadv_orig_ifinfo_release);
-}
-
-/**
  * batadv_orig_node_free_rcu() - free the orig_node
  * @rcu: rcu pointer of the orig_node
  */
@@ -902,7 +852,7 @@ static void batadv_orig_node_free_rcu(st
  *  free after rcu grace period
  * @ref: kref pointer of the orig_node
  */
-static void batadv_orig_node_release(struct kref *ref)
+void batadv_orig_node_release(struct kref *ref)
 {
 	struct hlist_node *node_tmp;
 	struct batadv_neigh_node *neigh_node;
@@ -949,16 +899,6 @@ static void batadv_orig_node_release(str
 }
 
 /**
- * batadv_orig_node_put() - decrement the orig node refcounter and possibly
- *  release it
- * @orig_node: the orig node to free
- */
-void batadv_orig_node_put(struct batadv_orig_node *orig_node)
-{
-	kref_put(&orig_node->refcount, batadv_orig_node_release);
-}
-
-/**
  * batadv_originator_free() - Free all originator structures
  * @bat_priv: the bat priv with all the soft interface information
  */
--- a/net/batman-adv/originator.h
+++ b/net/batman-adv/originator.h
@@ -12,6 +12,7 @@
 #include <linux/compiler.h>
 #include <linux/if_ether.h>
 #include <linux/jhash.h>
+#include <linux/kref.h>
 #include <linux/netlink.h>
 #include <linux/seq_file.h>
 #include <linux/skbuff.h>
@@ -21,19 +22,18 @@ bool batadv_compare_orig(const struct hl
 int batadv_originator_init(struct batadv_priv *bat_priv);
 void batadv_originator_free(struct batadv_priv *bat_priv);
 void batadv_purge_orig_ref(struct batadv_priv *bat_priv);
-void batadv_orig_node_put(struct batadv_orig_node *orig_node);
+void batadv_orig_node_release(struct kref *ref);
 struct batadv_orig_node *batadv_orig_node_new(struct batadv_priv *bat_priv,
 					      const u8 *addr);
 struct batadv_hardif_neigh_node *
 batadv_hardif_neigh_get(const struct batadv_hard_iface *hard_iface,
 			const u8 *neigh_addr);
-void
-batadv_hardif_neigh_put(struct batadv_hardif_neigh_node *hardif_neigh);
+void batadv_hardif_neigh_release(struct kref *ref);
 struct batadv_neigh_node *
 batadv_neigh_node_get_or_create(struct batadv_orig_node *orig_node,
 				struct batadv_hard_iface *hard_iface,
 				const u8 *neigh_addr);
-void batadv_neigh_node_put(struct batadv_neigh_node *neigh_node);
+void batadv_neigh_node_release(struct kref *ref);
 struct batadv_neigh_node *
 batadv_orig_router_get(struct batadv_orig_node *orig_node,
 		       const struct batadv_hard_iface *if_outgoing);
@@ -43,7 +43,7 @@ batadv_neigh_ifinfo_new(struct batadv_ne
 struct batadv_neigh_ifinfo *
 batadv_neigh_ifinfo_get(struct batadv_neigh_node *neigh,
 			struct batadv_hard_iface *if_outgoing);
-void batadv_neigh_ifinfo_put(struct batadv_neigh_ifinfo *neigh_ifinfo);
+void batadv_neigh_ifinfo_release(struct kref *ref);
 
 int batadv_hardif_neigh_dump(struct sk_buff *msg, struct netlink_callback *cb);
 int batadv_hardif_neigh_seq_print_text(struct seq_file *seq, void *offset);
@@ -54,7 +54,7 @@ batadv_orig_ifinfo_get(struct batadv_ori
 struct batadv_orig_ifinfo *
 batadv_orig_ifinfo_new(struct batadv_orig_node *orig_node,
 		       struct batadv_hard_iface *if_outgoing);
-void batadv_orig_ifinfo_put(struct batadv_orig_ifinfo *orig_ifinfo);
+void batadv_orig_ifinfo_release(struct kref *ref);
 
 int batadv_orig_seq_print_text(struct seq_file *seq, void *offset);
 int batadv_orig_dump(struct sk_buff *msg, struct netlink_callback *cb);
@@ -65,7 +65,7 @@ batadv_orig_node_vlan_new(struct batadv_
 struct batadv_orig_node_vlan *
 batadv_orig_node_vlan_get(struct batadv_orig_node *orig_node,
 			  unsigned short vid);
-void batadv_orig_node_vlan_put(struct batadv_orig_node_vlan *orig_vlan);
+void batadv_orig_node_vlan_release(struct kref *ref);
 
 /**
  * batadv_choose_orig() - Return the index of the orig entry in the hash table
@@ -86,4 +86,86 @@ static inline u32 batadv_choose_orig(con
 struct batadv_orig_node *
 batadv_orig_hash_find(struct batadv_priv *bat_priv, const void *data);
 
+/**
+ * batadv_orig_node_vlan_put() - decrement the refcounter and possibly release
+ *  the originator-vlan object
+ * @orig_vlan: the originator-vlan object to release
+ */
+static inline void
+batadv_orig_node_vlan_put(struct batadv_orig_node_vlan *orig_vlan)
+{
+	if (!orig_vlan)
+		return;
+
+	kref_put(&orig_vlan->refcount, batadv_orig_node_vlan_release);
+}
+
+/**
+ * batadv_neigh_ifinfo_put() - decrement the refcounter and possibly release
+ *  the neigh_ifinfo
+ * @neigh_ifinfo: the neigh_ifinfo object to release
+ */
+static inline void
+batadv_neigh_ifinfo_put(struct batadv_neigh_ifinfo *neigh_ifinfo)
+{
+	if (!neigh_ifinfo)
+		return;
+
+	kref_put(&neigh_ifinfo->refcount, batadv_neigh_ifinfo_release);
+}
+
+/**
+ * batadv_hardif_neigh_put() - decrement the hardif neighbors refcounter
+ *  and possibly release it
+ * @hardif_neigh: hardif neigh neighbor to free
+ */
+static inline void
+batadv_hardif_neigh_put(struct batadv_hardif_neigh_node *hardif_neigh)
+{
+	if (!hardif_neigh)
+		return;
+
+	kref_put(&hardif_neigh->refcount, batadv_hardif_neigh_release);
+}
+
+/**
+ * batadv_neigh_node_put() - decrement the neighbors refcounter and possibly
+ *  release it
+ * @neigh_node: neigh neighbor to free
+ */
+static inline void batadv_neigh_node_put(struct batadv_neigh_node *neigh_node)
+{
+	if (!neigh_node)
+		return;
+
+	kref_put(&neigh_node->refcount, batadv_neigh_node_release);
+}
+
+/**
+ * batadv_orig_ifinfo_put() - decrement the refcounter and possibly release
+ *  the orig_ifinfo
+ * @orig_ifinfo: the orig_ifinfo object to release
+ */
+static inline void
+batadv_orig_ifinfo_put(struct batadv_orig_ifinfo *orig_ifinfo)
+{
+	if (!orig_ifinfo)
+		return;
+
+	kref_put(&orig_ifinfo->refcount, batadv_orig_ifinfo_release);
+}
+
+/**
+ * batadv_orig_node_put() - decrement the orig node refcounter and possibly
+ *  release it
+ * @orig_node: the orig node to free
+ */
+static inline void batadv_orig_node_put(struct batadv_orig_node *orig_node)
+{
+	if (!orig_node)
+		return;
+
+	kref_put(&orig_node->refcount, batadv_orig_node_release);
+}
+
 #endif /* _NET_BATMAN_ADV_ORIGINATOR_H_ */
--- a/net/batman-adv/soft-interface.c
+++ b/net/batman-adv/soft-interface.c
@@ -512,7 +512,7 @@ out:
  *  after rcu grace period
  * @ref: kref pointer of the vlan object
  */
-static void batadv_softif_vlan_release(struct kref *ref)
+void batadv_softif_vlan_release(struct kref *ref)
 {
 	struct batadv_softif_vlan *vlan;
 
@@ -526,19 +526,6 @@ static void batadv_softif_vlan_release(s
 }
 
 /**
- * batadv_softif_vlan_put() - decrease the vlan object refcounter and
- *  possibly release it
- * @vlan: the vlan object to release
- */
-void batadv_softif_vlan_put(struct batadv_softif_vlan *vlan)
-{
-	if (!vlan)
-		return;
-
-	kref_put(&vlan->refcount, batadv_softif_vlan_release);
-}
-
-/**
  * batadv_softif_vlan_get() - get the vlan object for a specific vid
  * @bat_priv: the bat priv with all the soft interface information
  * @vid: the identifier of the vlan object to retrieve
--- a/net/batman-adv/soft-interface.h
+++ b/net/batman-adv/soft-interface.h
@@ -9,6 +9,7 @@
 
 #include "main.h"
 
+#include <linux/kref.h>
 #include <linux/netdevice.h>
 #include <linux/skbuff.h>
 #include <linux/types.h>
@@ -24,8 +25,21 @@ void batadv_softif_destroy_sysfs(struct
 bool batadv_softif_is_valid(const struct net_device *net_dev);
 extern struct rtnl_link_ops batadv_link_ops;
 int batadv_softif_create_vlan(struct batadv_priv *bat_priv, unsigned short vid);
-void batadv_softif_vlan_put(struct batadv_softif_vlan *softif_vlan);
+void batadv_softif_vlan_release(struct kref *ref);
 struct batadv_softif_vlan *batadv_softif_vlan_get(struct batadv_priv *bat_priv,
 						  unsigned short vid);
 
+/**
+ * batadv_softif_vlan_put() - decrease the vlan object refcounter and
+ *  possibly release it
+ * @vlan: the vlan object to release
+ */
+static inline void batadv_softif_vlan_put(struct batadv_softif_vlan *vlan)
+{
+	if (!vlan)
+		return;
+
+	kref_put(&vlan->refcount, batadv_softif_vlan_release);
+}
+
 #endif /* _NET_BATMAN_ADV_SOFT_INTERFACE_H_ */
--- a/net/batman-adv/tp_meter.c
+++ b/net/batman-adv/tp_meter.c
@@ -357,6 +357,9 @@ static void batadv_tp_vars_release(struc
  */
 static void batadv_tp_vars_put(struct batadv_tp_vars *tp_vars)
 {
+	if (!tp_vars)
+		return;
+
 	kref_put(&tp_vars->refcount, batadv_tp_vars_release);
 }
 
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -248,6 +248,9 @@ static void batadv_tt_local_entry_releas
 static void
 batadv_tt_local_entry_put(struct batadv_tt_local_entry *tt_local_entry)
 {
+	if (!tt_local_entry)
+		return;
+
 	kref_put(&tt_local_entry->common.refcount,
 		 batadv_tt_local_entry_release);
 }
@@ -271,7 +274,7 @@ static void batadv_tt_global_entry_free_
  *  queue for free after rcu grace period
  * @ref: kref pointer of the nc_node
  */
-static void batadv_tt_global_entry_release(struct kref *ref)
+void batadv_tt_global_entry_release(struct kref *ref)
 {
 	struct batadv_tt_global_entry *tt_global_entry;
 
@@ -284,17 +287,6 @@ static void batadv_tt_global_entry_relea
 }
 
 /**
- * batadv_tt_global_entry_put() - decrement the tt_global_entry refcounter and
- *  possibly release it
- * @tt_global_entry: tt_global_entry to be free'd
- */
-void batadv_tt_global_entry_put(struct batadv_tt_global_entry *tt_global_entry)
-{
-	kref_put(&tt_global_entry->common.refcount,
-		 batadv_tt_global_entry_release);
-}
-
-/**
  * batadv_tt_global_hash_count() - count the number of orig entries
  * @bat_priv: the bat priv with all the soft interface information
  * @addr: the mac address of the client to count entries for
@@ -453,6 +445,9 @@ static void batadv_tt_orig_list_entry_re
 static void
 batadv_tt_orig_list_entry_put(struct batadv_tt_orig_list_entry *orig_entry)
 {
+	if (!orig_entry)
+		return;
+
 	kref_put(&orig_entry->refcount, batadv_tt_orig_list_entry_release);
 }
 
@@ -2818,6 +2813,9 @@ static void batadv_tt_req_node_release(s
  */
 static void batadv_tt_req_node_put(struct batadv_tt_req_node *tt_req_node)
 {
+	if (!tt_req_node)
+		return;
+
 	kref_put(&tt_req_node->refcount, batadv_tt_req_node_release);
 }
 
--- a/net/batman-adv/translation-table.h
+++ b/net/batman-adv/translation-table.h
@@ -9,6 +9,7 @@
 
 #include "main.h"
 
+#include <linux/kref.h>
 #include <linux/netdevice.h>
 #include <linux/netlink.h>
 #include <linux/seq_file.h>
@@ -31,7 +32,7 @@ void batadv_tt_global_del_orig(struct ba
 struct batadv_tt_global_entry *
 batadv_tt_global_hash_find(struct batadv_priv *bat_priv, const u8 *addr,
 			   unsigned short vid);
-void batadv_tt_global_entry_put(struct batadv_tt_global_entry *tt_global_entry);
+void batadv_tt_global_entry_release(struct kref *ref);
 int batadv_tt_global_hash_count(struct batadv_priv *bat_priv,
 				const u8 *addr, unsigned short vid);
 struct batadv_orig_node *batadv_transtable_search(struct batadv_priv *bat_priv,
@@ -58,4 +59,19 @@ bool batadv_tt_global_is_isolated(struct
 int batadv_tt_cache_init(void);
 void batadv_tt_cache_destroy(void);
 
+/**
+ * batadv_tt_global_entry_put() - decrement the tt_global_entry refcounter and
+ *  possibly release it
+ * @tt_global_entry: tt_global_entry to be free'd
+ */
+static inline void
+batadv_tt_global_entry_put(struct batadv_tt_global_entry *tt_global_entry)
+{
+	if (!tt_global_entry)
+		return;
+
+	kref_put(&tt_global_entry->common.refcount,
+		 batadv_tt_global_entry_release);
+}
+
 #endif /* _NET_BATMAN_ADV_TRANSLATION_TABLE_H_ */
--- a/net/batman-adv/tvlv.c
+++ b/net/batman-adv/tvlv.c
@@ -50,6 +50,9 @@ static void batadv_tvlv_handler_release(
  */
 static void batadv_tvlv_handler_put(struct batadv_tvlv_handler *tvlv_handler)
 {
+	if (!tvlv_handler)
+		return;
+
 	kref_put(&tvlv_handler->refcount, batadv_tvlv_handler_release);
 }
 
@@ -106,6 +109,9 @@ static void batadv_tvlv_container_releas
  */
 static void batadv_tvlv_container_put(struct batadv_tvlv_container *tvlv)
 {
+	if (!tvlv)
+		return;
+
 	kref_put(&tvlv->refcount, batadv_tvlv_container_release);
 }
 


