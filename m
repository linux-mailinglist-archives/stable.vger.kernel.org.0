Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74F41217F32
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 07:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728433AbgGHFoh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 01:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbgGHFoh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jul 2020 01:44:37 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02795C061755
        for <stable@vger.kernel.org>; Tue,  7 Jul 2020 22:44:37 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id r19so1653416ljn.12
        for <stable@vger.kernel.org>; Tue, 07 Jul 2020 22:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Qq/LVwU/N4W4lzPSMDMiPTvy9LVBc34wJPoHGag6tLc=;
        b=kv9AnCfQWFMHtQLqLSODLvbf5K6d/kQg0ki/rNlHKapH83Ze+SUbwUzm3mJh5ZEMx9
         djP0a3vF6i9mXoKmQIXhaGFPmJfaF3tKDbVKc2A2KWwkgLW/ij/Yi8/VT914A8WDEBdf
         JF3sejEisujgxRFcy6M+EupWWOKeKX3vnTxeWEOiOxGWBn0igKNWnoD8mM/eTtpW5+SZ
         9PyzTOe5p4R3WIliKUuOYN1UYy0HCyVw5amRgNuEYZvLcG8svOCeRxC4nkwQAJNZc+mK
         IR2NtTXTeBVv6bFRdFOcU7okwgFgOA/WufeRcIBM4Tvv2mU4iJ3wuy7D1u3+l+//hSww
         puGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Qq/LVwU/N4W4lzPSMDMiPTvy9LVBc34wJPoHGag6tLc=;
        b=XG0CL4VsFX3pH6OGAIXRrEQcs5J+sp4tKXq/qcC+SJJ+2VSK7GApX75qUUl/39kbiD
         c+CPIpM2Cz2xEPwJk2YdDs/aXkPHSDLyHLLOA0ntQb25NmE0NAsfSl7SLqKA4VcPYyKS
         DZ0tPby+5eGBs53aLivXtRcgNNofjpvlNNLmxzr6kVRG1OcG4kzK2hQiEqXR1oPrca8V
         VI9gZENXTLwNfUWUDfNZFDM7HlA0VxO4eaxiip5Du9JxfZ7U8mr1rxTcl8pHAgGl//s8
         flarhMsNgl7z/ee2sq2AoX00cLb8taEyWEBWLfmZt1pUAyi8ZTuk+ejvd1DN29zBDDLW
         aRQQ==
X-Gm-Message-State: AOAM531yOHWDiSFTOX8EKpLMnFpUk3hhxqWWCiRHod04M7f3xptgktp3
        TkA3Fg+Nn9dJcmDVAa5pFGupO9VFwGpBHgL/N38Ov+1XBB4=
X-Google-Smtp-Source: ABdhPJyhpQr82E7ylH41uvaeqXfPiHzUfkHmR2AncBiUenm2TYVaLiC2J8ZOTNclh1yKo1ruN2pn+s7VenJy19cUemc=
X-Received: by 2002:a2e:9dc6:: with SMTP id x6mr24848001ljj.94.1594187075357;
 Tue, 07 Jul 2020 22:44:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200707160012.1299338-1-chris@chris-wilson.co.uk>
In-Reply-To: <20200707160012.1299338-1-chris@chris-wilson.co.uk>
From:   lepton <ytht.net@gmail.com>
Date:   Tue, 7 Jul 2020 22:44:24 -0700
Message-ID: <CALqoU4znLvWvweMndRt0A33=XwHZ0+1cyow553mSSAM7SkY6Lg@mail.gmail.com>
Subject: Re: [PATCH 1/2] drm/vgem: Do not allocate backing shmemfs file for an
 import dmabuf object
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        Daniel Vetter <daniel@ffwll.ch>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas_os@shipmail.org>,
        "# v4 . 10+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 7, 2020 at 9:00 AM Chris Wilson <chris@chris-wilson.co.uk> wrot=
