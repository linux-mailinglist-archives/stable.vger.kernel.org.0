Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 912D3319CCC
	for <lists+stable@lfdr.de>; Fri, 12 Feb 2021 11:45:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbhBLKoK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Feb 2021 05:44:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20410 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230268AbhBLKn4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Feb 2021 05:43:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613126548;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6ZntO9QgNpavvwp9VvBrnPMHVLypPqNlK4JlwHmPtXM=;
        b=MAa3q//qK0fiTLdLyFiYs5Q+jcZHcFViSlKD+98N4MOf5hdF8yoMuxg7rGtLHrWc7S0DxJ
        yKwhYDYi/QJuBh18IPhMg9q6KFs5bzlzZdB5WbTm7WadGdq1YAWiz0jDQ1ZUVdMB5eIzBk
        zMMQSLVeY97Plx3ROsjigj4xGZ0SMCc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-548-RTEL0pWVP2Gk_MdZynMuhQ-1; Fri, 12 Feb 2021 05:42:24 -0500
X-MC-Unique: RTEL0pWVP2Gk_MdZynMuhQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F37A3427C3;
        Fri, 12 Feb 2021 10:42:20 +0000 (UTC)
Received: from [10.36.114.178] (ovpn-114-178.ams2.redhat.com [10.36.114.178])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C27637047A;
        Fri, 12 Feb 2021 10:42:16 +0000 (UTC)
To:     Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Baoquan He <bhe@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?UTF-8?Q?=c5=81ukasz_Majczak?= <lma@semihalf.com>,
        Mel Gorman <mgorman@suse.de>,
        Mike Rapoport <rppt@linux.ibm.com>, Qian Cai <cai@lca.pw>,
        "Sarvela, Tomi P" <tomi.p.sarvela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org, x86@kernel.org
References: <20210208110820.6269-1-rppt@kernel.org>
 <YCZZeAAC8VOCPhpU@dhcp22.suse.cz>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Subject: Re: [PATCH v5 1/1] mm: refactor initialization of struct page for
 holes in memory layout
Message-ID: <e5ce315f-64f7-75e3-b587-ad0062d5902c@redhat.com>
Date:   Fri, 12 Feb 2021 11:42:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <YCZZeAAC8VOCPhpU@dhcp22.suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12.02.21 11:33, Michal Hocko wrote:
> On Mon 08-02-21 13:08:20, Mike Rapoport wrote:
>> From: Mike Rapoport <rppt@linux.ibm.com>
>>
>> There could be struct pages that are not backed by actual physical memory.
>> This can happen when the actual memory bank is not a multiple of
>> SECTION_SIZE or when an architecture does not register memory holes
>> reserved by the firmware as memblock.memory.
>>
>> Such pages are currently initialized using init_unavailable_mem() function
>> that iterates through PFNs in holes in memblock.memory and if there is a
>> struct page corresponding to a PFN, the fields of this page are set to
>> default values and it is marked as Reserved.
>>
>> init_unavailable_mem() does not take into account zone and node the page
>> belongs to and sets both zone and node links in struct page to zero.
> 
> IIUC the zone should be associated based on the pfn and architecture
> constraines on zones. Node is then guessed based on the last existing
> range, right?
> 
>> On a system that has firmware reserved holes in a zone above ZONE_DMA, for
>> instance in a configuration below:
>>
>> 	# grep -A1 E820 /proc/iomem
>> 	7a17b000-7a216fff : Unknown E820 type
>> 	7a217000-7bffffff : System RAM
> 
> I like the description here though. Thanks very useful.
> 
>> unset zone link in struct page will trigger
>>
>> 	VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);
> 
> I guess you mean set_pfnblock_flags_mask, right? Is this bug on really
> needed? Maybe we just need to skip over reserved pages?
> 
>> because there are pages in both ZONE_DMA32 and ZONE_DMA (unset zone link
>> in struct page) in the same pageblock.
>>
>> Moreover, it is possible that the lowest node and zone start is not aligned
>> to the section boundarie, for example on x86:
>>
>> [    0.078898] Zone ranges:
>> [    0.078899]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
>> ...
>> [    0.078910] Early memory node ranges
>> [    0.078912]   node   0: [mem 0x0000000000001000-0x000000000009cfff]
>> [    0.078913]   node   0: [mem 0x0000000000100000-0x000000003fffffff]
>>
>> and thus with SPARSEMEM memory model the beginning of the memory map will
>> have struct pages that are not spanned by any node and zone.
>>
>> Update detection of node boundaries in get_pfn_range_for_nid() so that the
>> node range will be expanded to cover memory map section. Since zone spans
>> are derived from the node span, there always will be a zone that covers the
>> part of the memory map with unavailable pages.
>>
>> Interleave initialization of the unavailable pages with the normal
>> initialization of memory map, so that zone and node information will be
>> properly set on struct pages that are not backed by the actual memory.
> 
> I have to digest this but my first impression is that this is more heavy
> weight than it needs to. Pfn walkers should normally obey node range at
> least. The first pfn is usually excluded but I haven't seen real

We've seen examples where this is not sufficient. Simple example:

Have your physical memory end within a memory section. Easy via QEMU, 
just do a "-m 4000M". The remaining part of the last section has 
fake/wrong node/zone info.

Hotplug memory. The node/zone gets resized such that PFN walkers might 
stumble over it.

The basic idea is to make sure that any initialized/"online" pfn belongs 
to exactly one node/zone and that the node/zone spans that PFN.

> problems with that. The VM_BUG_ON blowing up is really bad but as said
> above we can simply make it less offensive in presence of reserved pages
> as those shouldn't reach that path AFAICS normally.

Andrea tried tried working around if via PG_reserved pages and it 
resulted in quite some ugly code. Andrea also noted that we cannot rely 
on any random page walker to do the right think when it comes to messed 
up node/zone info.

-- 
Thanks,

David / dhildenb

