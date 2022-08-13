Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64D0E591AFA
	for <lists+stable@lfdr.de>; Sat, 13 Aug 2022 16:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237698AbiHMOaB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Aug 2022 10:30:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239390AbiHMOaA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Aug 2022 10:30:00 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C72527CC5
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 07:29:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E3F47CE069F
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 14:29:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C86B7C433D7;
        Sat, 13 Aug 2022 14:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660400996;
        bh=yNZ/B+l43mUI/mpA27gQ+bpJhk2430Jra03DVwYZF1U=;
        h=Subject:To:Cc:From:Date:From;
        b=eNEM8h56WNyNonvdeiSIgjg8HFRbC2tvi+GP6+SbXtVDMtbpsGfGOhjC6lUCU44ZI
         54M2HZCCwZTgNt0kztttm4kQjwM8wNi3LIU8G3A05DleExX+LJBZXcqZ6SB34yX+uq
         TU7cklaYNIi84YUjfZOHhtW07GC23rsFJvN/W+fs=
Subject: FAILED: patch "[PATCH] mbcache: add functions to delete entry if unused" failed to apply to 4.9-stable tree
To:     jack@suse.cz, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Aug 2022 16:29:53 +0200
Message-ID: <1660400993215253@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3dc96bba65f53daa217f0a8f43edad145286a8f5 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 12 Jul 2022 12:54:21 +0200
Subject: [PATCH] mbcache: add functions to delete entry if unused

Add function mb_cache_entry_delete_or_get() to delete mbcache entry if
it is unused and also add a function to wait for entry to become unused
- mb_cache_entry_wait_unused(). We do not share code between the two
deleting function as one of them will go away soon.

CC: stable@vger.kernel.org
Fixes: 82939d7999df ("ext4: convert to mbcache2")
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220712105436.32204-2-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/fs/mbcache.c b/fs/mbcache.c
index cfc28129fb6f..2010bc80a3f2 100644
--- a/fs/mbcache.c
+++ b/fs/mbcache.c
@@ -11,7 +11,7 @@
 /*
  * Mbcache is a simple key-value store. Keys need not be unique, however
  * key-value pairs are expected to be unique (we use this fact in
- * mb_cache_entry_delete()).
+ * mb_cache_entry_delete_or_get()).
  *
  * Ext2 and ext4 use this cache for deduplication of extended attribute blocks.
  * Ext4 also uses it for deduplication of xattr values stored in inodes.
@@ -125,6 +125,19 @@ void __mb_cache_entry_free(struct mb_cache_entry *entry)
 }
 EXPORT_SYMBOL(__mb_cache_entry_free);
 
+/*
+ * mb_cache_entry_wait_unused - wait to be the last user of the entry
+ *
+ * @entry - entry to work on
+ *
+ * Wait to be the last user of the entry.
+ */
+void mb_cache_entry_wait_unused(struct mb_cache_entry *entry)
+{
+	wait_var_event(&entry->e_refcnt, atomic_read(&entry->e_refcnt) <= 3);
+}
+EXPORT_SYMBOL(mb_cache_entry_wait_unused);
+
 static struct mb_cache_entry *__entry_find(struct mb_cache *cache,
 					   struct mb_cache_entry *entry,
 					   u32 key)
@@ -217,7 +230,7 @@ struct mb_cache_entry *mb_cache_entry_get(struct mb_cache *cache, u32 key,
 }
 EXPORT_SYMBOL(mb_cache_entry_get);
 
-/* mb_cache_entry_delete - remove a cache entry
+/* mb_cache_entry_delete - try to remove a cache entry
  * @cache - cache we work with
  * @key - key
  * @value - value
@@ -254,6 +267,55 @@ void mb_cache_entry_delete(struct mb_cache *cache, u32 key, u64 value)
 }
 EXPORT_SYMBOL(mb_cache_entry_delete);
 
+/* mb_cache_entry_delete_or_get - remove a cache entry if it has no users
+ * @cache - cache we work with
+ * @key - key
+ * @value - value
+ *
+ * Remove entry from cache @cache with key @key and value @value. The removal
+ * happens only if the entry is unused. The function returns NULL in case the
+ * entry was successfully removed or there's no entry in cache. Otherwise the
+ * function grabs reference of the entry that we failed to delete because it
+ * still has users and return it.
+ */
+struct mb_cache_entry *mb_cache_entry_delete_or_get(struct mb_cache *cache,
+						    u32 key, u64 value)
+{
+	struct hlist_bl_node *node;
+	struct hlist_bl_head *head;
+	struct mb_cache_entry *entry;
+
+	head = mb_cache_entry_head(cache, key);
+	hlist_bl_lock(head);
+	hlist_bl_for_each_entry(entry, node, head, e_hash_list) {
+		if (entry->e_key == key && entry->e_value == value) {
+			if (atomic_read(&entry->e_refcnt) > 2) {
+				atomic_inc(&entry->e_refcnt);
+				hlist_bl_unlock(head);
+				return entry;
+			}
+			/* We keep hash list reference to keep entry alive */
+			hlist_bl_del_init(&entry->e_hash_list);
+			hlist_bl_unlock(head);
+			spin_lock(&cache->c_list_lock);
+			if (!list_empty(&entry->e_list)) {
+				list_del_init(&entry->e_list);
+				if (!WARN_ONCE(cache->c_entry_count == 0,
+		"mbcache: attempt to decrement c_entry_count past zero"))
+					cache->c_entry_count--;
+				atomic_dec(&entry->e_refcnt);
+			}
+			spin_unlock(&cache->c_list_lock);
+			mb_cache_entry_put(cache, entry);
+			return NULL;
+		}
+	}
+	hlist_bl_unlock(head);
+
+	return NULL;
+}
+EXPORT_SYMBOL(mb_cache_entry_delete_or_get);
+
 /* mb_cache_entry_touch - cache entry got used
  * @cache - cache the entry belongs to
  * @entry - entry that got used
diff --git a/include/linux/mbcache.h b/include/linux/mbcache.h
index 20f1e3ff6013..8eca7f25c432 100644
--- a/include/linux/mbcache.h
+++ b/include/linux/mbcache.h
@@ -30,15 +30,23 @@ void mb_cache_destroy(struct mb_cache *cache);
 int mb_cache_entry_create(struct mb_cache *cache, gfp_t mask, u32 key,
 			  u64 value, bool reusable);
 void __mb_cache_entry_free(struct mb_cache_entry *entry);
+void mb_cache_entry_wait_unused(struct mb_cache_entry *entry);
 static inline int mb_cache_entry_put(struct mb_cache *cache,
 				     struct mb_cache_entry *entry)
 {
-	if (!atomic_dec_and_test(&entry->e_refcnt))
+	unsigned int cnt = atomic_dec_return(&entry->e_refcnt);
+
+	if (cnt > 0) {
+		if (cnt <= 3)
+			wake_up_var(&entry->e_refcnt);
 		return 0;
+	}
 	__mb_cache_entry_free(entry);
 	return 1;
 }
 
+struct mb_cache_entry *mb_cache_entry_delete_or_get(struct mb_cache *cache,
+						    u32 key, u64 value);
 void mb_cache_entry_delete(struct mb_cache *cache, u32 key, u64 value);
 struct mb_cache_entry *mb_cache_entry_get(struct mb_cache *cache, u32 key,
 					  u64 value);

