Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7472F628FD
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 21:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390590AbfGHTJ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 15:09:58 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:54421 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731402AbfGHTJ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jul 2019 15:09:57 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=bo.liu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0TWPWMSM_1562612890;
Received: from US-160370MP2.local(mailfrom:bo.liu@linux.alibaba.com fp:SMTPD_---0TWPWMSM_1562612890)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 09 Jul 2019 03:08:12 +0800
Date:   Mon, 8 Jul 2019 12:08:09 -0700
From:   Liu Bo <bo.liu@linux.alibaba.com>
To:     Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] blk-throttle: fix zero wait time for iops throttled group
Message-ID: <20190708190809.l4fdhigexzdujvuv@US-160370MP2.local>
Reply-To: bo.liu@linux.alibaba.com
References: <156259979778.2486.6296077059654653057.stgit@buzz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156259979778.2486.6296077059654653057.stgit@buzz>
User-Agent: NeoMutt/20180323
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 08, 2019 at 06:29:57PM +0300, Konstantin Khlebnikov wrote:
> After commit 991f61fe7e1d ("Blk-throttle: reduce tail io latency when iops
> limit is enforced") wait time could be zero even if group is throttled and
> cannot issue requests right now. As a result throtl_select_dispatch() turns
> into busy-loop under irq-safe queue spinlock.
> 
> Fix is simple: always round up target time to the next throttle slice.
> 
> Fixes: 991f61fe7e1d ("Blk-throttle: reduce tail io latency when iops limit is enforced")
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> Cc: stable@vger.kernel.org # v4.19+
> ---
>  block/blk-throttle.c |    9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
> index 9ea7c0ecad10..8ab6c8153223 100644
> --- a/block/blk-throttle.c
> +++ b/block/blk-throttle.c
> @@ -881,13 +881,10 @@ static bool tg_with_in_iops_limit(struct throtl_grp *tg, struct bio *bio,
>  	unsigned long jiffy_elapsed, jiffy_wait, jiffy_elapsed_rnd;
>  	u64 tmp;
>  
> -	jiffy_elapsed = jiffy_elapsed_rnd = jiffies - tg->slice_start[rw];
> -
> -	/* Slice has just started. Consider one slice interval */
> -	if (!jiffy_elapsed)
> -		jiffy_elapsed_rnd = tg->td->throtl_slice;
> +	jiffy_elapsed = jiffies - tg->slice_start[rw];
>  
> -	jiffy_elapsed_rnd = roundup(jiffy_elapsed_rnd, tg->td->throtl_slice);
> +	/* Round up to the next throttle slice, wait time must be nonzero */
> +	jiffy_elapsed_rnd = roundup(jiffy_elapsed + 1, tg->td->throtl_slice);
>  
>  	/*
>  	 * jiffy_elapsed_rnd should not be a big value as minimum iops can be

Did you use a tiny iops limit to run into this?

thanks,
-liubo
