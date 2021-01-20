Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2266F2FD5A1
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 17:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391484AbhATQ12 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jan 2021 11:27:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391464AbhATQ1X (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jan 2021 11:27:23 -0500
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4BC2C0613D6
        for <stable@vger.kernel.org>; Wed, 20 Jan 2021 08:26:13 -0800 (PST)
Received: by mail-ot1-x336.google.com with SMTP id d1so3390051otl.13
        for <stable@vger.kernel.org>; Wed, 20 Jan 2021 08:26:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TR4A8q6K02DxTiaXZ3lXiS7PoGiZ905DDYVFaKV6hJs=;
        b=X+6XC27e9NvRxAXSFcJCX7sBLTclDZaFZztT0rBtKNzuYzjxhbDoOceu3gLmc7RRCG
         jJYxKFy0VDUwRGiSiNWileQMSufEJIZvnv2Lm7VGg7bRZF63rBoiyNMPWnVjrdckTwIc
         bBeX+A5PFbrlPkTNtMd6QGzwA2TjoCRzbkA1k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TR4A8q6K02DxTiaXZ3lXiS7PoGiZ905DDYVFaKV6hJs=;
        b=dXSiz7KTf4f4NYK/tBxmey1fMd6zB07VdYCKqUiQuGrKZ920SrUDfaph+HjNi1aV5N
         TcuaEG1bkY21MnXkh97JzxLPJiFC+K8Kl8s4iXythXbutHex7YhoZXSuQmU4aYsyZXuk
         7xDKlEhhF0BbEYMuDnYP1w5+cvt3WhVie16IuTMxlctq6CbW4SgZKc1dF7dgwLoswSlN
         Vch2WlFwoNeRyvsglXONzE5mpwuP5Ss//kChSA77n7QQfVNf+5alh9hG3gyXfQmTGGbr
         gIL2mMgR5W12CgK1A7mBMmM84807ejDi4KQI5hSzp96nAsPTSBGQ+YebglXPlbRjig35
         sxhg==
X-Gm-Message-State: AOAM533ipPhYg0QGOXloCQ5Nt/kg8vho8ChIxnxd0Vj1EtMx6JPsg+1i
        SFgjo1G58kB+NiVkNFjF2o88kMy2v8PZB58sn0Ajo5pxiJg=
X-Google-Smtp-Source: ABdhPJyqk40fmfS7gqlnqy6/UClYuooRH8LNmG2/KUb4n6AFXeVUr0ep1ChY8yMP9+rjQYw6gpo15Az+wTN1pS5m+oA=
X-Received: by 2002:a05:6830:1bef:: with SMTP id k15mr7418547otb.303.1611159973120;
 Wed, 20 Jan 2021 08:26:13 -0800 (PST)
MIME-Version: 1.0
References: <20210120123535.40226-1-paul@crapouillou.net> <20210120123535.40226-4-paul@crapouillou.net>
In-Reply-To: <20210120123535.40226-4-paul@crapouillou.net>
From:   Daniel Vetter <daniel@ffwll.ch>
Date:   Wed, 20 Jan 2021 17:26:02 +0100
Message-ID: <CAKMK7uFWUWtsOK-tcnon5p6-8ek3ZD2HeexUE7s7vUKKNXFXkg@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] drm/ingenic: Fix non-OSD mode
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
> Even though the JZ4740 did not have the OSD mode, it had (according to
> the documentation) two DMA channels, but there is absolutely no
> information about how to select the second DMA channel.
>
> Make the ingenic-drm driver work in non-OSD mode by using the
> foreground0 plane (which is bound to the DMA0 channel) as the primary
> plane, instead of the foreground1 plane, which is the primary plane
> when in OSD mode.
>
> Fixes: 3c9bea4ef32b ("drm/ingenic: Add support for OSD mode")
> Cc: <stable@vger.kernel.org> # v5.8+
> Signed-off-by: Paul Cercueil <paul@crapouillou.net>

Does what it says on the tin^Wcommit message.

Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> ---
>  drivers/gpu/drm/ingenic/ingenic-drm-drv.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
> index 158433b4c084..963dcbfeaba2 100644
> --- a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
> +++ b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
> @@ -554,7 +554,7 @@ static void ingenic_drm_plane_atomic_update(struct drm_plane *plane,
>                 height = state->src_h >> 16;
>                 cpp = state->fb->format->cpp[0];
>
> -               if (priv->soc_info->has_osd && plane->type == DRM_PLANE_TYPE_OVERLAY)
> +               if (!priv->soc_info->has_osd || plane->type == DRM_PLANE_TYPE_OVERLAY)
>                         hwdesc = &priv->dma_hwdescs->hwdesc_f0;
>                 else
>                         hwdesc = &priv->dma_hwdescs->hwdesc_f1;
> @@ -826,6 +826,7 @@ static int ingenic_drm_bind(struct device *dev, bool has_components)
>         const struct jz_soc_info *soc_info;
>         struct ingenic_drm *priv;
>         struct clk *parent_clk;
> +       struct drm_plane *primary;
>         struct drm_bridge *bridge;
>         struct drm_panel *panel;
>         struct drm_encoder *encoder;
> @@ -940,9 +941,11 @@ static int ingenic_drm_bind(struct device *dev, bool has_components)
>         if (soc_info->has_osd)
>                 priv->ipu_plane = drm_plane_from_index(drm, 0);
>
> -       drm_plane_helper_add(&priv->f1, &ingenic_drm_plane_helper_funcs);
> +       primary = priv->soc_info->has_osd ? &priv->f1 : &priv->f0;
>
> -       ret = drm_universal_plane_init(drm, &priv->f1, 1,
> +       drm_plane_helper_add(primary, &ingenic_drm_plane_helper_funcs);
> +
> +       ret = drm_universal_plane_init(drm, primary, 1,
>                                        &ingenic_drm_primary_plane_funcs,
>                                        priv->soc_info->formats_f1,
>                                        priv->soc_info->num_formats_f1,
> @@ -954,7 +957,7 @@ static int ingenic_drm_bind(struct device *dev, bool has_components)
>
>         drm_crtc_helper_add(&priv->crtc, &ingenic_drm_crtc_helper_funcs);
>
> -       ret = drm_crtc_init_with_planes(drm, &priv->crtc, &priv->f1,
> +       ret = drm_crtc_init_with_planes(drm, &priv->crtc, primary,
>                                         NULL, &ingenic_drm_crtc_funcs, NULL);
>         if (ret) {
>                 dev_err(dev, "Failed to init CRTC: %i\n", ret);
> --
> 2.29.2
>


-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
