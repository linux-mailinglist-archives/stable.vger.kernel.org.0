Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED72714171C
	for <lists+stable@lfdr.de>; Sat, 18 Jan 2020 12:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbgARLEU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Jan 2020 06:04:20 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:49171 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726961AbgARLEU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Jan 2020 06:04:20 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 480FS21hVhz9sP6;
        Sat, 18 Jan 2020 22:04:18 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1579345458;
        bh=vuQ2I94GVxk1Stamn10MtxxxtP9xCsJhl4rGOCjEFfY=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=NVJmS6Aqapw7GuOrz1KJ8PMQVTP5nSiBrdi/aqB/bynm81H9owV0Xw5k8JgpJeX3E
         gof3l9jvUIdJkC8kCzYqF9w3E9O2KQtcPvYqu6Sdq+jUXWsSMcB8uM0Pv3/seI0mT8
         IQIm7H5tPmffH//1uTLQfKHy+ZsNjtl5+H9Ss3rJRW/gDxjHFTwfP+cguhrR1TWDKe
         /p5TdIihP8HhPpkz4YaerzZvv+hCfpCUQs6fwiInCRH9WvyJz9623edlxYd3K4/CVT
         oHeeiaAsnAD8cF8JmhziKJ4qbKyLFvCXze+r2GJCwUrPma/RYrZ+OwIM8yZNNpol/y
         xJnId6setroqQ==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        akpm@linux-foundation.org, peterz@infradead.org, will@kernel.org
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        stable@vger.kernel.org,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Subject: Re: [PATCH v4 2/9] mm/mmu_gather: Invalidate TLB correctly on batch allocation failure and flush
In-Reply-To: <20200116064531.483522-3-aneesh.kumar@linux.ibm.com>
References: <20200116064531.483522-1-aneesh.kumar@linux.ibm.com> <20200116064531.483522-3-aneesh.kumar@linux.ibm.com>
Date:   Sat, 18 Jan 2020 21:04:27 +1000
Message-ID: <8736cd81qc.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com> writes:
> From: Peter Zijlstra <peterz@infradead.org>
>
> Architectures for which we have hardware walkers of Linux page table should
> flush TLB on mmu gather batch allocation failures and batch flush. Some
> architectures like POWER supports multiple translation modes (hash and radix)
> and in the case of POWER only radix translation mode needs the above TLBI.
> This is because for hash translation mode kernel wants to avoid this extra
> flush since there are no hardware walkers of linux page table. With radix
> translation, the hardware also walks linux page table and with that, kernel
> needs to make sure to TLB invalidate page walk cache before page table pages are
> freed.
>
> More details in
> commit: d86564a2f085 ("mm/tlb, x86/mm: Support invalidating TLB caches for RCU_TABLE_FREE")
>
> The changes to sparc are to make sure we keep the old behavior since we are now
> removing HAVE_RCU_TABLE_NO_INVALIDATE. The default value for
> tlb_needs_table_invalidate is to always force an invalidate and sparc can avoid
> the table invalidate. Hence we define tlb_needs_table_invalidate to false for
> sparc architecture.
>
> Cc: <stable@vger.kernel.org>
> Fixes: a46cc7a90fd8 ("powerpc/mm/radix: Improve TLB/PWC flushes")

Which went into v4.14, so I like to use:

Cc: stable@vger.kernel.org # v4.14+


> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
> ---
>  arch/Kconfig                    |  3 ---
>  arch/powerpc/Kconfig            |  1 -
>  arch/powerpc/include/asm/tlb.h  | 11 +++++++++++
>  arch/sparc/Kconfig              |  1 -
>  arch/sparc/include/asm/tlb_64.h |  9 +++++++++
>  include/asm-generic/tlb.h       | 22 +++++++++++++++-------
>  mm/mmu_gather.c                 | 16 ++++++++--------
>  7 files changed, 43 insertions(+), 20 deletions(-)

Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)

cheers

