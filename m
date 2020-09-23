Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67A532751B8
	for <lists+stable@lfdr.de>; Wed, 23 Sep 2020 08:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbgIWGjl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Sep 2020 02:39:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:49530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726608AbgIWGjl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Sep 2020 02:39:41 -0400
Received: from sekiro (amontpellier-556-1-154-164.w109-210.abo.wanadoo.fr [109.210.130.164])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B305021D43;
        Wed, 23 Sep 2020 06:39:39 +0000 (UTC)
Date:   Wed, 23 Sep 2020 08:39:36 +0200
From:   Ludovic Desroches <ludovic.desroches@microchip.com>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dan.j.williams@intel.com,
        vkoul@kernel.org, stable@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: [PATCH 4.19] dmaengine: at_hdmac: Fix memory leak
Message-ID: <20200923063936.zs6yg7vb4zw4hzuf@sekiro>
References: <20200920082838.GA813@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200920082838.GA813@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 20, 2020 at 10:28:38AM +0200, Pavel Machek wrote:
> Date: Sun, 20 Sep 2020 10:28:38 +0200
> From: Pavel Machek <pavel@ucw.cz>
> To: linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
>  linux-arm-kernel@lists.infradead.org, dan.j.williams@intel.com,
>  vkoul@kernel.org, ludovic.desroches@microchip.com, stable@vger.kernel.org,
>  Greg KH <greg@kroah.com>
> Subject: [PATCH 4.19] dmaengine: at_hdmac: Fix memory leak
> 
> 
> This fixes memory leak in at_hdmac. Mainline does not have the same
> problem.
> 
> Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>
Acked-by: Ludovic Desroches <ludovic.desroches@microchip.com>

Thanks.

> 
> diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
> index 86427f6ba78c..0847b2055857 100644
> --- a/drivers/dma/at_hdmac.c
> +++ b/drivers/dma/at_hdmac.c
> @@ -1714,8 +1714,10 @@ static struct dma_chan *at_dma_xlate(struct of_phandle_args *dma_spec,
>  	atslave->dma_dev = &dmac_pdev->dev;
>  
>  	chan = dma_request_channel(mask, at_dma_filter, atslave);
> -	if (!chan)
> +	if (!chan) {
> +		kfree(atslave);
>  		return NULL;
> +	}
>  
>  	atchan = to_at_dma_chan(chan);
>  	atchan->per_if = dma_spec->args[0] & 0xff;
> 
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html



