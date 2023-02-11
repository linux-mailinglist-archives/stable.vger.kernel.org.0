Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C737C692E73
	for <lists+stable@lfdr.de>; Sat, 11 Feb 2023 06:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbjBKFFX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Feb 2023 00:05:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjBKFFW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Feb 2023 00:05:22 -0500
Received: from letterbox.kde.org (letterbox.kde.org [46.43.1.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3714E1BDF
        for <stable@vger.kernel.org>; Fri, 10 Feb 2023 21:05:20 -0800 (PST)
Received: from vertex.localdomain (pool-173-49-113-140.phlapa.fios.verizon.net [173.49.113.140])
        (Authenticated sender: zack)
        by letterbox.kde.org (Postfix) with ESMTPSA id 3ED7F320F40;
        Sat, 11 Feb 2023 05:05:17 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kde.org; s=users;
        t=1676091918; bh=VE9uW2xbrRGBt1AOLbeWHee+LoPKNNj4SOnCz92UtEM=;
        h=From:To:Cc:Subject:Date:From;
        b=C5FLVW+Ogl+rB5L2rfP1ltVP90UDc5cITtSHa72tt5o8KdsUahX6CA2glnvI2FjVd
         9UnyCJLCz0rUmrRrlSejp5vA7/Zy4kBoWpHkJmyvGwvnBWTZW31YaaZF9+CvhTjogx
         mJj577q+NIhzPV6bF328O+Hq0N7MrXWgFIfMAoaiJ6MVQq8glkuEuiYD3fOhgOHUcn
         9pobWs1mhf/u2bxU+PurSae0lJMXIf0ylzvIokvq0OCsIlK3LK1neX2dh5OJCfM3Aq
         7P/GoGFnqyDL5XaFbVgyEbJBbWnH213MREa0zBmclt4at9z30K/HEh+N4QIP60sgRs
         Pkc/jPoJaeHfQ==
From:   Zack Rusin <zack@kde.org>
To:     dri-devel@lists.freedesktop.org
Cc:     krastevm@vmware.com, mombasawalam@vmware.com, banackm@vmware.com,
        Zack Rusin <zackr@vmware.com>, stable@vger.kernel.org
Subject: [PATCH v3] drm/vmwgfx: Do not drop the reference to the handle too soon
Date:   Sat, 11 Feb 2023 00:05:14 -0500
Message-Id: <20230211050514.2431155-1-zack@kde.org>
X-Mailer: git-send-email 2.38.1
Reply-To: Zack Rusin <zackr@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zack Rusin <zackr@vmware.com>

v3: Fix vmw_user_bo_lookup which was also dropping the gem reference
before the kernel was done with buffer depending on userspace doing
the right thing. Same bug, different spot.

It is possible for userspace to predict the next buffer handle and
to destroy the buffer while it's still used by the kernel. Delay
dropping the internal reference on the buffers until kernel is done
with them.

Instead of immediately dropping the gem reference in vmw_user_bo_lookup
and vmw_gem_object_create_with_handle let the callers decide when they're
ready give the control back to userspace.

Also fixes the second usage of vmw_gem_object_create_with_handle in
vmwgfx_surface.c which wasn't grabbing an explicit reference
to the gem object which could have been destroyed by the userspace
on the owning surface at any point.

Signed-off-by: Zack Rusin <zackr@vmware.com>
Fixes: 8afa13a0583f ("drm/vmwgfx: Implement DRIVER_GEM")
Cc: <stable@vger.kernel.org> # v5.17+
Reviewed-by: Martin Krastev <krastevm@vmware.com>
Reviewed-by: Maaz Mombasawala <mombasawalam@vmware.com>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_bo.c      |  8 +++++---
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c |  2 ++
 drivers/gpu/drm/vmwgfx/vmwgfx_gem.c     |  4 ++--
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c     |  4 +++-
 drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c |  1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_shader.c  |  1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_surface.c | 10 ++++++----
 7 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c b/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
index 7a00314882a3..82094c137855 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
@@ -500,6 +500,7 @@ static int vmw_user_bo_synccpu_release(struct drm_file *filp,
 		ttm_bo_put(&vmw_bo->tbo);
 	}
 
+	drm_gem_object_put(&vmw_bo->tbo.base);
 	return ret;
 }
 
@@ -540,6 +541,7 @@ int vmw_user_bo_synccpu_ioctl(struct drm_device *dev, void *data,
 
 		ret = vmw_user_bo_synccpu_grab(vbo, arg->flags);
 		vmw_bo_unreference(&vbo);
+		drm_gem_object_put(&vbo->tbo.base);
 		if (unlikely(ret != 0)) {
 			if (ret == -ERESTARTSYS || ret == -EBUSY)
 				return -EBUSY;
@@ -596,7 +598,7 @@ int vmw_bo_unref_ioctl(struct drm_device *dev, void *data,
  * struct vmw_bo should be placed.
  * Return: Zero on success, Negative error code on error.
  *
- * The vmw buffer object pointer will be refcounted.
+ * The vmw buffer object pointer will be refcounted (both ttm and gem)
  */
 int vmw_user_bo_lookup(struct drm_file *filp,
 		       u32 handle,
@@ -613,7 +615,6 @@ int vmw_user_bo_lookup(struct drm_file *filp,
 
 	*out = to_vmw_bo(gobj);
 	ttm_bo_get(&(*out)->tbo);
-	drm_gem_object_put(gobj);
 
 	return 0;
 }
@@ -693,7 +694,8 @@ int vmw_dumb_create(struct drm_file *file_priv,
 	ret = vmw_gem_object_create_with_handle(dev_priv, file_priv,
 						args->size, &args->handle,
 						&vbo);
-
+	/* drop reference from allocate - handle holds it now */
+	drm_gem_object_put(&vbo->tbo.base);
 	return ret;
 }
 
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
index 6d1b46c23719..6b9aa2b4ef54 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -1165,6 +1165,7 @@ static int vmw_translate_mob_ptr(struct vmw_private *dev_priv,
 	vmw_bo_placement_set(vmw_bo, VMW_BO_DOMAIN_MOB, VMW_BO_DOMAIN_MOB);
 	ret = vmw_validation_add_bo(sw_context->ctx, vmw_bo);
 	ttm_bo_put(&vmw_bo->tbo);
+	drm_gem_object_put(&vmw_bo->tbo.base);
 	if (unlikely(ret != 0))
 		return ret;
 
@@ -1221,6 +1222,7 @@ static int vmw_translate_guest_ptr(struct vmw_private *dev_priv,
 			     VMW_BO_DOMAIN_GMR | VMW_BO_DOMAIN_VRAM);
 	ret = vmw_validation_add_bo(sw_context->ctx, vmw_bo);
 	ttm_bo_put(&vmw_bo->tbo);
+	drm_gem_object_put(&vmw_bo->tbo.base);
 	if (unlikely(ret != 0))
 		return ret;
 
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_gem.c b/drivers/gpu/drm/vmwgfx/vmwgfx_gem.c
index 51bd1f8c5cc4..d6baf73a6458 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_gem.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_gem.c
@@ -133,8 +133,6 @@ int vmw_gem_object_create_with_handle(struct vmw_private *dev_priv,
 	(*p_vbo)->tbo.base.funcs = &vmw_gem_object_funcs;
 
 	ret = drm_gem_handle_create(filp, &(*p_vbo)->tbo.base, handle);
-	/* drop reference from allocate - handle holds it now */
-	drm_gem_object_put(&(*p_vbo)->tbo.base);
 out_no_bo:
 	return ret;
 }
@@ -161,6 +159,8 @@ int vmw_gem_object_create_ioctl(struct drm_device *dev, void *data,
 	rep->map_handle = drm_vma_node_offset_addr(&vbo->tbo.base.vma_node);
 	rep->cur_gmr_id = handle;
 	rep->cur_gmr_offset = 0;
+	/* drop reference from allocate - handle holds it now */
+	drm_gem_object_put(&vbo->tbo.base);
 out_no_bo:
 	return ret;
 }
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
index 8659de9d23f3..84d6380b9895 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@ -1725,8 +1725,10 @@ static struct drm_framebuffer *vmw_kms_fb_create(struct drm_device *dev,
 
 err_out:
 	/* vmw_user_lookup_handle takes one ref so does new_fb */
-	if (bo)
+	if (bo) {
 		vmw_bo_unreference(&bo);
+		drm_gem_object_put(&bo->tbo.base);
+	}
 	if (surface)
 		vmw_surface_unreference(&surface);
 
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c b/drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c
index 7bcda29a2897..8d171d71cb8a 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c
@@ -458,6 +458,7 @@ int vmw_overlay_ioctl(struct drm_device *dev, void *data,
 	ret = vmw_overlay_update_stream(dev_priv, buf, arg, true);
 
 	vmw_bo_unreference(&buf);
+	drm_gem_object_put(&buf->tbo.base);
 
 out_unlock:
 	mutex_unlock(&overlay->mutex);
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_shader.c b/drivers/gpu/drm/vmwgfx/vmwgfx_shader.c
index 6b8e984695ed..e7226db8b242 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_shader.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_shader.c
@@ -810,6 +810,7 @@ static int vmw_shader_define(struct drm_device *dev, struct drm_file *file_priv,
 				    num_output_sig, tfile, shader_handle);
 out_bad_arg:
 	vmw_bo_unreference(&buffer);
+	drm_gem_object_put(&buffer->tbo.base);
 	return ret;
 }
 
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c b/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c
index 9d4ae9623a00..5db403ee8261 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c
@@ -686,7 +686,7 @@ static void vmw_user_surface_base_release(struct ttm_base_object **p_base)
 	    container_of(base, struct vmw_user_surface, prime.base);
 	struct vmw_resource *res = &user_srf->srf.res;
 
-	if (base->shareable && res && res->guest_memory_bo)
+	if (res->guest_memory_bo)
 		drm_gem_object_put(&res->guest_memory_bo->tbo.base);
 
 	*p_base = NULL;
@@ -867,7 +867,11 @@ int vmw_surface_define_ioctl(struct drm_device *dev, void *data,
 			goto out_unlock;
 		}
 		vmw_bo_reference(res->guest_memory_bo);
-		drm_gem_object_get(&res->guest_memory_bo->tbo.base);
+		/*
+		 * We don't expose the handle to the userspace and surface
+		 * already holds a gem reference
+		 */
+		drm_gem_handle_delete(file_priv, backup_handle);
 	}
 
 	tmp = vmw_resource_reference(&srf->res);
@@ -1571,8 +1575,6 @@ vmw_gb_surface_define_internal(struct drm_device *dev,
 			drm_vma_node_offset_addr(&res->guest_memory_bo->tbo.base.vma_node);
 		rep->buffer_size = res->guest_memory_bo->tbo.base.size;
 		rep->buffer_handle = backup_handle;
-		if (user_srf->prime.base.shareable)
-			drm_gem_object_get(&res->guest_memory_bo->tbo.base);
 	} else {
 		rep->buffer_map_handle = 0;
 		rep->buffer_size = 0;
-- 
2.38.1

