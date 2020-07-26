Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AEA622E1CF
	for <lists+stable@lfdr.de>; Sun, 26 Jul 2020 20:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbgGZSDV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Jul 2020 14:03:21 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.54]:14981 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbgGZSDV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Jul 2020 14:03:21 -0400
X-Greylist: delayed 716 seconds by postgrey-1.27 at vger.kernel.org; Sun, 26 Jul 2020 14:03:20 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1595786599;
        s=strato-dkim-0002; d=gerhold.net;
        h=In-Reply-To:References:Message-ID:Subject:Cc:To:From:Date:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=sgrIlsRu3tTV7/SFO/NsvidkS88USSPVoIq5RUCV9cY=;
        b=mW6VxErJ1mnpiiI27BaRuU88RCUwcUqhIs/WtlBaHskpWsHRSn/Iwd26vAzEh5z+lE
        7CH0C0yTJmR+004aAVMOdvUF5w8ij624ADgGP6mnDzfQtNOetboC/EPf9jz73dQnY8qA
        ki/6nph3g+AQvKHOmk5UDnGjzyOyKpO0NoydrHoSI3g+cmtB3CXMHeG4uwSFRY1mg0hI
        n3uCkZDoSjprfQ5fqm0duftrQNwWj/GL+Z1m+HF9dq68V2p0lf/0y2bMI3y04flxRboT
        rPK7U015JYP+oi7ss6c3Vs2tQevlNjqGxJOFpoMzpJSoDAnkO6Nq31cgtZWmXW2JtFDC
        JVBg==
X-RZG-AUTH: ":P3gBZUipdd93FF5ZZvYFPugejmSTVR2nRPhVOQ/OcYgojyw4j34+u26zEodhPgRDZ8j8IcjDBg=="
X-RZG-CLASS-ID: mo00
Received: from gerhold.net
        by smtp.strato.de (RZmta 46.10.5 DYNA|AUTH)
        with ESMTPSA id Y0939ew6QHpII7L
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Sun, 26 Jul 2020 19:51:18 +0200 (CEST)
Date:   Sun, 26 Jul 2020 19:51:11 +0200
From:   Stephan Gerhold <stephan@gerhold.net>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     dri-devel@lists.freedesktop.org,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Sean Paul <sean@poorly.run>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH] drm/mcde: Fix stability issue
Message-ID: <20200726175111.GA5343@gerhold.net>
References: <20200718233323.3407670-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200718233323.3407670-1-linus.walleij@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jul 19, 2020 at 01:33:22AM +0200, Linus Walleij wrote:
> Whenener a display update was sent, apart from updating
> the memory base address we called mcde_display_send_one_frame()
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

I think this makes sense as a fix for the issue you described, so FWIW:
Acked-by: Stephan Gerhold <stephan@gerhold.net>

While looking at this I had a few thoughts for potential future patches:

 - Clearly mcde_display_send_one_frame() does not only send a single
   frame only in some cases (when te_sync = true), so maybe it should
   be named differently?

 - I was a bit confused because with this change we also call
   mcde_dsi_te_request() only once. Looking at the vendor driver the
   nova_dsilink_te_request() function that is very similar is only
   called within mcde_add_bta_te_oneshot_listener(), which is only
   called for MCDE_SYNCSRC_BTA.

   However, the rest of the MCDE code looks more similar to
   MCDE_SYNCSRC_TE0, which does not call that function in the vendor
   driver. I wonder if mcde_dsi_te_request() is needed at all?

Thanks,
Stephan
