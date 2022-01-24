Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1E2E49A490
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:09:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2371565AbiAYAIj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:08:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2363954AbiAXXq1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:46:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B815C0BD130;
        Mon, 24 Jan 2022 13:40:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57F2FB81142;
        Mon, 24 Jan 2022 21:40:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F90FC340E7;
        Mon, 24 Jan 2022 21:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060449;
        bh=+BUX2ce92f50v3eT6BDPKhljeKXX+4pxIuGRPS/+NDY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=biEKpIVoeraIRuB0HWO5tkozG9BWf3L1wwxggc/IORlk/XdkFr+uGCTJVOey36kt3
         BFIhRGHMQ8yOV7tp1NeDApATP+O9HsSE1O2IZEZkeCmjP31qY6rhUPmL8Dp15m6nVa
         reW84Xev46/F7Kz8qSaQd37rIJZZvLXE+h9RP6U8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zack Rusin <zackr@vmware.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= 
        <thomas.hellstrom@linux.intel.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Martin Krastev <krastevm@vmware.com>,
        Maaz Mombasawala <mombasawalam@vmware.com>,
        Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 5.16 0952/1039] drm/vmwgfx: Remove explicit transparent hugepages support
Date:   Mon, 24 Jan 2022 19:45:41 +0100
Message-Id: <20220124184157.286756514@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zack Rusin <zackr@vmware.com>

commit bc701a28c74e78d7b5aa2b8628cb3608d4785d14 upstream.

Old versions of the svga device used to export virtual vram, handling of
which was optimized on top of transparent hugepages support. Only very
old devices (OpenGL 2.1 support and earlier) used this code and at this
point performance differences are negligible.

Because the code requires very old hardware versions to run it has
been largely untested and unused for a long time.

Furthermore removal of the ttm hugepages support in:
commit 0d979509539e ("drm/ttm: remove ttm_bo_vm_insert_huge()")
broke the coherency mode in vmwgfx when running with hugepages.

Fixes: 0d979509539e ("drm/ttm: remove ttm_bo_vm_insert_huge()")
Signed-off-by: Zack Rusin <zackr@vmware.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Martin Krastev <krastevm@vmware.com>
Reviewed-by: Maaz Mombasawala <mombasawalam@vmware.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211215184147.3688785-2-zack@kde.org
(cherry picked from commit 49d535d64d52945e2c874f380705675e20a02b6a)
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vmwgfx/Makefile     |    1 
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c |    8 -
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h |    5 
 drivers/gpu/drm/vmwgfx/vmwgfx_thp.c |  184 ------------------------------------
 4 files changed, 198 deletions(-)
 delete mode 100644 drivers/gpu/drm/vmwgfx/vmwgfx_thp.c

--- a/drivers/gpu/drm/vmwgfx/Makefile
+++ b/drivers/gpu/drm/vmwgfx/Makefile
@@ -12,6 +12,5 @@ vmwgfx-y := vmwgfx_execbuf.o vmwgfx_gmr.
 	    vmwgfx_devcaps.o ttm_object.o ttm_memory.o vmwgfx_system_manager.o
 
 vmwgfx-$(CONFIG_DRM_FBDEV_EMULATION) += vmwgfx_fb.o
