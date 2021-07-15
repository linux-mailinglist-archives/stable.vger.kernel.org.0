Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9347D3C9D2F
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 12:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240344AbhGOKtd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 06:49:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:57822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232055AbhGOKtd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 06:49:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30C5C61380;
        Thu, 15 Jul 2021 10:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626345999;
        bh=DG3LveTVAU6PEbDuGHpdRTy1eY78W4ev4Y4ViSg12X8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DWnIO3kmhnVuKJw4p6WLmqkpE8Pgqv2yTuzK6P+ux+cfORUTE9Vo6+UGuOlPgVtao
         VdY28fLTSlIf8l2YrnwamxkP+dc8poqf1T91RLOJLtcYjZvMidL0yQCgv0n+SgrRmt
         WKHfD4L/d7HqmC0MglaQ4MmDKtKv33oZduzKIjRE=
Date:   Thu, 15 Jul 2021 12:46:33 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Thara Gopinath <thara.gopinath@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 129/593] crypto: qce: skcipher: Fix incorrect sg
 count for dma transfers
Message-ID: <YPASCTljJFr07jcU@kroah.com>
References: <20210712060843.180606720@linuxfoundation.org>
 <20210712060857.335221127@linuxfoundation.org>
 <20210714194028.GA15200@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714194028.GA15200@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 14, 2021 at 09:40:28PM +0200, Pavel Machek wrote:
> Hi!
> 
> > [ Upstream commit 1339a7c3ba05137a2d2fe75f602311bbfc6fab33 ]
> > 
> > Use the sg count returned by dma_map_sg to call into
> > dmaengine_prep_slave_sg rather than using the original sg count. dma_map_sg
> > can merge consecutive sglist entries, thus making the original sg count
> > wrong. This is a fix for memory coruption issues observed while testing
> > encryption/decryption of large messages using libkcapi framework.
> > 
> > Patch has been tested further by running full suite of tcrypt.ko tests
> > including fuzz tests.
> 
> This still needs more work AFAICT.
> 
> > index a2d3da0ad95f..5a6559131eac 100644
> > --- a/drivers/crypto/qce/skcipher.c
> > +++ b/drivers/crypto/qce/skcipher.c
> > @@ -122,21 +122,22 @@ qce_skcipher_async_req_handle(struct crypto_async_request *async_req)
> >  	sg_mark_end(sg);
> >  	rctx->dst_sg = rctx->dst_tbl.sgl;
> 
> ret is == 0 at this point.
> 
> > -	ret = dma_map_sg(qce->dev, rctx->dst_sg, rctx->dst_nents, dir_dst);
> > -	if (ret < 0)
> > +	dst_nents = dma_map_sg(qce->dev, rctx->dst_sg, rctx->dst_nents, dir_dst);
> > +	if (dst_nents < 0)
> >  		goto error_free;
> 
> And we go to the error path, and return ret... instead of returning failure.
> 
> >  	if (diff_dst) {
> > -		ret = dma_map_sg(qce->dev, req->src, rctx->src_nents, dir_src);
> > -		if (ret < 0)
> > +		src_nents = dma_map_sg(qce->dev, req->src, rctx->src_nents, dir_src);
> > +		if (src_nents < 0)
> >  			goto error_unmap_dst;
> >  		rctx->src_sg = req->src;
> 
> Same problem happens here.
> 
> The problem is already fixed in the mainline; I believe we want that
> in 5.10-stable at least.
> 
> commit a8bc4f5e7a72e4067f5afd7e98b61624231713ca
> Author: Wei Yongjun <weiyongjun1@huawei.com>
> Date:   Wed Jun 2 11:36:45 2021 +0000
> 
>     crypto: qce - fix error return code in qce_skcipher_async_req_handle()
> 
>     Fix to return a negative error code from the error handling
>         case instead of 0, as done elsewhere in this function.
> 
>     Fixes: 1339a7c3ba05 ("crypto: qce: skcipher: Fix incorrect sg
>     count for dma transfers")
>         Reported-by: Hulk Robot <hulkci@huawei.com>
> 	    Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> 	    
> 

This is also already in this 5.10.50 release.

thanks,

greg k-h
