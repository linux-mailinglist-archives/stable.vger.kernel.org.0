Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51B0B66064A
	for <lists+stable@lfdr.de>; Fri,  6 Jan 2023 19:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231690AbjAFSVI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Jan 2023 13:21:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235652AbjAFSUq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Jan 2023 13:20:46 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F08D36B5F0
        for <stable@vger.kernel.org>; Fri,  6 Jan 2023 10:20:44 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id co23so2037621wrb.4
        for <stable@vger.kernel.org>; Fri, 06 Jan 2023 10:20:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aemmpY4lie0lDuI7ZJtcygqgFQlTvEL2aaHOwmDLGio=;
        b=BOSJE7k9oAgjMKUPmDPqU5v3aotgQDyoBIuL+1/3CyEnq/QGAKfiOSwoatlql7i8sb
         X9MHzMrnFyc0xhjunyG27PnLXeW1c+AJ+c1pE9XeqThLDFOsFSEvc/MBSYyMaSCfCYBf
         KpQMEMdNYa2d9pub8CX6UAyoih+vUQoZ8TXSk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aemmpY4lie0lDuI7ZJtcygqgFQlTvEL2aaHOwmDLGio=;
        b=SJC4WPwNmdowivcCGROJy5xxINbk63pRiD6g/O6/uG19DY8ht34UjTVwics+m+k1fl
         BOWTT5wAGsnxi4WDutSuFujtTFD+ef7BTaXPErfNcykR8b2JfxjPbDt2hZN7wlV/59PH
         RZt+dYXOZ8zkg25M5MV8S4097reXz51VzTOng4ZrB9QXvA+sSwUlm9dBNxKAms9f2q1F
         hnc+gFh5l7z4H+MAikp/cSyYX4B5C7arvPaB24djQcp/nLrtEECi3Try0jUjE1Bu2HST
         Hax/cOWWMQUnw1h89YGS1aGYltqkxLGcSml2fceZKqqRFlbRPHOgLRNdShxeFpiNgO3s
         77OQ==
X-Gm-Message-State: AFqh2koo7feuc442n6+LOFxRb7DDYDyofNdNXv5+ktvag3wwgHfVGsrv
        jE7lY4hZLQFnk/cRgS+5rTeCxA==
X-Google-Smtp-Source: AMrXdXuslGmA1psv/BImwtT+vCgcM1mmsJIsu6DTNKX2UGWUkyyOlwD0Yl43/lZw2WQyQlHD+vDb0Q==
X-Received: by 2002:a05:6000:691:b0:296:8c1f:3786 with SMTP id bo17-20020a056000069100b002968c1f3786mr15177819wrb.9.1673029243548;
        Fri, 06 Jan 2023 10:20:43 -0800 (PST)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id j17-20020adff011000000b002a64e575b4esm1862163wro.47.2023.01.06.10.20.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 10:20:42 -0800 (PST)
Date:   Fri, 6 Jan 2023 19:20:40 +0100
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Brian Norris <briannorris@chromium.org>
Cc:     Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Sean Paul <seanpaul@chromium.org>,
        Michel =?iso-8859-1?Q?D=E4nzer?= <michel.daenzer@mailbox.org>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Sandy Huang <hjc@rock-chips.com>,
        linux-rockchip@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] drm/atomic: Allow vblank-enabled + self-refresh
 "disable"
Message-ID: <Y7hmeBBRqgnwQ2O6@phenom.ffwll.local>
Mail-Followup-To: Brian Norris <briannorris@chromium.org>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Sean Paul <seanpaul@chromium.org>,
        Michel =?iso-8859-1?Q?D=E4nzer?= <michel.daenzer@mailbox.org>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Sandy Huang <hjc@rock-chips.com>,
        linux-rockchip@lists.infradead.org, stable@vger.kernel.org
References: <20230105174001.1.I3904f697863649eb1be540ecca147a66e42bfad7@changeid>
 <Y7hgLUXOrD7QwKs1@phenom.ffwll.local>
 <Y7hjte/w8yP2TPlB@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7hjte/w8yP2TPlB@google.com>
