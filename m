Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0948552F92
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 12:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241404AbiFUKUb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 06:20:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiFUKUb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 06:20:31 -0400
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C658628706
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 03:20:29 -0700 (PDT)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-fb6b4da1dfso17778029fac.4
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 03:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Q1y5ykfuwzaIhfMftCW0ZPynnysLI/Qwn7Z8Dl6y9VY=;
        b=RnPGuAIjnlZOlpz+6FZVR4D8s2YbC6novHsOQZindmm7O+TnuORlnZkzrRwxWVfg76
         dZIYDhwL5ppox7J2C66z+lScVfnPyc3bhSLB9e9EG1TahPZuF8h5+ximupKlr1b3YwLI
         mGwcH2z35e6LB9tv83DFR9iQtBBWksH4zB1LU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Q1y5ykfuwzaIhfMftCW0ZPynnysLI/Qwn7Z8Dl6y9VY=;
        b=WIiZG2mmUCzToFTudIGPS1tv/+VqTAT1bwq/GOpXqTQ5bPI6WF+fjWzo0T+hoqxfXs
         U+C93kVTS5kvFHo3wrE1JrR2IfEdmfteRBDMBo9H/O9iy6syhaHZOMvzSVXKKjnkrw5X
         Tmst3MmH+JFF5AIbZrY3pqMzbkicAEKZ3gtmrfqMkjJ2hV6VgZcORvSBM0Fxy+RRlV81
         JRyJjHOf+nNzI/4vaxDXGuoKy2Lnb4OMJi/zbiX7F4q6WgVIEe2X4rlU4Qa8wACctgFr
         invNsTCEjJ+6yyKLV3/SoOZJJDcT/qA9i/xuP2wpZVwHH+KvdJa7+Edn+PhfFZmHXBZ+
         US6g==
X-Gm-Message-State: AJIora+DxSOZbQL3DJJV/t0K8Wf99X5ni73EAIqXawTJQsgCRaZ19IwE
        bwopB4zqJtsaXW318l90sZbFPmrFHYhJRDakjuLhxQ==
X-Google-Smtp-Source: AGRyM1uy0B57/B/o6uV+59QhaxBKSeVhCN+KL760xH3olWTL6epvRf32oj6PlISM4ckk/2W2LG5QqniQZ6lSfsFzTNM=
X-Received: by 2002:a05:6870:e98b:b0:fe:219a:2449 with SMTP id
 r11-20020a056870e98b00b000fe219a2449mr21376619oao.228.1655806829125; Tue, 21
 Jun 2022 03:20:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220621092319.379049-1-daniel.vetter@ffwll.ch> <303b9f91-9214-5243-8224-a11953960839@suse.de>
In-Reply-To: <303b9f91-9214-5243-8224-a11953960839@suse.de>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Tue, 21 Jun 2022 12:20:18 +0200
Message-ID: <CAKMK7uHH5Rw=0q-KsO_pZ54mGQAsQuiMLNepn8gviBNeVu4JKg@mail.gmail.com>
Subject: Re: [PATCH] drm/fb-helper: Make set_var validation stricter
To:     Thomas Zimmermann <tzimmermann@suse.de>,
        =?UTF-8?Q?Michel_D=C3=A4nzer?= <michel@daenzer.net>
Cc:     security@kernel.org, Daniel Stone <daniels@collabora.com>,
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

