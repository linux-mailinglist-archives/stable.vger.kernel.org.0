Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 264836A231B
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 21:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbjBXUSg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Feb 2023 15:18:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjBXUSf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Feb 2023 15:18:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAB6D1ACC9;
        Fri, 24 Feb 2023 12:18:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42673618DE;
        Fri, 24 Feb 2023 20:18:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CDD5C433EF;
        Fri, 24 Feb 2023 20:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677269913;
        bh=p8fZIG2TcgGJcvoEAQe87TXTkE4aS4pGTxy2SF+EekU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j4TFPvvD17Qum7WCm7hbyhg8nJFxCpfJgBxV7BcThXHNhq7wHL2PTVuwMQ8MeUTh3
         Y3OXfOtx5zPBSoyaMqgAu9n09e1BGlWCH5PFXmIeZbZXMU2i6TjsX2TymHE4gc1CPk
         tIta8KRNQx+PJsL6tFPldoOgDhEGM7IULJG9+FKbb5233RyTjuwVKlq/HXJT80gZpf
         DTwKaGGBlQjwJ47047mL7VDEONxxSRAddS6m1ni0Sb4YR50+Ct/1rfIG+nPtpyqB6b
         gmErWXuIYd+73f/XhvtivTjeTJUSdKnFwUEtupmX+UQOnosNexq/5N8d3VTMRUse35
         CVSqhhCvOWKWg==
Date:   Fri, 24 Feb 2023 13:18:30 -0700
From:   Keith Busch <kbusch@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] block: clear bio->bi_bdev when putting a bio back in
 the cache
Message-ID: <Y/kbluzYPiq65xkK@kbusch-mbp.dhcp.thefacebook.com>
References: <20230224170845.175485-1-axboe@kernel.dk>
 <20230224170845.175485-2-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230224170845.175485-2-axboe@kernel.dk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 24, 2023 at 10:08:44AM -0700, Jens Axboe wrote:
> This isn't strictly needed in terms of correctness, but it does allow
> polling to know if the bio has been put already by a different task
> and hence avoid polling something that we don't need to.
> 
> Cc: stable@vger.kernel.org
> Fixes: be4d234d7aeb ("bio: add allocation cache abstraction")
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Looks good.

Reviewed-by: Keith Busch <kbusch@kernel.org>

> ---
>  block/bio.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/block/bio.c b/block/bio.c
> index 2693f34afb7e..605c40025068 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -772,6 +772,7 @@ static inline void bio_put_percpu_cache(struct bio *bio)
>  
>  	if ((bio->bi_opf & REQ_POLLED) && !WARN_ON_ONCE(in_interrupt())) {
>  		bio->bi_next = cache->free_list;
> +		bio->bi_bdev = NULL;
>  		cache->free_list = bio;
>  		cache->nr++;
>  	} else {
> -- 
> 2.39.1
> 
