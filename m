Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E373E179688
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 18:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbgCDRSU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 12:18:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:45238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726561AbgCDRST (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Mar 2020 12:18:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D446F22B48;
        Wed,  4 Mar 2020 17:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583342299;
        bh=MUbhpaPxtsmIxbxMQKKGkxYQ5ffHIsrSQGT8xxkgWIg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nA/NS7xr+r9Gf2v19TrGeKMDS0uIKF5sHkAAdYdey463HUKAaDyH4gka9R5JPLeJR
         hN+ysmVb9Bj04mXnzzctc2ESDEW197wwzEGd26TvfFev0+P/IFgWEd++DIYezV5+cB
         5tgAkHKC9jKZ73suIBR2WDBp/XBXLUIS0eliR+M4=
Date:   Wed, 4 Mar 2020 18:18:17 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Stephen Boyd <swboyd@chromium.org>,
        Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        Rob Clark <robdclark@gmail.com>,
        Sean Paul <seanpaul@chromium.org>,
        Douglas Anderson <dianders@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 04/87] drm/msm: Set dma maximum segment size for mdss
Message-ID: <20200304171817.GC1852712@kroah.com>
References: <20200303174349.075101355@linuxfoundation.org>
 <20200303174349.401386271@linuxfoundation.org>
 <20200304151316.GA2367@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304151316.GA2367@duo.ucw.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 04, 2020 at 04:13:16PM +0100, Pavel Machek wrote:
> Hi!
> 
> > Turning on CONFIG_DMA_API_DEBUG_SG results in the following error:
> > 
> > [   12.078665] msm ae00000.mdss: DMA-API: mapping sg segment longer than device claims to support [len=3526656] [max=65536]
> > [   12.089870] WARNING: CPU: 6 PID: 334 at
> > /mnt/host/source/src/third_party/kernel/v4.19/kernel/dma/debug.c:1301
> > debug_dma_map_sg+0x1dc/0x318
> 
> This one leaks resources in the (very improbable) case of error; it
> needs to goto cleanup instead of simply returning.
> 
> > +++ b/drivers/gpu/drm/msm/msm_drv.c
> > @@ -492,6 +492,14 @@ static int msm_drm_init(struct device *dev, struct drm_driver *drv)
> >  	if (ret)
> >  		goto err_msm_uninit;
> >  
> > +	if (!dev->dma_parms) {
> > +		dev->dma_parms = devm_kzalloc(dev, sizeof(*dev->dma_parms),
> > +					      GFP_KERNEL);
> > +		if (!dev->dma_parms)
> > +			return -ENOMEM;
> > +	}
> > +	dma_set_max_seg_size(dev, DMA_BIT_MASK(32));
> > +
> >  	msm_gem_shrinker_init(ddev);
> >  

Can you submit a patch to fix it?

thanks,

greg k-h
