Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4328B552F7C
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 12:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349274AbiFUKNh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 06:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347396AbiFUKNR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 06:13:17 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF759286E3
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 03:13:16 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id v4so16487194oiv.1
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 03:13:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=jRAlE/bJ1Ca4hsx5ke9XWk2CzxZrpZgSEfd0e07HGaQ=;
        b=UJQUf3lM6MdURVi+Xf8JRF2JXJgkz4nohXlimzB45Ngshl2/XJBgl2HaZCAsBMEzbE
         oqbFTnNIHOHCCrx1w7m0h0u87It9K3txfFZsxAhQXaOhcyglmhE2EVbp5GpS1798oHOm
         y205LQlV1tLs1o3mNaTnSj2DzO+0UGCSQcUJg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jRAlE/bJ1Ca4hsx5ke9XWk2CzxZrpZgSEfd0e07HGaQ=;
        b=lAMlzN3z6Pn0DRbGmUUIf7m1q1ncxm4mGw5A1905Ztdw1bMYreVVDZyxoDwttZrcFo
         zFueMOMOzHAPTYTMh/1JNkWKD7kF9EwRqQcKqeNGcEuYyM6EmtVsERWEzKq47I9u9E/W
         mLh57UVaUrQhvV1vfZW7tOS4nHxHSmkc76DV2XljDzNOwxhkvInQcEhLdcfvnH0NNVhk
         n3xfE54bbFLj0AH5WAblhLaNnbr3Aqrsa2n8TSYNuWsy51QM1ONNdQVLP+yY+VY/JdNN
         pAmAtPFeO3YnreW8ozgVWYzTbtXCX3WpWCmRgVZn+mthqxTUVB+1tOSvftR2JwlXA2jd
         X01A==
X-Gm-Message-State: AOAM531pIRFYKnQJvuPxz2dh6ULyCJbCqeepyi0udvmPtks4kvh1OBu/
        xYnXt6J4LKdkqSzornI2e2Ubq0umnGUsB0WCsldfSQ==
X-Google-Smtp-Source: ABdhPJyk0o+XH+4mUcXDp1683nEKUzUKopJCe0EMh4GIYy168iqKIfEoXZ9riupCqWV1fEM76j5UFBicUTv0v606HZs=
X-Received: by 2002:aca:aad5:0:b0:32f:3b9b:e0f with SMTP id
 t204-20020acaaad5000000b0032f3b9b0e0fmr19174031oie.228.1655806395148; Tue, 21
 Jun 2022 03:13:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220621092319.379049-1-daniel.vetter@ffwll.ch>
In-Reply-To: <20220621092319.379049-1-daniel.vetter@ffwll.ch>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Tue, 21 Jun 2022 12:13:04 +0200
Message-ID: <CAKMK7uEK_N2LtGypOaru70F40-XKG1sFpoC6ukrx=aCD7u5S8w@mail.gmail.com>
Subject: Re: [PATCH] drm/fb-helper: Make set_var validation stricter
To:     security@kernel.org,
        =?UTF-8?Q?Michel_D=C3=A4nzer?= <michel@daenzer.net>
Cc:     Daniel Stone <daniels@collabora.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        openeuler-security@openeuler.org, guodaxing@huawei.com,
        Weigang <weigang12@huawei.com>,
        Daniel Vetter <daniel.vetter@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Update Michel's address.

On Tue, 21 Jun 2022 at 11:23, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
>
> The drm fbdev emulation does not forward mode changes to the driver,
> and hence all changes where rejected in 865afb11949e ("drm/fb-helper:
> reject any changes to the fbdev").
>
> Unfortunately this resulted in bugs on multiple monitor systems with
> different resolutions. In that case the fbdev emulation code sizes the
> underlying framebuffer for the largest screen (which dictates
> x/yres_virtual), but adjust the fbdev x/yres to match the smallest
> resolution. The above mentioned patch failed to realize that, and
> errornously validated x/yres against the fb dimensions.
>
> This was fixed by just dropping the validation for too small sizes,
> which restored vt switching with 12ffed96d436 ("drm/fb-helper: Allow
> var->x/yres(_virtual) < fb->width/height again").
>
> But this also restored all kinds of validation issues and their
> fallout in the notoriously buggy fbcon code for too small sizes. Since
> no one is volunteering to really make fbcon and vc/vt fully robust
> against these math issues make sure this barn door is closed for good
> again.
>
> Since it's a bit tricky to remember the x/yres we picked across both
> the newer generic fbdev emulation and the older code with more driver
> involvement, we simply check that it doesn't change. This relies on
> drm_fb_helper_fill_var() having done things correctly, and nothing
> having trampled it yet.
>
> Note that this leaves all the other fbdev drivers out in the rain.
> Given that distros have finally started to move away from those
> completely for real I think that's good enough. The code it spaghetti
> enough that I do not feel confident to even review fixes for it.
>
> What might help fbdev is doing something similar to what was done in
> a49145acfb97 ("fbmem: add margin check to fb_check_caps()") and ensure
> x/yres_virtual aren't too small, for some value of "too small". Maybe
> checking that they're at least x/yres makes sense?
>
> Fixes: 12ffed96d436 ("drm/fb-helper: Allow var->x/yres(_virtual) < fb->wi=
dth/height again")
> Cc: Michel D=C3=A4nzer <michel.daenzer@amd.com>
> Cc: Daniel Stone <daniels@collabora.com>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> Cc: Maxime Ripard <mripard@kernel.org>
> Cc: Thomas Zimmermann <tzimmermann@suse.de>
> Cc: <stable@vger.kernel.org> # v4.11+
> Cc: Helge Deller <deller@gmx.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: openeuler-security@openeuler.org
> Cc: guodaxing@huawei.com
> Cc: Weigang (Jimmy) <weigang12@huawei.com>
> Reported-by: Weigang (Jimmy) <weigang12@huawei.com>
> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> ---
> Note: Weigang asked for this to stay under embargo until it's all
> review and tested.
> -Daniel
> ---
>  drivers/gpu/drm/drm_fb_helper.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_hel=
per.c
> index 695997ae2a7c..5664a177a404 100644
> --- a/drivers/gpu/drm/drm_fb_helper.c
> +++ b/drivers/gpu/drm/drm_fb_helper.c
> @@ -1355,8 +1355,8 @@ int drm_fb_helper_check_var(struct fb_var_screeninf=
o *var,
>          * to KMS, hence fail if different settings are requested.
>          */
>         if (var->bits_per_pixel > fb->format->cpp[0] * 8 ||
> -           var->xres > fb->width || var->yres > fb->height ||
> -           var->xres_virtual > fb->width || var->yres_virtual > fb->heig=
ht) {
> +           var->xres !=3D info->var.xres || var->yres !=3D info->var.yre=
s ||
> +           var->xres_virtual !=3D fb->width || var->yres_virtual !=3D fb=
->height) {
>                 drm_dbg_kms(dev, "fb requested width/height/bpp can't fit=
 in current fb "
>                           "request %dx%d-%d (virtual %dx%d) > %dx%d-%d\n"=
,
>                           var->xres, var->yres, var->bits_per_pixel,
> --
> 2.36.0
>


--=20
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
