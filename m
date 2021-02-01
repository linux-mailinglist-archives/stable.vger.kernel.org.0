Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6098130A67C
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 12:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbhBAL1x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 06:27:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36400 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230316AbhBAL1w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 06:27:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612178785;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gxLqvpXl3gUUeGQW/1robjY+CzCVzkMk/eTpCkIzHRM=;
        b=i0k/zCyPxr0lOi+OqjxwRzX+6VcZBVMAL08ehWa+E0+Z1jUdhudhXn/2rR0rhwYq3j/tHY
        iNcqKTOHZaFGAtxOxF6DhyEa2VybTNfrnPZLznWYbgEZX54rUkfoK1Bgly2b5bLWf1y9TW
        g+8amF6uHmLaUNYteK/rsf7vJNv472s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-601-r3qRBkhxPiGwKEzbg3uhgQ-1; Mon, 01 Feb 2021 06:26:21 -0500
X-MC-Unique: r3qRBkhxPiGwKEzbg3uhgQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1FDAC107ACF5;
        Mon,  1 Feb 2021 11:26:13 +0000 (UTC)
Received: from localhost (ovpn-12-141.pek2.redhat.com [10.72.12.141])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C9A095C5AE;
        Mon,  1 Feb 2021 11:26:07 +0000 (UTC)
Date:   Mon, 1 Feb 2021 19:26:05 +0800
From:   Baoquan He <bhe@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Mike Rapoport <rppt@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?utf-8?Q?=C5=81ukasz?= Majczak <lma@semihalf.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>, Qian Cai <cai@lca.pw>,
        "Sarvela, Tomi P" <tomi.p.sarvela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v4 1/2] x86/setup: always add the beginning of RAM as
 memblock.memory
Message-ID: <20210201112605.GA2357@MiWiFi-R3L-srv>
References: <20210130221035.4169-1-rppt@kernel.org>
 <20210130221035.4169-2-rppt@kernel.org>
 <56e2c568-b121-8860-a6b0-274ace46d835@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56e2c568-b121-8860-a6b0-274ace46d835@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 02/01/21 at 10:32am, David Hildenbrand wrote:
> On 30.01.21 23:10, Mike Rapoport wrote:
> > From: Mike Rapoport <rppt@linux.ibm.com>
> > 
> > The physical memory on an x86 system starts at address 0, but this is not
> > always reflected in e820 map. For example, the BIOS can have e820 entries
> > like
> > 
> > [    0.000000] BIOS-provided physical RAM map:
> > [    0.000000] BIOS-e820: [mem 0x0000000000001000-0x000000000009ffff] usable
> > 
> > or
> > 
> > [    0.000000] BIOS-provided physical RAM map:
> > [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000000fff] reserved
> > [    0.000000] BIOS-e820: [mem 0x0000000000001000-0x0000000000057fff] usable
> > 
> > In either case, e820__memblock_setup() won't add the range 0x0000 - 0x1000
> > to memblock.memory and later during memory map initialization this range is
> > left outside any zone.
> > 
> > With SPARSEMEM=y there is always a struct page for pfn 0 and this struct
> > page will have it's zone link wrong no matter what value will be set there.
> > 
> > To avoid this inconsistency, add the beginning of RAM to memblock.memory.
> > Limit the added chunk size to match the reserved memory to avoid
> > registering memory that may be used by the firmware but never reserved at
> > e820__memblock_setup() time.
> > 
> > Fixes: bde9cfa3afe4 ("x86/setup: don't remove E820_TYPE_RAM for pfn 0")
> > Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> > Cc: stable@vger.kernel.org
> > ---
> >   arch/x86/kernel/setup.c | 8 ++++++++
> >   1 file changed, 8 insertions(+)
> > 
> > diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> > index 3412c4595efd..67c77ed6eef8 100644
> > --- a/arch/x86/kernel/setup.c
> > +++ b/arch/x86/kernel/setup.c
> > @@ -727,6 +727,14 @@ static void __init trim_low_memory_range(void)
> >   	 * Kconfig help text for X86_RESERVE_LOW.
> >   	 */
> >   	memblock_reserve(0, ALIGN(reserve_low, PAGE_SIZE));
> > +
> > +	/*
> > +	 * Even if the firmware does not report the memory at address 0 as
> > +	 * usable, inform the generic memory management about its existence
> > +	 * to ensure it is a part of ZONE_DMA and the memory map for it is
> > +	 * properly initialized.
> > +	 */
> > +	memblock_add(0, ALIGN(reserve_low, PAGE_SIZE));
> >   }
> >   	
> >   /*
> > 
> 
> I think, to make that code more robust, and to not rely on archs to do the
> right thing, we should do something like
> 
> 1) Make sure in free_area_init() that each PFN with a memmap (i.e., falls
> into a partial present section) is spanned by a zone; that would include PFN
> 0 in this case.
> 
> 2) In init_zone_unavailable_mem(), similar to round_up(max_pfn,
> PAGES_PER_SECTION) handling, consider range
> 	[round_down(min_pfn, PAGES_PER_SECTION), min_pfn - 1]
> which would handle in the x86-64 case [0..0] and, therefore, initialize PFN
> 0.

Sounds reasonable. Maybe we can change to get the real expected lowest
pfn from find_min_pfn_for_node() by iterating memblock.memory and
memblock.reserved and comparing.

> 
> Also, I think the special-case of PFN 0 is analogous to the
> round_up(max_pfn, PAGES_PER_SECTION) handling in
> init_zone_unavailable_mem(): who guarantees that these PFN above the highest
> present PFN are actually spanned by a zone?
> 
> I'd suggest going through all zone ranges in free_area_init() first, dealing
> with zones that have "not section aligned start/end", clamping them up/down
> if required such that no holes within a section are left uncovered by a
> zone.
> 
> -- 
> Thanks,
> 
> David / dhildenb

