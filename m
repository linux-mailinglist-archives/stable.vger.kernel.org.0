Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF6C38CCE6
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 20:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238497AbhEUSHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 14:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238482AbhEUSHf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 May 2021 14:07:35 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E494C0613CE
        for <stable@vger.kernel.org>; Fri, 21 May 2021 11:06:11 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id r12so21903361wrp.1
        for <stable@vger.kernel.org>; Fri, 21 May 2021 11:06:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=raspberrypi.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D5LwmNVFsSfy6EyRs7Ealr4gzA97VJM1KuOHtzH0Li0=;
        b=VE0HakH5HjuuQJKCxvKI5+8hyL5a8G9LX7e9Rjffwcw2UeJqvG6j3fhS10puSV5X73
         CzlMG7QORuLeT3EXZg9T8bZIkO8xrHlT2wpEP4OnnbJoc0oPrrWSgA+q5wH7tZAkEPEI
         Teb+xPMKbuRZkdkwfW3WTLZWr+hC8Q5tG1i79mkvCsjSMt5yoou1NHoE53Ch4NCuv4bJ
         +eZyR5P+TZLyyHfG5boD/jGH6HdO+Uw2wRoiFdKyjn2X1cUuY6cUb03Zuh4aOh9ZjjYt
         76J1DYOvCEVREhQe7M3CagXt/C7/CwqijicoI/cX4WWJ0ntUZpy1nIbU0CQ6TkW/E9k7
         8wYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D5LwmNVFsSfy6EyRs7Ealr4gzA97VJM1KuOHtzH0Li0=;
        b=CY2Tn0F5wF5AnyHqNdALUeU71tPUSkcMx/0PPZ9Jjoydcxp1GEAdEVpxET8e3o5cyg
         bqKWjafIdz/ma3mFsdDm+JRlH0FXYKZFRurgfCuWm/SFERuJ6V0OEE3DEspiZ1/rv7wx
         2R99T8kCbGeDU+5e/ZQqjXQyFmiMyzRpmW4s79EEesrBIx38OulMD6gVUQb48E1Zv1Sf
         F2gPZjxoc8ChyR2vd3JsEkLEhRrAKQDQ8RAvCHGaw6najGUmBMMil9Owh+xk01srfxCq
         x6cRyZfqWQd2wWZ4juAA+q+ozTWztCP0wFJT6xlqV5BH+CXk89cnMWunRBBjbGEn6kBK
         pjag==
X-Gm-Message-State: AOAM533mKsLEzUvw0Ikwr++xxWKRjlMONyMfaeBIhM10KXfbprJ031nM
        9gvosClmdXVV9kYkgg0icVk+VQwaAZc04L5xAfykzm6XiJg=
X-Google-Smtp-Source: ABdhPJzX2Eq4rQeY4gzgDvqnd7rQnzuIshDnGr5EuwboV/EfaHrQg8AH54RsVMdP1TD5pJIaYTw1SphxHZ1NIv/2R+c=
X-Received: by 2002:a5d:4351:: with SMTP id u17mr10693936wrr.47.1621620370129;
 Fri, 21 May 2021 11:06:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210507150515.257424-1-maxime@cerno.tech> <20210507150515.257424-7-maxime@cerno.tech>
In-Reply-To: <20210507150515.257424-7-maxime@cerno.tech>
From:   Dave Stevenson <dave.stevenson@raspberrypi.com>
Date:   Fri, 21 May 2021 19:05:53 +0100
Message-ID: <CAPY8ntACvEvvEgRY_Y-fHANLW+0K9iariwpicDGOVM+Xje_CeQ@mail.gmail.com>
Subject: Re: [PATCH v4 06/12] drm/vc4: hdmi: Prevent clock unbalance
To:     Maxime Ripard <maxime@cerno.tech>
Cc:     Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        David Airlie <airlied@linux.ie>, Eric Anholt <eric@anholt.net>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-rpi-kernel@lists.infradead.org,
        Phil Elwell <phil@raspberrypi.com>,
        Tim Gover <tim.gover@raspberrypi.com>,
        Dom Cobley <dom@raspberrypi.com>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 7 May 2021 at 16:05, Maxime Ripard <maxime@cerno.tech> wrote:
>
> Since we fixed the hooks to disable the encoder at boot, we now have an
> unbalanced clk_disable call at boot since we never enabled them in the
> first place.
>
> Let's mimic the state of the hardware and enable the clocks at boot if
> the controller is enabled to get the use-count right.
>
> Cc: <stable@vger.kernel.org> # v5.10+
> Fixes: 09c438139b8f ("drm/vc4: hdmi: Implement finer-grained hooks")
> Signed-off-by: Maxime Ripard <maxime@cerno.tech>

Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>

> ---
>  drivers/gpu/drm/vc4/vc4_hdmi.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
> index 1fda574579af..9c919472ae84 100644
> --- a/drivers/gpu/drm/vc4/vc4_hdmi.c
> +++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
> @@ -1995,6 +1995,14 @@ static int vc4_hdmi_bind(struct device *dev, struct device *master, void *data)
>         if (vc4_hdmi->variant->reset)
>                 vc4_hdmi->variant->reset(vc4_hdmi);
>
> +       if ((of_device_is_compatible(dev->of_node, "brcm,bcm2711-hdmi0") ||
> +            of_device_is_compatible(dev->of_node, "brcm,bcm2711-hdmi1")) &&
> +           HDMI_READ(HDMI_VID_CTL) & VC4_HD_VID_CTL_ENABLE) {
> +               clk_prepare_enable(vc4_hdmi->pixel_clock);
> +               clk_prepare_enable(vc4_hdmi->hsm_clock);
> +               clk_prepare_enable(vc4_hdmi->pixel_bvb_clock);
> +       }
> +
>         pm_runtime_enable(dev);
>
>         drm_simple_encoder_init(drm, encoder, DRM_MODE_ENCODER_TMDS);
> --
> 2.31.1
>
