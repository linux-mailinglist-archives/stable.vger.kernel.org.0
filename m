Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B27C654CE79
	for <lists+stable@lfdr.de>; Wed, 15 Jun 2022 18:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344363AbiFOQTA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jun 2022 12:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355290AbiFOQSR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jun 2022 12:18:17 -0400
Received: from out199-6.us.a.mail.aliyun.com (out199-6.us.a.mail.aliyun.com [47.90.199.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BCA452E70;
        Wed, 15 Jun 2022 09:16:39 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=xianting.tian@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0VGTX79V_1655309728;
Received: from 192.168.1.6(mailfrom:xianting.tian@linux.alibaba.com fp:SMTPD_---0VGTX79V_1655309728)
          by smtp.aliyun-inc.com;
          Thu, 16 Jun 2022 00:15:30 +0800
Subject: Re: [RESEND PATCH] mm: page_alloc: validate buddy before check the
 migratetype
To:     Zi Yan <ziy@nvidia.com>
Cc:     Guo Ren <guoren@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, huanyi.xj@alibaba-inc.com,
        zjb194813@alibaba-inc.com, tianhu.hh@alibaba-inc.com,
        Hanjun Guo <guohanjun@huawei.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Laura Abbott <labbott@redhat.com>
References: <20220613131046.3009889-1-xianting.tian@linux.alibaba.com>
 <0262A4FB-5A9B-47D3-8F1A-995509F56279@nvidia.com>
 <CAJF2gTQGXAubtas4wAzrg298dGQJntu38X48V2OzcK8xZ_vPJg@mail.gmail.com>
 <D667F530-E286-4E75-B7CE-63E120E440C8@nvidia.com>
 <CAJF2gTSsaaseds=T_y-Ddt5Np2rYhk3ENumzSZDZUSXFwT3u-g@mail.gmail.com>
 <435B45C3-E6A5-43B2-A5A2-318C748691FC@nvidia.com>
 <b65b9edd-ff3e-aa44-029a-49fa5ba66b47@linux.alibaba.com>
 <18330D9A-F433-4136-A226-F24173293BF3@nvidia.com>
From:   Xianting Tian <xianting.tian@linux.alibaba.com>
Message-ID: <5526fab6-c7e1-bddc-912b-e4d9b2769d4e@linux.alibaba.com>
Date:   Thu, 16 Jun 2022 00:15:28 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <18330D9A-F433-4136-A226-F24173293BF3@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-11.1 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


在 2022/6/15 下午9:55, Zi Yan 写道:
> On 15 Jun 2022, at 2:47, Xianting Tian wrote:
>
>> 在 2022/6/14 上午8:14, Zi Yan 写道:
>>> On 13 Jun 2022, at 19:47, Guo Ren wrote:
>>>
>>>> On Tue, Jun 14, 2022 at 3:49 AM Zi Yan <ziy@nvidia.com> wrote:
>>>>> On 13 Jun 2022, at 12:32, Guo Ren wrote:
>>>>>
>>>>>> On Mon, Jun 13, 2022 at 11:23 PM Zi Yan <ziy@nvidia.com> wrote:
>>>>>>> Hi Xianting,
>>>>>>>
>>>>>>> Thanks for your patch.
>>>>>>>
>>>>>>> On 13 Jun 2022, at 9:10, Xianting Tian wrote:
>>>>>>>
>>>>>>>> Commit 787af64d05cd ("mm: page_alloc: validate buddy before check its migratetype.")
>>>>>>>> added buddy check code. But unfortunately, this fix isn't backported to
>>>>>>>> linux-5.17.y and the former stable branches. The reason is it added wrong
>>>>>>>> fixes message:
>>>>>>>>        Fixes: 1dd214b8f21c ("mm: page_alloc: avoid merging non-fallbackable
>>>>>>>>                            pageblocks with others")
>>>>>>> No, the Fixes tag is right. The commit above does need to validate buddy.
>>>>>> I think Xianting is right. The “Fixes:" tag is not accurate and the
>>>>>> page_is_buddy() is necessary here.
>>>>>>
>>>>>> This patch could be applied to the early version of the stable tree
>>>>>> (eg: Linux-5.10.y, not the master tree)
>>>>> This is quite misleading. Commit 787af64d05cd applies does not mean it is
>>>>> intended to fix the preexisting bug. Also it does not apply cleanly
>>>>> to commit d9dddbf55667, there is a clear indentation mismatch. At best,
>>>>> you can say the way of 787af64d05cd fixing 1dd214b8f21c also fixes d9dddbf55667.
>>>>> There is no way you can apply 787af64d05cd to earlier trees and call it a day.
>>>>>
>>>>> You can mention 787af64d05cd that it fixes a bug in 1dd214b8f21c and there is
>>>>> a similar bug in d9dddbf55667 that can be fixed in a similar way too. Saying
>>>>> the fixes message is wrong just misleads people, making them think there is
>>>>> no bug in 1dd214b8f21c. We need to be clear about this.
>>>> First, d9dddbf55667 is earlier than 1dd214b8f21c in Linus tree. The
>>>> origin fixes could cover the Linux-5.0.y tree if they give the
>>>> accurate commit number and that is the cause we want to point out.
>>> Yes, I got that d9dddbf55667 is earlier and commit 787af64d05cd fixes
>>> the issue introduced by d9dddbf55667. But my point is that 787af64d05cd
>>> is not intended to fix d9dddbf55667 and saying it has a wrong fixes
>>> message is misleading. This is the point I want to make.
>>>
>>>> Second, if the patch is for d9dddbf55667 then it could cover any tree
>>>> in the stable repo. Actually, we only know Linux-5.10.y has the
>>>> problem.
>>> But it is not and does not apply to d9dddbf55667 cleanly.
>>>
>>>> Maybe, Gregkh could help to direct us on how to deal with the issue:
>>>> (Fixup a bug which only belongs to the former stable branch.)
>>>>
>>> I think you just need to send this patch without saying “commit
>>> 787af64d05cd fixes message is wrong” would be a good start. You also
>>> need extra fix to mm/page_isolation.c for kernels between 5.15 and 5.17
>>> (inclusive). So there will need to be two patches:
>>>
>>> 1) your patch to stable tree prior to 5.15 and
>>>
>>> 2) your patch with an additional mm/page_isolation.c fix to stable tree
>>> between 5.15 and 5.17.
>>>
>>>>> Also, you will need to fix the mm/page_isolation.c code too to make this patch
>>>>> complete, unless you can show that PFN=0x1000 is never going to be encountered
>>>>> in the mm/page_isolation.c code I mentioned below.
>>>> No, we needn't fix mm/page_isolation.c in linux-5.10.y, because it had
>>>> pfn_valid_within(buddy_pfn) check after __find_buddy_pfn() to prevent
>>>> buddy_pfn=0.
>>>> The root cause comes from __find_buddy_pfn():
>>>> return page_pfn ^ (1 << order);
>>> Right. But pfn_valid_within() was removed since 5.15. So your fix is
>>> required for kernels between 5.15 and 5.17 (inclusive).
>>>
>>>> When page_pfn is the same as the order size, it will return the
>>>> previous buddy not the next. That is the only exception for this
>>>> algorithm, right?
>>>>
>>>>
>>>>
>>>>
>>>> In fact, the bug is a very long time to reproduce and is not easy to
>>>> debug, so we want to contribute it to the community to prevent other
>>>> guys from wasting time. Although there is no new patch at all.
>>> Thanks for your reporting and sending out the patch. I really
>>> appreciate it. We definitely need your inputs. Throughout the email
>>> thread, I am trying to help you clarify the bug and how to fix it
>>> properly:
>>>
>>> 1. The commit 787af64d05cd does not apply cleanly to commits
>>> d9dddbf55667, meaning you cannot just cherry-pick that commit to
>>> fix the issue. That is why we need your patch to fix the issue.
>>> And saying it has a wrong fixes message in this patch’s git log is
>>> misleading.
>>>
>>> 2. For kernels between 5.15 and 5.17 (inclusive), an additional fix
>>> to mm/page_isolation.c is also needed, since pfn_valid_within() was
>>> removed since 5.15 and the issue can appear during page isolation.
>>>
>>> 3. For kernels before 5.15, this patch will apply.
>> Zi Yan, Guo Ren,
>>
>> I think we still need some imporvemnt for MASTER branch, as we discussed above, we will get an illegal buddy page if buddy_pfn is 0,
>>
>> within page_is_buddy(), it still use the illegal buddy page to do the check. I think in most of cases, page_is_buddy() can return false,  but it still may return true with very low probablity.
> Can you elaborate more on this? What kind of page can lead to page_is_buddy()
> returning true? You said it is buddy_pfn is 0, but if the page is reserved,
> if (!page_is_guard(buddy) && !PageBuddy(buddy)) should return false.
> Maybe show us the dump_page() that offending page.
>
> Thanks.

Let‘s take the issue we met on RISC-V arch for example,

pfn_base is 512 as we reserved 2M RAM for opensbi, mem_map's value is 
0xffffffe07e205000, which is the page address of PFN 512.

__find_buddy_pfn() returned 0 for PFN 0x2000 with order 0xd.
We know PFN 0 is not a valid pfn for buddy system, because 512 is the first PFN for buddy system.

Then it use below code to get buddy page with buddy_pfn 0:
buddy = page + (buddy_pfn - pfn);
So buddy page address is:
0xffffffe07e1fe000 = (struct page*)0xffffffe07e26e000 + (0 - 0x2000)

we can know this buddy page's address is less than mem_map(0xffffffe07e1fe000 < 0xffffffe07e205000),
actually 0xffffffe07e1fe000 is not a valid page's address. If we use 0xffffffe07e1fe000
as the page's address to extract the value of a member in 'struct page', we may get an uncertain value.
That's why I say page_is_buddy() may return true with very low probablity.

So I think we need to add the code the verify buddy_pfn in the first place:
	pfn_valid(buddy_pfn)

>> I think we need to add some code to verify buddy_pfn in the first place.
>>
>> Could you give some suggestions for this idea?
>>
>>>>>>>> Actually, this issue is involved by commit:
>>>>>>>>        commit d9dddbf55667 ("mm/page_alloc: prevent merging between isolated and other pageblocks")
>>>>>>>>
>>>>>>>> For RISC-V arch, the first 2M is reserved for sbi, so the start PFN is 512,
>>>>>>>> but it got buddy PFN 0 for PFN 0x2000:
>>>>>>>>        0 = 0x2000 ^ (1 << 12)
>>>>>>>> With the illegal buddy PFN 0, it got an illegal buddy page, which caused
>>>>>>>> crash in __get_pfnblock_flags_mask().
>>>>>>> It seems that the RISC-V arch reveals a similar bug from d9dddbf55667.
>>>>>>> Basically, this bug will only happen when PFN=0x2000 is merging up and
>>>>>>> there are some isolated pageblocks.
>>>>>> Not PFN=0x2000, it's PFN=0x1000, I guess.
>>>>>>
>>>>>> RISC-V's first 2MB RAM could reserve for opensbi, so it would have
>>>>>> riscv_pfn_base=512 and mem_map began with 512th PFN when
>>>>>> CONFIG_FLATMEM=y.
>>>>>> (Also, csky has the same issue: a non-zero pfn_base in some scenarios.)
>>>>>>
>>>>>> But __find_buddy_pfn algorithm thinks the start address is 0, it could
>>>>>> get 0 pfn or less than the pfn_base value. We need another check to
>>>>>> prevent that.
>>>>>>
>>>>>>> BTW, what does first reserved 2MB imply? All 4KB pages from first 2MB are
>>>>>>> set to PageReserved?
>>>>>>>
>>>>>>>> With the patch, it can avoid the calling of get_pageblock_migratetype() if
>>>>>>>> it isn't buddy page.
>>>>>>> You might miss the __find_buddy_pfn() caller in unset_migratetype_isolate()
>>>>>>> from mm/page_isolation.c, if you are talking about linux-5.17.y and former
>>>>>>> version. There, page_is_buddy() is also not called and is_migrate_isolate_page()
>>>>>>> is called, which calls get_pageblock_migratetype() too.
>>>>>>>
>>>>>>>> Fixes: d9dddbf55667 ("mm/page_alloc: prevent merging between isolated and other pageblocks")
>>>>>>>> Cc: stable@vger.kernel.org
>>>>>>>> Reported-by: zjb194813@alibaba-inc.com
>>>>>>>> Reported-by: tianhu.hh@alibaba-inc.com
>>>>>>>> Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
>>>>>>>> ---
>>>>>>>>    mm/page_alloc.c | 3 +++
>>>>>>>>    1 file changed, 3 insertions(+)
>>>>>>>>
>>>>>>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>>>>>>> index b1caa1c6c887..5b423caa68fd 100644
>>>>>>>> --- a/mm/page_alloc.c
>>>>>>>> +++ b/mm/page_alloc.c
>>>>>>>> @@ -1129,6 +1129,9 @@ static inline void __free_one_page(struct page *page,
>>>>>>>>
>>>>>>>>                         buddy_pfn = __find_buddy_pfn(pfn, order);
>>>>>>>>                         buddy = page + (buddy_pfn - pfn);
>>>>>>>> +
>>>>>>>> +                     if (!page_is_buddy(page, buddy, order))
>>>>>>>> +                             goto done_merging;
>>>>>>>>                         buddy_mt = get_pageblock_migratetype(buddy);
>>>>>>>>
>>>>>>>>                         if (migratetype != buddy_mt
>>>>>>>> --
>>>>>>>> 2.17.1
>>>>>>> --
>>>>>>> Best Regards,
>>>>>>> Yan, Zi
>>>>>>
>>>>>> --
>>>>>> Best Regards
>>>>>>    Guo Ren
>>>>>>
>>>>>> ML: https://lore.kernel.org/linux-csky/
>>>>> --
>>>>> Best Regards,
>>>>> Yan, Zi
>>>>
>>>> -- 
>>>> Best Regards
>>>>    Guo Ren
>>>>
>>>> ML: https://lore.kernel.org/linux-csky/
>>> --
>>> Best Regards,
>>> Yan, Zi
> --
> Best Regards,
> Yan, Zi
