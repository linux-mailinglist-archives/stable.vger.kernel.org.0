Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88D592D36C9
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 00:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731698AbgLHXP3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Dec 2020 18:15:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56048 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731697AbgLHXP0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Dec 2020 18:15:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607469238;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vZuEjie3C0diipEeely/p+lvmS/tS18fOM2YkdXhaZE=;
        b=EGKwmED0MAieMebNTEywkMbdAVKIzAFUhLHs9OBYXOJYlpR/QE3lr3dx1QL/dzc7syDQgF
        DVJhMelRjx2AIHTUpYTl4PNvZWND7CfWstI3yUkOlLRVVwIfD6E/djPHWFTDuygVuPp/C6
        v3GvHjdl22NMr8995yEJgfRUMAhdYOg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-173-ET9dVJ6gMMGwfdaSRkBYyQ-1; Tue, 08 Dec 2020 18:13:54 -0500
X-MC-Unique: ET9dVJ6gMMGwfdaSRkBYyQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0183580EF80;
        Tue,  8 Dec 2020 23:13:53 +0000 (UTC)
Received: from mail (ovpn-119-164.rdu2.redhat.com [10.10.119.164])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7611C5C1BB;
        Tue,  8 Dec 2020 23:13:48 +0000 (UTC)
Date:   Tue, 8 Dec 2020 18:13:47 -0500
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Mike Rapoport <rppt@linux.ibm.com>
Cc:     akpm@linux-foundation.org, bhe@redhat.com, cai@lca.pw,
        david@redhat.com, mgorman@suse.de, mhocko@kernel.org,
        mm-commits@vger.kernel.org, stable@vger.kernel.org, vbabka@suse.cz
Subject: Re: +
 mm-initialize-struct-pages-in-reserved-regions-outside-of-the-zone-ranges.patch
 added to -mm tree
Message-ID: <X9AIq3bwYXtrpFvx@redhat.com>
References: <20201206005401.qKuAVgOXr%akpm@linux-foundation.org>
 <20201206064849.GW123287@linux.ibm.com>
 <X80xQ6mvSwJZ0RvC@redhat.com>
 <20201207165037.GH1112728@linux.ibm.com>
 <X87rodZBmvJCyjBi@redhat.com>
 <20201208214614.GD1164013@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201208214614.GD1164013@linux.ibm.com>
User-Agent: Mutt/2.0.2 (2020-11-20)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 08, 2020 at 11:46:14PM +0200, Mike Rapoport wrote:
> On Mon, Dec 07, 2020 at 09:57:37PM -0500, Andrea Arcangeli wrote:
> > On Mon, Dec 07, 2020 at 06:50:37PM +0200, Mike Rapoport wrote:
> > > On Sun, Dec 06, 2020 at 02:30:11PM -0500, Andrea Arcangeli wrote:
> > > > On Sun, Dec 06, 2020 at 08:48:49AM +0200, Mike Rapoport wrote:
> > > > > I don't see why we need all this complexity when a simple fixup was
> > > > > enough.
> > > > 
> > > > Note the memblock bug crashed my systems:
> > > > 
> > > > 	VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);
> > > > 
> > > > Please note how zone_spans_pfn expands:
> > > > 
> > > > static inline bool zone_spans_pfn(const struct zone *zone, unsigned long pfn)
> > > > {
> > > > 	return zone->zone_start_pfn <= pfn && pfn < zone_end_pfn(zone);
> > > > }
> > > > 
> > > > For pfn_to_page(0), the zone_start_pfn is 1 for DMA zone. pfn is 0.
> > > 
> > > I don't know why you keep calling it "memblock bug" as pfn 0 was not
> > > part of DMA zone at least for ten years.
> > > 
> > > If you backport this VM_BUG_ON_PAGE() to 2.6.36 that has no memblock on
> > > x86 it will happily trigger there.
> > 
> > I guess it wasn't considered a bug until your patch that was meant to
> > enforce this invariant for all pfn_valid was merged in -mm?
> 
> What was not considered a bug? That node 0 and DMA zone on x86 started
> at pfn 1 and pfn 0 zone/node links were set by chance to the right
> values?

Well, I don't think zoneid 0 is the "right value" for the pfn 0 since zoneid
0 DMA start from pfn 1.

Now if you rephrase the above with "were set to the wrong values",
then the answer is yes.

