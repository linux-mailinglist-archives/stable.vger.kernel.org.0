Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B24966C4F6
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231863AbjAPQAW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:00:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231470AbjAPQAA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:00:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CC1423C7B
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:59:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B7F3B8105C
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:59:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8034C433D2;
        Mon, 16 Jan 2023 15:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884796;
        bh=uZWdHrBHqTriIG2YZjbTVy0K4hfjwYU0RzNGPLzJ5ZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nCmHRMbUoi2vxxlemFWynqQjPltS6s4+z1U3+PFF7mDqkYg9XLjnhK48rC1ZTzX26
         3JgVrGZeOd8gIuqLxx9TwVWw9KVjzEhC1805uOXGAY/56pXYW5AQ6+7awT6VRLtGFJ
         C/zXj1896gYHlYr2u8jTmj+CZhfY8LlSNg4FeUmU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Maaz Mombasawala <mombasawalam@vmware.com>,
        Zack Rusin <zackr@vmware.com>,
        Martin Krastev <krastevm@vmware.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 143/183] drm/vmwgfx: Remove ttm object hashtable
Date:   Mon, 16 Jan 2023 16:51:06 +0100
Message-Id: <20230116154809.392186330@linuxfoundation.org>
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

[ Upstream commit 931e09d8d5b4aa19bdae0234f2727049f1cd13d9 ]

The object_hash hashtable for ttm objects is not being used.
Remove it and perform refactoring in ttm_object init function.

Signed-off-by: Maaz Mombasawala <mombasawalam@vmware.com>
Reviewed-by: Zack Rusin <zackr@vmware.com>
Reviewed-by: Martin Krastev <krastevm@vmware.com>
Signed-off-by: Zack Rusin <zackr@vmware.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221022040236.616490-5-zack@kde.org
Stable-dep-of: a309c7194e8a ("drm/vmwgfx: Remove rcu locks from user resources")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/ttm_object.c | 24 ++++++------------------
 drivers/gpu/drm/vmwgfx/ttm_object.h |  6 ++----
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c |  2 +-
 3 files changed, 9 insertions(+), 23 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/ttm_object.c b/drivers/gpu/drm/vmwgfx/ttm_object.c
index 26a55fef1ab5..9546b121bc22 100644
--- a/drivers/gpu/drm/vmwgfx/ttm_object.c
+++ b/drivers/gpu/drm/vmwgfx/ttm_object.c
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 OR MIT */
 /**************************************************************************
  *
- * Copyright (c) 2009-2013 VMware, Inc., Palo Alto, CA., USA
+ * Copyright (c) 2009-2022 VMware, Inc., Palo Alto, CA., USA
  * All Rights Reserved.
  *
  * Permission is hereby granted, free of charge, to any person obtaining a
@@ -44,13 +44,14 @@
 
 #define pr_fmt(fmt) "[TTM] " fmt
 
+#include "ttm_object.h"
+#include "vmwgfx_drv.h"
+
 #include <linux/list.h>
 #include <linux/spinlock.h>
 #include <linux/slab.h>
 #include <linux/atomic.h>
 #include <linux/module.h>
-#include "ttm_object.h"
-#include "vmwgfx_drv.h"
 
 MODULE_IMPORT_NS(DMA_BUF);
 
@@ -81,9 +82,7 @@ struct ttm_object_file {
 /*
  * struct ttm_object_device
  *
- * @object_lock: lock that protects the object_hash hash table.
- *
- * @object_hash: hash table for fast lookup of object global names.
+ * @object_lock: lock that protects idr.
  *
  * @object_count: Per device object count.
  *
@@ -92,7 +91,6 @@ struct ttm_object_file {
 
 struct ttm_object_device {
 	spinlock_t object_lock;
-	struct vmwgfx_open_hash object_hash;
 	atomic_t object_count;
 	struct dma_buf_ops ops;
 	void (*dmabuf_release)(struct dma_buf *dma_buf);
@@ -449,20 +447,15 @@ struct ttm_object_file *ttm_object_file_init(struct ttm_object_device *tdev,
 }
 
 struct ttm_object_device *
-ttm_object_device_init(unsigned int hash_order,
-		       const struct dma_buf_ops *ops)
+ttm_object_device_init(const struct dma_buf_ops *ops)
 {
 	struct ttm_object_device *tdev = kmalloc(sizeof(*tdev), GFP_KERNEL);
-	int ret;
 
 	if (unlikely(tdev == NULL))
 		return NULL;
 
 	spin_lock_init(&tdev->object_lock);
 	atomic_set(&tdev->object_count, 0);
-	ret = vmwgfx_ht_create(&tdev->object_hash, hash_order);
-	if (ret != 0)
-		goto out_no_object_hash;
 
 	/*
 	 * Our base is at VMWGFX_NUM_MOB + 1 because we want to create
@@ -477,10 +470,6 @@ ttm_object_device_init(unsigned int hash_order,
 	tdev->dmabuf_release = tdev->ops.release;
 	tdev->ops.release = ttm_prime_dmabuf_release;
 	return tdev;
-
-out_no_object_hash:
-	kfree(tdev);
-	return NULL;
 }
 
 void ttm_object_device_release(struct ttm_object_device **p_tdev)
@@ -491,7 +480,6 @@ void ttm_object_device_release(struct ttm_object_device **p_tdev)
 
 	WARN_ON_ONCE(!idr_is_empty(&tdev->idr));
 	idr_destroy(&tdev->idr);
-	vmwgfx_ht_remove(&tdev->object_hash);
 
 	kfree(tdev);
 }
diff --git a/drivers/gpu/drm/vmwgfx/ttm_object.h b/drivers/gpu/drm/vmwgfx/ttm_object.h
index 1a2fa0f83f5f..6870f951b677 100644
--- a/drivers/gpu/drm/vmwgfx/ttm_object.h
+++ b/drivers/gpu/drm/vmwgfx/ttm_object.h
@@ -1,6 +1,6 @@
 /**************************************************************************
  *
- * Copyright (c) 2006-2009 VMware, Inc., Palo Alto, CA., USA
+ * Copyright (c) 2006-2022 VMware, Inc., Palo Alto, CA., USA
  * All Rights Reserved.
  *
  * Permission is hereby granted, free of charge, to any person obtaining a
@@ -262,7 +262,6 @@ extern void ttm_object_file_release(struct ttm_object_file **p_tfile);
 /**
  * ttm_object device init - initialize a struct ttm_object_device
  *
- * @hash_order: Order of hash table used to hash the base objects.
  * @ops: DMA buf ops for prime objects of this device.
  *
  * This function is typically called on device initialization to prepare
@@ -270,8 +269,7 @@ extern void ttm_object_file_release(struct ttm_object_file **p_tfile);
  */
 
 extern struct ttm_object_device *
-ttm_object_device_init(unsigned int hash_order,
-		       const struct dma_buf_ops *ops);
+ttm_object_device_init(const struct dma_buf_ops *ops);
 
 /**
  * ttm_object_device_release - release data held by a ttm_object_device
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
index 45028e25d490..13b90273eb77 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
@@ -994,7 +994,7 @@ static int vmw_driver_load(struct vmw_private *dev_priv, u32 pci_id)
 		goto out_err0;
 	}
 
-	dev_priv->tdev = ttm_object_device_init(12, &vmw_prime_dmabuf_ops);
+	dev_priv->tdev = ttm_object_device_init(&vmw_prime_dmabuf_ops);
 
 	if (unlikely(dev_priv->tdev == NULL)) {
 		drm_err(&dev_priv->drm,
-- 
2.35.1



