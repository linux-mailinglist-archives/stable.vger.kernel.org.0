Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3C57521370
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 13:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232974AbiEJLVo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 07:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240906AbiEJLVa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 07:21:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 332FA1A448F
        for <stable@vger.kernel.org>; Tue, 10 May 2022 04:17:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E700EB81CBC
        for <stable@vger.kernel.org>; Tue, 10 May 2022 11:17:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46616C385A6;
        Tue, 10 May 2022 11:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652181450;
        bh=zC1IvfFQp/3QJDmf20TS/yTGQnuSs/7ere3qsQBVhBE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=shCNNLy8Uru24EaXz6gyvLjaCegw9b12boRvJawgbJwMCC5usy5Dm62PJjMHd49sY
         ZI5KSETgkI06CsrrtK+cgDMzdc/80TZcgLu2IDV60gOsZAqGuE6SEtgrw8IusWzlPv
         vMSW/9xBfAeytht2XRNSb/xEzqK2Nvw4szv65NHM=
Date:   Tue, 10 May 2022 13:17:28 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nobel Barakat <nobelbarakat@google.com>
Cc:     stable@vger.kernel.org, Haimin Zhang <tcs.kernel@gmail.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 5.10] block-map: add __GFP_ZERO flag for alloc_page in
 function bio_copy_kern
Message-ID: <YnpJyE0JeX26CMRX@kroah.com>
References: <20220504201207.2352621-1-nobelbarakat@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220504201207.2352621-1-nobelbarakat@google.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 04, 2022 at 08:12:07PM +0000, Nobel Barakat wrote:
> [ Upstream commit cc8f7fe1f5eab010191aa4570f27641876fa1267 ]
> 
> Add __GFP_ZERO flag for alloc_page in function bio_copy_kern to initialize
> the buffer of a bio.
> 
> Signed-off-by: Haimin Zhang <tcs.kernel@gmail.com>
> Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Link: https://lore.kernel.org/r/20220216084038.15635-1-tcs.kernel@gmail.com
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> [nobelbarakat: Backported to 5.10: Manually added flag] 
> Signed-off-by: Nobel Barakat <nobelbarakat@google.com>
> ---
> This changes fixes a kernel info leak since it's possible for bio_copy_kern to
> copy unitialized memory into userspace. 
> 
> For the backport, I had to manually add the __GFP_ZERO
> flag since alloc_page on 5.10 uses a different parameter
> than on 5.15. On 5.10, alloc_page is called with q->bounce_gfp
> whereas on 5.15 it's called with GFP_NOIO.
> 
> Version 5.4 is also affected, and I intend to submit a backport
> there as well.
> 
>  block/blk-map.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/block/blk-map.c b/block/blk-map.c
> index 21630dccac62..ede73f4f7014 100644
> --- a/block/blk-map.c
> +++ b/block/blk-map.c
> @@ -488,7 +488,7 @@
>  		if (bytes > len)
>  			bytes = len;
>  
> -		page = alloc_page(q->bounce_gfp | gfp_mask);
> +		page = alloc_page(q->bounce_gfp | __GFP_ZERO | gfp_mask);
>  		if (!page)
>  			goto cleanup;
>  
> -- 
> 2.36.0.464.gb9c8b46e94-goog
> 

Both now queued up, thanks.

greg k-h
