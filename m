Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7366E5108
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 21:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbjDQTee (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 15:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbjDQTed (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 15:34:33 -0400
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB27F2107;
        Mon, 17 Apr 2023 12:34:30 -0700 (PDT)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-1878504c22aso18258266fac.8;
        Mon, 17 Apr 2023 12:34:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681760069; x=1684352069;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5q1UADTLtxpaMg26Rskq3kK3zFrTI6WC2dwC06gJvSg=;
        b=IHqpf2sk6GocJcMUsxs7EfH25jwhs8pny+rgCsFkFVvee5zh6VW+fji3F7acj7NOGM
         NpBLJkBPE0evdOqIk9nHBFmZ0D/QICtqPzJ7acbSKBVgL0Q4CpBsvp2txsIQF2jQfMd1
         R+Otpjdk8UUdxApKTKmST3WGlH9msFY2to5R/93AHeg+a5vnsnAEAgZfU+Isv2tZ9GmS
         NG04Tkw+pn/Kisy0rasEpqktx3KY7CEKxoun7E4eXM528b7uY2tftG+4nDJ1T0yCXZhr
         447bUjFW0u8MktcRXncryfD4L8+RdOntdBX3PiE6a3YBG/BrwIM39xxzgz0e831t7Z0X
         2nBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681760069; x=1684352069;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5q1UADTLtxpaMg26Rskq3kK3zFrTI6WC2dwC06gJvSg=;
        b=awD6lT/4ArN5WWl+hG+hSqn6y95zlBIfqCdi8ClhfGSFqP3ScahCltwjS8j/WNeeSL
         KdcpRz+yV2rCVKj0UTTSILPC55r8IBNG7ZIFfRjuQgNEAp+hmQoSZYIBOQcScpMjm2Py
         0owZTia3QknQC9nuyejrwJWnDHe08YtNyx3BjOTqaPhHhI+W++b9Mt4OHnAhHP4uRvqR
         N3QEK2Ni6GDGSFT00Q/q23iekpOaOx74hMdmfNAZIDzBy1zQjg4CnI+bLU+OecZTZjS3
         gmCgHdt5G9ImKFFSTm3YHUDz9nnYK2mQEULOj5RR+9HBNUjIrQidWPcGb87SwYAg40oJ
         8i0w==
X-Gm-Message-State: AAQBX9fA4cBDEmL5ztgf9sZ2qNo4Skh4nnYFE6WCDv7NEYxGRSEFEaqu
        S/yfb83U7l/Dz5GbRghP2LH9YVAjphdvxFcRVeA=
X-Google-Smtp-Source: AKy350Y6q2hi+cxptjOwoPFYriOiGtU+hYfqGDp+Z7d0toixkRxdfroHewDdXnL5ss2zptH/e+7WDkWHMI6tvpahUWU=
X-Received: by 2002:a05:6870:32ca:b0:188:438:d4b6 with SMTP id
 r10-20020a05687032ca00b001880438d4b6mr515953oac.3.1681760069194; Mon, 17 Apr
 2023 12:34:29 -0700 (PDT)
MIME-Version: 1.0
References: <20230413151228.19714-1-n.zhandarovich@fintech.ru>
In-Reply-To: <20230413151228.19714-1-n.zhandarovich@fintech.ru>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Mon, 17 Apr 2023 15:34:18 -0400
Message-ID: <CADnq5_MqJ7jnYrRus+HFy+Qk5F6b3627TN-gpxSbGgPdgfLkfw@mail.gmail.com>
Subject: Re: [PATCH v2] radeon: avoid double free in ci_dpm_init()
To:     Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        Natalia Petrova <n.petrova@fintech.ru>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>, linux-kernel@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        stable@vger.kernel.org,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        lvc-project@linuxtesting.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks.  Applied!

Alex

On Thu, Apr 13, 2023 at 11:12=E2=80=AFAM Nikita Zhandarovich
<n.zhandarovich@fintech.ru> wrote:
>
> Several calls to ci_dpm_fini() will attempt to free resources that
> either have been freed before or haven't been allocated yet. This
> may lead to undefined or dangerous behaviour.
>
> For instance, if r600_parse_extended_power_table() fails, it might
> call r600_free_extended_power_table() as will ci_dpm_fini() later
> during error handling.
>
> Fix this by only freeing pointers to objects previously allocated.
>
> Found by Linux Verification Center (linuxtesting.org) with static
> analysis tool SVACE.
>
> Fixes: cc8dbbb4f62a ("drm/radeon: add dpm support for CI dGPUs (v2)")
> Cc: stable@vger.kernel.org
> Co-developed-by: Natalia Petrova <n.petrova@fintech.ru>
> Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
> ---
> v2: free only resouces allocated prior, do not remove ci_dpm_fini()
> or other deallocating calls altogether; fix commit message.
> v1: https://lore.kernel.org/all/20230403182808.8699-1-n.zhandarovich@fint=
ech.ru/
>
>  drivers/gpu/drm/radeon/ci_dpm.c | 28 ++++++++++++++++++++--------
>  1 file changed, 20 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/gpu/drm/radeon/ci_dpm.c b/drivers/gpu/drm/radeon/ci_=
dpm.c
> index 8ef25ab305ae..b8f4dac68d85 100644
> --- a/drivers/gpu/drm/radeon/ci_dpm.c
> +++ b/drivers/gpu/drm/radeon/ci_dpm.c
> @@ -5517,6 +5517,7 @@ static int ci_parse_power_table(struct radeon_devic=
e *rdev)
>         u8 frev, crev;
>         u8 *power_state_offset;
>         struct ci_ps *ps;
> +       int ret;
>
>         if (!atom_parse_data_header(mode_info->atom_context, index, NULL,
>                                    &frev, &crev, &data_offset))
> @@ -5546,11 +5547,15 @@ static int ci_parse_power_table(struct radeon_dev=
ice *rdev)
>                 non_clock_array_index =3D power_state->v2.nonClockInfoInd=
ex;
>                 non_clock_info =3D (struct _ATOM_PPLIB_NONCLOCK_INFO *)
>                         &non_clock_info_array->nonClockInfo[non_clock_arr=
ay_index];
> -               if (!rdev->pm.power_state[i].clock_info)
> -                       return -EINVAL;
> +               if (!rdev->pm.power_state[i].clock_info) {
> +                       ret =3D -EINVAL;
> +                       goto err_free_ps;
> +               }
>                 ps =3D kzalloc(sizeof(struct ci_ps), GFP_KERNEL);
> -               if (ps =3D=3D NULL)
> -                       return -ENOMEM;
> +               if (ps =3D=3D NULL) {
> +                       ret =3D -ENOMEM;
> +                       goto err_free_ps;
> +               }
>                 rdev->pm.dpm.ps[i].ps_priv =3D ps;
>                 ci_parse_pplib_non_clock_info(rdev, &rdev->pm.dpm.ps[i],
>                                               non_clock_info,
> @@ -5590,6 +5595,12 @@ static int ci_parse_power_table(struct radeon_devi=
ce *rdev)
>         }
>
>         return 0;
> +
> +err_free_ps:
> +       for (i =3D 0; i < rdev->pm.dpm.num_ps; i++)
> +               kfree(rdev->pm.dpm.ps[i].ps_priv);
> +       kfree(rdev->pm.dpm.ps);
> +       return ret;
>  }
>
>  static int ci_get_vbios_boot_values(struct radeon_device *rdev,
> @@ -5678,25 +5689,26 @@ int ci_dpm_init(struct radeon_device *rdev)
>
>         ret =3D ci_get_vbios_boot_values(rdev, &pi->vbios_boot_state);
>         if (ret) {
> -               ci_dpm_fini(rdev);
> +               kfree(rdev->pm.dpm.priv);
>                 return ret;
>         }
>
>         ret =3D r600_get_platform_caps(rdev);
>         if (ret) {
> -               ci_dpm_fini(rdev);
> +               kfree(rdev->pm.dpm.priv);
>                 return ret;
>         }
>
>         ret =3D r600_parse_extended_power_table(rdev);
>         if (ret) {
> -               ci_dpm_fini(rdev);
> +               kfree(rdev->pm.dpm.priv);
>                 return ret;
>         }
>
>         ret =3D ci_parse_power_table(rdev);
>         if (ret) {
> -               ci_dpm_fini(rdev);
> +               kfree(rdev->pm.dpm.priv);
> +               r600_free_extended_power_table(rdev);
>                 return ret;
>         }
>
