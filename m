Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61FF02F349C
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 16:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404944AbhALPsd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 10:48:33 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:7958 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404814AbhALPsa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jan 2021 10:48:30 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10CFWaSx168016;
        Tue, 12 Jan 2021 10:47:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=5GuUw2ilKr/3LrpKOVWFzEHAHdojZRzNIOzb13tEkOk=;
 b=Qw6yCWc7I8RYDbigrNyQOqWQRn+9DSOj9/yVfUMANIPWgXYG9VaCPwvdZFNroHm8foRR
 5RVidqpGQFmIQ4cFeCCdkLkZ+MahXLF1SeM5zrySsPkk9Hsd2TfhQFHOSwwe1vcYVMhi
 pb5L+W00Pvlm918KQZ1G6RSB6E6J/L6eISfEjxLdYmnIVUM8TpT031dfIQfg8j26RlDJ
 fNpsjS8vV8MmUDh+NidXiW1MIgwxikByZ4kCkLNAqqtwRwFgmRFDzAmHTye22qWxKVx5
 gG4iPS4vqZjjmzxxoKJlRMwNvzW4IR+BOxMGj2neuwmTmCXVsIz4XXi7PQP27zNJSLm7 dQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361e2p19qw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 10:47:26 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10CFWgMn168641;
        Tue, 12 Jan 2021 10:47:23 -0500
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361e2p19pp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 10:47:23 -0500
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10CFWb9e015679;
        Tue, 12 Jan 2021 15:47:21 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 35y448hxxe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 15:47:21 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10CFlJlg25100636
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 15:47:19 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F056852057;
        Tue, 12 Jan 2021 15:47:18 +0000 (GMT)
Received: from pomme.local (unknown [9.145.179.152])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 5B21252059;
        Tue, 12 Jan 2021 15:47:18 +0000 (GMT)
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
To:     Vinayak Menon <vinmenon@codeaurora.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andy Lutomirski <luto@kernel.org>, Peter Xu <peterx@redhat.com>,
        Nadav Amit <nadav.amit@gmail.com>, Yu Zhao <yuzhao@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>,
        Will Deacon <will@kernel.org>, surenb@google.com
References: <X+D0hTZCrWS3P5Pi@google.com>
 <CAHk-=wg_UBuo7ro1fpEGkMyFKA1+PxrE85f9J_AhUfr-nJPpLQ@mail.gmail.com>
 <9E301C7C-882A-4E0F-8D6D-1170E792065A@gmail.com>
 <CAHk-=wg-Y+svNy3CDkJjj0X_CJkSbpERLg64-Vqwq5u7SC4z0g@mail.gmail.com>
 <X+ESkna2z3WjjniN@google.com>
 <1FCC8F93-FF29-44D3-A73A-DF943D056680@gmail.com>
 <20201221223041.GL6640@xz-x1>
 <CAHk-=wh-bG4thjXUekLtrCg8FRrdWjtT40ibXXLSm_hzQG8eOw@mail.gmail.com>
 <CALCETrV=8tY7h=aaudWBEn-MJnNkm2wz5qjH49SYqwkjYTpOaA@mail.gmail.com>
 <CAHk-=wj=CcOHQpG0cUGfoMCt2=Uaifpqq-p-mMOmW8XmrBn4fQ@mail.gmail.com>
 <20210105153727.GK3040@hirez.programming.kicks-ass.net>
 <bfb1cbe6-a705-469d-c95a-776624817e33@codeaurora.org>
