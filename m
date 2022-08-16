Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B487D595A57
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 13:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234885AbiHPLhz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 07:37:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233014AbiHPLhh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 07:37:37 -0400
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA814C612;
        Tue, 16 Aug 2022 04:04:04 -0700 (PDT)
Received: by mail-ej1-f53.google.com with SMTP id y13so18163411ejp.13;
        Tue, 16 Aug 2022 04:04:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=nd9E3ERHmlMBUFlo/ihXKmWFsJgTONarDHUMPdYaZ2Q=;
        b=2y98z5zz0EmCJcYGnc3Ojq08IXd93vO8zquBJZvK+CokyE67Ytoz4ApRhurjDbJ2rU
         iFnGRWFt7wtHSBR5tG/nuzT/Bvq8FmOc22M46EbiGaik113VUoRToN/VOptOVK7HTEy+
         9BQbh+vsq5tplJOcubcaNIx9qXS439PfzaQfo81TaK6YNrHdiF1jT2i0Afvfj/wcy5Xd
         Idffwx4kA0HaZfMZtgWiYiYhHN6cmLsiS3UV9G8poxVareDM+DdiHoC3kBoG1CYEl6Mh
         iWYTnA2sFaMZUiW00iaVtSyhONQzKBkXXqwHAF5Xz4eN9RdVG2TDv1rzBv0mzNJl49Yx
         tQlQ==
X-Gm-Message-State: ACgBeo2TvNkmEBu8QxE8UdCN37MxPEkIgpK21kLPjSjBoOoU6D1sjWKF
        hHE+8JbZWs5uhjIIr/XxIBs=
X-Google-Smtp-Source: AA6agR5w33g8Zp3gOjtUawQuZF37ADesLbkchseJLmGfuU/MeFpxiidHNAW+Pu7+6xtVswq2RwHrwg==
X-Received: by 2002:a17:906:8a65:b0:730:6ebb:c96c with SMTP id hy5-20020a1709068a6500b007306ebbc96cmr12989684ejc.733.1660647842427;
        Tue, 16 Aug 2022 04:04:02 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id y19-20020a170906071300b007303fe58eb2sm5122514ejb.154.2022.08.16.04.04.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Aug 2022 04:04:02 -0700 (PDT)
Message-ID: <9b1474ea-8568-cdb5-72dc-51d577497f8a@kernel.org>
Date:   Tue, 16 Aug 2022 13:04:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Subject: Re: [PATCH 5.19 0767/1157] kasan: fix zeroing vmalloc memory with
 HW_TAGS
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Andrey Konovalov <andreyknvl@google.com>,
        Marco Elver <elver@google.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
References: <20220815180439.416659447@linuxfoundation.org>
 <20220815180510.173732661@linuxfoundation.org>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20220815180510.173732661@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 15. 08. 22, 20:02, Greg Kroah-Hartman wrote:
