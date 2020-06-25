Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F52F20A3D0
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 19:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404206AbgFYRQm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jun 2020 13:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404187AbgFYRQm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jun 2020 13:16:42 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 209FCC08C5C1;
        Thu, 25 Jun 2020 10:16:42 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id h15so6647142wrq.8;
        Thu, 25 Jun 2020 10:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yVQ9UuGl9K3XAoQkcU4sk60ru7Jl6/1Dd6NAYAebMXg=;
        b=lIRxH08oBEtuy5h9XR66KqcOrsxZ0XlddiBu/lKKdWleODwNSaQM/WbnVXHsuvLvUh
         agkgoxKGXBnSKFm5gB7hSS8yJLE7HDathIX15iveNqp21BTU9vcigalAcCXU8EY3JWUf
         XXnTC11ape0jhLCHnTImNZr21PRnH2MsmwirJjJLe9LGrwMFt+DcYCgAIvfqU8A8taOh
         ybrXosKbJnHy75RxSPj8T0YjjU67Se6ZfNLppxcybAorylHPm0I4ykbEs/80gTIaLRNa
         qcv8Y7zSXGPg0IH2JfejT6U0tKcKzi1YPU3skGHjhTbj09Mc7YDgIz8mnexPVKRvWwyP
         5enQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yVQ9UuGl9K3XAoQkcU4sk60ru7Jl6/1Dd6NAYAebMXg=;
        b=bMLP+m4wTk8X1vr5C+3hN9wCaoTD2l/q5KP1IgBvNUXNs+GhVJQyOgjWB2fG8OBGeo
         3xN7PqlclYlnjCjKbMKWgL59Q1QvsAiakZhnIXrbj18WnGGshdlsdGIbn+AJ5wGd+m6x
         g+f+p/57z3pPTZYEPl+/LOM6XcJyRCP1ZMO+/RJ13nN3Z2+GmojqhP1RjunRo23VSEl8
         lFXsc7htpHsnuCRpAAG+dsnAIfgDHHiJogPqsDOqGb1EXg69yvLSiTh6c+AiepaM5zLc
         ywQVrUkDQE2ldPORSdYYlADWp5dsUvXtKT1nbCvnHhzxj1FzkH5Y9EyBswCCXCRYl7BA
         aXYA==
X-Gm-Message-State: AOAM530Pi5XC/VUTvThYXZ5IzkbHgPEQParVdO5p0g7jUcsSkfiEye06
        5ZCc22j1Lh+e/YzOF72WBar31b657aCznneec2c=
X-Google-Smtp-Source: ABdhPJxZfMZ1K1HQA1XbNumMSVKKi36ZAB/pjLuv0BsyN6lesNEXqVUKOGIt8dkTenZnxe/2Sy9ztW2+SpjOTTCGJSU=
X-Received: by 2002:adf:ef89:: with SMTP id d9mr24684664wro.124.1593105400767;
 Thu, 25 Jun 2020 10:16:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200625165042.13708-1-mironov.ivan@gmail.com>
In-Reply-To: <20200625165042.13708-1-mironov.ivan@gmail.com>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Thu, 25 Jun 2020 13:16:29 -0400
Message-ID: <CADnq5_NgvGEW+4t5gzLdaOJo0HC10M5iEaE+j7O6yKB9H6H-5w@mail.gmail.com>
Subject: Re: [PATCH v1] drm/amd/powerplay: Fix NULL dereference in lock_bus()
 on Vega20 w/o RAS
To:     Ivan Mironov <mironov.ivan@gmail.com>
Cc:     amd-gfx list <amd-gfx@lists.freedesktop.org>,
        Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
        Bjorn Nostvold <bjorn.nostvold@gmail.com>,
        David Airlie <airlied@linux.ie>,
        LKML <linux-kernel@vger.kernel.org>,
        Maling list - DRI developers 
        <dri-devel@lists.freedesktop.org>,
        "for 3.8" <stable@vger.kernel.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        Alex Deucher <alexander.deucher@amd.com>,
        Evan Quan <evan.quan@amd.com>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Applied.  Thanks!

Alex

