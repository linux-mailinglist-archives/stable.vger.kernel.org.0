Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA7014FEA4
	for <lists+stable@lfdr.de>; Sun,  2 Feb 2020 18:38:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgBBRiG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 2 Feb 2020 12:38:06 -0500
Received: from mail.fireflyinternet.com ([77.68.26.236]:51322 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726525AbgBBRiG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Feb 2020 12:38:06 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 20092098-1500050 
        for multiple; Sun, 02 Feb 2020 17:37:33 +0000
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To:     DRI Development <dri-devel@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
From:   Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <20200202132133.1891846-1-daniel.vetter@ffwll.ch>
Cc:     Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Hillf Danton <hdanton@sina.com>, stable@vger.kernel.org,
        Emil Velikov <emil.velikov@collabora.com>,
        Sean Paul <seanpaul@chromium.org>,
        Eric Anholt <eric@anholt.net>, Sam Ravnborg <sam@ravnborg.org>,
        Rob Clark <robdclark@chromium.org>,
        Daniel Vetter <daniel.vetter@intel.com>
References: <20200202132133.1891846-1-daniel.vetter@ffwll.ch>
Message-ID: <158066505178.17828.178213696291677257@skylake-alporthouse-com>
User-Agent: alot/0.6
Subject: Re: [PATCH] drm/vgem: Close use-after-free race in vgem_gem_create
Date:   Sun, 02 Feb 2020 17:37:31 +0000
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Daniel Vetter (2020-02-02 13:21:33)
> There's two references floating around here (for the object reference,
> not the handle_count reference, that's a different thing):
> 
> - The temporary reference held by vgem_gem_create, acquired by
>   creating the object and released by calling
>   drm_gem_object_put_unlocked.
> 
> - The reference held by the object handle, created by
>   drm_gem_handle_create. This one generally outlives the function,
>   except if a 2nd thread races with a GEM_CLOSE ioctl call.
> 
> So usually everything is correct, except in that race case, where the
> access to gem_object->size could be looking at freed data already.
> Which again isn't a real problem (userspace shot its feet off already
> with the race, we could return garbage), but maybe someone can exploit
> this as an information leak.
> 
> Cc: Dan Carpenter <dan.carpenter@oracle.com>
> Cc: Hillf Danton <hdanton@sina.com>
> Cc: Reported-by: syzbot+0dc4444774d419e916c8@syzkaller.appspotmail.com
> Cc: stable@vger.kernel.org
> Cc: Emil Velikov <emil.velikov@collabora.com>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Sean Paul <seanpaul@chromium.org>
> Cc: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Eric Anholt <eric@anholt.net>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: Rob Clark <robdclark@chromium.org>
> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> ---
>  drivers/gpu/drm/vgem/vgem_drv.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpu/drm/vgem/vgem_drv.c b/drivers/gpu/drm/vgem/vgem_drv.c
> index 5bd60ded3d81..909eba43664a 100644
> --- a/drivers/gpu/drm/vgem/vgem_drv.c
> +++ b/drivers/gpu/drm/vgem/vgem_drv.c
> @@ -196,9 +196,10 @@ static struct drm_gem_object *vgem_gem_create(struct drm_device *dev,
>                 return ERR_CAST(obj);
>  
>         ret = drm_gem_handle_create(file, &obj->base, handle);
> -       drm_gem_object_put_unlocked(&obj->base);
> -       if (ret)
> +       if (ret) {
> +               drm_gem_object_put_unlocked(&obj->base);
>                 return ERR_PTR(ret);
> +       }
>  
>         return &obj->base;
>  }
> @@ -221,7 +222,9 @@ static int vgem_gem_dumb_create(struct drm_file *file, struct drm_device *dev,
>         args->size = gem_object->size;
>         args->pitch = pitch;
>  
> -       DRM_DEBUG("Created object of size %lld\n", size);
> +       drm_gem_object_put_unlocked(gem_object);
> +
> +       DRM_DEBUG("Created object of size %llu\n", args->size);

I was thinking we either should return size from vgem_gem_create (the
strategy we took in i915) or simply remove the vgem_gem_create() as that
doesn't improve readability.

-static struct drm_gem_object *vgem_gem_create(struct drm_device *dev,
-                                             struct drm_file *file,
-                                             unsigned int *handle,
-                                             unsigned long size)
+static int vgem_gem_dumb_create(struct drm_file *file, struct drm_device *dev,
+                               struct drm_mode_create_dumb *args)
 {
        struct drm_vgem_gem_object *obj;
-       int ret;
+       u64 pitch, size;
+       u32 handle;
+
+       pitch = args->width * DIV_ROUND_UP(args->bpp, 8);
+       size = mul_u32_u32(args->height, pitch);
+       if (size == 0 || pitch < args->width)
+               return -EINVAL;

        obj = __vgem_gem_create(dev, size);
        if (IS_ERR(obj))
-               return ERR_CAST(obj);
+               return PTR_ERR(obj);
+
+       size = obj->base.size;

-       ret = drm_gem_handle_create(file, &obj->base, handle);
+       ret = drm_gem_handle_create(file, &obj->base, &handle);
        drm_gem_object_put_unlocked(&obj->base);
        if (ret)
                return ERR_PTR(ret);

-       return &obj->base;
-}
-
-static int vgem_gem_dumb_create(struct drm_file *file, struct drm_device *dev,
-                               struct drm_mode_create_dumb *args)
-{
-       struct drm_gem_object *gem_object;
-       u64 pitch, size;
-
-       pitch = args->width * DIV_ROUND_UP(args->bpp, 8);
-       size = args->height * pitch;
-       if (size == 0)
-               return -EINVAL;
-
-       gem_object = vgem_gem_create(dev, file, &args->handle, size);
-       if (IS_ERR(gem_object))
-               return PTR_ERR(gem_object);
-
-       args->size = gem_object->size;
+       args->size = size;
        args->pitch = pitch;
+       args->handle = handle;


At the end of the day, it makes no difference,
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
-Chris
