Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B251954B54C
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 18:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344590AbiFNQGL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 12:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234800AbiFNQGK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 12:06:10 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAFE23CFC1;
        Tue, 14 Jun 2022 09:06:05 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 7584B1F961;
        Tue, 14 Jun 2022 16:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1655222764; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i2YXHTV+/1Q4slUJZ6kN+vaPbtaTWCSFbqHwLTTAG/Q=;
        b=o9LXKHUUHAzq90GflKi5JC+fRF1d9fOmhwbT1yNIccPpaJLY12EWOETdSbgBK2iXeYJRjR
        kNuL1UQbkae3UViCAne3kZ8kL/OywVCr2Xb8gyQEkqqV/FL5oIN499z3HQuSPMTlF1FHTV
        etf66hzC66lrOXfLJ9ZlS5lSAlZTbzM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1655222764;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i2YXHTV+/1Q4slUJZ6kN+vaPbtaTWCSFbqHwLTTAG/Q=;
        b=DbNBawXuB8ir/8Gs0/da5W3IYzBiH7F/XPoUCRjakfks55I5ZQD9pAYDJ1gO1wC9ASYnol
        YFP8V6ik8/oQPkAA==
Received: from quack3.suse.cz (unknown [10.163.28.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 31A6F2C14B;
        Tue, 14 Jun 2022 16:06:04 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id C67B6A0635; Tue, 14 Jun 2022 18:06:03 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>,
        Ritesh Harjani <ritesh.list@gmail.com>,
        Jan Kara <jack@suse.cz>, stable@vger.kernel.org
Subject: [PATCH 02/10] mbcache: Add functions to delete entry if unused
Date:   Tue, 14 Jun 2022 18:05:16 +0200
Message-Id: <20220614160603.20566-2-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220614124146.21594-1-jack@suse.cz>
References: <20220614124146.21594-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4616; h=from:subject; bh=skeGIP6uNoPCOIjVTMbCMuiyxH91b+myiEhlBWZHpaY=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBiqLG8Db3e4AsILbU6dxrM6q6KCylRRjO1obkzKYgm UO71Zq2JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYqixvAAKCRCcnaoHP2RA2X2LB/ 0dkq9K7jqgcPYUoAhpJ5OwdXOQJGCb29KO75mxVIFqIKt3eUrTfreMeotdAdVctMx75zZOfBoGWVtQ pceWYmDHwjKq+7JrcQl5oSy99nRl9sqx0DXXzxzU4iLRjuYHo6imU1NsKTWnA8Otdlo/lvk6MDzyVp M7PEvG6fra14FwLshL6w/Hazzb1PhP+GMG7xNQjs+LXjz0esS8zT1LDHTBUXTtxuHtHs7aVYjGE4rJ I/ugMzCn9rSlsTWbSjFZ0+0sQz6hbqomeE7rfayhQa5QAoR9mFxidiFHhUOUeqXu5LnPKibbSvKj3a q6T1c6GLGuIRD+9dB5DVGHWaoj8v0v
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add function mb_cache_entry_try_delete() to delete mbcache entry if it
is unused and also add a function to wait for entry to become unused -
mb_cache_entry_wait_unused(). We do not share code between the two
deleting function as one of them will go away soon.

CC: stable@vger.kernel.org
Fixes: 82939d7999df ("ext4: convert to mbcache2")
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/mbcache.c            | 63 ++++++++++++++++++++++++++++++++++++++++-
 include/linux/mbcache.h | 10 ++++++-
 2 files changed, 71 insertions(+), 2 deletions(-)

diff --git a/fs/mbcache.c b/fs/mbcache.c
index cfc28129fb6f..1ae66b2c75f4 100644
--- a/fs/mbcache.c
+++ b/fs/mbcache.c
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
@@ -254,6 +267,54 @@ void mb_cache_entry_delete(struct mb_cache *cache, u32 key, u64 value)
 }
 EXPORT_SYMBOL(mb_cache_entry_delete);
 
+/* mb_cache_entry_try_delete - try to remove a cache entry
+ * @cache - cache we work with
+ * @key - key
+ * @value - value
+ *
+ * Remove entry from cache @cache with key @key and value @value. The removal
+ * happens only if the entry is unused. The function returns NULL in case the
+ * entry was successfully removed or there's no entry in cache. Otherwise the
+ * function returns the entry that we failed to delete because it has users.
+ */
+struct mb_cache_entry *mb_cache_entry_try_delete(struct mb_cache *cache,
+						 u32 key, u64 value)
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
+EXPORT_SYMBOL(mb_cache_entry_try_delete);
+
 /* mb_cache_entry_touch - cache entry got used
  * @cache - cache the entry belongs to
  * @entry - entry that got used
diff --git a/include/linux/mbcache.h b/include/linux/mbcache.h
index 20f1e3ff6013..1176fdfb8d53 100644
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
 
+struct mb_cache_entry *mb_cache_entry_try_delete(struct mb_cache *cache,
+						 u32 key, u64 value);
 void mb_cache_entry_delete(struct mb_cache *cache, u32 key, u64 value);
 struct mb_cache_entry *mb_cache_entry_get(struct mb_cache *cache, u32 key,
 					  u64 value);
-- 
2.35.3