On Thu, Jun 25, 2020 at 1:14 PM Ivan Mironov <mironov.ivan@gmail.com> wrote:
>
> I updated my system with Radeon VII from kernel 5.6 to kernel 5.7, and
> following started to happen on each boot:
>
>         ...
>         BUG: kernel NULL pointer dereference, address: 0000000000000128
>         ...
>         CPU: 9 PID: 1940 Comm: modprobe Tainted: G            E     5.7.2-200.im0.fc32.x86_64 #1
>         Hardware name: System manufacturer System Product Name/PRIME X570-P, BIOS 1407 04/02/2020
>         RIP: 0010:lock_bus+0x42/0x60 [amdgpu]
>         ...
>         Call Trace:
>          i2c_smbus_xfer+0x3d/0xf0
>          i2c_default_probe+0xf3/0x130
>          i2c_detect.isra.0+0xfe/0x2b0
>          ? kfree+0xa3/0x200
>          ? kobject_uevent_env+0x11f/0x6a0
>          ? i2c_detect.isra.0+0x2b0/0x2b0
>          __process_new_driver+0x1b/0x20
>          bus_for_each_dev+0x64/0x90
>          ? 0xffffffffc0f34000
>          i2c_register_driver+0x73/0xc0
>          do_one_initcall+0x46/0x200
>          ? _cond_resched+0x16/0x40
>          ? kmem_cache_alloc_trace+0x167/0x220
>          ? do_init_module+0x23/0x260
>          do_init_module+0x5c/0x260
>          __do_sys_init_module+0x14f/0x170
>          do_syscall_64+0x5b/0xf0
>          entry_SYSCALL_64_after_hwframe+0x44/0xa9
>         ...
>
> Error appears when some i2c device driver tries to probe for devices
> using adapter registered by `smu_v11_0_i2c_eeprom_control_init()`.
> Code supporting this adapter requires `adev->psp.ras.ras` to be not
> NULL, which is true only when `amdgpu_ras_init()` detects HW support by
> calling `amdgpu_ras_check_supported()`.
>
> Before 9015d60c9ee1, adapter was registered by
>
>         -> amdgpu_device_ip_init()
>           -> amdgpu_ras_recovery_init()
>             -> amdgpu_ras_eeprom_init()
>               -> smu_v11_0_i2c_eeprom_control_init()
>
> after verifying that `adev->psp.ras.ras` is not NULL in
> `amdgpu_ras_recovery_init()`. Currently it is registered
> unconditionally by
>
>         -> amdgpu_device_ip_init()
>           -> pp_sw_init()
>             -> hwmgr_sw_init()
>               -> vega20_smu_init()
>                 -> smu_v11_0_i2c_eeprom_control_init()
>
> Fix simply adds HW support check (ras == NULL => no support) before
> calling `smu_v11_0_i2c_eeprom_control_{init,fini}()`.
>
> Please note that there is a chance that similar fix is also required for
> CHIP_ARCTURUS. I do not know whether any actual Arcturus hardware without
> RAS exist, and whether calling `smu_i2c_eeprom_init()` makes any sense
> when there is no HW support.
>
> Cc: stable@vger.kernel.org
> Fixes: 9015d60c9ee1 ("drm/amdgpu: Move EEPROM I2C adapter to amdgpu_device")
> Signed-off-by: Ivan Mironov <mironov.ivan@gmail.com>
> Tested-by: Bjorn Nostvold <bjorn.nostvold@gmail.com>
> ---
> Changelog:
>
> v1:
>   - Added "Tested-by" for another user who used this patch to fix the
>     same issue.
>
> v0:
>   - Patch introduced.
> ---
>  drivers/gpu/drm/amd/powerplay/smumgr/vega20_smumgr.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/gpu/drm/amd/powerplay/smumgr/vega20_smumgr.c b/drivers/gpu/drm/amd/powerplay/smumgr/vega20_smumgr.c
> index 2fb97554134f..c2e0fbbccf56 100644
> --- a/drivers/gpu/drm/amd/powerplay/smumgr/vega20_smumgr.c
> +++ b/drivers/gpu/drm/amd/powerplay/smumgr/vega20_smumgr.c
> @@ -522,9 +522,11 @@ static int vega20_smu_init(struct pp_hwmgr *hwmgr)
>         priv->smu_tables.entry[TABLE_ACTIVITY_MONITOR_COEFF].version = 0x01;
>         priv->smu_tables.entry[TABLE_ACTIVITY_MONITOR_COEFF].size = sizeof(DpmActivityMonitorCoeffInt_t);
>
> -       ret = smu_v11_0_i2c_eeprom_control_init(&adev->pm.smu_i2c);
> -       if (ret)
> -               goto err4;
> +       if (adev->psp.ras.ras) {
> +               ret = smu_v11_0_i2c_eeprom_control_init(&adev->pm.smu_i2c);
> +               if (ret)
> +                       goto err4;
> +       }
>
>         return 0;
>
> @@ -560,7 +562,8 @@ static int vega20_smu_fini(struct pp_hwmgr *hwmgr)
>                         (struct vega20_smumgr *)(hwmgr->smu_backend);
>         struct amdgpu_device *adev = hwmgr->adev;
>
> -       smu_v11_0_i2c_eeprom_control_fini(&adev->pm.smu_i2c);
> +       if (adev->psp.ras.ras)
> +               smu_v11_0_i2c_eeprom_control_fini(&adev->pm.smu_i2c);
>
>         if (priv) {
>                 amdgpu_bo_free_kernel(&priv->smu_tables.entry[TABLE_PPTABLE].handle,
> --
> 2.26.2
>
> _______________________________________________
> amd-gfx mailing list
> amd-gfx@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/amd-gfx
