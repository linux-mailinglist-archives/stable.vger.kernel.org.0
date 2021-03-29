Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EFE834D3E8
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 17:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbhC2P2t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 11:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231312AbhC2P2Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 11:28:24 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB8B5C061574
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 08:28:24 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id g8-20020a9d6c480000b02901b65ca2432cso12641149otq.3
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 08:28:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sL+u4G7CrcA6Z+TYaOSWP3JFMaDkhckMWoxhAu6f8eY=;
        b=G0/S0pMQjOWbDYVq3Eg2hpnVRgtSNFukbo80ggQSwyQO7G1V8RbEcV+ahVZmJl0M1X
         2keMHJsikzpjqQOsPFfwkdfoj7JS5vsEAlxWjJ3wy9BYG6k1wUmREvnuJQwEKYVclXis
         hhmQDwPw8dLrI5+VBEgi8u/bjutQHVIsAxfAgdm8sCD+vIxy38vVI6Cn5U5WwqIeUPZM
         VxwPyq9TLmOo9ZwKZr3VH33nd1EVOp9eMaaZYEqP6IrY1CjUHKmnunTBOsFw6WS9At/Q
         CH77zcFrcp4g0kViyGgxFD4Ja5OEarHddizi/5+3kjbeYbd18V5ahKoKu0sZ6TVLKFR3
         sqUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sL+u4G7CrcA6Z+TYaOSWP3JFMaDkhckMWoxhAu6f8eY=;
        b=YKY7R4PSLcvaIAHYyISjXWtO/3GMSm7M1KZQctR098Az/nYoNSMALgu32+ub4flcZL
         5as2HQ5XGmQkn6FlEAxbc9AOGC2g8ym5oeSPWmq15jCUrHEhGtr4G2His57EsdMOFDBb
         ypbBSWBDsjmYlwC8mfwd91Z92cIK3iQ+zml/KuIg1YlKEhDmL53/5UAWYPtjoaK+FpvF
         DM7BNIjIKznfYwYG3oVXGBQ+FuXTuvMZSE+uLKkXs/cd1V3u4me7KdvUXtjyyTdSzmcJ
         UHPwbr5fcveyACsUbNKXyAuXJkW9uJp0/KJq6rQFbmsPn/cRVLvuObRTsEqmr858MHzW
         FS3g==
X-Gm-Message-State: AOAM530onuoIIJzfZQS7JpdXDInXCYRCgBh4Wl9s9waPqoJJAq1zyEMH
        ATaEZ5lPZ1VjT5RIVqKbnjdF+ZF4IxYLwBP61yo=
X-Google-Smtp-Source: ABdhPJw14WGwRwjI3JS9f/hgxbza0cAEMKGAJ1wRfH1tTSrMO2vp3Xb4f94nKSRpGzGiFNuddd5MLmhatevZH6uQA5A=
X-Received: by 2002:a9d:d89:: with SMTP id 9mr23556338ots.23.1617031704134;
 Mon, 29 Mar 2021 08:28:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210317151348.11331-1-wse@tuxedocomputers.com>
 <CADnq5_OpJ-2jR4D8xwH93PZKoMWXx8C2yGTkqt7KRrVgph-KvA@mail.gmail.com> <53b26416-31d0-6efd-04e9-2a9f34e525b7@amd.com>
In-Reply-To: <53b26416-31d0-6efd-04e9-2a9f34e525b7@amd.com>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Mon, 29 Mar 2021 11:28:13 -0400
Message-ID: <CADnq5_NwuTv5pWiOk_bYdemm+aPi_SNZTYzMLO3ewma-Bkwhkg@mail.gmail.com>
Subject: Re: [PATCH] drm/amd/display: Try YCbCr420 color when YCbCr444 fails
To:     Harry Wentland <harry.wentland@amd.com>
Cc:     Werner Sembach <wse@tuxedocomputers.com>,
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

Applied.  Thanks!

Alex

On Fri, Mar 26, 2021 at 10:59 AM Harry Wentland <harry.wentland@amd.com> wrote:
>
>
>
> On 2021-03-24 4:23 p.m., Alex Deucher wrote:
> > On Wed, Mar 17, 2021 at 11:25 AM Werner Sembach <wse@tuxedocomputers.com> wrote:
> >>
> >> When encoder validation of a display mode fails, retry with less bandwidth
> >> heavy YCbCr420 color mode, if available. This enables some HDMI 1.4 setups
> >> to support 4k60Hz output, which previously failed silently.
> >>
> >> On some setups, while the monitor and the gpu support display modes with
> >> pixel clocks of up to 600MHz, the link encoder might not. This prevents
> >> YCbCr444 and RGB encoding for 4k60Hz, but YCbCr420 encoding might still be
> >> possible. However, which color mode is used is decided before the link
> >> encoder capabilities are checked. This patch fixes the problem by retrying
> >> to find a display mode with YCbCr420 enforced and using it, if it is
> >> valid.
> >>
> >> Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
> >> Cc: <stable@vger.kernel.org>
> >
> >
> > This seems reasonable to me.  Harry, Leo, Any objections?
> >
>
> Looks good to me.
>
> Reviewed-by: Harry Wentland <harry.wentland@amd.com>
>
> Harry
>
> > Alex
> >
> >> ---
> >>
> >>  From c9398160caf4ff20e63b8ba3a4366d6ef95c4ac3 Mon Sep 17 00:00:00 2001
> >> From: Werner Sembach <wse@tuxedocomputers.com>
> >> Date: Wed, 17 Mar 2021 12:52:22 +0100
> >> Subject: [PATCH] Retry forcing YCbCr420 color on failed encoder validation
> >>
> >> ---
> >>   drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 9 +++++++++
> >>   1 file changed, 9 insertions(+)
> >>
> >> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> >> index 961abf1cf040..2d16389b5f1e 100644
> >> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> >> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> >> @@ -5727,6 +5727,15 @@ create_validate_stream_for_sink(struct amdgpu_dm_connector *aconnector,
> >>
> >>          } while (stream == NULL && requested_bpc >= 6);
> >>
> >> +       if (dc_result == DC_FAIL_ENC_VALIDATE && !aconnector->force_yuv420_output) {
> >> +               DRM_DEBUG_KMS("Retry forcing YCbCr420 encoding\n");
> >> +
> >> +               aconnector->force_yuv420_output = true;
> >> +               stream = create_validate_stream_for_sink(aconnector, drm_mode,
> >> +                                               dm_state, old_stream);
> >> +               aconnector->force_yuv420_output = false;
> >> +       }
> >> +
> >>          return stream;
> >>   }
> >>
> >> --
> >> 2.25.1
> >>
> >> _______________________________________________
> >> dri-devel mailing list
> >> dri-devel@lists.freedesktop.org
> >> https://lists.freedesktop.org/mailman/listinfo/dri-devel>
