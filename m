Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0484555363B
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 17:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351597AbiFUPh6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 11:37:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352741AbiFUPhj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 11:37:39 -0400
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BBA72AC5F
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 08:37:38 -0700 (PDT)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-101d2e81bceso10031116fac.0
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 08:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1hsFe+lmUa/9RV5YTCwkhmBLS1dKqbvQQjZx9G+nizk=;
        b=QxjnxuE7/UUXBX8eR/y5eq0TCGY4lWSQl1JIoYIjqmXgw8ZCM5sx3p6unNeDitKxGt
         IWIWByONfgFvgDNKq9DMitCSt1SA/38hP6NyEDKaz9xFLtzXr3IOopkCyM7Sp5/J22wL
         wnVYhOeWf195UVEeZl4/uywJdOmQ1QEtO0wFo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1hsFe+lmUa/9RV5YTCwkhmBLS1dKqbvQQjZx9G+nizk=;
        b=Wvx8478YeCN+sf5pa1gAf64VHrHoOcNnjbce0OzKG559RJdK1OhWmdxptNpIypPG5V
         v5I/9+RLYZ7eD18zs+IH9dhSiQirxLLvgwFT+v8W8HDxhMMLk8wEIAigKCLu40XUwBB1
         MfymFg1CamqTak8QmY5hj1DoJGand7ZkoabylSm78ojuRGXe79aq/irMSjem5Udfu6+Q
         kxOqG8V0EU6o4x3JJ/lZrFufxx2cCHR10KbJe4+M2X/WErC3Ts0meJpI755CzsjzHL/i
         4m9D6AScVhsHtgOeLHgNBhNCYW7caVKAQgi4cL3TtHxhWbpXV78DBCb270rIl14IlmYE
         Qimg==
X-Gm-Message-State: AJIora/K3YiulYBtwX4PV2f2xm2vEIl0SD2Ch6LpIK+a1jdid9xhBW/L
        MzUmZ1+O75croQvgdnvttcHUjPYZM/tTZnLBcvGoHw==
X-Google-Smtp-Source: AGRyM1vjW1d0pv/HWnWQQutlnH2/U32yFYsLteL91Y4s7T1sq+zyauQBb6ArpXrM9HQ07CPL91isBdXE3hiPltJ8RK0=
X-Received: by 2002:a05:6870:e98b:b0:fe:219a:2449 with SMTP id
 r11-20020a056870e98b00b000fe219a2449mr22258279oao.228.1655825857022; Tue, 21
 Jun 2022 08:37:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220621092319.379049-1-daniel.vetter@ffwll.ch> <8701b28a-fb86-c95f-6a3e-ddea9cd10b97@gmx.de>
In-Reply-To: <8701b28a-fb86-c95f-6a3e-ddea9cd10b97@gmx.de>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Tue, 21 Jun 2022 17:37:25 +0200
Message-ID: <CAKMK7uG3DxXx067oxHTphRjoi34AA=C9YenV3gJT_T+Vo9MOFA@mail.gmail.com>
Subject: Re: [PATCH] drm/fb-helper: Make set_var validation stricter
To:     Helge Deller <deller@gmx.de>
Cc:     security@kernel.org,
        =?UTF-8?Q?Michel_D=C3=A4nzer?= <michel.daenzer@amd.com>,
        Daniel Stone <daniels@collabora.com>,
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

On Tue, 21 Jun 2022 at 16:57, Helge Deller <deller@gmx.de> wrote:
>
> On 6/21/22 11:23, Daniel Vetter wrote:
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
>
> I don't understand why you are blaming fbcon here (again)...
>
> The real problem is that user-provided input (virt/physical screen sizes)
> isn't correctly validated.
> And that's even what your patch below does.

I don't want to play whack-a-mole in here. And what I tried to do here
(but oh well, too many things would break) is outright disallow any
changes, not just try to validate (and probably in vain) that the
changes look decent. Because making stuff invariant also solves all
the locking fun. And sure even then we could have bugs that break
stuff, but since everything would be invariant people would notice
when booting, instead of trying to hit corner cases using syzkaller
for stuff that mostly only syzkaller exercises.

And I'm pretty sure syzkaller isn't good enough to really hit
concurrency issues, it has a pretty hard time just finding basic
validation bugs like this.
-Daniel

> Helge
>
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
> >  drivers/gpu/drm/drm_fb_helper.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
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
> > +         var->xres_virtual !=3D fb->width || var->yres_virtual !=3D fb=
->height) {
> >               drm_dbg_kms(dev, "fb requested width/height/bpp can't fit=
 in current fb "
> >                         "request %dx%d-%d (virtual %dx%d) > %dx%d-%d\n"=
,
> >                         var->xres, var->yres, var->bits_per_pixel,
>


--=20
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
