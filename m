Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0214A5A1F
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 11:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236696AbiBAKg5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 05:36:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236708AbiBAKg5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 05:36:57 -0500
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E911AC061401
        for <stable@vger.kernel.org>; Tue,  1 Feb 2022 02:36:56 -0800 (PST)
Received: by mail-oi1-x233.google.com with SMTP id 4so7912964oil.11
        for <stable@vger.kernel.org>; Tue, 01 Feb 2022 02:36:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=thQSKAMpg3vonVejk+upRRfxFVRMJlvDC8QT1+vvLTE=;
        b=BjysRH1/UjWKl4SwTWns+a3iySdYESImlXYI7dzIfcW5U3YKan1zfT4PIm9Yg1CO+i
         UeBzRv66NeNKkAxDGEvzfZAO0hDDWZu37G4sPsJ0qidfgez8DuvVdkYwSyJc/ruD4Unm
         v10dtEg3+JZQA08R+oq5qhyMzzEa33iBiE/uo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=thQSKAMpg3vonVejk+upRRfxFVRMJlvDC8QT1+vvLTE=;
        b=HXcIY+DIj6z8MMpSXAyT02HT0ASPGB8jYU7STyD9hTlMINxScnQba7NShaYFjiArDu
         JUd5j+2G239BBF9KUCiST/ePZJZ98Nv2my0gcGLHapSmlnsXOmtogzf0D+Hv0bDxtbbY
         SLA9Uxgr4jA3benqmsumhhD2BukwOFylDhYoOX+0mjj8PELLlZEr6LovhJ1eVnry3dum
         PgOBzm44DkrlVwblvtilx2jO0xMXiooyW0bBGvrv5msKJzkeEvggysoDr6zy2hjF5d5X
         0dUq14q3UvLUBJSfRCRUMwcjqWtxC9lOn9PSUfx+5J1RO4HQaGIETSjKMzZsycSWLp+G
         awzA==
X-Gm-Message-State: AOAM530JYs7GkoadnSMTjeeykVD311deOSO1oE8wHJ+r9WldEiM9hR8X
        gVRVP6J4dI8xWSxn3U/pZqZjlGhh5eKhYuJibj+tWw==
X-Google-Smtp-Source: ABdhPJyRYjaTjIpRbmzrzjkG0kQCosoH7kxsVtTm5JDqQlhuefr1UAJQF2kq5O9RD6DgxMJ94sRyCMJm8h5u3PghwEM=
X-Received: by 2002:a54:4803:: with SMTP id j3mr745297oij.279.1643711816234;
 Tue, 01 Feb 2022 02:36:56 -0800 (PST)
MIME-Version: 1.0
References: <20220131210552.482606-1-daniel.vetter@ffwll.ch>
 <20220131210552.482606-4-daniel.vetter@ffwll.ch> <9c22b709-cbcf-6a29-a45e-5a57ba0b9c14@gmx.de>
In-Reply-To: <9c22b709-cbcf-6a29-a45e-5a57ba0b9c14@gmx.de>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Tue, 1 Feb 2022 11:36:44 +0100
Message-ID: <CAKMK7uGvOVe8kkJCTkQBEFw+3i2iAMANsyG9vGqZkcROZ9he4A@mail.gmail.com>
Subject: Re: [PATCH 03/21] fbcon: Restore fbcon scrolling acceleration
To:     Helge Deller <deller@gmx.de>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        linux-fbdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Claudio Suarez <cssk@net-c.es>,
        Dave Airlie <airlied@gmail.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Pavel Machek <pavel@ucw.cz>, Sam Ravnborg <sam@ravnborg.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Sven Schnelle <svens@stackframe.org>,
        Gerd Hoffmann <kraxel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 1, 2022 at 11:16 AM Helge Deller <deller@gmx.de> wrote:
