Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF34569CE72
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232785AbjBTN7X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:59:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232729AbjBTN7Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:59:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A8B91EFCD
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:58:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C18F460CEB
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:58:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7BBDC433D2;
        Mon, 20 Feb 2023 13:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901536;
        bh=6oDZu+NJZP7NTVee/M/XLF+prhMsOP+I9UO50H9burM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DFvagQcdxe3Vx2NKIWvkn68ptFrprpFGnCV9muxndTKncxhuzMeamTUxdJi/dLxw1
         yoy6guAkFOJ2cWHkdKdfSU8JMWMCO0OiAsZQ6oHhMsSdVe+YsLRkNyybDUy4T0qnM9
         GvjcxhXkiIMybQbKesTIXdXbcgQYlQ9q0fm1Z3iA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zack Rusin <zackr@vmware.com>,
        Martin Krastev <krastevm@vmware.com>,
        Maaz Mombasawala <mombasawalam@vmware.com>
Subject: [PATCH 6.1 054/118] drm/vmwgfx: Do not drop the reference to the handle too soon
Date:   Mon, 20 Feb 2023 14:36:10 +0100
Message-Id: <20230220133602.622924506@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

commit a950b989ea29ab3b38ea7f6e3d2540700a3c54e8 upstream.

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
Reviewed-by: Martin Krastev <krastevm@vmware.com>
Reviewed-by: Maaz Mombasawala <mombasawalam@vmware.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230211050514.2431155-1-zack@kde.org
(cherry picked from commit 9ef8d83e8e25d5f1811b3a38eb1484f85f64296c)
Cc: <stable@vger.kernel.org> # v5.17+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_bo.c      |    8 +++++---
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c |    2 ++
 drivers/gpu/drm/vmwgfx/vmwgfx_gem.c     |    4 ++--
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c     |    4 +++-
 drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c |    1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_shader.c  |    1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_surface.c |   10 ++++++----
 7 files changed, 20 insertions(+), 10 deletions(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
@@ -598,6 +598,7 @@ static int vmw_user_bo_synccpu_release(s
 		ttm_bo_put(&vmw_bo->base);
 	}
 
+	drm_gem_object_put(&vmw_bo->base.base);
 	return ret;
 }
 
