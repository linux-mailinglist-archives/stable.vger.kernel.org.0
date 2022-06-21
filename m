Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CED0553667
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 17:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353005AbiFUPlF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 11:41:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353108AbiFUPk7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 11:40:59 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30B6B2CDDA
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 08:40:56 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id v4so17559457oiv.1
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 08:40:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=iPWlvVJb996j+OYToIXWPF9elFevyeXAwJfgAksV1b0=;
        b=WmNpBsxCYq6mJQcqRZde2ZouluEr+ctT7EjB6NWzf33sUd7lESQEVmeki9hDz6A7g0
         lNMK/iH7pIWlxfcsKhQDrLOizOhkFqDCQmTL2g+xbwP62sViFn6EmBxFbTIZGeKi1NIP
         fFd0tIC8TdhqnZfE18EqZ1WrjCXGY4+Q7luTs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=iPWlvVJb996j+OYToIXWPF9elFevyeXAwJfgAksV1b0=;
        b=aFOQEqqqkAh8/GuwSQhOTI4GpNKOWO3fwlDxbTyCwyb2oqD/wkARcbldRL6KveUGoI
         Fgg5fHusCxjjUJySAUSJHH4RkKvqMRKDIWvjKZyUHA317r37xQu7iXZP5E1ZUL1nY/vt
         Ha3FET/tTig2r8vNSv63rZKIvk4Bft7TkPKGVAZGVq/cBoOm13GJlzUcEnqCfuxkSekL
         BdQebpGZswFueNzvktPn6eSpTctOp4rH1mETt767+c3elgcRRR0LY2pXX/eu+RiGfakE
         iXlCvPVyfVvGoYTmXNyQdPKmEoGeKijK2X5pKT+wVecU5hRkFULDOOFYr9OY0bsdB2Cq
         vv2Q==
X-Gm-Message-State: AOAM532TfAFhrIagx8oeEvSdlYBYmS4my6/YWDwxu0H3S8Fb3lW6GSjz
        NBlbT9OvrDLG6AP6NtEn/kF97AL8OH9sYTxSUB5FJQ==
X-Google-Smtp-Source: ABdhPJxZStVpFnLMHiSu26lw4bjgMmQWpCkg8Sv363XqHD0/Ksp19trO0HxM5857IbdyZUNMlGMnlNWi0Zc7sIGTSR0=
X-Received: by 2002:aca:aad5:0:b0:32f:3b9b:e0f with SMTP id
 t204-20020acaaad5000000b0032f3b9b0e0fmr20043516oie.228.1655826055456; Tue, 21
 Jun 2022 08:40:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220621092319.379049-1-daniel.vetter@ffwll.ch>
 <8701b28a-fb86-c95f-6a3e-ddea9cd10b97@gmx.de> <CAKMK7uG3DxXx067oxHTphRjoi34AA=C9YenV3gJT_T+Vo9MOFA@mail.gmail.com>
In-Reply-To: <CAKMK7uG3DxXx067oxHTphRjoi34AA=C9YenV3gJT_T+Vo9MOFA@mail.gmail.com>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Tue, 21 Jun 2022 17:40:44 +0200
Message-ID: <CAKMK7uEOBb2ebFAvAvTk2bJdAHw07bQxezSdVOJS1=odg+zbDg@mail.gmail.com>
Subject: Re: [PATCH] drm/fb-helper: Make set_var validation stricter
To:     Helge Deller <deller@gmx.de>,
        =?UTF-8?Q?Michel_D=C3=A4nzer?= <michel@daenzer.net>
Cc:     security@kernel.org, Daniel Stone <daniels@collabora.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        stable@vger.kernel.org,
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