From:   Laurent Dufour <ldufour@linux.vnet.ibm.com>
Message-ID: <0201238b-e716-2a3c-e9ea-d5294ff77525@linux.vnet.ibm.com>
Date:   Tue, 12 Jan 2021 16:47:17 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <bfb1cbe6-a705-469d-c95a-776624817e33@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_10:2021-01-12,2021-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 mlxlogscore=436 clxscore=1011 lowpriorityscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 suspectscore=0 priorityscore=1501 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101120090
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Le 12/01/2021 à 12:43, Vinayak Menon a écrit :
> On 1/5/2021 9:07 PM, Peter Zijlstra wrote:
>> On Mon, Dec 21, 2020 at 08:16:11PM -0800, Linus Torvalds wrote:
>>
>>> So I think the basic rule is that "if you hold mmap_sem for writing,
>>> you're always safe". And that really should be considered the
>>> "default" locking.
>>>
>>> ANY time you make a modification to the VM layer, you should basically
>>> always treat it as a write operation, and get the mmap_sem for
>>> writing.
>>>
>>> Yeah, yeah, that's a bit simplified, and it ignores various special
>>> cases (and the hardware page table walkers that obviously take no
>>> locks at all), but if you hold the mmap_sem for writing you won't
>>> really race with anything else - not page faults, and not other
>>> "modify this VM".
>>> To a first approximation, everybody that changes the VM should take
>>> the mmap_sem for writing, and the readers should just be just about
>>> page fault handling (and I count GUP as "page fault handling" too -
>>> it's kind of the same "look up page" rather than "modify vm" kind of
>>> operation).
>>>
>>> And there are just a _lot_ more page faults than there are things that
>>> modify the page tables and the vma's.
>>>
>>> So having that mental model of "lookup of pages in a VM take mmap_semn
>>> for reading, any modification of the VM uses it for writing" makes
>>> sense both from a performance angle and a logical standpoint. It's the
>>> correct model.
>>> And it's worth noting that COW is still "lookup of pages", even though
>>> it might modify the page tables in the process. The same way lookup
>>> can modify the page tables to mark things accessed or dirty.
>>>
>>> So COW is still a lookup operation, in ways that "change the
>>> writabiility of this range" very much is not. COW is "lookup for
>>> write", and the magic we do to copy to make that write valid is still
>>> all about the lookup of the page.
>> (your other email clarified this point; the COW needs to copy while
>> holding the PTL and we need TLBI under PTL if we're to change this)
>>
>>> Which brings up another mental mistake I saw earlier in this thread:
>>> you should not think "mmap_sem is for vma, and the page table lock is
>>> for the page table changes".
>>>
>>> mmap_sem is the primary lock for any modifications to the VM layout,
>>> whether it be in the vma's or in the page tables.
>>>
>>> Now, the page table lock does exist _in_addition_to_ the mmap_sem, but
>>> it is partly because
>>>
>>>   (a) we have things that historically walked the page tables _without_
>>> walking the vma's (notably the virtual memory scanning)
>>>
>>>   (b) we do allow concurrent page faults, so we then need a lower-level
>>> lock to serialize the parallelism we _do_ have.
>> And I'm thinking the speculative page fault series steps right into all
>> this, it fundamentally avoids mmap_sem and entirely relies on the PTL.
>>
>> Which opens it up to exactly these races explored here.
>>
>> The range lock approach does not suffer this, but I'm still worried
>> about the actual performance of that thing.
> 
> 
> Some thoughts on why there may not be an issue with speculative page fault.
> Adding Laurent as well.
> 
> Possibility of race against other PTE modifiers
> 
> 1) Fork - We have seen a case of SPF racing with fork marking PTEs RO and that
> is described and fixed here https://lore.kernel.org/patchwork/patch/1062672/
> 2) mprotect - change_protection in mprotect which does the deferred flush is
> marked under vm_write_begin/vm_write_end, thus SPF bails out on faults on those 
> VMAs.
> 3) userfaultfd - mwriteprotect_range is not protected unlike in (2) above.
> But SPF does not take UFFD faults.
> 4) hugetlb - hugetlb_change_protection - called from mprotect and covered by
> (2) above.
> 5) Concurrent faults - SPF does not handle all faults. Only anon page faults.
> Of which do_anonymous_page and do_swap_page are NONE/NON-PRESENT->PRESENT
> transitions without tlb flush. And I hope do_wp_page with RO->RW is fine as well.
> I could not see a case where speculative path cannot see a PTE update done via
> a fault on another CPU.
> 

Thanks Vinayak,

You explained it fine. Indeed SPF is handling deferred TLB invalidation by 
marking the VMA through vm_write_begin/end(), as for the fork case you 
mentioned. Once the PTL is held, and the VMA's seqcount is checked, the PTE 
values read are valid.

Cheers,
Laurent.


