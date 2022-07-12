Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06B66571EE6
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 17:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233084AbiGLPWA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 11:22:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbiGLPVc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 11:21:32 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3930F2D1F8
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 08:19:42 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id y8so10545804eda.3
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 08:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C9VaI0vSPKUD5SvoWT4Rlvx+rE2rxs+iV6uR37UPyfs=;
        b=G3vieiWvH01IfSAf2DTS/mYiBZuPsMSXH7MlkDlEiQJuNUD33eBA3lU8zpnVu/iyH/
         RHiix9oiqYDTVSpyT22raDMYkUU/DRkiGnsb8fEpAEIplFYXwhm2OHP/CS+BMZUcuCSw
         Ge0P879iGSJblKX5fMWux/At6UBxetyip/f76gVA4umBJoEg5o3MaGSmisAgthdbAAj/
         oSJDsiGpH55MSkIx+jtI32KQ2oZvVhVBhSrNwN2FcnXMNmMffRE2Am2tFHvhgKIndMkZ
         VWJTQbd/rYP+6fhhnSAXPU5FyK6exyBPg965IrU8YdFOGTtGgN1yRBvl8HN0EWmQRJ8e
         5ciQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C9VaI0vSPKUD5SvoWT4Rlvx+rE2rxs+iV6uR37UPyfs=;
        b=03L0fAFAmw1vLloipXB0oIX7xRitAIklpfxqSrxSVhd3bECoVmNaH0mlG/sGib6p09
         01uBMCH9VuouDLjBe42fwygazvKtYzXQNtgqateOXhQa7oA6kyWLYzQbMuSCwqpZLynT
         U5I+MEQ2XJuRS1Sxqjor04adNISRwxP7LY/+tYjfIwV8bPhWM0LGLRLUtZRhsVbOy5VM
         2naGaBNr9BTHrFyLDdiMAk5lf3FFfl9FhcsC6V3O16yIFVVwHi76/dewevbNac9HiAz+
         ggm63xdzkZorX0H6sR79V/PtVWARJ2etqRNio3Arb6THWSsw9nL10hI3f1Yef86RgKqm
         Vlfg==
X-Gm-Message-State: AJIora+8jGXZFfZwO7RSaa/vr6SSqSq9u19YzoEOH2+zs8ZFEf4hZhoa
        DyHxtoHpUNX3Absu9lpdCvSqDHLr704aAo8iSGY=
X-Google-Smtp-Source: AGRyM1uCLAdGLDWrBHKTlPgbK7mM1MRwJiXD6iCchvPA7KNWfKzYUHhfzOXF0CTlFfMxm2hRzW2LnzwAOQ6+2f03tv0=
X-Received: by 2002:a05:6402:28c3:b0:43a:6d78:1b64 with SMTP id
 ef3-20020a05640228c300b0043a6d781b64mr31964242edb.93.1657639180802; Tue, 12
 Jul 2022 08:19:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220711173928.3858-1-mario.kleiner.de@gmail.com>
In-Reply-To: <20220711173928.3858-1-mario.kleiner.de@gmail.com>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Tue, 12 Jul 2022 11:19:29 -0400
Message-ID: <CADnq5_Mm+Bjra+nqmmeMpX5zJ9fQUgQOJuBaqZYpjsCGtbXQUg@mail.gmail.com>
Subject: Re: [PATCH] drm/amd/display: Only use depth 36 bpp linebuffers on DCN
 display engines.
To:     Mario Kleiner <mario.kleiner.de@gmail.com>
Cc:     amd-gfx list <amd-gfx@lists.freedesktop.org>,
        Maling list - DRI developers 
        <dri-devel@lists.freedesktop.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        "for 3.8" <stable@vger.kernel.org>
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

Applied.  Thanks!

Alex

On Mon, Jul 11, 2022 at 1:39 PM Mario Kleiner
<mario.kleiner.de@gmail.com> wrote:
>
> Various DCE versions had trouble with 36 bpp lb depth, requiring fixes,
> last time in commit 353ca0fa5630 ("drm/amd/display: Fix 10bit 4K display
> on CIK GPUs") for DCE-8. So far >= DCE-11.2 was considered ok, but now I
> found out that on DCE-11.2 it causes dithering when there shouldn't be
> any, so identity pixel passthrough with identity gamma LUTs doesn't work
> when it should. This breaks various important neuroscience applications,
> as reported to me by scientific users of Polaris cards under Ubuntu 22.04
> with Linux 5.15, and confirmed by testing it myself on DCE-11.2.
>
> Lets only use depth 36 for DCN engines, where my testing showed that it
> is both necessary for high color precision output, e.g., RGBA16 fb's,
> and not harmful, as far as more than one year in real-world use showed.
>
> DCE engines seem to work fine for high precision output at 30 bpp, so
> this ("famous last words") depth 30 should hopefully fix all known problems
> without introducing new ones.
>
> Successfully retested on DCE-11.2 Polaris and DCN-1.0 Raven Ridge on
> top of Linux 5.19.0-rc2 + drm-next.
>
> Fixes: 353ca0fa5630 ("drm/amd/display: Fix 10bit 4K display on CIK GPUs")
> Signed-off-by: Mario Kleiner <mario.kleiner.de@gmail.com>
> Tested-by: Mario Kleiner <mario.kleiner.de@gmail.com>
> Cc: stable@vger.kernel.org # 5.14.0
> Cc: Alex Deucher <alexander.deucher@amd.com>
> Cc: Harry Wentland <harry.wentland@amd.com>
> ---
>  drivers/gpu/drm/amd/display/dc/core/dc_resource.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
> index 6774dd8bb53e..3fe3fbac1e63 100644
> --- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
> +++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
> @@ -1117,12 +1117,13 @@ bool resource_build_scaling_params(struct pipe_ctx *pipe_ctx)
>          * on certain displays, such as the Sharp 4k. 36bpp is needed
>          * to support SURFACE_PIXEL_FORMAT_GRPH_ARGB16161616 and
>          * SURFACE_PIXEL_FORMAT_GRPH_ABGR16161616 with actual > 10 bpc
> -        * precision on at least DCN display engines. However, at least
> -        * Carrizo with DCE_VERSION_11_0 does not like 36 bpp lb depth,
> -        * so use only 30 bpp on DCE_VERSION_11_0. Testing with DCE 11.2 and 8.3
> -        * did not show such problems, so this seems to be the exception.
> +        * precision on DCN display engines, but apparently not for DCE, as
> +        * far as testing on DCE-11.2 and DCE-8 showed. Various DCE parts have
> +        * problems: Carrizo with DCE_VERSION_11_0 does not like 36 bpp lb depth,
> +        * neither do DCE-8 at 4k resolution, or DCE-11.2 (broken identify pixel
> +        * passthrough). Therefore only use 36 bpp on DCN where it is actually needed.
>          */
> -       if (plane_state->ctx->dce_version > DCE_VERSION_11_0)
> +       if (plane_state->ctx->dce_version > DCE_VERSION_MAX)
>                 pipe_ctx->plane_res.scl_data.lb_params.depth = LB_PIXEL_DEPTH_36BPP;
>         else
>                 pipe_ctx->plane_res.scl_data.lb_params.depth = LB_PIXEL_DEPTH_30BPP;
> --
> 2.34.1
>
