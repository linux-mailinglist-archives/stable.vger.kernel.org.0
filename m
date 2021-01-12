Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C149D2F2E3D
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 12:45:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728431AbhALLpC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 06:45:02 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:48330 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729258AbhALLpB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jan 2021 06:45:01 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1610451880; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=pDD5+cOOV+kq8coSojkQ9ER1nl8CFfyd8Ps/ttb8Gl0=; b=DAlNq3m56kueriJv1+piarBt32NMb0qo9vAvNgZvAxRkxCVsvgtafkVsBjFnc1JoXza8c0io
 AihOuAb+GwCYOJcOwGF7rOPbIz65GWtch1MyozIklAXGrkVwDMyaKWKCUA1EVhy0IEk/IPJr
 E5iiTESWLSxmBTFTaAtg9eW8uiA=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n09.prod.us-east-1.postgun.com with SMTP id
 5ffd8b888fb3cda82f163e7c (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 12 Jan 2021 11:44:08
 GMT
Sender: vinmenon=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 78D49C43465; Tue, 12 Jan 2021 11:44:07 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL autolearn=no autolearn_force=no version=3.4.0
Received: from [192.168.1.4] (unknown [183.83.147.228])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: vinmenon)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 454D0C433ED;
        Tue, 12 Jan 2021 11:43:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 454D0C433ED
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=vinmenon@codeaurora.org
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
To:     Peter Zijlstra <peterz@infradead.org>,
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
        Will Deacon <will@kernel.org>, ldufour@linux.vnet.ibm.com,
        surenb@google.com
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
From:   Vinayak Menon <vinmenon@codeaurora.org>
Message-ID: <bfb1cbe6-a705-469d-c95a-776624817e33@codeaurora.org>
Date:   Tue, 12 Jan 2021 17:13:57 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210105153727.GK3040@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/5/2021 9:07 PM, Peter Zijlstra wrote:
> On Mon, Dec 21, 2020 at 08:16:11PM -0800, Linus Torvalds wrote:
>
>> So I think the basic rule is that "if you hold mmap_sem for writing,
>> you're always safe". And that really should be considered the
>> "default" locking.
>>
>> ANY time you make a modification to the VM layer, you should basically
>> always treat it as a write operation, and get the mmap_sem for
>> writing.
>>
>> Yeah, yeah, that's a bit simplified, and it ignores various special
>> cases (and the hardware page table walkers that obviously take no
>> locks at all), but if you hold the mmap_sem for writing you won't
>> really race with anything else - not page faults, and not other
>> "modify this VM".
>> To a first approximation, everybody that changes the VM should take
>> the mmap_sem for writing, and the readers should just be just about
>> page fault handling (and I count GUP as "page fault handling" too -
>> it's kind of the same "look up page" rather than "modify vm" kind of
>> operation).
>>
>> And there are just a _lot_ more page faults than there are things that
>> modify the page tables and the vma's.
>>
>> So having that mental model of "lookup of pages in a VM take mmap_semn
>> for reading, any modification of the VM uses it for writing" makes
>> sense both from a performance angle and a logical standpoint. It's the
>> correct model.
>> And it's worth noting that COW is still "lookup of pages", even though
>> it might modify the page tables in the process. The same way lookup
>> can modify the page tables to mark things accessed or dirty.
>>
>> So COW is still a lookup operation, in ways that "change the
>> writabiility of this range" very much is not. COW is "lookup for
>> write", and the magic we do to copy to make that write valid is still
>> all about the lookup of the page.
> (your other email clarified this point; the COW needs to copy while
> holding the PTL and we need TLBI under PTL if we're to change this)
>
>> Which brings up another mental mistake I saw earlier in this thread:
>> you should not think "mmap_sem is for vma, and the page table lock is
>> for the page table changes".
>>
>> mmap_sem is the primary lock for any modifications to the VM layout,
>> whether it be in the vma's or in the page tables.
>>
>> Now, the page table lock does exist _in_addition_to_ the mmap_sem, but
>> it is partly because
>>
>>   (a) we have things that historically walked the page tables _without_
>> walking the vma's (notably the virtual memory scanning)
>>
>>   (b) we do allow concurrent page faults, so we then need a lower-level
>> lock to serialize the parallelism we _do_ have.
> And I'm thinking the speculative page fault series steps right into all
> this, it fundamentally avoids mmap_sem and entirely relies on the PTL.
>
> Which opens it up to exactly these races explored here.
>
> The range lock approach does not suffer this, but I'm still worried
> about the actual performance of that thing.


Some thoughts on why there may not be an issue with speculative page fault.
Adding Laurent as well.

Possibility of race against other PTE modifiers

1) Fork - We have seen a case of SPF racing with fork marking PTEs RO 
and that
is described and fixed here https://lore.kernel.org/patchwork/patch/1062672/
2) mprotect - change_protection in mprotect which does the deferred flush is
marked under vm_write_begin/vm_write_end, thus SPF bails out on faults 
on those VMAs.
3) userfaultfd - mwriteprotect_range is not protected unlike in (2) above.
But SPF does not take UFFD faults.
4) hugetlb - hugetlb_change_protection - called from mprotect and covered by
(2) above.
5) Concurrent faults - SPF does not handle all faults. Only anon page 
faults.
Of which do_anonymous_page and do_swap_page are NONE/NON-PRESENT->PRESENT
transitions without tlb flush. And I hope do_wp_page with RO->RW is fine 
as well.
I could not see a case where speculative path cannot see a PTE update 
done via
a fault on another CPU.

-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, hosted by The Linux Foundation

