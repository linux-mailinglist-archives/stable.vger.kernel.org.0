Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18DD018B791
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:34:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729052AbgCSNM7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:12:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:59576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729021AbgCSNM7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:12:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B920215A4;
        Thu, 19 Mar 2020 13:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623578;
        bh=JuW9RWEn+7NdyIv+I+mV1pt2r3wYlQSP1gc80Cfe0Yc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uT2ettCYfopRQ7tq7EPljvNCrhI5bVwEcwBJ7DdsD2OdGpGnYaYskoZekozpq2lOE
         eclDulLtK9+DuT/u1xvFblNbDIa+h9c4SSzv7uBBTqMjkY0OETTo+HdaDVa7Vntcrn
         rntvld3qJIyTJPYEcgtOB99aT0TQrCEpPpJPOr4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?Linus=20L=FCssing?= <linus.luessing@c0d3.blue>,
        Antonio Quartulli <a@unstable.cc>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.9 57/90] batman-adv: fix TT sync flag inconsistencies
Date:   Thu, 19 Mar 2020 14:00:19 +0100
Message-Id: <20200319123945.984996412@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123928.635114118@linuxfoundation.org>
References: <20200319123928.635114118@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus L�ssing <linus.luessing@c0d3.blue>

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
Signed-off-by: Linus L�ssing <linus.luessing@c0d3.blue>
Acked-by: Antonio Quartulli <a@unstable.cc>
[sw: typo in commit message]
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/translation-table.c |   60 +++++++++++++++++++++++++++++++------
 net/batman-adv/types.h             |    2 +
 2 files changed, 53 insertions(+), 9 deletions(-)

--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -1560,9 +1560,41 @@ batadv_tt_global_entry_has_orig(const st
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
 
@@ -1574,7 +1606,8 @@ batadv_tt_global_orig_entry_add(struct b
 		 * was added during a "temporary client detection"
 		 */
 		orig_entry->ttvn = ttvn;
-		goto out;
+		orig_entry->flags = flags;
+		goto sync_flags;
 	}
 
 	orig_entry = kmem_cache_zalloc(batadv_tt_orig_cache, GFP_ATOMIC);
@@ -1586,6 +1619,7 @@ batadv_tt_global_orig_entry_add(struct b
 	batadv_tt_global_size_inc(orig_node, tt_global->common.vid);
 	orig_entry->orig_node = orig_node;
 	orig_entry->ttvn = ttvn;
+	orig_entry->flags = flags;
 	kref_init(&orig_entry->refcount);
 
 	kref_get(&orig_entry->refcount);
@@ -1593,6 +1627,8 @@ batadv_tt_global_orig_entry_add(struct b
 			   &tt_global->orig_list);
 	atomic_inc(&tt_global->orig_list_count);
 
+sync_flags:
+	batadv_tt_global_sync_flags(tt_global);
 out:
 	if (orig_entry)
 		batadv_tt_orig_list_entry_put(orig_entry);
@@ -1716,10 +1752,10 @@ static bool batadv_tt_global_add(struct
 		}
 
 		/* the change can carry possible "attribute" flags like the
-		 * TT_CLIENT_WIFI, therefore they have to be copied in the
+		 * TT_CLIENT_TEMP, therefore they have to be copied in the
 		 * client entry
 		 */
-		common->flags |= flags;
+		common->flags |= flags & (~BATADV_TT_SYNC_MASK);
 
 		/* If there is the BATADV_TT_CLIENT_ROAM flag set, there is only
 		 * one originator left in the list and we previously received a
@@ -1736,7 +1772,8 @@ static bool batadv_tt_global_add(struct
 	}
 add_orig_entry:
 	/* add the new orig_entry (if needed) or update it */
-	batadv_tt_global_orig_entry_add(tt_global_entry, orig_node, ttvn);
+	batadv_tt_global_orig_entry_add(tt_global_entry, orig_node, ttvn,
+					flags & BATADV_TT_SYNC_MASK);
 
 	batadv_dbg(BATADV_DBG_TT, bat_priv,
 		   "Creating new global tt entry: %pM (vid: %d, via %pM)\n",
@@ -1959,6 +1996,7 @@ batadv_tt_global_dump_subentry(struct sk
 			       struct batadv_tt_orig_list_entry *orig,
 			       bool best)
 {
+	u16 flags = (common->flags & (~BATADV_TT_SYNC_MASK)) | orig->flags;
 	void *hdr;
 	struct batadv_orig_node_vlan *vlan;
 	u8 last_ttvn;
@@ -1988,7 +2026,7 @@ batadv_tt_global_dump_subentry(struct sk
 	    nla_put_u8(msg, BATADV_ATTR_TT_LAST_TTVN, last_ttvn) ||
 	    nla_put_u32(msg, BATADV_ATTR_TT_CRC32, crc) ||
 	    nla_put_u16(msg, BATADV_ATTR_TT_VID, common->vid) ||
-	    nla_put_u32(msg, BATADV_ATTR_TT_FLAGS, common->flags))
+	    nla_put_u32(msg, BATADV_ATTR_TT_FLAGS, flags))
 		goto nla_put_failure;
 
 	if (best && nla_put_flag(msg, BATADV_ATTR_FLAG_BEST))
@@ -2602,6 +2640,7 @@ static u32 batadv_tt_global_crc(struct b
 				unsigned short vid)
 {
 	struct batadv_hashtable *hash = bat_priv->tt.global_hash;
+	struct batadv_tt_orig_list_entry *tt_orig;
 	struct batadv_tt_common_entry *tt_common;
 	struct batadv_tt_global_entry *tt_global;
 	struct hlist_head *head;
@@ -2640,8 +2679,9 @@ static u32 batadv_tt_global_crc(struct b
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
@@ -2653,10 +2693,12 @@ static u32 batadv_tt_global_crc(struct b
 			/* compute the CRC on flags that have to be kept in sync
 			 * among nodes
 			 */
-			flags = tt_common->flags & BATADV_TT_SYNC_MASK;
+			flags = tt_orig->flags;
 			crc_tmp = crc32c(crc_tmp, &flags, sizeof(flags));
 
 			crc ^= crc32c(crc_tmp, tt_common->addr, ETH_ALEN);
+
+			batadv_tt_orig_list_entry_put(tt_orig);
 		}
 		rcu_read_unlock();
 	}
--- a/net/batman-adv/types.h
+++ b/net/batman-adv/types.h
@@ -1241,6 +1241,7 @@ struct batadv_tt_global_entry {
  * struct batadv_tt_orig_list_entry - orig node announcing a non-mesh client
  * @orig_node: pointer to orig node announcing this non-mesh client
  * @ttvn: translation table version number which added the non-mesh client
+ * @flags: per orig entry TT sync flags
  * @list: list node for batadv_tt_global_entry::orig_list
  * @refcount: number of contexts the object is used
  * @rcu: struct used for freeing in an RCU-safe manner
@@ -1248,6 +1249,7 @@ struct batadv_tt_global_entry {
 struct batadv_tt_orig_list_entry {
 	struct batadv_orig_node *orig_node;
 	u8 ttvn;
+	u8 flags;
 	struct hlist_node list;
 	struct kref refcount;
 	struct rcu_head rcu;