X-Operating-System: Linux phenom 5.19.0-2-amd64 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 06, 2023 at 10:08:53AM -0800, Brian Norris wrote:
> Hi Daniel,
> 
> On Fri, Jan 06, 2023 at 06:53:49PM +0100, Daniel Vetter wrote:
> > On Thu, Jan 05, 2023 at 05:40:17PM -0800, Brian Norris wrote:
> > > The self-refresh helper framework overloads "disable" to sometimes mean
> > > "go into self-refresh mode," and this mode activates automatically
> > > (e.g., after some period of unchanging display output). In such cases,
> > > the display pipe is still considered "on", and user-space is not aware
> > > that we went into self-refresh mode. Thus, users may expect that
> > > vblank-related features (such as DRM_IOCTL_WAIT_VBLANK) still work
> > > properly.
> > > 
> > > However, we trigger the WARN_ONCE() here if a CRTC driver tries to leave
> > > vblank enabled here.
> > > 
> > > Add a new exception, such that we allow CRTCs to be "disabled" (with
> > > self-refresh active) with vblank interrupts still enabled.
> > > 
> > > Cc: <stable@vger.kernel.org> # dependency for subsequent patch
> > > Signed-off-by: Brian Norris <briannorris@chromium.org>
> > > ---
> > > 
> > >  drivers/gpu/drm/drm_atomic_helper.c | 6 ++++++
> > >  1 file changed, 6 insertions(+)
> > > 
> > > diff --git a/drivers/gpu/drm/drm_atomic_helper.c b/drivers/gpu/drm/drm_atomic_helper.c
> > > index d579fd8f7cb8..7b5eddadebd5 100644
> > > --- a/drivers/gpu/drm/drm_atomic_helper.c
> > > +++ b/drivers/gpu/drm/drm_atomic_helper.c
> > > @@ -1207,6 +1207,12 @@ disable_outputs(struct drm_device *dev, struct drm_atomic_state *old_state)
> > >  
> > >  		if (!drm_dev_has_vblank(dev))
> > >  			continue;
> > > +		/*
> > > +		 * Self-refresh is not a true "disable"; let vblank remain
> > > +		 * enabled.
> > > +		 */
> > > +		if (new_crtc_state->self_refresh_active)
> > > +			continue;
> > 
> > This very fishy, because we check in crtc_needs_disable whether this
> > output should stay on due to self-refresh. Which means you should never
> > end up in here.
> 
> That's not what crtc_needs_disable() does w.r.t. self-refresh. In fact,
> it's the opposite; see, for example, the
> |new_state->self_refresh_active| clause. That clause means that if we're
> entering self-refresh, we *intend* to disable (i.e., we return 'true').
> That's because like I mention above, the self-refresh helpers overload
> what "disable" means.
> 
> I'll also add my caveat again that I'm a bit new to DRM, so feel free to
> continue to correct me if I'm wrong :) Or perhaps Sean Paul could
> provide second opinions, as I believe he wrote this stuff.

I already replied in another thread with hopefully less nonsense from my
side :-)

> > And yes vblank better work in self refresh :-) If it doesn't, then you
> > need to fake it with a timer, that's at least what i915 has done for
> > transparent self-refresh.
> 
> OK! Then that sounds like it at least ACKs my general idea for this
> series. (Michel and I poked at a few ideas in the thread at [1] and
> landed on approx. this solution, or else a fake/timer like you suggest.)

Yeah once I stopped looking at this the wrong way round it does make sense
what you're doing. See my other reply, I think with just this series here
the vblanks still stall out? Or does your hw actually keep generating
vblank irq with the display off?

> > We might need a few more helpers. Also, probably more igt, or is this
> > something igt testing has uncovered? If so, please cite the igt testcase
> > which hits this.
> 
> The current patch only fixes a warning that comes when I try to do the
> second patch. The second patch is a direct product of an IGT test
> failure (a few of kms_vblank's subtests), and I linked [1] the KernelCI
> report there.

Ah yeah that makes sense. Would be good to cite that in this patch too,
because I guess the same kms_vblank tests can also hit this warning here?
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
