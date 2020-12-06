Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09F192D06EA
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 20:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbgLFTbt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 14:31:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34949 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727135AbgLFTbt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Dec 2020 14:31:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607283022;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pbSdJYttwFuWfBw/mUTLBlKAAj9+lnMr03kmIdRNGXM=;
        b=hmYIQgSPRwQoyAVMtMytei9p/9PEMC9RE77faTXrv7gItAy6AwlY9kl+3hTXN4u97f3XdK
        BOEI3B55ZUwAX7/xsD1cx4OcqEapSsVrw+I/ap4M+XOUJUpuqxdHV2p0/HOJ4zNuiUtYaE
        xX6dMp93wSv1GhoQ0ulRZnlVYFGgbts=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-231-LTBLgYnnMGeP2ECXFQRvAA-1; Sun, 06 Dec 2020 14:30:18 -0500
X-MC-Unique: LTBLgYnnMGeP2ECXFQRvAA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AB13C801ADB;
        Sun,  6 Dec 2020 19:30:16 +0000 (UTC)
Received: from mail (ovpn-112-148.rdu2.redhat.com [10.10.112.148])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8204F5D9C2;
        Sun,  6 Dec 2020 19:30:12 +0000 (UTC)
Date:   Sun, 6 Dec 2020 14:30:11 -0500
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Mike Rapoport <rppt@linux.ibm.com>
Cc:     akpm@linux-foundation.org, bhe@redhat.com, cai@lca.pw,
        david@redhat.com, mgorman@suse.de, mhocko@kernel.org,
        mm-commits@vger.kernel.org, stable@vger.kernel.org, vbabka@suse.cz
Subject: Re: +
 mm-initialize-struct-pages-in-reserved-regions-outside-of-the-zone-ranges.patch
 added to -mm tree
Message-ID: <X80xQ6mvSwJZ0RvC@redhat.com>
References: <20201206005401.qKuAVgOXr%akpm@linux-foundation.org>
 <20201206064849.GW123287@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201206064849.GW123287@linux.ibm.com>
User-Agent: Mutt/2.0.2 (2020-11-20)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 06, 2020 at 08:48:49AM +0200, Mike Rapoport wrote:
> I don't see why we need all this complexity when a simple fixup was
> enough.

Note the memblock bug crashed my systems:

	VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);

Please note how zone_spans_pfn expands:

static inline bool zone_spans_pfn(const struct zone *zone, unsigned long pfn)
{
	return zone->zone_start_pfn <= pfn && pfn < zone_end_pfn(zone);
}

For pfn_to_page(0), the zone_start_pfn is 1 for DMA zone. pfn is 0.

How is the above not going to trigger a false positive once again with
the simple fix?

Not just pfn 0 in fact, any pfn reserved that happens to be the at the
start of each nid.

Doesn't the simple fix reintroduce the same broken invariant that was
meant to be fixed by the patch that required the simple fix or it
won't boot?

> > +	/*
> > +	 * memblock.reserved isn't enforced to overlap with
> > +	 * memblock.memory so initialize the struct pages for
> > +	 * memblock.reserved too in case it wasn't overlapping.
> > +	 *
> > +	 * If any struct page associated with a memblock.reserved
> > +	 * range isn't overlapping with a zone range, it'll be left
> > +	 * uninitialized, ideally with PagePoison, and it'll be a more
> > +	 * easily detectable error.
> > +	 */
> > +	for_each_res_pfn_range(i, nid, &start_pfn, &end_pfn, NULL) {
> > +		start_pfn = clamp(start_pfn, range_start_pfn, range_end_pfn);
> > +		end_pfn = clamp(end_pfn, range_start_pfn, range_end_pfn);
> > +
> > +		if (end_pfn > start_pfn)
> > +			pgcnt += init_unavailable_range(start_pfn, end_pfn,
> > +							zone, nid);
> > +	}
> 
> This means we are going iterate over all memory allocated before
> free_area_ini() from memblock extra time. One time here and another time
> in reserve_bootmem_region().
> And this can be substantial for CMA and alloc_large_system_hash().

The above loops over memory.reserved only.

Now the simple fix also has to loops over some memblock.reserved or it
still wouldn't boot.

You worry about memory.reserved which is bound by RAM.

I worry about holes that aren't bound by RAM.

The simple fix won't just restrict itself to the RAM in
memblock.reserved, it'll also go goes over the holes (that's all it
can do in order to cover memblock.reserved ranges without looking at
it).

