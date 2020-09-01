Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12BB525959C
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731973AbgIAPxn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:53:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:37232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726479AbgIAPqz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:46:55 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62A89206FA;
        Tue,  1 Sep 2020 15:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598975214;
        bh=A4CdEKrM7MiMR+gTtxnqFV7r8Lw8t5UvQxFbdJagD5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CLKCu2P+KQDXmF2atedjVLD/y/pRevT8XAx21LaZLGOAlnFThx/FqkbCxIf5g48pm
         m1e+1t+IUZa5HZVlkaNevnNBGioqJ3jJEABVioyU5+ug0uUCIckLEmr2h4Qo+X1bK3
         +Oz/RW4agx42tXA/XC/4GNVQRorW+HaPFK1fDq3I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Deucher <alexdeucher@gmail.com>,
        Michal Orzel <michalorzel.eng@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@intel.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.8 213/255] drm/modeset-lock: Take the modeset BKL for legacy drivers
Date:   Tue,  1 Sep 2020 17:11:09 +0200
Message-Id: <20200901151010.906899727@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Vetter <daniel.vetter@intel.com>

commit 77ef38574beb3e0b414db48e9c0f04633df68ba6 upstream.

This fell off in the conversion in

commit 9bcaa3fe58ab7559e71df798bcff6e0795158695
Author: Michal Orzel <michalorzel.eng@gmail.com>
Date:   Tue Apr 28 19:10:04 2020 +0200

    drm: Replace drm_modeset_lock/unlock_all with DRM_MODESET_LOCK_ALL_* helpers

but it's caught by the drm_warn_on_modeset_not_all_locked() that the
legacy modeset code uses. Since this is the bkl and it's unclear
what's all protected, play it safe and grab it again for legacy
drivers.

Unfortunately this means we need to sprinkle a few more #includes
around.

Also we need to add the drm_device as a parameter to the _END macro.

Finally remove the mute_lock() from setcrtc, since that's now done by
the macro.

Cc: Alex Deucher <alexdeucher@gmail.com>
Fixes: 9bcaa3fe58ab ("drm: Replace drm_modeset_lock/unlock_all with DRM_MODESET_LOCK_ALL_* helpers")
Cc: Michal Orzel <michalorzel.eng@gmail.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v5.8+
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200814093842.3048472-1-daniel.vetter@ffwll.ch
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_atomic_helper.c |    7 ++++---
 drivers/gpu/drm/drm_color_mgmt.c    |    2 +-
 drivers/gpu/drm/drm_crtc.c          |    4 +---
 drivers/gpu/drm/drm_mode_object.c   |    4 ++--
 drivers/gpu/drm/drm_plane.c         |    2 +-
 include/drm/drm_modeset_lock.h      |    9 +++++++--
 6 files changed, 16 insertions(+), 12 deletions(-)

--- a/drivers/gpu/drm/drm_atomic_helper.c
+++ b/drivers/gpu/drm/drm_atomic_helper.c
@@ -34,6 +34,7 @@
 #include <drm/drm_bridge.h>
 #include <drm/drm_damage_helper.h>
 #include <drm/drm_device.h>
+#include <drm/drm_drv.h>
 #include <drm/drm_plane_helper.h>
 #include <drm/drm_print.h>
 #include <drm/drm_self_refresh_helper.h>
@@ -3105,7 +3106,7 @@ void drm_atomic_helper_shutdown(struct d
 	if (ret)
 		DRM_ERROR("Disabling all crtc's during unload failed with %i\n", ret);
 
-	DRM_MODESET_LOCK_ALL_END(ctx, ret);
+	DRM_MODESET_LOCK_ALL_END(dev, ctx, ret);
 }
 EXPORT_SYMBOL(drm_atomic_helper_shutdown);
 
@@ -3245,7 +3246,7 @@ struct drm_atomic_state *drm_atomic_help
 	}
 
 unlock:
-	DRM_MODESET_LOCK_ALL_END(ctx, err);
+	DRM_MODESET_LOCK_ALL_END(dev, ctx, err);
 	if (err)
 		return ERR_PTR(err);
 
