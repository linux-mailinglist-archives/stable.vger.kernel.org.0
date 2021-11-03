Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A19B5444BAE
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 00:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbhKCXgQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 19:36:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48082 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229561AbhKCXgQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Nov 2021 19:36:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635982418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7De9Gqd8CUJxMa+TanGCv6guhL3v1dqZFI8MIBYGLDY=;
        b=IsvvSPCtbUlTk1764BjCJzn+Qgez6r0HpO/9RfWDo73iBN5uothGKsdnfwx8gMbwRdruy1
        1wdegNbWuSiH6S+kYeimZkVrZfGofUGXgz+hCXw4364r4tZls3/NNxvS50P5R+FOIgv5QG
        LTMD7i25ka+3pMwLAaYDD65PBPfxnW8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-242-Otw82a9hMBWCsZ4pxoiGYw-1; Wed, 03 Nov 2021 19:33:37 -0400
X-MC-Unique: Otw82a9hMBWCsZ4pxoiGYw-1
Received: by mail-wm1-f69.google.com with SMTP id k6-20020a7bc306000000b0030d92a6bdc7so1808988wmj.3
        for <stable@vger.kernel.org>; Wed, 03 Nov 2021 16:33:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7De9Gqd8CUJxMa+TanGCv6guhL3v1dqZFI8MIBYGLDY=;
        b=PIC+Qo7VwW2enfZhfNNQDwx9Pohm5JPBoJxyFp1QKGJe+wMMyCKzt2jTQsyBtIxjQo
         CUUNJxP3OpmcbfM6ElJZDN21aT6YYhuaTP1ddHu33rWotRq7wRW7ciVahkHV/OLcQC4j
         bl7/maazZvpFAPJ1Eed3Cw17lBmPTUrwSd3Tfl9f0LFgM1sh5eFpV2g0NveU46a+gg5G
         DLdSSziG2hzrQyW97vvdaiWFO8uziuWcU4tGbQ/411g91UWw6xDr0qRhe0NBjgiRMPOC
         EVNcG6JB/YeoMYZo27YiiiuTxJ9pnsH2TZ+UWoUb2XJE10IGcA/e3l8od6GsdtuZj0ol
         bkGw==
X-Gm-Message-State: AOAM533/qHLy+HUSlO9lVTVMC00n4KJmKVSJ6Bp8pAMzeARCV8m7Qq2M
        OVnr2srqYEc7wHwtD0Uaw1rX4PTIA7KZlFiFajhSe6MrF1evAQ7chY+w9tAr9UuUd3dt0A/eVuT
        tZ0Oi9WBAoYzaQlDaGvcuUd45zp96U+wq
X-Received: by 2002:adf:eb4b:: with SMTP id u11mr45872360wrn.49.1635982416131;
        Wed, 03 Nov 2021 16:33:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzqsfgbnO5nmV+YmqNe0Y1+aMbBesCQYIeQ4yjNTSV5UP0D0DskkCEJQoOGYhf4sRFoTFZSB/+e5dySrD+tg8U=
X-Received: by 2002:adf:eb4b:: with SMTP id u11mr45872342wrn.49.1635982415901;
 Wed, 03 Nov 2021 16:33:35 -0700 (PDT)
MIME-Version: 1.0
References: <20211103011057.15344-1-skeggsb@gmail.com> <CACO55tvy5atSW9SJw1E_wmfgn1cZpDiZ2T7VuS35UGXRVdpEaw@mail.gmail.com>
In-Reply-To: <CACO55tvy5atSW9SJw1E_wmfgn1cZpDiZ2T7VuS35UGXRVdpEaw@mail.gmail.com>
From:   Karol Herbst <kherbst@redhat.com>
Date:   Thu, 4 Nov 2021 00:33:25 +0100
Message-ID: <CACO55tvOAvFVhUhtttfBU9wB_2eOQL6rt8f2sKrndHgCLhHEkA@mail.gmail.com>
Subject: Re: [Nouveau] [PATCH] ce/gf100: fix incorrect CE0 address calculation
 on some GPUs
