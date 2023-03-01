Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE39B6A6F57
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 16:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbjCAPZC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 10:25:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbjCAPZA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 10:25:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96A97149A4
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 07:24:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D27F2B81076
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 15:24:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4409DC433D2;
        Wed,  1 Mar 2023 15:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677684278;
        bh=1o4V3CraZb2NjqmjiP+u4aQbQxd7Lj4npiLBIYJkscg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JxDGm9UqnulMqPosrzncuM2Xf97kXvjguyG+DM9Sh0WlF7Ll1AB7o8dtGp8RoJvuE
         NUbvE/J9WOQp4eGhB6wsCxkeaM4+PHjxG8XIAxc1ZKt4WsTLB43szRj8uv0b9J5lLI
         ybLhL+sy08FAXNmlf+oWiHyQziatA1/ZCsI13sSs=
Date:   Wed, 1 Mar 2023 16:24:36 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     stable@vger.kernel.org, sashal@kernel.org,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Vinod Koul <vkoul@kernel.org>
Subject: Re: [PATCH for 4.14,4.19,5.4] dmaengine: sh: rcar-dmac: Check for
 error num after dma_set_max_seg_size
Message-ID: <Y/9uNIPv8TL2JEvf@kroah.com>
References: <20230301091628.4004357-1-nobuhiro1.iwamatsu@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301091628.4004357-1-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 01, 2023 at 06:16:28PM +0900, Nobuhiro Iwamatsu wrote:
> From: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> 
> commit da2ad87fba0891576aadda9161b8505fde81a84d upstream.
> 
> As the possible failure of the dma_set_max_seg_size(), it should be
> better to check the return value of the dma_set_max_seg_size().
> 
> Fixes: 97d49c59e219 ("dmaengine: rcar-dmac: set scatter/gather max segment size")
> Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Link: https://lore.kernel.org/r/20220111011239.452837-1-jiasheng@iscas.ac.cn
> Signed-off-by: Vinod Koul <vkoul@kernel.org>
> Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
> ---
>  drivers/dma/sh/rcar-dmac.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/dma/sh/rcar-dmac.c b/drivers/dma/sh/rcar-dmac.c
> index eba942441e3823..10a8a6d4e86015 100644
> --- a/drivers/dma/sh/rcar-dmac.c
> +++ b/drivers/dma/sh/rcar-dmac.c
> @@ -1824,7 +1824,10 @@ static int rcar_dmac_probe(struct platform_device *pdev)
>  	dmac->dev = &pdev->dev;
>  	platform_set_drvdata(pdev, dmac);
>  	dmac->dev->dma_parms = &dmac->parms;
> -	dma_set_max_seg_size(dmac->dev, RCAR_DMATCR_MASK);
> +	ret = dma_set_max_seg_size(dmac->dev, RCAR_DMATCR_MASK);
> +	if (ret)
> +		return ret;
> +
>  	ret = dma_set_mask_and_coherent(dmac->dev, DMA_BIT_MASK(40));
>  	if (ret)
>  		return ret;
> -- 
> 2.36.1
> 
> 

Now queued up, thanks.

greg k-h
