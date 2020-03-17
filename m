Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 682A518920D
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 00:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbgCQX2L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 19:28:11 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:53786 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727131AbgCQX2L (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 19:28:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584487689;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VK3Q6bGCo75m3HDeeSQjqiadlND9pDqnmKIZsMttjvA=;
        b=l1HfCcv9nVYKqNhbcbBipUv7Mi/sZMOnvptAuptEBLZmYaSa2+KEM+UpYrMDGGBuUL6MK3
        OypJJpjkT5O3xPuwT8kYXjmdaHbRgFP+IiXMo6c/1++TXxt5ufhT+MYug7VP9PPIQ6RkjZ
        6ykyHwzthfzKIBZtOqa0E8mrgEpIoA0=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>,
        Antonio Quartulli <a@unstable.cc>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 4.4 28/48] batman-adv: fix TT sync flag inconsistencies
Date:   Wed, 18 Mar 2020 00:27:14 +0100
Message-Id: <20200317232734.6127-29-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200317232734.6127-1-sven@narfation.org>
References: <20200317232734.6127-1-sven@narfation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Lüssing <linus.luessing@c0d3.blue>

commit 54e22f265e872ae140755b3318521d400a094605 upstream.

This patch fixes an issue in the translation table code potentially
leading to a TT Request + Response storm. The issue may occur for nodes
involving BLA and an inconsistent configuration of the batman-adv AP
isolation feature. However, since the new multicast optimizations, a
single, malformed packet may lead to a mesh-wide, persistent
Denial-of-Service, too.

The issue occurs because nodes are currently OR-ing the TT sync flags of
all originators announcing a specific MAC address via the
translation table. When an intermediate node now receives a TT Request
and wants to answer this on behalf of the destination node, then this
intermediate node now responds with an altered flag field and broken
CRC. The next OGM of the real destination will lead to a CRC mismatch
and triggering a TT Request and Response again.

Furthermore, the OR-ing is currently never undone as long as at least
one originator announcing the according MAC address remains, leading to
the potential persistency of this issue.

This patch fixes this issue by storing the flags used in the CRC
calculation on a a per TT orig entry basis to be able to respond with
the correct, original flags in an intermediate TT Response for one
thing. And to be able to correctly unset sync flags once all nodes
announcing a sync flag vanish for another.

Fixes: e9c00136a475 ("batman-adv: fix tt_global_entries flags update")
Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
Acked-by: Antonio Quartulli <a@unstable.cc>
[sw: typo in commit message]
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
---
 net/batman-adv/translation-table.c | 55 ++++++++++++++++++++++++++----
 net/batman-adv/types.h             |  2 ++
 2 files changed, 50 insertions(+), 7 deletions(-)

diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index a30a77d1a220..43f6d546a67e 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -1263,9 +1263,41 @@ batadv_tt_global_entry_has_orig(const struct batadv_tt_global_entry *entry,
 	return found;
 }
 