On Tue, 21 Jun 2022 at 17:37, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
>
> On Tue, 21 Jun 2022 at 16:57, Helge Deller <deller@gmx.de> wrote:
> >
> > On 6/21/22 11:23, Daniel Vetter wrote:
> > > The drm fbdev emulation does not forward mode changes to the driver,
> > > and hence all changes where rejected in 865afb11949e ("drm/fb-helper:
> > > reject any changes to the fbdev").
> > >
> > > Unfortunately this resulted in bugs on multiple monitor systems with
> > > different resolutions. In that case the fbdev emulation code sizes th=
e
> > > underlying framebuffer for the largest screen (which dictates
> > > x/yres_virtual), but adjust the fbdev x/yres to match the smallest
> > > resolution. The above mentioned patch failed to realize that, and
> > > errornously validated x/yres against the fb dimensions.
> > >
> > > This was fixed by just dropping the validation for too small sizes,
> > > which restored vt switching with 12ffed96d436 ("drm/fb-helper: Allow
> > > var->x/yres(_virtual) < fb->width/height again").
> > >
> > > But this also restored all kinds of validation issues and their
> > > fallout in the notoriously buggy fbcon code for too small sizes. Sinc=
e
> > > no one is volunteering to really make fbcon and vc/vt fully robust
> > > against these math issues make sure this barn door is closed for good
> > > again.
> >
> > I don't understand why you are blaming fbcon here (again)...
> >
> > The real problem is that user-provided input (virt/physical screen size=
s)
> > isn't correctly validated.
> > And that's even what your patch below does.
>
> I don't want to play whack-a-mole in here. And what I tried to do here
> (but oh well, too many things would break) is outright disallow any
> changes, not just try to validate (and probably in vain) that the
> changes look decent. Because making stuff invariant also solves all
> the locking fun. And sure even then we could have bugs that break
> stuff, but since everything would be invariant people would notice
> when booting, instead of trying to hit corner cases using syzkaller
> for stuff that mostly only syzkaller exercises.
>
> And I'm pretty sure syzkaller isn't good enough to really hit
> concurrency issues, it has a pretty hard time just finding basic
> validation bugs like this.

Like I'm pretty sure if you make the font big enough and yres small
enough this can all blow up right away again, but I also really don't
want to find out.

And once you fix that you get to fix the races of changing fonts
through vt against changing resolution through fbdev ioctls, and at
that point you have a neat locking problem to solve.
-Daniel

> > Helge
> >
> > > Since it's a bit tricky to remember the x/yres we picked across both
> > > the newer generic fbdev emulation and the older code with more driver
> > > involvement, we simply check that it doesn't change. This relies on
> > > drm_fb_helper_fill_var() having done things correctly, and nothing
> > > having trampled it yet.
> > >
> > > Note that this leaves all the other fbdev drivers out in the rain.
> > > Given that distros have finally started to move away from those
> > > completely for real I think that's good enough. The code it spaghetti
> > > enough that I do not feel confident to even review fixes for it.
> > >
> > > What might help fbdev is doing something similar to what was done in
> > > a49145acfb97 ("fbmem: add margin check to fb_check_caps()") and ensur=
e
> > > x/yres_virtual aren't too small, for some value of "too small". Maybe
> > > checking that they're at least x/yres makes sense?
> > >
> > > Fixes: 12ffed96d436 ("drm/fb-helper: Allow var->x/yres(_virtual) < fb=
->width/height again")
> > > Cc: Michel D=C3=A4nzer <michel.daenzer@amd.com>
> > > Cc: Daniel Stone <daniels@collabora.com>
> > > Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> > > Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> > > Cc: Maxime Ripard <mripard@kernel.org>
> > > Cc: Thomas Zimmermann <tzimmermann@suse.de>
> > > Cc: <stable@vger.kernel.org> # v4.11+
> > > Cc: Helge Deller <deller@gmx.de>
> > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Cc: openeuler-security@openeuler.org
> > > Cc: guodaxing@huawei.com
> > > Cc: Weigang (Jimmy) <weigang12@huawei.com>
> > > Reported-by: Weigang (Jimmy) <weigang12@huawei.com>
> > > Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> > > ---
> > > Note: Weigang asked for this to stay under embargo until it's all
> > > review and tested.
> > > -Daniel
> > > ---
> > >  drivers/gpu/drm/drm_fb_helper.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb=
_helper.c
> > > index 695997ae2a7c..5664a177a404 100644
> > > --- a/drivers/gpu/drm/drm_fb_helper.c
> > > +++ b/drivers/gpu/drm/drm_fb_helper.c
> > > @@ -1355,8 +1355,8 @@ int drm_fb_helper_check_var(struct fb_var_scree=
ninfo *var,
> > >        * to KMS, hence fail if different settings are requested.
> > >        */
> > >       if (var->bits_per_pixel > fb->format->cpp[0] * 8 ||
> > > -         var->xres > fb->width || var->yres > fb->height ||
> > > -         var->xres_virtual > fb->width || var->yres_virtual > fb->he=
ight) {
> > > +         var->xres !=3D info->var.xres || var->yres !=3D info->var.y=
res ||
> > > +         var->xres_virtual !=3D fb->width || var->yres_virtual !=3D =
fb->height) {
> > >               drm_dbg_kms(dev, "fb requested width/height/bpp can't f=
it in current fb "
> > >                         "request %dx%d-%d (virtual %dx%d) > %dx%d-%d\=
n",
> > >                         var->xres, var->yres, var->bits_per_pixel,
> >
>
>
> --
> Daniel Vetter
> Software Engineer, Intel Corporation
> http://blog.ffwll.ch



--=20
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
