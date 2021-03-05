Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1996932F6CD
	for <lists+stable@lfdr.de>; Sat,  6 Mar 2021 00:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbhCEXuA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 18:50:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:57230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229697AbhCEXt5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 18:49:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A66BD65073;
        Fri,  5 Mar 2021 23:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614988197;
        bh=T1WRciFZ6SROSTvnq6Id8/sVq43F1qvTO0XybjxDSNs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=2J4OjFKKqN1PUcQG2vhC4e4UvgSYhgzDkv/q78FCoHnZt4B511g2fPskOH7C/cfeo
         TcYzPlKhPlrZOeiNlCy5ilQYwSnTfvDkR+cfhwC8OULkj7HVL5EAcsjHHfmQnQs2MY
         ERQVAQ7Uq32B4Ha2x56xXw/JUWk75dvlyr/B1DSs=
Date:   Fri, 5 Mar 2021 15:49:56 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Andrey Konovalov <andreyknvl@google.com>
Cc:     Alexander Potapenko <glider@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Marco Elver <elver@google.com>,
        Peter Collingbourne <pcc@google.com>,
        Evgenii Stepanov <eugenis@google.com>,
        Branislav Rankov <Branislav.Rankov@arm.com>,
        Kevin Brodsky <kevin.brodsky@arm.com>,
        kasan-dev@googlegroups.com, linux-arm-kernel@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] kasan, mm: fix crash with HW_TAGS and
 DEBUG_PAGEALLOC
Message-Id: <20210305154956.3bbfcedab3f549b708d5e2fa@linux-foundation.org>
In-Reply-To: <24cd7db274090f0e5bc3adcdc7399243668e3171.1614987311.git.andreyknvl@google.com>
References: <24cd7db274090f0e5bc3adcdc7399243668e3171.1614987311.git.andreyknvl@google.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat,  6 Mar 2021 00:36:33 +0100 Andrey Konovalov <andreyknvl@google.com> wrote:

> Currently, kasan_free_nondeferred_pages()->kasan_free_pages() is called
> after debug_pagealloc_unmap_pages(). This causes a crash when
> debug_pagealloc is enabled, as HW_TAGS KASAN can't set tags on an
> unmapped page.
> 
> This patch puts kasan_free_nondeferred_pages() before
> debug_pagealloc_unmap_pages() and arch_free_page(), which can also make
> the page unavailable.
> 
> ...
>
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1304,6 +1304,12 @@ static __always_inline bool free_pages_prepare(struct page *page,
>  
>  	kernel_poison_pages(page, 1 << order);
>  
> +	/*
> +	 * With hardware tag-based KASAN, memory tags must be set before the
> +	 * page becomes unavailable via debug_pagealloc or arch_free_page.
> +	 */
> +	kasan_free_nondeferred_pages(page, order, fpi_flags);
> +
>  	/*
>  	 * arch_free_page() can make the page's contents inaccessible.  s390
>  	 * does this.  So nothing which can access the page's contents should
> @@ -1313,8 +1319,6 @@ static __always_inline bool free_pages_prepare(struct page *page,
>  
>  	debug_pagealloc_unmap_pages(page, 1 << order);
>  
> -	kasan_free_nondeferred_pages(page, order, fpi_flags);
> -
>  	return true;
>  }

kasan_free_nondeferred_pages() has only two args in current mainline.

I fixed that in the obvious manner...
