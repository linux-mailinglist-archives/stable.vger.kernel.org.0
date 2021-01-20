Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D12B2FD6F0
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 18:33:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389473AbhATOIY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jan 2021 09:08:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727861AbhATNC1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jan 2021 08:02:27 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90A12C0613C1
        for <stable@vger.kernel.org>; Wed, 20 Jan 2021 05:01:40 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id r189so15263510oih.4
        for <stable@vger.kernel.org>; Wed, 20 Jan 2021 05:01:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=evwLpKMs/Q04HfoyBMd6+/dktMNHRP3J0svCExuNnHQ=;
        b=gjoMlQDXxoLKyVqfmWYc+fQsUBlfTlV9o5PJnH+Fw3wT6GK9N8OlzvgssUU0vb0fZH
         lnyuUY13b3P8wylC1s1XZ51WGymbIFWbcPL/0lXA0Z7SliOOw3K8jFrpKcp+79daAMjG
         3G0usdR1gu6MsBvz81d0Wq6+o038KK/qKvaQI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=evwLpKMs/Q04HfoyBMd6+/dktMNHRP3J0svCExuNnHQ=;
        b=Y2jF+tY7k7k/I5wmIogKP+qtaMr/6D8Xrkm15VVL/Qb7T8l4S5zFp6WFApNGdRVsq7
         3hQ+fvvO07Ry2DUQE81N3vJwHXb3pxYZaKWpk+bdgxYRguYsY4U4B47gs3R7RFpacLqH
         8SJs0R8DF7lcoXKI8WugIk/CJn7OSnhjdJD/LXUISbm4z37CEmYrrg6DyTl+Oo4rp+QM
         QWFwbQJVursI7zFxfyKQIK779FPUBPn+HGPFf6vtjbVuvsgktF7eff/A/COVMMJ3wZys
         KCZ0EvOkYIHLTdEqnrPqiX0UmQ+ALCFz2bu4WxtOSXuzspCGqLBtvd0Htz3yokZgaogj
         U/og==
X-Gm-Message-State: AOAM532mqIXKMN3dFfGt5F5SnNM/j7K759/XhiHvyxXR9Zpvrraba45d
        7fzeR/fCd+GcpxRA24wb6L6EuyIwMRtdN9HDu1IHqg==
X-Google-Smtp-Source: ABdhPJysT1Qy1MoMTRm8ql1bbsTkrvfGzeuP7tdOfKNPpJBmNa21UPEZGnfc3jKm9tHnbkwY1t4S/wSfEQIfR+Gs4/k=
X-Received: by 2002:aca:1906:: with SMTP id l6mr2714101oii.101.1611147697279;
 Wed, 20 Jan 2021 05:01:37 -0800 (PST)
MIME-Version: 1.0
References: <20210120123535.40226-1-paul@crapouillou.net> <20210120123535.40226-3-paul@crapouillou.net>
In-Reply-To: <20210120123535.40226-3-paul@crapouillou.net>
From:   Daniel Vetter <daniel@ffwll.ch>
Date:   Wed, 20 Jan 2021 14:01:26 +0100
Message-ID: <CAKMK7uFaP7xcw90=KqiGJd7Mt-gD-spvcxvOZr2Txhyv5vcBvw@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] drm/ingenic: Register devm action to cleanup encoders
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     David Airlie <airlied@linux.ie>, Sam Ravnborg <sam@ravnborg.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        od@zcrc.me, dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 20, 2021 at 1:36 PM Paul Cercueil <paul@crapouillou.net> wrote:
>
> Since the encoders have been devm-allocated, they will be freed way
> before drm_mode_config_cleanup() is called. To avoid use-after-free
> conditions, we then must ensure that drm_encoder_cleanup() is called
> before the encoders are freed.
>
> v2: Use the new __drmm_simple_encoder_alloc() function
>
> Fixes: c369cb27c267 ("drm/ingenic: Support multiple panels/bridges")
> Cc: <stable@vger.kernel.org> # 5.8+
> Signed-off-by: Paul Cercueil <paul@crapouillou.net>
> ---
>
> Notes:
>     Use the V1 of this patch to fix v5.11 and older kernels. This V2 only
>     applies on the current drm-misc-next branch.
>
>  drivers/gpu/drm/ingenic/ingenic-drm-drv.c | 16 +++++++---------
>  1 file changed, 7 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
> index 7bb31fbee29d..158433b4c084 100644
> --- a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
> +++ b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
> @@ -1014,20 +1014,18 @@ static int ingenic_drm_bind(struct device *dev, bool has_components)
>                         bridge = devm_drm_panel_bridge_add_typed(dev, panel,
>                                                                  DRM_MODE_CONNECTOR_DPI);
>
> -               encoder = devm_kzalloc(dev, sizeof(*encoder), GFP_KERNEL);
> -               if (!encoder)
> -                       return -ENOMEM;
> +               encoder = __drmm_simple_encoder_alloc(drm, sizeof(*encoder), 0,

Please don't use the __ prefixed functions, those are the internal
ones. The official one comes with type checking and all that included.
Otherwise lgtm.
-Daniel

> +                                                     DRM_MODE_ENCODER_DPI);
> +               if (IS_ERR(encoder)) {
> +                       ret = PTR_ERR(encoder);
> +                       dev_err(dev, "Failed to init encoder: %d\n", ret);
> +                       return ret;
> +               }
>
>                 encoder->possible_crtcs = 1;
>
>                 drm_encoder_helper_add(encoder, &ingenic_drm_encoder_helper_funcs);
>
> -               ret = drm_simple_encoder_init(drm, encoder, DRM_MODE_ENCODER_DPI);
> -               if (ret) {
> -                       dev_err(dev, "Failed to init encoder: %d\n", ret);
> -                       return ret;
> -               }
> -
>                 ret = drm_bridge_attach(encoder, bridge, NULL, 0);
>                 if (ret) {
>                         dev_err(dev, "Unable to attach bridge\n");
> --
> 2.29.2
>


-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