-vmwgfx-$(CONFIG_TRANSPARENT_HUGEPAGE) += vmwgfx_thp.o
 
 obj-$(CONFIG_DRM_VMWGFX) := vmwgfx.o
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
@@ -707,23 +707,15 @@ static int vmw_dma_masks(struct vmw_priv
 static int vmw_vram_manager_init(struct vmw_private *dev_priv)
 {
 	int ret;
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	ret = vmw_thp_init(dev_priv);
-#else
 	ret = ttm_range_man_init(&dev_priv->bdev, TTM_PL_VRAM, false,
 				 dev_priv->vram_size >> PAGE_SHIFT);
-#endif
 	ttm_resource_manager_set_used(ttm_manager_type(&dev_priv->bdev, TTM_PL_VRAM), false);
 	return ret;
 }
 
 static void vmw_vram_manager_fini(struct vmw_private *dev_priv)
 {
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	vmw_thp_fini(dev_priv);
-#else
 	ttm_range_man_fini(&dev_priv->bdev, TTM_PL_VRAM);
-#endif
 }
 
 static int vmw_setup_pci_resources(struct vmw_private *dev,
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
@@ -1557,11 +1557,6 @@ void vmw_bo_dirty_unmap(struct vmw_buffe
 vm_fault_t vmw_bo_vm_fault(struct vm_fault *vmf);
 vm_fault_t vmw_bo_vm_mkwrite(struct vm_fault *vmf);
 
-/* Transparent hugepage support - vmwgfx_thp.c */
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-extern int vmw_thp_init(struct vmw_private *dev_priv);
-void vmw_thp_fini(struct vmw_private *dev_priv);
-#endif
 
 /**
  * VMW_DEBUG_KMS - Debug output for kernel mode-setting
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_thp.c
+++ /dev/null
@@ -1,184 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0 OR MIT
-/*
- * Huge page-table-entry support for IO memory.
- *
- * Copyright (C) 2007-2019 Vmware, Inc. All rights reservedd.
- */
-#include "vmwgfx_drv.h"
-#include <drm/ttm/ttm_bo_driver.h>
-#include <drm/ttm/ttm_placement.h>
-#include <drm/ttm/ttm_range_manager.h>
-
-/**
- * struct vmw_thp_manager - Range manager implementing huge page alignment
- *
- * @manager: TTM resource manager.
- * @mm: The underlying range manager. Protected by @lock.
- * @lock: Manager lock.
- */
-struct vmw_thp_manager {
-	struct ttm_resource_manager manager;
-	struct drm_mm mm;
-	spinlock_t lock;
-};
-
-static struct vmw_thp_manager *to_thp_manager(struct ttm_resource_manager *man)
-{
-	return container_of(man, struct vmw_thp_manager, manager);
-}
-
-static const struct ttm_resource_manager_func vmw_thp_func;
-
-static int vmw_thp_insert_aligned(struct ttm_buffer_object *bo,
-				  struct drm_mm *mm, struct drm_mm_node *node,
-				  unsigned long align_pages,
-				  const struct ttm_place *place,
-				  struct ttm_resource *mem,
-				  unsigned long lpfn,
-				  enum drm_mm_insert_mode mode)
-{
-	if (align_pages >= bo->page_alignment &&
-	    (!bo->page_alignment || align_pages % bo->page_alignment == 0)) {
-		return drm_mm_insert_node_in_range(mm, node,
-						   mem->num_pages,
-						   align_pages, 0,
-						   place->fpfn, lpfn, mode);
-	}
-
-	return -ENOSPC;
-}
-
-static int vmw_thp_get_node(struct ttm_resource_manager *man,
-			    struct ttm_buffer_object *bo,
-			    const struct ttm_place *place,
-			    struct ttm_resource **res)
-{
-	struct vmw_thp_manager *rman = to_thp_manager(man);
-	struct drm_mm *mm = &rman->mm;
-	struct ttm_range_mgr_node *node;
-	unsigned long align_pages;
-	unsigned long lpfn;
-	enum drm_mm_insert_mode mode = DRM_MM_INSERT_BEST;
-	int ret;
-
-	node = kzalloc(struct_size(node, mm_nodes, 1), GFP_KERNEL);
-	if (!node)
-		return -ENOMEM;
-
-	ttm_resource_init(bo, place, &node->base);
-
-	lpfn = place->lpfn;
-	if (!lpfn)
-		lpfn = man->size;
-
-	mode = DRM_MM_INSERT_BEST;
-	if (place->flags & TTM_PL_FLAG_TOPDOWN)
-		mode = DRM_MM_INSERT_HIGH;
-
-	spin_lock(&rman->lock);
-	if (IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)) {
-		align_pages = (HPAGE_PUD_SIZE >> PAGE_SHIFT);
-		if (node->base.num_pages >= align_pages) {
-			ret = vmw_thp_insert_aligned(bo, mm, &node->mm_nodes[0],
-						     align_pages, place,
-						     &node->base, lpfn, mode);
-			if (!ret)
-				goto found_unlock;
-		}
-	}
-
-	align_pages = (HPAGE_PMD_SIZE >> PAGE_SHIFT);
-	if (node->base.num_pages >= align_pages) {
-		ret = vmw_thp_insert_aligned(bo, mm, &node->mm_nodes[0],
-					     align_pages, place, &node->base,
-					     lpfn, mode);
-		if (!ret)
-			goto found_unlock;
-	}
-
-	ret = drm_mm_insert_node_in_range(mm, &node->mm_nodes[0],
-					  node->base.num_pages,
-					  bo->page_alignment, 0,
-					  place->fpfn, lpfn, mode);
-found_unlock:
-	spin_unlock(&rman->lock);
-
-	if (unlikely(ret)) {
-		kfree(node);
-	} else {
-		node->base.start = node->mm_nodes[0].start;
-		*res = &node->base;
-	}
-
-	return ret;
-}
-
-static void vmw_thp_put_node(struct ttm_resource_manager *man,
-			     struct ttm_resource *res)
-{
-	struct ttm_range_mgr_node *node = to_ttm_range_mgr_node(res);
-	struct vmw_thp_manager *rman = to_thp_manager(man);
-
-	spin_lock(&rman->lock);
-	drm_mm_remove_node(&node->mm_nodes[0]);
-	spin_unlock(&rman->lock);
-
-	kfree(node);
-}
-
-int vmw_thp_init(struct vmw_private *dev_priv)
-{
-	struct vmw_thp_manager *rman;
-
-	rman = kzalloc(sizeof(*rman), GFP_KERNEL);
-	if (!rman)
-		return -ENOMEM;
-
-	ttm_resource_manager_init(&rman->manager,
-				  dev_priv->vram_size >> PAGE_SHIFT);
-
-	rman->manager.func = &vmw_thp_func;
-	drm_mm_init(&rman->mm, 0, rman->manager.size);
-	spin_lock_init(&rman->lock);
-
-	ttm_set_driver_manager(&dev_priv->bdev, TTM_PL_VRAM, &rman->manager);
-	ttm_resource_manager_set_used(&rman->manager, true);
-	return 0;
-}
-
-void vmw_thp_fini(struct vmw_private *dev_priv)
-{
-	struct ttm_resource_manager *man = ttm_manager_type(&dev_priv->bdev, TTM_PL_VRAM);
-	struct vmw_thp_manager *rman = to_thp_manager(man);
-	struct drm_mm *mm = &rman->mm;
-	int ret;
-
-	ttm_resource_manager_set_used(man, false);
-
-	ret = ttm_resource_manager_evict_all(&dev_priv->bdev, man);
-	if (ret)
-		return;
-	spin_lock(&rman->lock);
-	drm_mm_clean(mm);
-	drm_mm_takedown(mm);
-	spin_unlock(&rman->lock);
-	ttm_resource_manager_cleanup(man);
-	ttm_set_driver_manager(&dev_priv->bdev, TTM_PL_VRAM, NULL);
-	kfree(rman);
-}
-
-static void vmw_thp_debug(struct ttm_resource_manager *man,
-			  struct drm_printer *printer)
-{
-	struct vmw_thp_manager *rman = to_thp_manager(man);
-
-	spin_lock(&rman->lock);
-	drm_mm_print(&rman->mm, printer);
-	spin_unlock(&rman->lock);
-}
-
-static const struct ttm_resource_manager_func vmw_thp_func = {
-	.alloc = vmw_thp_get_node,
-	.free = vmw_thp_put_node,
-	.debug = vmw_thp_debug
-};