On Tue, 21 Jun 2022 at 12:15, Thomas Zimmermann <tzimmermann@suse.de> wrote=
:
>
> Hi
>
> Am 21.06.22 um 11:23 schrieb Daniel Vetter:
> > The drm fbdev emulation does not forward mode changes to the driver,
> > and hence all changes where rejected in 865afb11949e ("drm/fb-helper:
> > reject any changes to the fbdev").
> >
> > Unfortunately this resulted in bugs on multiple monitor systems with
> > different resolutions. In that case the fbdev emulation code sizes the
> > underlying framebuffer for the largest screen (which dictates
> > x/yres_virtual), but adjust the fbdev x/yres to match the smallest
> > resolution. The above mentioned patch failed to realize that, and
> > errornously validated x/yres against the fb dimensions.
> >
> > This was fixed by just dropping the validation for too small sizes,
> > which restored vt switching with 12ffed96d436 ("drm/fb-helper: Allow
> > var->x/yres(_virtual) < fb->width/height again").
> >
> > But this also restored all kinds of validation issues and their
> > fallout in the notoriously buggy fbcon code for too small sizes. Since
> > no one is volunteering to really make fbcon and vc/vt fully robust
> > against these math issues make sure this barn door is closed for good
> > again.
> >
> > Since it's a bit tricky to remember the x/yres we picked across both
> > the newer generic fbdev emulation and the older code with more driver
> > involvement, we simply check that it doesn't change. This relies on
> > drm_fb_helper_fill_var() having done things correctly, and nothing
> > having trampled it yet.
> >
> > Note that this leaves all the other fbdev drivers out in the rain.
> > Given that distros have finally started to move away from those
> > completely for real I think that's good enough. The code it spaghetti
> > enough that I do not feel confident to even review fixes for it.
> >
> > What might help fbdev is doing something similar to what was done in
> > a49145acfb97 ("fbmem: add margin check to fb_check_caps()") and ensure
> > x/yres_virtual aren't too small, for some value of "too small". Maybe
> > checking that they're at least x/yres makes sense?
> >
> > Fixes: 12ffed96d436 ("drm/fb-helper: Allow var->x/yres(_virtual) < fb->=
width/height again")
> > Cc: Michel D=C3=A4nzer <michel.daenzer@amd.com>
> > Cc: Daniel Stone <daniels@collabora.com>
> > Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> > Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> > Cc: Maxime Ripard <mripard@kernel.org>
> > Cc: Thomas Zimmermann <tzimmermann@suse.de>
> > Cc: <stable@vger.kernel.org> # v4.11+
> > Cc: Helge Deller <deller@gmx.de>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: openeuler-security@openeuler.org
> > Cc: guodaxing@huawei.com
> > Cc: Weigang (Jimmy) <weigang12@huawei.com>
> > Reported-by: Weigang (Jimmy) <weigang12@huawei.com>
> > Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> > ---
> > Note: Weigang asked for this to stay under embargo until it's all
> > review and tested.
> > -Daniel
> > ---
> >   drivers/gpu/drm/drm_fb_helper.c | 4 ++--
> >   1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_h=
elper.c
> > index 695997ae2a7c..5664a177a404 100644
> > --- a/drivers/gpu/drm/drm_fb_helper.c
> > +++ b/drivers/gpu/drm/drm_fb_helper.c
> > @@ -1355,8 +1355,8 @@ int drm_fb_helper_check_var(struct fb_var_screeni=
nfo *var,
> >        * to KMS, hence fail if different settings are requested.
> >        */
> >       if (var->bits_per_pixel > fb->format->cpp[0] * 8 ||
> > -         var->xres > fb->width || var->yres > fb->height ||
> > -         var->xres_virtual > fb->width || var->yres_virtual > fb->heig=
ht) {
> > +         var->xres !=3D info->var.xres || var->yres !=3D info->var.yre=
s ||
>
> This looks reasonable. We effectively only support a single resolution he=
re.
>
> > +         var->xres_virtual !=3D fb->width || var->yres_virtual !=3D fb=
->height) {
>
> AFAIU this change would require that all userspace always uses maximum
> values for {xres,yres}_virtual. Seems unrealistic to me.

The thing is, they kinda have to, because that's always going to be
the actually visible part :-) Otoh I guess we could also allow virtual
size to match the fbdev real size, but maybe that kind of sanity check
should be done in fbmem.c?

Tbh for these kind of things I'm leaning towards "let's wait until we
get a regression report", since there's simply too many random bugs
all over in the fbcon/vc/vt code when sou start resizing stuff. So I'm
very heavily leaning towards rejecting everything (and e.g. we should
have fixed this all up already in 2020 when the bugfix for x/yres
related underflows landed in 2020 imo).
-Daniel

> Best regards
> Thomas
>
>
> >               drm_dbg_kms(dev, "fb requested width/height/bpp can't fit=
 in current fb "
> >                         "request %dx%d-%d (virtual %dx%d) > %dx%d-%d\n"=
,
> >                         var->xres, var->yres, var->bits_per_pixel,
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
