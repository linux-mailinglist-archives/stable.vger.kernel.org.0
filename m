Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 819D763F1D7
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 14:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbiLANji (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 08:39:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbiLANjh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 08:39:37 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F0F7AD993
        for <stable@vger.kernel.org>; Thu,  1 Dec 2022 05:39:37 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id r9-20020a05683001c900b0066e6e7a751eso978907ota.0
        for <stable@vger.kernel.org>; Thu, 01 Dec 2022 05:39:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3d2zjXAvFCgKTN9l2ndJOVLE++1FzcNBvbhL7LfqE1E=;
        b=VDkHxX8o9J84KyVFE88taZWspnC8OcZjfdjAOIh4L/yM60dA+1/ed9c2YOhtGjofrr
         KK3j02f2jr2+VYYzpTuzY8VK66Se1NHzwFDVJlQjierpMbhVHqL1LgQ0vxsDL4x1F4fg
         JL/ck+0loGz/wvtu6uTZiy5zZH6fJkeJO8a5PB3KCemV7DYYDu2qQfNwDaMPNfpTkrxq
         Bf7pmdsBLJXAUg3mADOC2R/2b2VxIfwpMW8De0LkBXS7T++cS5aFs+TemNRsm98WrAqD
         V13z0M+6JGTmSG9fSZuVT7cCpOyN6SspnpH2wO9E6wDslo+lBThkCjk2HAS9D8LyES1G
         SGbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3d2zjXAvFCgKTN9l2ndJOVLE++1FzcNBvbhL7LfqE1E=;
        b=1p2xiDx2t9y/PO/E5Cqo7K63r2HkujerNa59hfFnfqWEEJAc2dFIiI6L5U31w6OxX0
         qzMH5Uf6Z3Bx+O96SvTKs2XpdfCXoVW6nZIZRoyVMQf44T74BUmgvd5UbdXGQNasDM/r
         0YDSvoo0Bb7fbDM+NAcVKMc1h0XYRaPWAVgskNx76fxvdQl9lYAOMwkiOWMXlOljBRvx
         FB9TouGgbkMcH5+g1BAWpuHueHjQTCtZX9Q8u16tI3vw/Xaimuj5jeZ3estYbkvjAAZD
         b+f666iUTEb6s3NcwK/AVv4D/Ojqp6QoA6+WklTg3toU2SwoZHgR6pi7hYljJLdAMBXL
         VeXg==
X-Gm-Message-State: ANoB5pmuQEvuouwtjFtJSjWVM9OgozVH5Jtc0EN/ieGt9mPhISuMB9id
        mlYWPkL4iu3CI7x0r2xX7c9p0KDAg/TaDizpN6f9OSdE
X-Google-Smtp-Source: AA0mqf6AlMIsMuLRmUgb0XtNMyqI/Q49PBvMaIhkoCvpEiLWkOePMzbkhjpq+kiDfaERxhlq9zWyjukY3f4hdHCRFzg=
X-Received: by 2002:a05:6830:1b62:b0:66c:7982:2d45 with SMTP id
 d2-20020a0568301b6200b0066c79822d45mr22973671ote.123.1669901976303; Thu, 01
 Dec 2022 05:39:36 -0800 (PST)
MIME-Version: 1.0
References: <20221201075631.983346-1-Prike.Liang@amd.com>
In-Reply-To: <20221201075631.983346-1-Prike.Liang@amd.com>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Thu, 1 Dec 2022 08:39:24 -0500
Message-ID: <CADnq5_MoME88oiE2yr=BPNr-YN+UncNifPJr4Ux+hh+A8vPNwA@mail.gmail.com>
Subject: Re: [PATCH v2] drm/amdgpu/sdma_v4_0: turn off SDMA ring buffer in the
 s2idle suspend
To:     Prike Liang <Prike.Liang@amd.com>
Cc:     amd-gfx@lists.freedesktop.org, Alexander.Deucher@amd.com,
        Lijo.Lazar@amd.com, Mario.Limonciello@amd.com,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 1, 2022 at 2:56 AM Prike Liang <Prike.Liang@amd.com> wrote:
>
> In the SDMA s0ix save process requires to turn off SDMA ring buffer for
> avoiding the SDMA in-flight request, otherwise will suffer from SDMA page
> fault which causes by page request from in-flight SDMA ring accessing at
> SDMA restore phase.
>
> Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2248
> Cc: stable@vger.kernel.org # 6.0
> Fixes: f8f4e2a51834 ("drm/amdgpu: skipping SDMA hw_init and hw_fini for S0ix.")
>
> Signed-off-by: Prike Liang <Prike.Liang@amd.com>

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>

> ---
> -v2: change the name sdma_v4_0_gfx_stop() to sdma_v4_0_gfx_enable() (Lijo)
> ---
>  drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c | 24 +++++++++++++++---------
>  1 file changed, 15 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
> index 1122bd4eae98..4d780e4430e7 100644
> --- a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
> +++ b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
> @@ -907,13 +907,13 @@ static void sdma_v4_0_ring_emit_fence(struct amdgpu_ring *ring, u64 addr, u64 se
>
>
>  /**
> - * sdma_v4_0_gfx_stop - stop the gfx async dma engines
> + * sdma_v4_0_gfx_enable - enable the gfx async dma engines
>   *
>   * @adev: amdgpu_device pointer
> - *
> - * Stop the gfx async dma ring buffers (VEGA10).
> + * @enable: enable SDMA RB/IB
> + * control the gfx async dma ring buffers (VEGA10).
>   */
> -static void sdma_v4_0_gfx_stop(struct amdgpu_device *adev)
> +static void sdma_v4_0_gfx_enable(struct amdgpu_device *adev, bool enable)
>  {
>         u32 rb_cntl, ib_cntl;
>         int i;
> @@ -922,10 +922,10 @@ static void sdma_v4_0_gfx_stop(struct amdgpu_device *adev)
>
>         for (i = 0; i < adev->sdma.num_instances; i++) {
>                 rb_cntl = RREG32_SDMA(i, mmSDMA0_GFX_RB_CNTL);
> -               rb_cntl = REG_SET_FIELD(rb_cntl, SDMA0_GFX_RB_CNTL, RB_ENABLE, 0);
> +               rb_cntl = REG_SET_FIELD(rb_cntl, SDMA0_GFX_RB_CNTL, RB_ENABLE, enable ? 1 : 0);
>                 WREG32_SDMA(i, mmSDMA0_GFX_RB_CNTL, rb_cntl);
>                 ib_cntl = RREG32_SDMA(i, mmSDMA0_GFX_IB_CNTL);
> -               ib_cntl = REG_SET_FIELD(ib_cntl, SDMA0_GFX_IB_CNTL, IB_ENABLE, 0);
> +               ib_cntl = REG_SET_FIELD(ib_cntl, SDMA0_GFX_IB_CNTL, IB_ENABLE, enable ? 1 : 0);
>                 WREG32_SDMA(i, mmSDMA0_GFX_IB_CNTL, ib_cntl);
>         }
>  }
> @@ -1044,7 +1044,7 @@ static void sdma_v4_0_enable(struct amdgpu_device *adev, bool enable)
>         int i;
>
>         if (!enable) {
> -               sdma_v4_0_gfx_stop(adev);
> +               sdma_v4_0_gfx_enable(adev, enable);
>                 sdma_v4_0_rlc_stop(adev);
>                 if (adev->sdma.has_page_queue)
>                         sdma_v4_0_page_stop(adev);
> @@ -1960,8 +1960,10 @@ static int sdma_v4_0_suspend(void *handle)
>         struct amdgpu_device *adev = (struct amdgpu_device *)handle;
>
>         /* SMU saves SDMA state for us */
> -       if (adev->in_s0ix)
> +       if (adev->in_s0ix) {
> +               sdma_v4_0_gfx_enable(adev, false);
>                 return 0;
> +       }
>
>         return sdma_v4_0_hw_fini(adev);
>  }
> @@ -1971,8 +1973,12 @@ static int sdma_v4_0_resume(void *handle)
>         struct amdgpu_device *adev = (struct amdgpu_device *)handle;
>
>         /* SMU restores SDMA state for us */
> -       if (adev->in_s0ix)
> +       if (adev->in_s0ix) {
> +               sdma_v4_0_enable(adev, true);
> +               sdma_v4_0_gfx_enable(adev, true);
> +               amdgpu_ttm_set_buffer_funcs_status(adev, true);
>                 return 0;
> +       }
>
>         return sdma_v4_0_hw_init(adev);
>  }
> --
> 2.25.1
>
