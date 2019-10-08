Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB1B0CF66D
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 11:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730016AbfJHJui (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 05:50:38 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:38984 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729767AbfJHJui (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 05:50:38 -0400
Received: by mail-ed1-f67.google.com with SMTP id a15so15054682edt.6
        for <stable@vger.kernel.org>; Tue, 08 Oct 2019 02:50:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=C4Sn2LyTGlsGA19K26hSD7gSL0yhfZTsKXwzGWxidOw=;
        b=DW6ATx9ATvHpBqVvlwMJuJiWB00Uw5JjA9VYNxubhAgGgspFlOt1NGoOVa4KAo+Akx
         nNkHCmpKTYDs/3vdAGM3N8RjTbP1NEYcQbFFj7QwelsUvmRujWeoYiMKIhxmMoOlmFsf
         WdXt3TRnRF7EUMcnuCE477xZrUNKpuQ7tC8CE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=C4Sn2LyTGlsGA19K26hSD7gSL0yhfZTsKXwzGWxidOw=;
        b=filnKtwsr2iDJuqHSHckep1LvZOLqkhp3GNu7ff2GUFLDdGXZC0qmI+r8mjY67omHm
         coQhACFJ342my57BimIMyAsuKMnMd+Mqq2/85+aMgMahLN8TX9yv6skufZgGi7bAyvew
         iDTjSL/7A1oeBx1ksC6qWCymmdZ2dPlJnk11RiZ+VE+mtIfvmQFh7LR+lU50B6sYwMy/
         lXRm/Vhmoz33oHYRjv20LgVJale3+uVvvsy1k39KIx66tLDcZJiVqfKIXdpckG3lKvNn
         BAKrATmaaQ6O+NIR4cYAneNHoR/FfEY6jJjjLMrun8XM1NEKiv5NJIdk/QeqvMmsEwqB
         yRxw==
X-Gm-Message-State: APjAAAWdBfvS/wCvLo5WVjUjGMlBs6U+sce0xRL9AQb2pgIP0roYwTxD
        edKtApkv39+PNd7Vn4Vs16LY6g==
X-Google-Smtp-Source: APXvYqxxwv46wDv4YrMe44eoYLbxRseBlpH5ESo6wGFdIoZLrUKolDk67i7SfrnrJf5KjiCdasDY0g==
X-Received: by 2002:a50:a0e2:: with SMTP id 89mr32578116edo.118.1570528236671;
        Tue, 08 Oct 2019 02:50:36 -0700 (PDT)
Received: from phenom.ffwll.local (212-51-149-96.fiber7.init7.net. [212.51.149.96])
        by smtp.gmail.com with ESMTPSA id f36sm3799428ede.28.2019.10.08.02.50.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 02:50:35 -0700 (PDT)
Date:   Tue, 8 Oct 2019 11:50:33 +0200
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Sean Paul <sean@poorly.run>
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
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
Message-ID: <20191008095033.GJ16989@phenom.ffwll.local>
References: <20190904202938.110207-1-sean@poorly.run>
 <CAKMK7uFtcmZd9+wARmYuZwtimUV91fiFXNmr5Nuk4Z65QjHyuA@mail.gmail.com>
 <20190919150401.GV218215@art_vandelay>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190919150401.GV218215@art_vandelay>
X-Operating-System: Linux phenom 5.2.0-2-amd64 
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 19, 2019 at 11:04:01AM -0400, Sean Paul wrote:
> On Thu, Sep 05, 2019 at 12:41:27PM +0200, Daniel Vetter wrote:
> > On Wed, Sep 4, 2019 at 10:29 PM Sean Paul <sean@poorly.run> wrote:
> > >
> > > From: Sean Paul <seanpaul@chromium.org>
> > >
> > > Since the dirtyfb ioctl doesn't give us any hints as to which plane is
> > > scanning out the fb it's marking as damaged, we need to loop through
> > > planes to find it.
> > >
> > > Currently we just reach into plane state and check, but that can race
> > > with another commit changing the fb out from under us. This patch locks
> > > the plane before checking the fb and will release the lock if the plane
> > > is not displaying the dirty fb.
> > >
> > > Fixes: b9fc5e01d1ce ("drm: Add helper to implement legacy dirtyfb")
> > > Cc: Rob Clark <robdclark@gmail.com>
> > > Cc: Deepak Rawat <drawat@vmware.com>
> > > Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> > > Cc: Thomas Hellstrom <thellstrom@vmware.com>
> > > Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> > > Cc: Maxime Ripard <maxime.ripard@bootlin.com>
> > > Cc: Sean Paul <sean@poorly.run>
> > > Cc: David Airlie <airlied@linux.ie>
> > > Cc: Daniel Vetter <daniel@ffwll.ch>
> > > Cc: dri-devel@lists.freedesktop.org
> > > Cc: <stable@vger.kernel.org> # v5.0+
> > > Reported-by: Daniel Vetter <daniel@ffwll.ch>
> > > Signed-off-by: Sean Paul <seanpaul@chromium.org>
> > > ---
> > >  drivers/gpu/drm/drm_damage_helper.c | 8 +++++++-
> > >  1 file changed, 7 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/gpu/drm/drm_damage_helper.c b/drivers/gpu/drm/drm_damage_helper.c
> > > index 8230dac01a89..3a4126dc2520 100644
> > > --- a/drivers/gpu/drm/drm_damage_helper.c
> > > +++ b/drivers/gpu/drm/drm_damage_helper.c
> > > @@ -212,8 +212,14 @@ int drm_atomic_helper_dirtyfb(struct drm_framebuffer *fb,
> > >         drm_for_each_plane(plane, fb->dev) {
> > >                 struct drm_plane_state *plane_state;
> > >
> > > -               if (plane->state->fb != fb)
> > > +               ret = drm_modeset_lock(&plane->mutex, state->acquire_ctx);
> > > +               if (ret)
> > 
> > I think for paranoid safety we should have a WARN_ON(ret == -EALREADY)
> > here. It should be impossible, but if it's not for some oddball
> > reason, we'll blow up.
> 
> drm_modeset_lock eats EALREADY and returns 0 for that case, so I guess it
> depends _how_ paranoid you want to be here :-)

Ah silly me, r-b as-is then.
-Daniel

> 
> > 
> > With that: Reviewed-by: Daniel Vetter <daniel@ffwll.ch>
> > 
> > But please give this a spin with some workloads and the ww_mutex
> > slowpath debugging enabled, just to makre sure.
> 
> Ok, had a chance to run through some tests this morning with
> CONFIG_DEBUG_WW_MUTEX_SLOWPATH and things lgtm
> 
> Sean
> 
> > -Daniel
> > 
> > > +                       goto out;
> > > +
> > > +               if (plane->state->fb != fb) {
> > > +                       drm_modeset_unlock(&plane->mutex);
> > >                         continue;
> > > +               }
> > >
> > >                 plane_state = drm_atomic_get_plane_state(state, plane);
> > >                 if (IS_ERR(plane_state)) {
> > > --
> > > Sean Paul, Software Engineer, Google / Chromium OS
> > >
> > 
> > 
> > -- 
> > Daniel Vetter
> > Software Engineer, Intel Corporation
> > +41 (0) 79 365 57 48 - http://blog.ffwll.ch
> 
> -- 
> Sean Paul, Software Engineer, Google / Chromium OS

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
