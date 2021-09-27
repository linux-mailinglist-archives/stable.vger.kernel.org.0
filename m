Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB1F1419EFC
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 21:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236352AbhI0TTJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 15:19:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235964AbhI0TTI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Sep 2021 15:19:08 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B86FCC061575
        for <stable@vger.kernel.org>; Mon, 27 Sep 2021 12:17:30 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id n64so7651124oih.2
        for <stable@vger.kernel.org>; Mon, 27 Sep 2021 12:17:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=h+G678zxTRNy+ObotE/FKbBlfNAHM072vsCplvAPsEQ=;
        b=UIjLNr3EL8hr7Po9/wuhxK0n4v+MySBr55Of6fye6DPmi5EZhTkmawfs/ciuznqD+p
         sqya0bpZBR1lxQBHel3BJSXpJ3v6g4YtPKEn/lrtwj+vsFhkFgcCtTlFI6bIoN6P9IXL
         mlSY4c73VTS+Jgrurk5YO0vbFvkysMdrerVHpBjqEmhTwgEA7m/c1WXeClr5XeC0aMdw
         WeN8bNgZ6LMjU/kU7NkBNqD7TKjjZheMoqXer/6SYCrWFCxZd9TlqrOfZslrugPYgjMo
         txSenfDrEj3fvvNqWY5s8HgfUDCDUE6m6TbquiBpZ3Zp39sZw6NAQzOI8OPrPA3jCQdq
         aQzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=h+G678zxTRNy+ObotE/FKbBlfNAHM072vsCplvAPsEQ=;
        b=GaU7y7XTIL5HBh6FooWK0CTV+nkxKIqjEqVpe127tN4tSao5cEt0/B1UmOSh4lvA8B
         N3FxtYbQPYBbQNJDucKb6vT39U7yebiL6LGPxBeUjAo7aTbLuwKqYi6Le3s+fag9TzbU
         arCr7ckNbYFBCHH33jpQW1V03WOBKUr5bs2BV2McoBH6GX/Wj6q0XjMalKO+6jwZXIB8
         AH7ZwqBw1PIiyNJ5CDsvdISEYHV4aKBlnmM6tvwtkEHJPLCcKRcevBxdG32s7jrtili7
         +54/VMlEACg5Ei8eoRg8sgBHtDaeKcovdCykqoSiIPRje6JGrsHco5Fa7S4uf9Pg6Oiu
         Dw1A==
X-Gm-Message-State: AOAM530qhREKmYTlWQsBgobFp4KXuUrQVWS1fOnUE/SqYgfzEgwJcw9p
        QE2E6LHFoHA/luW6TQeQG62gZaXj3E5hKnjpxQc=
X-Google-Smtp-Source: ABdhPJzo0+qvBUpeSqQwZQadzMHzvW+MA+7T1FSaw9yy6sRIGTge8vuiHqKw63qiqTKhME6H7Djgjgws76L1YVnJBdg=
X-Received: by 2002:aca:ab4d:: with SMTP id u74mr561061oie.120.1632770249962;
 Mon, 27 Sep 2021 12:17:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210927150821.389427-1-contact@emersion.fr>
In-Reply-To: <20210927150821.389427-1-contact@emersion.fr>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Mon, 27 Sep 2021 15:17:19 -0400
Message-ID: <CADnq5_MBVmec4MP5YizegcdQZe2XKBwsVdqSCWizo73n4x1Z=w@mail.gmail.com>
Subject: Re: [PATCH v2] amdgpu: check tiling flags when creating FB on GFX8-
To:     Simon Ser <contact@emersion.fr>
Cc:     amd-gfx list <amd-gfx@lists.freedesktop.org>,
        "for 3.8" <stable@vger.kernel.org>,
        =?UTF-8?Q?Michel_D=C3=A4nzer?= <mdaenzer@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Harry Wentland <hwentlan@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 27, 2021 at 11:09 AM Simon Ser <contact@emersion.fr> wrote:
