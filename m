Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1BED552FF6
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 12:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349140AbiFUKoI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 06:44:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348776AbiFUKnZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 06:43:25 -0400
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81764B7EA
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 03:43:23 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-f2a4c51c45so17802084fac.9
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 03:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=R/SnfkjM81HBhJ/VVSuPA/K/vaprti+o12zP1QCyx08=;
        b=TAQQpXj669FtgDYcpCn63eg5xbghVlw6MCRQtIfYPr0+RnPZxtTSEmzu0zWRVkJ6co
         MxHVSm8Z+TMBESHOwhWMb6VyUlMIJyd1DRdjC+CQ7hlwedJW3YSuCIRhKKdEuTyW9TBo
         G/Vu5I3J/aPDf83iT5M7c+DoHqZ2Pm3aRUa54=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=R/SnfkjM81HBhJ/VVSuPA/K/vaprti+o12zP1QCyx08=;
        b=y53RMHo96IE46YyVZkKAaCwGFmw+c4SIkPqNrupohKIhXWdE5lfP5KDQmWhu0tKzym
         XJB2Nh+aDTbYa/vPJ9+ZqmTT2qS/YUk7J888BYpnTMC2rkROyd2tqSDHF3hRS2OA6ezu
         lD6i1h1LM+yBM8uyIgTU+G26t+D2mV8phizkxWczIYaQgHFChvjm5bdWs+j3fxaGhh4u
         p5Q4EtEjCRJDCl+pQp5tReGk+ngb2WeV+c/60xNhK4LbwUY4zFXaAsZhwmgrL4d6dATN
         kwyxOZV+yQwPuvPdnHIumcT68wlLS16c1y4n2b8ZIbrxZlDUtGmevsnFYMKmuIOI1tNJ
         XAKw==
X-Gm-Message-State: AJIora90KyPZM/ftWt8LHNe1BT/7/6Pn2fuexs+ZAHAsPKUykLr5dsM2
        R/qZjrlhk7YqxiAv11HxHVT5gTa6/VPTofX49bkp9g==
X-Google-Smtp-Source: AGRyM1v/k6WCjIiH/KnM1+hdSUvoFTwkWsorqLslg7DFFPeRIX+h3fPpO+sqKvkN5eCzfyBbsFMoeAlv9hnXGRHngII=
X-Received: by 2002:a05:6870:3053:b0:f3:2997:659a with SMTP id
 u19-20020a056870305300b000f32997659amr15627650oau.7.1655808202430; Tue, 21
 Jun 2022 03:43:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220621092319.379049-1-daniel.vetter@ffwll.ch>
 <303b9f91-9214-5243-8224-a11953960839@suse.de> <CAKMK7uHH5Rw=0q-KsO_pZ54mGQAsQuiMLNepn8gviBNeVu4JKg@mail.gmail.com>
 <091e20d5-2658-c166-6d65-261716c57efa@suse.de>
In-Reply-To: <091e20d5-2658-c166-6d65-261716c57efa@suse.de>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Tue, 21 Jun 2022 12:43:11 +0200
Message-ID: <CAKMK7uEL5ne1Crhtp+L0K5+NruBUo8Wod-s9xWVZ05UREEV=rQ@mail.gmail.com>
Subject: Re: [PATCH] drm/fb-helper: Make set_var validation stricter
To:     Thomas Zimmermann <tzimmermann@suse.de>
Cc:     =?UTF-8?Q?Michel_D=C3=A4nzer?= <michel@daenzer.net>,
        security@kernel.org, Daniel Stone <daniels@collabora.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>, stable@vger.kernel.org,
        Helge Deller <deller@gmx.de>,
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

