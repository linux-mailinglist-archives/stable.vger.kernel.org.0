Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9AD938077E
	for <lists+stable@lfdr.de>; Fri, 14 May 2021 12:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231936AbhENKjw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 06:39:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:46100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231916AbhENKjs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 May 2021 06:39:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9DF4561406;
        Fri, 14 May 2021 10:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620988717;
        bh=z1krxmcEFCW/qOogrqVklsNypv42p3Xkx7h0791apzA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XIjkYd4kkRjYCwUCsXagITVyePv+uHdyiuUrI4Qnz6TBE2Lc7DGVhiK5xSoifB8fa
         sNz4IU8LqV43iRZ2dNfzdVIbvMu1yYKtQ1S0vyqFVkDwqffR7pA0M24md5H0sbriGI
         Ce3T9NMKNnC12M1tFIkc29lmTmRjoZc8fXI+NNvvdwv5QPjM+oQdiUW+tvKBiIuJpP
         i+66bblZH1S6spfJWYNeLvSK1p/0aM6WDPJxhVn0n2utg/EV9SKG2kMe1WfkdTF5O1
         Ym+lIXKSRpaehMgGT37WLgFOvva9S3b6jqHmxxONLhr1H85n3RLr2PFdDE7Zwi7VcL
         +vpHZsC4ML4QA==
Date:   Fri, 14 May 2021 11:38:33 +0100
From:   Will Deacon <will@kernel.org>
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>, stable@vger.kernel.org,
        Steven Price <steven.price@arm.com>
Subject: Re: [PATCH] arm64: Fix race condition on PG_dcache_clean in
 __sync_icache_dcache()
Message-ID: <20210514103833.GB3795@willie-the-truck>
References: <20210514095001.13236-1-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210514095001.13236-1-catalin.marinas@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 14, 2021 at 10:50:01AM +0100, Catalin Marinas wrote:
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

Acked-by: Will Deacon <will@kernel.org>

I wondered about the ISB for a bit (we don't broadcast it), but should
be fine as the racing CPU needs to return to userspace.

Will
