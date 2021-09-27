Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3FF418FB6
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 09:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233097AbhI0HME (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 03:12:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233035AbhI0HME (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Sep 2021 03:12:04 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F6F2C061570
        for <stable@vger.kernel.org>; Mon, 27 Sep 2021 00:10:26 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id u18so71562145lfd.12
        for <stable@vger.kernel.org>; Mon, 27 Sep 2021 00:10:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Aq6qXeEc6aCYUKeljOyg151CIpIcZX36L8L/emY/OsE=;
        b=cdo8ZMZPgS23dQDWWQhIUz40AnsyRN1qLMaZytqB14q9S3g5rNWtoNuUWOrk4IfySl
         /WqSq2xp+D35x4/2OYOxaqEtEKbQwSXukciLeOIfR2YGJBFlv29MPoefU3H0JMAAT917
         6THv9CbJ71Fl8F9NaahSeJGT/JbieFnYEF/n0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Aq6qXeEc6aCYUKeljOyg151CIpIcZX36L8L/emY/OsE=;
        b=GxfjozCgUyOhhkOKDjuBt3iiLS2MDDsnmOfgHhuY7XJoGPKteEvkQcqg9Ga7oNo/bM
         6AMwhXAL2C/TH91XFgH3b1bRGelc2V4D+xLFCwCD20U5apKfIYPOBkzfV2BJIDQ1zyGY
         sQndqIsvaB85HQhScf/HZP7Sf5mopYpIfAmjYxstNBcIHzVIKOZ9IaUOPAWmffvdDDJL
         myoGQs1qciQcf7JuaN40/WDlLpLPviWzzjoYi6oWy2QN4QYvvxxlsKEzZ1v/3RFfCumK
         tC26Iv06S+8dguevnpiZ3+gY1YBLX9p7HXa+1ZGyvxPHt6iqXkSzp50/18uYvwEpTnXJ
         eiWQ==
X-Gm-Message-State: AOAM530ISVB4uhGJ6B+r3C0MfEdAbKQMRQRfG7v/mN2wEWuO+b4WfsBi
        856iUuIOAjrTiglRsrMvPFjqdE0VDUeYgKWhmAV9Xg==
X-Google-Smtp-Source: ABdhPJw8o1CtMltYtGlZxX1NQvnWcDA0rZNViVBF1JsDNzpK+VPC78MlnTbnnUbT6xZKIPOB+g1kjbzjQtQSPw/FcV8=
X-Received: by 2002:a05:651c:1505:: with SMTP id e5mr27957292ljf.9.1632726624665;
 Mon, 27 Sep 2021 00:10:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210924162321.1.Ic2904d37f30013a7f3d8476203ad3733c186827e@changeid>
In-Reply-To: <20210924162321.1.Ic2904d37f30013a7f3d8476203ad3733c186827e@changeid>
From:   Chen-Yu Tsai <wenst@chromium.org>
Date:   Mon, 27 Sep 2021 15:10:13 +0800
Message-ID: <CAGXv+5Ej=sDXOy1Hg9fQrdxN-OEmxpfUjE8PfxgfBkWu9dvOXQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] drm/rockchip: dsi: hold pm-runtime across bind/unbind
To:     Brian Norris <briannorris@chromium.org>
Cc:     =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sandy Huang <hjc@rock-chips.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Thomas Hebb <tommyhebb@gmail.com>,
        aleksandr.o.makarov@gmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Sat, Sep 25, 2021 at 7:24 AM Brian Norris <briannorris@chromium.org> wrote:
>
> In commit 59eb7193bef2, we moved most HW configuration to bind(), but we
> didn't move the runtime PM management. Therefore, depending on initial
> boot state, runtime-PM workqueue delays, and other timing factors, we
> may disable our power domain in between the hardware configuration
> (bind()) and when we enable the display. This can cause us to lose
> hardware state and fail to configure our display. For example:
>
>   dw-mipi-dsi-rockchip ff968000.mipi: failed to write command FIFO
>   panel-innolux-p079zca ff960000.mipi.0: failed to write command 0
>
> or:
>
>   dw-mipi-dsi-rockchip ff968000.mipi: failed to write command FIFO
>   panel-kingdisplay-kd097d04 ff960000.mipi.0: failed write init cmds: -110
>
> We should match the runtime PM to the lifetime of the bind()/unbind()
> cycle.

I'm not too familiar with MIPI DSI, but it seems that the subsystem expects
the DSI link to be always available, and in LPM if power saving is required?
If so then this change matches that expectation, though we might lose some
power savings compared to the previous non-conforming behavior.

> Tested on Acer Chrometab 10 (RK3399 Gru-Scarlet), with panel drivers
> built either as modules or built-in.
>
> Side notes: it seems one is more likely to see this problem when the
> panel driver is built into the kernel. I've also seen this problem
> bisect down to commits that simply changed Kconfig dependencies, because
> it changed the order in which driver init functions were compiled into
> the kernel, and therefore the ordering and timing of built-in device
> probe.
>
> Fixes: 59eb7193bef2 ("drm/rockchip: dsi: move all lane config except LCDC mux to bind()")

This hash is from some stable branch. The mainline one is:

43c2de1002d2 drm/rockchip: dsi: move all lane config except LCDC mux to bind()

> Link: https://lore.kernel.org/linux-rockchip/9aedfb528600ecf871885f7293ca4207c84d16c1.camel@gmail.com/
> Reported-by: <aleksandr.o.makarov@gmail.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> ---
>
>  .../gpu/drm/rockchip/dw-mipi-dsi-rockchip.c   | 22 +++++++------------
>  1 file changed, 8 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c b/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c
> index a2262bee5aa4..4340a99edb97 100644
> --- a/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c
> +++ b/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c
> @@ -773,10 +773,6 @@ static void dw_mipi_dsi_encoder_enable(struct drm_encoder *encoder)
>         if (mux < 0)
>                 return;
>
> -       pm_runtime_get_sync(dsi->dev);
> -       if (dsi->slave)
> -               pm_runtime_get_sync(dsi->slave->dev);
> -
>         /*
>          * For the RK3399, the clk of grf must be enabled before writing grf
>          * register. And for RK3288 or other soc, this grf_clk must be NULL,
> @@ -795,20 +791,10 @@ static void dw_mipi_dsi_encoder_enable(struct drm_encoder *encoder)
>         clk_disable_unprepare(dsi->grf_clk);
>  }
>
> -static void dw_mipi_dsi_encoder_disable(struct drm_encoder *encoder)
> -{
> -       struct dw_mipi_dsi_rockchip *dsi = to_dsi(encoder);
> -
> -       if (dsi->slave)
> -               pm_runtime_put(dsi->slave->dev);
> -       pm_runtime_put(dsi->dev);
> -}
> -
>  static const struct drm_encoder_helper_funcs
>  dw_mipi_dsi_encoder_helper_funcs = {
>         .atomic_check = dw_mipi_dsi_encoder_atomic_check,
>         .enable = dw_mipi_dsi_encoder_enable,
> -       .disable = dw_mipi_dsi_encoder_disable,
>  };
>
>  static int rockchip_dsi_drm_create_encoder(struct dw_mipi_dsi_rockchip *dsi,
> @@ -938,6 +924,10 @@ static int dw_mipi_dsi_rockchip_bind(struct device *dev,
>                 put_device(second);
>         }
>
> +       pm_runtime_get_sync(dsi->dev);
> +       if (dsi->slave)
> +               pm_runtime_get_sync(dsi->slave->dev);
> +
>         ret = clk_prepare_enable(dsi->pllref_clk);
>         if (ret) {
>                 DRM_DEV_ERROR(dev, "Failed to enable pllref_clk: %d\n", ret);

The bind function is missing an error cleanup path. We might end up with
unbalanced runtime PM references. (And also possibly an enabled pllref clk.)
This is a pre-existing issue though. The code changes here look correct.

Regards
ChenYu


> @@ -989,6 +979,10 @@ static void dw_mipi_dsi_rockchip_unbind(struct device *dev,
>         dw_mipi_dsi_unbind(dsi->dmd);
>
>         clk_disable_unprepare(dsi->pllref_clk);
> +
> +       pm_runtime_put(dsi->dev);
> +       if (dsi->slave)
> +               pm_runtime_put(dsi->slave->dev);
>  }
>
>  static const struct component_ops dw_mipi_dsi_rockchip_ops = {
> --
> 2.33.0.685.g46640cef36-goog
>
>
> _______________________________________________
> Linux-rockchip mailing list
> Linux-rockchip@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-rockchip