The simple fix doesn't only go over pfn 0, it can keep looping from
last page in the previous nid to the first page in the next nid across
regions that weren't even in memblock.reserved and that may be larger
than any memory reserved region.

Reserved regions aren't holes, so the complex fix is more likely to
work stable since unlike the simple fix, it won't waste any CPU over
any non-RAM hole that isn't part of memblock.reserved nor
memblock.memory.

In addition the "static unsigned long hole_start_pfn" of the simple
fix also pushed complexity into the common code caller: it made
memmap_init non thread safe and in addition it required the
memmap_init to be called in paddr physical order or it won't even boot
anymore.

Now maybe it's safe now, but these memmap already gets initialized in
the background during boot, so the moment more than one thread does it
in parallel the simple patch will break because it's non-reentrant.

> > @@ -7126,7 +7155,13 @@ unsigned long __init node_map_pfn_alignm
> >   */
> >  unsigned long __init find_min_pfn_with_active_regions(void)
> >  {
> > -	return PHYS_PFN(memblock_start_of_DRAM());
> > +	/*
> > +	 * reserved regions must be included so that their page
> > +	 * structure can be part of a zone and obtain a valid zoneid
> > +	 * before __SetPageReserved().
> > +	 */
> > +	return min(PHYS_PFN(memblock_start_of_DRAM()),
> > +		   PHYS_PFN(memblock.reserved.regions[0].base));
> 
> So this implies that reserved memory starts before memory. Don't you
> find this weird?

That happens because the current API doesn't require overlap.

	for (i = 0; i < e820_table->nr_entries; i++) {
		struct e820_entry *entry = &e820_table->entries[i];

		end = entry->addr + entry->size;
		if (end != (resource_size_t)end)
			continue;

		if (entry->type == E820_TYPE_SOFT_RESERVED)
			memblock_reserve(entry->addr, entry->size);

		if (entry->type != E820_TYPE_RAM && entry->type != E820_TYPE_RESERVED_KERN)
			continue;

		memblock_add(entry->addr, entry->size);
	}

The above is a more complex way to write the below, which will make it
more clear there's never overlap:

		if (entry->type == E820_TYPE_SOFT_RESERVED)
			memblock_reserve(entry->addr, entry->size);
		else if (entry->type == E820_TYPE_RAM || entry->type == E820_TYPE_RESERVED_KERN)
			memblock_add(entry->addr, entry->size);

If you want to enforce that there is always overlap and in turn a zone
cannot start with a reserved pfn, then you could add a bugcheck if
memblock.reserved doesn't overlap to an already registered
memblock.memory range, and then the above e820 code above will break.

I thought the reason there couldn't be full overlap is the direct
mapping issue so there's a very good reason for it.

So given there's current zero overlap, I'm not exactly sure what's
weird that memblock.reserved starts before memblock.memory. The fact
pfn 0 is reserved is a bios thing, weird or not weird it's not in our
control.

I don't see any alternative on how to give a consistent zoneid to pfn
0, if zoneid 0 still starts at pfn 1 and you're not going to enforce
full overlap between memblock.reserved and memblock.memory either.

One only alternative I can see is to leave PagePoison in there and add
PagePoison or PageReserved checks all over the place starting from
reserve_bootmem_region like this:

void __meminit reserve_bootmem_region(phys_addr_t start, phys_addr_t end)
{
	unsigned long start_pfn = PFN_DOWN(start);
	unsigned long end_pfn = PFN_UP(end);

	for (; start_pfn < end_pfn; start_pfn++) {
		if (pfn_valid(start_pfn)) {
			struct page *page = pfn_to_page(start_pfn);

+			if (PagePoison(page))
+				continue

			init_reserved_page(start_pfn);

The above is still preferable since then we could then add PagePoison
checks all over the VM code like this:

       VM_BUG_ON(!PagePoison(page) && page_to_pfn(page) >= page_zone(page)->zone_start_pfn)

The above PagePoison mention assumes we'd need to extend PagePoison to
DEBUG_VM=n or switch to PageReserved or a NO_NODEID.

The whole point is we don't need to do any of the above since zones
can include all reserved pages too so once the kernel finished
booting, it'll be simpler if we have a valid zoneid so the invariant
bugchecks will pass for all valid pfn and they'll stop crashing
kernels with false positives.

Keeping all complexity in memblock common code and keeping the arch
caller raw is not a bad thing since memblock is common code and it'll
benefit all archs. I wouldn't go in the direction of
124049decbb121ec32742c94fb5d9d6bed8f24d8 once again.

Thanks,
Andrea

