Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4303482D8
	for <lists+stable@lfdr.de>; Wed, 24 Mar 2021 21:24:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238082AbhCXUXv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Mar 2021 16:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238022AbhCXUXd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Mar 2021 16:23:33 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55A22C06174A
        for <stable@vger.kernel.org>; Wed, 24 Mar 2021 13:23:31 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id g8-20020a9d6c480000b02901b65ca2432cso24299162otq.3
        for <stable@vger.kernel.org>; Wed, 24 Mar 2021 13:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RaZcdCZN7zqROxLNVq3rIO4aLNeOhcX7PBDOpMGUlmE=;
        b=BLsFl3OGLlqkaruz8cUyse209AF9YbDNLtc55K3B+sxHKeTcwbOFutQmJqro4VvRVO
         uYhQDOO1pe7kBibHLnBX9h79tklWvJjBPuoHLPzCvH8Lb1Fl/tfKYI8L5cHtjcrF38wL
         Zs2Ij4K5nbUnLAjQ4iAuyoUuoq1iGRvPbwmTdoie3Y0a1ohlGXc8UcuHJtGIYuJvPLSC
         juQ9Vku+d3YDXU46S7hCUus3baWTYZbbHztqmiCKAH3WB032mG0GIVqCV1ounqIRX6KN
         TzKexoujbodaP6TTwfk+0KBqzipZbVV4rlueCxOFRCatqIQ54ohgC9uUW5AFDxosDNeE
         nvXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RaZcdCZN7zqROxLNVq3rIO4aLNeOhcX7PBDOpMGUlmE=;
        b=faSQYjSwsuJjvoEu8CgZeKCA/WMdEEWA/lRn3HIVwjng657MxgvpW9+elkmJnwOikJ
         Qx1XaMfXZqTreUSgckBvg1XcUx6V5UumN/ftSpDVhjeklHE1hI8Cb9qFZahSr/OgmKUX
         g8EiU4h1DZLa1vuqEBXZOZRquh2nMZCny/IzLEOMDSv7ECkP+i2WmnXUDHxGSkukJIwI
         SeYcO3IUdUfR7GWQ0LIWKfY/FIA/1oPiLnaHepxcf9r9/1Q6jLEN9fsQ/MgmdziV+t+Y
         z27wqu4G9MWjUn5kSMBoVbhSZ8+pdFLBeCqcLPB7TbUjjYq+HT1QXv2Hf6FA9Dz0xBp0
         9i8A==
X-Gm-Message-State: AOAM530xD9aKYUGRMCWqKwamvmbB0RqY5oIGLJnmxA8dIUGuPFsFrJlT
        364hMSPh4EjnCA5FM7jF1pGdWoVeVBofxIQBHu0=
X-Google-Smtp-Source: ABdhPJzUUgR8Spu+CHOcOHs6UfaP8AfSy/e+bFFUzRutJXGFbySDVYUK6VJWWeGUFsfIWGvyxai0yy7WHzDYfd5XC0g=
X-Received: by 2002:a05:6830:408f:: with SMTP id x15mr4767542ott.132.1616617410803;
 Wed, 24 Mar 2021 13:23:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210317151348.11331-1-wse@tuxedocomputers.com>
In-Reply-To: <20210317151348.11331-1-wse@tuxedocomputers.com>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Wed, 24 Mar 2021 16:23:19 -0400
Message-ID: <CADnq5_OpJ-2jR4D8xwH93PZKoMWXx8C2yGTkqt7KRrVgph-KvA@mail.gmail.com>
Subject: Re: [PATCH] drm/amd/display: Try YCbCr420 color when YCbCr444 fails
To:     Werner Sembach <wse@tuxedocomputers.com>
Cc:     "Wentland, Harry" <harry.wentland@amd.com>,
        "Leo (Sunpeng) Li" <sunpeng.li@amd.com>,
        "Deucher, Alexander" <alexander.deucher@amd.com>,
        Christian Koenig <christian.koenig@amd.com>,
        Dave Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        Maling list - DRI developers 
        <dri-devel@lists.freedesktop.org>,
        "for 3.8" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 17, 2021 at 11:25 AM Werner Sembach <wse@tuxedocomputers.com> wrote:
>
> When encoder validation of a display mode fails, retry with less bandwidth
> heavy YCbCr420 color mode, if available. This enables some HDMI 1.4 setups
> to support 4k60Hz output, which previously failed silently.
>
> On some setups, while the monitor and the gpu support display modes with
> pixel clocks of up to 600MHz, the link encoder might not. This prevents
> YCbCr444 and RGB encoding for 4k60Hz, but YCbCr420 encoding might still be
> possible. However, which color mode is used is decided before the link
> encoder capabilities are checked. This patch fixes the problem by retrying
> to find a display mode with YCbCr420 enforced and using it, if it is
> valid.
>
> Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
> Cc: <stable@vger.kernel.org>


This seems reasonable to me.  Harry, Leo, Any objections?

Alex

> ---
>
> From c9398160caf4ff20e63b8ba3a4366d6ef95c4ac3 Mon Sep 17 00:00:00 2001
> From: Werner Sembach <wse@tuxedocomputers.com>
> Date: Wed, 17 Mar 2021 12:52:22 +0100
> Subject: [PATCH] Retry forcing YCbCr420 color on failed encoder validation
>
> ---
>  drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> index 961abf1cf040..2d16389b5f1e 100644
> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> @@ -5727,6 +5727,15 @@ create_validate_stream_for_sink(struct amdgpu_dm_connector *aconnector,
>
>         } while (stream == NULL && requested_bpc >= 6);
>
> +       if (dc_result == DC_FAIL_ENC_VALIDATE && !aconnector->force_yuv420_output) {
> +               DRM_DEBUG_KMS("Retry forcing YCbCr420 encoding\n");
> +
> +               aconnector->force_yuv420_output = true;
> +               stream = create_validate_stream_for_sink(aconnector, drm_mode,
> +                                               dm_state, old_stream);
> +               aconnector->force_yuv420_output = false;
> +       }
> +
>         return stream;
>  }
>
> --
> 2.25.1
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel
