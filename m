Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DBB2244728
	for <lists+stable@lfdr.de>; Fri, 14 Aug 2020 11:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726193AbgHNJiw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Aug 2020 05:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbgHNJiv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Aug 2020 05:38:51 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CF76C061383
        for <stable@vger.kernel.org>; Fri, 14 Aug 2020 02:38:51 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id y3so7776464wrl.4
        for <stable@vger.kernel.org>; Fri, 14 Aug 2020 02:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GlRbfN15T5Cg85h0wsIiuda9qqa99m1J2oOUVAH6u5I=;
        b=fYOi3zNJmQMHegHs2QSvL5wWQhR/7lfJGqv2xN9QUjvneWY9wv3M0eKjKklrgcDoRS
         zUuAVpQsyX01dVhDn/eJhCkIN5uMBJzDBmvz49m7X4qMeyGufrAVtvwfkffHK2GpMKiQ
         0xcPUucA+BzoBQ/XXQvcMEeb9XIrX6QHzNoT4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GlRbfN15T5Cg85h0wsIiuda9qqa99m1J2oOUVAH6u5I=;
        b=Cac/IqbpTfR7WYpMUJ4Vu5cCwwMSodwric27LKNpvVrE2b70VfX/yNa9+l0c7FOPtp
         kayzmlU77gwYK/Viok41C8QtGu+1fo2GpuztvIQTHl4qi4jhwiPtHQRU1sqQegBvvIAV
         PInKkCws5KEJn7OaRnG4fVAr7meIOcyCjOmmWFg/wvKF0qUGmuepMpncV6RSCVWb4eQW
         JAP8NtWPCAvSomeh8O0vWow/9bgM0U4Owbk5phqTFIwWD9xFH+I9A3afu1L4wLvR5+I0
         K/r09I3gkcbitC0FVkLvYDuF+auGgriRoQ81LRlp7YRfqAh4hYReDZuXtTY3+RyAsIRl
         /Mww==
X-Gm-Message-State: AOAM532r3tRxJB0ecJ7vrTZ0Sldy4sm3t73Oo6RY9/2tWUWoP116cS/H
        FTejuerlXhS5/z2JAfMzXtdvRA==
X-Google-Smtp-Source: ABdhPJxJathjrmL587wR7q0nkRavVrPuzw+35i1QEWinUdWFfDqV2CL2Cu4Cf29RHiHkcGUJPuzcpQ==
X-Received: by 2002:adf:ab0d:: with SMTP id q13mr1847361wrc.134.1597397928650;
        Fri, 14 Aug 2020 02:38:48 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id t14sm13790478wrv.14.2020.08.14.02.38.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 02:38:47 -0700 (PDT)
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
To:     DRI Development <dri-devel@lists.freedesktop.org>
Cc:     Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Alex Deucher <alexdeucher@gmail.com>,
        Michal Orzel <michalorzel.eng@gmail.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, stable@vger.kernel.org,
        Daniel Vetter <daniel.vetter@intel.com>
Subject: [PATCH] drm/modeset-lock: Take the modeset BKL for legacy drivers
Date:   Fri, 14 Aug 2020 11:38:42 +0200
Message-Id: <20200814093842.3048472-1-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
References: https://gitlab.freedesktop.org/drm/amd/-/issues/1224
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
--
Patch compiles but otherwise untested, and I'll go on vacations now
for 2 weeks. Alex, can you pls take care of this?

Thanks, Daniel
---
 drivers/gpu/drm/drm_atomic_helper.c | 7 ++++---
 drivers/gpu/drm/drm_color_mgmt.c    | 2 +-
 drivers/gpu/drm/drm_crtc.c          | 4 +---
 drivers/gpu/drm/drm_mode_object.c   | 4 ++--
 drivers/gpu/drm/drm_plane.c         | 2 +-
 include/drm/drm_modeset_lock.h      | 9 +++++++--
 6 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/drm_atomic_helper.c b/drivers/gpu/drm/drm_atomic_helper.c
index f67ee513a7cc..7515a40b2056 100644
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
@@ -3109,7 +3110,7 @@ void drm_atomic_helper_shutdown(struct drm_device *dev)
 	if (ret)
 		DRM_ERROR("Disabling all crtc's during unload failed with %i\n", ret);
 
-	DRM_MODESET_LOCK_ALL_END(ctx, ret);
+	DRM_MODESET_LOCK_ALL_END(dev, ctx, ret);
 }
 EXPORT_SYMBOL(drm_atomic_helper_shutdown);
 
@@ -3249,7 +3250,7 @@ struct drm_atomic_state *drm_atomic_helper_suspend(struct drm_device *dev)
 	}
 
 unlock:
-	DRM_MODESET_LOCK_ALL_END(ctx, err);
+	DRM_MODESET_LOCK_ALL_END(dev, ctx, err);
 	if (err)
 		return ERR_PTR(err);
 
@@ -3330,7 +3331,7 @@ int drm_atomic_helper_resume(struct drm_device *dev,
 
 	err = drm_atomic_helper_commit_duplicated_state(state, &ctx);
 
-	DRM_MODESET_LOCK_ALL_END(ctx, err);
+	DRM_MODESET_LOCK_ALL_END(dev, ctx, err);
 	drm_atomic_state_put(state);
 
 	return err;
diff --git a/drivers/gpu/drm/drm_color_mgmt.c b/drivers/gpu/drm/drm_color_mgmt.c
index c93123ff7c21..138ff34b31db 100644
--- a/drivers/gpu/drm/drm_color_mgmt.c
+++ b/drivers/gpu/drm/drm_color_mgmt.c
@@ -294,7 +294,7 @@ int drm_mode_gamma_set_ioctl(struct drm_device *dev,
 				     crtc->gamma_size, &ctx);
 
 out:
-	DRM_MODESET_LOCK_ALL_END(ctx, ret);
+	DRM_MODESET_LOCK_ALL_END(dev, ctx, ret);
 	return ret;
 
 }
diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index 283bcc4362ca..aecdd7ea26dc 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -588,7 +588,6 @@ int drm_mode_setcrtc(struct drm_device *dev, void *data,
 	if (crtc_req->mode_valid && !drm_lease_held(file_priv, plane->base.id))
 		return -EACCES;
 
-	mutex_lock(&crtc->dev->mode_config.mutex);
 	DRM_MODESET_LOCK_ALL_BEGIN(dev, ctx,
 				   DRM_MODESET_ACQUIRE_INTERRUPTIBLE, ret);
 
@@ -756,8 +755,7 @@ int drm_mode_setcrtc(struct drm_device *dev, void *data,
 	fb = NULL;
 	mode = NULL;
 
-	DRM_MODESET_LOCK_ALL_END(ctx, ret);
-	mutex_unlock(&crtc->dev->mode_config.mutex);
+	DRM_MODESET_LOCK_ALL_END(dev, ctx, ret);
 
 	return ret;
 }
diff --git a/drivers/gpu/drm/drm_mode_object.c b/drivers/gpu/drm/drm_mode_object.c
index 901b078abf40..db05f386a709 100644
--- a/drivers/gpu/drm/drm_mode_object.c
+++ b/drivers/gpu/drm/drm_mode_object.c
@@ -428,7 +428,7 @@ int drm_mode_obj_get_properties_ioctl(struct drm_device *dev, void *data,
 out_unref:
 	drm_mode_object_put(obj);
 out:
-	DRM_MODESET_LOCK_ALL_END(ctx, ret);
+	DRM_MODESET_LOCK_ALL_END(dev, ctx, ret);
 	return ret;
 }
 
@@ -470,7 +470,7 @@ static int set_property_legacy(struct drm_mode_object *obj,
 		break;
 	}
 	drm_property_change_valid_put(prop, ref);
-	DRM_MODESET_LOCK_ALL_END(ctx, ret);
+	DRM_MODESET_LOCK_ALL_END(dev, ctx, ret);
 
 	return ret;
 }
diff --git a/drivers/gpu/drm/drm_plane.c b/drivers/gpu/drm/drm_plane.c
index b7b90b3a2e38..affe1cfed009 100644
--- a/drivers/gpu/drm/drm_plane.c
+++ b/drivers/gpu/drm/drm_plane.c
@@ -792,7 +792,7 @@ static int setplane_internal(struct drm_plane *plane,
 					  crtc_x, crtc_y, crtc_w, crtc_h,
 					  src_x, src_y, src_w, src_h, &ctx);
 
-	DRM_MODESET_LOCK_ALL_END(ctx, ret);
+	DRM_MODESET_LOCK_ALL_END(plane->dev, ctx, ret);
 
 	return ret;
 }
diff --git a/include/drm/drm_modeset_lock.h b/include/drm/drm_modeset_lock.h
index 4fc9a43ac45a..aafd07388eb7 100644
--- a/include/drm/drm_modeset_lock.h
+++ b/include/drm/drm_modeset_lock.h
@@ -164,6 +164,8 @@ int drm_modeset_lock_all_ctx(struct drm_device *dev,
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
-- 
2.28.0