On Tue, 21 Jun 2022 at 12:33, Thomas Zimmermann <tzimmermann@suse.de> wrote=
:
>
> Hi
>
> Am 21.06.22 um 12:20 schrieb Daniel Vetter:
> > On Tue, 21 Jun 2022 at 12:15, Thomas Zimmermann <tzimmermann@suse.de> w=
rote:
> >>
> >> Hi
> >>
> >> Am 21.06.22 um 11:23 schrieb Daniel Vetter:
> >>> The drm fbdev emulation does not forward mode changes to the driver,
> >>> and hence all changes where rejected in 865afb11949e ("drm/fb-helper:
> >>> reject any changes to the fbdev").
> >>>
> >>> Unfortunately this resulted in bugs on multiple monitor systems with
> >>> different resolutions. In that case the fbdev emulation code sizes th=
e
> >>> underlying framebuffer for the largest screen (which dictates
> >>> x/yres_virtual), but adjust the fbdev x/yres to match the smallest
> >>> resolution. The above mentioned patch failed to realize that, and
> >>> errornously validated x/yres against the fb dimensions.
> >>>
> >>> This was fixed by just dropping the validation for too small sizes,
> >>> which restored vt switching with 12ffed96d436 ("drm/fb-helper: Allow
> >>> var->x/yres(_virtual) < fb->width/height again").
> >>>
> >>> But this also restored all kinds of validation issues and their
> >>> fallout in the notoriously buggy fbcon code for too small sizes. Sinc=
e
> >>> no one is volunteering to really make fbcon and vc/vt fully robust
> >>> against these math issues make sure this barn door is closed for good
> >>> again.
> >>>
> >>> Since it's a bit tricky to remember the x/yres we picked across both
> >>> the newer generic fbdev emulation and the older code with more driver
> >>> involvement, we simply check that it doesn't change. This relies on
> >>> drm_fb_helper_fill_var() having done things correctly, and nothing
> >>> having trampled it yet.
> >>>
> >>> Note that this leaves all the other fbdev drivers out in the rain.
> >>> Given that distros have finally started to move away from those
> >>> completely for real I think that's good enough. The code it spaghetti
> >>> enough that I do not feel confident to even review fixes for it.
> >>>
> >>> What might help fbdev is doing something similar to what was done in
> >>> a49145acfb97 ("fbmem: add margin check to fb_check_caps()") and ensur=
e
> >>> x/yres_virtual aren't too small, for some value of "too small". Maybe
> >>> checking that they're at least x/yres makes sense?
> >>>
> >>> Fixes: 12ffed96d436 ("drm/fb-helper: Allow var->x/yres(_virtual) < fb=
->width/height again")
> >>> Cc: Michel D=C3=A4nzer <michel.daenzer@amd.com>
> >>> Cc: Daniel Stone <daniels@collabora.com>
> >>> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> >>> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> >>> Cc: Maxime Ripard <mripard@kernel.org>
> >>> Cc: Thomas Zimmermann <tzimmermann@suse.de>
> >>> Cc: <stable@vger.kernel.org> # v4.11+
> >>> Cc: Helge Deller <deller@gmx.de>
> >>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >>> Cc: openeuler-security@openeuler.org
> >>> Cc: guodaxing@huawei.com
> >>> Cc: Weigang (Jimmy) <weigang12@huawei.com>
> >>> Reported-by: Weigang (Jimmy) <weigang12@huawei.com>
> >>> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> >>> ---
> >>> Note: Weigang asked for this to stay under embargo until it's all
> >>> review and tested.
> >>> -Daniel
> >>> ---
> >>>    drivers/gpu/drm/drm_fb_helper.c | 4 ++--
> >>>    1 file changed, 2 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb=
_helper.c
> >>> index 695997ae2a7c..5664a177a404 100644
> >>> --- a/drivers/gpu/drm/drm_fb_helper.c
> >>> +++ b/drivers/gpu/drm/drm_fb_helper.c
> >>> @@ -1355,8 +1355,8 @@ int drm_fb_helper_check_var(struct fb_var_scree=
ninfo *var,
> >>>         * to KMS, hence fail if different settings are requested.
> >>>         */
> >>>        if (var->bits_per_pixel > fb->format->cpp[0] * 8 ||
> >>> -         var->xres > fb->width || var->yres > fb->height ||
> >>> -         var->xres_virtual > fb->width || var->yres_virtual > fb->he=
ight) {
> >>> +         var->xres !=3D info->var.xres || var->yres !=3D info->var.y=
res ||
> >>
> >> This looks reasonable. We effectively only support a single resolution=
 here.
> >>
> >>> +         var->xres_virtual !=3D fb->width || var->yres_virtual !=3D =
fb->height) {
> >>
> >> AFAIU this change would require that all userspace always uses maximum
> >> values for {xres,yres}_virtual. Seems unrealistic to me.
> >
> > The thing is, they kinda have to, because that's always going to be
> > the actually visible part :-) Otoh I guess we could also allow virtual
> > size to match the fbdev real size, but maybe that kind of sanity check
> > should be done in fbmem.c?
>
> I'm not sure I understand. I'd expect that fbdev userspace allocates
> xres_virtual to be twice the size of xres. So it can do double
> buffering. In many cases fb->height would be larger than that.
>
> >
> > Tbh for these kind of things I'm leaning towards "let's wait until we
> > get a regression report", since there's simply too many random bugs
>
> Not that I disagree, but in this case a regression report seems inevitabl=
e.

Hm yeah maybe we need to allow the flexibility.

> > all over in the fbcon/vc/vt code when sou start resizing stuff. So I'm
> > very heavily leaning towards rejecting everything (and e.g. we should
> > have fixed this all up already in 2020 when the bugfix for x/yres
> > related underflows landed in 2020 imo).
>
> Do the fbdev igt tests work with this change if overalloc has been set
> to more than 200?

Hm haven't tried, but I guess I'll just cc the thing to our trybot CI.
The joys of patch testing when you can't really use any of the public
CI systems by default.
-Daniel


>
> Best regards
> Thomas
>
> > -Daniel
> >
> >> Best regards
> >> Thomas
> >>
> >>
> >>>                drm_dbg_kms(dev, "fb requested width/height/bpp can't =
fit in current fb "
> >>>                          "request %dx%d-%d (virtual %dx%d) > %dx%d-%d=
\n",
> >>>                          var->xres, var->yres, var->bits_per_pixel,
> >>
> >> --
> >> Thomas Zimmermann
> >> Graphics Driver Developer
> >> SUSE Software Solutions Germany GmbH
> >> Maxfeldstr. 5, 90409 N=C3=BCrnberg, Germany
> >> (HRB 36809, AG N=C3=BCrnberg)
> >> Gesch=C3=A4ftsf=C3=BChrer: Ivo Totev
> >
> >
> >
>
> --
> Thomas Zimmermann
> Graphics Driver Developer
> SUSE Software Solutions Germany GmbH
> Maxfeldstr. 5, 90409 N=C3=BCrnberg, Germany
> (HRB 36809, AG N=C3=BCrnberg)
> Gesch=C3=A4ftsf=C3=BChrer: Ivo Totev



--=20
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
