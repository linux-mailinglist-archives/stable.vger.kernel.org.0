Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A456866CBB7
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:16:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234464AbjAPRQY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:16:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234453AbjAPRPl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:15:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E852732E6F
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:56:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7594C60F7C
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:56:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 893E5C433EF;
        Mon, 16 Jan 2023 16:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888202;
        bh=3WWkOyYxi9xNZlYzkYUDd9JFb/tYuCz7BCvbPkNbzaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vVQSYJcHtTlysGOjHisY+jzYhsnyEWDANxHuJt9OFy9tfl8TKUrwZEJfcidtAN4PG
         wuk0n9X4EcQvrfrKRmEcqZSwPolAmYoY+1DZeM1Mw+iAOiAjwGP2iEtssrbc3+EHTZ
         0UZ8QXshtU/IOycHoN1IuXGPc5ZkQyxuvPZGNmlU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 440/521] mbcache: automatically delete entries from cache on freeing
Date:   Mon, 16 Jan 2023 16:51:42 +0100
Message-Id: <20230116154906.818913054@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit 307af6c879377c1c63e71cbdd978201f9c7ee8df ]

Use the fact that entries with elevated refcount are not removed from
the hash and just move removal of the entry from the hash to the entry
freeing time. When doing this we also change the generic code to hold
one reference to the cache entry, not two of them, which makes code
somewhat more obvious.

Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220712105436.32204-10-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: a44e84a9b776 ("ext4: fix deadlock due to mbcache entry corruption")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/mbcache.c            | 108 +++++++++++++++-------------------------
 include/linux/mbcache.h |  24 ++++++---
 2 files changed, 55 insertions(+), 77 deletions(-)

diff --git a/fs/mbcache.c b/fs/mbcache.c
index c76030e20d92..aa564e79891d 100644
--- a/fs/mbcache.c
+++ b/fs/mbcache.c
@@ -89,7 +89,7 @@ int mb_cache_entry_create(struct mb_cache *cache, gfp_t mask, u32 key,
 		return -ENOMEM;
 
 	INIT_LIST_HEAD(&entry->e_list);
-	/* One ref for hash, one ref returned */
+	/* Initial hash reference */
 	atomic_set(&entry->e_refcnt, 1);
 	entry->e_key = key;
 	entry->e_value = value;
@@ -105,21 +105,28 @@ int mb_cache_entry_create(struct mb_cache *cache, gfp_t mask, u32 key,
 		}
 	}
 	hlist_bl_add_head(&entry->e_hash_list, head);
-	hlist_bl_unlock(head);
-
+	/*
+	 * Add entry to LRU list before it can be found by
+	 * mb_cache_entry_delete() to avoid races
+	 */
 	spin_lock(&cache->c_list_lock);
 	list_add_tail(&entry->e_list, &cache->c_list);
-	/* Grab ref for LRU list */
-	atomic_inc(&entry->e_refcnt);
 	cache->c_entry_count++;
 	spin_unlock(&cache->c_list_lock);
+	hlist_bl_unlock(head);
 
 	return 0;
 }
 EXPORT_SYMBOL(mb_cache_entry_create);
 
-void __mb_cache_entry_free(struct mb_cache_entry *entry)
+void __mb_cache_entry_free(struct mb_cache *cache, struct mb_cache_entry *entry)
 {
+	struct hlist_bl_head *head;
+
+	head = mb_cache_entry_head(cache, entry->e_key);
+	hlist_bl_lock(head);
+	hlist_bl_del(&entry->e_hash_list);
+	hlist_bl_unlock(head);
 	kmem_cache_free(mb_entry_cache, entry);
 }
 EXPORT_SYMBOL(__mb_cache_entry_free);
@@ -133,7 +140,7 @@ EXPORT_SYMBOL(__mb_cache_entry_free);
  */
 void mb_cache_entry_wait_unused(struct mb_cache_entry *entry)
 {
-	wait_var_event(&entry->e_refcnt, atomic_read(&entry->e_refcnt) <= 3);
+	wait_var_event(&entry->e_refcnt, atomic_read(&entry->e_refcnt) <= 2);
 }
 EXPORT_SYMBOL(mb_cache_entry_wait_unused);
 
