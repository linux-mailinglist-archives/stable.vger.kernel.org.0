Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AEDB31B5F9
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 09:48:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbhBOIrP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 03:47:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43894 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229943AbhBOIrO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Feb 2021 03:47:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613378745;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0pkjOUDVkE/MRzGwK00jh4QWH14hnNozDo7Jiu945IU=;
        b=UeXNpnNXDp/T9bbhdcv7tiPYlsOXP/5G/Aut4rIeuyN2xlxcmHRXqRzEQUqRuQHb31bhzB
        S+KQR6NFmBm3O4Sbu4eSqSWPgRATfv4X4/VsLgX+cav7KgiGjYdAekWkTuWLDk59rVIt5a
        BczP2aD2+awc9Yawm5M3PKNJcuX7Sh8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-579-D7aIz6oePyqRY6RpuI7yAQ-1; Mon, 15 Feb 2021 03:45:43 -0500
X-MC-Unique: D7aIz6oePyqRY6RpuI7yAQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C07A3801965;
        Mon, 15 Feb 2021 08:45:40 +0000 (UTC)
Received: from [10.36.114.89] (ovpn-114-89.ams2.redhat.com [10.36.114.89])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 889DA5D9CA;
        Mon, 15 Feb 2021 08:45:31 +0000 (UTC)
To:     Mike Rapoport <rppt@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
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
References: <20210208110820.6269-1-rppt@kernel.org>
 <5dccbc93-f260-7f14-23bc-6dee2dff6c13@redhat.com>
 <a6cf3a26-a174-abab-a5a0-6cf89ebe4af7@redhat.com>
 <20210214172906.GN242749@kernel.org>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Subject: Re: [PATCH v5 1/1] mm: refactor initialization of struct page for
 holes in memory layout
Message-ID: <c1559dcb-7953-fe08-604a-5eaf202bf662@redhat.com>
Date:   Mon, 15 Feb 2021 09:45:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210214172906.GN242749@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 14.02.21 18:29, Mike Rapoport wrote:
> On Fri, Feb 12, 2021 at 10:56:19AM +0100, David Hildenbrand wrote:
>> On 12.02.21 10:55, David Hildenbrand wrote:
>>> On 08.02.21 12:08, Mike Rapoport wrote:
>>>> +#ifdef CONFIG_SPARSEMEM
>>>> +	/*
>>>> +	 * Sections in the memory map may not match actual populated
>>>> +	 * memory, extend the node span to cover the entire section.
>>>> +	 */
>>>> +	*start_pfn = round_down(*start_pfn, PAGES_PER_SECTION);
>>>> +	*end_pfn = round_up(*end_pfn, PAGES_PER_SECTION);
>>>
>>> Does that mean that we might create overlapping zones when one node
>>
>> s/overlapping zones/overlapping nodes/
>>
>>> starts in the middle of a section and the other one ends in the middle
>>> of a section?
>>
>>> Could it be a problem? (e.g., would we have to look at neighboring nodes
>>> when making the decision to extend, and how far to extend?)
> 
> Having a node end/start in a middle of a section would be a problem, but in
> this case I don't see a way to detect how a node should be extended :(

Running QEMU with something like:

...
     -m 8G \
     -smp sockets=2,cores=2 \
     -object memory-backend-ram,id=bmem0,size=4160M \
     -object memory-backend-ram,id=bmem1,size=4032M \
     -numa node,nodeid=0,cpus=0-1,memdev=bmem0 -numa node,nodeid=1,cpus=2-3,memdev=bmem1 \
...

Creates such a setup.

With an older kernel:

