Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40A50244EF8
	for <lists+stable@lfdr.de>; Fri, 14 Aug 2020 21:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbgHNTvl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Aug 2020 15:51:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726662AbgHNTvl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Aug 2020 15:51:41 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C845C061385
        for <stable@vger.kernel.org>; Fri, 14 Aug 2020 12:51:41 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id 3so8862664wmi.1
        for <stable@vger.kernel.org>; Fri, 14 Aug 2020 12:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZeZ9Xy6DiMTsE1qes3QZF9FoWJER7R9Dps7seD2Lcos=;
        b=Tv1LGVkgz8Ur6ku3zH9E93+hllKRcwTyZG5EpZCWVpMwTDlZ8XQMeESmJ97uyrmJJ+
         3K8aKRBj3IMfMC8hp0+gSrpWTkD4S+hhvc4CN0AAruLlYlTOcW8+wDcGSp9HA1cKywne
         GjyR8r5u8oeev4My83Vy4sUvg+Jyi4gpRYRFw89wZ0fWhij84mUOwkf2r+9DYbZak072
         8tchMEEo9fGgMZFSjmFwjJHdqJ95Md5apMbtGmjbMtUYlLgu6ILi9hlvfqqDc7POTZoD
         QbKo/QVFEG6M5LkrBwmZWzWkpg3EGvU4Bob6xBVLxGFRMSbvN21lxpQv4zwyxw5EwhTV
         9J1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZeZ9Xy6DiMTsE1qes3QZF9FoWJER7R9Dps7seD2Lcos=;
        b=GyKDYQq9bh2J8IPPZm5+itsBtu318073EQukDiq5Rxjp8DB9CAu4ippQEjVukRP/k6
         aSz+/qyG1TeP8gYmjU1xBOgi0didlr3Bq07f/gulFijMTjoT2SKu5RyU0MEBRgiys6Lk
         wQeK88ms0F5NIr5sfqAP9nSKAs4Htagz7if4WDyT9kJpvoecclql4b75MfntfufL/ZLV
         yKBqtE+/QnGJudnx1e7TIL/PetuI9DguRRbk4By11N9zZsHQn6uXccgivGfaxc317gFn
         /SwZGmJWlMm5x/gtLtPPwf4V7v1xzkvR+caZWDBHdt2YlxA8UCH+unUm7mhRAGX8YVzl
         ZTgg==
X-Gm-Message-State: AOAM5332WByuQmzer9EpX4+BZ5Gg5LOMyhqTLImR7OSSNYwwFpezfyq2
        qX+/7AAU3FJOuMIZkhFa3O4NW5JYQutHAmR4lNYiDuOb
X-Google-Smtp-Source: ABdhPJxFG7rFieLMiw1j57hM5hHPBuoZug0J3cmHUUlhNSpbU9mYTIc4HK2lhzochFmjdhFIPZMC2QUkhJoOLCzvGpE=
X-Received: by 2002:a05:600c:2209:: with SMTP id z9mr3770234wml.70.1597434699722;
 Fri, 14 Aug 2020 12:51:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200814093842.3048472-1-daniel.vetter@ffwll.ch>
In-Reply-To: <20200814093842.3048472-1-daniel.vetter@ffwll.ch>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Fri, 14 Aug 2020 15:51:28 -0400
Message-ID: <CADnq5_O5En26SyjtOHGAi8-X3Ois7J7oLJc6cmPJKpfL2torjQ@mail.gmail.com>
Subject: Re: [PATCH] drm/modeset-lock: Take the modeset BKL for legacy drivers
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Michal Orzel <michalorzel.eng@gmail.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        "for 3.8" <stable@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 14, 2020 at 5:38 AM Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
>
> This fell off in the conversion in
>
> commit 9bcaa3fe58ab7559e71df798bcff6e0795158695
> Author: Michal Orzel <michalorzel.eng@gmail.com>
> Date:   Tue Apr 28 19:10:04 2020 +0200
>
>     drm: Replace drm_modeset_lock/unlock_all with DRM_MODESET_LOCK_ALL_* helpers
>
> but it's caught by the drm_warn_on_modeset_not_all_locked() that the
> legacy modeset code uses. Since this is the bkl and it's unclear
> what's all protected, play it safe and grab it again for legacy
> drivers.
>
> Unfortunately this means we need to sprinkle a few more #includes
> around.
>
> Also we need to add the drm_device as a parameter to the _END macro.
>
> Finally remove the mute_lock() from setcrtc, since that's now done by
> the macro.
>
> Cc: Alex Deucher <alexdeucher@gmail.com>
> References: https://gitlab.freedesktop.org/drm/amd/-/issues/1224
> Fixes: 9bcaa3fe58ab ("drm: Replace drm_modeset_lock/unlock_all with DRM_MODESET_LOCK_ALL_* helpers")
> Cc: Michal Orzel <michalorzel.eng@gmail.com>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> Cc: Maxime Ripard <mripard@kernel.org>
> Cc: Thomas Zimmermann <tzimmermann@suse.de>
> Cc: David Airlie <airlied@linux.ie>
> Cc: Daniel Vetter <daniel@ffwll.ch>
> Cc: dri-devel@lists.freedesktop.org
> Cc: <stable@vger.kernel.org> # v5.8+
> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> --
> Patch compiles but otherwise untested, and I'll go on vacations now
> for 2 weeks. Alex, can you pls take care of this?

