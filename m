Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1F881891F9
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 00:27:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbgCQX1x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 19:27:53 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:53462 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726934AbgCQX1x (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 19:27:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584487671;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qq8YEViknwrvOYYwuR3jqliC1dxWp/L4yQy2yYtPGbY=;
        b=ZB1zJDZ+n0D7v3EHRYfj3Vzx6SlrvLveEGIcakEp1W4VYbPBsCe0NQnFWUbrgrGXc3gJ+v
        SVn+gbMuPcjGRqA49Smqku9dP3xwO6htvjE9zw3IaWsJfIz0BvNxZRAPVdopITv7+IZMJT
        almF5EsyW1NZycRjwr4rhzit9rOfvG4=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     Sven Eckelmann <sven@narfation.org>,
        Antonio Quartulli <a@unstable.cc>,
        Marek Lindner <mareklindner@neomailbox.ch>
Subject: [PATCH 4.4 10/48] batman-adv: Fix reference counting of vlan object for tt_local_entry
Date:   Wed, 18 Mar 2020 00:26:56 +0100
Message-Id: <20200317232734.6127-11-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200317232734.6127-1-sven@narfation.org>
References: <20200317232734.6127-1-sven@narfation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit a33d970d0b54b09746d5540af8271fad4eb10229 upstream.

The batadv_tt_local_entry was specific to a batadv_softif_vlan and held an
implicit reference to it. But this reference was never stored in form of a
pointer in the tt_local_entry itself. Instead batadv_tt_local_remove,
batadv_tt_local_table_free and batadv_tt_local_purge_pending_clients depend
on a consistent state of bat_priv->softif_vlan_list and that
batadv_softif_vlan_get always returns the batadv_softif_vlan object which
it has a reference for. But batadv_softif_vlan_get cannot guarantee that
because it is working only with rcu_read_lock on this list. It can
therefore happen that an vid is in this list twice or that
batadv_softif_vlan_get cannot find the batadv_softif_vlan for an vid due to
some other list operations taking place at the same time.

Instead add a batadv_softif_vlan pointer directly in batadv_tt_local_entry
which will be used for the reference counter decremented on release of
batadv_tt_local_entry.

Fixes: 35df3b298fc8 ("batman-adv: fix TT VLAN inconsistency on VLAN re-add")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Acked-by: Antonio Quartulli <a@unstable.cc>
Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
Signed-off-by: Antonio Quartulli <a@unstable.cc>
---
 net/batman-adv/translation-table.c | 44 ++++--------------------------
 net/batman-adv/types.h             |  2 ++
 2 files changed, 7 insertions(+), 39 deletions(-)

diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index 117febee5fa6..4014e5130879 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -197,8 +197,11 @@ batadv_tt_global_hash_find(struct batadv_priv *bat_priv, const u8 *addr,
 static void
 batadv_tt_local_entry_free_ref(struct batadv_tt_local_entry *tt_local_entry)
 {
-	if (atomic_dec_and_test(&tt_local_entry->common.refcount))
+	if (atomic_dec_and_test(&tt_local_entry->common.refcount)) {
+		batadv_softif_vlan_free_ref(tt_local_entry->vlan);
+
 		kfree_rcu(tt_local_entry, common.rcu);
+	}
 }
 
 /**
@@ -638,7 +641,6 @@ bool batadv_tt_local_add(struct net_device *soft_iface, const u8 *addr,
 	if (unlikely(hash_added != 0)) {
 		/* remove the reference for the hash */
 		batadv_tt_local_entry_free_ref(tt_local);
-		batadv_softif_vlan_free_ref(vlan);
 		goto out;
 	}
 
@@ -942,7 +944,6 @@ int batadv_tt_local_seq_print_text(struct seq_file *seq, void *offset)
 	struct batadv_tt_common_entry *tt_common_entry;
 	struct batadv_tt_local_entry *tt_local;
 	struct batadv_hard_iface *primary_if;
-	struct batadv_softif_vlan *vlan;
 	struct hlist_head *head;
 	unsigned short vid;
 	u32 i;
@@ -979,13 +980,6 @@ int batadv_tt_local_seq_print_text(struct seq_file *seq, void *offset)
 
 			no_purge = tt_common_entry->flags & np_flag;
 
-			vlan = batadv_softif_vlan_get(bat_priv, vid);
-			if (!vlan) {
-				seq_printf(seq, "Cannot retrieve VLAN %d\n",
-					   BATADV_PRINT_VID(vid));
-				continue;
-			}
-
 			seq_printf(seq,
 				   " * %pM %4i [%c%c%c%c%c%c] %3u.%03u   (%#.8x)\n",
 				   tt_common_entry->addr,
@@ -1003,9 +997,7 @@ int batadv_tt_local_seq_print_text(struct seq_file *seq, void *offset)
 				     BATADV_TT_CLIENT_ISOLA) ? 'I' : '.'),
 				   no_purge ? 0 : last_seen_secs,
 				   no_purge ? 0 : last_seen_msecs,
