Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7917CFBC4
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 16:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbfJHOAI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 10:00:08 -0400
Received: from mail-yw1-f66.google.com ([209.85.161.66]:41746 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbfJHOAI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 10:00:08 -0400
Received: by mail-yw1-f66.google.com with SMTP id 129so6446013ywb.8
        for <stable@vger.kernel.org>; Tue, 08 Oct 2019 07:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=poorly.run; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Cz5Xg/kziLDSnYYuVfabzBlkCNoveK9uLSfeq/wW9Uo=;
        b=AlhC/2ccACx825p479ug41jCrYtcng14X8Qn9L3NC1eKvSaIkhK3XB2J0NmRTFwjub
         PRiE+dTbjtdAKZjCe/nOEIKU62VNUC2+X4SMXM8qz7eaonSMcPIeqQw7Bjbk4AaJg637
         vEdmoKVvnPS2YruyMSGRz3sST1qjgLkTjQlP+PXPuIOi2Sf7FKWbE8+FzDpuqDF1KyAi
         w63RZTtHuaC5ACwq1q2oDNzAW3jDBQlgbwDkhxowQeKCGNhRb5cRzTXPO9xad5yW8/pc
         BedANZcTwU/wvgYxV9XI/7c67VjNiF16K+jxfR+QucLSikNGMLqd89qzzThY6GfvlLTR
         m7PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Cz5Xg/kziLDSnYYuVfabzBlkCNoveK9uLSfeq/wW9Uo=;
        b=ktro94uf+ZkUdz0VM0mDs+sOaaiJ+EpWGgrqtpvs7JgGO+0SPPa2q8MGVssrjJ8xuc
         yla84B7uVeycL1g28xbqiEJGaa8zQrDWcnd/w3aH0YGKeVXzf9aGWJAsyaqkrEX3/U72
         Cj1pmbkhpNyEilAQGwo2pOZKp7+vw+ySJi/CBaR3/33N9B86Tc7iKvskMwfpIrLuHJjp
         vLnaCKf6WQi8wTfNQp3ZIyIOT3Oip+t5YYodPVglGLvbvx0wydM5eAvoXXxTyzgiosUo
         nnxTfGW4yYyBE7NiCa589HQE+g9x6FzFdVxEMyvzGMA/NkTYME9hQMACgJLoh5R1R+cm
         b4Ug==
X-Gm-Message-State: APjAAAUrRChgs4pdu3yvyopdf3TT7yk1lRZHaVB6wnWFdSNo0XlnTeno
        4NQWNXEHFzC5oW1quSc4lxqbTA==
X-Google-Smtp-Source: APXvYqyCXOJCO2IXWoMeOsYSfXtD8n1wlZ6dVW0wqH0x3YvXEt/mbY1NsaV7KjDi7I0HuAQNr2UBvA==
X-Received: by 2002:a0d:d64c:: with SMTP id y73mr24895253ywd.334.1570543206122;
        Tue, 08 Oct 2019 07:00:06 -0700 (PDT)
Received: from localhost ([2620:0:1013:11:89c6:2139:5435:371d])
        by smtp.gmail.com with ESMTPSA id r67sm4849025ywr.48.2019.10.08.07.00.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 07:00:05 -0700 (PDT)
Date:   Tue, 8 Oct 2019 10:00:05 -0400
From:   Sean Paul <sean@poorly.run>
To:     Daniel Vetter <daniel@ffwll.ch>
Cc:     Sean Paul <sean@poorly.run>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
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
Message-ID: <20191008140005.GI126146@art_vandelay>
References: <20190904202938.110207-1-sean@poorly.run>
 <CAKMK7uFtcmZd9+wARmYuZwtimUV91fiFXNmr5Nuk4Z65QjHyuA@mail.gmail.com>
 <20190919150401.GV218215@art_vandelay>
 <20191008095033.GJ16989@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191008095033.GJ16989@phenom.ffwll.local>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 08, 2019 at 11:50:33AM +0200, Daniel Vetter wrote:
> On Thu, Sep 19, 2019 at 11:04:01AM -0400, Sean Paul wrote:
> > On Thu, Sep 05, 2019 at 12:41:27PM +0200, Daniel Vetter wrote:
> > > On Wed, Sep 4, 2019 at 10:29 PM Sean Paul <sean@poorly.run> wrote:
> > > >
> > > > From: Sean Paul <seanpaul@chromium.org>
> > > >
> > > > Since the dirtyfb ioctl doesn't give us any hints as to which plane is
> > > > scanning out the fb it's marking as damaged, we need to loop through
> > > > planes to find it.
> > > >
> > > > Currently we just reach into plane state and check, but that can race
> > > > with another commit changing the fb out from under us. This patch locks
> > > > the plane before checking the fb and will release the lock if the plane
> > > > is not displaying the dirty fb.
> > > >
> > > > Fixes: b9fc5e01d1ce ("drm: Add helper to implement legacy dirtyfb")
> > > > Cc: Rob Clark <robdclark@gmail.com>
> > > > Cc: Deepak Rawat <drawat@vmware.com>
> > > > Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> > > > Cc: Thomas Hellstrom <thellstrom@vmware.com>
> > > > Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> > > > Cc: Maxime Ripard <maxime.ripard@bootlin.com>
> > > > Cc: Sean Paul <sean@poorly.run>
> > > > Cc: David Airlie <airlied@linux.ie>
> > > > Cc: Daniel Vetter <daniel@ffwll.ch>
> > > > Cc: dri-devel@lists.freedesktop.org
> > > > Cc: <stable@vger.kernel.org> # v5.0+
> > > > Reported-by: Daniel Vetter <daniel@ffwll.ch>
> > > > Signed-off-by: Sean Paul <seanpaul@chromium.org>
> > > > ---
> > > >  drivers/gpu/drm/drm_damage_helper.c | 8 +++++++-
> > > >  1 file changed, 7 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/drivers/gpu/drm/drm_damage_helper.c b/drivers/gpu/drm/drm_damage_helper.c
> > > > index 8230dac01a89..3a4126dc2520 100644
> > > > --- a/drivers/gpu/drm/drm_damage_helper.c
> > > > +++ b/drivers/gpu/drm/drm_damage_helper.c
> > > > @@ -212,8 +212,14 @@ int drm_atomic_helper_dirtyfb(struct drm_framebuffer *fb,
> > > >         drm_for_each_plane(plane, fb->dev) {
> > > >                 struct drm_plane_state *plane_state;
> > > >
> > > > -               if (plane->state->fb != fb)
> > > > +               ret = drm_modeset_lock(&plane->mutex, state->acquire_ctx);
> > > > +               if (ret)
> > > 
> > > I think for paranoid safety we should have a WARN_ON(ret == -EALREADY)
> > > here. It should be impossible, but if it's not for some oddball
> > > reason, we'll blow up.
> > 
> > drm_modeset_lock eats EALREADY and returns 0 for that case, so I guess it
> > depends _how_ paranoid you want to be here :-)
> 
> Ah silly me, r-b as-is then.

Thanks, pushed to -misc-next

Sean

> -Daniel
> 
> > 
> > > 
> > > With that: Reviewed-by: Daniel Vetter <daniel@ffwll.ch>
> > > 
> > > But please give this a spin with some workloads and the ww_mutex
> > > slowpath debugging enabled, just to makre sure.
> > 
> > Ok, had a chance to run through some tests this morning with
> > CONFIG_DEBUG_WW_MUTEX_SLOWPATH and things lgtm
> > 
> > Sean
> > 
> > > -Daniel
> > > 
> > > > +                       goto out;
> > > > +
> > > > +               if (plane->state->fb != fb) {
> > > > +                       drm_modeset_unlock(&plane->mutex);
> > > >                         continue;
> > > > +               }
> > > >
> > > >                 plane_state = drm_atomic_get_plane_state(state, plane);
> > > >                 if (IS_ERR(plane_state)) {
> > > > --
> > > > Sean Paul, Software Engineer, Google / Chromium OS
> > > >
> > > 
> > > 
> > > -- 
> > > Daniel Vetter
> > > Software Engineer, Intel Corporation
> > > +41 (0) 79 365 57 48 - http://blog.ffwll.ch
> > 
> > -- 
> > Sean Paul, Software Engineer, Google / Chromium OS
> 
> -- 
> Daniel Vetter
> Software Engineer, Intel Corporation
> http://blog.ffwll.ch

-- 
Sean Paul, Software Engineer, Google / Chromium OS
