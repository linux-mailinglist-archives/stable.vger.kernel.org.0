Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5C2E2361
	for <lists+stable@lfdr.de>; Wed, 23 Oct 2019 21:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729081AbfJWTmk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Oct 2019 15:42:40 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:53644 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728697AbfJWTmj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Oct 2019 15:42:39 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04391;MF=yang.shi@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0Tg.I.VG_1571859431;
Received: from US-143344MP.local(mailfrom:yang.shi@linux.alibaba.com fp:SMTPD_---0Tg.I.VG_1571859431)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 24 Oct 2019 03:37:14 +0800
Subject: Re: [v2 PATCH] mm: thp: handle page cache THP correctly in
 PageTransCompoundMap
To:     Hugh Dickins <hughd@google.com>
Cc:     aarcange@redhat.com, kirill.shutemov@linux.intel.com,
        gavin.dg@linux.alibaba.com, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <1571850304-82802-1-git-send-email-yang.shi@linux.alibaba.com>
 <alpine.LSU.2.11.1910231157570.1088@eggly.anvils>
From:   Yang Shi <yang.shi@linux.alibaba.com>
Message-ID: <4d3c14ef-ee86-2719-70d6-68f1a8b42c28@linux.alibaba.com>
Date:   Wed, 23 Oct 2019 12:37:09 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:52.0)
 Gecko/20100101 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.11.1910231157570.1088@eggly.anvils>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 10/23/19 12:28 PM, Hugh Dickins wrote:
