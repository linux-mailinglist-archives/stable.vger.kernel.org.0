Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC0A54F2D8
	for <lists+stable@lfdr.de>; Fri, 17 Jun 2022 10:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380917AbiFQIZo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jun 2022 04:25:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232020AbiFQIZn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jun 2022 04:25:43 -0400
Received: from out199-7.us.a.mail.aliyun.com (out199-7.us.a.mail.aliyun.com [47.90.199.7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA966831D;
        Fri, 17 Jun 2022 01:25:40 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=xianting.tian@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0VGe5yuS_1655454335;
Received: from B-LB6YLVDL-0141.local(mailfrom:xianting.tian@linux.alibaba.com fp:SMTPD_---0VGe5yuS_1655454335)
          by smtp.aliyun-inc.com;
          Fri, 17 Jun 2022 16:25:37 +0800
Subject: Re: [PATCH 4.9] mm: page_alloc: validate buddy page before using
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     akpm@linux-foundation.org, ziy@nvidia.com, stable@vger.kernel.org,
        guoren@kernel.org, huanyi.xj@alibaba-inc.com, guohanjun@huawei.com,
        zjb194813@alibaba-inc.com, tianhu.hh@alibaba-inc.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20220616161928.3565294-1-xianting.tian@linux.alibaba.com>
 <Yqw5ZPyeMemfeKKY@kroah.com>
From:   Xianting Tian <xianting.tian@linux.alibaba.com>
Message-ID: <c091b3a2-394a-59b4-dd98-98774e33afea@linux.alibaba.com>
Date:   Fri, 17 Jun 2022 16:25:35 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <Yqw5ZPyeMemfeKKY@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-12.1 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


在 2022/6/17 下午4:20, Greg KH 写道:
> On Fri, Jun 17, 2022 at 12:19:28AM +0800, Xianting Tian wrote:
>> Commit 787af64d05cd ("mm: page_alloc: validate buddy before check its migratetype.")
>> fixes a bug in 1dd214b8f21c and there is a similar bug in d9dddbf55667 that
>> can be fixed in a similar way too.
>>
>> In addition, for RISC-V arch the first 2MB RAM could be reserved for opensbi,
>> so it would have pfn_base=512 and mem_map began with 512th PFN when
>> CONFIG_FLATMEM=y.
>> But __find_buddy_pfn algorithm thinks the start pfn 0, it could get 0 pfn or
>> less than the pfn_base value. We need page_is_buddy() to verify the buddy to
>> prevent accessing an invalid buddy.
>>
>> Fixes: d9dddbf55667 ("mm/page_alloc: prevent merging between isolated and other pageblocks")
>> Cc: stable@vger.kernel.org
>> Reported-by: zjb194813@alibaba-inc.com
>> Reported-by: tianhu.hh@alibaba-inc.com
>> Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
>> ---
>>   mm/page_alloc.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index a6e682569e5b..1c423faa4b62 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -864,6 +864,9 @@ static inline void __free_one_page(struct page *page,
>>   
>>   			buddy_idx = __find_buddy_index(page_idx, order);
>>   			buddy = page + (buddy_idx - page_idx);
>> +
>> +			if (!page_is_buddy(page, buddy, order))
>> +				goto done_merging;
>>   			buddy_mt = get_pageblock_migratetype(buddy);
>>   
>>   			if (migratetype != buddy_mt
>> -- 
>> 2.17.1
>>
> What is the git commit id of this change in Linus's tree?

It is this one,

commit 787af64d05cd528aac9ad16752d11bb1c6061bb9
Author: Zi Yan <ziy@nvidia.com>
Date:   Wed Mar 30 15:45:43 2022 -0700

     mm: page_alloc: validate buddy before check its migratetype.

     Whenever a buddy page is found, page_is_buddy() should be called to
     check its validity.  Add the missing check during pageblock merge 
check.

     Fixes: 1dd214b8f21c ("mm: page_alloc: avoid merging 
non-fallbackable pageblocks with others")
     Link: 
https://lore.kernel.org/all/20220330154208.71aca532@gandalf.local.home/
     Reported-and-tested-by: Steven Rostedt <rostedt@goodmis.org>
     Signed-off-by: Zi Yan <ziy@nvidia.com>
     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

>
> thanks,
>
> greg k-h
