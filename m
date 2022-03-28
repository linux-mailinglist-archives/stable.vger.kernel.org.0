Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 565FE4E8BFA
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 04:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235032AbiC1CPs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 22:15:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231757AbiC1CPs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 22:15:48 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD5F2608;
        Sun, 27 Mar 2022 19:14:07 -0700 (PDT)
Received: from canpemm500002.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KRbpl3yLXzcb5Z;
        Mon, 28 Mar 2022 10:13:51 +0800 (CST)
Received: from [10.174.177.76] (10.174.177.76) by
 canpemm500002.china.huawei.com (7.192.104.244) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 28 Mar 2022 10:14:05 +0800
Subject: Re: [PATCH] mm,hwpoison: unmap poisoned page before invalidation
To:     Rik van Riel <riel@surriel.com>
CC:     <linux-mm@kvack.org>, <kernel-team@fb.com>,
        Oscar Salvador <osalvador@suse.de>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        <stable@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20220325161428.5068d97e@imladris.surriel.com>
 <e6aa40b9-1cd8-b13f-555b-5f8ad863f196@huawei.com>
 <5b734809fef4d76944490d5ac3ea816f0756b90a.camel@surriel.com>
From:   Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <e3e3ae0f-50f6-6b13-c520-26aac353e0cb@huawei.com>
Date:   Mon, 28 Mar 2022 10:14:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <5b734809fef4d76944490d5ac3ea816f0756b90a.camel@surriel.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.76]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500002.china.huawei.com (7.192.104.244)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022/3/27 4:14, Rik van Riel wrote:
> On Sat, 2022-03-26 at 15:48 +0800, Miaohe Lin wrote:
>> On 2022/3/26 4:14, Rik van Riel wrote:
>>>
>>> +++ b/mm/memory.c
>>> @@ -3918,14 +3918,18 @@ static vm_fault_t __do_fault(struct
>>> vm_fault *vmf)
>>>                 return ret;
>>>  
>>>         if (unlikely(PageHWPoison(vmf->page))) {
>>> +               struct page *page = vmf->page;
>>>                 vm_fault_t poisonret = VM_FAULT_HWPOISON;
>>>                 if (ret & VM_FAULT_LOCKED) {
>>> +                       if (page_mapped(page))
>>> +                               unmap_mapping_pages(page_mapping(pa
>>> ge),
>>> +                                                   page->index, 1,
>>> false);
>>
>> It seems this unmap_mapping_pages also helps the success rate of the
>> below invalidate_inode_page.
>>
> 
> That is indeed what it is supposed to do.
> 
> It isn't fool proof, since you can still end up
> with dirty pages that don't get cleaned immediately,
> but it seems to turn infinite loops of a program
> being killed every time it's started into a more
> manageable situation where the task succeeds again
> pretty quickly.

Looks convincing to me.

> 
>>>                         /* Retry if a clean page was removed from
>>> the cache. */
>>> -                       if (invalidate_inode_page(vmf->page))
>>> -                               poisonret = 0;
>>> -                       unlock_page(vmf->page);
>>> +                       if (invalidate_inode_page(page))
>>> +                               poisonret = VM_FAULT_NOPAGE;
>>> +                       unlock_page(page);
>>>                 }
>>> -               put_page(vmf->page);
>>> +               put_page(page);
>>
>> Do we use page instead of vmf->page just for simplicity? Or there is
>> some other concern?
>>
> 
> Just a simplification, and not dereferencing the same thing
> 6 times.
> 

I see. :)

>>>                 vmf->page = NULL;
>>
>> We return either VM_FAULT_NOPAGE or VM_FAULT_HWPOISON with vmf->page
>> = NULL. If any case,
>> finish_fault won't be called later. So I think your fix is right.
> 
> Want to send in a Reviewed-by or Acked-by? :)
> 

Sure, but when I think more about this, it seems this fix isn't ideal:
If VM_FAULT_NOPAGE is returned with page table unset, the process will
re-trigger page fault again and again until invalidate_inode_page succeeds
to evict the inode page. This might hang the process a really long time.
Or am I miss something?

Thanks.
