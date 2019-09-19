Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5B9B7D7A
	for <lists+stable@lfdr.de>; Thu, 19 Sep 2019 17:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389695AbfISPED (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 11:04:03 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:43871 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389382AbfISPED (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Sep 2019 11:04:03 -0400
Received: by mail-yw1-f68.google.com with SMTP id q7so1328799ywe.10
        for <stable@vger.kernel.org>; Thu, 19 Sep 2019 08:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=poorly.run; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=y8vAVMHvzbWsdZXn87+UYmHO8hhkPrYpqOnkXz4LuK4=;
        b=Jc+Q99J7jDIc8UMXcQDlm6SXih7dlteWgLvH5grEUGae4NVRt4TvQIWgsD3ew8wd8H
         Rk0+EeCuKKC/Qe6EEteFSlaYgu7iz+WshpRtuG1Fh3erqb9ZKUyc9Zp/RHRN5qnIoKV5
         HuIBSgTygqDzLgFUN0/kARz3cOk78VT6ZxrQZGbvWVg0VXXNWRizpbOya3+bZZEY2uO6
         ezY2cFsaEvFpvsntH/WZ5Ep7CKukH+NjSh8eLtJ0teknFJ4ruievQWT1+llnlhmK6+FA
         ZOHgvvvaRGXEXUk1GAqJOskx6dzTUJCA4Nje7xulbHB8kwl3dQhhbUfEMpAlqmrGIO7s
         HJOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=y8vAVMHvzbWsdZXn87+UYmHO8hhkPrYpqOnkXz4LuK4=;
        b=Ud5IulIi1k2CxqxGHoe7bs5v/DeCxYoMvrr+igiJOdfrcNArRrkEiVCv0HlWBF5NmC
         VUcID2G5y/CBgLqSlsQXbECKBHjvLwGlGoyux+sv7XzEoYSzT9CPQQ86Babmj3rkrKOG
         GEBhlaMwIPx3V5lGF0Nh0u/1i/laaK42I7TFKk9gn41aaEY4GXnhjVf4BWy8lu5q/sSM
         3Wv5JcRt8y5jL0Ag6g4U8UZ2qkSFVG1VG6upfX7yKcQiRDL/TlmiMi9sSjjsxJqj9iw/
         /Pea7N/XqksfJqFbtmV5Mf9h14NCUktPX+6EHsyHOIRJHAVudy/lq4leBTv3E82+EdTU
         Jbew==
X-Gm-Message-State: APjAAAVetK06RTUij/uVvpnhu80m6D07mZJpN1MLLGr4fkU6N5CzGwQY
        rWRkmE4pXefzhnNpsjm+e9KaEA==
X-Google-Smtp-Source: APXvYqwx9wl4Q0hspgID6pNeOiMOJiNK3Q7E3XtH1k1AlBb6iwVW+mou23+ZcKZPPoCGDVoNKH2iBQ==
X-Received: by 2002:a81:7dc5:: with SMTP id y188mr7915294ywc.69.1568905442311;
        Thu, 19 Sep 2019 08:04:02 -0700 (PDT)
Received: from localhost ([2620:0:1013:11:89c6:2139:5435:371d])
        by smtp.gmail.com with ESMTPSA id d63sm1921007ywe.55.2019.09.19.08.04.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Sep 2019 08:04:01 -0700 (PDT)
Date:   Thu, 19 Sep 2019 11:04:01 -0400
From:   Sean Paul <sean@poorly.run>
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     Sean Paul <sean@poorly.run>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Sean Paul <seanpaul@chromium.org>,
        Rob Clark <robdclark@gmail.com>,
        Deepak Rawat <drawat@vmware.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        David Airlie <airlied@linux.ie>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] drm: damage_helper: Fix race checking plane->state->fb
Message-ID: <20190919150401.GV218215@art_vandelay>
References: <20190904202938.110207-1-sean@poorly.run>
 <CAKMK7uFtcmZd9+wARmYuZwtimUV91fiFXNmr5Nuk4Z65QjHyuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uFtcmZd9+wARmYuZwtimUV91fiFXNmr5Nuk4Z65QjHyuA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 05, 2019 at 12:41:27PM +0200, Daniel Vetter wrote:
> On Wed, Sep 4, 2019 at 10:29 PM Sean Paul <sean@poorly.run> wrote:
> >
> > From: Sean Paul <seanpaul@chromium.org>
> >
> > Since the dirtyfb ioctl doesn't give us any hints as to which plane is
> > scanning out the fb it's marking as damaged, we need to loop through
> > planes to find it.
> >
> > Currently we just reach into plane state and check, but that can race
> > with another commit changing the fb out from under us. This patch locks
> > the plane before checking the fb and will release the lock if the plane
> > is not displaying the dirty fb.
> >
> > Fixes: b9fc5e01d1ce ("drm: Add helper to implement legacy dirtyfb")
> > Cc: Rob Clark <robdclark@gmail.com>
> > Cc: Deepak Rawat <drawat@vmware.com>
> > Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> > Cc: Thomas Hellstrom <thellstrom@vmware.com>
> > Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> > Cc: Maxime Ripard <maxime.ripard@bootlin.com>
> > Cc: Sean Paul <sean@poorly.run>
> > Cc: David Airlie <airlied@linux.ie>
> > Cc: Daniel Vetter <daniel@ffwll.ch>
> > Cc: dri-devel@lists.freedesktop.org
> > Cc: <stable@vger.kernel.org> # v5.0+
> > Reported-by: Daniel Vetter <daniel@ffwll.ch>
> > Signed-off-by: Sean Paul <seanpaul@chromium.org>
> > ---
> >  drivers/gpu/drm/drm_damage_helper.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/gpu/drm/drm_damage_helper.c b/drivers/gpu/drm/drm_damage_helper.c
> > index 8230dac01a89..3a4126dc2520 100644
> > --- a/drivers/gpu/drm/drm_damage_helper.c
> > +++ b/drivers/gpu/drm/drm_damage_helper.c
> > @@ -212,8 +212,14 @@ int drm_atomic_helper_dirtyfb(struct drm_framebuffer *fb,
> >         drm_for_each_plane(plane, fb->dev) {
> >                 struct drm_plane_state *plane_state;
> >
> > -               if (plane->state->fb != fb)
> > +               ret = drm_modeset_lock(&plane->mutex, state->acquire_ctx);
> > +               if (ret)
> 
> I think for paranoid safety we should have a WARN_ON(ret == -EALREADY)
> here. It should be impossible, but if it's not for some oddball
> reason, we'll blow up.

drm_modeset_lock eats EALREADY and returns 0 for that case, so I guess it
depends _how_ paranoid you want to be here :-)

> 
> With that: Reviewed-by: Daniel Vetter <daniel@ffwll.ch>
> 
> But please give this a spin with some workloads and the ww_mutex
> slowpath debugging enabled, just to makre sure.

Ok, had a chance to run through some tests this morning with
CONFIG_DEBUG_WW_MUTEX_SLOWPATH and things lgtm

Sean

> -Daniel
> 
> > +                       goto out;
> > +
> > +               if (plane->state->fb != fb) {
> > +                       drm_modeset_unlock(&plane->mutex);
> >                         continue;
> > +               }
> >
> >                 plane_state = drm_atomic_get_plane_state(state, plane);
> >                 if (IS_ERR(plane_state)) {
> > --
> > Sean Paul, Software Engineer, Google / Chromium OS
> >
> 
> 
> -- 
> Daniel Vetter
> Software Engineer, Intel Corporation
> +41 (0) 79 365 57 48 - http://blog.ffwll.ch

-- 
Sean Paul, Software Engineer, Google / Chromium OS
