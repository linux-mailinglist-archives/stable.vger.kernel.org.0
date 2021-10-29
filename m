Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B89BE4405AD
	for <lists+stable@lfdr.de>; Sat, 30 Oct 2021 01:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbhJ2XMh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Oct 2021 19:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbhJ2XMg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Oct 2021 19:12:36 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 923BFC061570
        for <stable@vger.kernel.org>; Fri, 29 Oct 2021 16:10:07 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id nn3-20020a17090b38c300b001a03bb6c4ebso8355201pjb.1
        for <stable@vger.kernel.org>; Fri, 29 Oct 2021 16:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Khuc1pXaYRofI6UFT+rSjF/BH8l2xaVqJxEXbWNhoCI=;
        b=j8fihy9A+vPnYIT8fw/af9uk1vDrLXfUnYL7Y19yFfcmFAN142nUhBww+jcsbZbBJ0
         nBf5oCCHnGN3Z1kU04lJYCZB1o8OG82JZqP78x7yL39g2jSfxAPDWS1FXEUclJQDi+wQ
         7z5rz89qkltJ6fmszGfzOHbclRL0Zwsikf6es=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Khuc1pXaYRofI6UFT+rSjF/BH8l2xaVqJxEXbWNhoCI=;
        b=hUQddBz9Xcfy8QV1mdPrlDHgpvOTZWnm8DFOpti1YYtlUHWBWjqFGa9pXtEKHNAPmI
         llJmOlUwq5HP11rk7OW51K07AVVKjxKcZBW+hwBIiPxHthFbrjMYdb3q2L3CQcAYO9Je
         B1q2R8Ggjk5/9eUqQEjEZrJyfIkACGlStxpFpP5wUEUuvKK8JXT7nzzy0fVhdu224LJ8
         A2QFmFSPhID/BBV3TNtDpBd76RPEP/CXb/tt4jC6l8b4HC4H4cJMRvjzTk7DaaOHIdf/
         LHVstJf6MzyNPJQmNIaayVrM8XlPwjlU9tSVqgOa6NPoRdr9NURAyS2dunBuu4CJyK8m
         +cfQ==
X-Gm-Message-State: AOAM53085qaYJudsP1yyfR348gq+d+dDiXVVI46UeL264EQytp3JufsS
        fwYiZGR0H/bl2G07IdoDTaED6g==
X-Google-Smtp-Source: ABdhPJwGxsHcbLvcYaXN2qrTqidhM1hKN02zmGXtgdzYbdQKgNcPjnuobNEDquVUL1R26dWR0qrPOg==
X-Received: by 2002:a17:903:2451:b0:141:7907:674e with SMTP id l17-20020a170903245100b001417907674emr12386715pls.45.1635549006674;
        Fri, 29 Oct 2021 16:10:06 -0700 (PDT)
Received: from google.com ([2620:15c:202:201:be89:1308:1b03:6bc4])
        by smtp.gmail.com with ESMTPSA id mi11sm11824219pjb.5.2021.10.29.16.10.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Oct 2021 16:10:06 -0700 (PDT)
Date:   Fri, 29 Oct 2021 16:10:04 -0700
From:   Brian Norris <briannorris@chromium.org>
To:     Sean Paul <sean@poorly.run>
Cc:     Neil Armstrong <narmstrong@baylibre.com>,
        Robert Foss <robert.foss@linaro.org>,
        Jonas Karlman <jonas@kwiboo.se>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        dri-devel@lists.freedesktop.org,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        stable@vger.kernel.org, Zain Wang <wzz@rock-chips.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sean Paul <seanpaul@chromium.org>
Subject: Re: [PATCH] drm/bridge: analogix_dp: Make PSR-disable non-blocking
Message-ID: <YXx/TJ6CAXHfTdrQ@google.com>
References: <20211020161724.1.I67612ea073c3306c71b46a87be894f79707082df@changeid>
 <20211021004015.GD2515@art_vandelay>
 <CA+ASDXNNPHfAVuN_Q7UJR6GLaepHghtovDUKyMKrVM_UboiM2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+ASDXNNPHfAVuN_Q7UJR6GLaepHghtovDUKyMKrVM_UboiM2A@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 20, 2021 at 06:23:35PM -0700, Brian Norris wrote:
> On Wed, Oct 20, 2021 at 5:40 PM Sean Paul <sean@poorly.run> wrote:
> > The actual latency gains from doing this synchronously are minimal since the
> > panel will display new content as soon as it can regardless of whether the
> > kernel is blocking. There is likely a perceptual difference, but that's only
> > because kernel is lying to userspace and skipping frames without consent.
> 
> Hmm, you might well be right about some of the first points (I'm still
> learning the DRM framework), but I'm a bit skeptical that the
> perceptual difference is "only" because we're cheating in some way.
> I'm not doing science here, and it's certainly not a blinded test, but
> I'm nearly certain this patch cuts out approx 50-80% of the cursor lag
> I see without this patch (relative to the current Chrome OS kernel). I
> don't see how cheating would produce a smoother cursor movement --
> we'd still be dropping frames, and the movement would appear jumpy
> somewhere along the way.

Aha, so I think I found {a,the} reason for some disagreement here:
looking at the eDP PSR spec, I see that while the current implementation
is looking for psr_state==DP_PSR_SINK_INACTIVE to signal PSR-exit
completion, the spec shows an intermediate state
(DP_PSR_SINK_ACTIVE_RESYNC == 4), where among other things, "the Sink
device must display the incoming active frames from the Source device
with no visible glitches and/or artifacts."

And it happens that we move to DP_PSR_SINK_ACTIVE_RESYNC somewhat
quickly (on the order of 20-40ms), while the move to
DP_PSR_SINK_INACTIVE is a good chunk longer (approx 60ms more). So
pre-commit-6c836d965bad might have been cheating a little (we'd claim
we're "done" about 20-40ms too early), but post-commit-6c836d965bad
we're waiting about 60ms too long.

I'll send v2 to make this block for DP_PSR_SINK_ACTIVE_RESYNC ||
DP_PSR_SINK_INACTIVE, which gets much or all of the same latency win,
and I'll try to document the reasons, etc., better.

I'll probably also include a patch to drop the 'blocking' parameter,
since it's unused, and gives the wrong idea about this state machine.

> In any case, I'm absolutely certain that mainline Linux performs much
> much worse with PSR than the current CrOS kernel, but there are some
> other potential reasons for that, such as the lack of an
> input-notifier [1].
...
> [1] This got locked up in "controversy":
> https://patchwork.kernel.org/project/linux-arm-kernel/patch/20180405095000.9756-25-enric.balletbo@collabora.com/

While I'm here: I also played with this a bit, and I still haven't
gotten all the details right, but I don't believe this alone will get
the latency wins we'd like. We still need something like the above.

Brian
