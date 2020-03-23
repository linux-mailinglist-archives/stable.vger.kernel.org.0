Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECEB018EE93
	for <lists+stable@lfdr.de>; Mon, 23 Mar 2020 04:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgCWDnV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Mar 2020 23:43:21 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:50272 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726979AbgCWDnV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Mar 2020 23:43:21 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 72D3B7BDC1BD720A4460;
        Mon, 23 Mar 2020 11:43:16 +0800 (CST)
Received: from [10.173.228.124] (10.173.228.124) by smtp.huawei.com
 (10.3.19.202) with Microsoft SMTP Server (TLS) id 14.3.487.0; Mon, 23 Mar
 2020 11:43:10 +0800
Subject: Re: [PATCH v2] mm/hugetlb: fix a addressing exception caused by
 huge_pte_offset()
To:     Mike Kravetz <mike.kravetz@oracle.com>
CC:     <akpm@linux-foundation.org>, <kirill.shutemov@linux.intel.com>,
        <linux-kernel@vger.kernel.org>, <arei.gonglei@huawei.com>,
        <weidong.huang@huawei.com>, <weifuqiang@huawei.com>,
        <kvm@vger.kernel.org>, <linux-mm@kvack.org>,
        Matthew Wilcox <willy@infradead.org>,
        "Sean Christopherson" <sean.j.christopherson@intel.com>,
        <stable@vger.kernel.org>
References: <1582342427-230392-1-git-send-email-longpeng2@huawei.com>
 <51a25d55-de49-4c0a-c994-bf1a8cfc8638@oracle.com>
 <5700f44e-9df9-1b12-bc29-68e0463c2860@huawei.com>
 <e16fe81b-5c4c-e689-2f48-214f2025df2f@oracle.com>
From:   "Longpeng (Mike, Cloud Infrastructure Service Product Dept.)" 
        <longpeng2@huawei.com>
Message-ID: <e5ee0ed4-6af6-27af-1a0c-6eab3727768a@huawei.com>
Date:   Mon, 23 Mar 2020 11:43:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <e16fe81b-5c4c-e689-2f48-214f2025df2f@oracle.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.228.124]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2020/3/23 10:54, Mike Kravetz wrote:
> On 3/22/20 7:03 PM, Longpeng (Mike, Cloud Infrastructure Service Product Dept.) wrote:
>>
>>
>> On 2020/3/22 7:38, Mike Kravetz wrote:
>>> On 2/21/20 7:33 PM, Longpeng(Mike) wrote:
>>>> From: Longpeng <longpeng2@huawei.com>
>>>>
>>>> Our machine encountered a panic(addressing exception) after run
>>>> for a long time and the calltrace is:

[snip]

>>>>
>>>> We can avoid this race by read the pud only once. What's more, we also use
>>>> READ_ONCE to access the entries for safe(e.g. avoid the compilier mischief)
>>>>
>>>> Cc: Matthew Wilcox <willy@infradead.org>
>>>> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
>>>> Cc: Mike Kravetz <mike.kravetz@oracle.com>
>>>> Cc: stable@vger.kernel.org
>>>> Signed-off-by: Longpeng <longpeng2@huawei.com>
>>>
>>> Andrew dropped this patch from his tree which caused me to go back and
>>> look at the status of this patch/issue.
>>>
>>> It is pretty obvious that code in the current huge_pte_offset routine
>>> is racy.  I checked out the assembly code produced by my compiler and
>>> verified that the line,
>>>
>>> 	if (pud_huge(*pud) || !pud_present(*pud))
>>>
>>> does actually dereference *pud twice.  So, the value could change between
>>> those two dereferences.   Longpeng (Mike) could easlily recreate the issue
>>> if he put a delay between the two dereferences.  I believe the only
>>> reservations/concerns about the patch below was the use of READ_ONCE().
>>> Is that correct?
>>>
>> Hi Mike,
>>
>> It seems I've missed your another mail in my client, I found it here
>> (https://lkml.org/lkml/2020/2/27/1927) just now.
>>
>> I think we have reached an agreement that the pud/pmd need READ_ONCE in
>> huge_pte_offset() and disagreement is whether the pgd/p4d also need READ_ONCE,
>> right ?
> 
> Correct.
> 
> Sorry, I did not reply to the mail thread with more context.
> 
>>> Are there any objections to the patch if the READ_ONCE() calls are removed?
>>>
>> Because the pgd/p4g are only accessed and dereferenced once here, so some guys
>> want to remove it.
>>
>> But we must make sure they are *really* accessed once, in other words, this
>> makes we need to care about both the implementation of pgd_present/p4d_present
>> and the behavior of any compiler, for example:
>>
>> '''
>> static inline int func(int val)
>> {
>>     return subfunc1(val) & subfunc2(val);
>> }
>>
>> func(*p); // int *p
>> '''
>> We must make sure there's no strange compiler to generate an assemble code that
>> access and dereference 'p' more than once.
>>
>> I've not found any backwards with READ_ONCE here. However, if you also agree to
>> remove READ_ONCE around pgd/p4d, I'll do.
>>
> 
> I would like to remove the READ_ONCE calls and move the patch forward.  It
> does address a real issue you are seeing.
> 
> To be honest, I am more worried about the races in lookup_address_in_pgd()
> than using or not using READ_ONCE for  pgd/p4d in this patch.
> 
I had the same worry, we've discussed in another thread
(https://lkml.org/lkml/2020/2/20/1182) where I asked you `Is it possible the pud
changes from pud_huge() to pud_none() while another CPU is walking the
pagetable` and you thought it's possible.
The reason why I didn't do something in lookup_address_in_pgd together is just
because I haven't went into trouble caused by it yet.

> I have not looked closely at the generated code for lookup_address_in_pgd.
> It appears that it would dereference p4d, pud and pmd multiple times.  Sean
> seemed to think there was something about the calling context that would
> make issues like those seen with huge_pte_offset less likely to happen.  I
> do not know if this is accurate or not.
> 
> Let's remove the two READ_ONCE calls and move this patch forward.  We can
> look closer at lookup_address_in_pgd and generate another patch if that needs
> to be fixed as well.
> 
OK, I'll remove them in v3.

I'll do some fault injection or add some delays in lookup_address_in_pgd to test
if it can work well.

> Thanks
> 

---
Regards,
Longpeng(Mike)
