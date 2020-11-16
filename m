Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 023A62B54E0
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 00:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729210AbgKPXVA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 18:21:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:37060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725710AbgKPXVA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Nov 2020 18:21:00 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA93B2244C;
        Mon, 16 Nov 2020 23:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605568860;
        bh=Ckc3lnp9XJjLw+HiUSyThl4xMi1jyjUDeG3UV03dKcE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Sz5Uq2AnBExzb5l+OhENUeOTkb9n1z1tBFW7HcABvnUh/b/GF31PPhR2Fm+GUMLU0
         PKlDLmr/z60juSOlF+47U3YG4ITtDLzhpEGatctxb1UgMmvYqjhrw37aUxypjv8Iz/
         U4iOtDesqwGRLGPN44+5wzUkjTcK1bHn7vQMR3b0=
Date:   Mon, 16 Nov 2020 15:20:58 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Minchan Kim <minchan@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Harish Sriram <harish@linux.ibm.com>, stable@vger.kernel.org,
        "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: Re: [PATCH] Revert
 "mm/vunmap: add cond_resched() in vunmap_pmd_range"
Message-Id: <20201116152058.effcc5e6915cd9b98ba31348@linux-foundation.org>
In-Reply-To: <20201116175323.GB3805951@google.com>
References: <20201105170249.387069-1-minchan@kernel.org>
        <20201106175933.90e4c8851010c9ce4dd732b6@linux-foundation.org>
        <20201107083939.GA1633068@google.com>
        <20201112200101.GC123036@google.com>
        <20201112144919.5f6b36876f4e59ebb4a99d6d@linux-foundation.org>
        <20201113162529.GA2378542@google.com>
        <20201116175323.GB3805951@google.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Let's cc Uladzislau on vmalloc things?

> How about this?

Well, lol, that's a simple approach to avoiding the problem ;)

> unmap_kernel_range had been atomic operation and zsmalloc has used
> it in atomic context in zs_unmap_object.
> However, ("e47110e90584, mm/vunmap: add cond_resched() in vunmap_pmd_range")
> changed it into non-atomic operation via adding cond_resched.
> It causes zram decompresion failure by corrupting compressed buffer
> in atomic context.
> 
> This patch introduces unmap_kernel_range_atomic which works for
> only range less than PMD_SIZE to prevent cond_resched call.
> 
> ...
>
> --- a/include/linux/vmalloc.h
> +++ b/include/linux/vmalloc.h
> @@ -180,6 +180,7 @@ int map_kernel_range(unsigned long start, unsigned long size, pgprot_t prot,
>  		struct page **pages);
>  extern void unmap_kernel_range_noflush(unsigned long addr, unsigned long size);
>  extern void unmap_kernel_range(unsigned long addr, unsigned long size);
> +extern void unmap_kernel_range_atomic(unsigned long addr, unsigned long size);
>  static inline void set_vm_flush_reset_perms(void *addr)
>  {
>  	struct vm_struct *vm = find_vm_area(addr);
> @@ -200,6 +201,7 @@ unmap_kernel_range_noflush(unsigned long addr, unsigned long size)
>  {
>  }
>  #define unmap_kernel_range unmap_kernel_range_noflush
> +#define unmap_kernel_range_atomic unmap_kernel_range_noflush
>  static inline void set_vm_flush_reset_perms(void *addr)
>  {
>  }
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index d7075ad340aa..714e5425dc45 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -88,6 +88,7 @@ static void vunmap_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
>  	pmd_t *pmd;
>  	unsigned long next;
>  	int cleared;
> +	bool check_resched = (end - addr) > PMD_SIZE;
>  
>  	pmd = pmd_offset(pud, addr);
>  	do {
> @@ -102,8 +103,8 @@ static void vunmap_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
>  		if (pmd_none_or_clear_bad(pmd))
>  			continue;
>  		vunmap_pte_range(pmd, addr, next, mask);
> -
> -		cond_resched();
> +		if (check_resched)
> +			cond_resched();
>  	} while (pmd++, addr = next, addr != end);
>  }
>  
> @@ -2024,6 +2025,24 @@ void unmap_kernel_range(unsigned long addr, unsigned long size)
>  	flush_tlb_kernel_range(addr, end);
>  }
>  
> +/**
> + * unmap_kernel_range_atomic - unmap kernel VM area and flush cache and TLB
> + * @addr: start of the VM area to unmap
> + * @size: size of the VM area to unmap
> + *
> + * Similar to unmap_kernel_range_noflush() but it's atomic. @size should be
> + * less than PMD_SIZE.
> + */
> +void unmap_kernel_range_atomic(unsigned long addr, unsigned long size)
> +{
> +	unsigned long end = addr + size;
> +
> +	flush_cache_vunmap(addr, end);
> +	WARN_ON(size > PMD_SIZE);

WARN_ON_ONCE() would be better here - no point in creating a million
warnings where one would suffice.

> +	unmap_kernel_range_noflush(addr, size);
> +	flush_tlb_kernel_range(addr, end);
> +}
> +
>  static inline void setup_vmalloc_vm_locked(struct vm_struct *vm,
>  	struct vmap_area *va, unsigned long flags, const void *caller)
>  {
> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> index 662ee420706f..9decc7634852 100644
> --- a/mm/zsmalloc.c
> +++ b/mm/zsmalloc.c
> @@ -1154,7 +1154,7 @@ static inline void __zs_unmap_object(struct mapping_area *area,
>  {
>  	unsigned long addr = (unsigned long)area->vm_addr;
>  
> -	unmap_kernel_range(addr, PAGE_SIZE * 2);
> +	unmap_kernel_range_atomic(addr, PAGE_SIZE * 2);
>  }

I suppose we could live with it if no better solutions are forthcoming.
