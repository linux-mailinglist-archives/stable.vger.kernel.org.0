Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84C811D6652
	for <lists+stable@lfdr.de>; Sun, 17 May 2020 08:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbgEQGVL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 May 2020 02:21:11 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:52342 "EHLO
        asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726740AbgEQGVK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 May 2020 02:21:10 -0400
Received: from ravnborg.org (unknown [158.248.194.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by asavdk4.altibox.net (Postfix) with ESMTPS id 28BB5804B9;
        Sun, 17 May 2020 08:21:07 +0200 (CEST)
Date:   Sun, 17 May 2020 08:21:05 +0200
From:   Sam Ravnborg <sam@ravnborg.org>
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
        Rob Herring <robh+dt@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, od@zcrc.me, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 05/12] gpu/drm: Ingenic: Fix opaque pointer casted to
 wrong type
Message-ID: <20200517062105.GD609600@ravnborg.org>
References: <20200516215057.392609-1-paul@crapouillou.net>
 <20200516215057.392609-5-paul@crapouillou.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200516215057.392609-5-paul@crapouillou.net>
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.3 cv=MOBOZvRl c=1 sm=1 tr=0
        a=UWs3HLbX/2nnQ3s7vZ42gw==:117 a=UWs3HLbX/2nnQ3s7vZ42gw==:17
        a=kj9zAlcOel0A:10 a=VwQbUJbxAAAA:8 a=ER_8r6IbAAAA:8 a=7gkXJVJtAAAA:8
        a=e5mUnYsNAAAA:8 a=qQq3a1_-SCO9fxz2cd8A:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=9LHmKk7ezEChjTCyhBa9:22
        a=E9Po1WZjFZOl8hwRPBS3:22 a=Vxmtnl_E_bksehYqCbjh:22
        a=pHzHmUro8NiASowvMSCR:22 a=nt3jZW36AmriUCFCBwmW:22
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 16, 2020 at 11:50:50PM +0200, Paul Cercueil wrote:
> The opaque pointer passed to the IRQ handler is a pointer to the
> drm_device, not a pointer to our ingenic_drm structure.
> 
> It still worked, because our ingenic_drm structure contains the
> drm_device as its first field, so the pointer received had the same
> value, but this was not semantically correct.
> 
> Cc: stable@vger.kernel.org # v5.3
> Fixes: 90b86fcc47b4 ("DRM: Add KMS driver for the Ingenic JZ47xx SoCs")
> Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
> ---
>  drivers/gpu/drm/ingenic/ingenic-drm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/ingenic/ingenic-drm.c b/drivers/gpu/drm/ingenic/ingenic-drm.c
> index 0c472382a08b..97244462599b 100644
> --- a/drivers/gpu/drm/ingenic/ingenic-drm.c
> +++ b/drivers/gpu/drm/ingenic/ingenic-drm.c
> @@ -476,7 +476,7 @@ static int ingenic_drm_encoder_atomic_check(struct drm_encoder *encoder,
>  
>  static irqreturn_t ingenic_drm_irq_handler(int irq, void *arg)
>  {
> -	struct ingenic_drm *priv = arg;
> +	struct ingenic_drm *priv = drm_device_get_priv(arg);
>  	unsigned int state;
>  
>  	regmap_read(priv->map, JZ_REG_LCD_STATE, &state);
> -- 
> 2.26.2
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel
