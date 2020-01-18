Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59A55141719
	for <lists+stable@lfdr.de>; Sat, 18 Jan 2020 12:01:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbgARLBN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Jan 2020 06:01:13 -0500
Received: from ozlabs.org ([203.11.71.1]:47663 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726961AbgARLBN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Jan 2020 06:01:13 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 480FNQ3hbqz9sP6;
        Sat, 18 Jan 2020 22:01:10 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1579345271;
        bh=+ulljLUKb6YQwXPEHo6wjTNIvD2BQufBLyDbxBLm/nk=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=ZejS7K6bqRlR8103U9Yudfz6yhHjDi95+BKMxQYP7P6OQX3errdxmtKNxl9vRuLX1
         lmF9rG/xIrDDcQpE0z5bekpwIapcR0tAR3dU+HOfAqSQg6eGfrRMbzzA6Zb+QpBHKm
         gkuJnS2G47MSiourShu92BIaGFOClEW8DOgx97i1RKAoW3sYxQIYLSVrIRX/TNP6JS
         YLXQmMdIhNTAEJEQmU+KYiH9DCZwIRDY8LdfN5yedg4M0HUFlrxebt9zSRBfLzcSVi
         Es4hhap2p6oWvarpWe9gN4NXRzDkvxJEtjW2YQuoMqy06lNZcWLjqy3Ej6xeiJLhZv
         Z2CxB66OwaTAw==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        akpm@linux-foundation.org, peterz@infradead.org, will@kernel.org
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v4 1/9] powerpc/mmu_gather: Enable RCU_TABLE_FREE even for !SMP case
In-Reply-To: <20200116064531.483522-2-aneesh.kumar@linux.ibm.com>
References: <20200116064531.483522-1-aneesh.kumar@linux.ibm.com> <20200116064531.483522-2-aneesh.kumar@linux.ibm.com>
Date:   Sat, 18 Jan 2020 21:01:14 +1000
Message-ID: <875zh981vp.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com> writes:
> A follow up patch is going to make sure we correctly invalidate page walk cache
> before we free page table pages. In order to keep things simple enable
> RCU_TABLE_FREE even for !SMP so that we don't have to fixup the !SMP case
> differently in the followup patch
>
> !SMP case is right now broken for radix translation w.r.t page walk cache flush.
> We can get interrupted in between page table free and that would imply we
> have page walk cache entries pointing to tables which got freed already.

For the archives, both our platforms that run on Power9 force SMP on in
Kconfig, so the !SMP case is unlikely to be a problem for anyone in
practice, unless they've hacked their kernel to build it !SMP.

> Cc: <stable@vger.kernel.org>
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
> ---
>  arch/powerpc/Kconfig                         | 2 +-
>  arch/powerpc/include/asm/book3s/32/pgalloc.h | 8 --------
>  arch/powerpc/include/asm/book3s/64/pgalloc.h | 2 --
>  arch/powerpc/include/asm/nohash/pgalloc.h    | 8 --------
>  arch/powerpc/mm/book3s64/pgtable.c           | 7 -------
>  5 files changed, 1 insertion(+), 26 deletions(-)

Acked-by: Michael Ellerman <mpe@ellerman.id.au>

cheers

> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index 1ec34e16ed65..04240205f38c 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -222,7 +222,7 @@ config PPC
>  	select HAVE_HARDLOCKUP_DETECTOR_PERF	if PERF_EVENTS && HAVE_PERF_EVENTS_NMI && !HAVE_HARDLOCKUP_DETECTOR_ARCH
>  	select HAVE_PERF_REGS
>  	select HAVE_PERF_USER_STACK_DUMP
> -	select HAVE_RCU_TABLE_FREE		if SMP
> +	select HAVE_RCU_TABLE_FREE
>  	select HAVE_RCU_TABLE_NO_INVALIDATE	if HAVE_RCU_TABLE_FREE
>  	select HAVE_MMU_GATHER_PAGE_SIZE
>  	select HAVE_REGS_AND_STACK_ACCESS_API
> diff --git a/arch/powerpc/include/asm/book3s/32/pgalloc.h b/arch/powerpc/include/asm/book3s/32/pgalloc.h
> index 998317702630..dc5c039eb28e 100644
> --- a/arch/powerpc/include/asm/book3s/32/pgalloc.h
> +++ b/arch/powerpc/include/asm/book3s/32/pgalloc.h
> @@ -49,7 +49,6 @@ static inline void pgtable_free(void *table, unsigned index_size)
>  
>  #define get_hugepd_cache_index(x)  (x)
>  
> -#ifdef CONFIG_SMP
>  static inline void pgtable_free_tlb(struct mmu_gather *tlb,
>  				    void *table, int shift)
>  {
> @@ -66,13 +65,6 @@ static inline void __tlb_remove_table(void *_table)
>  
>  	pgtable_free(table, shift);
>  }
> -#else
> -static inline void pgtable_free_tlb(struct mmu_gather *tlb,
> -				    void *table, int shift)
> -{
> -	pgtable_free(table, shift);
> -}
> -#endif
>  
>  static inline void __pte_free_tlb(struct mmu_gather *tlb, pgtable_t table,
>  				  unsigned long address)
> diff --git a/arch/powerpc/include/asm/book3s/64/pgalloc.h b/arch/powerpc/include/asm/book3s/64/pgalloc.h
> index f6968c811026..a41e91bd0580 100644
> --- a/arch/powerpc/include/asm/book3s/64/pgalloc.h
> +++ b/arch/powerpc/include/asm/book3s/64/pgalloc.h
> @@ -19,9 +19,7 @@ extern struct vmemmap_backing *vmemmap_list;
>  extern pmd_t *pmd_fragment_alloc(struct mm_struct *, unsigned long);
>  extern void pmd_fragment_free(unsigned long *);
>  extern void pgtable_free_tlb(struct mmu_gather *tlb, void *table, int shift);
> -#ifdef CONFIG_SMP
>  extern void __tlb_remove_table(void *_table);
> -#endif
>  void pte_frag_destroy(void *pte_frag);
>  
>  static inline pgd_t *radix__pgd_alloc(struct mm_struct *mm)
> diff --git a/arch/powerpc/include/asm/nohash/pgalloc.h b/arch/powerpc/include/asm/nohash/pgalloc.h
> index 332b13b4ecdb..29c43665a753 100644
> --- a/arch/powerpc/include/asm/nohash/pgalloc.h
> +++ b/arch/powerpc/include/asm/nohash/pgalloc.h
> @@ -46,7 +46,6 @@ static inline void pgtable_free(void *table, int shift)
>  
>  #define get_hugepd_cache_index(x)	(x)
>  
> -#ifdef CONFIG_SMP
>  static inline void pgtable_free_tlb(struct mmu_gather *tlb, void *table, int shift)
>  {
>  	unsigned long pgf = (unsigned long)table;
> @@ -64,13 +63,6 @@ static inline void __tlb_remove_table(void *_table)
>  	pgtable_free(table, shift);
>  }
>  
> -#else
> -static inline void pgtable_free_tlb(struct mmu_gather *tlb, void *table, int shift)
> -{
> -	pgtable_free(table, shift);
> -}
> -#endif
> -
>  static inline void __pte_free_tlb(struct mmu_gather *tlb, pgtable_t table,
>  				  unsigned long address)
>  {
> diff --git a/arch/powerpc/mm/book3s64/pgtable.c b/arch/powerpc/mm/book3s64/pgtable.c
> index 75483b40fcb1..2bf7e1b4fd82 100644
> --- a/arch/powerpc/mm/book3s64/pgtable.c
> +++ b/arch/powerpc/mm/book3s64/pgtable.c
> @@ -378,7 +378,6 @@ static inline void pgtable_free(void *table, int index)
>  	}
>  }
>  
> -#ifdef CONFIG_SMP
>  void pgtable_free_tlb(struct mmu_gather *tlb, void *table, int index)
>  {
>  	unsigned long pgf = (unsigned long)table;
> @@ -395,12 +394,6 @@ void __tlb_remove_table(void *_table)
>  
>  	return pgtable_free(table, index);
>  }
> -#else
> -void pgtable_free_tlb(struct mmu_gather *tlb, void *table, int index)
> -{
> -	return pgtable_free(table, index);
> -}
> -#endif
>  
>  #ifdef CONFIG_PROC_FS
>  atomic_long_t direct_pages_count[MMU_PAGE_COUNT];
> -- 
> 2.24.1
