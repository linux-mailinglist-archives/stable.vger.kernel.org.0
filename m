Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA55D3226D6
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 09:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232155AbhBWIG3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 03:06:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29610 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232084AbhBWIGR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 03:06:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614067489;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TvIJWNY4/1GkazmbPNAwia/J/m5uVDdO8zNLf6UfHyc=;
        b=PghX9CnoOxvbWUo4w9lr4hKJrzriHfT8Bks71Zf8rMRRJoBc8i05xpHpoAPMuRuPy+8lE5
        zvNI2VUfp1hps+SdYq2TItPGIw5NOl28MPIO4/Jcb2hn2y5nQDa349e1GGKW9HURZ7OEwt
        7/pH/JryIBjClET/6O67FhsDXeaeahk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-RMz4k9mhMuqSZi37eipL3A-1; Tue, 23 Feb 2021 03:04:45 -0500
X-MC-Unique: RMz4k9mhMuqSZi37eipL3A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA3B780197A;
        Tue, 23 Feb 2021 08:04:27 +0000 (UTC)
Received: from [10.36.114.0] (ovpn-114-0.ams2.redhat.com [10.36.114.0])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ABF4719725;
        Tue, 23 Feb 2021 08:04:20 +0000 (UTC)
Subject: Re: [PATCH v6 1/1] mm/page_alloc.c: refactor initialization of struct
 page for holes in memory layout
To:     Mike Rapoport <rppt@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Andrea Arcangeli <aarcange@redhat.com>,
        Baoquan He <bhe@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?UTF-8?Q?=c5=81ukasz_Majczak?= <lma@semihalf.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>, Qian Cai <cai@lca.pw>,
        "Sarvela, Tomi P" <tomi.p.sarvela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org, x86@kernel.org
References: <20210222105728.28636-1-rppt@kernel.org>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <a7f70da1-6733-967f-4d1d-92d23b95a753@redhat.com>
Date:   Tue, 23 Feb 2021 09:04:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210222105728.28636-1-rppt@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 22.02.21 11:57, Mike Rapoport wrote:
> From: Mike Rapoport <rppt@linux.ibm.com>
> 
> There could be struct pages that are not backed by actual physical memory.
> This can happen when the actual memory bank is not a multiple of
> SECTION_SIZE or when an architecture does not register memory holes
> reserved by the firmware as memblock.memory.
> 
> Such pages are currently initialized using init_unavailable_mem() function
> that iterates through PFNs in holes in memblock.memory and if there is a
> struct page corresponding to a PFN, the fields of this page are set to
> default values and it is marked as Reserved.
> 
> init_unavailable_mem() does not take into account zone and node the page
> belongs to and sets both zone and node links in struct page to zero.
> 
> Before commit 73a6e474cb37 ("mm: memmap_init: iterate over memblock regions
> rather that check each PFN") the holes inside a zone were re-initialized
> during memmap_init() and got their zone/node links right. However, after
> that commit nothing updates the struct pages representing such holes.
> 
> On a system that has firmware reserved holes in a zone above ZONE_DMA, for
> instance in a configuration below:
> 
> 	# grep -A1 E820 /proc/iomem
> 	7a17b000-7a216fff : Unknown E820 type
> 	7a217000-7bffffff : System RAM
> 
> unset zone link in struct page will trigger
> 
> 	VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);
> 
> because there are pages in both ZONE_DMA32 and ZONE_DMA (unset zone link
> in struct page) in the same pageblock.
> 
> Interleave initialization of the unavailable pages with the normal
> initialization of memory map, so that zone and node information will be
> properly set on struct pages that are not backed by the actual memory.
> 
> With this change the pages for holes inside a zone will get proper
> zone/node links and the pages that are not spanned by any node will get
> links to the adjacent zone/node.

Does this include pages in the last section has handled by ...
...
> -	/*
> -	 * Early sections always have a fully populated memmap for the whole
> -	 * section - see pfn_valid(). If the last section has holes at the
> -	 * end and that section is marked "online", the memmap will be
> -	 * considered initialized. Make sure that memmap has a well defined
> -	 * state.
> -	 */
> -	pgcnt += init_unavailable_range(PFN_DOWN(next),
> -					round_up(max_pfn, PAGES_PER_SECTION));
> -

^ this code?

Or how is that case handled now?

-- 
Thanks,

David / dhildenb