>
> On GFX9+, format modifiers are always enabled and ensure the
> frame-buffers can be scanned out at ADDFB2 time.
>
> On GFX8-, format modifiers are not supported and no other check
> is performed. This means ADDFB2 IOCTLs will succeed even if the
> tiling isn't supported for scan-out, and will result in garbage
> displayed on screen [1].
>
> Fix this by adding a check for tiling flags for GFX8 and older.
> The check is taken from radeonsi in Mesa (see how is_displayable
> is populated in gfx6_compute_surface).
>
> Changes in v2: use drm_WARN_ONCE instead of drm_WARN (Michel)
>
> [1]: https://github.com/swaywm/wlroots/issues/3185
>
> Signed-off-by: Simon Ser <contact@emersion.fr>
> Cc: stable@vger.kernel.org
> Acked-by: Michel D=C3=A4nzer <mdaenzer@redhat.com>
> Cc: Alex Deucher <alexander.deucher@amd.com>
> Cc: Harry Wentland <hwentlan@amd.com>
> Cc: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
> Cc: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>

Applied.  Thanks.

Alex

> ---
>  drivers/gpu/drm/amd/amdgpu/amdgpu_display.c | 31 +++++++++++++++++++++
>  1 file changed, 31 insertions(+)
>
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c b/drivers/gpu/dr=
m/amd/amdgpu/amdgpu_display.c
> index 58bfc7f00d76..5faf3ef28080 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
> @@ -837,6 +837,28 @@ static int convert_tiling_flags_to_modifier(struct a=
mdgpu_framebuffer *afb)
>         return 0;
>  }
>
> +/* Mirrors the is_displayable check in radeonsi's gfx6_compute_surface *=
/
> +static int check_tiling_flags_gfx6(struct amdgpu_framebuffer *afb)
> +{
> +       u64 micro_tile_mode;
> +
> +       /* Zero swizzle mode means linear */
> +       if (AMDGPU_TILING_GET(afb->tiling_flags, SWIZZLE_MODE) =3D=3D 0)
> +               return 0;
> +
> +       micro_tile_mode =3D AMDGPU_TILING_GET(afb->tiling_flags, MICRO_TI=
LE_MODE);
> +       switch (micro_tile_mode) {
> +       case 0: /* DISPLAY */
> +       case 3: /* RENDER */
> +               return 0;
> +       default:
> +               drm_dbg_kms(afb->base.dev,
> +                           "Micro tile mode %llu not supported for scano=
ut\n",
> +                           micro_tile_mode);
> +               return -EINVAL;
> +       }
> +}
> +
>  static void get_block_dimensions(unsigned int block_log2, unsigned int c=
pp,
>                                  unsigned int *width, unsigned int *heigh=
t)
>  {
> @@ -1103,6 +1125,7 @@ int amdgpu_display_framebuffer_init(struct drm_devi=
ce *dev,
>                                     const struct drm_mode_fb_cmd2 *mode_c=
md,
>                                     struct drm_gem_object *obj)
>  {
> +       struct amdgpu_device *adev =3D drm_to_adev(dev);
>         int ret, i;
>
>         /*
> @@ -1122,6 +1145,14 @@ int amdgpu_display_framebuffer_init(struct drm_dev=
ice *dev,
>         if (ret)
>                 return ret;
>
> +       if (!dev->mode_config.allow_fb_modifiers) {
> +               drm_WARN_ONCE(dev, adev->family >=3D AMDGPU_FAMILY_AI,
> +                             "GFX9+ requires FB check based on format mo=
difier\n");
> +               ret =3D check_tiling_flags_gfx6(rfb);
> +               if (ret)
> +                       return ret;
> +       }
> +
>         if (dev->mode_config.allow_fb_modifiers &&
>             !(rfb->base.flags & DRM_MODE_FB_MODIFIERS)) {
>                 ret =3D convert_tiling_flags_to_modifier(rfb);
> --
> 2.33.0
>
>
