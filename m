Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE0A390FAA
	for <lists+stable@lfdr.de>; Wed, 26 May 2021 06:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbhEZEk7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 00:40:59 -0400
Received: from foss.arm.com ([217.140.110.172]:38442 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229473AbhEZEk7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 May 2021 00:40:59 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 09BBB1516;
        Tue, 25 May 2021 21:39:28 -0700 (PDT)
Received: from [10.163.81.152] (unknown [10.163.81.152])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 685193F73D;
        Tue, 25 May 2021 21:39:24 -0700 (PDT)
Subject: Re: [PATCH 1/1] mm/debug_vm_pgtable: fix alignment for
 pmd/pud_advanced_tests()
To:     Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        linux-sparc <sparclinux@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>, stable@vger.kernel.org,
        Vineet Gupta <vgupta@synopsys.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>
References: <20210525130043.186290-1-gerald.schaefer@linux.ibm.com>
 <20210525130043.186290-2-gerald.schaefer@linux.ibm.com>
From:   Anshuman Khandual <anshuman.khandual@arm.com>
Message-ID: <53271f1e-51e3-7673-b58b-0bfe65ffde94@arm.com>
Date:   Wed, 26 May 2021 10:10:06 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210525130043.186290-2-gerald.schaefer@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 5/25/21 6:30 PM, Gerald Schaefer wrote:
> In pmd/pud_advanced_tests(), the vaddr is aligned up to the next pmd/pud
> entry, and so it does not match the given pmdp/pudp and (aligned down) pfn
> any more.
> 
> For s390, this results in memory corruption, because the IDTE instruction
> used e.g. in xxx_get_and_clear() will take the vaddr for some calculations,
> in combination with the given pmdp. It will then end up with a wrong table
> origin, ending on ...ff8, and some of those wrongly set low-order bits will
> also select a wrong pagetable level for the index addition. IDTE could
> therefore invalidate (or 0x20) something outside of the page tables,
> depending on the wrongly picked index, which in turn depends on the random
> vaddr.
> 
> As result, we sometimes see "BUG task_struct (Not tainted): Padding
> overwritten" on s390, where one 0x5a padding value got overwritten with
> 0x7a.
> 
> Fix this by aligning down, similar to how the pmd/pud_aligned pfns are
> calculated.
> 
> Fixes: a5c3b9ffb0f40 ("mm/debug_vm_pgtable: add tests validating advanced arch page table helpers")
> Cc: <stable@vger.kernel.org> # v5.9+
> Signed-off-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>

Did not see any problem on arm64 or x86, builds okay across all
supported platforms. It would be great, if folks could test this
on remaining platforms i.e arc, riscv etc.

+ Vineet Gupta <vgupta@synopsys.com>
+ Palmer Dabbelt <palmer@dabbelt.com>
+ Paul Walmsley <paul.walmsley@sifive.com>

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

> ---
>  mm/debug_vm_pgtable.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
> index 6ff92c8b0a00..f7b23565a04f 100644
> --- a/mm/debug_vm_pgtable.c
> +++ b/mm/debug_vm_pgtable.c
> @@ -193,7 +193,7 @@ static void __init pmd_advanced_tests(struct mm_struct *mm,
>  
>  	pr_debug("Validating PMD advanced\n");
>  	/* Align the address wrt HPAGE_PMD_SIZE */
> -	vaddr = (vaddr & HPAGE_PMD_MASK) + HPAGE_PMD_SIZE;
> +	vaddr &= HPAGE_PMD_MASK;
>  
>  	pgtable_trans_huge_deposit(mm, pmdp, pgtable);
>  
> @@ -318,7 +318,7 @@ static void __init pud_advanced_tests(struct mm_struct *mm,
>  
>  	pr_debug("Validating PUD advanced\n");
>  	/* Align the address wrt HPAGE_PUD_SIZE */
> -	vaddr = (vaddr & HPAGE_PUD_MASK) + HPAGE_PUD_SIZE;
> +	vaddr &= HPAGE_PUD_MASK;
>  
>  	pud = pfn_pud(pfn, prot);
>  	set_pud_at(mm, vaddr, pudp, pud);
> 
