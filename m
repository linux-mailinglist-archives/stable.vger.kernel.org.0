Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42148624AEE
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 20:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbiKJTub (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 14:50:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbiKJTua (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 14:50:30 -0500
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF37E47332
        for <stable@vger.kernel.org>; Thu, 10 Nov 2022 11:50:29 -0800 (PST)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-1322d768ba7so3313682fac.5
        for <stable@vger.kernel.org>; Thu, 10 Nov 2022 11:50:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TpoLdvRflktQN7U9c5G434i5k6igw7JRT2IHc7qtmk0=;
        b=HVOaDTPDqnSHbrNBcsUODsBGtNj71hTeMHrHQFCH+Eqesse4GHqCFlxhxkVql20AYu
         orKbhWs8i6RnencmUjz/l8WUeZoLh4OGgMvvJ7gTTb1gygCejS0UOeeWpduW/BLmTwjS
         Ydgq9YRzU9OKkb6pfH8DjbIb7jdu9wSiTrNXZXic+cTK1vDc+taVDrOxWDujOvWaFNIx
         UsIxZ1k8xr93I292Ve+nWRw1qnEpBdPLVdreMmcD+4bTqF2SHDRlN+meEeHEuVIJDZgF
         QpuBZbBohTYm3XU+sR0ufdhHdZCuqBI9qTE/pHdvMAUmVt2OyJccjkAYhFFZqSHd5VBy
         i6Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TpoLdvRflktQN7U9c5G434i5k6igw7JRT2IHc7qtmk0=;
        b=El1CprYV3Z08RBnZ56TnDZ3o8TuzJAjO+B+4/Sf3c5tHntdB56u0+nOyenSTubHmhu
         bg5Y7OJ5N4tiw9zbOkgHNnlkZSnNaCBmwpvGDEj8ZcMWAQU2NZPUX8ld4Vr9R6l27D6y
         3w+v4tapPXhzfzUjid7cqaxIkrB1D0f3WnpqaXXnarQ2meOBbvE07afIH8UdDGaPCk7u
         N4+e/DLLR3Z6qpdaflNCZ8xtTWD7bVukG1YwjIl3GgNkY3x2c7EVuMRPi6y4BSJgLRMu
         KcYSf+vzBgnHzYUbZIvfn/CzJtZlcQcEBTkFED4gc9++cC/exEISMR0+YEYY2wZkSn5U
         CnDg==
X-Gm-Message-State: ACrzQf14LuM5gcb+VlDEWGycJ8UN+JiKowmuM/8PAS9oyBAldbjeugPI
        yjh5F0RtV8YkXspwWo1OcRxHmesTuZxRRW4FqXueg0fZ
X-Google-Smtp-Source: AMsMyM7/aeEfqXDDH280FG+apQQxmO7pE6h5/e99SBudI8LyEhNy9oCNc1RQLwGN6ybflTxq/Xu+YELxcpmRasGoJFU=
X-Received: by 2002:a05:6871:4503:b0:12d:58c1:33f9 with SMTP id
 nj3-20020a056871450300b0012d58c133f9mr2085137oab.46.1668109829153; Thu, 10
 Nov 2022 11:50:29 -0800 (PST)
MIME-Version: 1.0
References: <20221110130009.1835-1-christian.koenig@amd.com>
In-Reply-To: <20221110130009.1835-1-christian.koenig@amd.com>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Thu, 10 Nov 2022 14:50:17 -0500
Message-ID: <CADnq5_M3pfo0W2fXRjFd6b5Enhgfd9V+zCOkNEpazmXP++Oi2w@mail.gmail.com>
Subject: Re: [PATCH 1/4] drm/amdgpu: always register an MMU notifier for userptr
To:     =?UTF-8?Q?Christian_K=C3=B6nig?= <ckoenig.leichtzumerken@gmail.com>
Cc:     felix.kuehling@amd.com, Philip.Yang@amd.com,
        amd-gfx@lists.freedesktop.org,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 10, 2022 at 8:00 AM Christian K=C3=B6nig
<ckoenig.leichtzumerken@gmail.com> wrote:
>
> Since switching to HMM we always need that because we no longer grab
> references to the pages.
>
> Signed-off-by: Christian K=C3=B6nig <christian.koenig@amd.com>
> CC: stable@vger.kernel.org

Series is:
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>

> ---
>  drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c b/drivers/gpu/drm/am=
d/amdgpu/amdgpu_gem.c
> index 8ef31d687ef3..111484ceb47d 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
> @@ -413,11 +413,9 @@ int amdgpu_gem_userptr_ioctl(struct drm_device *dev,=
 void *data,
>         if (r)
>                 goto release_object;
>
> -       if (args->flags & AMDGPU_GEM_USERPTR_REGISTER) {
> -               r =3D amdgpu_mn_register(bo, args->addr);
> -               if (r)
> -                       goto release_object;
> -       }
> +       r =3D amdgpu_mn_register(bo, args->addr);
> +       if (r)
> +               goto release_object;
>
>         if (args->flags & AMDGPU_GEM_USERPTR_VALIDATE) {
>                 r =3D amdgpu_ttm_tt_get_user_pages(bo, bo->tbo.ttm->pages=
);
> --
> 2.34.1
>
