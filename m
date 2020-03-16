Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA2CE187594
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 23:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732800AbgCPWa7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 18:30:59 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:48916 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732795AbgCPWa6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 18:30:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584397856;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tR8c52kxcETks2zqNRD/yWP1cf0Kew/R4xkABIdf59c=;
        b=0V/MAk3oLg+UFAqGEzlOQv4Mmtb33jvC0oRXZLkn9xlq+NBVQjwe78xQ/At9HMNolNb/xT
        Pzxe/eayFKgMszW0g2TUmnvLpb9FW2LcHRgzWLOLhRkNRoaWI41mnJhW1W5Gzea5Zyn0eL
        UxhcjW1Lf7d+/rolYYH8FiqnBYc/iUQ=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>,
        =?UTF-8?q?Leonardo=20M=C3=B6rlein?= <me@irrelefant.net>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.14 08/15] batman-adv: Fix TT sync flags for intermediate TT responses
Date:   Mon, 16 Mar 2020 23:30:25 +0100
Message-Id: <20200316223032.6236-9-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200316223032.6236-1-sven@narfation.org>
References: <20200316223032.6236-1-sven@narfation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Lüssing <linus.luessing@c0d3.blue>

commit 7072337e52b3e9d5460500d8dc9cbc1ba2db084c upstream.

The previous TT sync fix so far only fixed TT responses issued by the
target node directly. So far, TT responses issued by intermediate nodes
still lead to the wrong flags being added, leading to CRC mismatches.

This behaviour was observed at Freifunk Hannover in a 800 nodes setup
where a considerable amount of nodes were still infected with 'WI'
TT flags even with (most) nodes having the previous TT sync fix applied.

I was able to reproduce the issue with intermediate TT responses in a
four node test setup and this patch fixes this issue by ensuring to
use the per originator instead of the summarized, OR'd ones.

Fixes: e9c00136a475 ("batman-adv: fix tt_global_entries flags update")
Reported-by: Leonardo Mörlein <me@irrelefant.net>
Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/translation-table.c | 61 +++++++++++++++++++++++++-----
 1 file changed, 51 insertions(+), 10 deletions(-)

diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index adc686087a26..c37611bea429 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -1544,6 +1544,8 @@ batadv_tt_global_orig_entry_find(const struct batadv_tt_global_entry *entry,
  *  by a given originator
  * @entry: the TT global entry to check
  * @orig_node: the originator to search in the list
+ * @flags: a pointer to store TT flags for the given @entry received
+ *  from @orig_node
  *
  * find out if an orig_node is already in the list of a tt_global_entry.
  *
@@ -1551,7 +1553,8 @@ batadv_tt_global_orig_entry_find(const struct batadv_tt_global_entry *entry,
  */
 static bool
 batadv_tt_global_entry_has_orig(const struct batadv_tt_global_entry *entry,
-				const struct batadv_orig_node *orig_node)
+				const struct batadv_orig_node *orig_node,
+				u8 *flags)
 {
 	struct batadv_tt_orig_list_entry *orig_entry;
 	bool found = false;
@@ -1559,6 +1562,10 @@ batadv_tt_global_entry_has_orig(const struct batadv_tt_global_entry *entry,
 	orig_entry = batadv_tt_global_orig_entry_find(entry, orig_node);
 	if (orig_entry) {
 		found = true;
+
+		if (flags)
+			*flags = orig_entry->flags;
+
 		batadv_tt_orig_list_entry_put(orig_entry);
 	}
 
@@ -1741,7 +1748,7 @@ static bool batadv_tt_global_add(struct batadv_priv *bat_priv,
 			if (!(common->flags & BATADV_TT_CLIENT_TEMP))
 				goto out;
 			if (batadv_tt_global_entry_has_orig(tt_global_entry,
-							    orig_node))
+							    orig_node, NULL))
 				goto out_remove;
 			batadv_tt_global_del_orig_list(tt_global_entry);
 			goto add_orig_entry;
@@ -2884,23 +2891,46 @@ batadv_tt_req_node_new(struct batadv_priv *bat_priv,
 }
 
 /**
- * batadv_tt_local_valid - verify that given tt entry is a valid one
+ * batadv_tt_local_valid() - verify local tt entry and get flags
  * @entry_ptr: to be checked local tt entry
  * @data_ptr: not used but definition required to satisfy the callback prototype
+ * @flags: a pointer to store TT flags for this client to
+ *
+ * Checks the validity of the given local TT entry. If it is, then the provided
+ * flags pointer is updated.
  *
  * Return: true if the entry is a valid, false otherwise.
  */
-static bool batadv_tt_local_valid(const void *entry_ptr, const void *data_ptr)
+static bool batadv_tt_local_valid(const void *entry_ptr,
+				  const void *data_ptr,
+				  u8 *flags)
 {
 	const struct batadv_tt_common_entry *tt_common_entry = entry_ptr;
 
 	if (tt_common_entry->flags & BATADV_TT_CLIENT_NEW)
 		return false;
+
+	if (flags)
+		*flags = tt_common_entry->flags;
+
 	return true;
 }
 
+/**
+ * batadv_tt_global_valid() - verify global tt entry and get flags
+ * @entry_ptr: to be checked global tt entry
+ * @data_ptr: an orig_node object (may be NULL)
+ * @flags: a pointer to store TT flags for this client to
+ *
+ * Checks the validity of the given global TT entry. If it is, then the provided
+ * flags pointer is updated either with the common (summed) TT flags if data_ptr
+ * is NULL or the specific, per originator TT flags otherwise.
+ *
+ * Return: true if the entry is a valid, false otherwise.
+ */
 static bool batadv_tt_global_valid(const void *entry_ptr,
-				   const void *data_ptr)
+				   const void *data_ptr,
+				   u8 *flags)
 {
 	const struct batadv_tt_common_entry *tt_common_entry = entry_ptr;
 	const struct batadv_tt_global_entry *tt_global_entry;
@@ -2914,7 +2944,8 @@ static bool batadv_tt_global_valid(const void *entry_ptr,
 				       struct batadv_tt_global_entry,
 				       common);
 
-	return batadv_tt_global_entry_has_orig(tt_global_entry, orig_node);
+	return batadv_tt_global_entry_has_orig(tt_global_entry, orig_node,
+					       flags);
 }
 
 /**
@@ -2924,25 +2955,34 @@ static bool batadv_tt_global_valid(const void *entry_ptr,
  * @hash: hash table containing the tt entries
  * @tt_len: expected tvlv tt data buffer length in number of bytes
  * @tvlv_buff: pointer to the buffer to fill with the TT data
- * @valid_cb: function to filter tt change entries
+ * @valid_cb: function to filter tt change entries and to return TT flags
  * @cb_data: data passed to the filter function as argument
+ *
+ * Fills the tvlv buff with the tt entries from the specified hash. If valid_cb
+ * is not provided then this becomes a no-op.
  */
 static void batadv_tt_tvlv_generate(struct batadv_priv *bat_priv,
 				    struct batadv_hashtable *hash,
 				    void *tvlv_buff, u16 tt_len,
 				    bool (*valid_cb)(const void *,
-						     const void *),
+						     const void *,
+						     u8 *flags),
 				    void *cb_data)
 {
 	struct batadv_tt_common_entry *tt_common_entry;
 	struct batadv_tvlv_tt_change *tt_change;
 	struct hlist_head *head;
 	u16 tt_tot, tt_num_entries = 0;
+	u8 flags;
+	bool ret;
 	u32 i;
 
 	tt_tot = batadv_tt_entries(tt_len);
 	tt_change = (struct batadv_tvlv_tt_change *)tvlv_buff;
 
+	if (!valid_cb)
+		return;
+
 	rcu_read_lock();
 	for (i = 0; i < hash->size; i++) {
 		head = &hash->table[i];
@@ -2952,11 +2992,12 @@ static void batadv_tt_tvlv_generate(struct batadv_priv *bat_priv,
 			if (tt_tot == tt_num_entries)
 				break;
 
-			if ((valid_cb) && (!valid_cb(tt_common_entry, cb_data)))
+			ret = valid_cb(tt_common_entry, cb_data, &flags);
+			if (!ret)
 				continue;
 
 			ether_addr_copy(tt_change->addr, tt_common_entry->addr);
-			tt_change->flags = tt_common_entry->flags;
+			tt_change->flags = flags;
 			tt_change->vid = htons(tt_common_entry->vid);
 			memset(tt_change->reserved, 0,
 			       sizeof(tt_change->reserved));
-- 
2.20.1

