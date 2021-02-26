Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83C553261C5
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 12:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbhBZLIp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Feb 2021 06:08:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42200 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230153AbhBZLIp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Feb 2021 06:08:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614337637;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Tk06oGoT/WyXBHM/QvyAXYl1KqMGMDdyTbImAeS6eqY=;
        b=SXfSx5UwN53pl1BymM/P5GJa58LFdWWccHHEW4HlPTSkm3EXRW8Fx0zmdZphxfhaAhg4Np
        g5D3HrXdXPWVbDTjKuTD6wENStPi0Xz6oSlcmKpx9Mdo+tIV/iQv2iT1kYwDBhsletDxOq
        in7Xtr6u2BRKexL7/I5cFLq1J4Gcbvg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-bFck02I7PoyTOVy4T72SBw-1; Fri, 26 Feb 2021 06:07:12 -0500
X-MC-Unique: bFck02I7PoyTOVy4T72SBw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8A38018BA28A;
        Fri, 26 Feb 2021 11:07:05 +0000 (UTC)
Received: from [10.36.112.148] (ovpn-112-148.ams2.redhat.com [10.36.112.148])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1D60C7093A;
        Fri, 26 Feb 2021 11:07:00 +0000 (UTC)
Subject: Re: [PATCH v8 1/1] mm/page_alloc.c: refactor initialization of struct
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
References: <20210225224351.7356-1-rppt@kernel.org>
 <20210225224351.7356-2-rppt@kernel.org>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <d1dff930-5719-c011-e5ee-b81f2a9fdb47@redhat.com>
Date:   Fri, 26 Feb 2021 12:07:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210225224351.7356-2-rppt@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 25.02.21 23:43, Mike Rapoport wrote:
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
> in set_pfnblock_flags_mask() when called with a struct page from a range
> other than E820_TYPE_RAM because there are pages in the range of ZONE_DMA32
> but the unset zone link in struct page makes them appear as a part of
> ZONE_DMA.
> 
> Interleave initialization of the unavailable pages with the normal
> initialization of memory map, so that zone and node information will be
> properly set on struct pages that are not backed by the actual memory.
> 
> With this change the pages for holes inside a zone will get proper
> zone/node links and the pages that are not spanned by any node will get
> links to the adjacent zone/node. The holes between nodes will be prepended
> to the zone/node above the hole and the trailing pages in the last section
> that will be appended to the zone/node below.
> 
> Fixes: 73a6e474cb37 ("mm: memmap_init: iterate over memblock regions rather that check each PFN")
> Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> Reported-by: Qian Cai <cai@lca.pw>
> Reported-by: Andrea Arcangeli <aarcange@redhat.com>
> Reviewed-by: Baoquan He <bhe@redhat.com>
> Acked-by: Vlastimil Babka <vbabka@suse.cz>
> ---

Reviewed-by: David Hildenbrand <david@redhat.com>

Thanks Mike!


-- 
Thanks,

David / dhildenb

