Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33ABB660643
	for <lists+stable@lfdr.de>; Fri,  6 Jan 2023 19:18:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234793AbjAFSSA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Jan 2023 13:18:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235069AbjAFSR7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Jan 2023 13:17:59 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ED3A34D77
        for <stable@vger.kernel.org>; Fri,  6 Jan 2023 10:17:58 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id m3so1643322wmq.0
        for <stable@vger.kernel.org>; Fri, 06 Jan 2023 10:17:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vZgX/uzlYtYm+9CzMWs/3dsasYH/jPMu/yKWM7axVwk=;
        b=EYP1baRZFqqVCOv2pOnk8Fyfs9j+68lHjfHjXy3FlgSyMB+a6B7b/8lxKKeXQM6i3+
         DUnkfdSpmpGibulk4z1SW1HEiJ/8mZiJud0QlpdKVVZWFI5fO126Iwwh2aunqAGusgw9
         FORTEE3dj1I00pDSrYlO+fYYkuAEfEm/4fEbU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vZgX/uzlYtYm+9CzMWs/3dsasYH/jPMu/yKWM7axVwk=;
        b=5sahEV726CF6GqYPmG2wKUWCdOJhWK+ywEEc/y+jBLrtNEhbMT1q9jtd10wUr1Bmxm
         fp1Wjsn1bSj/TIXJz39vXUpFEF3RPiMjI/Q6XPVB5bfOZz+3PvaO/hRmAAEqWaKhuND5
         njEwkvSv84xyCijLa+qB4+1iRlLtiXjCO2bJhngSVCkZK4V7e0jiW8X0IKP3PdkXkLne
         gf+zHNT6AqzO+hRd9gepTg7hmsmm/Z6Vb7gaUCpKyZnE5Gv5dS4OqstvkaPoK5BmZvqg
         LW074BG2Z4+4mnplb2s67VTf0YYTA9yRornJfa/BcIlCeVcq7AD6A2DseSOQ7qF5Vs19
         Gr0Q==
X-Gm-Message-State: AFqh2kq13stgHg4yNSl/pTWoNg95PbYIWIWT/sGBu7y5GuG6yYm8LBtW
        BUxsp4iGHTVktyHMc5LnedrK/w==
X-Google-Smtp-Source: AMrXdXsk//Ebc0AFqktmpd6sDIvJObm64v2tJRUyH+TzrQSdtbUZvCiU+wBVSRkdkv1F957NrNmdzA==
X-Received: by 2002:a05:600c:3d8a:b0:3d3:4406:8a37 with SMTP id bi10-20020a05600c3d8a00b003d344068a37mr40344682wmb.41.1673029076764;
        Fri, 06 Jan 2023 10:17:56 -0800 (PST)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id v10-20020a05600c444a00b003d998412db6sm7762398wmn.28.2023.01.06.10.17.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 10:17:55 -0800 (PST)
Date:   Fri, 6 Jan 2023 19:17:53 +0100
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Brian Norris <briannorris@chromium.org>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Sean Paul <seanpaul@chromium.org>,
        Michel =?iso-8859-1?Q?D=E4nzer?= <michel.daenzer@mailbox.org>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Sandy Huang <hjc@rock-chips.com>,
        linux-rockchip@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] drm/atomic: Allow vblank-enabled + self-refresh
 "disable"
Message-ID: <Y7hl0Z9PZhFk8On9@phenom.ffwll.local>
Mail-Followup-To: Brian Norris <briannorris@chromium.org>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Sean Paul <seanpaul@chromium.org>,
        Michel =?iso-8859-1?Q?D=E4nzer?= <michel.daenzer@mailbox.org>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Sandy Huang <hjc@rock-chips.com>,
        linux-rockchip@lists.infradead.org, stable@vger.kernel.org
References: <20230105174001.1.I3904f697863649eb1be540ecca147a66e42bfad7@changeid>
 <Y7hgLUXOrD7QwKs1@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7hgLUXOrD7QwKs1@phenom.ffwll.local>
X-Operating-System: Linux phenom 5.19.0-2-amd64 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 06, 2023 at 06:53:49PM +0100, Daniel Vetter wrote:
> On Thu, Jan 05, 2023 at 05:40:17PM -0800, Brian Norris wrote:
> > The self-refresh helper framework overloads "disable" to sometimes mean
> > "go into self-refresh mode," and this mode activates automatically
> > (e.g., after some period of unchanging display output). In such cases,
> > the display pipe is still considered "on", and user-space is not aware
> > that we went into self-refresh mode. Thus, users may expect that
> > vblank-related features (such as DRM_IOCTL_WAIT_VBLANK) still work
> > properly.
> > 
> > However, we trigger the WARN_ONCE() here if a CRTC driver tries to leave
> > vblank enabled here.
> > 
> > Add a new exception, such that we allow CRTCs to be "disabled" (with
> > self-refresh active) with vblank interrupts still enabled.
> > 
> > Cc: <stable@vger.kernel.org> # dependency for subsequent patch
> > Signed-off-by: Brian Norris <briannorris@chromium.org>
> > ---
> > 
> >  drivers/gpu/drm/drm_atomic_helper.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/drivers/gpu/drm/drm_atomic_helper.c b/drivers/gpu/drm/drm_atomic_helper.c
> > index d579fd8f7cb8..7b5eddadebd5 100644
> > --- a/drivers/gpu/drm/drm_atomic_helper.c
> > +++ b/drivers/gpu/drm/drm_atomic_helper.c
> > @@ -1207,6 +1207,12 @@ disable_outputs(struct drm_device *dev, struct drm_atomic_state *old_state)
> >  
> >  		if (!drm_dev_has_vblank(dev))
> >  			continue;
> > +		/*
> > +		 * Self-refresh is not a true "disable"; let vblank remain
> > +		 * enabled.
> > +		 */
> > +		if (new_crtc_state->self_refresh_active)
> > +			continue;
> 
> This very fishy, because we check in crtc_needs_disable whether this
> output should stay on due to self-refresh. Which means you should never
> end up in here.
> 
> And yes vblank better work in self refresh :-) If it doesn't, then you
> need to fake it with a timer, that's at least what i915 has done for
> transparent self-refresh.
> 
> We might need a few more helpers. Also, probably more igt, or is this
> something igt testing has uncovered? If so, please cite the igt testcase
> which hits this.

Ok I think I was a bit slow here, and it makes sense. Except this now
means we loose this check, and I'm also not sure whether we really want
drivers to implement this all.

What I think we want here is a bit more:
- for the self-refresh case check that the vblank all still works

- check that drivers which use self_refresh are not using
  drm_atomic_helper_wait_for_vblanks(), because that would defeat the
  point

- have a drm_crtc_vblank_off/on which take the crtc state, so they can
  look at the self-refresh state

- fake vblanks with hrtimer, because on most hw when you turn off the crtc
  the vblanks are also turned off, and so your compositor would still
  hang. The vblank machinery already has all the code to make this happen
  (and if it's not all, then i915 psr code should have it).

- I think kunit tests for this all would be really good, it's a rather
  complex state machinery between modesets and vblank functionality. You
  can speed up the kunit tests with some really high refresh rate, which
  isn't possible on real hw.

I'm also wondering why we've had this code for years and only hit issues
now?
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
