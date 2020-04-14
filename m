Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 385641A806E
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 16:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405206AbgDNOxA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 10:53:00 -0400
Received: from foss.arm.com ([217.140.110.172]:57418 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405178AbgDNOw5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Apr 2020 10:52:57 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DFBC130E;
        Tue, 14 Apr 2020 07:52:56 -0700 (PDT)
Received: from [192.168.1.172] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EE19B3F73D;
        Tue, 14 Apr 2020 07:52:55 -0700 (PDT)
Subject: Re: [PATCH 1/5] arm64: vdso: don't free unallocated pages
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
        will@kernel.org, stable@vger.kernel.org
References: <20200414104252.16061-1-mark.rutland@arm.com>
 <20200414104252.16061-2-mark.rutland@arm.com>
 <c5596228-2685-abb3-5ab1-9519759e1f7a@arm.com>
 <20200414132751.GF2486@C02TD0UTHF1T.local>
From:   Vincenzo Frascino <vincenzo.frascino@arm.com>
Message-ID: <8681c958-0fd9-130e-f7bb-99bfd3a027cb@arm.com>
Date:   Tue, 14 Apr 2020 15:53:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200414132751.GF2486@C02TD0UTHF1T.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 4/14/20 2:27 PM, Mark Rutland wrote:
> On Tue, Apr 14, 2020 at 01:50:38PM +0100, Vincenzo Frascino wrote:
>> Hi Mark,
>>
>> On 4/14/20 11:42 AM, Mark Rutland wrote:
>>> The aarch32_vdso_pages[] array never has entries allocated in the C_VVAR
>>> or C_VDSO slots, and as the array is zero initialized these contain
>>> NULL.
>>>
>>> However in __aarch32_alloc_vdso_pages() when
>>> aarch32_alloc_kuser_vdso_page() fails we attempt to free the page whose
>>> struct page is at NULL, which is obviously nonsensical.
>>
>> Could you please explain why do you think that free(NULL) is "nonsensical"? 
> 
> Regardless of the below, can you please explain why it is sensical? I'm
> struggling to follow your argument here.

free(NULL) is a no-operation ("no action occurs") according to the C standard
(ISO-IEC 9899 paragraph 7.20.3.2). Hence this should not cause any bug if the
allocator is correctly implemented. From what I can see the implementation of
the page allocator honors this assumption.

Since you say it is a bug (providing evidence), we might have to investigate
because probably there is an issue somewhere else.

> 
> * It serves no legitimate purpose. One cannot free a page without a
>   corresponding struct page.
> 
> * It is redundant. Removing the code does not detract from the utility
>   of the remainging code, or make that remaing code more complex.
> 
> * It hinders comprehension of the code. When a developer sees the
>   free_page() they will assume that the page was allocated somewhere,
>   but there is no corresponding allocation as the pointers are never
>   assigned to. Even if the code in question is not harmful to the
>   functional correctness of the code, it is an unnecessary burden to
>   developers.
> 
> * page_to_virt(NULL) does not have a well-defined result, and
>   page_to_virt() should only be called for a valid struct page pointer.
>   The result of page_to_virt(NULL) may not be a pointer into the linear
>   map as would be expected.
> 

Do you know why this is the case? To be compliant with what the page allocator
expects page_to_virt(NULL) should be equal to NULL.

> * free_page(x) calls free_pages(x, 0), which checks virt_addr_valid(x).
>   As page_to_virt(NULL) is not a valid linear map address, this can
>   trigger a VM_BUG_ON()
> 

free_pages(x, 0) checks virt_addr_valid(x) only if "addr != 0" (as per C
standard) which makes me infer what I stated above. But maybe I am missing
something.

[...]
-- 
Regards,
Vincenzo
