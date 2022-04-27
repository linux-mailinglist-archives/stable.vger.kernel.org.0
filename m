Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6780D511A9D
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 16:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238536AbiD0OvB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 10:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238648AbiD0OvA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 10:51:00 -0400
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 896C33C4AD;
        Wed, 27 Apr 2022 07:47:48 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-e2442907a1so2156895fac.8;
        Wed, 27 Apr 2022 07:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=47QrNpfa52VRAC22Iw7llWY6NibddnutqiXI8UWF5ZM=;
        b=BdJa1sqLVKb1yE4G6mdcb+IrXimsh9k5VFXCHYO+xamM3nHZHMPfWXsOGISyvqSyNo
         nj/hprdtte/D+dyo5UFYWHWD0JqP/tyYtAypuVFKL/355jiVI8mIAOZOnM+zEgOpPyjJ
         zVlYcc1Vkdo7mdLZU45vCRQ3kA7/qECRXtUtRMM2KyWBpqLpegiBA4FlZlUlLOF4OzTy
         5C7zE+/I6B+H0BWA4ES7h6gBKoldpZlVCdzNrvv7Ye8vpasDV3FApa6mu3BCPMvClwAb
         k9ozUssb2Rlv9vN2YbP6OZ+2AVnpwmmh15Vhq9VnkzqVtlV6i3R8EEh6tycLjcSEhi13
         nZjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=47QrNpfa52VRAC22Iw7llWY6NibddnutqiXI8UWF5ZM=;
        b=5LKs2YXc9kZtBNwNUnkI4fAS137p80G4/k6LmTr0hexbQSaG2obmWQDhwb1GS83qUj
         Z8mBZ+yiIS2IjqTosDIoJNbwFg8Gm+pjI/MG10JDDOphkwKHAMCcPRR5efyOt8tgV/7m
         Pz0WqSHyH0t1lYVpfJGDvVP2mzMa75FinA+TOeYnKxN03ypRUBmatrP/YV5nCb92by8l
         fUCsVyQKdAQnQ6crGN6ZJSPH7jPFr/cX098IB/xbO3F/3frnBg3WzhP7sozD3d6kQFMO
         xEykk96x4QQVmU1pxi+ToDASlPWi0soD0KreOfJ11YwX2qNn5I8tZNXVRJwaq2HShzLs
         YYoQ==
X-Gm-Message-State: AOAM531DRGUEtON+1RebNnqEWC9+/+aJJ0ZBJOihqil1CmUFhablIuAw
        iAuaxHQ287Q3AkpY2PpETcLRY17Ju/uvnNq9k/w=
X-Google-Smtp-Source: ABdhPJydWVQo9tj6Nu9xcJ7dQNUmdfr2cmUvOyyF9AuD6pmYXXsyxO9TpTngDTsG+9sTvqz8Na6H+DpwNnJxqzKT5+8=
X-Received: by 2002:a05:6870:311d:b0:de:9b6c:362b with SMTP id
 v29-20020a056870311d00b000de9b6c362bmr15164301oaa.200.1651070867943; Wed, 27
 Apr 2022 07:47:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220426235718.1634359-1-marmarek@invisiblethingslab.com>
In-Reply-To: <20220426235718.1634359-1-marmarek@invisiblethingslab.com>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Wed, 27 Apr 2022 10:47:36 -0400
Message-ID: <CADnq5_Pbaz9omsd6sHmOzTM=7c9fNBa5PAUfW4GOT=rtT4Anjg@mail.gmail.com>
Subject: Re: [PATCH] drm/amdgpu: do not use passthrough mode in Xen dom0
To:     =?UTF-8?Q?Marek_Marczykowski=2DG=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Lijo Lazar <lijo.lazar@amd.com>,
        "open list:DRM DRIVERS" <dri-devel@lists.freedesktop.org>,
        Guchun Chen <guchun.chen@amd.com>,
        David Airlie <airlied@linux.ie>,
        Bokun Zhang <bokun.zhang@amd.com>,
        Jingwen Chen <Jingwen.Chen2@amd.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        "for 3.8" <stable@vger.kernel.org>,
        Victor Skvortsov <victor.skvortsov@amd.com>,
        =?UTF-8?Q?Michel_D=C3=A4nzer?= <mdaenzer@redhat.com>,
        "open list:RADEON and AMDGPU DRM DRIVERS" 
        <amd-gfx@lists.freedesktop.org>, Bernard Zhao <bernard@vivo.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Candice Li <candice.li@amd.com>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>
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

Applied.  Thanks!

Alex

On Wed, Apr 27, 2022 at 3:12 AM Marek Marczykowski-G=C3=B3recki
<marmarek@invisiblethingslab.com> wrote:
>
> While technically Xen dom0 is a virtual machine too, it does have
> access to most of the hardware so it doesn't need to be considered a
> "passthrough". Commit b818a5d37454 ("drm/amdgpu/gmc: use PCI BARs for
> APUs in passthrough") changed how FB is accessed based on passthrough
> mode. This breaks amdgpu in Xen dom0 with message like this:
>
>     [drm:dc_dmub_srv_wait_idle [amdgpu]] *ERROR* Error waiting for DMUB i=
dle: status=3D3
>
> While the reason for this failure is unclear, the passthrough mode is
> not really necessary in Xen dom0 anyway. So, to unbreak booting affected
> kernels, disable passthrough mode in this case.
>
> Link: https://gitlab.freedesktop.org/drm/amd/-/issues/1985
> Fixes: b818a5d37454 ("drm/amdgpu/gmc: use PCI BARs for APUs in passthroug=
h")
> Signed-off-by: Marek Marczykowski-G=C3=B3recki <marmarek@invisiblethingsl=
ab.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c b/drivers/gpu/drm/a=
md/amdgpu/amdgpu_virt.c
> index a025f080aa6a..5e3756643da3 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
> @@ -24,6 +24,7 @@
>  #include <linux/module.h>
>
>  #include <drm/drm_drv.h>
> +#include <xen/xen.h>
>
>  #include "amdgpu.h"
>  #include "amdgpu_ras.h"
> @@ -710,7 +711,8 @@ void amdgpu_detect_virtualization(struct amdgpu_devic=
e *adev)
>                 adev->virt.caps |=3D AMDGPU_SRIOV_CAPS_ENABLE_IOV;
>
>         if (!reg) {
> -               if (is_virtual_machine())       /* passthrough mode exclu=
s sriov mod */
> +               /* passthrough mode exclus sriov mod */
> +               if (is_virtual_machine() && !xen_initial_domain())
>                         adev->virt.caps |=3D AMDGPU_PASSTHROUGH_MODE;
>         }
>
> --
> 2.35.1
>
