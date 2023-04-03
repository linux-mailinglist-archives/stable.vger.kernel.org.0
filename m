Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42FA46D3E8C
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 10:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231781AbjDCICk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 04:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbjDCICj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 04:02:39 -0400
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DFC41725;
        Mon,  3 Apr 2023 01:02:37 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R831e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=rongwei.wang@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0VfFRiwW_1680508954;
Received: from 30.24.98.140(mailfrom:rongwei.wang@linux.alibaba.com fp:SMTPD_---0VfFRiwW_1680508954)
          by smtp.aliyun-inc.com;
          Mon, 03 Apr 2023 16:02:35 +0800
Message-ID: <4301a7be-354f-183d-a828-01445434a1b3@linux.alibaba.com>
Date:   Mon, 3 Apr 2023 16:02:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/swap: fix swap_info_struct race between swapoff and
 get_swap_pages()
Content-Language: en-US
To:     Matthew Wilcox <willy@infradead.org>
Cc:     akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20230401221920.57986-1-rongwei.wang@linux.alibaba.com>
 <ZCpRtASqL5z5QphY@casper.infradead.org>
From:   Rongwei Wang <rongwei.wang@linux.alibaba.com>
In-Reply-To: <ZCpRtASqL5z5QphY@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.0 required=5.0 tests=ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 4/3/23 12:10 PM, Matthew Wilcox wrote:
> On Sun, Apr 02, 2023 at 06:19:20AM +0800, Rongwei Wang wrote:
>> Without this modification, a core will wait (mostly)
>> 'swap_info_struct->lock' when completing
>> 'del_from_avail_list(p)'. Immediately, other cores
>> soon calling 'add_to_avail_list()' to add the same
>> object again when acquiring the lock that released
>> by former. It's not the desired result but exists
>> indeed. This case can be described as below:
> This feels like a very verbose way of saying
>
> "The si->lock must be held when deleting the si from the
> available list.  Otherwise, another thread can re-add the
> si to the available list, which can lead to memory corruption.
> The only place we have found where this happens is in the
> swapoff path."
It looks better than mine. Sorry for my confusing description, it will 
be fixed in the next version.
>
>> +++ b/mm/swapfile.c
>> @@ -2610,8 +2610,12 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
>>   		spin_unlock(&swap_lock);
>>   		goto out_dput;
>>   	}
>> -	del_from_avail_list(p);
>> +	/*
>> +	 * Here lock is used to protect deleting and SWP_WRITEOK clearing
>> +	 * can be seen concurrently.
>> +	 */
> This comment isn't necessary.  But I would add a lockdep assert inside
> __del_from_avail_list() that p->lock is held.

Thanks. Actually, I have this line in previous test version, but delete 
for saving one line of code.

I will update here as you said.


Thanks for your time.

>
>>   	spin_lock(&p->lock);
>> +	del_from_avail_list(p);
>>   	if (p->prio < 0) {
>>   		struct swap_info_struct *si = p;
>>   		int nid;
>> -- 
>> 2.27.0
>>
>>