@@ -638,6 +639,7 @@ int vmw_user_bo_synccpu_ioctl(struct drm
 
 		ret = vmw_user_bo_synccpu_grab(vbo, arg->flags);
 		vmw_bo_unreference(&vbo);
+		drm_gem_object_put(&vbo->base.base);
 		if (unlikely(ret != 0)) {
 			if (ret == -ERESTARTSYS || ret == -EBUSY)
 				return -EBUSY;
@@ -695,7 +697,7 @@ int vmw_bo_unref_ioctl(struct drm_device
  * struct vmw_buffer_object should be placed.
  * Return: Zero on success, Negative error code on error.
  *
- * The vmw buffer object pointer will be refcounted.
+ * The vmw buffer object pointer will be refcounted (both ttm and gem)
  */
 int vmw_user_bo_lookup(struct drm_file *filp,
 		       uint32_t handle,
@@ -712,7 +714,6 @@ int vmw_user_bo_lookup(struct drm_file *
 
 	*out = gem_to_vmw_bo(gobj);
 	ttm_bo_get(&(*out)->base);
-	drm_gem_object_put(gobj);
 
 	return 0;
 }
@@ -779,7 +780,8 @@ int vmw_dumb_create(struct drm_file *fil
 	ret = vmw_gem_object_create_with_handle(dev_priv, file_priv,
 						args->size, &args->handle,
 						&vbo);
-
+	/* drop reference from allocate - handle holds it now */
+	drm_gem_object_put(&vbo->base.base);
 	return ret;
 }
 
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -1160,6 +1160,7 @@ static int vmw_translate_mob_ptr(struct
 	}
 	ret = vmw_validation_add_bo(sw_context->ctx, vmw_bo, true, false);
 	ttm_bo_put(&vmw_bo->base);
+	drm_gem_object_put(&vmw_bo->base.base);
 	if (unlikely(ret != 0))
 		return ret;
 
@@ -1214,6 +1215,7 @@ static int vmw_translate_guest_ptr(struc
 	}
 	ret = vmw_validation_add_bo(sw_context->ctx, vmw_bo, false, false);
 	ttm_bo_put(&vmw_bo->base);
+	drm_gem_object_put(&vmw_bo->base.base);
 	if (unlikely(ret != 0))
 		return ret;
 
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_gem.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_gem.c
@@ -152,8 +152,6 @@ int vmw_gem_object_create_with_handle(st
 	(*p_vbo)->base.base.funcs = &vmw_gem_object_funcs;
 
 	ret = drm_gem_handle_create(filp, &(*p_vbo)->base.base, handle);
-	/* drop reference from allocate - handle holds it now */
-	drm_gem_object_put(&(*p_vbo)->base.base);
 out_no_bo:
 	return ret;
 }
@@ -180,6 +178,8 @@ int vmw_gem_object_create_ioctl(struct d
 	rep->map_handle = drm_vma_node_offset_addr(&vbo->base.base.vma_node);
 	rep->cur_gmr_id = handle;
 	rep->cur_gmr_offset = 0;
+	/* drop reference from allocate - handle holds it now */
+	drm_gem_object_put(&vbo->base.base);
 out_no_bo:
 	return ret;
 }
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@ -1669,8 +1669,10 @@ static struct drm_framebuffer *vmw_kms_f
 
 err_out:
 	/* vmw_user_lookup_handle takes one ref so does new_fb */
-	if (bo)
+	if (bo) {
 		vmw_bo_unreference(&bo);
+		drm_gem_object_put(&bo->base.base);
+	}
 	if (surface)
 		vmw_surface_unreference(&surface);
 
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c
@@ -458,6 +458,7 @@ int vmw_overlay_ioctl(struct drm_device
 	ret = vmw_overlay_update_stream(dev_priv, buf, arg, true);
 
 	vmw_bo_unreference(&buf);
+	drm_gem_object_put(&buf->base.base);
 
 out_unlock:
 	mutex_unlock(&overlay->mutex);
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_shader.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_shader.c
@@ -807,6 +807,7 @@ static int vmw_shader_define(struct drm_
 				    num_output_sig, tfile, shader_handle);
 out_bad_arg:
 	vmw_bo_unreference(&buffer);
+	drm_gem_object_put(&buffer->base.base);
 	return ret;
 }
 
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c
@@ -683,7 +683,7 @@ static void vmw_user_surface_base_releas
 	    container_of(base, struct vmw_user_surface, prime.base);
 	struct vmw_resource *res = &user_srf->srf.res;
 
-	if (base->shareable && res && res->backup)
+	if (res && res->backup)
 		drm_gem_object_put(&res->backup->base.base);
 
 	*p_base = NULL;
@@ -860,7 +860,11 @@ int vmw_surface_define_ioctl(struct drm_
 			goto out_unlock;
 		}
 		vmw_bo_reference(res->backup);
-		drm_gem_object_get(&res->backup->base.base);
+		/*
+		 * We don't expose the handle to the userspace and surface
+		 * already holds a gem reference
+		 */
+		drm_gem_handle_delete(file_priv, backup_handle);
 	}
 
 	tmp = vmw_resource_reference(&srf->res);
@@ -1564,8 +1568,6 @@ vmw_gb_surface_define_internal(struct dr
 			drm_vma_node_offset_addr(&res->backup->base.base.vma_node);
 		rep->buffer_size = res->backup->base.base.size;
 		rep->buffer_handle = backup_handle;
-		if (user_srf->prime.base.shareable)
-			drm_gem_object_get(&res->backup->base.base);
 	} else {
 		rep->buffer_map_handle = 0;
 		rep->buffer_size = 0;


