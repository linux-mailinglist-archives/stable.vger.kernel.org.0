Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61830154AC4
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 19:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbgBFSFz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 13:05:55 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52251 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727662AbgBFSFz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Feb 2020 13:05:55 -0500
Received: by mail-wm1-f68.google.com with SMTP id p9so1008085wmc.2
        for <stable@vger.kernel.org>; Thu, 06 Feb 2020 10:05:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HuJJoTh37iJ/kXhNuFH6NXAQ8gVsPiqQogD42MSKrAE=;
        b=Scr7hdX04CkCAT5MX7s20t9T+z8o9ndq2qk6jtBvxXowPtQKd4+RLbUGiTFHmeZ9PV
         xccds89NVMJxgDGofaEU5+9sbvu/c1+l3ScaIdWqDz52txmTxOhQeoroGqPDpcjeCOFi
         uJhW9sryKRCfdrtaBVmRcJXSX9hZTkhzC/wiA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HuJJoTh37iJ/kXhNuFH6NXAQ8gVsPiqQogD42MSKrAE=;
        b=U9pCFJSOv4XKoDLEu5rREmMa8fcUTdeQLK6afShzt/ewaPdkoQBmjRGFoXOOvMxLlq
         51Pgq3YjtDbxvWMNomLo/9jdaOrCw+lTvNsiVLG8dynBa40KzQry9t5ytyIXhclG5H+1
         eMxzWHwC6mWoONmQZsD9HT2zkYPyTizQQ2bnOiiAcrxKG8gW3vXIoQOQXVdMKzaHgR/X
         uvTU6K06R5T9lchFP/x0Da3AcypH0JrENEmkLJ9lgbM+VModUCC3BT0/lz9VcAI1OebI
         usmpIuyPfUwq728flMd7W+hux7KHd3UBb/H6h/A3swaaeKcW6s+7/wCDLzx6BcVNwQ2a
         5WqQ==
X-Gm-Message-State: APjAAAWFYsnaRqRo7O3wLZFYznVtttpVnLiiZgZq4UUYh649bKOVRLp+
        u4mVH33zCYyDp5dNex566yTZYw==
X-Google-Smtp-Source: APXvYqyLV8Hne5DNPS5Wy9lMelW7rz4HZBm9zybm7SztMHQnJq+uFZ0o+jftUefkbEG0J7Lea49G+g==
X-Received: by 2002:a1c:6755:: with SMTP id b82mr5612468wmc.127.1581012352540;
        Thu, 06 Feb 2020 10:05:52 -0800 (PST)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id x11sm290224wmg.46.2020.02.06.10.05.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 10:05:51 -0800 (PST)
Date:   Thu, 6 Feb 2020 19:05:49 +0100
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Hillf Danton <hdanton@sina.com>, stable@vger.kernel.org,
        Emil Velikov <emil.velikov@collabora.com>,
        Sean Paul <seanpaul@chromium.org>,
        Eric Anholt <eric@anholt.net>, Sam Ravnborg <sam@ravnborg.org>,
        Rob Clark <robdclark@chromium.org>,
        Daniel Vetter <daniel.vetter@intel.com>
Subject: Re: [PATCH] drm/vgem: Close use-after-free race in vgem_gem_create
Message-ID: <20200206180549.GX43062@phenom.ffwll.local>
References: <20200202132133.1891846-1-daniel.vetter@ffwll.ch>
 <158066505178.17828.178213696291677257@skylake-alporthouse-com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158066505178.17828.178213696291677257@skylake-alporthouse-com>
