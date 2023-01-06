Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A492660630
	for <lists+stable@lfdr.de>; Fri,  6 Jan 2023 19:09:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbjAFSI7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Jan 2023 13:08:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231277AbjAFSI5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Jan 2023 13:08:57 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D35604166F
        for <stable@vger.kernel.org>; Fri,  6 Jan 2023 10:08:56 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id h7-20020a17090aa88700b00225f3e4c992so5955097pjq.1
        for <stable@vger.kernel.org>; Fri, 06 Jan 2023 10:08:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aRfBMIOrWnkTgcTHC8fokRZyL82kMsM9senrx2vjrp4=;
        b=KGEHXfRmPiYzMG2kUn40dLIk5Z1zjbUEthvuPHMpU6fXdKK6/8qi6QmjzIFqCAjxHo
         jdVeSB8e9/bEAZb+jcbPfsS3Hvi9dlBXT03QtiyWDcGq+k9yn3JWMV2F6TuXSP3iN7bh
         1C2hcM1cmLER/jBXk3lKj5hiOdZ3tqDNm480o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aRfBMIOrWnkTgcTHC8fokRZyL82kMsM9senrx2vjrp4=;
        b=a74xH+zRzL9FWph1ABSkBUmB7xzCBr4mCwApG/UUIAinCG60cmRMxv/FaYtJYVRhVG
         mLHuZcAM/BjFsHBKkldM4H2+6CWccfOwezBlyi/uIQd31ZV8kvorLhfn89e6WfHnnhFD
         orpC0uYkQ341/Z1F06Rv2etj5ERFqVY2WtSF/BLowvtG5UH6Vn7ZuKNilP7NaAvOAXuH
         icQo3W2PKAFiXczmL9Gf8+UH1AAyiGDSDyc+tHQai+DWSxcKZ/mJxkiDnZZ+bGDf7xZz
         86ZFpnhAc4cWZKXneDjV45qtGim4zdOq9k/UtQeHHtUfIQGUheDMqMsx51jnamjEmonI
         dcSg==
X-Gm-Message-State: AFqh2koIe+98e3XzvIP+t+rmLpkeHWgW7MMZAnG+LnabEqmFDEBis7Ef
        Ydz9W+IGvJKLqxQn3Z2LubGAeGuTF/Xt5Xol
X-Google-Smtp-Source: AMrXdXu3+CpeCXjMMRDSk0RxLILeTWZA5Pe+CQFqkM1hhlNB+wt9gU/hx35Rd9JRj7BX4MHLZ0xiiA==
X-Received: by 2002:a17:902:eb8f:b0:192:8ec5:fd58 with SMTP id q15-20020a170902eb8f00b001928ec5fd58mr43083908plg.6.1673028536246;
        Fri, 06 Jan 2023 10:08:56 -0800 (PST)
Received: from google.com ([2620:15c:9d:2:5567:fb20:aa4f:352])
        by smtp.gmail.com with ESMTPSA id u5-20020a170902e80500b00189529ed580sm1282081plg.60.2023.01.06.10.08.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 10:08:55 -0800 (PST)
Date:   Fri, 6 Jan 2023 10:08:53 -0800
From:   Brian Norris <briannorris@chromium.org>
To:     Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Sean Paul <seanpaul@chromium.org>,
        Michel =?iso-8859-1?Q?D=E4nzer?= <michel.daenzer@mailbox.org>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Sandy Huang <hjc@rock-chips.com>,
        linux-rockchip@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] drm/atomic: Allow vblank-enabled + self-refresh
 "disable"
Message-ID: <Y7hjte/w8yP2TPlB@google.com>
References: <20230105174001.1.I3904f697863649eb1be540ecca147a66e42bfad7@changeid>
 <Y7hgLUXOrD7QwKs1@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7hgLUXOrD7QwKs1@phenom.ffwll.local>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Daniel,

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

That's not what crtc_needs_disable() does w.r.t. self-refresh. In fact,
it's the opposite; see, for example, the
|new_state->self_refresh_active| clause. That clause means that if we're
entering self-refresh, we *intend* to disable (i.e., we return 'true').
That's because like I mention above, the self-refresh helpers overload
what "disable" means.

I'll also add my caveat again that I'm a bit new to DRM, so feel free to
continue to correct me if I'm wrong :) Or perhaps Sean Paul could
provide second opinions, as I believe he wrote this stuff.

> And yes vblank better work in self refresh :-) If it doesn't, then you
> need to fake it with a timer, that's at least what i915 has done for
> transparent self-refresh.

OK! Then that sounds like it at least ACKs my general idea for this
series. (Michel and I poked at a few ideas in the thread at [1] and
landed on approx. this solution, or else a fake/timer like you suggest.)

> We might need a few more helpers. Also, probably more igt, or is this
> something igt testing has uncovered? If so, please cite the igt testcase
> which hits this.

The current patch only fixes a warning that comes when I try to do the
second patch. The second patch is a direct product of an IGT test
failure (a few of kms_vblank's subtests), and I linked [1] the KernelCI
report there.

Brian

[1] Link: https://lore.kernel.org/dri-devel/Y5itf0+yNIQa6fU4@sirena.org.uk/
    Reported-by: "kernelci.org bot" <bot@kernelci.org>
