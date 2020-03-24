Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84C991903A0
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 03:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbgCXCiC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Mar 2020 22:38:02 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:12180 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726824AbgCXCiB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Mar 2020 22:38:01 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id A08EEAD13A6A126C81F7;
        Tue, 24 Mar 2020 10:37:58 +0800 (CST)
Received: from [10.173.228.124] (10.173.228.124) by smtp.huawei.com
 (10.3.19.207) with Microsoft SMTP Server (TLS) id 14.3.487.0; Tue, 24 Mar
 2020 10:37:50 +0800
Subject: Re: [PATCH v2] mm/hugetlb: fix a addressing exception caused by
 huge_pte_offset()
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        Mike Kravetz <mike.kravetz@oracle.com>
CC:     <akpm@linux-foundation.org>, <kirill.shutemov@linux.intel.com>,
        <linux-kernel@vger.kernel.org>, <arei.gonglei@huawei.com>,
        <weidong.huang@huawei.com>, <weifuqiang@huawei.com>,
        <kvm@vger.kernel.org>, <linux-mm@kvack.org>,
        Matthew Wilcox <willy@infradead.org>,
        "Sean Christopherson" <sean.j.christopherson@intel.com>,
        <stable@vger.kernel.org>
References: <1582342427-230392-1-git-send-email-longpeng2@huawei.com>
 <51a25d55-de49-4c0a-c994-bf1a8cfc8638@oracle.com>
 <20200323160955.GY20941@ziepe.ca>
 <69055395-e7e5-a8e2-7f3e-f61607149318@oracle.com>
 <20200323180706.GC20941@ziepe.ca>
 <88698dd7-eb87-4b0b-7ba7-44ef6eab6a6c@oracle.com>
 <20200323225225.GF20941@ziepe.ca>
From:   "Longpeng (Mike, Cloud Infrastructure Service Product Dept.)" 
        <longpeng2@huawei.com>
Message-ID: <e8e71ba4-d609-269a-6160-153e373e7563@huawei.com>
Date:   Tue, 24 Mar 2020 10:37:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20200323225225.GF20941@ziepe.ca>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.228.124]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2020/3/24 6:52, Jason Gunthorpe wrote:
> On Mon, Mar 23, 2020 at 01:35:07PM -0700, Mike Kravetz wrote:
>> On 3/23/20 11:07 AM, Jason Gunthorpe wrote:
>>> On Mon, Mar 23, 2020 at 10:27:48AM -0700, Mike Kravetz wrote:
>>>
>>>>>  	pgd = pgd_offset(mm, addr);
>>>>> -	if (!pgd_present(*pgd))
>>>>> +	if (!pgd_present(READ_ONCE(*pgd)))
>>>>>  		return NULL;
>>>>>  	p4d = p4d_offset(pgd, addr);
>>>>> -	if (!p4d_present(*p4d))
>>>>> +	if (!p4d_present(READ_ONCE(*p4d)))
>>>>>  		return NULL;
>>>>>  
>>>>>       pud = pud_offset(p4d, addr);
>>>>
>>>> One would argue that pgd and p4d can not change from present to !present
>>>> during the execution of this code.  To me, that seems like the issue which
>>>> would cause an issue.  Of course, I could be missing something.
>>>
>>> This I am not sure of, I think it must be true under the read side of
>>> the mmap_sem, but probably not guarenteed under RCU..
>>>
>>> In any case, it doesn't matter, the fact that *p4d can change at all
>>> is problematic. Unwinding the above inlines we get:
>>>
>>>   p4d = p4d_offset(pgd, addr)
>>>   if (!p4d_present(*p4d))
>>>       return NULL;
>>>   pud = (pud_t *)p4d_page_vaddr(*p4d) + pud_index(address);
>>>
>>> According to our memory model the compiler/CPU is free to execute this
>>> as:
>>>
>>>   p4d = p4d_offset(pgd, addr)
>>>   p4d_for_vaddr = *p4d;
>>>   if (!p4d_present(*p4d))
>>>       return NULL;
>>>   pud = (pud_t *)p4d_page_vaddr(p4d_for_vaddr) + pud_index(address);
>>>
>>
>> Wow!  How do you know this?  You don't need to answer :)
> 
> It says explicitly in Documentation/memory-barriers.txt - see
> section COMPILER BARRIER:
> 
>  (*) The compiler is within its rights to reorder loads and stores
>      to the same variable, and in some cases, the CPU is within its
>      rights to reorder loads to the same variable.  This means that
>      the following code:
> 
>         a[0] = x;
>         a[1] = x;
> 
>      Might result in an older value of x stored in a[1] than in a[0].
> 
> It also says READ_ONCE puts things in program order, but we don't use
> READ_ONCE inside pud_offset(), so it doesn't help us.
> 
> Best answer is to code things so there is exactly one dereference of
> the pointer protected by READ_ONCE. Very clear to read, very safe.
> 
> Maybe Longpeng can rework the patch around these principles?
> 
Thanks Jason and Mike, I learn a lot from your analysis.

