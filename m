Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 374A118B425
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbgCSNG6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:06:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:50420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727801AbgCSNG6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:06:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB3E920774;
        Thu, 19 Mar 2020 13:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623217;
        bh=euP/WgkghCca+zFiL7MPcQhityGcjNh5BaHRFwBJaFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jRsUqpefzk3iRHlZYMS8abf40wz6rfnu2+K4B8Hi6DfXY+Z8oCwfnmWa0E2nNxwRd
         +bbx2+qcZENpI4ffdBN4YOixNr44DnhilAsZ2tkIYCesOsEgSGGARHlY9uRWyNeZk5
         tZStNbpHAxH1ka50F9YeKVRR/GWA0Jb6zIJZQyag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sven Eckelmann <sven@narfation.org>,
        Antonio Quartulli <a@unstable.cc>,
        Marek Lindner <mareklindner@neomailbox.ch>
Subject: [PATCH 4.4 47/93] batman-adv: Fix reference counting of vlan object for tt_local_entry
Date:   Thu, 19 Mar 2020 13:59:51 +0100
Message-Id: <20200319123940.028982114@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/translation-table.c |   44 ++++---------------------------------
 net/batman-adv/types.h             |    2 +
 2 files changed, 7 insertions(+), 39 deletions(-)

--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -197,8 +197,11 @@ batadv_tt_global_hash_find(struct batadv
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
@@ -638,7 +641,6 @@ bool batadv_tt_local_add(struct net_devi
 	if (unlikely(hash_added != 0)) {
 		/* remove the reference for the hash */
 		batadv_tt_local_entry_free_ref(tt_local);
-		batadv_softif_vlan_free_ref(vlan);
 		goto out;
 	}
 
@@ -942,7 +944,6 @@ int batadv_tt_local_seq_print_text(struc
 	struct batadv_tt_common_entry *tt_common_entry;
 	struct batadv_tt_local_entry *tt_local;
 	struct batadv_hard_iface *primary_if;
-	struct batadv_softif_vlan *vlan;
 	struct hlist_head *head;
 	unsigned short vid;
 	u32 i;
@@ -979,13 +980,6 @@ int batadv_tt_local_seq_print_text(struc
 
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
@@ -1003,9 +997,7 @@ int batadv_tt_local_seq_print_text(struc
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
@@ -1050,7 +1042,6 @@ u16 batadv_tt_local_remove(struct batadv
 {
 	struct batadv_tt_local_entry *tt_local_entry;
 	u16 flags, curr_flags = BATADV_NO_FLAGS;
-	struct batadv_softif_vlan *vlan;
 	void *tt_entry_exists;
 
 	tt_local_entry = batadv_tt_local_hash_find(bat_priv, addr, vid);
@@ -1090,14 +1081,6 @@ u16 batadv_tt_local_remove(struct batadv
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
@@ -1170,7 +1153,6 @@ static void batadv_tt_local_table_free(s
 	spinlock_t *list_lock; /* protects write access to the hash lists */
 	struct batadv_tt_common_entry *tt_common_entry;
 	struct batadv_tt_local_entry *tt_local;
-	struct batadv_softif_vlan *vlan;
 	struct hlist_node *node_tmp;
 	struct hlist_head *head;
 	u32 i;
@@ -1192,14 +1174,6 @@ static void batadv_tt_local_table_free(s
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
@@ -3229,7 +3203,6 @@ static void batadv_tt_local_purge_pendin
 	struct batadv_hashtable *hash = bat_priv->tt.local_hash;
 	struct batadv_tt_common_entry *tt_common;
 	struct batadv_tt_local_entry *tt_local;
-	struct batadv_softif_vlan *vlan;
 	struct hlist_node *node_tmp;
 	struct hlist_head *head;
 	spinlock_t *list_lock; /* protects write access to the hash lists */
@@ -3259,13 +3232,6 @@ static void batadv_tt_local_purge_pendin
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


