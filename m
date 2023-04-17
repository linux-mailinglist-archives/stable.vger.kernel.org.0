Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CAF16E4593
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 12:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbjDQKtD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 06:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbjDQKtA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 06:49:00 -0400
Received: from gloria.sntech.de (gloria.sntech.de [185.11.138.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C641D1BF
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 03:47:53 -0700 (PDT)
Received: from ip4d1634d3.dynamic.kabel-deutschland.de ([77.22.52.211] helo=diego.localnet)
        by gloria.sntech.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <heiko@sntech.de>)
        id 1poMN3-0002dr-Ug; Mon, 17 Apr 2023 12:46:05 +0200
From:   Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To:     dri-devel@lists.freedesktop.org,
        Sascha Hauer <s.hauer@pengutronix.de>
Cc:     Sandy Huang <hjc@rock-chips.com>,
        linux-rockchip@lists.infradead.org, kernel@pengutronix.de,
        Chris Morgan <macroalpha82@gmail.com>,
        =?ISO-8859-1?Q?K=F6ry?= Maincent <kory.maincent@bootlin.com>,
        Michael Riesch <michael.riesch@wolfvision.net>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, stable@vger.kernel.org
Subject: Re: [PATCH] drm/rockchip: vop2: fix suspend/resume
Date:   Mon, 17 Apr 2023 12:46:05 +0200
Message-ID: <7404631.18pcnM708K@diego>
In-Reply-To: <20230417094215.2049231-1-s.hauer@pengutronix.de>
References: <20230417094215.2049231-1-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sascha,

Am Montag, 17. April 2023, 11:42:15 CEST schrieb Sascha Hauer:
> During a suspend/resume cycle the VO power domain will be disabled and
> the VOP2 registers will reset to their default values. After that the
> cached register values will be out of sync and the read/modify/write
> operations we do on the window registers will result in bogus values
> written. Fix this by marking the regcache as dirty each time we disable
> the VOP2 and call regcache_sync() each time we enable it again. With
> this the VOP2 will show a picture after a suspend/resume cycle whereas
> without this the screen stays dark.
> 
> Fixes: 604be85547ce4 ("drm/rockchip: Add VOP2 driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>

somehow we overlapped with this v2 and me applying the original one [0]
to drm-misc. With drm-misc being a shared tree there is also no way back.

So if this v2 is better suited, could do a follow-up patch instead - on
top of your original one?

Thanks
Heiko



[0] https://cgit.freedesktop.org/drm/drm-misc/commit/?h=drm-misc-fixes&id=afa965a45e01e541cdbe5c8018226eff117610f0

> ---
> 
> Changes since v1:
> - Use regcache_mark_dirty()/regcache_sync() instead of regmap_reinit_cache()
> 
>  drivers/gpu/drm/rockchip/rockchip_drm_vop2.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
> index ba3b817895091..293c228a83f90 100644
> --- a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
> +++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
> @@ -839,6 +839,8 @@ static void vop2_enable(struct vop2 *vop2)
>  		return;
>  	}
>  
> +	regcache_sync(vop2->map);
> +
>  	if (vop2->data->soc_id == 3566)
>  		vop2_writel(vop2, RK3568_OTP_WIN_EN, 1);
>  
> @@ -867,6 +869,8 @@ static void vop2_disable(struct vop2 *vop2)
>  
>  	pm_runtime_put_sync(vop2->dev);
>  
> +	regcache_mark_dirty(vop2->map);
> +
>  	clk_disable_unprepare(vop2->aclk);
>  	clk_disable_unprepare(vop2->hclk);
>  }
> 




