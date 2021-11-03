Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA67B443DD4
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 08:51:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbhKCHyN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 03:54:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60771 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229504AbhKCHyM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Nov 2021 03:54:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635925896;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=irWXlZxDylOk4IvQ4TmBV6Sa70wcpbNEWa+s/Ek+9WE=;
        b=LCiNi+8Saa+8/zHAJ3OorfyDsDzEjyDJmb0h2wKY2bVXk2pIb/wgVKJMUlpqinwdRDlEqL
        QyFS9Vh1f4+SXHfe3+8/HjXTV0Xl8iuQiIV3IFHgTNSmU8Kr69UaA8j/Ws7INUqBNwhRiv
        Y8kX7fD3xydpoQ/Ltpk35R7BFjCf5Wk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-RIv99TpOOuawCM2cy661-w-1; Wed, 03 Nov 2021 03:51:35 -0400
X-MC-Unique: RIv99TpOOuawCM2cy661-w-1
Received: by mail-wm1-f72.google.com with SMTP id c1-20020a05600c0ac100b00322fcaa2bc7so710674wmr.4
        for <stable@vger.kernel.org>; Wed, 03 Nov 2021 00:51:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=irWXlZxDylOk4IvQ4TmBV6Sa70wcpbNEWa+s/Ek+9WE=;
        b=U4JHpxcIAE1JtObuUbkgyP+Q3o6IEIY5wS/KreSY22b2Dlv1+aqtZAL0TmGIqh27X3
         WUd1A4wjnThJm/E02De2JtHBzrydt8t2c7uyyY52d1GjjKMgwD3SJDFF3LHMIeXN/Lpj
         SY2XvE8lj5snKNMVeIfZSUjfHwmFCJ+yMTPN382wL+TK9NQY5APgspK/5/hpYKXNLb73
         /zWPZUSkdvVsdqNvB3RsH+v12yF51ORu1sTqFKlikCOJWX1wSW4GdNgZXzPvGz2r9oQE
         Nuo3zkMBn9zzMn2nLXXkdCORx/C/nbxavoWMRHOnSIiDmghr5KAeLZox8qKQllvQkZvX
         /sKg==
X-Gm-Message-State: AOAM531/1wsjVKtRJ/ZLgV/LbXhnE2OuiAKYllfm3G4l/PYsYZzJak3g
        cWO/CZhJ+hQT+57L4b9uDurLAWu0DiHl6xXPMZGR8J8nw2d3CXIMDbtdyVqtqtq5H11fo8WkDpi
        Pj4jSXwfLsNQ8QymNoTWc+C0+cUszQed2
X-Received: by 2002:a05:6000:144c:: with SMTP id v12mr53633349wrx.142.1635925894215;
        Wed, 03 Nov 2021 00:51:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzxUsEwlf2IYsDc3CXkiOwdsadyc5FEF0ZwMlAnAzju5XqXgEiKwXC/8wyvlIvOkO8Ya2PuD+3uWdV96nEjcBE=
X-Received: by 2002:a05:6000:144c:: with SMTP id v12mr53633334wrx.142.1635925894058;
 Wed, 03 Nov 2021 00:51:34 -0700 (PDT)
MIME-Version: 1.0
References: <20211103011057.15344-1-skeggsb@gmail.com>
In-Reply-To: <20211103011057.15344-1-skeggsb@gmail.com>
From:   Karol Herbst <kherbst@redhat.com>
Date:   Wed, 3 Nov 2021 08:51:23 +0100
Message-ID: <CACO55tvy5atSW9SJw1E_wmfgn1cZpDiZ2T7VuS35UGXRVdpEaw@mail.gmail.com>
Subject: Re: [Nouveau] [PATCH] ce/gf100: fix incorrect CE0 address calculation
 on some GPUs
To:     Ben Skeggs <skeggsb@gmail.com>
Cc:     nouveau <nouveau@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 3, 2021 at 2:11 AM Ben Skeggs <skeggsb@gmail.com> wrote:
>
> From: Ben Skeggs <bskeggs@redhat.com>
>
> The code which constructs the modules for each engine present on the GPU
> passes -1 for 'instance' on non-instanced engines, which affects how the
> name for a sub-device is generated.  This is then stored as 'instance 0'
> in nvkm_subdev.inst, so code can potentially be shared with earlier GPUs
> that only had a single instance of an engine.
>
> However, GF100's CE constructor uses this value to calculate the address
> of its falcon before it's translated, resulting in CE0 getting the wrong
> address.
>
> This slightly modifies the approach, always passing a valid instance for
> engines that *can* have multiple copies, and having the code for earlier
> GPUs explicitly ask for non-instanced name generation.
>
> Bug: https://gitlab.freedesktop.org/drm/nouveau/-/issues/91
>
> Fixes: 50551b15c760 ("drm/nouveau/ce: switch to instanced constructor")
> Cc: <stable@vger.kernel.org> # v5.12+
> Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
> ---
>  drivers/gpu/drm/nouveau/nvkm/engine/ce/gt215.c    | 2 +-
>  drivers/gpu/drm/nouveau/nvkm/engine/device/base.c | 3 +--
>  2 files changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/ce/gt215.c b/drivers/gpu/drm/nouveau/nvkm/engine/ce/gt215.c
> index 704df0f2d1f1..09a112af2f89 100644
> --- a/drivers/gpu/drm/nouveau/nvkm/engine/ce/gt215.c
> +++ b/drivers/gpu/drm/nouveau/nvkm/engine/ce/gt215.c
> @@ -78,6 +78,6 @@ int
>  gt215_ce_new(struct nvkm_device *device, enum nvkm_subdev_type type, int inst,
>              struct nvkm_engine **pengine)
>  {
> -       return nvkm_falcon_new_(&gt215_ce, device, type, inst,
> +       return nvkm_falcon_new_(&gt215_ce, device, type, -1,
>                                 (device->chipset != 0xaf), 0x104000, pengine);
>  }
> diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c b/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
> index ca75c5f6ecaf..b51d690f375f 100644
> --- a/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
> +++ b/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
> @@ -3147,8 +3147,7 @@ nvkm_device_ctor(const struct nvkm_device_func *func,
>         WARN_ON(device->chip->ptr.inst & ~((1 << ARRAY_SIZE(device->ptr)) - 1));             \
>         for (j = 0; device->chip->ptr.inst && j < ARRAY_SIZE(device->ptr); j++) {            \
>                 if ((device->chip->ptr.inst & BIT(j)) && (subdev_mask & BIT_ULL(type))) {    \
> -                       int inst = (device->chip->ptr.inst == 1) ? -1 : (j);                 \
> -                       ret = device->chip->ptr.ctor(device, (type), inst, &device->ptr[j]); \
> +                       ret = device->chip->ptr.ctor(device, (type), (j), &device->ptr[j]);  \
>                         subdev = nvkm_device_subdev(device, (type), (j));                    \
>                         if (ret) {                                                           \
>                                 nvkm_subdev_del(&subdev);                                    \
> --
> 2.31.1
>

Reviewed-by: Karol Herbst <kherbst@redhat.com>

