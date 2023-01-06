Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8C5660850
	for <lists+stable@lfdr.de>; Fri,  6 Jan 2023 21:31:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235857AbjAFUbG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Jan 2023 15:31:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbjAFUbC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Jan 2023 15:31:02 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5DAB3C709
        for <stable@vger.kernel.org>; Fri,  6 Jan 2023 12:31:00 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id bn26so2372864wrb.0
        for <stable@vger.kernel.org>; Fri, 06 Jan 2023 12:31:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zmnTz8/2kfdFyB6x8PTFchjQzfo0fx86uAVQddggYnU=;
        b=QDiE9naefEI1d5kfh4laxGY1RcATSlKvPxkPLXOkcJ9yILKQhTE4aESsj1oYoKNoD1
         +JqJEO+cE/oaC3db0934YfBDzaJfkep6EF1RNkAzSCyF4yOW4irWP5lPS/S+Pa1HYOkj
         8DNo819Vw9PzXSpGcwo9fonNqrP4IfiIKYlVA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zmnTz8/2kfdFyB6x8PTFchjQzfo0fx86uAVQddggYnU=;
        b=p2rYLc6Xdrcrtz6ewEa6p91d89a9uvt1XKuKo3KJNy/u5uiPJWXmizpkRE+i7URX+o
         pzykELpPKYxLeCJlULNcXJhUs7MkcSOO1lxEO4YPQCN5oOcN0ntBEScrZ6YazpebJS/H
         d8VAb3gBpFqcO90Y21UcQeb2FR/LIPdROYM+GgiBLeregDkLrHiNBI5tJKyd35fwDjfD
         327F3fOUpsuEwhs5sI64Y1bbVCLypE6lZgjOPgfxY1ir++y9P8w1l/ZuxdGDnwR/pMdH
         a+FHTOoNPdoys1qu6QqpIgjEHqF/7hYxSqyaGR3W3+iXugnVVD0bqY8yrue8QqgNubPy
         BAAQ==
X-Gm-Message-State: AFqh2kpYpDWs5RBp9c6U3lhDqN/2xnruOu8xFIWrTb24Gq4WbYl/qhkZ
        3Avc0nOswwABuLuxxGL9/+p5Lw==
X-Google-Smtp-Source: AMrXdXsGhHQm6ue86ek8a/TahpSuukropvViZubkaaHdP6I4LctKBRL7+Y+FkYhKQhuX8FcLuzSEJg==
X-Received: by 2002:adf:f54a:0:b0:242:2e1e:23a6 with SMTP id j10-20020adff54a000000b002422e1e23a6mr36969526wrp.22.1673037059116;
        Fri, 06 Jan 2023 12:30:59 -0800 (PST)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id t14-20020adfeb8e000000b002baa780f0fasm1998405wrn.111.2023.01.06.12.30.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 12:30:58 -0800 (PST)
Date:   Fri, 6 Jan 2023 21:30:56 +0100
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
Message-ID: <Y7iFAJqGNXA7wHoK@phenom.ffwll.local>
Mail-Followup-To: Brian Norris <briannorris@chromium.org>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Sean Paul <seanpaul@chromium.org>,
        Michel =?iso-8859-1?Q?D=E4nzer?= <michel.daenzer@mailbox.org>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Sandy Huang <hjc@rock-chips.com>,
        linux-rockchip@lists.infradead.org, stable@vger.kernel.org
References: <20230105174001.1.I3904f697863649eb1be540ecca147a66e42bfad7@changeid>
 <Y7hgLUXOrD7QwKs1@phenom.ffwll.local>
 <Y7hl0Z9PZhFk8On9@phenom.ffwll.local>
 <Y7h3cuAVE2fdS9K3@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7h3cuAVE2fdS9K3@google.com>
X-Operating-System: Linux phenom 5.19.0-2-amd64 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 06, 2023 at 11:33:06AM -0800, Brian Norris wrote:
> On Fri, Jan 06, 2023 at 07:17:53PM +0100, Daniel Vetter wrote:
> > Ok I think I was a bit slow here, and it makes sense. Except this now
> > means we loose this check, and I'm also not sure whether we really want
> > drivers to implement this all.
> > 
> > What I think we want here is a bit more:
> > - for the self-refresh case check that the vblank all still works
> 
> You mean, keep the WARN_ONCE(), but invert it to ensure that 'ret == 0'?
> I did consider that, but I don't know why I stopped.

Yeah, so that we check that vblanks keep working in the self-refresh case.

