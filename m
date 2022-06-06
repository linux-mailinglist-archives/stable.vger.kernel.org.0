Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A58853EC0F
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239688AbiFFO2y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 10:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239670AbiFFO2y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 10:28:54 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBAECC7E06;
        Mon,  6 Jun 2022 07:28:52 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 8A72321A8A;
        Mon,  6 Jun 2022 14:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1654525731; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Kc42nz+2+bqP7cCKWXuEIBa11roLN1eBL1xCmnflQlo=;
        b=rK8xBB2oHYtkKUdkQQRiSwvaZ0GJmuRsc+PnhRTRaIMUeS4yjHsqR5eJPnf/VSHkayV7M9
        A4cDmNY7OGVxJ93VC0adZ4YQxePtT4QPlwokTizMF+gD9DQ6sln5NlDgjfVE6gZZkofrBa
        XLkxUydKRPsj33Wna28qCu3lA8XbzO8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1654525731;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Kc42nz+2+bqP7cCKWXuEIBa11roLN1eBL1xCmnflQlo=;
        b=PKOV/emUaCopRM23lWmITBhsf3xHhFd8D/v/GlDnWtQq5yoRi8IWJ+J9Ddl7F5hLMeaReZ
        IpU3FIo9uCOeEZDg==
Received: from quack3.suse.cz (unknown [10.163.28.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 61C442C142;
        Mon,  6 Jun 2022 14:28:51 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 040BBA0634; Mon,  6 Jun 2022 16:28:51 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>,
        Ritesh Harjani <ritesh.list@gmail.com>,
        Jan Kara <jack@suse.cz>, stable@vger.kernel.org
Subject: [PATCH 1/2] mbcache: Add functions to invalidate entries and wait for entry users
Date:   Mon,  6 Jun 2022 16:28:46 +0200
Message-Id: <20220606142850.15489-1-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220606142215.17962-1-jack@suse.cz>
References: <20220606142215.17962-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4241; h=from:subject; bh=VybMWKBFivCdccW9wDyiV62mL7n4M/x5BQnutPjnBgg=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBing8e94l7wpbVjPp4rvGND4X0T8JqB0r14ZiV/1u5 9x38WZeJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYp4PHgAKCRCcnaoHP2RA2TrFCA DWs9Vk4zDDc0B+LSrn7DLFBAkcLfEa+oJ61SMvY6K7uOGo3j2pkHn6OGSnz+i08IcdaGtG7aTtRs5V jSn0QACtB20iRJxCmuoNMzdEKh74Si8Tt0RxuYnhRoGn4q3JMBu9YwxoJZLoNa+kkzhLJy9Jttzxmx FhHz+A/fJNVO7bGGwSUU2Ybub6OUKwDpBMc/FqEQy1tcZ8+dlDLkHjvHLtihjrLebyIv18r6Di35L9 cLXaG5bkDCr4353coffMCRY1deU+8w0l79VMwG0xXPfejPaNuRqyLVKMojoAANtU3kXvQTelpGVhG6 P+xlKkQcEwqhxxA8IAvnpa0K1ZPOgJ
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

Add functions which allow for invalidating entry in the cache but
keeping the last reference and for waiting on remaining users of the
cache entry. These functions will be used by ext4 to fix races with
xattr block sharing.

CC: stable@vger.kernel.org
Fixes: 82939d7999df ("ext4: convert to mbcache2")
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/mbcache.c            | 47 ++++++++++++++++++++++++++++++++++++-----
 include/linux/mbcache.h | 11 +++++++++-
 2 files changed, 52 insertions(+), 6 deletions(-)

diff --git a/fs/mbcache.c b/fs/mbcache.c
index 97c54d3a2227..b81ea7c6fa21 100644
--- a/fs/mbcache.c
+++ b/fs/mbcache.c
@@ -125,6 +125,21 @@ void __mb_cache_entry_free(struct mb_cache_entry *entry)
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
+	WARN_ON_ONCE(!list_empty(&entry->e_list));
+	WARN_ON_ONCE(!hlist_bl_unhashed(&entry->e_hash_list));
+	wait_var_event(&entry->e_refcnt, atomic_read(&entry->e_refcnt) == 1);
+}
+EXPORT_SYMBOL(mb_cache_entry_wait_unused);
+
 static struct mb_cache_entry *__entry_find(struct mb_cache *cache,
 					   struct mb_cache_entry *entry,
 					   u32 key)
@@ -217,14 +232,18 @@ struct mb_cache_entry *mb_cache_entry_get(struct mb_cache *cache, u32 key,
 }
 EXPORT_SYMBOL(mb_cache_entry_get);
 
-/* mb_cache_entry_delete - remove a cache entry
+/* mb_cache_entry_invalidate - invalidate mbcache entry
  * @cache - cache we work with
  * @key - key
  * @value - value
  *
- * Remove entry from cache @cache with key @key and value @value.
+ * Invalidate entry in cache @cache with key @key and value @value. The entry
+ * is removed from the hash and LRU so there can be no new users of it. The
+ * invalidated entry is returned so that the caller can drop the last
+ * reference (perhaps after waiting for remaining users).
  */
-void mb_cache_entry_delete(struct mb_cache *cache, u32 key, u64 value)
+struct mb_cache_entry *mb_cache_entry_invalidate(struct mb_cache *cache,
+						 u32 key, u64 value)
 {
 	struct hlist_bl_node *node;
 	struct hlist_bl_head *head;
@@ -246,11 +265,29 @@ void mb_cache_entry_delete(struct mb_cache *cache, u32 key, u64 value)
 				atomic_dec(&entry->e_refcnt);
 			}
 			spin_unlock(&cache->c_list_lock);
-			mb_cache_entry_put(cache, entry);
-			return;
+			return entry;
 		}
 	}
 	hlist_bl_unlock(head);
