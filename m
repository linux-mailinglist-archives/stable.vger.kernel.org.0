Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC93150F7E5
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 11:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346370AbiDZJLS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:11:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346201AbiDZJHS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 05:07:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C978D082E;
        Tue, 26 Apr 2022 01:48:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD2FD60C42;
        Tue, 26 Apr 2022 08:48:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B41B8C385A0;
        Tue, 26 Apr 2022 08:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962900;
        bh=HId+6tXTg5x1+3jpLMDLJZA0gM91e9w+FYLycdrtnXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Nl0Bi5IhxqcMG+SPAVh+Df0yXiZ/1Dfo5r8NFHTc/2aQEBD/TIWTQ5w9jlG+S4PH
         taFPcI7Ssg4UXRHKt2oSQRq27Lu5j1vaSoiltlJjS1nqqdlTBqD7GThXmBm3m1/G2J
         VDPqM9ZqF8VhortzKhPYlYk0ppiFVqpgElHvTrvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zack Rusin <zackr@vmware.com>,
        Philipp Sieweck <psi@informatik.uni-kiel.de>,
        Maaz Mombasawala <mombasawalam@vmware.com>,
        Martin Krastev <krastevm@vmware.com>
Subject: [PATCH 5.17 126/146] drm/vmwgfx: Fix gem refcounting and memory evictions
Date:   Tue, 26 Apr 2022 10:22:01 +0200
Message-Id: <20220426081753.603340299@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zack Rusin <zackr@vmware.com>

commit 298799a28264ce400d9ff95c51b7adcb123d866e upstream.

v2: Add the last part of the ref count fix which was spotted by
Philipp Sieweck where the ref count of cpu writers is off due to
ERESTARTSYS or EBUSY during bo waits.

The initial GEM port broke refcounting on shareable (prime) surfaces and
memory evictions. The prime surfaces broke because the parent surfaces
weren't increasing the ref count on GEM surfaces, which meant that
the memory backing textures could have been deleted while the texture
was still accessible. The evictions broke due to a typo, the code was
supposed to exit if the passed buffers were not vmw_buffer_object
not if they were. They're tied because the evictions depend on having
memory to actually evict.

