Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4398D5A29AB
	for <lists+stable@lfdr.de>; Fri, 26 Aug 2022 16:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344513AbiHZOjX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Aug 2022 10:39:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbiHZOjS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Aug 2022 10:39:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 314ADD2EB5
        for <stable@vger.kernel.org>; Fri, 26 Aug 2022 07:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661524754;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ft0lQYVoEV6jBNoLlY/vGG48ZPsyM0mxyqwdiyDO9u0=;
        b=iykJV9Q6MvtbWi+Gidjr2jTTTXIihUOzdpkOcRUJW+9o35T6HlOS2CKxzBDlUIv9CIL5vi
        ojUNrFtQdN8rneaFpcuS1llILoST8EWr8pdEfhe6GxihzCyewejNJ0r4mMrQlhSkD7nfII
        taePEB3h5rp7AvnYf8CNDPOI2CblnTo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-505-IXPDwIVSOXWC9ukoEVhJqg-1; Fri, 26 Aug 2022 10:39:10 -0400
X-MC-Unique: IXPDwIVSOXWC9ukoEVhJqg-1
Received: by mail-wr1-f70.google.com with SMTP id t12-20020adfa2cc000000b00224f577fad1so192062wra.4
        for <stable@vger.kernel.org>; Fri, 26 Aug 2022 07:39:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:cc:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=Ft0lQYVoEV6jBNoLlY/vGG48ZPsyM0mxyqwdiyDO9u0=;
        b=Po6fnlUaLFLef4bAdKX4fl4kos0z4972eUGcBnqKHonELarv88Sbl6GBflgpnpOMNL
         3p34qa/g0T9gx5rG+DDdbsn2yxzdMD6Cy0bIXtohK81tyHP2KyVMzSXwhLU60LM+wgZ4
         3CSSCFxUN7OuBI9XQ1x4MzDTC+OScmEHeH5i/jq3mvjnqfWtE6YkUAJhXpNNV0LQzo4U
         etNILmBxPsYBOPYUfXXA3fktSSxhAK5Ey5rUkAMauYeQijKCtWIgVljdBKnaaE8hm5qk
         s1hqXVYQgnY+F+TrXa9XV/XthjZLfclgJvnZbp2OteBlL7vEE3D5Sjznly+gpD0/R6dg
         kYbQ==
X-Gm-Message-State: ACgBeo3cHOReNHyOPjV9y8zGMM7gvA1Wf/FYIYyEY3NtwfrSrK9u3kmx
        +VAVezjETUVSiNYCcf+q/hVeOa1kfPMThc9fGxBMF4olGM3OcqxN9neMYfglyzPI3NeFnxIIQn6
        UJgfSC+gjQaix4GYw
X-Received: by 2002:a05:600c:1f1a:b0:3a6:2569:496b with SMTP id bd26-20020a05600c1f1a00b003a62569496bmr5450957wmb.176.1661524749691;
        Fri, 26 Aug 2022 07:39:09 -0700 (PDT)
X-Google-Smtp-Source: AA6agR78RH87xC4FNL/JmgMsnjs3esusw3W4DDiJGKyeEE33BMY6II+9QepZiEzqEmrMzkzxyftCIg==
X-Received: by 2002:a05:600c:1f1a:b0:3a6:2569:496b with SMTP id bd26-20020a05600c1f1a00b003a62569496bmr5450936wmb.176.1661524749334;
        Fri, 26 Aug 2022 07:39:09 -0700 (PDT)
Received: from ?IPV6:2003:cb:c708:f600:abad:360:c840:33fa? (p200300cbc708f600abad0360c84033fa.dip0.t-ipconnect.de. [2003:cb:c708:f600:abad:360:c840:33fa])
        by smtp.gmail.com with ESMTPSA id q12-20020adfcd8c000000b00225206dd595sm2100027wrj.86.2022.08.26.07.39.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Aug 2022 07:39:08 -0700 (PDT)
Message-ID: <ca62c992-6242-5e82-22de-a6e8ffa824b1@redhat.com>
Date:   Fri, 26 Aug 2022 16:39:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Content-Language: en-US
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>, stable@vger.kernel.org,
        Yu Zhao <yuzhao@google.com>
References: <20220823221138.45602-1-peterx@redhat.com>
 <411d7b8c-f914-875e-b397-856e6a894366@redhat.com>
 <YwjXxC2BbJ5+3Isx@xz-m1.local>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH] mm/mprotect: Only reference swap pfn page if type match
