Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1EEC30A46A
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 10:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232785AbhBAJeZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 04:34:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48732 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232771AbhBAJeW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 04:34:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612171975;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TRJgwth9GyqyyQWIRdUel3dkprdXQQtXGasEdO9dd+4=;
        b=cjkcrE+ueaI911nUlt0Bfk/RmuJTucV3Hrhs7/Y/b10TCWwRFHgUz+0ct5KCjGDgZw/xyA
        3RKRcmVu/gbZp0bFMDGgCpeHeL6msyvraaA3ZXxsBrPenclVaRbak53I6qMMIeMcZl2ydc
        onocBW0mWpZjtRwsdgnX6zM1vNej1/4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-10-AK_YxLelMz630S1tQGjELQ-1; Mon, 01 Feb 2021 04:32:53 -0500
X-MC-Unique: AK_YxLelMz630S1tQGjELQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E6304801AF1;
        Mon,  1 Feb 2021 09:32:50 +0000 (UTC)
Received: from [10.36.115.24] (ovpn-115-24.ams2.redhat.com [10.36.115.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DBD9260C66;
        Mon,  1 Feb 2021 09:32:45 +0000 (UTC)
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
References: <20210130221035.4169-1-rppt@kernel.org>
 <20210130221035.4169-2-rppt@kernel.org>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Subject: Re: [PATCH v4 1/2] x86/setup: always add the beginning of RAM as
 memblock.memory
Message-ID: <56e2c568-b121-8860-a6b0-274ace46d835@redhat.com>
Date:   Mon, 1 Feb 2021 10:32:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210130221035.4169-2-rppt@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 30.01.21 23:10, Mike Rapoport wrote:
> From: Mike Rapoport <rppt@linux.ibm.com>
> 
> The physical memory on an x86 system starts at address 0, but this is not
> always reflected in e820 map. For example, the BIOS can have e820 entries
> like
> 
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000001000-0x000000000009ffff] usable
> 
> or
> 
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000000fff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000001000-0x0000000000057fff] usable
> 
> In either case, e820__memblock_setup() won't add the range 0x0000 - 0x1000
> to memblock.memory and later during memory map initialization this range is
> left outside any zone.
> 
> With SPARSEMEM=y there is always a struct page for pfn 0 and this struct
> page will have it's zone link wrong no matter what value will be set there.
> 
> To avoid this inconsistency, add the beginning of RAM to memblock.memory.
> Limit the added chunk size to match the reserved memory to avoid
> registering memory that may be used by the firmware but never reserved at
> e820__memblock_setup() time.
> 
> Fixes: bde9cfa3afe4 ("x86/setup: don't remove E820_TYPE_RAM for pfn 0")
> Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> Cc: stable@vger.kernel.org
> ---
>   arch/x86/kernel/setup.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 3412c4595efd..67c77ed6eef8 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -727,6 +727,14 @@ static void __init trim_low_memory_range(void)
>   	 * Kconfig help text for X86_RESERVE_LOW.
>   	 */
>   	memblock_reserve(0, ALIGN(reserve_low, PAGE_SIZE));
> +
> +	/*
> +	 * Even if the firmware does not report the memory at address 0 as
> +	 * usable, inform the generic memory management about its existence
> +	 * to ensure it is a part of ZONE_DMA and the memory map for it is
> +	 * properly initialized.
> +	 */
> +	memblock_add(0, ALIGN(reserve_low, PAGE_SIZE));
>   }
>   	
>   /*
> 

I think, to make that code more robust, and to not rely on archs to do 
the right thing, we should do something like

1) Make sure in free_area_init() that each PFN with a memmap (i.e., 
falls into a partial present section) is spanned by a zone; that would 
include PFN 0 in this case.

2) In init_zone_unavailable_mem(), similar to round_up(max_pfn, 
PAGES_PER_SECTION) handling, consider range
	[round_down(min_pfn, PAGES_PER_SECTION), min_pfn - 1]
which would handle in the x86-64 case [0..0] and, therefore, initialize 
PFN 0.

Also, I think the special-case of PFN 0 is analogous to the 
round_up(max_pfn, PAGES_PER_SECTION) handling in 
init_zone_unavailable_mem(): who guarantees that these PFN above the 
highest present PFN are actually spanned by a zone?

I'd suggest going through all zone ranges in free_area_init() first, 
dealing with zones that have "not section aligned start/end", clamping 
them up/down if required such that no holes within a section are left 
uncovered by a zone.

-- 
Thanks,

David / dhildenb

