Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6BE18EDD0
	for <lists+stable@lfdr.de>; Mon, 23 Mar 2020 03:03:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbgCWCDs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Mar 2020 22:03:48 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:37584 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726979AbgCWCDs (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Mar 2020 22:03:48 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 968B961BB91CCDCFEC8E;
        Mon, 23 Mar 2020 10:03:39 +0800 (CST)
Received: from [10.173.228.124] (10.173.228.124) by smtp.huawei.com
 (10.3.19.213) with Microsoft SMTP Server (TLS) id 14.3.487.0; Mon, 23 Mar
 2020 10:03:33 +0800
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
From:   "Longpeng (Mike, Cloud Infrastructure Service Product Dept.)" 
        <longpeng2@huawei.com>
Message-ID: <5700f44e-9df9-1b12-bc29-68e0463c2860@huawei.com>
Date:   Mon, 23 Mar 2020 10:03:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <51a25d55-de49-4c0a-c994-bf1a8cfc8638@oracle.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.228.124]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2020/3/22 7:38, Mike Kravetz wrote:
> On 2/21/20 7:33 PM, Longpeng(Mike) wrote:
>> From: Longpeng <longpeng2@huawei.com>
>>
>> Our machine encountered a panic(addressing exception) after run
>> for a long time and the calltrace is:
>> RIP: 0010:[<ffffffff9dff0587>]  [<ffffffff9dff0587>] hugetlb_fault+0x307/0xbe0
>> RSP: 0018:ffff9567fc27f808  EFLAGS: 00010286
>> RAX: e800c03ff1258d48 RBX: ffffd3bb003b69c0 RCX: e800c03ff1258d48
>> RDX: 17ff3fc00eda72b7 RSI: 00003ffffffff000 RDI: e800c03ff1258d48
>> RBP: ffff9567fc27f8c8 R08: e800c03ff1258d48 R09: 0000000000000080
>> R10: ffffaba0704c22a8 R11: 0000000000000001 R12: ffff95c87b4b60d8
>> R13: 00005fff00000000 R14: 0000000000000000 R15: ffff9567face8074
>> FS:  00007fe2d9ffb700(0000) GS:ffff956900e40000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: ffffd3bb003b69c0 CR3: 000000be67374000 CR4: 00000000003627e0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> Call Trace:
>>  [<ffffffff9df9b71b>] ? unlock_page+0x2b/0x30
>>  [<ffffffff9dff04a2>] ? hugetlb_fault+0x222/0xbe0
>>  [<ffffffff9dff1405>] follow_hugetlb_page+0x175/0x540
>>  [<ffffffff9e15b825>] ? cpumask_next_and+0x35/0x50
>>  [<ffffffff9dfc7230>] __get_user_pages+0x2a0/0x7e0
>>  [<ffffffff9dfc648d>] __get_user_pages_unlocked+0x15d/0x210
>>  [<ffffffffc068cfc5>] __gfn_to_pfn_memslot+0x3c5/0x460 [kvm]
>>  [<ffffffffc06b28be>] try_async_pf+0x6e/0x2a0 [kvm]
>>  [<ffffffffc06b4b41>] tdp_page_fault+0x151/0x2d0 [kvm]
>>  [<ffffffffc075731c>] ? vmx_vcpu_run+0x2ec/0xc80 [kvm_intel]
>>  [<ffffffffc0757328>] ? vmx_vcpu_run+0x2f8/0xc80 [kvm_intel]
>>  [<ffffffffc06abc11>] kvm_mmu_page_fault+0x31/0x140 [kvm]
>>  [<ffffffffc074d1ae>] handle_ept_violation+0x9e/0x170 [kvm_intel]
>>  [<ffffffffc075579c>] vmx_handle_exit+0x2bc/0xc70 [kvm_intel]
>>  [<ffffffffc074f1a0>] ? __vmx_complete_interrupts.part.73+0x80/0xd0 [kvm_intel]
>>  [<ffffffffc07574c0>] ? vmx_vcpu_run+0x490/0xc80 [kvm_intel]
>>  [<ffffffffc069f3be>] vcpu_enter_guest+0x7be/0x13a0 [kvm]
>>  [<ffffffffc06cf53e>] ? kvm_check_async_pf_completion+0x8e/0xb0 [kvm]
>>  [<ffffffffc06a6f90>] kvm_arch_vcpu_ioctl_run+0x330/0x490 [kvm]
>>  [<ffffffffc068d919>] kvm_vcpu_ioctl+0x309/0x6d0 [kvm]
>>  [<ffffffff9deaa8c2>] ? dequeue_signal+0x32/0x180
>>  [<ffffffff9deae34d>] ? do_sigtimedwait+0xcd/0x230
>>  [<ffffffff9e03aed0>] do_vfs_ioctl+0x3f0/0x540
>>  [<ffffffff9e03b0c1>] SyS_ioctl+0xa1/0xc0
>>  [<ffffffff9e53879b>] system_call_fastpath+0x22/0x27
>>
>> ( The kernel we used is older, but we think the latest kernel also has this
>>   bug after dig into this problem. )
>>
>> For 1G hugepages, huge_pte_offset() wants to return NULL or pudp, but it
>> may return a wrong 'pmdp' if there is a race. Please look at the following
>> code snippet:
>>     ...
>>     pud = pud_offset(p4d, addr);
>>     if (sz != PUD_SIZE && pud_none(*pud))
>>         return NULL;
>>     /* hugepage or swap? */
>>     if (pud_huge(*pud) || !pud_present(*pud))
>>         return (pte_t *)pud;
>>
>>     pmd = pmd_offset(pud, addr);
>>     if (sz != PMD_SIZE && pmd_none(*pmd))
>>         return NULL;
>>     /* hugepage or swap? */
>>     if (pmd_huge(*pmd) || !pmd_present(*pmd))
>>         return (pte_t *)pmd;
>>     ...
>>
>> The following sequence would trigger this bug:
>> 1. CPU0: sz = PUD_SIZE and *pud = 0 , continue
>> 1. CPU0: "pud_huge(*pud)" is false
>> 2. CPU1: calling hugetlb_no_page and set *pud to xxxx8e7(PRESENT)
>> 3. CPU0: "!pud_present(*pud)" is false, continue
>> 4. CPU0: pmd = pmd_offset(pud, addr) and maybe return a wrong pmdp
>> However, we want CPU0 to return NULL or pudp.
>>
>> We can avoid this race by read the pud only once. What's more, we also use
>> READ_ONCE to access the entries for safe(e.g. avoid the compilier mischief)
>>
>> Cc: Matthew Wilcox <willy@infradead.org>
>> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
>> Cc: Mike Kravetz <mike.kravetz@oracle.com>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Longpeng <longpeng2@huawei.com>
> 
> Andrew dropped this patch from his tree which caused me to go back and
> look at the status of this patch/issue.
> 
> It is pretty obvious that code in the current huge_pte_offset routine
> is racy.  I checked out the assembly code produced by my compiler and
> verified that the line,
> 
> 	if (pud_huge(*pud) || !pud_present(*pud))
> 
> does actually dereference *pud twice.  So, the value could change between
> those two dereferences.   Longpeng (Mike) could easlily recreate the issue
> if he put a delay between the two dereferences.  I believe the only
> reservations/concerns about the patch below was the use of READ_ONCE().
> Is that correct?
> 
Hi Mike,

It seems I've missed your another mail in my client, I found it here
(https://lkml.org/lkml/2020/2/27/1927) just now.

I think we have reached an agreement that the pud/pmd need READ_ONCE in
huge_pte_offset() and disagreement is whether the pgd/p4d also need READ_ONCE,
right ?

> Are there any objections to the patch if the READ_ONCE() calls are removed?
> 
Because the pgd/p4g are only accessed and dereferenced once here, so some guys
want to remove it.

But we must make sure they are *really* accessed once, in other words, this
makes we need to care about both the implementation of pgd_present/p4d_present
and the behavior of any compiler, for example:

'''
static inline int func(int val)
{
    return subfunc1(val) & subfunc2(val);
}

func(*p); // int *p
'''
We must make sure there's no strange compiler to generate an assemble code that
access and dereference 'p' more than once.

I've not found any backwards with READ_ONCE here. However, if you also agree to
remove READ_ONCE around pgd/p4d, I'll do.

> Longpeng (Mike), can you recreate the issue by adding the delay and removing
> the READ_ONCE() calls?
> 
I think remove the READ_ONCE around pgd/p4d won't cause any fucntional change.

---
Regards,
Longpeng(Mike)