[    0.000000] BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bffdffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bffe0000-0x00000000bfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000023fffffff] usable
[...]
[    0.002506] ACPI: SRAT: Node 0 PXM 0 [mem 0x00000000-0x0009ffff]
[    0.002508] ACPI: SRAT: Node 0 PXM 0 [mem 0x00100000-0xbfffffff]
[    0.002509] ACPI: SRAT: Node 0 PXM 0 [mem 0x100000000-0x143ffffff]
[    0.002510] ACPI: SRAT: Node 1 PXM 1 [mem 0x144000000-0x23fffffff]
[    0.002511] NUMA: Node 0 [mem 0x00000000-0x0009ffff] + [mem 0x00100000-0xbfffffff] -> [mem 0x00000000-0xbfffffff]
[    0.002513] NUMA: Node 0 [mem 0x00000000-0xbfffffff] + [mem 0x100000000-0x143ffffff] -> [mem 0x00000000-0x143ffffff]
[    0.002519] NODE_DATA(0) allocated [mem 0x143fd5000-0x143ffffff]
[    0.002669] NODE_DATA(1) allocated [mem 0x23ffd2000-0x23fffcfff]
[    0.017947] memblock: reserved range [0x0000000000000000-0x0000000000001000] is not in memory
[    0.017953] memblock: reserved range [0x000000000009f000-0x0000000000100000] is not in memory
[    0.017956] Zone ranges:
[    0.017957]   DMA      [mem 0x0000000000000000-0x0000000000ffffff]
[    0.017958]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.017960]   Normal   [mem 0x0000000100000000-0x000000023fffffff]
[    0.017961]   Device   empty
[    0.017962] Movable zone start for each node
[    0.017964] Early memory node ranges
[    0.017965]   node   0: [mem 0x0000000000000000-0x00000000bffdffff]
[    0.017966]   node   0: [mem 0x0000000100000000-0x0000000143ffffff]
[    0.017967]   node   1: [mem 0x0000000144000000-0x000000023fffffff]
[    0.017969] Initmem setup node 0 [mem 0x0000000000000000-0x0000000143ffffff]
[    0.017971] On node 0 totalpages: 1064928
[    0.017972]   DMA zone: 64 pages used for memmap
[    0.017973]   DMA zone: 21 pages reserved
[    0.017974]   DMA zone: 4096 pages, LIFO batch:0
[    0.017994]   DMA32 zone: 12224 pages used for memmap
[    0.017995]   DMA32 zone: 782304 pages, LIFO batch:63
[    0.022281] DMA32: Zeroed struct page in unavailable ranges: 32
[    0.022286]   Normal zone: 4352 pages used for memmap
[    0.022287]   Normal zone: 278528 pages, LIFO batch:63
[    0.023769] Initmem setup node 1 [mem 0x0000000144000000-0x000000023fffffff]
[    0.023774] On node 1 totalpages: 1032192
[    0.023775]   Normal zone: 16128 pages used for memmap
[    0.023775]   Normal zone: 1032192 pages, LIFO batch:63


With current next/master:

[    0.000000] BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bffdffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bffe0000-0x00000000bfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000023fffffff] usable
[...]
[    0.002419] ACPI: SRAT: Node 0 PXM 0 [mem 0x00000000-0x0009ffff]
[    0.002421] ACPI: SRAT: Node 0 PXM 0 [mem 0x00100000-0xbfffffff]
[    0.002422] ACPI: SRAT: Node 0 PXM 0 [mem 0x100000000-0x143ffffff]
[    0.002423] ACPI: SRAT: Node 1 PXM 1 [mem 0x144000000-0x23fffffff]
[    0.002424] NUMA: Node 0 [mem 0x00000000-0x0009ffff] + [mem 0x00100000-0xbfffffff] -> [mem 0x00000000-0xbfffffff]
[    0.002426] NUMA: Node 0 [mem 0x00000000-0xbfffffff] + [mem 0x100000000-0x143ffffff] -> [mem 0x00000000-0x143ffffff]
[    0.002432] NODE_DATA(0) allocated [mem 0x143fd5000-0x143ffffff]
[    0.002583] NODE_DATA(1) allocated [mem 0x23ffd2000-0x23fffcfff]
[    0.017722] Zone ranges:
[    0.017726]   DMA      [mem 0x0000000000000000-0x0000000000ffffff]
[    0.017728]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.017729]   Normal   [mem 0x0000000100000000-0x000000023fffffff]
[    0.017731]   Device   empty
[    0.017732] Movable zone start for each node
[    0.017734] Early memory node ranges
[    0.017735]   node   0: [mem 0x0000000000001000-0x000000000009efff]
[    0.017736]   node   0: [mem 0x0000000000100000-0x00000000bffdffff]
[    0.017737]   node   0: [mem 0x0000000100000000-0x0000000143ffffff]
[    0.017738]   node   1: [mem 0x0000000144000000-0x000000023fffffff]
[    0.017741] Initmem setup node 0 [mem 0x0000000000000000-0x0000000147ffffff]
[    0.017742] On node 0 totalpages: 1064830
[    0.017743]   DMA zone: 64 pages used for memmap
[    0.017744]   DMA zone: 21 pages reserved
[    0.017745]   DMA zone: 3998 pages, LIFO batch:0
[    0.017765]   DMA zone: 98 pages in unavailable ranges
[    0.017766]   DMA32 zone: 12224 pages used for memmap
[    0.017766]   DMA32 zone: 782304 pages, LIFO batch:63
[    0.022042]   DMA32 zone: 32 pages in unavailable ranges
[    0.022046]   Normal zone: 4608 pages used for memmap
[    0.022047]   Normal zone: 278528 pages, LIFO batch:63
[    0.023601]   Normal zone: 16384 pages in unavailable ranges
[    0.023606] Initmem setup node 1 [mem 0x0000000140000000-0x000000023fffffff]
[    0.023608] On node 1 totalpages: 1032192
[    0.023609]   Normal zone: 16384 pages used for memmap
[    0.023609]   Normal zone: 1032192 pages, LIFO batch:63
[    0.029267]   Normal zone: 16384 pages in unavailable ranges


In this setup, one node ends in the middle of a section (+64MB), the
other one starts in the middle of the same section (+64MB).

After your patch, the nodes overlap (in one section)

I can spot that each node still has the same number of present pages and
that each node now has exactly 64MB unavailable pages (the extra ones spanned).


So at least here, it looks like the machinery is still doing the right thing?


-- 
Thanks,

David / dhildenb

