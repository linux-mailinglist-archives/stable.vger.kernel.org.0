Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F47F63D778
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 15:04:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbiK3OEC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 09:04:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiK3ODi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 09:03:38 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4924E421BD
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 06:03:27 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id s196so16146531pgs.3
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 06:03:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EEv8biCW1DAZ/y5wqGNt797D01bRASY/trErFq6uAMs=;
        b=UOZL9aovBLP3IRsFLyhdKW/pGGv4eOjZaSaB4Y8Ym4ei8ZwypxvOO/uQBS2EZNdZt2
         elUAGrkEtiieGjb0WBfHTFKVLzsC54NVHYRP+rNoBdnNbqT83EK4U73nPT3NwZJ1F5Bx
         NXrw/QoUKUHxH1psiJAry1SfhT2kCu7mcQKIo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EEv8biCW1DAZ/y5wqGNt797D01bRASY/trErFq6uAMs=;
        b=eQIEd9Z9AymEdm2c4B+XrAsahDCBez7hrNsbk/GdGy6GFNMQFQd/rsRj3Wur3BgGIV
         9z+7tleM6a8CzR/VDVSZny1ebLAKM1umpFxd8ewZxuJHTD4GHKRBs6kX6phxzevTJW3l
         LeyicUrP8xIfDTqEALlfhJnrPZfbH30yC9LBMxv9GlZmAfiUWcig2cQNWvuRlSnT9pIg
         ecXdArrQSsZ56NnCPAN7asehRJ04rjbaNJL3oReMzOLkNDjs8bFZ9Cudha7zoTF7ViP8
         yDtM4gu4Gnj+UWXwk5cqpI9qXSYmV75F2gcGeAupB5+ioZqRY8I490EY16QKanKT22EA
         VsGg==
X-Gm-Message-State: ANoB5pneFwDYQ9q0jCWHKX6bXMTJAJPLPvkaGAfF73kTB5MVnGvhBWsF
        irGCJbvSyF3Nvc1jI+XQ68knNU5T+j0IVlPmMi4sRQ==
X-Google-Smtp-Source: AA0mqf6KeHcENbmOiG7T2E55IFNkSKIPRSOlOP/bSDKNZdIZ7zLoslnx9jPJwCKyZsvAoB4iS0MvnmTEvpKENKWR1xo=
X-Received: by 2002:a63:ff5f:0:b0:46f:b6df:3107 with SMTP id
 s31-20020a63ff5f000000b0046fb6df3107mr36521260pgk.454.1669817003750; Wed, 30
 Nov 2022 06:03:23 -0800 (PST)
MIME-Version: 1.0
References: <20221129200242.298120-1-robdclark@gmail.com> <20221129200242.298120-3-robdclark@gmail.com>
In-Reply-To: <20221129200242.298120-3-robdclark@gmail.com>
From:   Daniel Vetter <daniel@ffwll.ch>
Date:   Wed, 30 Nov 2022 15:03:10 +0100
Message-ID: <CAKMK7uGi7fDC2=3-H5h0e4a0FUOOy_rLB22-DXRoJ2kQEkPeMQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] drm/shmem-helper: Avoid vm_open error paths
To:     Rob Clark <robdclark@gmail.com>
Cc:     dri-devel@lists.freedesktop.org, Daniel Vetter <daniel@ffwll.ch>,
        Rob Clark <robdclark@chromium.org>, stable@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@gmail.com>,
        Eric Anholt <eric@anholt.net>,
        =?UTF-8?Q?Noralf_Tr=C3=B8nnes?= <noralf@tronnes.org>,
        Rob Herring <robh@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 29, 2022 at 12:02:42PM -0800, Rob Clark wrote:
> From: Rob Clark <robdclark@chromium.org>
>
> vm_open() is not allowed to fail.  Fortunately we are guaranteed that
> the pages are already pinned, and only need to increment the refcnt.  So
> just increment it directly.

Please mention hare that the only issue is the mutex_lock_interruptible,
and the only way we've found to hit this is if you send a signal to the
original process in a fork() at _just_ the right time.

With that: Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>

>
> Fixes: 2194a63a818d ("drm: Add library for shmem backed GEM objects")
> Cc: stable@vger.kernel.org
> Signed-off-by: Rob Clark <robdclark@chromium.org>
> ---
>  drivers/gpu/drm/drm_gem_shmem_helper.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
> index 110a9eac2af8..9885ba64127f 100644
> --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
> +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
> @@ -571,12 +571,20 @@ static void drm_gem_shmem_vm_open(struct vm_area_struct *vma)
>  {
>       struct drm_gem_object *obj = vma->vm_private_data;
>       struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(obj);
> -     int ret;
>
>       WARN_ON(shmem->base.import_attach);
>
> -     ret = drm_gem_shmem_get_pages(shmem);
> -     WARN_ON_ONCE(ret != 0);
> +     mutex_lock(&shmem->pages_lock);
> +
> +     /*
> +      * We should have already pinned the pages, vm_open() just grabs
> +      * an additional reference for the new mm the vma is getting
> +      * copied into.
> +      */
> +     WARN_ON_ONCE(!shmem->pages_use_count);
> +
> +     shmem->pages_use_count++;
> +     mutex_unlock(&shmem->pages_lock);
>
>       drm_gem_vm_open(vma);
>  }
> --
> 2.38.1
>

--
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
