Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E75F35717AA
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 12:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232570AbiGLKym (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 06:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232353AbiGLKyl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 06:54:41 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B28BEAE541;
        Tue, 12 Jul 2022 03:54:38 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 700742295F;
        Tue, 12 Jul 2022 10:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1657623277; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pxn/q+VyxU70VC7ps9CVLkIKrw+ywD4CDOKn+8ddLLY=;
        b=jDlPgTm0/2hcvkMC4LfoliggfX3pyaWtemUedn8jOdocDpIRMv3tySA30v89KelyU5wZfe
        9dJnzGUtvFWGX9KXKzZVpII9W15x/pJsijT0N0ZTE35usCyPvEOf1389nRIItZnW72/ubZ
        YPYx01LoTMzTEO3a2K9PzDPVAiBMYG8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1657623277;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pxn/q+VyxU70VC7ps9CVLkIKrw+ywD4CDOKn+8ddLLY=;
        b=Mtm8WFnxkRph/M1Y90duhlZ/QtWA65/3jMD7f0bUvidiG+wa65FB35HywzTzg7NpwzPzmV
        jbTlH0okAv2nnkBw==
Received: from quack3.suse.cz (unknown [10.100.224.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 511DF2C143;
        Tue, 12 Jul 2022 10:54:37 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 0112EA0641; Tue, 12 Jul 2022 12:54:36 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>,
        Ritesh Harjani <ritesh.list@gmail.com>,
        Jan Kara <jack@suse.cz>, stable@vger.kernel.org
Subject: [PATCH 02/10] mbcache: Add functions to delete entry if unused
Date:   Tue, 12 Jul 2022 12:54:21 +0200
Message-Id: <20220712105436.32204-2-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220712104519.29887-1-jack@suse.cz>
References: <20220712104519.29887-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5083; h=from:subject; bh=LBLfbsQjwc8OJWwxlERpPP1FlxZGrI8a39qPPkXFAUg=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBizVLd1cMt9PA88E/rnsGvU3M2WTektHh0oGAXcru7 bESGkVmJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYs1S3QAKCRCcnaoHP2RA2asqB/ 9wjN6V0K8RYjwh7hTPzvu7ilE6L6SYdt32XvrnoguT2H5CAj5FlbiRAK+0aZ1FB1oIXH/5hesasEcJ lie/TeqO4yMs19zx9vM/PhiJUp7HyDBJCjp/328m8SYB0ixd2dlz0u1nH3g51I+eFr0XLukw4h1KOh q2QVCro1awvHs6HkgQcEyfSX2usbVahrrroPFIPKaFEBnZPN4jbIF1VmZqn7Z/6kJlYo0aCkS6aupf bgoIvw1OnMyXL/gUsfvAN/4uRpSH/QBGRK7kwzWRvzOfubCiPCjQTP5Cho9h74gaIIuNIQ6naA7DF2 u7c+5IPK2S+eNlBdJFZQGaC0+rmk7v
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

Add function mb_cache_entry_delete_or_get() to delete mbcache entry if
it is unused and also add a function to wait for entry to become unused
- mb_cache_entry_wait_unused(). We do not share code between the two
deleting function as one of them will go away soon.

CC: stable@vger.kernel.org
Fixes: 82939d7999df ("ext4: convert to mbcache2")
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/mbcache.c            | 66 +++++++++++++++++++++++++++++++++++++++--
 include/linux/mbcache.h | 10 ++++++-
 2 files changed, 73 insertions(+), 3 deletions(-)

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
-- 
2.35.3