> On Thu, 24 Oct 2019, Yang Shi wrote:
>
>> We have usecase to use tmpfs as QEMU memory backend and we would like to
>> take the advantage of THP as well.  But, our test shows the EPT is not
>> PMD mapped even though the underlying THP are PMD mapped on host.
>> The number showed by /sys/kernel/debug/kvm/largepage is much less than
>> the number of PMD mapped shmem pages as the below:
>>
>> 7f2778200000-7f2878200000 rw-s 00000000 00:14 262232 /dev/shm/qemu_back_mem.mem.Hz2hSf (deleted)
>> Size:            4194304 kB
>> [snip]
>> AnonHugePages:         0 kB
>> ShmemPmdMapped:   579584 kB
>> [snip]
>> Locked:                0 kB
>>
>> cat /sys/kernel/debug/kvm/largepages
>> 12
>>
>> And some benchmarks do worse than with anonymous THPs.
>>
>> By digging into the code we figured out that commit 127393fbe597 ("mm:
>> thp: kvm: fix memory corruption in KVM with THP enabled") checks if
>> there is a single PTE mapping on the page for anonymous THP when
>> setting up EPT map.  But, the _mapcount < 0 check doesn't fit to page
>> cache THP since every subpage of page cache THP would get _mapcount
>> inc'ed once it is PMD mapped, so PageTransCompoundMap() always returns
>> false for page cache THP.  This would prevent KVM from setting up PMD
>> mapped EPT entry.
>>
>> So we need handle page cache THP correctly.  However, when page cache
>> THP's PMD gets split, kernel just remove the map instead of setting up
>> PTE map like what anonymous THP does.  Before KVM calls get_user_pages()
>> the subpages may get PTE mapped even though it is still a THP since the
>> page cache THP may be mapped by other processes at the mean time.
>>
>> Checking its _mapcount and whether the THP has PTE mapped or not.
>> Although this may report some false negative cases (PTE mapped by other
>> processes), it looks not trivial to make this accurate.
>>
>> With this fix /sys/kernel/debug/kvm/largepage would show reasonable
>> pages are PMD mapped by EPT as the below:
>>
>> 7fbeaee00000-7fbfaee00000 rw-s 00000000 00:14 275464 /dev/shm/qemu_back_mem.mem.SKUvat (deleted)
>> Size:            4194304 kB
>> [snip]
>> AnonHugePages:         0 kB
>> ShmemPmdMapped:   557056 kB
>> [snip]
>> Locked:                0 kB
>>
>> cat /sys/kernel/debug/kvm/largepages
>> 271
>>
>> And the benchmarks are as same as anonymous THPs.
>>
> Fixes: dd78fedde4b9 ("rmap: support file thp")

OK, though it might be the best blame target.

>
>> Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
>> Reported-by: Gang Deng <gavin.dg@linux.alibaba.com>
>> Tested-by: Gang Deng <gavin.dg@linux.alibaba.com>
>> Suggested-by: Hugh Dickins <hughd@google.com>
>> Cc: Andrea Arcangeli <aarcange@redhat.com>
>> Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
>> Cc: <stable@vger.kernel.org> 4.8+
>> ---
>> v2: Adopted the suggestion from Hugh to use _mapcount and compound_mapcount.
>>      But I just open coding compound_mapcount to avoid duplicating the
>>      definition of compound_mapcount_ptr in two different files.  Since
>>      "compound_mapcount" looks self-explained so I'm supposed the open
>>      coding would not affect the readability.
> No, relying on head[1] is not nice: Matthew's suggestion better.

Done in v3.

>
>>   include/linux/page-flags.h | 22 ++++++++++++++++++++--
>>   1 file changed, 20 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
>> index f91cb88..954a877 100644
>> --- a/include/linux/page-flags.h
>> +++ b/include/linux/page-flags.h
>> @@ -622,12 +622,30 @@ static inline int PageTransCompound(struct page *page)
>>    *
>>    * Unlike PageTransCompound, this is safe to be called only while
>>    * split_huge_pmd() cannot run from under us, like if protected by the
>> - * MMU notifier, otherwise it may result in page->_mapcount < 0 false
>> + * MMU notifier, otherwise it may result in page->_mapcount check false
>>    * positives.
>> + *
>> + * We have to treat page cache THP differently since every subpage of it
>> + * would get _mapcount inc'ed once it is PMD mapped.  But, it may be PTE
>> + * mapped in the current process so comparing subpage's _mapcount to
>> + * compound_mapcount ot filter out PTE mapped case.
> s/ ot / to /

oops, will fix it.

>
>>    */
>>   static inline int PageTransCompoundMap(struct page *page)
>>   {
>> -	return PageTransCompound(page) && atomic_read(&page->_mapcount) < 0;
>> +	struct page *head;
>> +	int map_count;
>> +
>> +	if (!PageTransCompound(page))
>> +		return 0;
>> +
>> +	if (PageAnon(page))
>> +		return atomic_read(&page->_mapcount) < 0;
>> +
>> +	head = compound_head(page);
>> +	map_count = atomic_read(&page->_mapcount);
>> +	/* File THP is PMD mapped and not double mapped */
> s/ double / PTE /

Will fix it.

>
>> +	return map_count >= 0 &&
> You have added a map_count >= 0 test there. Okay, not wrong, but not
> necessary, and not consistent with what's returned in the PageAnon
> case (if this were called for an unmapped page).

I was thinking about this too. I'm wondering there might be a case that 
the PMD is split and it was the last PMD map, in this case subpage's 
_mapcount is also equal to compound_mapcount (both is -1). So, it would 
return true, then KVM may setup PMD map in EPT, but it might be PTE 
mapped later on the host. But, I'm not quite sure if this is really 
possible or if this is really a integrity problem. So, I thought it 
might be safer to add this check.

>
> But asking for consistency in this function is asking for too much.
> It is *very* specialized to the particular places from which it is
> called (doesn't really belong in page-flags.h at all), and just so
> long as it gives them the right answer most of the time, and errs
> on the safe side the rest of the time, it'll do.
>
> (I don't know if it's ever called on a tail page: it would not crash
> if it were, but different tail pages may give different answers.)
>
>> +	       map_count == atomic_read(&head[1].compound_mapcount);
>>   }
>>   
>>   /*
>> -- 
>> 1.8.3.1
>>
>>