This fixes crashes with XA state tracker which is used for xrender
acceleration on xf86-video-vmware, apps/tests which use a lot of
memory (a good test being the piglit's streaming-texture-leak) and
desktops.

Signed-off-by: Zack Rusin <zackr@vmware.com>
Fixes: 8afa13a0583f ("drm/vmwgfx: Implement DRIVER_GEM")
Reported-by: Philipp Sieweck <psi@informatik.uni-kiel.de>
Cc: <stable@vger.kernel.org> # v5.17+
Reviewed-by: Maaz Mombasawala <mombasawalam@vmware.com>
Reviewed-by: Martin Krastev <krastevm@vmware.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220420040328.1007409-1-zack@kde.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_bo.c      |   43 ++++++++++++++------------------
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c     |    8 +----
 drivers/gpu/drm/vmwgfx/vmwgfx_surface.c |    7 ++++-
 3 files changed, 28 insertions(+), 30 deletions(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
@@ -46,6 +46,21 @@ vmw_buffer_object(struct ttm_buffer_obje
 	return container_of(bo, struct vmw_buffer_object, base);
 }
 
+/**
+ * bo_is_vmw - check if the buffer object is a &vmw_buffer_object
+ * @bo: ttm buffer object to be checked
+ *
+ * Uses destroy function associated with the object to determine if this is
+ * a &vmw_buffer_object.
+ *
+ * Returns:
+ * true if the object is of &vmw_buffer_object type, false if not.
+ */
+static bool bo_is_vmw(struct ttm_buffer_object *bo)
+{
+	return bo->destroy == &vmw_bo_bo_free ||
+	       bo->destroy == &vmw_gem_destroy;
+}
 
 /**
  * vmw_bo_pin_in_placement - Validate a buffer to placement.
@@ -615,8 +630,9 @@ int vmw_user_bo_synccpu_ioctl(struct drm
 
 		ret = vmw_user_bo_synccpu_grab(vbo, arg->flags);
 		vmw_bo_unreference(&vbo);
-		if (unlikely(ret != 0 && ret != -ERESTARTSYS &&
-			     ret != -EBUSY)) {
+		if (unlikely(ret != 0)) {
+			if (ret == -ERESTARTSYS || ret == -EBUSY)
+				return -EBUSY;
 			DRM_ERROR("Failed synccpu grab on handle 0x%08x.\n",
 				  (unsigned int) arg->handle);
 			return ret;
@@ -798,7 +814,7 @@ int vmw_dumb_create(struct drm_file *fil
 void vmw_bo_swap_notify(struct ttm_buffer_object *bo)
 {
 	/* Is @bo embedded in a struct vmw_buffer_object? */
-	if (vmw_bo_is_vmw_bo(bo))
+	if (!bo_is_vmw(bo))
 		return;
 
 	/* Kill any cached kernel maps before swapout */
@@ -822,7 +838,7 @@ void vmw_bo_move_notify(struct ttm_buffe
 	struct vmw_buffer_object *vbo;
 
 	/* Make sure @bo is embedded in a struct vmw_buffer_object? */
-	if (vmw_bo_is_vmw_bo(bo))
+	if (!bo_is_vmw(bo))
 		return;
 
 	vbo = container_of(bo, struct vmw_buffer_object, base);
@@ -843,22 +859,3 @@ void vmw_bo_move_notify(struct ttm_buffe
 	if (mem->mem_type != VMW_PL_MOB && bo->resource->mem_type == VMW_PL_MOB)
 		vmw_resource_unbind_list(vbo);
 }
-
-/**
- * vmw_bo_is_vmw_bo - check if the buffer object is a &vmw_buffer_object
- * @bo: buffer object to be checked
- *
- * Uses destroy function associated with the object to determine if this is
- * a &vmw_buffer_object.
- *
- * Returns:
- * true if the object is of &vmw_buffer_object type, false if not.
- */
-bool vmw_bo_is_vmw_bo(struct ttm_buffer_object *bo)
-{
-	if (bo->destroy == &vmw_bo_bo_free ||
-	    bo->destroy == &vmw_gem_destroy)
-		return true;
-
-	return false;
-}
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
@@ -997,13 +997,10 @@ static int vmw_driver_load(struct vmw_pr
 		goto out_no_fman;
 	}
 
-	drm_vma_offset_manager_init(&dev_priv->vma_manager,
-				    DRM_FILE_PAGE_OFFSET_START,
-				    DRM_FILE_PAGE_OFFSET_SIZE);
 	ret = ttm_device_init(&dev_priv->bdev, &vmw_bo_driver,
 			      dev_priv->drm.dev,
 			      dev_priv->drm.anon_inode->i_mapping,
-			      &dev_priv->vma_manager,
+			      dev_priv->drm.vma_offset_manager,
 			      dev_priv->map_mode == vmw_dma_alloc_coherent,
 			      false);
 	if (unlikely(ret != 0)) {
@@ -1173,7 +1170,6 @@ static void vmw_driver_unload(struct drm
 	vmw_devcaps_destroy(dev_priv);
 	vmw_vram_manager_fini(dev_priv);
 	ttm_device_fini(&dev_priv->bdev);
-	drm_vma_offset_manager_destroy(&dev_priv->vma_manager);
 	vmw_release_device_late(dev_priv);
 	vmw_fence_manager_takedown(dev_priv->fman);
 	if (dev_priv->capabilities & SVGA_CAP_IRQMASK)
@@ -1397,7 +1393,7 @@ vmw_get_unmapped_area(struct file *file,
 	struct vmw_private *dev_priv = vmw_priv(file_priv->minor->dev);
 
 	return drm_get_unmapped_area(file, uaddr, len, pgoff, flags,
-				     &dev_priv->vma_manager);
+				     dev_priv->drm.vma_offset_manager);
 }
 
 static int vmwgfx_pm_notifier(struct notifier_block *nb, unsigned long val,
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c
@@ -683,6 +683,9 @@ static void vmw_user_surface_base_releas
 	    container_of(base, struct vmw_user_surface, prime.base);
 	struct vmw_resource *res = &user_srf->srf.res;
 
+	if (base->shareable && res && res->backup)
+		drm_gem_object_put(&res->backup->base.base);
+
 	*p_base = NULL;
 	vmw_resource_unreference(&res);
 }
@@ -857,6 +860,7 @@ int vmw_surface_define_ioctl(struct drm_
 			goto out_unlock;
 		}
 		vmw_bo_reference(res->backup);
+		drm_gem_object_get(&res->backup->base.base);
 	}
 
 	tmp = vmw_resource_reference(&srf->res);
@@ -1513,7 +1517,6 @@ vmw_gb_surface_define_internal(struct dr
 							&res->backup);
 		if (ret == 0)
 			vmw_bo_reference(res->backup);
-
 	}
 
 	if (unlikely(ret != 0)) {
@@ -1561,6 +1564,8 @@ vmw_gb_surface_define_internal(struct dr
 			drm_vma_node_offset_addr(&res->backup->base.base.vma_node);
 		rep->buffer_size = res->backup->base.base.size;
 		rep->buffer_handle = backup_handle;
+		if (user_srf->prime.base.shareable)
+			drm_gem_object_get(&res->backup->base.base);
 	} else {
 		rep->buffer_map_handle = 0;
 		rep->buffer_size = 0;


