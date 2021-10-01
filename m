Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE2241F662
	for <lists+stable@lfdr.de>; Fri,  1 Oct 2021 22:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355326AbhJAUjM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Oct 2021 16:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355319AbhJAUjM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Oct 2021 16:39:12 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBB86C06177E
        for <stable@vger.kernel.org>; Fri,  1 Oct 2021 13:37:27 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id 73so10423097qki.4
        for <stable@vger.kernel.org>; Fri, 01 Oct 2021 13:37:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=poorly.run; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zkZRE1eEAZyryz39bCaestf9STy5sTzg/yvpAeBoKL4=;
        b=CCfbyOwfd0P5t+5ZRImMnUUskPj72rArktg6RNaaUNyqXUeSgwpM0rbAcBAkglWGIq
         Ay6J1tK3tzZyS4rNAL4Ie+5m+CxzGQLqODv44oIGUpXsXPPErFtsUvyi1Ih5aIRK06jS
         keLPV3t/hH5HZ09dSBgthqijzUkoR9Z9U2xEZYGbrxp8yxMiltt7cYgV8CRb3z1N13is
         X/V1h6W7+jmpVATxfjdn5QbUBJ4FZV+O5R7shhJJj3Yc4pi04JGiICRUcPpMDr24Yv6U
         JQmu27ksNY9r75HUGveFA/TQIniku8vM8xLV89+TRl3DdYOt7mYt5pmsStjLkbN2Fgcd
         fbYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zkZRE1eEAZyryz39bCaestf9STy5sTzg/yvpAeBoKL4=;
        b=4l9qEzE/GsEhRx+5d1cEbQ2yYqiwhTnnfyvocr4g8UP4FgpWd/1LS0dAgdCEokuxsU
         qUP7TKPJlvxVXiYVtG+svGw0kkey+YARg4MsGP5YLT1AANss5BhPGXGe7K2/QU8V+aKS
         8e45t7YpY2ivrla2xLpcL8l3dGIkaDkNjc3ErY4dNXgQ2M5TOAgYTYuCOQR4Rtr9FCKd
         PoADU8jfsi3jESj+KGQDD4N6aXUiBnPEIxOz3f5DpjbnBHaTRejS7r6cZnOFIE5TK2zY
         ZkUII+ux7V3ksXK7MESJbInqc1aggsi/xHZTPzicxzBMU2oQspUTco7w/Fo6qrwBbHXu
         5yxA==
X-Gm-Message-State: AOAM533CJRFlxx6h8abPw0tMDor+RW6MwPC6PIFxL+n6zI9VQCJO44BM
        k4oyjKxF+lUujxSzcsqKCAsWCQ==
X-Google-Smtp-Source: ABdhPJyanMpqt2duCpwpvAmH2PwIWFc4RUPjx+nuDVdS38gdaqmbFEoZOY+04aefRITy3t9qRTOsoA==
X-Received: by 2002:ae9:e895:: with SMTP id a143mr55119qkg.113.1633120646890;
        Fri, 01 Oct 2021 13:37:26 -0700 (PDT)
Received: from localhost ([167.100.64.199])
        by smtp.gmail.com with ESMTPSA id i8sm3957487qtp.55.2021.10.01.13.37.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 01 Oct 2021 13:37:26 -0700 (PDT)
Date:   Fri, 1 Oct 2021 16:37:22 -0400
From:   Sean Paul <sean@poorly.run>
To:     Brian Norris <briannorris@chromium.org>
Cc:     Andrzej Hajda <a.hajda@samsung.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        dri-devel@lists.freedesktop.org,
        linux-rockchip@lists.infradead.org,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        linux-kernel@vger.kernel.org, Jonas Karlman <jonas@kwiboo.se>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        stable@vger.kernel.org, Tomeu Vizoso <tomeu.vizoso@collabora.com>
Subject: Re: [PATCH] drm/brdige: analogix_dp: Grab runtime PM reference for
 DP-AUX
Message-ID: <20211001203722.GZ2515@art_vandelay>
References: <20210929144010.1.I773a08785666ebb236917b0c8e6c05e3de471e75@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210929144010.1.I773a08785666ebb236917b0c8e6c05e3de471e75@changeid>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 29, 2021 at 02:41:03PM -0700, Brian Norris wrote:
> If the display is not enable()d, then we aren't holding a runtime PM
> reference here. Thus, it's easy to accidentally cause a hang, if user
> space is poking around at /dev/drm_dp_aux0 at the "wrong" time.
> 
> Let's get the panel and PM state right before trying to talk AUX.
> 
> Fixes: 0d97ad03f422 ("drm/bridge: analogix_dp: Remove duplicated code")
> Cc: <stable@vger.kernel.org>
> Cc: Tomeu Vizoso <tomeu.vizoso@collabora.com>
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> ---
> 
>  .../gpu/drm/bridge/analogix/analogix_dp_core.c  | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
> index b7d2e4449cfa..a1b553904b85 100644
> --- a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
> +++ b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
> @@ -1632,8 +1632,23 @@ static ssize_t analogix_dpaux_transfer(struct drm_dp_aux *aux,
>  				       struct drm_dp_aux_msg *msg)
>  {
>  	struct analogix_dp_device *dp = to_dp(aux);
> +	int ret, ret2;
>  
> -	return analogix_dp_transfer(dp, msg);
> +	ret = analogix_dp_prepare_panel(dp, true, false);
> +	if (ret) {
> +		DRM_DEV_ERROR(dp->dev, "Failed to prepare panel (%d)\n", ret);

s/DRM_DEV_ERROR/drm_err/

> +		return ret;
> +	}
> +
> +	pm_runtime_get_sync(dp->dev);
> +	ret = analogix_dp_transfer(dp, msg);
> +	pm_runtime_put(dp->dev);
> +
> +	ret2 = analogix_dp_prepare_panel(dp, false, false);
> +	if (ret2)
> +		DRM_DEV_ERROR(dp->dev, "Failed to unprepare panel (%d)\n", ret2);

What's the reasoning for not propagating unprepare failures? I feel like that
should be fair game.

> +
> +	return ret;
>  }
>  
>  struct analogix_dp_device *
> -- 
> 2.33.0.685.g46640cef36-goog
> 

-- 
Sean Paul, Software Engineer, Google / Chromium OS
