Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB443631B5
	for <lists+stable@lfdr.de>; Tue,  9 Jul 2019 09:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726034AbfGIHSk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jul 2019 03:18:40 -0400
Received: from forwardcorp1j.mail.yandex.net ([5.45.199.163]:39650 "EHLO
        forwardcorp1j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725886AbfGIHSj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jul 2019 03:18:39 -0400
Received: from mxbackcorp2j.mail.yandex.net (mxbackcorp2j.mail.yandex.net [IPv6:2a02:6b8:0:1619::119])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id D282C2E0D96;
        Tue,  9 Jul 2019 10:18:36 +0300 (MSK)
Received: from smtpcorp1j.mail.yandex.net (smtpcorp1j.mail.yandex.net [2a02:6b8:0:1619::137])
        by mxbackcorp2j.mail.yandex.net (nwsmtp/Yandex) with ESMTP id akmrB41YWg-IaU4L3b8;
        Tue, 09 Jul 2019 10:18:36 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1562656716; bh=HVi/4mii0aOLlDy7iHHak1FI+515jxoexIoDkfss/1A=;
        h=In-Reply-To:Message-ID:From:Date:References:To:Subject:Cc;
        b=KDE2FjPstQZ1JWZ8y87Fy8Px3Mh8orINWRH+1EOfNxxQHiQLYHWfGVHIMa/ShuluM
         Qf6dUMrJmXHj6E0x24mRGYnuhU5YSwAR6sRTChUEt/OlmSWNakUQoMGBKHJGaEBK4N
         /1geVVpagIy7GU7iyswpuG5DG9YoWpreUdoEST0I=
Authentication-Results: mxbackcorp2j.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from dynamic-red.dhcp.yndx.net (dynamic-red.dhcp.yndx.net [2a02:6b8:0:40c:fce8:911:2fe8:4dfb])
        by smtpcorp1j.mail.yandex.net (nwsmtp/Yandex) with ESMTPSA id 4g1gL3BDrd-IaQCCUKv;
        Tue, 09 Jul 2019 10:18:36 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
Subject: Re: [PATCH] blk-throttle: fix zero wait time for iops throttled group
To:     bo.liu@linux.alibaba.com
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <156259979778.2486.6296077059654653057.stgit@buzz>
 <20190708190809.l4fdhigexzdujvuv@US-160370MP2.local>
From:   Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Message-ID: <2240c382-502d-d112-418b-d44aa67d0ab2@yandex-team.ru>
Date:   Tue, 9 Jul 2019 10:18:36 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190708190809.l4fdhigexzdujvuv@US-160370MP2.local>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08.07.2019 22:08, Liu Bo wrote:
> On Mon, Jul 08, 2019 at 06:29:57PM +0300, Konstantin Khlebnikov wrote:
>> After commit 991f61fe7e1d ("Blk-throttle: reduce tail io latency when iops
>> limit is enforced") wait time could be zero even if group is throttled and
>> cannot issue requests right now. As a result throtl_select_dispatch() turns
>> into busy-loop under irq-safe queue spinlock.
>>
>> Fix is simple: always round up target time to the next throttle slice.
>>
>> Fixes: 991f61fe7e1d ("Blk-throttle: reduce tail io latency when iops limit is enforced")
>> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
>> Cc: stable@vger.kernel.org # v4.19+
>> ---
>>   block/blk-throttle.c |    9 +++------
>>   1 file changed, 3 insertions(+), 6 deletions(-)
>>
>> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
>> index 9ea7c0ecad10..8ab6c8153223 100644
>> --- a/block/blk-throttle.c
>> +++ b/block/blk-throttle.c
>> @@ -881,13 +881,10 @@ static bool tg_with_in_iops_limit(struct throtl_grp *tg, struct bio *bio,
>>   	unsigned long jiffy_elapsed, jiffy_wait, jiffy_elapsed_rnd;
>>   	u64 tmp;
>>   
>> -	jiffy_elapsed = jiffy_elapsed_rnd = jiffies - tg->slice_start[rw];
>> -
>> -	/* Slice has just started. Consider one slice interval */
>> -	if (!jiffy_elapsed)
>> -		jiffy_elapsed_rnd = tg->td->throtl_slice;
>> +	jiffy_elapsed = jiffies - tg->slice_start[rw];
>>   
>> -	jiffy_elapsed_rnd = roundup(jiffy_elapsed_rnd, tg->td->throtl_slice);
>> +	/* Round up to the next throttle slice, wait time must be nonzero */
>> +	jiffy_elapsed_rnd = roundup(jiffy_elapsed + 1, tg->td->throtl_slice);
>>   
>>   	/*
>>   	 * jiffy_elapsed_rnd should not be a big value as minimum iops can be
> 
> Did you use a tiny iops limit to run into this?

Yep. 25 iops

also kernel built with HZ=250, this might be related

> 
> thanks,
> -liubo
> 
