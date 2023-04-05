Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73C6E6D74A0
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 08:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232924AbjDEGuB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 02:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237111AbjDEGt4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 02:49:56 -0400
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 686B14693;
        Tue,  4 Apr 2023 23:49:54 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=rongwei.wang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VfOIfDC_1680677388;
Received: from 30.221.128.100(mailfrom:rongwei.wang@linux.alibaba.com fp:SMTPD_---0VfOIfDC_1680677388)
          by smtp.aliyun-inc.com;
          Wed, 05 Apr 2023 14:49:49 +0800
Message-ID: <527978d9-3f6f-b507-5f0f-b24311ff78e4@linux.alibaba.com>
Date:   Wed, 5 Apr 2023 14:49:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/swap: fix swap_info_struct race between swapoff and
 get_swap_pages()
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     bagasdotme@gmail.com, willy@infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Aaron Lu <aaron.lu@intel.com>
References: <20230401221920.57986-1-rongwei.wang@linux.alibaba.com>
 <20230404154716.23058-1-rongwei.wang@linux.alibaba.com>
 <20230404122600.88257a623c7f72e078dcf705@linux-foundation.org>
Content-Language: en-US
From:   Rongwei Wang <rongwei.wang@linux.alibaba.com>
In-Reply-To: <20230404122600.88257a623c7f72e078dcf705@linux-foundation.org>
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

Hi Andrew

On 4/5/23 3:26 AM, Andrew Morton wrote:
> On Tue,  4 Apr 2023 23:47:16 +0800 Rongwei Wang <rongwei.wang@linux.alibaba.com> wrote:
>
>> The si->lock must be held when deleting the si from
>> the available list.
>>
>> ...
>>
>> --- a/mm/swapfile.c
>> +++ b/mm/swapfile.c
>> @@ -679,6 +679,7 @@ static void __del_from_avail_list(struct swap_info_struct *p)
>>   {
>>   	int nid;
>>   
>> +	assert_spin_locked(&p->lock);
>>   	for_each_node(nid)
>>   		plist_del(&p->avail_lists[nid], &swap_avail_heads[nid]);
>>   }
>> @@ -2434,8 +2435,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
>>   		spin_unlock(&swap_lock);
>>   		goto out_dput;
>>   	}
>> -	del_from_avail_list(p);
>>   	spin_lock(&p->lock);
>> +	del_from_avail_list(p);
>>   	if (p->prio < 0) {
>>   		struct swap_info_struct *si = p;
>>   		int nid;
> So we have
>
> swap_avail_lock
> swap_info_struct.lock
> swap_cluster_info.lock
>
> Is the ranking of these three clearly documented somewhere?

It seems have

swap_lock

swap_info_struct.lock

swap_avail_lock

I just summary the ranking of these three locks by reading code, not 
find any documents (maybe have).

>
>
> Did you test this with lockdep fully enabled?
>
>
> I'm thinking that Aaron's a2468cc9bfdff ("swap: choose swap device
> according to numa node") is the appropriate Fixes: target - do you
> agree?

Yes, I'm sure my latest test version has included Aaron's a2468cc9bfdff, 
and my test .config has enabled CONFIG

as below:

CONFIG_LOCK_DEBUGGING_SUPPORT=y CONFIG_PROVE_LOCKING=y 
CONFIG_DEBUG_SPINLOCK=y CONFIG_DEBUG_LOCK_ALLOC=y CONFIG_LOCKDEP=y 
CONFIG_DEBUG_LOCKDEP=y CONFIG_DEBUG_ATOMIC_SLEEP=y

>
>
> These functions use identifier `p' for the swap_info_struct*, whereas
> most other code uses the much more sensible `si'.  That's just rude.
> But we shouldn't change that within this fix.

Indeed, It's confusing more or less to use both 'si' and 'p'. I can 
ready for another patch to replace 'p' with 'si'.

Thanks.