> diff --git a/arch/Kconfig b/arch/Kconfig
> index 48b5e103bdb0..208aad121630 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -396,9 +396,6 @@ config HAVE_ARCH_JUMP_LABEL_RELATIVE
>  config HAVE_RCU_TABLE_FREE
>  	bool
>  
> -config HAVE_RCU_TABLE_NO_INVALIDATE
> -	bool
> -
>  config HAVE_MMU_GATHER_PAGE_SIZE
>  	bool
>  
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index 04240205f38c..f9970f87612e 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -223,7 +223,6 @@ config PPC
>  	select HAVE_PERF_REGS
>  	select HAVE_PERF_USER_STACK_DUMP
>  	select HAVE_RCU_TABLE_FREE
> -	select HAVE_RCU_TABLE_NO_INVALIDATE	if HAVE_RCU_TABLE_FREE
>  	select HAVE_MMU_GATHER_PAGE_SIZE
>  	select HAVE_REGS_AND_STACK_ACCESS_API
>  	select HAVE_RELIABLE_STACKTRACE		if PPC_BOOK3S_64 && CPU_LITTLE_ENDIAN
> diff --git a/arch/powerpc/include/asm/tlb.h b/arch/powerpc/include/asm/tlb.h
> index b2c0be93929d..7f3a8b902325 100644
> --- a/arch/powerpc/include/asm/tlb.h
> +++ b/arch/powerpc/include/asm/tlb.h
> @@ -26,6 +26,17 @@
>  
>  #define tlb_flush tlb_flush
>  extern void tlb_flush(struct mmu_gather *tlb);
> +/*
> + * book3s:
> + * Hash does not use the linux page-tables, so we can avoid
> + * the TLB invalidate for page-table freeing, Radix otoh does use the
> + * page-tables and needs the TLBI.
> + *
> + * nohash:
> + * We still do TLB invalidate in the __pte_free_tlb routine before we
> + * add the page table pages to mmu gather table batch.
> + */
> +#define tlb_needs_table_invalidate()	radix_enabled()
>  
>  /* Get the generic bits... */
>  #include <asm-generic/tlb.h>
> diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
> index eb24cb1afc11..18e9fb6fcf1b 100644
> --- a/arch/sparc/Kconfig
> +++ b/arch/sparc/Kconfig
> @@ -65,7 +65,6 @@ config SPARC64
>  	select HAVE_KRETPROBES
>  	select HAVE_KPROBES
>  	select HAVE_RCU_TABLE_FREE if SMP
> -	select HAVE_RCU_TABLE_NO_INVALIDATE if HAVE_RCU_TABLE_FREE
>  	select HAVE_MEMBLOCK_NODE_MAP
>  	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
>  	select HAVE_DYNAMIC_FTRACE
> diff --git a/arch/sparc/include/asm/tlb_64.h b/arch/sparc/include/asm/tlb_64.h
> index a2f3fa61ee36..8cb8f3833239 100644
> --- a/arch/sparc/include/asm/tlb_64.h
> +++ b/arch/sparc/include/asm/tlb_64.h
> @@ -28,6 +28,15 @@ void flush_tlb_pending(void);
>  #define __tlb_remove_tlb_entry(tlb, ptep, address) do { } while (0)
>  #define tlb_flush(tlb)	flush_tlb_pending()
>  
> +/*
> + * SPARC64's hardware TLB fill does not use the Linux page-tables
> + * and therefore we don't need a TLBI when freeing page-table pages.
> + */
> +
> +#ifdef CONFIG_HAVE_RCU_TABLE_FREE
> +#define tlb_needs_table_invalidate()	(false)
> +#endif
> +
>  #include <asm-generic/tlb.h>
>  
>  #endif /* _SPARC64_TLB_H */
> diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
> index 2b10036fefd0..9e22ac369d1d 100644
> --- a/include/asm-generic/tlb.h
> +++ b/include/asm-generic/tlb.h
> @@ -137,13 +137,6 @@
>   *  When used, an architecture is expected to provide __tlb_remove_table()
>   *  which does the actual freeing of these pages.
>   *
> - *  HAVE_RCU_TABLE_NO_INVALIDATE
> - *
> - *  This makes HAVE_RCU_TABLE_FREE avoid calling tlb_flush_mmu_tlbonly() before
> - *  freeing the page-table pages. This can be avoided if you use
> - *  HAVE_RCU_TABLE_FREE and your architecture does _NOT_ use the Linux
> - *  page-tables natively.
> - *
>   *  MMU_GATHER_NO_RANGE
>   *
>   *  Use this if your architecture lacks an efficient flush_tlb_range().
> @@ -189,8 +182,23 @@ struct mmu_table_batch {
>  
>  extern void tlb_remove_table(struct mmu_gather *tlb, void *table);
>  
> +/*
> + * This allows an architecture that does not use the linux page-tables for
> + * hardware to skip the TLBI when freeing page tables.
> + */
> +#ifndef tlb_needs_table_invalidate
> +#define tlb_needs_table_invalidate() (true)
> +#endif
> +
> +#else
> +
> +#ifdef tlb_needs_table_invalidate
> +#error tlb_needs_table_invalidate() requires HAVE_RCU_TABLE_FREE
>  #endif
>  
> +#endif /* CONFIG_HAVE_RCU_TABLE_FREE */
> +
> +
>  #ifndef CONFIG_HAVE_MMU_GATHER_NO_GATHER
>  /*
>   * If we can't allocate a page to make a big batch of page pointers
> diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
> index 7d70e5c78f97..7c1b8f67af7b 100644
> --- a/mm/mmu_gather.c
> +++ b/mm/mmu_gather.c
> @@ -102,14 +102,14 @@ bool __tlb_remove_page_size(struct mmu_gather *tlb, struct page *page, int page_
>   */
>  static inline void tlb_table_invalidate(struct mmu_gather *tlb)
>  {
> -#ifndef CONFIG_HAVE_RCU_TABLE_NO_INVALIDATE
> -	/*
> -	 * Invalidate page-table caches used by hardware walkers. Then we still
> -	 * need to RCU-sched wait while freeing the pages because software
> -	 * walkers can still be in-flight.
> -	 */
> -	tlb_flush_mmu_tlbonly(tlb);
> -#endif
> +	if (tlb_needs_table_invalidate()) {
> +		/*
> +		 * Invalidate page-table caches used by hardware walkers. Then
> +		 * we still need to RCU-sched wait while freeing the pages
> +		 * because software walkers can still be in-flight.
> +		 */
> +		tlb_flush_mmu_tlbonly(tlb);
> +	}
>  }
>  
>  static void tlb_remove_table_smp_sync(void *arg)
> -- 
> 2.24.1
