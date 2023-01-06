Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFA9C65FFAB
	for <lists+stable@lfdr.de>; Fri,  6 Jan 2023 12:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbjAFLnJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Jan 2023 06:43:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233524AbjAFLnG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Jan 2023 06:43:06 -0500
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050:0:465::101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73E5969B1D;
        Fri,  6 Jan 2023 03:43:04 -0800 (PST)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4NpM0K0sZFz9sTD;
        Fri,  6 Jan 2023 12:42:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1673005377;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+MKewvQAOmy/Zn8oNArbj5sMzsVqtojw6uyLjAN8pxw=;
        b=RR68Uij7oOSXHjTTB6IOaiZ/WbfzNHq250+jiBWvglyo7RsQaixfIba1oTOVzP+MdTCWcf
        Jyzp435Zmhb4JdZueZrcdt7ZjPijmFyzYkIdLkAOyk/2VRX8pMXF+7pDR3Zgh7S901EvLS
        M9YeS46cK2eNA11KeWC1zaBgnwu5vISzjr8xftwfjXd7T8V9EwXqJ6jnEbkSVAx5s3y8V0
        Ucish6QEzF4eXtaehQG4YxrtXfk0Y7NMwXCqtJ4zfn8XBPoaI6SDM0n/zAvHSBA/1eMjBr
        /UbXykZOCpYV6Cg1HUXtLxoZmh/2XaE9ToBZ5CfSs0rtN2nUiCv6+py6c8s5jg==
Message-ID: <9455bc5b-2074-4f48-71a7-5c816ee19a78@mailbox.org>
Date:   Fri, 6 Jan 2023 12:42:54 +0100
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] drm/rockchip: vop: Leave vblank enabled in
 self-refresh
To:     Brian Norris <briannorris@chromium.org>,
        =?UTF-8?Q?Heiko_St=c3=bcbner?= <heiko@sntech.de>,
        Sean Paul <seanpaul@chromium.org>
Cc:     "kernelci.org bot" <bot@kernelci.org>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Sandy Huang <hjc@rock-chips.com>,
        linux-rockchip@lists.infradead.org, stable@vger.kernel.org
References: <20230105174001.1.I3904f697863649eb1be540ecca147a66e42bfad7@changeid>
 <20230105174001.2.Ic07cba4ab9a7bd3618a9e4258b8f92ea7d10ae5a@changeid>
Content-Language: en-CA
From:   =?UTF-8?Q?Michel_D=c3=a4nzer?= <michel.daenzer@mailbox.org>
In-Reply-To: <20230105174001.2.Ic07cba4ab9a7bd3618a9e4258b8f92ea7d10ae5a@changeid>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-MBO-RS-META: tq4hqps3dpqxcfuhdffygmxousg6bo4x
X-MBO-RS-ID: a6ab78268fa770b490a
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/6/23 02:40, Brian Norris wrote:
> If we disable vblank when entering self-refresh, vblank APIs (like
> DRM_IOCTL_WAIT_VBLANK) no longer work. But user space is not aware when
> we enter self-refresh, so this appears to be an API violation -- that
> DRM_IOCTL_WAIT_VBLANK fails with EINVAL whenever the display is idle and
> enters self-refresh.
> 
> The downstream driver used by many of these systems never used to
> disable vblank for PSR, and in fact, even upstream, we didn't do that
> until radically redesigning the state machine in commit 6c836d965bad
> ("drm/rockchip: Use the helpers for PSR").
> 
> Thus, it seems like a reasonable API fix to simply restore that
> behavior, and leave vblank enabled.
> 
> Note that this appears to potentially unbalance the
> drm_crtc_vblank_{off,on}() calls in some cases, but:
> (a) drm_crtc_vblank_on() documents this as OK and
> (b) if I do the naive balancing, I find state machine issues such that
>     we're not in sync properly; so it's easier to take advantage of (a).
> 
> Backporting notes:
> Marking as 'Fixes' commit 6c836d965bad ("drm/rockchip: Use the helpers
> for PSR"), but it probably depends on commit bed030a49f3e
> ("drm/rockchip: Don't fully disable vop on self refresh") as well.
> 
> We also need the previous patch ("drm/atomic: Allow vblank-enabled +
> self-refresh "disable""), of course.
> 
> Fixes: 6c836d965bad ("drm/rockchip: Use the helpers for PSR")
> Cc: <stable@vger.kernel.org>
> Link: https://lore.kernel.org/dri-devel/Y5itf0+yNIQa6fU4@sirena.org.uk/
> Reported-by: "kernelci.org bot" <bot@kernelci.org>
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> ---
> 
>  drivers/gpu/drm/rockchip/rockchip_drm_vop.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
> index fa1f4ee6d195..c541967114b4 100644
> --- a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
> +++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
> @@ -719,11 +719,11 @@ static void vop_crtc_atomic_disable(struct drm_crtc *crtc,
>  
>  	mutex_lock(&vop->vop_lock);
>  
> -	drm_crtc_vblank_off(crtc);
> -
>  	if (crtc->state->self_refresh_active)
>  		goto out;
>  
> +	drm_crtc_vblank_off(crtc);
> +
>  	/*
>  	 * Vop standby will take effect at end of current frame,
>  	 * if dsp hold valid irq happen, it means standby complete.

The out label immediately unlocks vop->vop_lock again, seems a bit pointless. :)

AFAICT the self_refresh_active case should just return immediately, the out label would also send any pending atomic commit completion event, which seems wrong now that the vblank interrupt is left enabled. (I also wonder if drm_crtc_vblank_off doesn't take care of that already, at least amdgpu doesn't do this explicitly AFAICT)


-- 
Earthling Michel Dänzer            |                  https://redhat.com
Libre software enthusiast          |         Mesa and Xwayland developer