To:     Ben Skeggs <skeggsb@gmail.com>
Cc:     nouveau <nouveau@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 3, 2021 at 8:51 AM Karol Herbst <kherbst@redhat.com> wrote:
>
> On Wed, Nov 3, 2021 at 2:11 AM Ben Skeggs <skeggsb@gmail.com> wrote:
> >
> > From: Ben Skeggs <bskeggs@redhat.com>
> >
> > The code which constructs the modules for each engine present on the GPU
> > passes -1 for 'instance' on non-instanced engines, which affects how the
> > name for a sub-device is generated.  This is then stored as 'instance 0'
> > in nvkm_subdev.inst, so code can potentially be shared with earlier GPUs
> > that only had a single instance of an engine.
> >
> > However, GF100's CE constructor uses this value to calculate the address
> > of its falcon before it's translated, resulting in CE0 getting the wrong
> > address.
> >
> > This slightly modifies the approach, always passing a valid instance for
> > engines that *can* have multiple copies, and having the code for earlier
> > GPUs explicitly ask for non-instanced name generation.
> >
> > Bug: https://gitlab.freedesktop.org/drm/nouveau/-/issues/91
> >
> > Fixes: 50551b15c760 ("drm/nouveau/ce: switch to instanced constructor")
> > Cc: <stable@vger.kernel.org> # v5.12+
> > Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
> > ---
> >  drivers/gpu/drm/nouveau/nvkm/engine/ce/gt215.c    | 2 +-
> >  drivers/gpu/drm/nouveau/nvkm/engine/device/base.c | 3 +--
> >  2 files changed, 2 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/ce/gt215.c b/drivers/gpu/drm/nouveau/nvkm/engine/ce/gt215.c
> > index 704df0f2d1f1..09a112af2f89 100644
> > --- a/drivers/gpu/drm/nouveau/nvkm/engine/ce/gt215.c
> > +++ b/drivers/gpu/drm/nouveau/nvkm/engine/ce/gt215.c
> > @@ -78,6 +78,6 @@ int
> >  gt215_ce_new(struct nvkm_device *device, enum nvkm_subdev_type type, int inst,
> >              struct nvkm_engine **pengine)
> >  {
> > -       return nvkm_falcon_new_(&gt215_ce, device, type, inst,
> > +       return nvkm_falcon_new_(&gt215_ce, device, type, -1,
> >                                 (device->chipset != 0xaf), 0x104000, pengine);
> >  }
> > diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c b/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
> > index ca75c5f6ecaf..b51d690f375f 100644
> > --- a/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
> > +++ b/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
> > @@ -3147,8 +3147,7 @@ nvkm_device_ctor(const struct nvkm_device_func *func,
> >         WARN_ON(device->chip->ptr.inst & ~((1 << ARRAY_SIZE(device->ptr)) - 1));             \
> >         for (j = 0; device->chip->ptr.inst && j < ARRAY_SIZE(device->ptr); j++) {            \
> >                 if ((device->chip->ptr.inst & BIT(j)) && (subdev_mask & BIT_ULL(type))) {    \
> > -                       int inst = (device->chip->ptr.inst == 1) ? -1 : (j);                 \
> > -                       ret = device->chip->ptr.ctor(device, (type), inst, &device->ptr[j]); \
> > +                       ret = device->chip->ptr.ctor(device, (type), (j), &device->ptr[j]);  \
> >                         subdev = nvkm_device_subdev(device, (type), (j));                    \
> >                         if (ret) {                                                           \
> >                                 nvkm_subdev_del(&subdev);                                    \
> > --
> > 2.31.1
> >
>
> Reviewed-by: Karol Herbst <kherbst@redhat.com>

Tested that on a GF108, so

Tested-by: Karol Herbst <kherbst@redhat.com>