> There was no intention to engfoce any invariant of overlaping or not
> ovelapping ranges in memblock.memory and memblock.reserved.
> 
> The change in 73a6e474cb376921a311786652782155eac2fdf0 was to change the
> loop over all pfns in a zone that among other things checked if that pfn
> is in memblock.memory to a loop over intersection of pfns in a
> zone with memblock.memory.
> 
> This exposed that before 73a6e474cb376921a311786652782155eac2fdf0:
> * small holes, like your "7a17b000-7a216fff : Unknown E820 type" get
> their zone/node links right because of an optimizaiton in
> __early_pfn_to_nid() that didn't check if a pfn is in memblock.memory
> for every pfn but rather cached the results.
> * on x86 pfn 0 was neither in node 0 nor in DMA zone because they both
> started with pfn 1; it got zone/node links set to 0 because that's what
> init_unavailable_range() did for all pfns in "unavailable ranges".
> 
> So, if you add something like this
> 
> static int check_pfn0(void)
> {
> 	unsigned long pfn = 0;
> 	struct page *page = pfn_to_page(pfn);
> 
> 	VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);
> 
> 	return 0;
> }
> late_initcall(check_pfn0);
> 
> to an older kernel, this will blow up.

Some older kernel wouldn't fail just at pfn 0. In v5.8/9 the above
bugcheck crashes on pfn > 0.

In all versions before your
https://lore.kernel.org/lkml/20201201181502.2340-1-rppt@kernel.org ,
worrying at pfn 0 and the first reserved pfn in each nid would be just
window dressing.

Now the moment you apply
https://lore.kernel.org/lkml/20201201181502.2340-1-rppt@kernel.org
then pfn 0 and all other pfn at the start of each nid that still break
the above bugcheck invariant, gets the focus because they're thing
still breaking the above bugcheck, the very bugcheck crashing v5.8/9.

> 
> So, my guess is that we've never got to this check for pfn 0 and I
> really don't know how your system crashed with both my patches applied,
> unless you had a patch that checked pfn 0.

I thought I already mentioned it's the __SetPageReserved that checks
PagePoison and the __SetPageReserved is issued on all struct page in
memblock.reserved ranges.

You're calling __SetPageReserved on each one of the reserved pages. If
you didn't go over each one of the struct page to initialize them and
__SetPageReserved them, then
https://lore.kernel.org/lkml/20201201181502.2340-1-rppt@kernel.org
would be capable of booting without the simple fix too.

https://lore.kernel.org/lkml/20201201181502.2340-1-rppt@kernel.org is
correctly failing boot, because what was missing was a proper zoneid
initialization that would wipe the PagePoison away, on all
memblock.reserved ranges that aren't overlapping on memblock.memory
ranges, which is precisely what the complex patch does.

> > > The problem, as I see it, in, hmm, questionable semantics for
> > > !E820_TYPE_RAM ranges on x86.
> > > 
> > > I keep asking this simple question again and again and I still have no
> > > clear "yes" or "no" answer:
> > > 
> > > 	Is PFN 0 on x86 memory?
> > 
> > The pfn is the same regardless if it's RAM or non RAM, so I don't
> > think it makes any difference in this respect if it's RAM or not.
> > 
> > > Let's step back for a second and instead of blaming memblock in lack of
> > > enforcement for .memory and .reserved to overlap and talking about how
> > > memblock core was not robust enough we'll get to the point where we have
> > > clear defintions of what e820 ranges represent.
> > 
> > I don't see why we should go back into the direction that the caller
> > needs improvement like in commit
> > 124049decbb121ec32742c94fb5d9d6bed8f24d8 and to try to massage the raw
> > e820 data before giving it to the linux common code.
> 
> That's the entire point that the e820 data is massaged before it gets to
> the common code. 124049decbb121ec32742c94fb5d9d6bed8f24d8 tried to alter
> the way the raw e820 was transformed before going to the common code and
> my feeling it was a shot in the dark.
> 
> The current abstraction we have in the common code to describe physical
> memory is memblock and I want to make it explicit that every range in
> e820 table is a part of system memory and hence a part of
> memblock.memory.

What's the advantage of not initializing the struct pages in the
memblock.reserved ranges, if you add all memblock.reserved to
memblock.memory and you still initialize all memblock.memory then?

Isn't the cost of the loop and number of pfn being initialized then
identical to the complex patch then?