> From: Andrey Konovalov <andreyknvl@google.com>
> 
> [ Upstream commit 6c2f761dad7851d8088b91063ccaea3c970efe78 ]
> 
> HW_TAGS KASAN skips zeroing page_alloc allocations backing vmalloc
> mappings via __GFP_SKIP_ZERO.  Instead, these pages are zeroed via
> kasan_unpoison_vmalloc() by passing the KASAN_VMALLOC_INIT flag.
> 
> The problem is that __kasan_unpoison_vmalloc() does not zero pages when
> either kasan_vmalloc_enabled() or is_vmalloc_or_module_addr() fail.
> 
> Thus:
> 
> 1. Change __vmalloc_node_range() to only set KASAN_VMALLOC_INIT when
>     __GFP_SKIP_ZERO is set.
> 
> 2. Change __kasan_unpoison_vmalloc() to always zero pages when the
>     KASAN_VMALLOC_INIT flag is set.
> 
> 3. Add WARN_ON() asserts to check that KASAN_VMALLOC_INIT cannot be set
>     in other early return paths of __kasan_unpoison_vmalloc().
> 
> Also clean up the comment in __kasan_unpoison_vmalloc.
> 
> Link: https://lkml.kernel.org/r/4bc503537efdc539ffc3f461c1b70162eea31cf6.1654798516.git.andreyknvl@google.com
> Fixes: 23689e91fb22 ("kasan, vmalloc: add vmalloc tagging for HW_TAGS")
> Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
> Cc: Marco Elver <elver@google.com>
> Cc: Alexander Potapenko <glider@google.com>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   mm/kasan/hw_tags.c | 32 +++++++++++++++++++++++---------
>   mm/vmalloc.c       | 10 +++++-----
>   2 files changed, 28 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/kasan/hw_tags.c b/mm/kasan/hw_tags.c
> index 9e1b6544bfa8..9ad8eff71b28 100644
> --- a/mm/kasan/hw_tags.c
> +++ b/mm/kasan/hw_tags.c
> @@ -257,27 +257,37 @@ static void unpoison_vmalloc_pages(const void *addr, u8 tag)
>   	}
>   }
>   
> +static void init_vmalloc_pages(const void *start, unsigned long size)
> +{
> +	const void *addr;
> +
> +	for (addr = start; addr < start + size; addr += PAGE_SIZE) {
> +		struct page *page = virt_to_page(addr);
> +
> +		clear_highpage_kasan_tagged(page);

This breaks build on aarch64:
> mm/kasan/hw_tags.c: In function 'init_vmalloc_pages':
> mm/kasan/hw_tags.c:267:17: error: implicit declaration of function 'clear_highpage_kasan_tagged' [-Werror=implicit-function-declaration]



> +	}
> +}
> +
>   void *__kasan_unpoison_vmalloc(const void *start, unsigned long size,
>   				kasan_vmalloc_flags_t flags)
>   {
>   	u8 tag;
>   	unsigned long redzone_start, redzone_size;
>   
> -	if (!kasan_vmalloc_enabled())
> -		return (void *)start;
> -
> -	if (!is_vmalloc_or_module_addr(start))
> +	if (!kasan_vmalloc_enabled() || !is_vmalloc_or_module_addr(start)) {
> +		if (flags & KASAN_VMALLOC_INIT)
> +			init_vmalloc_pages(start, size);
>   		return (void *)start;
> +	}
>   
>   	/*
> -	 * Skip unpoisoning and assigning a pointer tag for non-VM_ALLOC
> -	 * mappings as:
> +	 * Don't tag non-VM_ALLOC mappings, as:
>   	 *
>   	 * 1. Unlike the software KASAN modes, hardware tag-based KASAN only
>   	 *    supports tagging physical memory. Therefore, it can only tag a
>   	 *    single mapping of normal physical pages.
>   	 * 2. Hardware tag-based KASAN can only tag memory mapped with special
> -	 *    mapping protection bits, see arch_vmalloc_pgprot_modify().
> +	 *    mapping protection bits, see arch_vmap_pgprot_tagged().
>   	 *    As non-VM_ALLOC mappings can be mapped outside of vmalloc code,
>   	 *    providing these bits would require tracking all non-VM_ALLOC
>   	 *    mappers.
> @@ -289,15 +299,19 @@ void *__kasan_unpoison_vmalloc(const void *start, unsigned long size,
>   	 *
>   	 * For non-VM_ALLOC allocations, page_alloc memory is tagged as usual.
>   	 */
> -	if (!(flags & KASAN_VMALLOC_VM_ALLOC))
> +	if (!(flags & KASAN_VMALLOC_VM_ALLOC)) {
> +		WARN_ON(flags & KASAN_VMALLOC_INIT);
>   		return (void *)start;
> +	}
>   
>   	/*
>   	 * Don't tag executable memory.
>   	 * The kernel doesn't tolerate having the PC register tagged.
>   	 */
> -	if (!(flags & KASAN_VMALLOC_PROT_NORMAL))
> +	if (!(flags & KASAN_VMALLOC_PROT_NORMAL)) {
> +		WARN_ON(flags & KASAN_VMALLOC_INIT);
>   		return (void *)start;
> +	}
>   
>   	tag = kasan_random_tag();
>   	start = set_tag(start, tag);
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index effd1ff6a4b4..a1ab9b472571 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3168,15 +3168,15 @@ void *__vmalloc_node_range(unsigned long size, unsigned long align,
>   
>   	/*
>   	 * Mark the pages as accessible, now that they are mapped.
> -	 * The init condition should match the one in post_alloc_hook()
> -	 * (except for the should_skip_init() check) to make sure that memory
> -	 * is initialized under the same conditions regardless of the enabled
> -	 * KASAN mode.
> +	 * The condition for setting KASAN_VMALLOC_INIT should complement the
> +	 * one in post_alloc_hook() with regards to the __GFP_SKIP_ZERO check
> +	 * to make sure that memory is initialized under the same conditions.
>   	 * Tag-based KASAN modes only assign tags to normal non-executable
>   	 * allocations, see __kasan_unpoison_vmalloc().
>   	 */
>   	kasan_flags |= KASAN_VMALLOC_VM_ALLOC;
> -	if (!want_init_on_free() && want_init_on_alloc(gfp_mask))
> +	if (!want_init_on_free() && want_init_on_alloc(gfp_mask) &&
> +	    (gfp_mask & __GFP_SKIP_ZERO))
>   		kasan_flags |= KASAN_VMALLOC_INIT;
>   	/* KASAN_VMALLOC_PROT_NORMAL already set if required. */
>   	area->addr = kasan_unpoison_vmalloc(area->addr, real_size, kasan_flags);

-- 
js
suse labs

