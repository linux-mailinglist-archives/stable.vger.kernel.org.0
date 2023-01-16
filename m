Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6687C66C512
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:01:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231961AbjAPQBY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:01:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231939AbjAPQBO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:01:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02FBF1C32C
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:01:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B61DDB81062
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:01:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1769EC433EF;
        Mon, 16 Jan 2023 16:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884869;
        bh=H9NRk+hmLcnJSQrnDya3gSUuFTeBntqcDSXVL8lxbJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fLeqsroOXcP3HxqRTLUVLT75OP0rRWhZwPVRFpYc7oVwPoiaBUGCmElGDbFZwIKVB
         CHiaDNcvxgjKgQpte18FCrYDql5W2BqxlPRGyy69msAv7CRdKBpcsi68G9ZiFNu90L
         6FVbQfGDJ5Zslm5a5YT3/3S1UybCjux/qt69TgjA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Maaz Mombasawala <mombasawalam@vmware.com>,
        Zack Rusin <zackr@vmware.com>,
        Martin Krastev <krastevm@vmware.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 142/183] drm/vmwgfx: Refactor resource managers hashtable to use linux/hashtable implementation.
Date:   Mon, 16 Jan 2023 16:51:05 +0100
Message-Id: <20230116154809.360822191@linuxfoundation.org>
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

[ Upstream commit 43531dc661b7fb6be249c023bf25847b38215545 ]

Vmwgfx's hashtab implementation needs to be replaced with linux/hashtable
to reduce maintenance burden.
Refactor cmdbuf resource manager to use linux/hashtable.h implementation
as part of this effort.

Signed-off-by: Maaz Mombasawala <mombasawalam@vmware.com>
Reviewed-by: Zack Rusin <zackr@vmware.com>
Reviewed-by: Martin Krastev <krastevm@vmware.com>
Signed-off-by: Zack Rusin <zackr@vmware.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221022040236.616490-4-zack@kde.org
Stable-dep-of: a309c7194e8a ("drm/vmwgfx: Remove rcu locks from user resources")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf_res.c | 62 +++++++++-------------
 1 file changed, 26 insertions(+), 36 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf_res.c b/drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf_res.c
index 82ef58ccdd42..142aef686fcd 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf_res.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf_res.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0 OR MIT
 /**************************************************************************
  *
- * Copyright 2014-2015 VMware, Inc., Palo Alto, CA., USA
+ * Copyright 2014-2022 VMware, Inc., Palo Alto, CA., USA
  *
  * Permission is hereby granted, free of charge, to any person obtaining a
  * copy of this software and associated documentation files (the
@@ -28,6 +28,8 @@
 #include "vmwgfx_drv.h"
 #include "vmwgfx_resource_priv.h"
 
+#include <linux/hashtable.h>
+
 #define VMW_CMDBUF_RES_MAN_HT_ORDER 12
 
 /**
@@ -59,7 +61,7 @@ struct vmw_cmdbuf_res {
  * @resources and @list are protected by the cmdbuf mutex for now.
  */
 struct vmw_cmdbuf_res_manager {
-	struct vmwgfx_open_hash resources;
+	DECLARE_HASHTABLE(resources, VMW_CMDBUF_RES_MAN_HT_ORDER);
 	struct list_head list;
 	struct vmw_private *dev_priv;
 };
