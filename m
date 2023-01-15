Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE7F66AFD6
	for <lists+stable@lfdr.de>; Sun, 15 Jan 2023 09:04:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbjAOIEm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Jan 2023 03:04:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbjAOIEl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Jan 2023 03:04:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E8FDB47B;
        Sun, 15 Jan 2023 00:04:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2825160C53;
        Sun, 15 Jan 2023 08:04:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C804C433D2;
        Sun, 15 Jan 2023 08:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673769879;
        bh=qm7hyC0LUcDgDBxuDWXDhly2lFnkKUN2YKEnH4CRa8Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TOVodW3/W+kLvSDGrLFSUb3XjtmMs7WVRscM0i0DMoDYKTRmx82lcFEcwEDOd94rH
         HZ+4kJFALknAhdiBPzTip+vPj0+ohAWgdB+LR3/N63yRzHrqT/QI5NSPCpS0I5IjL2
         wGz4G/2X1r3lutsGlX6uiDH891qeUF3wP9s9KnT4=
Date:   Sun, 15 Jan 2023 09:04:36 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Fedor Pchelkin <pchelkin@ispras.ru>
Cc:     stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH 5.10 1/1] block: fix and cleanup bio_check_ro
Message-ID: <Y8OzlLXW4WvgvwDw@kroah.com>
References: <20230114222709.180795-1-pchelkin@ispras.ru>
 <20230114222709.180795-2-pchelkin@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230114222709.180795-2-pchelkin@ispras.ru>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 15, 2023 at 01:27:09AM +0300, Fedor Pchelkin wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> commit 57e95e4670d1126c103305bcf34a9442f49f6d6a upstream.
> 
> Don't use a WARN_ONCE when printing a potentially user triggered
> condition.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Link: https://lore.kernel.org/r/20220304180105.409765-2-hch@lst.de
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
> ---
>  block/blk-core.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 26664f2a139e..921d436fa3c6 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -701,8 +701,7 @@ static inline bool bio_check_ro(struct bio *bio, struct hd_struct *part)
>  		if (op_is_flush(bio->bi_opf) && !bio_sectors(bio))
>  			return false;
>  
> -		WARN_ONCE(1,
> -		       "Trying to write to read-only block-device %s (partno %d)\n",
> +		pr_warn("Trying to write to read-only block-device %s (partno %d)\n",
>  			bio_devname(bio, b), part->partno);
>  		/* Older lvm-tools actually trigger this */
>  		return false;
> -- 
> 2.34.1
> 

Again, we CAN NOT take patches for older kernels and not for newer ones,
that one will cause regressions when people upgrade to newer kernels.

So I'm dropping all of your patches from my queue, please resend them so
that all trees are properly covered.  As-is, I can not take the, and
most importantly, you do not want me to accept such a thing!

thanks,

greg k-h
