Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD90114AAC3
	for <lists+stable@lfdr.de>; Mon, 27 Jan 2020 20:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725938AbgA0T65 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jan 2020 14:58:57 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38462 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbgA0T64 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jan 2020 14:58:56 -0500
Received: by mail-wm1-f66.google.com with SMTP id a9so3508868wmj.3
        for <stable@vger.kernel.org>; Mon, 27 Jan 2020 11:58:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NjWH5hq6JOVGc8DtlGVaAUzKTFE7kCZSGUKwFEb4+oE=;
        b=UhMz/7MY18F0hGdePd6lNR+cm3IMw+AbNUlYpkwwxPBZFvkG0MnPDjCO8sejM15k4H
         uF94cG1a7ac9w90hheUYaSAUCJMhUROFBU+Ovp3KHpYa2c3DfNHCnn2Dqv9TIiHe3ZOt
         R+SU1jE9eYNNUC3idlnoCd6SEW275cYX63ty1PLhk3EuYRrQCWdH+Aa9+J2o+utruM9Q
         bQgz+bx83v5BNR5ASGhtxsWdL7tHbzrVozc2HjNv+f5PwM0nmWRpAZHBRKIXkgtiYqVI
         15aPVq8av6fTC/orv4X0jwMxhRwd27VSE9RKv5ESC2qPByp5nT75OcQh0NkNx1ckCsP6
         d5Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NjWH5hq6JOVGc8DtlGVaAUzKTFE7kCZSGUKwFEb4+oE=;
        b=oBljym4LcSLVfGiAwOTOfMHDHpbMjtrf64k92vYSMoNr+i2UQC8BZdY3Q7mmieUGaK
         fRmCY4FkXZHBRDwjDqqSzRnMHBb5lLxgeOlbseVob3n0CHUYlXbgeM/5xhQHVmeX+Y81
         /eqaA2K88Du/HJC+PA/mK+6OzxLOubW8w1xzABUUXVMCWn3TOodtZj5ub9Z4G7YbHiGD
         s4L7SLPIl23VM4tiltlsHsWumc7Qr0ZuR1yEc3rL7kUQjbhK4hwRf1CtPfzxi8K0RKMN
         x0QOrjWKICSHYu6H+DQCZTJ9rCL402id1RftlWtiAOgj3eZ2GG3owF721wZkVSIVfpvX
         Kvew==
X-Gm-Message-State: APjAAAWmV4ucLhucHm15aOBDdET69+mIwpvCpXVSlvvMyAt8POeWpjxp
        F5UhKa0A3HFqHrDl6+0euwGzuYoX9/Ea2kGTZ2E=
X-Google-Smtp-Source: APXvYqzSJ4yyeECv+2kLzTliNZRLy+OPAVYReep+n1Fu+lioWSk+6VGtA93kTBKWU3V6V/BGm429NVr4nbzXx9d58Bo=
X-Received: by 2002:a1c:f009:: with SMTP id a9mr300738wmb.73.1580155135137;
 Mon, 27 Jan 2020 11:58:55 -0800 (PST)
MIME-Version: 1.0
References: <d4fb24b4-bc95-4684-bb09-3cf4df8b3c2c@canonical.com> <20200124192343.12540-1-harry.wentland@amd.com>
In-Reply-To: <20200124192343.12540-1-harry.wentland@amd.com>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Mon, 27 Jan 2020 14:58:41 -0500
Message-ID: <CADnq5_Nz-RD6+Or0qS2SWf-r8dxcz1BwJjrjNS7tuSJqu+-odQ@mail.gmail.com>
Subject: Re: [PATCH] drm/amd/display: Fix psr static frames calculation
To:     Harry Wentland <harry.wentland@amd.com>
Cc:     amd-gfx list <amd-gfx@lists.freedesktop.org>,
        Colin Ian King <colin.king@canonical.com>,
        Zhan Liu <Zhan.Liu@amd.com>, Roman Li <roman.li@amd.com>,
        "for 3.8" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 24, 2020 at 2:23 PM Harry Wentland <harry.wentland@amd.com> wrote:
>
> From: Roman Li <Roman.Li@amd.com>
>
> [Why]
> Driver crash with psr feature enabled due to divide-by-zero error.
> This is a regression after rework to calculate static screen frame
> number entry time.
>
> [How]
> Correct order of operations to avoid divide-by-zero.
>
> Cc: Colin Ian King <colin.king@canonical.com>
> Fixes: 5b5abe952607 drm/amd/display: make PSR static screen entry within 30 ms
> Cc: stable@vger.kernel.org
> Signed-off-by: Roman Li <roman.li@amd.com>
> Reviewed-by: Zhan Liu <Zhan.Liu@amd.com>

Acked-by: Alex Deucher <alexander.deucher@amd.com>

> ---
>  drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> index eed3ed7180fd..61c36c1520c2 100644
> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> @@ -8491,7 +8491,6 @@ bool amdgpu_dm_psr_enable(struct dc_stream_state *stream)
>         /* Calculate number of static frames before generating interrupt to
>          * enter PSR.
>          */
> -       unsigned int frame_time_microsec = 1000000 / vsync_rate_hz;
>         // Init fail safe of 2 frames static
>         unsigned int num_frames_static = 2;
>
> @@ -8506,8 +8505,10 @@ bool amdgpu_dm_psr_enable(struct dc_stream_state *stream)
>          * Calculate number of frames such that at least 30 ms of time has
>          * passed.
>          */
> -       if (vsync_rate_hz != 0)
> +       if (vsync_rate_hz != 0) {
> +               unsigned int frame_time_microsec = 1000000 / vsync_rate_hz;
>                 num_frames_static = (30000 / frame_time_microsec) + 1;
> +       }
>
>         params.triggers.cursor_update = true;
>         params.triggers.overlay_update = true;
> --
> 2.25.0
>
> _______________________________________________
> amd-gfx mailing list
> amd-gfx@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/amd-gfx
