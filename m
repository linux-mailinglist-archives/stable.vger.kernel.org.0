Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6364B4AD8D8
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 14:16:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348685AbiBHNQB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 08:16:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376423AbiBHNFi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 08:05:38 -0500
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8EF7C03FEC0;
        Tue,  8 Feb 2022 05:05:36 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: andrzej.p)
        with ESMTPSA id 8B08C1F445AC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1644325534;
        bh=+LYk/UmBswNwBd6wWfrZcVl5V3vV0QlUdcWtoUKbDuQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=IanUsb20GeXPoeXi8WV425L3Z8GSZZDMd0uxkgXYPzceXXkZJh9UCows5Csu7Wvvc
         B3yIDNzZT4Xy4oCBqx+wDXMTsql5c19joggI4o0NCcavdvhcu3HPkMpjZ/JTdD6lWt
         1ci/i++lztI4rFx09BtouRBuOS0jm/JXSjF08/fdua7R5mT+LTCOVWOseeYR57JO/y
         F8xL5qxuJXEYjUHYtf3h4CECr7JoSHdDDNkOa0IoiA0+n5gq7baWcQ99XTE/UFrhyZ
         qQy+aeuj0dfnjFYL/C7+b/vqY40oUyVHUW3CjmgJ3qxzYqA3twd6xi4DcFWuX0Xd6J
         8kaYKsldRv48Q==
Message-ID: <73b30627-2908-8472-01db-d07e176ce129@collabora.com>
Date:   Tue, 8 Feb 2022 14:05:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] drm/rockchip: vop: Correct RK3399 VOP register fields
Content-Language: en-US
To:     Brian Norris <briannorris@chromium.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@linux.ie>,
        =?UTF-8?Q?Heiko_St=c3=bcbner?= <heiko@sntech.de>
Cc:     Sandy Huang <hjc@rock-chips.com>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        stable@vger.kernel.org, Mark Yao <markyao0591@gmail.com>
References: <20220119161104.1.I1d01436bef35165a8cdfe9308789c0badb5ff46a@changeid>
From:   Andrzej Pietrasiewicz <andrzej.p@collabora.com>
In-Reply-To: <20220119161104.1.I1d01436bef35165a8cdfe9308789c0badb5ff46a@changeid>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Brian,

Sorry about the delay.

W dniu 20.01.2022 o 01:11, Brian Norris pisze:
> Commit 7707f7227f09 ("drm/rockchip: Add support for afbc") switched up
> the rk3399_vop_big[] register windows, but it did so incorrectly.
> 
> The biggest problem is in rk3288_win23_data[] vs.
> rk3368_win23_data[] .format field:
> 
>    RK3288's format: VOP_REG(RK3288_WIN2_CTRL0, 0x7, 1)
>    RK3368's format: VOP_REG(RK3368_WIN2_CTRL0, 0x3, 5)
> 
> Bits 5:6 (i.e., shift 5, mask 0x3) are correct for RK3399, according to
> the TRM.
> 
> There are a few other small differences between the 3288 and 3368
> definitions that were swapped in commit 7707f7227f09. I reviewed them to
> the best of my ability according to the RK3399 TRM and fixed them up.
> 
> This fixes IOMMU issues (and display errors) when testing with BG24
> color formats.
> 
> Fixes: 7707f7227f09 ("drm/rockchip: Add support for afbc")
> Cc: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Brian Norris <briannorris@chromium.org>

Tested-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>

> ---
> I'd appreciate notes or testing from Andrzej, since I'm not sure how he
> tested his original AFBC work.
> 
>   drivers/gpu/drm/rockchip/rockchip_vop_reg.c | 8 +++++---
>   1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpu/drm/rockchip/rockchip_vop_reg.c b/drivers/gpu/drm/rockchip/rockchip_vop_reg.c
> index 1f7353f0684a..798b542e5916 100644
> --- a/drivers/gpu/drm/rockchip/rockchip_vop_reg.c
> +++ b/drivers/gpu/drm/rockchip/rockchip_vop_reg.c
> @@ -902,6 +902,7 @@ static const struct vop_win_phy rk3399_win01_data = {
>   	.enable = VOP_REG(RK3288_WIN0_CTRL0, 0x1, 0),
>   	.format = VOP_REG(RK3288_WIN0_CTRL0, 0x7, 1),
>   	.rb_swap = VOP_REG(RK3288_WIN0_CTRL0, 0x1, 12),
> +	.x_mir_en = VOP_REG(RK3288_WIN0_CTRL0, 0x1, 21),
>   	.y_mir_en = VOP_REG(RK3288_WIN0_CTRL0, 0x1, 22),
>   	.act_info = VOP_REG(RK3288_WIN0_ACT_INFO, 0x1fff1fff, 0),
>   	.dsp_info = VOP_REG(RK3288_WIN0_DSP_INFO, 0x0fff0fff, 0),
> @@ -912,6 +913,7 @@ static const struct vop_win_phy rk3399_win01_data = {
>   	.uv_vir = VOP_REG(RK3288_WIN0_VIR, 0x3fff, 16),
>   	.src_alpha_ctl = VOP_REG(RK3288_WIN0_SRC_ALPHA_CTRL, 0xff, 0),
>   	.dst_alpha_ctl = VOP_REG(RK3288_WIN0_DST_ALPHA_CTRL, 0xff, 0),
> +	.channel = VOP_REG(RK3288_WIN0_CTRL2, 0xff, 0),
>   };
>   
>   /*
> @@ -922,11 +924,11 @@ static const struct vop_win_phy rk3399_win01_data = {
>   static const struct vop_win_data rk3399_vop_win_data[] = {
>   	{ .base = 0x00, .phy = &rk3399_win01_data,
>   	  .type = DRM_PLANE_TYPE_PRIMARY },
> -	{ .base = 0x40, .phy = &rk3288_win01_data,
> +	{ .base = 0x40, .phy = &rk3368_win01_data,
>   	  .type = DRM_PLANE_TYPE_OVERLAY },
> -	{ .base = 0x00, .phy = &rk3288_win23_data,
> +	{ .base = 0x00, .phy = &rk3368_win23_data,
>   	  .type = DRM_PLANE_TYPE_OVERLAY },
> -	{ .base = 0x50, .phy = &rk3288_win23_data,
> +	{ .base = 0x50, .phy = &rk3368_win23_data,
>   	  .type = DRM_PLANE_TYPE_CURSOR },
>   };
>   