Looks good to me.
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>

Also confirmed to fix the issue.  I'll push to drm-misc.

Thanks!

Alex

>
> Thanks, Daniel
> ---
>  drivers/gpu/drm/drm_atomic_helper.c | 7 ++++---
>  drivers/gpu/drm/drm_color_mgmt.c    | 2 +-
>  drivers/gpu/drm/drm_crtc.c          | 4 +---
>  drivers/gpu/drm/drm_mode_object.c   | 4 ++--
>  drivers/gpu/drm/drm_plane.c         | 2 +-
>  include/drm/drm_modeset_lock.h      | 9 +++++++--
>  6 files changed, 16 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/gpu/drm/drm_atomic_helper.c b/drivers/gpu/drm/drm_atomic_helper.c
> index f67ee513a7cc..7515a40b2056 100644
> --- a/drivers/gpu/drm/drm_atomic_helper.c
> +++ b/drivers/gpu/drm/drm_atomic_helper.c
> @@ -34,6 +34,7 @@
>  #include <drm/drm_bridge.h>
>  #include <drm/drm_damage_helper.h>
>  #include <drm/drm_device.h>
> +#include <drm/drm_drv.h>
>  #include <drm/drm_plane_helper.h>
>  #include <drm/drm_print.h>
>  #include <drm/drm_self_refresh_helper.h>
> @@ -3109,7 +3110,7 @@ void drm_atomic_helper_shutdown(struct drm_device *dev)
>         if (ret)
>                 DRM_ERROR("Disabling all crtc's during unload failed with %i\n", ret);
>
> -       DRM_MODESET_LOCK_ALL_END(ctx, ret);
> +       DRM_MODESET_LOCK_ALL_END(dev, ctx, ret);
>  }
>  EXPORT_SYMBOL(drm_atomic_helper_shutdown);
>
> @@ -3249,7 +3250,7 @@ struct drm_atomic_state *drm_atomic_helper_suspend(struct drm_device *dev)
>         }
>
>  unlock:
> -       DRM_MODESET_LOCK_ALL_END(ctx, err);
> +       DRM_MODESET_LOCK_ALL_END(dev, ctx, err);
>         if (err)
>                 return ERR_PTR(err);
>
> @@ -3330,7 +3331,7 @@ int drm_atomic_helper_resume(struct drm_device *dev,
>
>         err = drm_atomic_helper_commit_duplicated_state(state, &ctx);
>
> -       DRM_MODESET_LOCK_ALL_END(ctx, err);
> +       DRM_MODESET_LOCK_ALL_END(dev, ctx, err);
>         drm_atomic_state_put(state);
>
>         return err;
> diff --git a/drivers/gpu/drm/drm_color_mgmt.c b/drivers/gpu/drm/drm_color_mgmt.c
> index c93123ff7c21..138ff34b31db 100644
> --- a/drivers/gpu/drm/drm_color_mgmt.c
> +++ b/drivers/gpu/drm/drm_color_mgmt.c
> @@ -294,7 +294,7 @@ int drm_mode_gamma_set_ioctl(struct drm_device *dev,
>                                      crtc->gamma_size, &ctx);
>
>  out:
> -       DRM_MODESET_LOCK_ALL_END(ctx, ret);
> +       DRM_MODESET_LOCK_ALL_END(dev, ctx, ret);
>         return ret;
>
>  }
> diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
> index 283bcc4362ca..aecdd7ea26dc 100644
> --- a/drivers/gpu/drm/drm_crtc.c
> +++ b/drivers/gpu/drm/drm_crtc.c
> @@ -588,7 +588,6 @@ int drm_mode_setcrtc(struct drm_device *dev, void *data,
>         if (crtc_req->mode_valid && !drm_lease_held(file_priv, plane->base.id))
>                 return -EACCES;
>
> -       mutex_lock(&crtc->dev->mode_config.mutex);
>         DRM_MODESET_LOCK_ALL_BEGIN(dev, ctx,
>                                    DRM_MODESET_ACQUIRE_INTERRUPTIBLE, ret);
>
> @@ -756,8 +755,7 @@ int drm_mode_setcrtc(struct drm_device *dev, void *data,
>         fb = NULL;
>         mode = NULL;
>
> -       DRM_MODESET_LOCK_ALL_END(ctx, ret);
> -       mutex_unlock(&crtc->dev->mode_config.mutex);
> +       DRM_MODESET_LOCK_ALL_END(dev, ctx, ret);
>
>         return ret;
>  }
> diff --git a/drivers/gpu/drm/drm_mode_object.c b/drivers/gpu/drm/drm_mode_object.c
> index 901b078abf40..db05f386a709 100644
> --- a/drivers/gpu/drm/drm_mode_object.c
> +++ b/drivers/gpu/drm/drm_mode_object.c
> @@ -428,7 +428,7 @@ int drm_mode_obj_get_properties_ioctl(struct drm_device *dev, void *data,
>  out_unref:
>         drm_mode_object_put(obj);
>  out:
> -       DRM_MODESET_LOCK_ALL_END(ctx, ret);
> +       DRM_MODESET_LOCK_ALL_END(dev, ctx, ret);
>         return ret;
>  }
>
> @@ -470,7 +470,7 @@ static int set_property_legacy(struct drm_mode_object *obj,
>                 break;
>         }
>         drm_property_change_valid_put(prop, ref);
> -       DRM_MODESET_LOCK_ALL_END(ctx, ret);
> +       DRM_MODESET_LOCK_ALL_END(dev, ctx, ret);
>
>         return ret;
>  }
> diff --git a/drivers/gpu/drm/drm_plane.c b/drivers/gpu/drm/drm_plane.c
> index b7b90b3a2e38..affe1cfed009 100644
> --- a/drivers/gpu/drm/drm_plane.c
> +++ b/drivers/gpu/drm/drm_plane.c
> @@ -792,7 +792,7 @@ static int setplane_internal(struct drm_plane *plane,
>                                           crtc_x, crtc_y, crtc_w, crtc_h,
>                                           src_x, src_y, src_w, src_h, &ctx);
>
> -       DRM_MODESET_LOCK_ALL_END(ctx, ret);
> +       DRM_MODESET_LOCK_ALL_END(plane->dev, ctx, ret);
>
>         return ret;
>  }
> diff --git a/include/drm/drm_modeset_lock.h b/include/drm/drm_modeset_lock.h
> index 4fc9a43ac45a..aafd07388eb7 100644
> --- a/include/drm/drm_modeset_lock.h
> +++ b/include/drm/drm_modeset_lock.h
> @@ -164,6 +164,8 @@ int drm_modeset_lock_all_ctx(struct drm_device *dev,
>   * is 0, so no error checking is necessary
>   */
>  #define DRM_MODESET_LOCK_ALL_BEGIN(dev, ctx, flags, ret)               \
> +       if (!drm_drv_uses_atomic_modeset(dev))                          \
> +               mutex_lock(&dev->mode_config.mutex);                    \
>         drm_modeset_acquire_init(&ctx, flags);                          \
>  modeset_lock_retry:                                                    \
>         ret = drm_modeset_lock_all_ctx(dev, &ctx);                      \
> @@ -172,6 +174,7 @@ modeset_lock_retry:                                                 \
>
>  /**
>   * DRM_MODESET_LOCK_ALL_END - Helper to release and cleanup modeset locks
> + * @dev: drm device
>   * @ctx: local modeset acquire context, will be dereferenced
>   * @ret: local ret/err/etc variable to track error status
>   *
> @@ -188,7 +191,7 @@ modeset_lock_retry:                                                 \
>   * to that failure. In both of these cases the code between BEGIN/END will not
>   * be run, so the failure will reflect the inability to grab the locks.
>   */
> -#define DRM_MODESET_LOCK_ALL_END(ctx, ret)                             \
> +#define DRM_MODESET_LOCK_ALL_END(dev, ctx, ret)                                \
>  modeset_lock_fail:                                                     \
>         if (ret == -EDEADLK) {                                          \
>                 ret = drm_modeset_backoff(&ctx);                        \
> @@ -196,6 +199,8 @@ modeset_lock_fail:                                                  \
>                         goto modeset_lock_retry;                        \
>         }                                                               \
>         drm_modeset_drop_locks(&ctx);                                   \
> -       drm_modeset_acquire_fini(&ctx);
> +       drm_modeset_acquire_fini(&ctx);                                 \
> +       if (!drm_drv_uses_atomic_modeset(dev))                          \
> +               mutex_unlock(&dev->mode_config.mutex);
>
>  #endif /* DRM_MODESET_LOCK_H_ */
> --
> 2.28.0
>
