Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 514E049B272
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 12:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348571AbiAYK74 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 05:59:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379810AbiAYK5h (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 05:57:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12F85C061751;
        Tue, 25 Jan 2022 02:57:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A373E6168C;
        Tue, 25 Jan 2022 10:57:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E424C340E0;
        Tue, 25 Jan 2022 10:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643108252;
        bh=64WEc7pcjWdPNj74JeYR5KiScRakP+CCGpEFsBeMNVs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ILp0AsXbtwNkLs91cv8y7WBjlDnuvN+K1Drs34qWXyqB47YrVypA32xHwH5oDLZGE
         qvWGsxGhieFDWVB1EYbmU9XjDWp+O60vZwv6SVxXAsqR2ebcFG6xZ8GGVKKzJavKZa
         VxdFF6C+Xl4VMo7nblpSLHSStyt240YV/hz8hDqw=
Date:   Tue, 25 Jan 2022 11:57:29 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 262/563] uio: uio_dmem_genirq: Catch the Exception
Message-ID: <Ye/Xmfm4odaglfsc@kroah.com>
References: <20220124184024.407936072@linuxfoundation.org>
 <20220124184033.490683244@linuxfoundation.org>
 <20220125104725.GA19281@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220125104725.GA19281@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 25, 2022 at 11:47:25AM +0100, Pavel Machek wrote:
> Hi!
> 
> > From: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> > 
> > [ Upstream commit eec91694f927d1026974444eb6a3adccd4f1cbc2 ]
> > 
> > The return value of dma_set_coherent_mask() is not always 0.
> > To catch the exception in case that dma is not support the mask.
> > 
> > Fixes: 0a0c3b5a24bd ("Add new uio device for dynamic memory allocation")
> 
> 
> > +++ b/drivers/uio/uio_dmem_genirq.c
> > @@ -183,7 +183,11 @@ static int uio_dmem_genirq_probe(struct platform_device *pdev)
> >  		goto bad0;
> >  	}
> >  
> > -	dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
> > +	ret = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "DMA enable failed\n");
> > +		return ret;
> > +	}
> 
> Handing errors is good, but you may not directly return here as it
> would leak the resources. Something like this?
> 
> Signed-off-by: Pavel Machek <pavel@denx.de>
> 
> Best regards,
> 								Pavel
> 
> diff --git a/drivers/uio/uio_dmem_genirq.c b/drivers/uio/uio_dmem_genirq.c
> index bf39a424ea77..7b80d0c02735 100644
> --- a/drivers/uio/uio_dmem_genirq.c
> +++ b/drivers/uio/uio_dmem_genirq.c
> @@ -186,7 +186,7 @@ static int uio_dmem_genirq_probe(struct platform_device *pdev)
>  	ret = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
>  	if (ret) {
>  		dev_err(&pdev->dev, "DMA enable failed\n");
> -		return ret;
> +		goto bad0;
>  	}
>  
>  	priv->uioinfo = uioinfo;
> 
> 
> 
> -- 
> DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
> HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

Yeah, this commit should not be backported, I'll go drop it from
everywhere.  But the original commit in Linus's tree is fine as the
error handling is not like this anymore.

thanks,

greg k-h