+
+	return NULL;
+}
+EXPORT_SYMBOL(mb_cache_entry_invalidate);
+
+/* mb_cache_entry_delete - delete mbcache entry
+ * @cache - cache we work with
+ * @key - key
+ * @value - value
+ *
+ * Delete entry in cache @cache with key @key and value @value.
+ */
+void mb_cache_entry_delete(struct mb_cache *cache, u32 key, u64 value)
+{
+	struct mb_cache_entry *entry;
+
+	entry = mb_cache_entry_invalidate(cache, key, value);
+	if (entry)
+		mb_cache_entry_put(cache, entry);
 }
 EXPORT_SYMBOL(mb_cache_entry_delete);
 
diff --git a/include/linux/mbcache.h b/include/linux/mbcache.h
index 20f1e3ff6013..4e6a5e05e78b 100644
--- a/include/linux/mbcache.h
+++ b/include/linux/mbcache.h
@@ -30,15 +30,24 @@ void mb_cache_destroy(struct mb_cache *cache);
 int mb_cache_entry_create(struct mb_cache *cache, gfp_t mask, u32 key,
 			  u64 value, bool reusable);
 void __mb_cache_entry_free(struct mb_cache_entry *entry);
+void mb_cache_entry_wait_unused(struct mb_cache_entry *entry);
 static inline int mb_cache_entry_put(struct mb_cache *cache,
 				     struct mb_cache_entry *entry)
 {
-	if (!atomic_dec_and_test(&entry->e_refcnt))
+	unsigned int cnt;
+
+	cnt = atomic_dec_return(&entry->e_refcnt);
+	if (cnt > 0) {
+		if (cnt == 1)
+			wake_up_var(&entry->e_refcnt);
 		return 0;
+	}
 	__mb_cache_entry_free(entry);
 	return 1;
 }
 
+struct mb_cache_entry *mb_cache_entry_invalidate(struct mb_cache *cache,
+						 u32 key, u64 value);
 void mb_cache_entry_delete(struct mb_cache *cache, u32 key, u64 value);
 struct mb_cache_entry *mb_cache_entry_get(struct mb_cache *cache, u32 key,
 					  u64 value);
-- 
2.35.3

