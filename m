Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED2E49DA60
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 06:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236361AbiA0F7z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 00:59:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236357AbiA0F7y (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 00:59:54 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4035EC06173B
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 21:59:54 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id h21so2686824wrb.8
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 21:59:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorfullife-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=G8p9n+htg/79lkjPBzyjVNa8biwypRxIALTw6/oqEQI=;
        b=Za26JLsU1BtatOrze/S5zzcABpHZeyndaurLEd67odktXAQRGo4lg7AJTqCVeCifgj
         aJ304MiWYNo4Po/J1LvQY/iu8I5/lYP3kAQkv9V4ZPJGYTECEjX5+dfNDvOfb5aXXbRs
         oYDJeI8qAmMAXgiZJqOVby+OgARgJkusd0VSiEWiC1j8/0TQ2wpJ3QV+LUP/HQyfcA+D
         n7t+ag/Sziw8WcK6/Hb/yhMOB607B8jGqJZsN35izDRDnID6CJ9DVT+E/cueuDOobF90
         tGLRvllv/SuHEdAw01wQd/wCI8uflQC/PkyQYVBtE6u5hXL8I9BAcTHCvf/IDfR3WfTH
         RFGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=G8p9n+htg/79lkjPBzyjVNa8biwypRxIALTw6/oqEQI=;
        b=qgfIVsOn6LllivmxAeNzBaXAgQa76yh0eiQ76PQgC/MM9Wxa3KE9eSjvsTMSqssnZd
         m4gnRCbro5Hp6ebyEtPsxILffT5ghs/WP3JImejy/fcYVRHH/Zeox2WRiPYQhrR8k+cr
         zetTHcIjEEtsoOlo1D4jpnNqrEgu+fC2fKUusxgYlmnyHTonSXo3STyM8x7DthFVmf6o
         0sR6de+vYLv8vqCkW1eCrC+c4VVvSrZt9gIQ0YUS8ajtlh314Og13z4BnRDuNgVGbOm6
         3QGclMGQjniAP573O1vw12W+KfLyTgIiD3BfCEksZpxH1IqAZThsVfqIEjJbA2TLChjB
         0mIA==
X-Gm-Message-State: AOAM533ExZ9fWN5DKudp0+D59NOWkjdaZJIDgNlwRNphXLOtpX7nnjWr
        U5IYAnU3DHEtnE1KVXYvPxQfrA==
X-Google-Smtp-Source: ABdhPJxpkN+X0z8qoZuuqurO2M6v5ztcgkmZkwhoxudB/VDoodE5ESz0XltB6fblLQcbOpeGeBNIXQ==
X-Received: by 2002:a5d:584e:: with SMTP id i14mr1540824wrf.197.1643263192768;
        Wed, 26 Jan 2022 21:59:52 -0800 (PST)
Received: from ?IPV6:2003:d9:9707:d500:f72a:8d22:e3d4:f73? (p200300d99707d500f72a8d22e3d40f73.dip0.t-ipconnect.de. [2003:d9:9707:d500:f72a:8d22:e3d4:f73])
        by smtp.googlemail.com with ESMTPSA id n13sm1166998wrv.94.2022.01.26.21.59.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jan 2022 21:59:52 -0800 (PST)
Message-ID: <c658f8c5-a808-f2f1-2e1e-cfb68dd19d6a@colorfullife.com>
Date:   Thu, 27 Jan 2022 06:59:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] mm/util.c: Make kvfree() safe for calling while holding
 spinlocks
Content-Language: en-US
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Vasily Averin <vvs@virtuozzo.com>, cgel.zte@gmail.com,
        shakeelb@google.com, rdunlap@infradead.org, dbueso@suse.de,
        unixbhaskar@gmail.com, chi.minghao@zte.com.cn, arnd@arndb.de,
        Zeal Robot <zealci@zte.com.cn>, linux-mm@kvack.org,
        1vier1@web.de, stable@vger.kernel.org,
        Michal Hocko <mhocko@kernel.org>
References: <20211222194828.15320-1-manfred@colorfullife.com>
 <20220126185340.58f88e8e1b153b6650c83270@linux-foundation.org>
From:   Manfred Spraul <manfred@colorfullife.com>
In-Reply-To: <20220126185340.58f88e8e1b153b6650c83270@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Andrew,

On 1/27/22 03:53, Andrew Morton wrote:
> On Wed, 22 Dec 2021 20:48:28 +0100 Manfred Spraul <manfred@colorfullife.com> wrote:
>
>> One codepath in find_alloc_undo() calls kvfree() while holding a spinlock.
>> Since vfree() can sleep this is a bug.
>>
>> Previously, the code path used kfree(), and kfree() is safe to be called
>> while holding a spinlock.
>>
>> Minghao proposed to fix this by updating find_alloc_undo().
>>
>> Alternate proposal to fix this: Instead of changing find_alloc_undo(),
>> change kvfree() so that the same rules as for kfree() apply:
>> Having different rules for kfree() and kvfree() just asks for bugs.
>>
>> Disadvantage: Releasing vmalloc'ed memory will be delayed a bit.
> I know we've been around this loop a bunch of times and deferring was
> considered.   But I forget the conclusion.  IIRC, mhocko was involved?

I do not remember a mail from mhocko.

Shakeel proposed to use the approach from Chi.

Decision: https://marc.info/?l=linux-kernel&m=164132032717757&w=2

With Reviewed-by:

https://marc.info/?l=linux-kernel&m=164132744522325&w=2
>> --- a/mm/util.c
>> +++ b/mm/util.c
>> @@ -610,12 +610,12 @@ EXPORT_SYMBOL(kvmalloc_node);
>>    * It is slightly more efficient to use kfree() or vfree() if you are certain
>>    * that you know which one to use.
>>    *
>> - * Context: Either preemptible task context or not-NMI interrupt.
>> + * Context: Any context except NMI interrupt.
>>    */
>>   void kvfree(const void *addr)
>>   {
>>   	if (is_vmalloc_addr(addr))
>> -		vfree(addr);
>> +		vfree_atomic(addr);
>>   	else
>>   		kfree(addr);
>>   }