X-Operating-System: Linux phenom 5.3.0-3-amd64 
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 02, 2020 at 05:37:31PM +0000, Chris Wilson wrote:
> Quoting Daniel Vetter (2020-02-02 13:21:33)
> > There's two references floating around here (for the object reference,
> > not the handle_count reference, that's a different thing):
> > 
> > - The temporary reference held by vgem_gem_create, acquired by
> >   creating the object and released by calling
> >   drm_gem_object_put_unlocked.
> > 
> > - The reference held by the object handle, created by
> >   drm_gem_handle_create. This one generally outlives the function,
> >   except if a 2nd thread races with a GEM_CLOSE ioctl call.
> > 
> > So usually everything is correct, except in that race case, where the
> > access to gem_object->size could be looking at freed data already.
> > Which again isn't a real problem (userspace shot its feet off already
> > with the race, we could return garbage), but maybe someone can exploit
> > this as an information leak.
> > 
> > Cc: Dan Carpenter <dan.carpenter@oracle.com>
> > Cc: Hillf Danton <hdanton@sina.com>
> > Cc: Reported-by: syzbot+0dc4444774d419e916c8@syzkaller.appspotmail.com
> > Cc: stable@vger.kernel.org
> > Cc: Emil Velikov <emil.velikov@collabora.com>
> > Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> > Cc: Sean Paul <seanpaul@chromium.org>
> > Cc: Chris Wilson <chris@chris-wilson.co.uk>
> > Cc: Eric Anholt <eric@anholt.net>
> > Cc: Sam Ravnborg <sam@ravnborg.org>
> > Cc: Rob Clark <robdclark@chromium.org>
> > Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> > ---
> >  drivers/gpu/drm/vgem/vgem_drv.c | 9 ++++++---
> >  1 file changed, 6 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/gpu/drm/vgem/vgem_drv.c b/drivers/gpu/drm/vgem/vgem_drv.c
> > index 5bd60ded3d81..909eba43664a 100644
> > --- a/drivers/gpu/drm/vgem/vgem_drv.c
> > +++ b/drivers/gpu/drm/vgem/vgem_drv.c
> > @@ -196,9 +196,10 @@ static struct drm_gem_object *vgem_gem_create(struct drm_device *dev,
> >                 return ERR_CAST(obj);
> >  
> >         ret = drm_gem_handle_create(file, &obj->base, handle);
> > -       drm_gem_object_put_unlocked(&obj->base);
> > -       if (ret)
> > +       if (ret) {
> > +               drm_gem_object_put_unlocked(&obj->base);
> >                 return ERR_PTR(ret);
> > +       }
> >  
> >         return &obj->base;
> >  }
> > @@ -221,7 +222,9 @@ static int vgem_gem_dumb_create(struct drm_file *file, struct drm_device *dev,
> >         args->size = gem_object->size;
> >         args->pitch = pitch;
> >  
> > -       DRM_DEBUG("Created object of size %lld\n", size);
> > +       drm_gem_object_put_unlocked(gem_object);
> > +
> > +       DRM_DEBUG("Created object of size %llu\n", args->size);
> 
> I was thinking we either should return size from vgem_gem_create (the
> strategy we took in i915) or simply remove the vgem_gem_create() as that
> doesn't improve readability.
> 
> -static struct drm_gem_object *vgem_gem_create(struct drm_device *dev,
> -                                             struct drm_file *file,
> -                                             unsigned int *handle,
> -                                             unsigned long size)
> +static int vgem_gem_dumb_create(struct drm_file *file, struct drm_device *dev,
> +                               struct drm_mode_create_dumb *args)
>  {
>         struct drm_vgem_gem_object *obj;
> -       int ret;
> +       u64 pitch, size;
> +       u32 handle;
> +
> +       pitch = args->width * DIV_ROUND_UP(args->bpp, 8);
> +       size = mul_u32_u32(args->height, pitch);
> +       if (size == 0 || pitch < args->width)
> +               return -EINVAL;
> 
>         obj = __vgem_gem_create(dev, size);
>         if (IS_ERR(obj))
> -               return ERR_CAST(obj);
> +               return PTR_ERR(obj);
> +
> +       size = obj->base.size;
> 
> -       ret = drm_gem_handle_create(file, &obj->base, handle);
> +       ret = drm_gem_handle_create(file, &obj->base, &handle);
>         drm_gem_object_put_unlocked(&obj->base);
>         if (ret)
>                 return ERR_PTR(ret);
> 
> -       return &obj->base;
> -}
> -
> -static int vgem_gem_dumb_create(struct drm_file *file, struct drm_device *dev,
> -                               struct drm_mode_create_dumb *args)
> -{
> -       struct drm_gem_object *gem_object;
> -       u64 pitch, size;
> -
> -       pitch = args->width * DIV_ROUND_UP(args->bpp, 8);
> -       size = args->height * pitch;
> -       if (size == 0)
> -               return -EINVAL;
> -
> -       gem_object = vgem_gem_create(dev, file, &args->handle, size);
> -       if (IS_ERR(gem_object))
> -               return PTR_ERR(gem_object);
> -
> -       args->size = gem_object->size;
> +       args->size = size;
>         args->pitch = pitch;
> +       args->handle = handle;
> 
> 
> At the end of the day, it makes no difference,

Yeah there's room for more polish, but didn't want to do that in the cc:
stable patch.

> Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>

Thanks for your review, finally applied to drm-misc-next-fixes now that CI
has blessed me with its attention for a bit!
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
