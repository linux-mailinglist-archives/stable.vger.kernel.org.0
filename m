Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55DC014FDD4
	for <lists+stable@lfdr.de>; Sun,  2 Feb 2020 16:39:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbgBBPjY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Feb 2020 10:39:24 -0500
Received: from asavdk3.altibox.net ([109.247.116.14]:46640 "EHLO
        asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726880AbgBBPjY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Feb 2020 10:39:24 -0500
Received: from ravnborg.org (unknown [158.248.194.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by asavdk3.altibox.net (Postfix) with ESMTPS id BAA2520029;
        Sun,  2 Feb 2020 16:39:17 +0100 (CET)
Date:   Sun, 2 Feb 2020 16:39:16 +0100
From:   Sam Ravnborg <sam@ravnborg.org>
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        Rob Clark <robdclark@chromium.org>,
        Hillf Danton <hdanton@sina.com>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        stable@vger.kernel.org, Sean Paul <seanpaul@chromium.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Emil Velikov <emil.velikov@collabora.com>
Subject: Re: [PATCH] drm/vgem: Close use-after-free race in vgem_gem_create
Message-ID: <20200202153915.GA8034@ravnborg.org>
References: <20200202132133.1891846-1-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200202132133.1891846-1-daniel.vetter@ffwll.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.3 cv=eMA9ckh1 c=1 sm=1 tr=0
        a=UWs3HLbX/2nnQ3s7vZ42gw==:117 a=UWs3HLbX/2nnQ3s7vZ42gw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=yPCof4ZbAAAA:8
        a=QY18SFpNAAAA:8 a=hSkVLCK3AAAA:8 a=VwQbUJbxAAAA:8 a=QX4gbG5DAAAA:8
        a=cm27Pg_UAAAA:8 a=taGs_qngAAAA:8 a=-VAfIpHNAAAA:8 a=7gkXJVJtAAAA:8
        a=QyXUC8HyAAAA:8 a=e5mUnYsNAAAA:8 a=PZMVLxdsxIagqOrAZEMA:9
        a=CjuIK1q_8ugA:10 a=LYL6_n6_bXSRrjLcjcND:22 a=cQPPKAXgyycSBL8etih5:22
        a=AjGcO6oz07-iQ99wixmX:22 a=AbAUZ8qAyYyZVLSsDulk:22
        a=xmb-EsYY8bH0VWELuYED:22 a=DM_PlaNYpjARcMQr2apF:22
        a=srlwD-8ojaedGGhPAyx8:22 a=E9Po1WZjFZOl8hwRPBS3:22
        a=Vxmtnl_E_bksehYqCbjh:22
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Daniel.
On Sun, Feb 02, 2020 at 02:21:33PM +0100, Daniel Vetter wrote:
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
  ^^  Small typo

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
>  		return ERR_CAST(obj);
>  
>  	ret = drm_gem_handle_create(file, &obj->base, handle);
> -	drm_gem_object_put_unlocked(&obj->base);
> -	if (ret)
> +	if (ret) {
> +		drm_gem_object_put_unlocked(&obj->base);
>  		return ERR_PTR(ret);
> +	}
>  
>  	return &obj->base;
>  }
> @@ -221,7 +222,9 @@ static int vgem_gem_dumb_create(struct drm_file *file, struct drm_device *dev,
>  	args->size = gem_object->size;
>  	args->pitch = pitch;
>  
> -	DRM_DEBUG("Created object of size %lld\n", size);
> +	drm_gem_object_put_unlocked(gem_object);
> +
> +	DRM_DEBUG("Created object of size %llu\n", args->size);
>  
>  	return 0;
>  }
> -- 
> 2.24.1
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel
