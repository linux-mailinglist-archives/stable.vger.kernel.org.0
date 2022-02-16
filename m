Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B75E84B7C08
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 01:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245111AbiBPAlT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 19:41:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245091AbiBPAlT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 19:41:19 -0500
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBFCAF8B96
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 16:41:04 -0800 (PST)
Received: by mail-oi1-x233.google.com with SMTP id 13so810907oiz.12
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 16:41:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D6kOuJ3sFRAfxlfcJvGvD0WdwWS/gNKzCWsG8Lno9eY=;
        b=iX4gNuGKYZNG9hM1lAyY7Nf/bZLA5KTwEcEMmT3v/Wkao8xyAeGNUtg1UxOYaO42aC
         XZstBpPHLaxU6YJNIWfSub+ULsZeKmX/L7ae/TPdpY5zEOmW7JYZjAIs56FeEgSA/CLE
         wG0hkTYT7TAeJo1PVmmZFXS/PQWpRu2EtuOzM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D6kOuJ3sFRAfxlfcJvGvD0WdwWS/gNKzCWsG8Lno9eY=;
        b=m5rG5Ub0pa/EiU5qNP+7YhptIjUL4RrrmpWC0XI+nSxJapLtRuaEBzyCpJhEgoeO6V
         H/9Mg8KJZGm8qQ7UB03wvf+13bFW0kAMCx0YGNHu16B6kgMJ4vYemTlPTnVw6HIBj/Wt
         AvMoMHO4BQgzzMGrXmgyCZWGOdHU8XjOYfd9y1MzS+yq71GKAK0UXHKIybybddm45Y+R
         T/r8TKUpnWz1nyaAa7cIY4wdMtfv62bW7DDJd5721J1fx6c5zGpslVlYWRNNneX6/aXL
         FRi50Cz2v02FTH9CckXlC26qKG/qhJZyXMdqHAe3Acqx1Aw3qh/cYf8YxAbUNupNRvmq
         RQyg==
X-Gm-Message-State: AOAM532B6QT4EKpRdvGNQH5cJ464yT8uA9u9pn5Nm44hLi9SS0VJJwNQ
        1o6Bl70anM1uZW2k5TttK3vy2NUAw2BiAA==
X-Google-Smtp-Source: ABdhPJwCTVfB+YO8Kf6PYn/ta9ZnFS1dFpasw4+9y6PHnvZKNRx0HCMab9j88q2AqIc7VJJ33nhDWg==
X-Received: by 2002:a05:6808:e8d:b0:2d4:1d34:b970 with SMTP id k13-20020a0568080e8d00b002d41d34b970mr1882435oil.330.1644972063918;
        Tue, 15 Feb 2022 16:41:03 -0800 (PST)
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com. [209.85.167.169])
        by smtp.gmail.com with ESMTPSA id u32sm11138020oiw.28.2022.02.15.16.41.01
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Feb 2022 16:41:02 -0800 (PST)
Received: by mail-oi1-f169.google.com with SMTP id r19so853458oic.5
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 16:41:01 -0800 (PST)
X-Received: by 2002:a05:6808:1b29:b0:2ce:6ee7:2cc5 with SMTP id
 bx41-20020a0568081b2900b002ce6ee72cc5mr2715980oib.243.1644972061370; Tue, 15
 Feb 2022 16:41:01 -0800 (PST)
MIME-Version: 1.0
References: <20211001144212.v2.1.I773a08785666ebb236917b0c8e6c05e3de471e75@changeid>
 <CAD=FV=XU0bYVZk+-jPWZVoODW79QXOJ=NQy+RH=fYyX+LCZb2Q@mail.gmail.com>
 <CA+ASDXPXKVwcZGYoagJYPm4E7DzaJmEVEv2FANhLH-juJw+r+Q@mail.gmail.com> <CAD=FV=VYe1rLKANQ8eom7g8x1v6_s_OYnX819Ax4m7O3UwDHmg@mail.gmail.com>
In-Reply-To: <CAD=FV=VYe1rLKANQ8eom7g8x1v6_s_OYnX819Ax4m7O3UwDHmg@mail.gmail.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Tue, 15 Feb 2022 16:40:49 -0800
X-Gmail-Original-Message-ID: <CA+ASDXO8c4dK31p=kvBABJQsDUs20qVHM6NxYf1JQDCr2oswAw@mail.gmail.com>
Message-ID: <CA+ASDXO8c4dK31p=kvBABJQsDUs20qVHM6NxYf1JQDCr2oswAw@mail.gmail.com>
Subject: Re: [PATCH v2] drm/bridge: analogix_dp: Grab runtime PM reference for DP-AUX
To:     Doug Anderson <dianders@chromium.org>
Cc:     Andrzej Hajda <a.hajda@samsung.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sean Paul <sean@poorly.run>, Jonas Karlman <jonas@kwiboo.se>,
        LKML <linux-kernel@vger.kernel.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "# 4.0+" <stable@vger.kernel.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 15, 2022 at 3:46 PM Doug Anderson <dianders@chromium.org> wrote:
> On Tue, Feb 15, 2022 at 2:52 PM Brian Norris <briannorris@chromium.org> wrote:
> > It still makes me wonder what the point
> > of the /dev/drm_dp_aux<N> interface is though, because it seems like
> > you're pretty much destined to not have reliable operation through
> > that means.
>
> I can't say I have tons of history for those files. I seem to recall
> maybe someone using them to have userspace tweak the embedded
> backlight on some external DP connected panels? I think we also might
> use it in Chrome OS to update the firmware of panels (dunno if
> internal or external) in some cases too? I suspect that it works OK
> for certain situations but it's really not going to work in all
> cases...

Yes, I believe I'm only submitting patches like this because fwupd
apparently likes to indiscriminately whack at dpaux devices:
https://github.com/fwupd/fwupd/tree/main/plugins/synaptics-mst#kernel-dp-aux-interface

That seems like a bad idea.

(We've already disabled that plugin on these systems, but it seems
wise not to leave the stumbling block here for the next time.)

> I suppose this just further proves the point that this is really not a
> great interface to rely on. It's fine for debugging during hardware
> bringup and I guess in limited situations it might be OK, but it's
> really not something we want userspace tweaking with anyway, right? In
> general I expect it's up to the kernel to be controlling peripherals
> on the DP AUX bus. The kernel should have a backlight driver and
> should do the AUX transfers needed. Having userspace in there mucking
> with things is just a bad idea. I mean, userspace also doesn't know
> when a panel has been power cycled and potentially lost any changes
> that they might have written, right?
>
> I sorta suspect that most of the uses of these files are there because
> there wasn't a kernel driver and someone thought that doing it in
> userspace was the way to go?

*shrug* beats me.

Brian