>
> On 1/31/22 22:05, Daniel Vetter wrote:
> > This functionally undoes 39aead8373b3 ("fbcon: Disable accelerated
> > scrolling"), but behind the FRAMEBUFFER_CONSOLE_LEGACY_ACCELERATION
> > option.
>
> you have two trivial copy-n-paste errors in this patch which still prevent the
> console acceleration.

Duh :-(

But before we dig into details I think the big picture would be
better. I honestly don't like the #ifdef pile here that much. I wonder
whether your approach, also with GETVX/YRES adjusted somehow, wouldn't
look cleaner? Like I said in the cover letter I got mostly distracted
with fbcon locking last week, not really with this one here at all, so
maybe going with your 4 (or 2 if we squash them like I did here)
patches is neater?

Cheers, Daniel

>
> > diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
> > index 2ff90061c7f3..39dc18a5de86 100644
> > --- a/drivers/video/fbdev/core/fbcon.c
> > +++ b/drivers/video/fbdev/core/fbcon.c
> > @@ -1125,13 +1125,15 @@ static void fbcon_init(struct vc_data *vc, int init)
> >
> >       ops->graphics = 0;
> >
> > -     /*
> > -      * No more hw acceleration for fbcon.
> > -      *
> > -      * FIXME: Garbage collect all the now dead code after sufficient time
> > -      * has passed.
> > -      */
> > +#ifdef CONFIG_FRAMEBUFFER_CONSOLE_ROTATION
>
> should be:
> #ifdef CONFIG_FRAMEBUFFER_CONSOLE_LEGACY_ACCELERATION
>
>
> > +     if ((info->flags & FBINFO_HWACCEL_COPYAREA) &&
> > +         !(info->flags & FBINFO_HWACCEL_DISABLED))
> > +             p->scrollmode = SCROLL_MOVE;
> > +     else /* default to something safe */
> > +             p->scrollmode = SCROLL_REDRAW;
> > +#else
> >       p->scrollmode = SCROLL_REDRAW;
> > +#endif
> >
> >       /*
> >        *  ++guenther: console.c:vc_allocate() relies on initializing
> > @@ -1971,15 +1973,49 @@ static void updatescrollmode(struct fbcon_display *p,
> >  {
> >       struct fbcon_ops *ops = info->fbcon_par;
> >       int fh = vc->vc_font.height;
> > +     int cap = info->flags;
> > +     u16 t = 0;
> > +     int ypan = FBCON_SWAP(ops->rotate, info->fix.ypanstep,
> > +                           info->fix.xpanstep);
> > +     int ywrap = FBCON_SWAP(ops->rotate, info->fix.ywrapstep, t);
> >       int yres = FBCON_SWAP(ops->rotate, info->var.yres, info->var.xres);
> >       int vyres = FBCON_SWAP(ops->rotate, info->var.yres_virtual,
> >                                  info->var.xres_virtual);
> > +     int good_pan = (cap & FBINFO_HWACCEL_YPAN) &&
> > +             divides(ypan, vc->vc_font.height) && vyres > yres;
> > +     int good_wrap = (cap & FBINFO_HWACCEL_YWRAP) &&
> > +             divides(ywrap, vc->vc_font.height) &&
> > +             divides(vc->vc_font.height, vyres) &&
> > +             divides(vc->vc_font.height, yres);
> > +     int reading_fast = cap & FBINFO_READS_FAST;
> > +     int fast_copyarea = (cap & FBINFO_HWACCEL_COPYAREA) &&
> > +             !(cap & FBINFO_HWACCEL_DISABLED);
> > +     int fast_imageblit = (cap & FBINFO_HWACCEL_IMAGEBLIT) &&
> > +             !(cap & FBINFO_HWACCEL_DISABLED);
> >
> >       p->vrows = vyres/fh;
> >       if (yres > (fh * (vc->vc_rows + 1)))
> >               p->vrows -= (yres - (fh * vc->vc_rows)) / fh;
> >       if ((yres % fh) && (vyres % fh < yres % fh))
> >               p->vrows--;
> > +
> > +     if (good_wrap || good_pan) {
> > +             if (reading_fast || fast_copyarea)
> > +                     p->scrollmode = good_wrap ?
> > +                             SCROLL_WRAP_MOVE : SCROLL_PAN_MOVE;
> > +             else
> > +                     p->scrollmode = good_wrap ? SCROLL_REDRAW :
> > +                             SCROLL_PAN_REDRAW;
> > +     } else {
> > +             if (reading_fast || (fast_copyarea && !fast_imageblit))
> > +                     p->scrollmode = SCROLL_MOVE;
> > +             else
> > +                     p->scrollmode = SCROLL_REDRAW;
> > +     }
> > +
> > +#ifndef CONFIG_FRAMEBUFFER_CONSOLE_ROTATION
>
> same here... it needs to be:
> #ifdef CONFIG_FRAMEBUFFER_CONSOLE_LEGACY_ACCELERATION
>
>
> > +     p->scrollmode = SCROLL_REDRAW;
> > +#endif
> >  }
> >
> >  #define PITCH(w) (((w) + 7) >> 3)
> >
>
> still reviewing the other patches...
>
> Helge



-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
