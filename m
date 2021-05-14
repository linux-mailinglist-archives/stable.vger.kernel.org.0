Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F41C438068B
	for <lists+stable@lfdr.de>; Fri, 14 May 2021 11:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232517AbhENJzl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 05:55:41 -0400
Received: from foss.arm.com ([217.140.110.172]:46162 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232607AbhENJzk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 May 2021 05:55:40 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4062C1763;
        Fri, 14 May 2021 02:54:29 -0700 (PDT)
Received: from [192.168.1.179] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 607F73F719;
        Fri, 14 May 2021 02:54:28 -0700 (PDT)
Subject: Re: [PATCH] arm64: Fix race condition on PG_dcache_clean in
 __sync_icache_dcache()
To:     Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org
Cc:     Mark Rutland <mark.rutland@arm.com>, stable@vger.kernel.org,
        Will Deacon <will@kernel.org>
References: <20210514095001.13236-1-catalin.marinas@arm.com>
From:   Steven Price <steven.price@arm.com>
Message-ID: <3bee1bdf-b6ea-9cde-e946-d24eb79ddb62@arm.com>
Date:   Fri, 14 May 2021 10:54:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210514095001.13236-1-catalin.marinas@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 14/05/2021 10:50, Catalin Marinas wrote:
> To ensure that instructions are observable in a new mapping, the arm64
> set_pte_at() implementation cleans the D-cache and invalidates the
> I-cache to the PoU. As an optimisation, this is only done on executable
> mappings and the PG_dcache_clean page flag is set to avoid future cache
> maintenance on the same page.
> 
> When two different processes map the same page (e.g. private executable
> file or shared mapping) there's a potential race on checking and setting
> PG_dcache_clean via set_pte_at() -> __sync_icache_dcache(). While on the
> fault paths the page is locked (PG_locked), mprotect() does not take the
> page lock. The result is that one process may see the PG_dcache_clean
> flag set but the I/D cache maintenance not yet performed.
> 
> Avoid test_and_set_bit(PG_dcache_clean) in favour of separate test_bit()
> and set_bit(). In the rare event of a race, the cache maintenance is
> done twice.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: <stable@vger.kernel.org>
> Cc: Will Deacon <will@kernel.org>
> Cc: Steven Price <steven.price@arm.com>

Thanks for writing up a proper patch.

Reviewed-by: Steven Price <steven.price@arm.com>

Steve

> ---
> 
> Found while debating with Steven a similar race on PG_mte_tagged. For
> the latter we'll have to take a lock but hopefully in practice it will
> only happen when restoring from swap. Separate thread anyway.
> 
> There's at least arch/arm with a similar race. Powerpc seems to do it
> properly with separate test/set. Other architectures have a bigger
> problem as they do a similar check in update_mmu_cache(), called after
> the pte was already exposed to user.
> 
> I looked at fixing this in the mprotect() code but taking the page lock
> will slow it down, so not sure how popular this would be for such a rare
> race.
> 
>  arch/arm64/mm/flush.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/mm/flush.c b/arch/arm64/mm/flush.c
> index ac485163a4a7..6d44c028d1c9 100644
> --- a/arch/arm64/mm/flush.c
> +++ b/arch/arm64/mm/flush.c
> @@ -55,8 +55,10 @@ void __sync_icache_dcache(pte_t pte)
>  {
>  	struct page *page = pte_page(pte);
>  
> -	if (!test_and_set_bit(PG_dcache_clean, &page->flags))
> +	if (!test_bit(PG_dcache_clean, &page->flags)) {
>  		sync_icache_aliases(page_address(page), page_size(page));
> +		set_bit(PG_dcache_clean, &page->flags);
> +	}
>  }
>  EXPORT_SYMBOL_GPL(__sync_icache_dcache);
>  
> 

