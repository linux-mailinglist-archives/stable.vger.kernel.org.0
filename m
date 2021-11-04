Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C12604451CE
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 11:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231249AbhKDK7m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 06:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230511AbhKDK7l (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Nov 2021 06:59:41 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A25C061714
        for <stable@vger.kernel.org>; Thu,  4 Nov 2021 03:57:03 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id f8so6512085plo.12
        for <stable@vger.kernel.org>; Thu, 04 Nov 2021 03:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HI6OL2hUqXH1cbKP1U0E29lTlSyKIQ0fy7Vbh2BV6VE=;
        b=gceXa5J7JjyQ9Yag7zDi31i1euTnulZ386u0RoIgvYpdDrEsfOnAauedFneRhV6hLN
         +mrmOuudk0kLesFcw02jboeYzblDZDPsVQQqCBvd78oFf+eNXJpFPmkoZsL2qyoj/BlH
         l91f1XmK/IBXX4zgJ0JT/bL8s6uf2QzLPAK4kiQ5JWj60Ib87lQqRbzgsJFRYUThWOoa
         xR5RxDG2IjjzoO13W3jvy9rNx/WdezQbxjTOv0vVZH+cxccm+i+1PFDAGWnlArI66z0c
         RCJDqzx85fOZ6MDU/mPUOHCJmCB6U8AHYq1z9BLlEv85fCihqmzHpbiyjmrtj/D/ZwIb
         P3nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HI6OL2hUqXH1cbKP1U0E29lTlSyKIQ0fy7Vbh2BV6VE=;
        b=SI7E3J33xpbVYvvgNjEBcRxGdl2N5KNvR8iUUuyzS/oWtNrt7WMg70bEYUGYfbh8je
         clWQoR2YRFFd87bXLX52vQBkPkpGYfhIP58qj2fNgweqpp5Y2BASpeEMslSjVP/OqdJH
         jWyE/tfC2k/P72AXjqrk3++h2pNPoxcxmy6OyMsfUlWXp4YwamePgJ1r8peQth6aCo9r
         YmbT1Xtdt57KyrERc8Zo0oLKRbmxAhUNIm+CquhH2yfV6/WqBsGzX8HAr1S9D86j+uqu
         VqrE3VcWCAx/9yD+HWoSc5KzsbzlGPn/kj39mh1j0uJ2a/tAxn5uysRzPBKNyCGgK2NN
         Oi3A==
X-Gm-Message-State: AOAM531u5OpYDGAvZx0oTGjEH0WPPC6H1z98vcG81U1Nyu7eNFhIHO/C
        9OuxRIvQbO87ljf20rnm8RQfBSJ3dgU8x6c4bgtJ3w==
X-Google-Smtp-Source: ABdhPJxiNaI3r+C/e/5etdLrsfc4tUQRjvE+SamtOt+KPuwKZ5nCJFUQaUuYrSHt2fswdIiEse3pXH9Abe1ZChBJ+h8=
X-Received: by 2002:a17:90b:4a05:: with SMTP id kk5mr9467300pjb.232.1636023423138;
 Thu, 04 Nov 2021 03:57:03 -0700 (PDT)
MIME-Version: 1.0
References: <20211103135112.v3.1.I67612ea073c3306c71b46a87be894f79707082df@changeid>
In-Reply-To: <20211103135112.v3.1.I67612ea073c3306c71b46a87be894f79707082df@changeid>
From:   Robert Foss <robert.foss@linaro.org>
Date:   Thu, 4 Nov 2021 11:56:51 +0100
Message-ID: <CAG3jFys5iB-HwK1gc4FJFX0mAWbPLE8ZQH64LoKgXyhk+eSPFA@mail.gmail.com>
Subject: Re: [PATCH v3] drm/bridge: analogix_dp: Make PSR-exit block less
To:     Brian Norris <briannorris@chromium.org>
Cc:     Andrzej Hajda <andrzej.hajda@intel.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Sean Paul <sean@poorly.run>, Jonas Karlman <jonas@kwiboo.se>,
        dri-devel@lists.freedesktop.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        stable@vger.kernel.org, Zain Wang <wzz@rock-chips.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sean Paul <seanpaul@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

HI Brian,

On Wed, 3 Nov 2021 at 21:52, Brian Norris <briannorris@chromium.org> wrote:
>
> Prior to commit 6c836d965bad ("drm/rockchip: Use the helpers for PSR"),
> "PSR exit" used non-blocking analogix_dp_send_psr_spd(). The refactor
> started using the blocking variant, for a variety of reasons -- quoting
> Sean Paul's potentially-faulty memory:
>
> """
>  - To avoid racing a subsequent PSR entry (if exit takes a long time)
>  - To avoid racing disable/modeset
>  - We're not displaying new content while exiting PSR anyways, so there
>    is minimal utility in allowing frames to be submitted
>  - We're lying to userspace telling them frames are on the screen when
>    we're just dropping them on the floor
> """
>
> However, I'm finding that this blocking transition is causing upwards of
> 60+ ms of unneeded latency on PSR-exit, to the point that initial cursor
> movements when leaving PSR are unbearably jumpy.
>
> It turns out that we need to meet in the middle somewhere: Sean is right
> that we were "lying to userspace" with a non-blocking PSR-exit, but the
> new blocking behavior is also waiting too long:
>
> According to the eDP specification, the sink device must support PSR
> entry transitions from both state 4 (ACTIVE_RESYNC) and state 0
> (INACTIVE). It also states that in ACTIVE_RESYNC, "the Sink device must
> display the incoming active frames from the Source device with no
> visible glitches and/or artifacts."
>
> Thus, for our purposes, we only need to wait for ACTIVE_RESYNC before
> moving on; we are ready to display video, and subsequent PSR-entry is
> safe.
>
> Tested on a Samsung Chromebook Plus (i.e., Rockchip RK3399 Gru Kevin),
> where this saves about 60ms of latency, for PSR-exit that used to
> take about 80ms.
>
> Fixes: 6c836d965bad ("drm/rockchip: Use the helpers for PSR")
> Cc: <stable@vger.kernel.org>
> Cc: Zain Wang <wzz@rock-chips.com>
> Cc: Tomasz Figa <tfiga@chromium.org>
> Cc: Heiko Stuebner <heiko@sntech.de>
> Cc: Sean Paul <seanpaul@chromium.org>
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> Reviewed-by: Sean Paul <seanpaul@chromium.org>
> ---
> CC list is partially constructed from the commit message of the Fixed
> commit
>
> Changes in v3:
>  - Fix the exiting/entering comment (a reviewer noticed off-mailing-list
>    that I got it backwards)
>  - Add Reviewed-by
>
> Changes in v2:
>  - retitled subject (previous: "drm/bridge: analogix_dp: Make
>    PSR-disable non-blocking")
>  - instead of completely non-blocking, make this "less"-blocking
>  - more background (thanks Sean!)
>  - more specification details
>
>  drivers/gpu/drm/bridge/analogix/analogix_dp_reg.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/bridge/analogix/analogix_dp_reg.c b/drivers/gpu/drm/bridge/analogix/analogix_dp_reg.c
> index cab6c8b92efd..6a4f20fccf84 100644
> --- a/drivers/gpu/drm/bridge/analogix/analogix_dp_reg.c
> +++ b/drivers/gpu/drm/bridge/analogix/analogix_dp_reg.c
> @@ -998,11 +998,21 @@ int analogix_dp_send_psr_spd(struct analogix_dp_device *dp,
>         if (!blocking)
>                 return 0;
>
> +       /*
> +        * db[1]!=0: entering PSR, wait for fully active remote frame buffer.
> +        * db[1]==0: exiting PSR, wait for either
> +        *  (a) ACTIVE_RESYNC - the sink "must display the
> +        *      incoming active frames from the Source device with no visible
> +        *      glitches and/or artifacts", even though timings may still be
> +        *      re-synchronizing; or
> +        *  (b) INACTIVE - the transition is fully complete.
> +        */
>         ret = readx_poll_timeout(analogix_dp_get_psr_status, dp, psr_status,
>                 psr_status >= 0 &&
>                 ((vsc->db[1] && psr_status == DP_PSR_SINK_ACTIVE_RFB) ||
> -               (!vsc->db[1] && psr_status == DP_PSR_SINK_INACTIVE)), 1500,
> -               DP_TIMEOUT_PSR_LOOP_MS * 1000);
> +               (!vsc->db[1] && (psr_status == DP_PSR_SINK_ACTIVE_RESYNC ||
> +                                psr_status == DP_PSR_SINK_INACTIVE))),
> +               1500, DP_TIMEOUT_PSR_LOOP_MS * 1000);
>         if (ret) {
>                 dev_warn(dp->dev, "Failed to apply PSR %d\n", ret);
>                 return ret;
> --
> 2.34.0.rc0.344.g81b53c2807-goog
>


Applied to drm-misc-next