What you suggest would require adding extra information to flag which
ranges must not have a direct mapping, but that information is already
in memblock today, for each range in memblock_reserved but not in
memblock.memory or did I misunderstand how that no-direct-map detail works?

I see nothing wrong in adding memblock.reserved to memblock.memory,
but the total information in kernel memory will remain the same, it's
just a different representation that will require more CPU and RAM to
handle, not that it matters. All it matters is what is simpler in the
code and the current version looks simpler. Or do you expect the
version that enforces overlap to reduce the kernel code?

> The purpose here is not to enforce overlap at all times [and it is
> possible despite the direct mapping issues ;-) ].
> The idea is to have the abstract description of the physical memory
> (i.e. memblock) as close as possible to actual layout. The "simple" code
> in e820__memblock_setup() only made things obfuscated and inconsistent.
> 
> If you have memory populated at address 0 you would expect that
> for_each_mem_pfn_range() will start from pfn 0.

Specifically which code do you envision that needs to get RAM pfn in
physical order and cannot call:

for_each_mem_pfn_range(pfn))
	handle(pfn);
for_each_res_pfn_range(pfn))
	handle(pfn);

If you need it in physical order immediately then having
memblock.memory including memblock.reserve would simplify things for
sure, but who needs that when it runs even exactly at the same speed?

> In addition, and implicit call to memblock_add() in memblock_reserve()
> would be a waste of CPU time as most of the times memblock_reserve() is
> called as the part of memory allocation before page allocator is ready.

Well, given such CPU time is so little, I would still spend that CPU
time to do an enforcement and bugcheck and manual call of memblock_add
if any memblock_reserve has no full overlap.

So I'd rather spend the CPU time to do the work itself and not having
to risk kernel-crashing issue if any of the callers got a future patch
done wrong or if the bios maps aren't done fully right after a bios
upgrade.

How much CPU time we're talking about here? Those aren't the
computations on the pfn but on the ranges and there aren't going to be
million of e820 entries.

Even if you envision million of e820 entries, the first thing to do
then to save CPU time in memblock is drop all lists and replace them
with interval trees based on rbtrees, so the complexity of the later
loops that intersect the memblock ranges with the nid-zone ranges,
will go in O(log(N)) where N is in the number of e820 ranges. Leaving
memblock at risk from a buggy e820 caller is not going to save nearly
as much CPU as such data structure computation complexity enhancement
in my view. memblock_add then will also run in O(log(N)).

> Sorry, I was not clear. The penalty here is not the traversal of
> memblock.reserved array. The penalty is for redundant initialization of
> struct page for ranges memblock.reserved describes.

But that's the fix... How can you avoid removing the PagePoison for
all pfn_valid in memblock.reserved, when the crash of
https://lore.kernel.org/lkml/20201201181502.2340-1-rppt@kernel.org is
in __SetPageReserved of reserve_bootmem_region?

> For instance, the if user specified hugetlb_cma=nnG loop over
> memblock.reserved will cause redundant initialization pass over the
> pages in this nnG.

And if that didn't happen, then I'm left wondering if
free_low_memory_core_early would crash again with specified
hugetlb_cma=nnG, not just in pfn 0 anymore even with the simple fix
applied.

Where does PagePoison get removed from the CMA range, or is somehow
__SetPageReserved not called with the simple fix applied on the CMA
reserved range?

The important thing that the simple fix breaks (and get us back to
square one) is that after
https://lore.kernel.org/lkml/20201201181502.2340-1-rppt@kernel.org
we're finally guaranteed each pfn_valid gets either a "right zoneid"
or PagePosion. It is great in that respect and I'd rather not break
such guarantee again with the simple fix that may still not boot with
CMA region reservation and will also return breaking the check_pfn0
bugcheck above.

