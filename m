Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1566922E18D
	for <lists+stable@lfdr.de>; Sun, 26 Jul 2020 19:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgGZRFh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Jul 2020 13:05:37 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:52180 "EHLO
        asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726117AbgGZRFh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Jul 2020 13:05:37 -0400
Received: from ravnborg.org (unknown [188.228.123.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by asavdk4.altibox.net (Postfix) with ESMTPS id D22DF804D9;
        Sun, 26 Jul 2020 19:05:33 +0200 (CEST)
Date:   Sun, 26 Jul 2020 19:05:32 +0200
From:   Sam Ravnborg <sam@ravnborg.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     dri-devel@lists.freedesktop.org,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Sean Paul <sean@poorly.run>, stable@vger.kernel.org,
        Stephan Gerhold <stephan@gerhold.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] drm/mcde: Fix stability issue
Message-ID: <20200726170532.GD3275923@ravnborg.org>
References: <20200718233323.3407670-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200718233323.3407670-1-linus.walleij@linaro.org>
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.3 cv=aP3eV41m c=1 sm=1 tr=0
        a=S6zTFyMACwkrwXSdXUNehg==:117 a=S6zTFyMACwkrwXSdXUNehg==:17
        a=kj9zAlcOel0A:10 a=j8Cu_9a8AAAA:8 a=VwQbUJbxAAAA:8 a=KKAkSRfTAAAA:8
        a=7gkXJVJtAAAA:8 a=e5mUnYsNAAAA:8 a=MbAr_5FlAAiZ0vvuv2IA:9
        a=CjuIK1q_8ugA:10 a=A2jcf3dkIZPIRbEE90CI:22 a=AjGcO6oz07-iQ99wixmX:22
        a=cvBusfyB2V15izCimMoJ:22 a=E9Po1WZjFZOl8hwRPBS3:22
        a=Vxmtnl_E_bksehYqCbjh:22
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Linus.

On Sun, Jul 19, 2020 at 01:33:22AM +0200, Linus Walleij wrote:
> Whenener a display update was sent, apart from updating
s/Whenener/Whenever
> the memory base address we called mcde_display_send_one_frame()
                         ^ insert comma?

> which also sent a command to the display requesting the TE IRQ
> and enabling the FIFO.
> 
> When continous updates are running this is wrong: we need
> to only send this to start the flow to the display on
> the very first update. This lead to the display pipeline
> locking up and crashing.
> 
> Check if the flow is already running and in that case
> do not call mcde_display_send_one_frame().
> 
> This fixes crashes on the Samsung GT-S7710 (Skomer).
> 
> Cc: Stephan Gerhold <stephan@gerhold.net>
> Cc: stable@vger.kernel.org
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Patch looks fine.
Acked-by: Sam Ravnborg <sam@ravnborg.org>

> ---
>  drivers/gpu/drm/mcde/mcde_display.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpu/drm/mcde/mcde_display.c b/drivers/gpu/drm/mcde/mcde_display.c
> index 212aee60cf61..1d8ea8830a17 100644
> --- a/drivers/gpu/drm/mcde/mcde_display.c
> +++ b/drivers/gpu/drm/mcde/mcde_display.c
> @@ -1086,9 +1086,14 @@ static void mcde_display_update(struct drm_simple_display_pipe *pipe,
>  	 */
>  	if (fb) {
>  		mcde_set_extsrc(mcde, drm_fb_cma_get_gem_addr(fb, pstate, 0));
> -		if (!mcde->video_mode)
> -			/* Send a single frame using software sync */
> -			mcde_display_send_one_frame(mcde);
> +		if (!mcde->video_mode) {
> +			/*
> +			 * Send a single frame using software sync if the flow
> +			 * is not active yet.
> +			 */
> +			if (mcde->flow_active == 0)
> +				mcde_display_send_one_frame(mcde);
> +		}
>  		dev_info_once(mcde->dev, "sent first display update\n");
>  	} else {
>  		/*
> -- 
> 2.26.2
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel
