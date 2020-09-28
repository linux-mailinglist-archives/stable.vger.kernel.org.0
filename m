Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC1E27B02A
	for <lists+stable@lfdr.de>; Mon, 28 Sep 2020 16:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgI1OnG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 10:43:06 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:47960 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgI1OnD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Sep 2020 10:43:03 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: eballetbo)
        with ESMTPSA id 5769329A5CD
Subject: Re: [PATCH v1 2/2] drm/rockchip: fix warning from cdn_dp_resume
To:     Sam Ravnborg <sam@ravnborg.org>, dri-devel@lists.freedesktop.org,
        Heiko Stuebner <heiko@sntech.de>,
        Thomas Zimmermann <tzimmermann@suse.de>
Cc:     linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org,
        Sandy Huang <hjc@rock-chips.com>, stable@vger.kernel.org
References: <20200925215524.2899527-1-sam@ravnborg.org>
 <20200925215524.2899527-3-sam@ravnborg.org>
From:   Enric Balletbo i Serra <enric.balletbo@collabora.com>
Message-ID: <dcc5d70e-5c95-be50-a6bf-cee62bed6bf6@collabora.com>
Date:   Mon, 28 Sep 2020 16:42:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200925215524.2899527-3-sam@ravnborg.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sam,

Thank you for your patch.

On 25/9/20 23:55, Sam Ravnborg wrote:
> Commit 7c49abb4c2f8 ("drm/rockchip: cdn-dp-core: Make cdn_dp_core_suspend/resume static")
> introduced the following warning in some builds:
> 
> cdn-dp-core.c:1124:12: warning: ‘cdn_dp_resume’ defined but not used
>  1124 | static int cdn_dp_resume(struct device *dev)
>       |            ^~~~~~~~~~~~~
> 
> Fix this by defining cdn_dp_resume __maybe_unused
> 
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> Fixes: 7c49abb4c2f8 ("drm/rockchip: cdn-dp-core: Make cdn_dp_core_suspend/resume static")
> Cc: Enric Balletbo i Serra <enric.balletbo@collabora.com>
> Cc: Heiko Stuebner <heiko@sntech.de>
> Cc: Sandy Huang <hjc@rock-chips.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-rockchip@lists.infradead.org
> Cc: <stable@vger.kernel.org> # v5.8+
> ---

Hopefully this time this change lands ;-) Similar patches [1], [2], [3], were
sent in the past by different authors but for some reason never reached upstream.

[1] https://lkml.org/lkml/2020/4/28/1703
[2] https://www.spinics.net/lists/dri-devel/msg268818.html
[3] https://lkml.org/lkml/2020/8/10/1412

>  drivers/gpu/drm/rockchip/cdn-dp-core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/rockchip/cdn-dp-core.c b/drivers/gpu/drm/rockchip/cdn-dp-core.c
> index a4a45daf93f2..1162e321aaed 100644
> --- a/drivers/gpu/drm/rockchip/cdn-dp-core.c
> +++ b/drivers/gpu/drm/rockchip/cdn-dp-core.c
> @@ -1121,7 +1121,7 @@ static int cdn_dp_suspend(struct device *dev)

Shouldn't cdn_dp_suspend also have a __maybe_unused?

With that,

Reviewed-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>

>  	return ret;
>  }
>  
> -static int cdn_dp_resume(struct device *dev)
> +static int __maybe_unused cdn_dp_resume(struct device *dev)
>  {
>  	struct cdn_dp_device *dp = dev_get_drvdata(dev);
>  
> 
