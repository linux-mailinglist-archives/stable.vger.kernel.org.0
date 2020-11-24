Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB8CF2C2270
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 11:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731232AbgKXKCg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Nov 2020 05:02:36 -0500
Received: from foss.arm.com ([217.140.110.172]:51038 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728872AbgKXKCg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Nov 2020 05:02:36 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5D8E31396;
        Tue, 24 Nov 2020 02:02:35 -0800 (PST)
Received: from [192.168.0.130] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A47333F71F;
        Tue, 24 Nov 2020 02:02:31 -0800 (PST)
Subject: Re: [PATCH 1/6] arm64: pgtable: Fix pte_accessible()
To:     Will Deacon <will@kernel.org>, linux-kernel@vger.kernel.org
Cc:     kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
        Yu Zhao <yuzhao@google.com>, Minchan Kim <minchan@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
        stable@vger.kernel.org
References: <20201120143557.6715-1-will@kernel.org>
 <20201120143557.6715-2-will@kernel.org>
From:   Anshuman Khandual <anshuman.khandual@arm.com>
Message-ID: <6eb6dead-4c76-d14a-dcc7-0d1411337dc6@arm.com>
Date:   Tue, 24 Nov 2020 15:32:18 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201120143557.6715-2-will@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 11/20/20 8:05 PM, Will Deacon wrote:
> pte_accessible() is used by ptep_clear_flush() to figure out whether TLB
> invalidation is necessary when unmapping pages for reclaim. Although our
> implementation is correct according to the architecture, returning true
> only for valid, young ptes in the absence of racing page-table

Just curious, a PTE mapping would go into the TLB only if it is an
young one with PTE_AF bit set per the architecture ?

> modifications, this is in fact flawed due to lazy invalidation of old
> ptes in ptep_clear_flush_young() where we elide the expensive DSB
> instruction for completing the TLB invalidation.

IOW, an old PTE might have missed the required TLB invalidation via
ptep_clear_flush_young() because it's done in lazy mode. Hence just
include old valid PTEs in pte_accessible() so that TLB invalidation
could be done in ptep_clear_flush() path instead. May be TLB flush
could be done for every PTE, irrespective of its PTE_AF bit in
ptep_clear_flush_young().

> 
> Rather than penalise the aging path, adjust pte_accessible() to return
> true for any valid pte, even if the access flag is cleared.

But will not this cause more (possibly not required) TLB invalidation
in normal unmapping paths ? The cover letter mentions that this patch
fixes a real world crash. Should not the crash also be described here
in the commit message as this patch is marked for stable and has a
"Fixes: " tag.

> 
> Cc: <stable@vger.kernel.org>
> Fixes: 76c714be0e5e ("arm64: pgtable: implement pte_accessible()")
> Reported-by: Yu Zhao <yuzhao@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/include/asm/pgtable.h | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index 4ff12a7adcfd..1bdf51f01e73 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -115,8 +115,6 @@ extern unsigned long empty_zero_page[PAGE_SIZE / sizeof(unsigned long)];
>  #define pte_valid(pte)		(!!(pte_val(pte) & PTE_VALID))
>  #define pte_valid_not_user(pte) \
>  	((pte_val(pte) & (PTE_VALID | PTE_USER)) == PTE_VALID)
> -#define pte_valid_young(pte) \
> -	((pte_val(pte) & (PTE_VALID | PTE_AF)) == (PTE_VALID | PTE_AF))
>  #define pte_valid_user(pte) \
>  	((pte_val(pte) & (PTE_VALID | PTE_USER)) == (PTE_VALID | PTE_USER))
>  
> @@ -126,7 +124,7 @@ extern unsigned long empty_zero_page[PAGE_SIZE / sizeof(unsigned long)];
>   * remapped as PROT_NONE but are yet to be flushed from the TLB.
>   */
>  #define pte_accessible(mm, pte)	\
> -	(mm_tlb_flush_pending(mm) ? pte_present(pte) : pte_valid_young(pte))
> +	(mm_tlb_flush_pending(mm) ? pte_present(pte) : pte_valid(pte))
>  
>  /*
>   * p??_access_permitted() is true for valid user mappings (subject to the
> 
