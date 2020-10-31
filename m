Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF5B02A180A
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 15:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727505AbgJaOD2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 10:03:28 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:64466 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727407AbgJaOD2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Oct 2020 10:03:28 -0400
Received: from fsav108.sakura.ne.jp (fsav108.sakura.ne.jp [27.133.134.235])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 09VE36PJ098541;
        Sat, 31 Oct 2020 23:03:06 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav108.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav108.sakura.ne.jp);
 Sat, 31 Oct 2020 23:03:06 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav108.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 09VE30bg098446
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Sat, 31 Oct 2020 23:03:06 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Subject: Re: Linux 4.19.154
To:     Jari Ruusu <jariruusu@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
References: <160405368022942@kroah.com> <160405368043128@kroah.com>
 <5F9D6341.71F2A54E@users.sourceforge.net>
From:   Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Message-ID: <9996e46f-e493-e3b3-c23a-31415668db7d@i-love.sakura.ne.jp>
Date:   Sat, 31 Oct 2020 23:02:56 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <5F9D6341.71F2A54E@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020/10/31 22:14, Jari Ruusu wrote:
> Greg Kroah-Hartman wrote:
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -2127,11 +2127,10 @@ static void handle_bad_sector(struct bio *bio, sector_t maxsector)
>>  {
>>         char b[BDEVNAME_SIZE];
>>
>> -       printk(KERN_INFO "attempt to access beyond end of device\n");
>> -       printk(KERN_INFO "%s: rw=%d, want=%Lu, limit=%Lu\n",
>> -                       bio_devname(bio, b), bio->bi_opf,
>> -                       (unsigned long long)bio_end_sector(bio),
>> -                       (long long)maxsector);
>> +       pr_info_ratelimited("attempt to access beyond end of device\n"
>> +                           "%s: rw=%d, want=%llu, limit=%llu\n",
>> +                           bio_devname(bio, b), bio->bi_opf,
>> +                           bio_end_sector(bio), maxsector);
>>  }
>>
>>  #ifdef CONFIG_FAIL_MAKE_REQUEST
> 
> Above change "block: ratelimit handle_bad_sector() message"
> upstream commit f4ac712e4fe009635344b9af5d890fe25fcc8c0d
> in 4.19.154 kernel is not completely OK.
> 
> Removing casts from arguments 4 and 5 produces these compile warnings:
> 
(...snipped...)
> For 64 bit systems it is only compile time cosmetic warning. For 32 bit
> system + CONFIG_LBDAF=n it introduces bugs: output formats are "%llu" and
> passed parameters are 32 bits. That is not OK.
> 
> Upstream kernels have hardcoded 64 bit sector_t. In older stable trees
> sector_t can be either 64 or 32 bit. In other words, backport of above patch
> needs to keep those original casts.

Indeed, commit f4ac712e4fe00963 ("block: ratelimit handle_bad_sector() message")
depends on commit 72deb455b5ec619f ("block: remove CONFIG_LBDAF") which was merged
into 5.2 kernel.

-------- Forwarded Message --------
Date: Thu, 8 Oct 2020 07:40:49 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org
Subject: Re: [PATCH] block: ratelimit handle_bad_sector() message
Message-ID: <20201008064049.GA29599@infradead.org>
References: <20201008002344.6759-1-penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <20201008002344.6759-1-penguin-kernel@I-love.SAKURA.ne.jp>

On Thu, Oct 08, 2020 at 09:23:44AM +0900, Tetsuo Handa wrote:
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -803,8 +803,8 @@ static void handle_bad_sector(struct bio *bio, sector_t maxsector)
>  {
>  	char b[BDEVNAME_SIZE];
>  
> -	printk(KERN_INFO "attempt to access beyond end of device\n");
> -	printk(KERN_INFO "%s: rw=%d, want=%Lu, limit=%Lu\n",
> +	printk_ratelimited(KERN_INFO "attempt to access beyond end of device\n");
> +	printk_ratelimited(KERN_INFO "%s: rw=%d, want=%Lu, limit=%Lu\n",
>  			bio_devname(bio, b), bio->bi_opf,
>  			(unsigned long long)bio_end_sector(bio),
>  			(long long)maxsector);

Please use pr_info_ratelimited, and also remove the casts now that
sector_t is guranteed to be an unsigned long long.
