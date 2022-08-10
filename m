Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 301D458EF6E
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 17:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233218AbiHJP2b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 11:28:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233167AbiHJP2b (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 11:28:31 -0400
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 679CD78225
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 08:28:30 -0700 (PDT)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-1168e046c85so8381373fac.13
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 08:28:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=JGlVYKOhE0vnUO2uJlfhRsy2OU4tbrDN/YlwAH68OlA=;
        b=d2fByg4d4eWVNrjXbt7g4Wnpbdp3QlMHivfhSOsmfJdN3rtz5lmLEO5bcHPCmK3cpB
         02kToal3VgfEsfmOaLaRvnfN9L3rJ3wXLUufbO8HUeN1GIdMNHpMvsdElrmMhugkAmdb
         jiW6UT1XCjR1pOsWvCytvweTFn8nQx/PD5Cbbij1xOT97r8zic6tzSQ2ZuIQXPi34yq2
         sH+p9VshI6HOGNRXY+qjvf3SXQ1osQajxi9ZYHHeocGeuMvARfifKe1XRCAxgdN+DFQU
         WXV3p1uSXOscr27zdt+drJp1QlF7LK9OdsUu3386/BVFdtNWnPq1r5HPLRzmi7Yq7xKM
         cDKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=JGlVYKOhE0vnUO2uJlfhRsy2OU4tbrDN/YlwAH68OlA=;
        b=gxF81OzwYPVK3SfxiVQtiQ7IT/UI4RS35I8yRsm01SgGckt/Y2tcVNSYC9HcpGuIZE
         XYsgTxpo8g4Sga7WaqA9rigomZESc30U8DNa4v+eoTUZLxGJc/02i5b5BsH68pCQ0gje
         q2E33os6ixiAiCZsCiqD/H05dE1vD12zu/TU5GTeC61IUzxg5hEBJvN0vlTGYfPF+omS
         jyBQbeC96+uac2UZiJztHCLxmLqssrQ5AFXk79FKDA5nTiKTeR7ytZULkKuEMRvvtA2y
         pqqlR9ULQyQlIQKLzRyGTw5ST/7B0DwmAuGDOadB4NOE1YefdVBpFNusEdzF+3dR1otS
         s26Q==
X-Gm-Message-State: ACgBeo1i3htYpd5auisrqde0SkBF/J4XDLQQVSWkjdvKBPbmNwp1lKAd
        g3cyJEGy2xKfLk7GG6CA4mWnsip5q6hvfhCx3us0htT4
X-Google-Smtp-Source: AA6agR72B/i2Sv+68Dtoh6o4c2bgP4iHsBtHCLZLHB7+iUfaZkhkEa0Cnr9ALp5db2cvfBULM6Dx1pJYMsVVsRxXVy0=
X-Received: by 2002:a05:6870:3398:b0:113:7f43:d0e9 with SMTP id
 w24-20020a056870339800b001137f43d0e9mr1643409oae.33.1660145309696; Wed, 10
 Aug 2022 08:28:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220719185659.2068735-1-alexander.deucher@amd.com>
In-Reply-To: <20220719185659.2068735-1-alexander.deucher@amd.com>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Wed, 10 Aug 2022 11:28:18 -0400
Message-ID: <CADnq5_MkB8xKHZxVsiXfWPA-QuVrrNCNXF=ScrYAPjNbAH36LA@mail.gmail.com>
Subject: Re: [PATCH] drm/amdgpu: fix check in fbdev init
To:     Alex Deucher <alexander.deucher@amd.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, hgoffin@amazon.com,
        amd-gfx@lists.freedesktop.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 19, 2022 at 2:57 PM Alex Deucher <alexander.deucher@amd.com> wrote:
>
> The new vkms virtual display code is atomic so there is
> no need to call drm_helper_disable_unused_functions()
> when it is enabled.  Doing so can result in a segfault.
> When the driver switched from the old virtual display code
> to the new atomic virtual display code, it was missed that
> we enable virtual display unconditionally under SR-IOV
> so the checks here missed that case.  Add the missing
> check for SR-IOV.
>
> There is no equivalent of this patch for Linus' tree
> because the relevant code no longer exists.  This patch
> is only relevant to kernels 5.15 and 5.16.
>
> Fixes: 84ec374bd580 ("drm/amdgpu: create amdgpu_vkms (v4)")
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Cc: stable@vger.kernel.org # 5.15.x
> Cc: hgoffin@amazon.com

Hi Greg,

Is there any chance this can get applied?  It fixes a regression on
5.15 and 5.16.

Thanks,

Alex

> ---
>  drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c
> index cd0acbea75da..d58ab9deb028 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c
> @@ -341,7 +341,8 @@ int amdgpu_fbdev_init(struct amdgpu_device *adev)
>         }
>
>         /* disable all the possible outputs/crtcs before entering KMS mode */
> -       if (!amdgpu_device_has_dc_support(adev) && !amdgpu_virtual_display)
> +       if (!amdgpu_device_has_dc_support(adev) && !amdgpu_virtual_display &&
> +           !amdgpu_sriov_vf(adev))
>                 drm_helper_disable_unused_functions(adev_to_drm(adev));
>
>         drm_fb_helper_initial_config(&rfbdev->helper, bpp_sel);
> --
> 2.35.3
>
