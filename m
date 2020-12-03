Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD1B42CD4D3
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 12:44:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729964AbgLCLna (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 06:43:30 -0500
Received: from foss.arm.com ([217.140.110.172]:37972 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726710AbgLCLna (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Dec 2020 06:43:30 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1D325113E;
        Thu,  3 Dec 2020 03:42:44 -0800 (PST)
Received: from [10.37.8.53] (unknown [10.37.8.53])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4CC8E3F66B;
        Thu,  3 Dec 2020 03:42:40 -0800 (PST)
Subject: Re: [PATCH v2] proc: use untagged_addr() for pagemap_read addresses
To:     Miles Chen <miles.chen@mediatek.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mediatek@lists.infradead.org, wsd_upstream@mediatek.com,
        Andrey Konovalov <andreyknvl@google.com>,
        Alexander Potapenko <glider@google.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Marco Elver <elver@google.com>,
        Will Deacon <will.deacon@arm.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Song Bao Hua <song.bao.hua@hisilicon.com>,
        stable@vger.kernel.org
References: <20201127050738.14440-1-miles.chen@mediatek.com>
From:   Vincenzo Frascino <vincenzo.frascino@arm.com>
Message-ID: <d836c2d2-321f-3931-568b-430d73c60c2c@arm.com>
Date:   Thu, 3 Dec 2020 11:45:56 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201127050738.14440-1-miles.chen@mediatek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Miles,

On 11/27/20 5:07 AM, Miles Chen wrote:
> When we try to visit the pagemap of a tagged userspace pointer, we find
> that the start_vaddr is not correct because of the tag.
> To fix it, we should untag the usespace pointers in pagemap_read().
> 

Nit: s/usespace/userspace/ (please search and replace all occurrences :) )

> I tested with 5.10-rc4 and the issue remains.
> 
> Explaination from Catalin in [1]:
>

Nit: s/Explaination/Explanation/ (please search and replace all occurrences :) )

> "
> Arguably, that's a user-space bug since tagged file offsets were never
> supported. In this case it's not even a tag at bit 56 as per the arm64
> tagged address ABI but rather down to bit 47. You could say that the
> problem is caused by the C library (malloc()) or whoever created the
> tagged vaddr and passed it to this function. It's not a kernel
> regression as we've never supported it.
> 
> Now, pagemap is a special case where the offset is usually not generated
> as a classic file offset but rather derived by shifting a user virtual
> address. I guess we can make a concession for pagemap (only) and allow
> such offset with the tag at bit (56 - PAGE_SHIFT + 3).
> "
> 
> My test code is baed on [2]:

Nit: s/baed/based/ (please search and replace all occurrences :) )

[...]

> ---
>  fs/proc/task_mmu.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 217aa2705d5d..92b277388f05 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -1599,11 +1599,15 @@ static ssize_t pagemap_read(struct file *file, char __user *buf,
>  
>  	src = *ppos;
>  	svpfn = src / PM_ENTRY_BYTES;
> -	start_vaddr = svpfn << PAGE_SHIFT;
>  	end_vaddr = mm->task_size;
>  
>  	/* watch out for wraparound */
> -	if (svpfn > mm->task_size >> PAGE_SHIFT)
> +	start_vaddr = end_vaddr;
> +	if (svpfn < (ULONG_MAX >> PAGE_SHIFT))

It seems that 'svpfn' should be less-then-equal (<=) '(ULONG_MAX >>
PAGE_SHIFT)'. Is there any specific reason why this is not the case?

> +		start_vaddr = untagged_addr(svpfn << PAGE_SHIFT);
> +
> +	/* Ensure the address is inside the task */
> +	if (start_vaddr > mm->task_size)
>  		start_vaddr = end_vaddr;
>  
>  	/*
> 

Otherwise:

Reviewed-by: Vincenzo Frascino <vincenzo.frascino@arm.com>

-- 
Regards,
Vincenzo