So... the patch should like this ?

@@ -4909,29 +4909,33 @@ pte_t *huge_pte_offset(struct mm_struct *mm,
 		       unsigned long addr, unsigned long sz)
 {
 	pgd_t *pgd;
-	p4d_t *p4d;
-	pud_t *pud;
-	pmd_t *pmd;
+	p4d_t *p4g, p4d_entry;
+	pud_t *pud, pud_entry;
+	pmd_t *pmd, pmd_entry;

 	pgd = pgd_offset(mm, addr);
 	if (!pgd_present(*pgd))
 		return NULL;
-	p4d = p4d_offset(pgd, addr);
-	if (!p4d_present(*p4d))
+
+	p4g = p4d_offset(pgd, addr);
+	p4d_entry = READ_ONCE(*p4g);
+	if (!p4d_present(p4d_entry))
 		return NULL;

-	pud = pud_offset(p4d, addr);
-	if (sz != PUD_SIZE && pud_none(*pud))
+	pud = pud_offset(&p4d_entry, addr);
+	pud_entry = READ_ONCE(*pud);
+	if (sz != PUD_SIZE && pud_none(pud_entry))
 		return NULL;
 	/* hugepage or swap? */
-	if (pud_huge(*pud) || !pud_present(*pud))
+	if (pud_huge(pud_entry) || !pud_present(pud_entry))
 		return (pte_t *)pud;

-	pmd = pmd_offset(pud, addr);
-	if (sz != PMD_SIZE && pmd_none(*pmd))
+	pmd = pmd_offset(&pud_entry, addr);
+	pmd_entry = READ_ONCE(*pmd);
+	if (sz != PMD_SIZE && pmd_none(pmd_entry))
 		return NULL;
 	/* hugepage or swap? */
-	if (pmd_huge(*pmd) || !pmd_present(*pmd))
+	if (pmd_huge(pmd_entry) || !pmd_present(pmd_entry))
 		return (pte_t *)pmd;

> Also I wonder if the READ_ONCE(*pmdp) is OK. gup_pmd_range() uses it,
> but I can't explain why it shouldn't be pmd_read_atomic().
> 
>>> In the case where p4 goes from !present -> present (ie
>>> handle_mm_fault()):
>>>
>>> p4d_for_vaddr == p4d_none, and p4d_present(*p4d) == true, meaning the
>>> p4d_page_vaddr() will crash.
>>>
>>> Basically the problem here is not just missing READ_ONCE, but that the
>>> p4d is read multiple times at all. It should be written like gup_fast
>>> does, to guarantee a single CPU read of the unstable data:
>>>
>>>   p4d = READ_ONCE(*p4d_offset(pgdp, addr));
>>>   if (!p4d_present(p4))
>>>       return NULL;
>>>   pud = pud_offset(&p4d, addr);
>>>
>>> At least this is what I've been able to figure out :\
>>
>> In that case, I believe there are a bunch of similar routines with this issue.
> 
> Yes, my look around page walk related users makes me come to a similar
> worry.
> 
> Fortunately, I think this is largely theoretical as most likely the
> compiler will generate a single store for these coding patterns. 
> 
> That said, there have been bugs in the past, see commit 26c191788f18
> ("mm: pmd_read_atomic: fix 32bit PAE pmd walk vs pmd_populate SMP race
> condition") which is significantly related to the compiler lifting a
> load inside pte_offset to before the required 'if (pmd_*)' checks.
> 
>> For this patch, I was primarily interested in seeing the obvious
>> multiple dereferences in C fixed up.  This is above and beyond that!
>> :)
> 
> Well, I think it is worth solving the underlying problem
> properly. Otherwise we get weird solutions to data races like
> pmd_trans_unstable()...
> 
> Jason
> .
> 

---
Regards,
Longpeng(Mike)