-				   vlan->tt.crc);
-
-			batadv_softif_vlan_free_ref(vlan);
+				   tt_local->vlan->tt.crc);
 		}
 		rcu_read_unlock();
 	}
@@ -1050,7 +1042,6 @@ u16 batadv_tt_local_remove(struct batadv_priv *bat_priv, const u8 *addr,
 {
 	struct batadv_tt_local_entry *tt_local_entry;
 	u16 flags, curr_flags = BATADV_NO_FLAGS;
-	struct batadv_softif_vlan *vlan;
 	void *tt_entry_exists;
 
 	tt_local_entry = batadv_tt_local_hash_find(bat_priv, addr, vid);
@@ -1090,14 +1081,6 @@ u16 batadv_tt_local_remove(struct batadv_priv *bat_priv, const u8 *addr,
 	/* extra call to free the local tt entry */
 	batadv_tt_local_entry_free_ref(tt_local_entry);
 
-	/* decrease the reference held for this vlan */
-	vlan = batadv_softif_vlan_get(bat_priv, vid);
-	if (!vlan)
-		goto out;
-
-	batadv_softif_vlan_free_ref(vlan);
-	batadv_softif_vlan_free_ref(vlan);
-
 out:
 	if (tt_local_entry)
 		batadv_tt_local_entry_free_ref(tt_local_entry);
@@ -1170,7 +1153,6 @@ static void batadv_tt_local_table_free(struct batadv_priv *bat_priv)
 	spinlock_t *list_lock; /* protects write access to the hash lists */
 	struct batadv_tt_common_entry *tt_common_entry;
 	struct batadv_tt_local_entry *tt_local;
-	struct batadv_softif_vlan *vlan;
 	struct hlist_node *node_tmp;
 	struct hlist_head *head;
 	u32 i;
@@ -1192,14 +1174,6 @@ static void batadv_tt_local_table_free(struct batadv_priv *bat_priv)
 						struct batadv_tt_local_entry,
 						common);
 
-			/* decrease the reference held for this vlan */
-			vlan = batadv_softif_vlan_get(bat_priv,
-						      tt_common_entry->vid);
-			if (vlan) {
-				batadv_softif_vlan_free_ref(vlan);
-				batadv_softif_vlan_free_ref(vlan);
-			}
-
 			batadv_tt_local_entry_free_ref(tt_local);
 		}
 		spin_unlock_bh(list_lock);
@@ -3229,7 +3203,6 @@ static void batadv_tt_local_purge_pending_clients(struct batadv_priv *bat_priv)
 	struct batadv_hashtable *hash = bat_priv->tt.local_hash;
 	struct batadv_tt_common_entry *tt_common;
 	struct batadv_tt_local_entry *tt_local;
-	struct batadv_softif_vlan *vlan;
 	struct hlist_node *node_tmp;
 	struct hlist_head *head;
 	spinlock_t *list_lock; /* protects write access to the hash lists */
@@ -3259,13 +3232,6 @@ static void batadv_tt_local_purge_pending_clients(struct batadv_priv *bat_priv)
 						struct batadv_tt_local_entry,
 						common);
 
-			/* decrease the reference held for this vlan */
-			vlan = batadv_softif_vlan_get(bat_priv, tt_common->vid);
-			if (vlan) {
-				batadv_softif_vlan_free_ref(vlan);
-				batadv_softif_vlan_free_ref(vlan);
-			}
-
 			batadv_tt_local_entry_free_ref(tt_local);
 		}
 		spin_unlock_bh(list_lock);
diff --git a/net/batman-adv/types.h b/net/batman-adv/types.h
index cbd347c2e4a5..dcf285fae2e6 100644
--- a/net/batman-adv/types.h
+++ b/net/batman-adv/types.h
@@ -947,10 +947,12 @@ struct batadv_tt_common_entry {
  * struct batadv_tt_local_entry - translation table local entry data
  * @common: general translation table data
  * @last_seen: timestamp used for purging stale tt local entries
+ * @vlan: soft-interface vlan of the entry
  */
 struct batadv_tt_local_entry {
 	struct batadv_tt_common_entry common;
 	unsigned long last_seen;
+	struct batadv_softif_vlan *vlan;
 };
 
 /**
-- 
2.20.1

