Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61256251710
	for <lists+stable@lfdr.de>; Tue, 25 Aug 2020 13:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729698AbgHYLHe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Aug 2020 07:07:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:56578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729529AbgHYLHe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Aug 2020 07:07:34 -0400
Received: from localhost (unknown [122.171.38.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2A112071E;
        Tue, 25 Aug 2020 11:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598353653;
        bh=tQ7tmapdZ7mR2P77XK9Qs44T1+glRTxLlJJVkA/wFWs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zmvkQCa2PUGTshf7z8RUglmHXa8EtzLR4FcjZhP+/NyREFetE3U9OHlYZ4egphK4+
         cVMv5DHhBK/yRJjuX9JWBgZdu81x8PrNSXagzfyBw1bUKHb19Ld0IQvJO/bpfskdat
         qmOrfPCgxA4GFDE3a4H5IOYOnlB5v2FmUxse2PFU=
Date:   Tue, 25 Aug 2020 16:37:29 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Gustavo Pimentel <Gustavo.Pimentel@synopsys.com>
Cc:     dmaengine@vger.kernel.org, Joao Pinto <Joao.Pinto@synopsys.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] dmaengine: dw-edma: Fix scatter-gather address
 calculation
Message-ID: <20200825110729.GH2639@vkoul-mobl>
References: <8d3ab7e2ba96563fe3495b32f60077fffb85307d.1597327623.git.gustavo.pimentel@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d3ab7e2ba96563fe3495b32f60077fffb85307d.1597327623.git.gustavo.pimentel@synopsys.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 13-08-20, 16:14, Gustavo Pimentel wrote:
> Fix the source and destination physical address calculation of a
> peripheral device on scatter-gather implementation.
> 
> This issue manifested during tests using a 64 bits architecture system.
> The abnormal behavior wasn't visible before due to all previous tests
> were done using 32 bits architecture system, that masked his effect.

Applied, thanks

> 
> Fixes: e63d79d1ffcd ("dmaengine: Add Synopsys eDMA IP core driver")
> 

Dont leave empty line here

> Cc: Joao Pinto <jpinto@synopsys.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Gustavo Pimentel <gustavo.pimentel@synopsys.com>
> ---
>  drivers/dma/dw-edma/dw-edma-core.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/dma/dw-edma/dw-edma-core.c b/drivers/dma/dw-edma/dw-edma-core.c
> index ed430ad..b971505 100644
> --- a/drivers/dma/dw-edma/dw-edma-core.c
> +++ b/drivers/dma/dw-edma/dw-edma-core.c
> @@ -405,7 +405,7 @@ dw_edma_device_transfer(struct dw_edma_transfer *xfer)
>  			if (xfer->cyclic) {
>  				burst->dar = xfer->xfer.cyclic.paddr;
>  			} else {
> -				burst->dar = sg_dma_address(sg);
> +				burst->dar = dst_addr;
>  				/* Unlike the typical assumption by other
>  				 * drivers/IPs the peripheral memory isn't
>  				 * a FIFO memory, in this case, it's a
> @@ -413,14 +413,13 @@ dw_edma_device_transfer(struct dw_edma_transfer *xfer)
>  				 * and destination addresses are increased
>  				 * by the same portion (data length)
>  				 */
> -				src_addr += sg_dma_len(sg);
>  			}
>  		} else {
>  			burst->dar = dst_addr;
>  			if (xfer->cyclic) {
>  				burst->sar = xfer->xfer.cyclic.paddr;
>  			} else {
> -				burst->sar = sg_dma_address(sg);
> +				burst->sar = src_addr;
>  				/* Unlike the typical assumption by other
>  				 * drivers/IPs the peripheral memory isn't
>  				 * a FIFO memory, in this case, it's a
> @@ -428,12 +427,14 @@ dw_edma_device_transfer(struct dw_edma_transfer *xfer)
>  				 * and destination addresses are increased
>  				 * by the same portion (data length)
>  				 */
> -				dst_addr += sg_dma_len(sg);
>  			}
>  		}
>  
> -		if (!xfer->cyclic)
> +		if (!xfer->cyclic) {
> +			src_addr += sg_dma_len(sg);
> +			dst_addr += sg_dma_len(sg);
>  			sg = sg_next(sg);
> +		}
>  	}
>  
>  	return vchan_tx_prep(&chan->vc, &desc->vd, xfer->flags);
> -- 
> 2.7.4

-- 
~Vinod
