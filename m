Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E90AE66C4F8
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231810AbjAPQAY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:00:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231974AbjAPQAD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:00:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D95F23D84
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:00:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C78A061042
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:00:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0D50C433EF;
        Mon, 16 Jan 2023 16:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884801;
        bh=HR6xZZ8QbSkmPFuqJ9XV+UzrIEwbaNrWmxCigzwoIXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u2OgcFEzMG0CT/N88PMGarznJhPeaXqfPddXVM1vHWtO+/bT2pkq3050wNynQ8Fef
         vBYrKsDzR4g7ANTNO+s4hEjAsXTPn6jyuhRhbkg5Oa6UeHXX9IXA+eJazmgqQVanUD
         hVafrxUJgO7MkDEbKP26LmEpzOwiTlk5h9ZEYeyY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Maaz Mombasawala <mombasawalam@vmware.com>,
        Zack Rusin <zackr@vmware.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 145/183] drm/vmwgfx: Refactor ttm reference object hashtable to use linux/hashtable.
Date:   Mon, 16 Jan 2023 16:51:08 +0100
Message-Id: <20230116154809.469169949@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
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

From: Maaz Mombasawala <mombasawalam@vmware.com>

[ Upstream commit 76a9e07f270cf5fb556ac237dbf11f5dacd61fef ]

This is part of an effort to move from the vmwgfx_open_hash hashtable to
linux/hashtable implementation.
Refactor the ref_hash hashtable, used for fast lookup of reference objects
associated with a ttm file.
This also exposed a problem related to inconsistently using 32-bit and
64-bit keys with this hashtable. The hash function used changes depending
on the size of the type, and results are not consistent across numbers,
for example, hash_32(329) = 329, but hash_long(329) = 328. This would
cause the lookup to fail for objects already in the hashtable, since keys
of different sizes were being passed during adding and lookup. This was
not an issue before because vmwgfx_open_hash always used hash_long.
Fix this by always using 64-bit keys for this hashtable, which means that
hash_long is always used.

Signed-off-by: Maaz Mombasawala <mombasawalam@vmware.com>
Reviewed-by: Zack Rusin <zackr@vmware.com>
Signed-off-by: Zack Rusin <zackr@vmware.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221022040236.616490-11-zack@kde.org
Stable-dep-of: a309c7194e8a ("drm/vmwgfx: Remove rcu locks from user resources")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/ttm_object.c | 91 ++++++++++++++++-------------
 drivers/gpu/drm/vmwgfx/ttm_object.h | 12 ++--
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c |  2 +-
 3 files changed, 56 insertions(+), 49 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/ttm_object.c b/drivers/gpu/drm/vmwgfx/ttm_object.c
index 9546b121bc22..c07b81fbc495 100644
--- a/drivers/gpu/drm/vmwgfx/ttm_object.c
+++ b/drivers/gpu/drm/vmwgfx/ttm_object.c
@@ -52,9 +52,12 @@
 #include <linux/slab.h>
 #include <linux/atomic.h>
 #include <linux/module.h>
+#include <linux/hashtable.h>
 
 MODULE_IMPORT_NS(DMA_BUF);
 
+#define VMW_TTM_OBJECT_REF_HT_ORDER 10
+
 /**
  * struct ttm_object_file
  *
@@ -75,7 +78,7 @@ struct ttm_object_file {
 	struct ttm_object_device *tdev;
 	spinlock_t lock;
 	struct list_head ref_list;
-	struct vmwgfx_open_hash ref_hash;
+	DECLARE_HASHTABLE(ref_hash, VMW_TTM_OBJECT_REF_HT_ORDER);
 	struct kref refcount;
 };
 
@@ -136,6 +139,36 @@ ttm_object_file_ref(struct ttm_object_file *tfile)
 	return tfile;
 }
 
+static int ttm_tfile_find_ref_rcu(struct ttm_object_file *tfile,
+				  uint64_t key,
+				  struct vmwgfx_hash_item **p_hash)
+{
+	struct vmwgfx_hash_item *hash;
+
+	hash_for_each_possible_rcu(tfile->ref_hash, hash, head, key) {
+		if (hash->key == key) {
+			*p_hash = hash;
+			return 0;
+		}
+	}
+	return -EINVAL;
+}
+
+static int ttm_tfile_find_ref(struct ttm_object_file *tfile,
+			      uint64_t key,
+			      struct vmwgfx_hash_item **p_hash)
+{
+	struct vmwgfx_hash_item *hash;
+
+	hash_for_each_possible(tfile->ref_hash, hash, head, key) {
+		if (hash->key == key) {
+			*p_hash = hash;
+			return 0;
+		}
+	}
+	return -EINVAL;
+}
+
 static void ttm_object_file_destroy(struct kref *kref)
 {
 	struct ttm_object_file *tfile =
@@ -238,14 +271,13 @@ void ttm_base_object_unref(struct ttm_base_object **p_base)
  * Return: A pointer to the object if successful or NULL otherwise.
  */
 struct ttm_base_object *