Could you test your simple fix with DEBUG_VM=y and hugetlb_cma=nnG,
does it boot? While I'm not entirely sure how the simple fix can boot
with DEBUG_VM=y and hugetlb_cma=nnG (I don't rule out it might boot),
I'm pretty confident my complex fix will still boot fine with
hugetlb_cma=nnG.

> Regardless of particular implementation, the generic code cannot detect
> physical memory layout, this is up to architecture to detect what memory
> banks are populated and provide this information to the generic code.
> 
> So we'll always have what you call "dependencies on the caller" here.
> The good thing is that we can fix "the caller" when we find it's wrong.

The caller that massages the e820 bios table, is still
software. Software can go from arch code to common code. There's no
asm or arch dependency in there.

The caller in my view needs to know what e820 is and send down the raw
info... it's a 1:1 API translation, the caller massaging of the data
can all go in the callee and benefit all callers.

Alternatively, if the caller logic doesn't go from arch code to common
code for whatever reason, the common code can still put the caller
logic in the common code and use it to verify the caller did
everything right, fixup if it didn't and warn in the logs about it,
using the same software algo the caller uses to massage the e820 data.

The benefit is once the callee does all validation, then all archs
that do a mistake will be told and boot will not fail and it'll be
more likely to boot stable even in presence of inconsistent hardware
tables.

The whole point of the above is to reduce the chance that we either
have to keep cut-and-pasting N times the same logic in all callers, or
that in the future a subtle change in the arch code or a subtle
difference in the bios tables (kind of precisely what's crashing v5.8
and v5.9) will cause the kernel to boot unstable in a non easily
reproducible way.

Looking the current e820 code it looks it's already expecting all
validation to happen in the callee.

> > I guess before worrying of pfn 1 not being added to memblock.reserved,
> > I'd worry about pfn 0 itself not being added to memblock.reserved.
> 
> My point was that with a bit different e820 table we may again hit a
> corner case that we didn't anticipate.
> 
> pfn 0 is in memblock.reserved by a coincidence and not by design and using
> memblock.reserved to detect zone/node boundaries is not reliable.
>
> Moreover, if you look for usage of for_each_mem_pfn_range() in
> page_alloc.c, it's looks very much that it is presumed to iterate over
> *all* physical memory, including mysterious pfn 0.

All the complex patch does it that it guarantees all the reserved
pages can get a "right" zoneid.

Then we certainly should consider rounding it down by the pageblock in
case pfn 0 isn't reserved.

In fact if you add all memblock.reserved ranges to memblock.memory,
you'll obtain exactly the same result in the zone_start_pfn as with
the complex patch in the zone_start_pfn calculation and the exact same
issue of PagePoison being left on pfn 0 will happen if pfn 0 isn't
added to memblock.memory with { memblock_add; memblock_reserved }.
 
> > Still with the complex patch applied, if something goes wrong
> > DEBUG_VM=y will make it reproducible, with the simple fix we return in
> > non-reproducible land.
> 
> I still think that the complex patch is going in the wrong direction.
> We cannot rely on memblock.reserved to calculate zones and nodes span.
> 
> This:
> 
> +       /*
> +        * reserved regions must be included so that their page
> +        * structure can be part of a zone and obtain a valid zoneid
> +        * before __SetPageReserved().
> +        */
> +       return min(PHYS_PFN(memblock_start_of_DRAM()),
> +                  PHYS_PFN(memblock.reserved.regions[0].base));
> 
> is definitely a hack that worked because "the caller" has this:
> 
> 	/*
> 	 * Make sure page 0 is always reserved because on systems with
> 	 * L1TF its contents can be leaked to user processes.
> 	 */
> 	memblock_reserve(0, PAGE_SIZE);
> 
> So, what would have happen if L1TF was not yet disclosed? ;-)

It's actually fine thing to delete the above memblock_reserve(0,
PAGE_SIZE) for all testing so we can move into the remaining issues.

After deleting the memblock_reserve of pfn 0, the VM_BUG_ON_PAGE will
show PagePoison in page->flags in the bugcheck above, which is
preferable than having a wrong zone id. In addition PagePoison will be
more detectable error than a wrong zone id so it's more likely to
notify us something fundamentally went wrong in memblock.

With simple fix we'll be left wondering once again as it happened
before
https://lore.kernel.org/lkml/20201201181502.2340-1-rppt@kernel.org .

Second, the removal of memblock_reserve(0, PAGE_SIZE) is the right
test to do to verify and exercise the needed round_down to the start
of the pageblock (if there's no adjacent zone preceding it) orthogonal
enhancement that would be needed anyway even if we only looked at
memblock.memory there (again to avoid leaving PagePoison or setting ti
to a zoneid that won't pass the check_pfn0).

The end result of the "hack" is precisely what you obtain if you add
all memblock.reserved to memblock.memory, except it doesn't require to
add memblock.reserved to memblock.memory.

Thanks,
Andrea

