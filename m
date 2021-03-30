Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4978134E34C
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 10:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbhC3IkH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Mar 2021 04:40:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36916 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231537AbhC3Ijs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Mar 2021 04:39:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617093588;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KXQmTQDu9c+2SYac0KGEwbkl0f73KbuMpkS546ZCxxU=;
        b=a8J8rAHoNgc9cJ9m+64LFCALLV5yb0lEGU4/eUS6xjpXBXmzfBskNh7Rh60D+OIaZAslEf
        liCU+74sjy1xm97vrGi/Amx0Um5QihcLbmZSZpp1gUbxBS9Vsgq5qsNM0sGzVW4ZNp2QhM
        sRJ8gEv0JPkhVlnOllouELaAI3YjslQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-499-JfDCLdmgMPezIKTDgvIweA-1; Tue, 30 Mar 2021 04:39:45 -0400
X-MC-Unique: JfDCLdmgMPezIKTDgvIweA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 82F241927800;
        Tue, 30 Mar 2021 08:39:43 +0000 (UTC)
Received: from [10.36.114.210] (ovpn-114-210.ams2.redhat.com [10.36.114.210])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 700A1299C4;
        Tue, 30 Mar 2021 08:39:41 +0000 (UTC)
Subject: Re: [PATCH v3] mm: page_alloc: ignore init_on_free=1 for
 debug_pagealloc=1
To:     Sergei Trofimovich <slyfox@gentoo.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrey Konovalov <andreyknvl@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-mm@kvack.org
References: <ea46d903-d201-5781-1f3c-f8d7fea5070e@suse.cz>
 <20210329222555.3077928-1-slyfox@gentoo.org>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <181e57b8-d606-e974-47d4-7cceebfdfc87@redhat.com>
Date:   Tue, 30 Mar 2021 10:39:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210329222555.3077928-1-slyfox@gentoo.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 30.03.21 00:25, Sergei Trofimovich wrote:
> On !ARCH_SUPPORTS_DEBUG_PAGEALLOC (like ia64) debug_pagealloc=1
> implies page_poison=on:
> 
>      if (page_poisoning_enabled() ||
>           (!IS_ENABLED(CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC) &&
>            debug_pagealloc_enabled()))
>              static_branch_enable(&_page_poisoning_enabled);
> 
> page_poison=on needs to override init_on_free=1.
> 
> Before the change it did not work as expected for the following case:
> - have PAGE_POISONING=y
> - have page_poison unset
> - have !ARCH_SUPPORTS_DEBUG_PAGEALLOC arch (like ia64)
> - have init_on_free=1
> - have debug_pagealloc=1
> 
> That way we get both keys enabled:
> - static_branch_enable(&init_on_free);
> - static_branch_enable(&_page_poisoning_enabled);
> 
> which leads to poisoned pages returned for __GFP_ZERO pages.
> 
> After the change we execute only:
> - static_branch_enable(&_page_poisoning_enabled);
> and ignore init_on_free=1.
> 
> Acked-by: Vlastimil Babka <vbabka@suse.cz>
> Fixes: 8db26a3d4735 ("mm, page_poison: use static key more efficiently")
> Cc: <stable@vger.kernel.org>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: linux-mm@kvack.org
> CC: David Hildenbrand <david@redhat.com>
> CC: Andrey Konovalov <andreyknvl@gmail.com>
> Link: https://lkml.org/lkml/2021/3/26/443
> 
> Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
> ---
> Change since v2:
> - Added 'Fixes:' and 'CC: stable@' suggested by Vlastimil and David
> - Renamed local variable to 'page_poisoning_requested' for
>    consistency suggested by David
> - Simplified initialization of page_poisoning_requested suggested
>    by David
> - Added 'Acked-by: Vlastimil'
> 
>   mm/page_alloc.c | 30 +++++++++++++++++-------------
>   1 file changed, 17 insertions(+), 13 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index cfc72873961d..4bb3cdfc47f8 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -764,32 +764,36 @@ static inline void clear_page_guard(struct zone *zone, struct page *page,
>    */
>   void init_mem_debugging_and_hardening(void)
>   {
> +	bool page_poisoning_requested = false;
> +
> +#ifdef CONFIG_PAGE_POISONING
> +	/*
> +	 * Page poisoning is debug page alloc for some arches. If
> +	 * either of those options are enabled, enable poisoning.
> +	 */
> +	if (page_poisoning_enabled() ||
> +	     (!IS_ENABLED(CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC) &&
> +	      debug_pagealloc_enabled())) {
> +		static_branch_enable(&_page_poisoning_enabled);
> +		page_poisoning_requested = true;
> +	}
> +#endif
> +
>   	if (_init_on_alloc_enabled_early) {
> -		if (page_poisoning_enabled())
> +		if (page_poisoning_requested)
>   			pr_info("mem auto-init: CONFIG_PAGE_POISONING is on, "
>   				"will take precedence over init_on_alloc\n");
>   		else
>   			static_branch_enable(&init_on_alloc);
>   	}
>   	if (_init_on_free_enabled_early) {
> -		if (page_poisoning_enabled())
> +		if (page_poisoning_requested)
>   			pr_info("mem auto-init: CONFIG_PAGE_POISONING is on, "
>   				"will take precedence over init_on_free\n");
>   		else
>   			static_branch_enable(&init_on_free);
>   	}
>   
> -#ifdef CONFIG_PAGE_POISONING
> -	/*
> -	 * Page poisoning is debug page alloc for some arches. If
> -	 * either of those options are enabled, enable poisoning.
> -	 */
> -	if (page_poisoning_enabled() ||
> -	     (!IS_ENABLED(CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC) &&
> -	      debug_pagealloc_enabled()))
> -		static_branch_enable(&_page_poisoning_enabled);
> -#endif
> -
>   #ifdef CONFIG_DEBUG_PAGEALLOC
>   	if (!debug_pagealloc_enabled())
>   		return;
> 

Thanks!

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