@@ -154,10 +161,9 @@ static struct mb_cache_entry *__entry_find(struct mb_cache *cache,
 	while (node) {
 		entry = hlist_bl_entry(node, struct mb_cache_entry,
 				       e_hash_list);
-		if (entry->e_key == key && entry->e_reusable) {
-			atomic_inc(&entry->e_refcnt);
+		if (entry->e_key == key && entry->e_reusable &&
+		    atomic_inc_not_zero(&entry->e_refcnt))
 			goto out;
-		}
 		node = node->next;
 	}
 	entry = NULL;
@@ -217,10 +223,9 @@ struct mb_cache_entry *mb_cache_entry_get(struct mb_cache *cache, u32 key,
 	head = mb_cache_entry_head(cache, key);
 	hlist_bl_lock(head);
 	hlist_bl_for_each_entry(entry, node, head, e_hash_list) {
-		if (entry->e_key == key && entry->e_value == value) {
-			atomic_inc(&entry->e_refcnt);
+		if (entry->e_key == key && entry->e_value == value &&
+		    atomic_inc_not_zero(&entry->e_refcnt))
 			goto out;
-		}
 	}
 	entry = NULL;
 out:
@@ -280,37 +285,25 @@ EXPORT_SYMBOL(mb_cache_entry_delete);
 struct mb_cache_entry *mb_cache_entry_delete_or_get(struct mb_cache *cache,
 						    u32 key, u64 value)
 {
-	struct hlist_bl_node *node;
-	struct hlist_bl_head *head;
 	struct mb_cache_entry *entry;
 
-	head = mb_cache_entry_head(cache, key);
-	hlist_bl_lock(head);
-	hlist_bl_for_each_entry(entry, node, head, e_hash_list) {
-		if (entry->e_key == key && entry->e_value == value) {
-			if (atomic_read(&entry->e_refcnt) > 2) {
-				atomic_inc(&entry->e_refcnt);
-				hlist_bl_unlock(head);
-				return entry;
-			}
-			/* We keep hash list reference to keep entry alive */
-			hlist_bl_del_init(&entry->e_hash_list);
-			hlist_bl_unlock(head);
-			spin_lock(&cache->c_list_lock);
-			if (!list_empty(&entry->e_list)) {
-				list_del_init(&entry->e_list);
-				if (!WARN_ONCE(cache->c_entry_count == 0,
-		"mbcache: attempt to decrement c_entry_count past zero"))
-					cache->c_entry_count--;
-				atomic_dec(&entry->e_refcnt);
-			}
-			spin_unlock(&cache->c_list_lock);
-			mb_cache_entry_put(cache, entry);
-			return NULL;
-		}
-	}
-	hlist_bl_unlock(head);
+	entry = mb_cache_entry_get(cache, key, value);
+	if (!entry)
+		return NULL;
 
+	/*
+	 * Drop the ref we got from mb_cache_entry_get() and the initial hash
+	 * ref if we are the last user
+	 */
+	if (atomic_cmpxchg(&entry->e_refcnt, 2, 0) != 2)
+		return entry;
+
+	spin_lock(&cache->c_list_lock);
+	if (!list_empty(&entry->e_list))
+		list_del_init(&entry->e_list);
+	cache->c_entry_count--;
+	spin_unlock(&cache->c_list_lock);
+	__mb_cache_entry_free(cache, entry);
 	return NULL;
 }
 EXPORT_SYMBOL(mb_cache_entry_delete_or_get);
@@ -342,42 +335,24 @@ static unsigned long mb_cache_shrink(struct mb_cache *cache,
 				     unsigned long nr_to_scan)
 {
 	struct mb_cache_entry *entry;
-	struct hlist_bl_head *head;
 	unsigned long shrunk = 0;
 
 	spin_lock(&cache->c_list_lock);
 	while (nr_to_scan-- && !list_empty(&cache->c_list)) {
 		entry = list_first_entry(&cache->c_list,
 					 struct mb_cache_entry, e_list);
-		if (entry->e_referenced || atomic_read(&entry->e_refcnt) > 2) {
+		/* Drop initial hash reference if there is no user */
+		if (entry->e_referenced ||
+		    atomic_cmpxchg(&entry->e_refcnt, 1, 0) != 1) {
 			entry->e_referenced = 0;
 			list_move_tail(&entry->e_list, &cache->c_list);
 			continue;
 		}
 		list_del_init(&entry->e_list);
 		cache->c_entry_count--;
-		/*
-		 * We keep LRU list reference so that entry doesn't go away
-		 * from under us.
-		 */
 		spin_unlock(&cache->c_list_lock);
-		head = mb_cache_entry_head(cache, entry->e_key);
-		hlist_bl_lock(head);
-		/* Now a reliable check if the entry didn't get used... */
-		if (atomic_read(&entry->e_refcnt) > 2) {
-			hlist_bl_unlock(head);
-			spin_lock(&cache->c_list_lock);
-			list_add_tail(&entry->e_list, &cache->c_list);
-			cache->c_entry_count++;
-			continue;
-		}
-		if (!hlist_bl_unhashed(&entry->e_hash_list)) {
-			hlist_bl_del_init(&entry->e_hash_list);
-			atomic_dec(&entry->e_refcnt);
-		}
-		hlist_bl_unlock(head);
-		if (mb_cache_entry_put(cache, entry))
-			shrunk++;
+		__mb_cache_entry_free(cache, entry);
+		shrunk++;
 		cond_resched();
 		spin_lock(&cache->c_list_lock);
 	}
@@ -469,11 +444,6 @@ void mb_cache_destroy(struct mb_cache *cache)
 	 * point.
 	 */
 	list_for_each_entry_safe(entry, next, &cache->c_list, e_list) {
-		if (!hlist_bl_unhashed(&entry->e_hash_list)) {
-			hlist_bl_del_init(&entry->e_hash_list);
-			atomic_dec(&entry->e_refcnt);
-		} else
-			WARN_ON(1);
 		list_del(&entry->e_list);
 		WARN_ON(atomic_read(&entry->e_refcnt) != 1);
 		mb_cache_entry_put(cache, entry);
diff --git a/include/linux/mbcache.h b/include/linux/mbcache.h
index 8eca7f25c432..e9d5ece87794 100644
--- a/include/linux/mbcache.h
+++ b/include/linux/mbcache.h
@@ -13,8 +13,16 @@ struct mb_cache;
 struct mb_cache_entry {
 	/* List of entries in cache - protected by cache->c_list_lock */
 	struct list_head	e_list;
-	/* Hash table list - protected by hash chain bitlock */
+	/*
+	 * Hash table list - protected by hash chain bitlock. The entry is
+	 * guaranteed to be hashed while e_refcnt > 0.
+	 */
 	struct hlist_bl_node	e_hash_list;
+	/*
+	 * Entry refcount. Once it reaches zero, entry is unhashed and freed.
+	 * While refcount > 0, the entry is guaranteed to stay in the hash and
+	 * e.g. mb_cache_entry_try_delete() will fail.
+	 */
 	atomic_t		e_refcnt;
 	/* Key in hash - stable during lifetime of the entry */
 	u32			e_key;
@@ -29,20 +37,20 @@ void mb_cache_destroy(struct mb_cache *cache);
 
 int mb_cache_entry_create(struct mb_cache *cache, gfp_t mask, u32 key,
 			  u64 value, bool reusable);
-void __mb_cache_entry_free(struct mb_cache_entry *entry);
+void __mb_cache_entry_free(struct mb_cache *cache,
+			   struct mb_cache_entry *entry);
 void mb_cache_entry_wait_unused(struct mb_cache_entry *entry);
-static inline int mb_cache_entry_put(struct mb_cache *cache,
-				     struct mb_cache_entry *entry)
+static inline void mb_cache_entry_put(struct mb_cache *cache,
+				      struct mb_cache_entry *entry)
 {
 	unsigned int cnt = atomic_dec_return(&entry->e_refcnt);
 
 	if (cnt > 0) {
-		if (cnt <= 3)
+		if (cnt <= 2)
 			wake_up_var(&entry->e_refcnt);
-		return 0;
+		return;
 	}
-	__mb_cache_entry_free(entry);
-	return 1;
+	__mb_cache_entry_free(cache, entry);
 }
 
 struct mb_cache_entry *mb_cache_entry_delete_or_get(struct mb_cache *cache,
-- 
2.35.1