e:
>
> If we assign obj->filp, we believe that the create vgem bo is native and
> allow direct operations like mmap() assuming it behaves as backed by a
> shmemfs inode. When imported from a dmabuf, the obj->pages are
> not always meaningful and the shmemfs backing store misleading.
>
> Note, that regular mmap access to a vgem bo is via the dumb buffer API,
> and that rejects attempts to mmap an imported dmabuf,
>
> drm_gem_dumb_map_offset():
>         if (obj->import_attach) return -EINVAL;
>
> So the only route by which we might accidentally allow mmapping of an
> imported buffer is via vgem_prime_mmap(), which checked for
> obj->filp assuming that it would be NULL.
>
> Well it would had it been updated to use the common
> drm_gem_dum_map_offset() helper, instead it has
>
> vgem_gem_dumb_map():
>         if (!obj->filp) return -EINVAL;
>
> falling foul of the same trap as above.
>
> Reported-by: Lepton Wu <ytht.net@gmail.com>
> Fixes: af33a9190d02 ("drm/vgem: Enable dmabuf import interfaces")
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Lepton Wu <ytht.net@gmail.com>
> Cc: Daniel Vetter <daniel@ffwll.ch>
> Cc: Christian K=C3=B6nig <christian.koenig@amd.com>
> Cc: Thomas Hellstr=C3=B6m (Intel) <thomas_os@shipmail.org>
> Cc: <stable@vger.kernel.org> # v4.13+
> ---
>  drivers/gpu/drm/vgem/vgem_drv.c | 27 +++++++++++++++++----------
>  1 file changed, 17 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/gpu/drm/vgem/vgem_drv.c b/drivers/gpu/drm/vgem/vgem_=
drv.c
> index 909eba43664a..eb3b7cdac941 100644
> --- a/drivers/gpu/drm/vgem/vgem_drv.c
> +++ b/drivers/gpu/drm/vgem/vgem_drv.c
> @@ -91,7 +91,7 @@ static vm_fault_t vgem_gem_fault(struct vm_fault *vmf)
>                 ret =3D 0;
>         }
>         mutex_unlock(&obj->pages_lock);
> -       if (ret) {
> +       if (ret && obj->base.filp) {
>                 struct page *page;
>
>                 page =3D shmem_read_mapping_page(
> @@ -157,7 +157,8 @@ static void vgem_postclose(struct drm_device *dev, st=
ruct drm_file *file)
>  }
>
>  static struct drm_vgem_gem_object *__vgem_gem_create(struct drm_device *=
dev,
> -                                               unsigned long size)
> +                                                    struct file *shmem,
> +                                                    unsigned long size)
>  {
>         struct drm_vgem_gem_object *obj;
>         int ret;
Remove this, it's not used any more.
> @@ -166,11 +167,8 @@ static struct drm_vgem_gem_object *__vgem_gem_create=
(struct drm_device *dev,
>         if (!obj)
>                 return ERR_PTR(-ENOMEM);
>
> -       ret =3D drm_gem_object_init(dev, &obj->base, roundup(size, PAGE_S=
IZE));
> -       if (ret) {
> -               kfree(obj);
> -               return ERR_PTR(ret);
> -       }
> +       drm_gem_private_object_init(dev, &obj->base, size);
> +       obj->base.filp =3D shmem;
>
>         mutex_init(&obj->pages_lock);
>
> @@ -189,11 +187,20 @@ static struct drm_gem_object *vgem_gem_create(struc=
t drm_device *dev,
>                                               unsigned long size)
>  {
>         struct drm_vgem_gem_object *obj;
> +       struct file *shmem;
>         int ret;
>
> -       obj =3D __vgem_gem_create(dev, size);
> -       if (IS_ERR(obj))
> +       size =3D roundup(size, PAGE_SIZE);
> +
> +       shmem =3D shmem_file_setup(DRIVER_NAME, size, VM_NORESERVE);
> +       if (IS_ERR(shmem))
> +               return ERR_CAST(shmem);
> +
> +       obj =3D __vgem_gem_create(dev, shmem, size);
> +       if (IS_ERR(obj)) {
> +               fput(shmem);
>                 return ERR_CAST(obj);
> +       }
>
>         ret =3D drm_gem_handle_create(file, &obj->base, handle);
>         if (ret) {
> @@ -363,7 +370,7 @@ static struct drm_gem_object *vgem_prime_import_sg_ta=
ble(struct drm_device *dev,
>         struct drm_vgem_gem_object *obj;
>         int npages;
>
> -       obj =3D __vgem_gem_create(dev, attach->dmabuf->size);
> +       obj =3D __vgem_gem_create(dev, NULL, attach->dmabuf->size);
>         if (IS_ERR(obj))
>                 return ERR_CAST(obj);
>
> --
> 2.27.0
>