@@ -82,14 +84,13 @@ vmw_cmdbuf_res_lookup(struct vmw_cmdbuf_res_manager *man,
 		      u32 user_key)
 {
 	struct vmwgfx_hash_item *hash;
-	int ret;
 	unsigned long key = user_key | (res_type << 24);
 
-	ret = vmwgfx_ht_find_item(&man->resources, key, &hash);
-	if (unlikely(ret != 0))
-		return ERR_PTR(ret);
-
-	return drm_hash_entry(hash, struct vmw_cmdbuf_res, hash)->res;
+	hash_for_each_possible_rcu(man->resources, hash, head, key) {
+		if (hash->key == key)
+			return drm_hash_entry(hash, struct vmw_cmdbuf_res, hash)->res;
+	}
+	return ERR_PTR(-EINVAL);
 }
 
 /**
@@ -105,7 +106,7 @@ static void vmw_cmdbuf_res_free(struct vmw_cmdbuf_res_manager *man,
 				struct vmw_cmdbuf_res *entry)
 {
 	list_del(&entry->head);
-	WARN_ON(vmwgfx_ht_remove_item(&man->resources, &entry->hash));
+	hash_del_rcu(&entry->hash.head);
 	vmw_resource_unreference(&entry->res);
 	kfree(entry);
 }
@@ -159,7 +160,6 @@ void vmw_cmdbuf_res_commit(struct list_head *list)
 void vmw_cmdbuf_res_revert(struct list_head *list)
 {
 	struct vmw_cmdbuf_res *entry, *next;
-	int ret;
 
 	list_for_each_entry_safe(entry, next, list, head) {
 		switch (entry->state) {
@@ -167,8 +167,8 @@ void vmw_cmdbuf_res_revert(struct list_head *list)
 			vmw_cmdbuf_res_free(entry->man, entry);
 			break;
 		case VMW_CMDBUF_RES_DEL:
-			ret = vmwgfx_ht_insert_item(&entry->man->resources, &entry->hash);
-			BUG_ON(ret);
+			hash_add_rcu(entry->man->resources, &entry->hash.head,
+						entry->hash.key);
 			list_move_tail(&entry->head, &entry->man->list);
 			entry->state = VMW_CMDBUF_RES_COMMITTED;
 			break;
@@ -199,26 +199,20 @@ int vmw_cmdbuf_res_add(struct vmw_cmdbuf_res_manager *man,
 		       struct list_head *list)
 {
 	struct vmw_cmdbuf_res *cres;
-	int ret;
 
 	cres = kzalloc(sizeof(*cres), GFP_KERNEL);
 	if (unlikely(!cres))
 		return -ENOMEM;
 
 	cres->hash.key = user_key | (res_type << 24);
-	ret = vmwgfx_ht_insert_item(&man->resources, &cres->hash);
-	if (unlikely(ret != 0)) {
-		kfree(cres);
-		goto out_invalid_key;
-	}
+	hash_add_rcu(man->resources, &cres->hash.head, cres->hash.key);
 
 	cres->state = VMW_CMDBUF_RES_ADD;
 	cres->res = vmw_resource_reference(res);
 	cres->man = man;
 	list_add_tail(&cres->head, list);
 
-out_invalid_key:
-	return ret;
+	return 0;
 }
 
 /**
@@ -243,24 +237,26 @@ int vmw_cmdbuf_res_remove(struct vmw_cmdbuf_res_manager *man,
 			  struct list_head *list,
 			  struct vmw_resource **res_p)
 {
-	struct vmw_cmdbuf_res *entry;
+	struct vmw_cmdbuf_res *entry = NULL;
 	struct vmwgfx_hash_item *hash;
-	int ret;
+	unsigned long key = user_key | (res_type << 24);
 
-	ret = vmwgfx_ht_find_item(&man->resources, user_key | (res_type << 24),
-			       &hash);
-	if (likely(ret != 0))
+	hash_for_each_possible_rcu(man->resources, hash, head, key) {
+		if (hash->key == key) {
+			entry = drm_hash_entry(hash, struct vmw_cmdbuf_res, hash);
+			break;
+		}
+	}
+	if (unlikely(!entry))
 		return -EINVAL;
 
-	entry = drm_hash_entry(hash, struct vmw_cmdbuf_res, hash);
-
 	switch (entry->state) {
 	case VMW_CMDBUF_RES_ADD:
 		vmw_cmdbuf_res_free(man, entry);
 		*res_p = NULL;
 		break;
 	case VMW_CMDBUF_RES_COMMITTED:
-		(void) vmwgfx_ht_remove_item(&man->resources, &entry->hash);
+		hash_del_rcu(&entry->hash.head);
 		list_del(&entry->head);
 		entry->state = VMW_CMDBUF_RES_DEL;
 		list_add_tail(&entry->head, list);
@@ -287,7 +283,6 @@ struct vmw_cmdbuf_res_manager *
 vmw_cmdbuf_res_man_create(struct vmw_private *dev_priv)
 {
 	struct vmw_cmdbuf_res_manager *man;
-	int ret;
 
 	man = kzalloc(sizeof(*man), GFP_KERNEL);
 	if (!man)
@@ -295,12 +290,8 @@ vmw_cmdbuf_res_man_create(struct vmw_private *dev_priv)
 
 	man->dev_priv = dev_priv;
 	INIT_LIST_HEAD(&man->list);
-	ret = vmwgfx_ht_create(&man->resources, VMW_CMDBUF_RES_MAN_HT_ORDER);
-	if (ret == 0)
-		return man;
-
-	kfree(man);
-	return ERR_PTR(ret);
+	hash_init(man->resources);
+	return man;
 }
 
 /**
@@ -320,7 +311,6 @@ void vmw_cmdbuf_res_man_destroy(struct vmw_cmdbuf_res_manager *man)
 	list_for_each_entry_safe(entry, next, &man->list, head)
 		vmw_cmdbuf_res_free(man, entry);
 
-	vmwgfx_ht_remove(&man->resources);
 	kfree(man);
 }
 
-- 
2.35.1



