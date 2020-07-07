Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 492D92174B3
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 19:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbgGGRFe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 13:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbgGGRFe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jul 2020 13:05:34 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A9F1C061755
        for <stable@vger.kernel.org>; Tue,  7 Jul 2020 10:05:34 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id d21so25167672lfb.6
        for <stable@vger.kernel.org>; Tue, 07 Jul 2020 10:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dg7bGo9exn3RYa6jD0o+FN6Oys3EwD4T1EHma4Zs9M4=;
        b=CA3w4lqM831nU6Fzp2Sp9wz1UHOEDxWMrLyMeH9KClYfK2jsobMJUUUT6jliBBEVm6
         W2mgus5b5gw4bhik9NaOAYqyToSqeXBXnN8sO89YKgkwY7m9bu6ytbVMrSUQ/QZocE5X
         Wrd0OO6hAF56GiH2UGIVZqo9qvIjg6Kubd30qCezNlHy8BEHvTvafrebGBUuxrCwy3Jq
         CI2ELDAg18IcLLGBvXVXecxj0O+9v3RbNi+RgThX7s5CND3tIhaHj0Lra8bhwTBLqNfF
         Dd3XQF008luwZU6EywrqCPRH8/hH/1tjDQX9/LTvQojzQoBQwy4iyy2MYEi1sri+LoW3
         ofLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dg7bGo9exn3RYa6jD0o+FN6Oys3EwD4T1EHma4Zs9M4=;
        b=eCBEuvGEMdJ7fUcBd1lJSWhRcb2CA7mb8RfkkLrzi9F95CVxgP5heYxX15YYbX4W/5
         BHAIIvc57TLXGm4shOLndrWD1TZbD2idnQU479dT/BWojDtv8kcdOc3gYp/hRhw2jUYe
         ij2iHqGW2tUzjNssPcOGl4Xcf2Io2KUDCbX/Wu2JHcDeoAE6OxxQpOA+509/Dbp8c6f/
         soLqfW7WJehMfTych360Td/sjaJNFeH4qqHGwGjG8UP1W3viV0sl3FJrzAeOE5lDzSs4
         SIS0Zmqhm3g6/gh5JVTnfqckWK0ZiPhMso+sn0F0Ies/S1susHsHrUI7Wb4C3Ci1W4db
         4EVA==
X-Gm-Message-State: AOAM531wkeMEyyEquyCRIAitiyKUkAek8spamJAiY2j5IdrwRQqs9xDu
        OVticnRdFvTUydvZUGOiDEH6AIlhGS5ypD0WOn60tDLzQAs=
X-Google-Smtp-Source: ABdhPJycrY9gubirKkY4a+yFHjVXn7ad0XefK+qdb3Zk19QPFEOIT65O2gg5S5VqjUvxslPLefH56wTkA2zmEiFSZbQ=
X-Received: by 2002:a05:6512:4c6:: with SMTP id w6mr31263276lfq.76.1594141532322;
 Tue, 07 Jul 2020 10:05:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200707160012.1299338-1-chris@chris-wilson.co.uk>
In-Reply-To: <20200707160012.1299338-1-chris@chris-wilson.co.uk>
From:   lepton <ytht.net@gmail.com>
Date:   Tue, 7 Jul 2020 10:05:21 -0700
Message-ID: <CALqoU4y61Yc5ndaLSO3WoGSPxGm1nJJufk3U=uxhZe3sT1Xyzg@mail.gmail.com>
Subject: Re: [PATCH 1/2] drm/vgem: Do not allocate backing shmemfs file for an
 import dmabuf object
To:     chris@chris-wilson.co.uk
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
What do you mean by "regular mmap access" here?  It looks like vgem is
using vgem_gem_dumb_map as .dumb_map_offset callback then it doesn't call
drm_gem_dumb_map_offset
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