@@ -3326,7 +3327,7 @@ int drm_atomic_helper_resume(struct drm_
 
 	err = drm_atomic_helper_commit_duplicated_state(state, &ctx);
 
-	DRM_MODESET_LOCK_ALL_END(ctx, err);
+	DRM_MODESET_LOCK_ALL_END(dev, ctx, err);
 	drm_atomic_state_put(state);
 
 	return err;
--- a/drivers/gpu/drm/drm_color_mgmt.c
+++ b/drivers/gpu/drm/drm_color_mgmt.c
@@ -294,7 +294,7 @@ int drm_mode_gamma_set_ioctl(struct drm_
 				     crtc->gamma_size, &ctx);
 
 out:
-	DRM_MODESET_LOCK_ALL_END(ctx, ret);
+	DRM_MODESET_LOCK_ALL_END(dev, ctx, ret);
 	return ret;
 
 }
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -561,7 +561,6 @@ int drm_mode_setcrtc(struct drm_device *
 	if (crtc_req->mode_valid && !drm_lease_held(file_priv, plane->base.id))
 		return -EACCES;
 
-	mutex_lock(&crtc->dev->mode_config.mutex);
 	DRM_MODESET_LOCK_ALL_BEGIN(dev, ctx,
 				   DRM_MODESET_ACQUIRE_INTERRUPTIBLE, ret);
 
@@ -728,8 +727,7 @@ out:
 	fb = NULL;
 	mode = NULL;
 
-	DRM_MODESET_LOCK_ALL_END(ctx, ret);
-	mutex_unlock(&crtc->dev->mode_config.mutex);
+	DRM_MODESET_LOCK_ALL_END(dev, ctx, ret);
 
 	return ret;
 }
--- a/drivers/gpu/drm/drm_mode_object.c
+++ b/drivers/gpu/drm/drm_mode_object.c
@@ -428,7 +428,7 @@ int drm_mode_obj_get_properties_ioctl(st
 out_unref:
 	drm_mode_object_put(obj);
 out:
-	DRM_MODESET_LOCK_ALL_END(ctx, ret);
+	DRM_MODESET_LOCK_ALL_END(dev, ctx, ret);
 	return ret;
 }
 
@@ -470,7 +470,7 @@ static int set_property_legacy(struct dr
 		break;
 	}
 	drm_property_change_valid_put(prop, ref);
-	DRM_MODESET_LOCK_ALL_END(ctx, ret);
+	DRM_MODESET_LOCK_ALL_END(dev, ctx, ret);
 
 	return ret;
 }
--- a/drivers/gpu/drm/drm_plane.c
+++ b/drivers/gpu/drm/drm_plane.c
@@ -791,7 +791,7 @@ static int setplane_internal(struct drm_
 					  crtc_x, crtc_y, crtc_w, crtc_h,
 					  src_x, src_y, src_w, src_h, &ctx);
 
-	DRM_MODESET_LOCK_ALL_END(ctx, ret);
+	DRM_MODESET_LOCK_ALL_END(plane->dev, ctx, ret);
 
 	return ret;
 }
--- a/include/drm/drm_modeset_lock.h
+++ b/include/drm/drm_modeset_lock.h
@@ -164,6 +164,8 @@ int drm_modeset_lock_all_ctx(struct drm_
  * is 0, so no error checking is necessary
  */
 #define DRM_MODESET_LOCK_ALL_BEGIN(dev, ctx, flags, ret)		\
+	if (!drm_drv_uses_atomic_modeset(dev))				\
+		mutex_lock(&dev->mode_config.mutex);			\
 	drm_modeset_acquire_init(&ctx, flags);				\
 modeset_lock_retry:							\
 	ret = drm_modeset_lock_all_ctx(dev, &ctx);			\
@@ -172,6 +174,7 @@ modeset_lock_retry:							\
 
 /**
  * DRM_MODESET_LOCK_ALL_END - Helper to release and cleanup modeset locks
+ * @dev: drm device
  * @ctx: local modeset acquire context, will be dereferenced
  * @ret: local ret/err/etc variable to track error status
  *
@@ -188,7 +191,7 @@ modeset_lock_retry:							\
  * to that failure. In both of these cases the code between BEGIN/END will not
  * be run, so the failure will reflect the inability to grab the locks.
  */
-#define DRM_MODESET_LOCK_ALL_END(ctx, ret)				\
+#define DRM_MODESET_LOCK_ALL_END(dev, ctx, ret)				\
 modeset_lock_fail:							\
 	if (ret == -EDEADLK) {						\
 		ret = drm_modeset_backoff(&ctx);			\
@@ -196,6 +199,8 @@ modeset_lock_fail:							\
 			goto modeset_lock_retry;			\
 	}								\
 	drm_modeset_drop_locks(&ctx);					\
-	drm_modeset_acquire_fini(&ctx);
+	drm_modeset_acquire_fini(&ctx);					\
+	if (!drm_drv_uses_atomic_modeset(dev))				\
+		mutex_unlock(&dev->mode_config.mutex);
 
 #endif /* DRM_MODESET_LOCK_H_ */


