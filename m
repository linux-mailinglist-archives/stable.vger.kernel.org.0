Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4914D331667
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 19:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbhCHSmz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 13:42:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:57348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230075AbhCHSm3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 13:42:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27C406521D;
        Mon,  8 Mar 2021 18:42:26 +0000 (UTC)
Date:   Mon, 8 Mar 2021 18:42:15 +0000
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Andrey Konovalov <andreyknvl@google.com>
Cc:     Will Deacon <will.deacon@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Alexander Potapenko <glider@google.com>,
        Marco Elver <elver@google.com>,
        Peter Collingbourne <pcc@google.com>,
        Evgenii Stepanov <eugenis@google.com>,
        Branislav Rankov <Branislav.Rankov@arm.com>,
        Kevin Brodsky <kevin.brodsky@arm.com>,
        kasan-dev@googlegroups.com, linux-arm-kernel@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] arm64: kasan: fix page_alloc tagging with DEBUG_VIRTUAL
Message-ID: <20210308184214.GI15644@arm.com>
References: <4b55b35202706223d3118230701c6a59749d9b72.1615219501.git.andreyknvl@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b55b35202706223d3118230701c6a59749d9b72.1615219501.git.andreyknvl@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 08, 2021 at 05:10:23PM +0100, Andrey Konovalov wrote:
> When CONFIG_DEBUG_VIRTUAL is enabled, the default page_to_virt() macro
> implementation from include/linux/mm.h is used. That definition doesn't
> account for KASAN tags, which leads to no tags on page_alloc allocations.
> 
> Provide an arm64-specific definition for page_to_virt() when
> CONFIG_DEBUG_VIRTUAL is enabled that takes care of KASAN tags.
> 
> Fixes: 2813b9c02962 ("kasan, mm, arm64: tag non slab memory allocated via pagealloc")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
> ---
>  arch/arm64/include/asm/memory.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
> index c759faf7a1ff..0aabc3be9a75 100644
> --- a/arch/arm64/include/asm/memory.h
> +++ b/arch/arm64/include/asm/memory.h
> @@ -328,6 +328,11 @@ static inline void *phys_to_virt(phys_addr_t x)
>  #define ARCH_PFN_OFFSET		((unsigned long)PHYS_PFN_OFFSET)
>  
>  #if !defined(CONFIG_SPARSEMEM_VMEMMAP) || defined(CONFIG_DEBUG_VIRTUAL)
> +#define page_to_virt(x)	({						\
> +	__typeof__(x) __page = x;					\
> +	void *__addr = __va(page_to_phys(__page));			\
> +	(void *)__tag_set((const void *)__addr, page_kasan_tag(__page));\
> +})
>  #define virt_to_page(x)		pfn_to_page(virt_to_pfn(x))

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