> > - check that drivers which use self_refresh are not using
> >   drm_atomic_helper_wait_for_vblanks(), because that would defeat the
> >   point
> 
> I'm a bit lost on this one. drm_atomic_helper_wait_for_vblanks() is part
> of the common drm_atomic_helper_commit_tail*() helpers, and so it's
> naturally used in many cases (including Rockchip/PSR). And how does it
> defeat the point?

Yeah, but that's for backwards compat reasons, the much better function is
drm_atomic_helper_wait_for_flip_done(). And if you go into self refresh
that's really the better one.

> > - have a drm_crtc_vblank_off/on which take the crtc state, so they can
> >   look at the self-refresh state
> 
> And I suppose you mean this helper variant would kick off the next step
> (fake vblank timer)?

Yeah, I figured that's the better way to implement this since it would be
driver agnostic. But rockchip is still the only driver using the
self-refresh helpers, so I guess it doesn't really matter.

> > - fake vblanks with hrtimer, because on most hw when you turn off the crtc
> >   the vblanks are also turned off, and so your compositor would still
> >   hang. The vblank machinery already has all the code to make this happen
> >   (and if it's not all, then i915 psr code should have it).
> 
> Is a timer better than an interrupt? I'm pretty sure the vblank
> interrupts still can fire on Rockchip CRTC (VOP) (see also the other
> branch of this thread), so this isn't really necessary. (IGT vblank
> tests pass without hanging.) Unless you simply prefer a fake timer for
> some reason.
> 
> Also, I still haven't found that fake timer machinery, but maybe I just
> don't know what I'm looking for.

I ... didn't find it either. I'm honestly not sure whether this works for
intel, or whether we do something silly like disable self-refresh when a
vblank interrupt is pending :-/
 
> > - I think kunit tests for this all would be really good, it's a rather
> >   complex state machinery between modesets and vblank functionality. You
> >   can speed up the kunit tests with some really high refresh rate, which
> >   isn't possible on real hw.
> 
> Last time I tried my hand at kunit in a subsystem with no prior kunit
> tests, I had a miserable time and gave up. At least DRM has a few
> already, so maybe this wouldn't be as terrible. Perhaps I can give this
> a shot, but there's a chance this will kick things to the back burner
> far enough that I simply don't get around to it at all. (So far, I'm
> only addressing this because KernelCI complained.)

Nah if we dont solve this in a generic way then we don't need kunit to
make sure it keeps working.

> > I'm also wondering why we've had this code for years and only hit issues
> > now?
> 
> I'd guess a few reasons:
> 1. drm_self_refresh_helper_init() is only used by one driver -- Rockchip
> 2. Rockchip systems are most commonly either Chromebooks, or else
>    otherwise cheap embedded things, and may not have displays at all,
>    let alone displays with PSR
> 3. Rockchip Chromebooks shipped with a kernel forked off of the earlier
>    PSR support, before everything got refactored (and vblank handling
>    regressed) for the self-refresh "helpers". They only upgraded to a
>    newer upstream kernel within the last few months.
> 4. AFAICT, ChromeOS user space doesn't even exercise the vblank-related
>    ioctls, so we don't actually notice that this is "broken". I suppose
>    it would only be IGT tests that notice.
> 5. I fixed up various upstream PSR bugs are part of #3 [0],
>    along the way I unborked PSR enough that KernelCI finally caught the
>    bug. See my explanation in [1] for why the vblank bug was masked, and
>    appeared to be a "regression" due to my more recent fixes.

Yeah I thought we had more drivers using self-refresh helpers, bot that's
not the case :-/

I think new proposal from me is to just respin this patch here with our
discussion all summarized (it's good to record this stuff for the next
person that comes around), and the WARN_ON adjusted so it also checks that
vblank interrupts keep working (per the ret value at least, it's not a
real functional check). And call that good enough.

Also maybe look into switching from wait_for_vblanks to
wait_for_flip_done, it's the right thing to do (see kerneldoc, it should
explain things a bit).
-Daniel


> 
> Brian
> 
> [0] Combined with point #2: ChromeOS would be the first serious users of
>     the refactored PSR support. All this was needed to make it actually
>     usable:
> 
>     (2021) c4c6ef229593 drm/bridge: analogix_dp: Make PSR-exit block less
>     (2022) ca871659ec16 drm/bridge: analogix_dp: Support PSR-exit to disable transition <--- KernelCI "blamed" this one, because PSR was less broken
>     (2022) e54a4424925a drm/atomic: Force bridge self-refresh-exit on CRTC switch
> 
> [1] https://lore.kernel.org/dri-devel/Y6OCg9BPnJvimQLT@google.com/
> Re: renesas/master bisection: igt-kms-rockchip.kms_vblank.pipe-A-wait-forked on rk3399-gru-kevin

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