+/**
+ * batadv_tt_global_sync_flags - update TT sync flags
+ * @tt_global: the TT global entry to update sync flags in
+ *
+ * Updates the sync flag bits in the tt_global flag attribute with a logical
+ * OR of all sync flags from any of its TT orig entries.
+ */
+static void
+batadv_tt_global_sync_flags(struct batadv_tt_global_entry *tt_global)
+{
+	struct batadv_tt_orig_list_entry *orig_entry;
+	const struct hlist_head *head;
+	u16 flags = BATADV_NO_FLAGS;
+
+	rcu_read_lock();
+	head = &tt_global->orig_list;
+	hlist_for_each_entry_rcu(orig_entry, head, list)
+		flags |= orig_entry->flags;
+	rcu_read_unlock();
+
+	flags |= tt_global->common.flags & (~BATADV_TT_SYNC_MASK);
+	tt_global->common.flags = flags;
+}
+
+/**
+ * batadv_tt_global_orig_entry_add - add or update a TT orig entry
+ * @tt_global: the TT global entry to add an orig entry in
+ * @orig_node: the originator to add an orig entry for
+ * @ttvn: translation table version number of this changeset
+ * @flags: TT sync flags
+ */
 static void
 batadv_tt_global_orig_entry_add(struct batadv_tt_global_entry *tt_global,
-				struct batadv_orig_node *orig_node, int ttvn)
+				struct batadv_orig_node *orig_node, int ttvn,
+				u8 flags)
 {
 	struct batadv_tt_orig_list_entry *orig_entry;
 
@@ -1275,7 +1307,8 @@ batadv_tt_global_orig_entry_add(struct batadv_tt_global_entry *tt_global,
 		 * was added during a "temporary client detection"
 		 */
 		orig_entry->ttvn = ttvn;
-		goto out;
+		orig_entry->flags = flags;
+		goto sync_flags;
 	}
 
 	orig_entry = kzalloc(sizeof(*orig_entry), GFP_ATOMIC);
@@ -1287,6 +1320,7 @@ batadv_tt_global_orig_entry_add(struct batadv_tt_global_entry *tt_global,
 	batadv_tt_global_size_inc(orig_node, tt_global->common.vid);
 	orig_entry->orig_node = orig_node;
 	orig_entry->ttvn = ttvn;
+	orig_entry->flags = flags;
 	atomic_set(&orig_entry->refcount, 2);
 
 	spin_lock_bh(&tt_global->list_lock);
@@ -1295,6 +1329,8 @@ batadv_tt_global_orig_entry_add(struct batadv_tt_global_entry *tt_global,
 	spin_unlock_bh(&tt_global->list_lock);
 	atomic_inc(&tt_global->orig_list_count);
 
+sync_flags:
+	batadv_tt_global_sync_flags(tt_global);
 out:
 	if (orig_entry)
 		batadv_tt_orig_list_entry_free_ref(orig_entry);
@@ -1417,7 +1453,7 @@ static bool batadv_tt_global_add(struct batadv_priv *bat_priv,
 		 * TT_CLIENT_WIFI, therefore they have to be copied in the
 		 * client entry
 		 */
-		tt_global_entry->common.flags |= flags;
+		tt_global_entry->common.flags |= flags & (~BATADV_TT_SYNC_MASK);
 
 		/* If there is the BATADV_TT_CLIENT_ROAM flag set, there is only
 		 * one originator left in the list and we previously received a
@@ -1434,7 +1470,8 @@ static bool batadv_tt_global_add(struct batadv_priv *bat_priv,
 	}
 add_orig_entry:
 	/* add the new orig_entry (if needed) or update it */
-	batadv_tt_global_orig_entry_add(tt_global_entry, orig_node, ttvn);
+	batadv_tt_global_orig_entry_add(tt_global_entry, orig_node, ttvn,
+					flags & BATADV_TT_SYNC_MASK);
 
 	batadv_dbg(BATADV_DBG_TT, bat_priv,
 		   "Creating new global tt entry: %pM (vid: %d, via %pM)\n",
@@ -2087,6 +2124,7 @@ static u32 batadv_tt_global_crc(struct batadv_priv *bat_priv,
 				unsigned short vid)
 {
 	struct batadv_hashtable *hash = bat_priv->tt.global_hash;
+	struct batadv_tt_orig_list_entry *tt_orig;
 	struct batadv_tt_common_entry *tt_common;
 	struct batadv_tt_global_entry *tt_global;
 	struct hlist_head *head;
@@ -2125,8 +2163,9 @@ static u32 batadv_tt_global_crc(struct batadv_priv *bat_priv,
 			/* find out if this global entry is announced by this
 			 * originator
 			 */
-			if (!batadv_tt_global_entry_has_orig(tt_global,
-							     orig_node))
+			tt_orig = batadv_tt_global_orig_entry_find(tt_global,
+								   orig_node);
+			if (!tt_orig)
 				continue;
 
 			/* use network order to read the VID: this ensures that
@@ -2138,10 +2177,12 @@ static u32 batadv_tt_global_crc(struct batadv_priv *bat_priv,
 			/* compute the CRC on flags that have to be kept in sync
 			 * among nodes
 			 */
-			flags = tt_common->flags & BATADV_TT_SYNC_MASK;
+			flags = tt_orig->flags;
 			crc_tmp = crc32c(crc_tmp, &flags, sizeof(flags));
 
 			crc ^= crc32c(crc_tmp, tt_common->addr, ETH_ALEN);
+
+			batadv_tt_orig_list_entry_free_ref(tt_orig);
 		}
 		rcu_read_unlock();
 	}
diff --git a/net/batman-adv/types.h b/net/batman-adv/types.h
index 375c27a68cbc..630777a93cdd 100644
--- a/net/batman-adv/types.h
+++ b/net/batman-adv/types.h
@@ -980,6 +980,7 @@ struct batadv_tt_global_entry {
  * struct batadv_tt_orig_list_entry - orig node announcing a non-mesh client
  * @orig_node: pointer to orig node announcing this non-mesh client
  * @ttvn: translation table version number which added the non-mesh client
+ * @flags: per orig entry TT sync flags
  * @list: list node for batadv_tt_global_entry::orig_list
  * @refcount: number of contexts the object is used
  * @rcu: struct used for freeing in an RCU-safe manner
@@ -987,6 +988,7 @@ struct batadv_tt_global_entry {
 struct batadv_tt_orig_list_entry {
 	struct batadv_orig_node *orig_node;
 	u8 ttvn;
+	u8 flags;
 	struct hlist_node list;
 	atomic_t refcount;
 	struct rcu_head rcu;
-- 
2.20.1