In-Reply-To: <YwjXxC2BbJ5+3Isx@xz-m1.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 26.08.22 16:25, Peter Xu wrote:
> On Fri, Aug 26, 2022 at 12:49:37PM +0200, David Hildenbrand wrote:
>> On 24.08.22 00:11, Peter Xu wrote:
>>> Yu Zhao reported a bug after the commit "mm/swap: Add swp_offset_pfn() to
>>> fetch PFN from swap entry" added a check in swp_offset_pfn() for swap type [1]:
>>>
>>>   kernel BUG at include/linux/swapops.h:117!
>>>   CPU: 46 PID: 5245 Comm: EventManager_De Tainted: G S         O L 6.0.0-dbg-DEV #2
>>>   RIP: 0010:pfn_swap_entry_to_page+0x72/0xf0
>>>   Code: c6 48 8b 36 48 83 fe ff 74 53 48 01 d1 48 83 c1 08 48 8b 09 f6
>>>   c1 01 75 7b 66 90 48 89 c1 48 8b 09 f6 c1 01 74 74 5d c3 eb 9e <0f> 0b
>>>   48 ba ff ff ff ff 03 00 00 00 eb ae a9 ff 0f 00 00 75 13 48
>>>   RSP: 0018:ffffa59e73fabb80 EFLAGS: 00010282
>>>   RAX: 00000000ffffffe8 RBX: 0c00000000000000 RCX: ffffcd5440000000
>>>   RDX: 1ffffffffff7a80a RSI: 0000000000000000 RDI: 0c0000000000042b
>>>   RBP: ffffa59e73fabb80 R08: ffff9965ca6e8bb8 R09: 0000000000000000
>>>   R10: ffffffffa5a2f62d R11: 0000030b372e9fff R12: ffff997b79db5738
>>>   R13: 000000000000042b R14: 0c0000000000042b R15: 1ffffffffff7a80a
>>>   FS:  00007f549d1bb700(0000) GS:ffff99d3cf680000(0000) knlGS:0000000000000000
>>>   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>   CR2: 0000440d035b3180 CR3: 0000002243176004 CR4: 00000000003706e0
>>>   DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>>   DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>>>   Call Trace:
>>>    <TASK>
>>>    change_pte_range+0x36e/0x880
>>>    change_p4d_range+0x2e8/0x670
>>>    change_protection_range+0x14e/0x2c0
>>>    mprotect_fixup+0x1ee/0x330
>>>    do_mprotect_pkey+0x34c/0x440
>>>    __x64_sys_mprotect+0x1d/0x30
>>>
>>> It triggers because pfn_swap_entry_to_page() could be called upon e.g. a
>>> genuine swap entry.
>>>
>>> Fix it by only calling it when it's a write migration entry where the page*
>>> is used.
>>>
>>> [1] https://lore.kernel.org/lkml/CAOUHufaVC2Za-p8m0aiHw6YkheDcrO-C3wRGixwDS32VTS+k1w@mail.gmail.com/
>>>
>>> Fixes: 6c287605fd56 ("mm: remember exclusively mapped anonymous pages with PG_anon_exclusive")
>>> Cc: David Hildenbrand <david@redhat.com>
>>> Cc: <stable@vger.kernel.org>
>>> Reported-by: Yu Zhao <yuzhao@google.com>
>>> Signed-off-by: Peter Xu <peterx@redhat.com>
>>> ---
>>>  mm/mprotect.c | 3 ++-
>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/mm/mprotect.c b/mm/mprotect.c
>>> index f2b9b1da9083..4549f5945ebe 100644
>>> --- a/mm/mprotect.c
>>> +++ b/mm/mprotect.c
>>> @@ -203,10 +203,11 @@ static unsigned long change_pte_range(struct mmu_gather *tlb,
>>>  			pages++;
>>>  		} else if (is_swap_pte(oldpte)) {
>>>  			swp_entry_t entry = pte_to_swp_entry(oldpte);
>>> -			struct page *page = pfn_swap_entry_to_page(entry);
>>>  			pte_t newpte;
>>>  
>>>  			if (is_writable_migration_entry(entry)) {
>>> +				struct page *page = pfn_swap_entry_to_page(entry);
>>> +
>>>  				/*
>>>  				 * A protection check is difficult so
>>>  				 * just be safe and disable write
>>
>>
>> Stumbling over the THP code, I was wondering if we also want to adjust change_huge_pmd()
>> and hugetlb_change_protection. There are no actual swap entries, so I assume we're fine.
>>
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 482c1826e723..466364e7fc5f 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -1798,10 +1798,10 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>>  #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
>>         if (is_swap_pmd(*pmd)) {
>>                 swp_entry_t entry = pmd_to_swp_entry(*pmd);
>> -               struct page *page = pfn_swap_entry_to_page(entry);
>>  
>>                 VM_BUG_ON(!is_pmd_migration_entry(*pmd));
>>                 if (is_writable_migration_entry(entry)) {
>> +                       struct page *page = pfn_swap_entry_to_page(entry);
>>                         pmd_t newpmd;
>>                         /*
>>                          * A protection check is difficult so
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index 2480ba627aa5..559465fae5cd 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -6370,9 +6370,9 @@ unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
>>                 }
>>                 if (unlikely(is_hugetlb_entry_migration(pte))) {
>>                         swp_entry_t entry = pte_to_swp_entry(pte);
>> -                       struct page *page = pfn_swap_entry_to_page(entry);
>>  
>>                         if (!is_readable_migration_entry(entry)) {
>> +                               struct page *page = pfn_swap_entry_to_page(entry);
>>                                 pte_t newpte;
>>  
>>                                 if (PageAnon(page))
>>
>>
>> @Peter, what's your thought?
> 
> IMHO they're not needed?
> 
> The rule is simple in my mind: we should only pass in a pfn-typed swap
> entry into pfn_swap_entry_to_page() (or the new swp_offset_pfn()), or it's
> a violation of the API.  In these two cases they do not violate the API and
> they're always safe because they're guaranteed to be pfn swap entries when
> calling.

I was wondering about extreme corner cases regarding the struct page.

Assume we have a hwpoison_entry that pointed at a valid struct page. We
can succeed in offlining+removing the section it's located on (I was
recently challenging if we want to keep that behavior as it's really
shaky already), freeing the relevant memmap entry and the memory section.

pfn_swap_entry_to_page() -> pfn_to_page() would be problematic if there
is no memmap anymore.


I assume it's ok to always call it for is_pfn_swap_entry(), but in the
PMD case we only check for is_swap_pmd()? Isn't that problematic?


I was confused by the hugetlb case, it's indeed fine as we check for
is_hugetlb_entry_migration().

-- 
Thanks,

David / dhildenb