-ttm_base_object_noref_lookup(struct ttm_object_file *tfile, uint32_t key)
+ttm_base_object_noref_lookup(struct ttm_object_file *tfile, uint64_t key)
 {
 	struct vmwgfx_hash_item *hash;
-	struct vmwgfx_open_hash *ht = &tfile->ref_hash;
 	int ret;
 
 	rcu_read_lock();
-	ret = vmwgfx_ht_find_item_rcu(ht, key, &hash);
+	ret = ttm_tfile_find_ref_rcu(tfile, key, &hash);
 	if (ret) {
 		rcu_read_unlock();
 		return NULL;
@@ -257,15 +289,14 @@ ttm_base_object_noref_lookup(struct ttm_object_file *tfile, uint32_t key)
 EXPORT_SYMBOL(ttm_base_object_noref_lookup);
 
 struct ttm_base_object *ttm_base_object_lookup(struct ttm_object_file *tfile,
-					       uint32_t key)
+					       uint64_t key)
 {
 	struct ttm_base_object *base = NULL;
 	struct vmwgfx_hash_item *hash;
-	struct vmwgfx_open_hash *ht = &tfile->ref_hash;
 	int ret;
 
 	rcu_read_lock();
-	ret = vmwgfx_ht_find_item_rcu(ht, key, &hash);
+	ret = ttm_tfile_find_ref_rcu(tfile, key, &hash);
 
 	if (likely(ret == 0)) {
 		base = drm_hash_entry(hash, struct ttm_ref_object, hash)->obj;
@@ -278,7 +309,7 @@ struct ttm_base_object *ttm_base_object_lookup(struct ttm_object_file *tfile,
 }
 
 struct ttm_base_object *
-ttm_base_object_lookup_for_ref(struct ttm_object_device *tdev, uint32_t key)
+ttm_base_object_lookup_for_ref(struct ttm_object_device *tdev, uint64_t key)
 {
 	struct ttm_base_object *base;
 
@@ -297,7 +328,6 @@ int ttm_ref_object_add(struct ttm_object_file *tfile,
 		       bool *existed,
 		       bool require_existed)
 {
-	struct vmwgfx_open_hash *ht = &tfile->ref_hash;
 	struct ttm_ref_object *ref;
 	struct vmwgfx_hash_item *hash;
 	int ret = -EINVAL;
@@ -310,7 +340,7 @@ int ttm_ref_object_add(struct ttm_object_file *tfile,
 
 	while (ret == -EINVAL) {
 		rcu_read_lock();
-		ret = vmwgfx_ht_find_item_rcu(ht, base->handle, &hash);
+		ret = ttm_tfile_find_ref_rcu(tfile, base->handle, &hash);
 
 		if (ret == 0) {
 			ref = drm_hash_entry(hash, struct ttm_ref_object, hash);
@@ -335,21 +365,14 @@ int ttm_ref_object_add(struct ttm_object_file *tfile,
 		kref_init(&ref->kref);
 
 		spin_lock(&tfile->lock);
-		ret = vmwgfx_ht_insert_item_rcu(ht, &ref->hash);
-
-		if (likely(ret == 0)) {
-			list_add_tail(&ref->head, &tfile->ref_list);
-			kref_get(&base->refcount);
-			spin_unlock(&tfile->lock);
-			if (existed != NULL)
-				*existed = false;
-			break;
-		}
+		hash_add_rcu(tfile->ref_hash, &ref->hash.head, ref->hash.key);
+		ret = 0;
 
+		list_add_tail(&ref->head, &tfile->ref_list);
+		kref_get(&base->refcount);
 		spin_unlock(&tfile->lock);
-		BUG_ON(ret != -EINVAL);
-
-		kfree(ref);
+		if (existed != NULL)
+			*existed = false;
 	}
 
 	return ret;
@@ -361,10 +384,8 @@ ttm_ref_object_release(struct kref *kref)
 	struct ttm_ref_object *ref =
 	    container_of(kref, struct ttm_ref_object, kref);
 	struct ttm_object_file *tfile = ref->tfile;
-	struct vmwgfx_open_hash *ht;
 
-	ht = &tfile->ref_hash;
-	(void)vmwgfx_ht_remove_item_rcu(ht, &ref->hash);
+	hash_del_rcu(&ref->hash.head);
 	list_del(&ref->head);
 	spin_unlock(&tfile->lock);
 
@@ -376,13 +397,12 @@ ttm_ref_object_release(struct kref *kref)
 int ttm_ref_object_base_unref(struct ttm_object_file *tfile,
 			      unsigned long key)
 {
-	struct vmwgfx_open_hash *ht = &tfile->ref_hash;
 	struct ttm_ref_object *ref;
 	struct vmwgfx_hash_item *hash;
 	int ret;
 
 	spin_lock(&tfile->lock);
-	ret = vmwgfx_ht_find_item(ht, key, &hash);
+	ret = ttm_tfile_find_ref(tfile, key, &hash);
 	if (unlikely(ret != 0)) {
 		spin_unlock(&tfile->lock);
 		return -EINVAL;
@@ -414,16 +434,13 @@ void ttm_object_file_release(struct ttm_object_file **p_tfile)
 	}
 
 	spin_unlock(&tfile->lock);
-	vmwgfx_ht_remove(&tfile->ref_hash);
 
 	ttm_object_file_unref(&tfile);
 }
 
-struct ttm_object_file *ttm_object_file_init(struct ttm_object_device *tdev,
-					     unsigned int hash_order)
+struct ttm_object_file *ttm_object_file_init(struct ttm_object_device *tdev)
 {
 	struct ttm_object_file *tfile = kmalloc(sizeof(*tfile), GFP_KERNEL);
-	int ret;
 
 	if (unlikely(tfile == NULL))
 		return NULL;
@@ -433,17 +450,9 @@ struct ttm_object_file *ttm_object_file_init(struct ttm_object_device *tdev,
 	kref_init(&tfile->refcount);
 	INIT_LIST_HEAD(&tfile->ref_list);
 
-	ret = vmwgfx_ht_create(&tfile->ref_hash, hash_order);
-	if (ret)
-		goto out_err;
+	hash_init(tfile->ref_hash);
 
 	return tfile;
-out_err:
-	vmwgfx_ht_remove(&tfile->ref_hash);
-
-	kfree(tfile);
-
-	return NULL;
 }
 
 struct ttm_object_device *
diff --git a/drivers/gpu/drm/vmwgfx/ttm_object.h b/drivers/gpu/drm/vmwgfx/ttm_object.h
index 6870f951b677..67f30d589e27 100644
--- a/drivers/gpu/drm/vmwgfx/ttm_object.h
+++ b/drivers/gpu/drm/vmwgfx/ttm_object.h
@@ -104,7 +104,7 @@ struct ttm_base_object {
 	struct ttm_object_file *tfile;
 	struct kref refcount;
 	void (*refcount_release) (struct ttm_base_object **base);
-	u32 handle;
+	u64 handle;
 	enum ttm_object_type object_type;
 	u32 shareable;
 };
@@ -164,7 +164,7 @@ extern int ttm_base_object_init(struct ttm_object_file *tfile,
  */
 
 extern struct ttm_base_object *ttm_base_object_lookup(struct ttm_object_file
-						      *tfile, uint32_t key);
+						      *tfile, uint64_t key);
 
 /**
  * ttm_base_object_lookup_for_ref
@@ -178,7 +178,7 @@ extern struct ttm_base_object *ttm_base_object_lookup(struct ttm_object_file
  */
 
 extern struct ttm_base_object *
-ttm_base_object_lookup_for_ref(struct ttm_object_device *tdev, uint32_t key);
+ttm_base_object_lookup_for_ref(struct ttm_object_device *tdev, uint64_t key);
 
 /**
  * ttm_base_object_unref
@@ -237,14 +237,12 @@ extern int ttm_ref_object_base_unref(struct ttm_object_file *tfile,
  * ttm_object_file_init - initialize a struct ttm_object file
  *
  * @tdev: A struct ttm_object device this file is initialized on.
- * @hash_order: Order of the hash table used to hold the reference objects.
  *
  * This is typically called by the file_ops::open function.
  */
 
 extern struct ttm_object_file *ttm_object_file_init(struct ttm_object_device
-						    *tdev,
-						    unsigned int hash_order);
+						    *tdev);
 
 /**
  * ttm_object_file_release - release data held by a ttm_object_file
@@ -312,7 +310,7 @@ extern int ttm_prime_handle_to_fd(struct ttm_object_file *tfile,
 	kfree_rcu(__obj, __prime.base.rhead)
 
 struct ttm_base_object *
-ttm_base_object_noref_lookup(struct ttm_object_file *tfile, uint32_t key);
+ttm_base_object_noref_lookup(struct ttm_object_file *tfile, uint64_t key);
 
 /**
  * ttm_base_object_noref_release - release a base object pointer looked up
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
index 8d77e79bd904..b909a3ce9af3 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
@@ -1242,7 +1242,7 @@ static int vmw_driver_open(struct drm_device *dev, struct drm_file *file_priv)
 	if (unlikely(!vmw_fp))
 		return ret;
 
-	vmw_fp->tfile = ttm_object_file_init(dev_priv->tdev, 10);
+	vmw_fp->tfile = ttm_object_file_init(dev_priv->tdev);
 	if (unlikely(vmw_fp->tfile == NULL))
 		goto out_no_tfile;
 
-- 
2.35.1



