Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A064660729
	for <lists+stable@lfdr.de>; Fri,  6 Jan 2023 20:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235330AbjAFTdL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Jan 2023 14:33:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjAFTdK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Jan 2023 14:33:10 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99642736E9
        for <stable@vger.kernel.org>; Fri,  6 Jan 2023 11:33:09 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id w3so2686392ply.3
        for <stable@vger.kernel.org>; Fri, 06 Jan 2023 11:33:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MFslfd+pC3/chcOWKMwxg3XD+/XfpfE2RT5MHLxEcXU=;
        b=USdDzZhhWDJBoerKZ6sMe7xg6j0XN8M9ShxJ4WtrGWLrm7Qvne88YzVYrL5fIU0niK
         eE7dTaorSZcyd/zlf4KVTqdihiFDkB/gNmtEOAXRyKxnA9SYcWnEpAAWpaorPuJ//Qkd
         AV5giVIwDvgnNz3AVs4WTV6OiJHAtAzClM4No=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MFslfd+pC3/chcOWKMwxg3XD+/XfpfE2RT5MHLxEcXU=;
        b=i0RwfV6aFDRoYoCc1941qRuHuDGOElXu2ozwQP9k55gTT5srTwsr9pMUyvGjPwbxPh
         lmHTg8I9PY4hTY67nc+n1dNDSgLf9PuS5DRlkVg6UTa+VitD0uUPJOvjfUhe9EUrxPph
         vCtLRZfO6tOyyPonwFIruInGQK5qZobkhEAR86RK+CLGXY56LzcFpFDCdbKp339olcQp
         YCiNr3OWIuYe9zA1R8hx1g2mwjBN1Do94lcdzg5MLB/zotYO1IhfVEqL1LXFERrfedv5
         IVxJYZCwdrOGjfpYgu73F67xhfbHfhGQqo/VfOWxi7vM6tUnd7H20iCuN+FoSOF0HQxy
         +QtA==
X-Gm-Message-State: AFqh2koAxNBQWwiC+zjdvgmSqj64Lh7fZGwrDVyBANZH5W630Zu1YxiI
        P3GNknpzTYV80Ib/+JgH7j32wA==
X-Google-Smtp-Source: AMrXdXsH3vIaY64jg/dcbXKNEQaz/aJx6Q/1RM0SJeHVYhMTi8gZJKnEWYPW2YjzNx/EtPEwTX3XXQ==
X-Received: by 2002:a17:902:b402:b0:191:2b76:612c with SMTP id x2-20020a170902b40200b001912b76612cmr53370723plr.62.1673033589074;
        Fri, 06 Jan 2023 11:33:09 -0800 (PST)
Received: from google.com ([2620:15c:9d:2:bc4e:2cc9:68b3:15dc])
        by smtp.gmail.com with ESMTPSA id i7-20020a17090332c700b001894881842dsm1298174plr.151.2023.01.06.11.33.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 11:33:08 -0800 (PST)
Date:   Fri, 6 Jan 2023 11:33:06 -0800
From:   Brian Norris <briannorris@chromium.org>
To:     Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Sean Paul <seanpaul@chromium.org>,
        Michel =?iso-8859-1?Q?D=E4nzer?= <michel.daenzer@mailbox.org>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Sandy Huang <hjc@rock-chips.com>,
        linux-rockchip@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] drm/atomic: Allow vblank-enabled + self-refresh
 "disable"
Message-ID: <Y7h3cuAVE2fdS9K3@google.com>
References: <20230105174001.1.I3904f697863649eb1be540ecca147a66e42bfad7@changeid>
 <Y7hgLUXOrD7QwKs1@phenom.ffwll.local>
 <Y7hl0Z9PZhFk8On9@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7hl0Z9PZhFk8On9@phenom.ffwll.local>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 06, 2023 at 07:17:53PM +0100, Daniel Vetter wrote:
> Ok I think I was a bit slow here, and it makes sense. Except this now
> means we loose this check, and I'm also not sure whether we really want
> drivers to implement this all.
> 
> What I think we want here is a bit more:
> - for the self-refresh case check that the vblank all still works

You mean, keep the WARN_ONCE(), but invert it to ensure that 'ret == 0'?
I did consider that, but I don't know why I stopped.

> - check that drivers which use self_refresh are not using
>   drm_atomic_helper_wait_for_vblanks(), because that would defeat the
>   point

I'm a bit lost on this one. drm_atomic_helper_wait_for_vblanks() is part
of the common drm_atomic_helper_commit_tail*() helpers, and so it's
naturally used in many cases (including Rockchip/PSR). And how does it
defeat the point?

> - have a drm_crtc_vblank_off/on which take the crtc state, so they can
>   look at the self-refresh state

And I suppose you mean this helper variant would kick off the next step
(fake vblank timer)?

> - fake vblanks with hrtimer, because on most hw when you turn off the crtc
>   the vblanks are also turned off, and so your compositor would still
>   hang. The vblank machinery already has all the code to make this happen
>   (and if it's not all, then i915 psr code should have it).

Is a timer better than an interrupt? I'm pretty sure the vblank
interrupts still can fire on Rockchip CRTC (VOP) (see also the other
branch of this thread), so this isn't really necessary. (IGT vblank
tests pass without hanging.) Unless you simply prefer a fake timer for
some reason.

Also, I still haven't found that fake timer machinery, but maybe I just
don't know what I'm looking for.

> - I think kunit tests for this all would be really good, it's a rather
>   complex state machinery between modesets and vblank functionality. You
>   can speed up the kunit tests with some really high refresh rate, which
>   isn't possible on real hw.

Last time I tried my hand at kunit in a subsystem with no prior kunit
tests, I had a miserable time and gave up. At least DRM has a few
already, so maybe this wouldn't be as terrible. Perhaps I can give this
a shot, but there's a chance this will kick things to the back burner
far enough that I simply don't get around to it at all. (So far, I'm
only addressing this because KernelCI complained.)

> I'm also wondering why we've had this code for years and only hit issues
> now?

I'd guess a few reasons:
1. drm_self_refresh_helper_init() is only used by one driver -- Rockchip
2. Rockchip systems are most commonly either Chromebooks, or else
   otherwise cheap embedded things, and may not have displays at all,
   let alone displays with PSR
3. Rockchip Chromebooks shipped with a kernel forked off of the earlier
   PSR support, before everything got refactored (and vblank handling
   regressed) for the self-refresh "helpers". They only upgraded to a
   newer upstream kernel within the last few months.
4. AFAICT, ChromeOS user space doesn't even exercise the vblank-related
   ioctls, so we don't actually notice that this is "broken". I suppose
   it would only be IGT tests that notice.
5. I fixed up various upstream PSR bugs are part of #3 [0],
   along the way I unborked PSR enough that KernelCI finally caught the
   bug. See my explanation in [1] for why the vblank bug was masked, and
   appeared to be a "regression" due to my more recent fixes.

Brian

[0] Combined with point #2: ChromeOS would be the first serious users of
    the refactored PSR support. All this was needed to make it actually
    usable:

    (2021) c4c6ef229593 drm/bridge: analogix_dp: Make PSR-exit block less
    (2022) ca871659ec16 drm/bridge: analogix_dp: Support PSR-exit to disable transition <--- KernelCI "blamed" this one, because PSR was less broken
    (2022) e54a4424925a drm/atomic: Force bridge self-refresh-exit on CRTC switch

[1] https://lore.kernel.org/dri-devel/Y6OCg9BPnJvimQLT@google.com/
Re: renesas/master bisection: igt-kms-rockchip.kms_vblank.pipe-A-wait-forked on rk3399-gru-kevin
