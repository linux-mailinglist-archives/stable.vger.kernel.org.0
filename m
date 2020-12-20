Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E68DF2DF2B9
	for <lists+stable@lfdr.de>; Sun, 20 Dec 2020 03:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgLTCWg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 21:22:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34262 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726788AbgLTCWg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Dec 2020 21:22:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608430868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9zeAQetcjgmSvWdd3NI+EASB0L+QdlqdeWqKzcViEfI=;
        b=gCSiZ/2/3SGnqRYUwbALwxC4VX5uIEpjfngXOrKAWVDEjg6MFC2zFYsH/R21YKK2Ocx5tR
        mxybzF1xIv/A8j7alrREeWhUBM+VgNTDtHFmIx5mnxtbq8I9Js2ryV2YjcmUldPOvvvf66
        hiQZmLyJgQ83vIcvGdkaFo+5dSziAK4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-LM3L3jgIPQifBGX3icIUWg-1; Sat, 19 Dec 2020 21:21:06 -0500
X-MC-Unique: LM3L3jgIPQifBGX3icIUWg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 98C95800D55;
        Sun, 20 Dec 2020 02:21:04 +0000 (UTC)
Received: from mail (ovpn-119-164.rdu2.redhat.com [10.10.119.164])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 63DE960BE2;
        Sun, 20 Dec 2020 02:21:00 +0000 (UTC)
Date:   Sat, 19 Dec 2020 21:20:59 -0500
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     linux-mm <linux-mm@kvack.org>, Peter Xu <peterx@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable@vger.kernel.org, minchan@kernel.org,
        Andy Lutomirski <luto@kernel.org>, yuzhao@google.com,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
Message-ID: <X961C3heiGSJ5qVL@redhat.com>
References: <20201219043006.2206347-1-namit@vmware.com>
 <X95RRZ3hkebEmmaj@redhat.com>
 <EDC00345-B46E-4396-8379-98E943723809@gmail.com>
 <DD367393-D1B3-4A84-AF92-9C6BAEAB40DC@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DD367393-D1B3-4A84-AF92-9C6BAEAB40DC@gmail.com>
User-Agent: Mutt/2.0.3 (2020-12-04)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 19, 2020 at 02:06:02PM -0800, Nadav Amit wrote:
> > On Dec 19, 2020, at 1:34 PM, Nadav Amit <nadav.amit@gmail.com> wrote:
> > 
> > [ cc’ing some more people who have experience with similar problems ]
> > 
> >> On Dec 19, 2020, at 11:15 AM, Andrea Arcangeli <aarcange@redhat.com> wrote:
> >> 
> >> Hello,
> >> 
> >> On Fri, Dec 18, 2020 at 08:30:06PM -0800, Nadav Amit wrote:
> >>> Analyzing this problem indicates that there is a real bug since
> >>> mmap_lock is only taken for read in mwriteprotect_range(). This might
> >> 
> >> Never having to take the mmap_sem for writing, and in turn never
> >> blocking, in order to modify the pagetables is quite an important
> >> feature in uffd that justifies uffd instead of mprotect. It's not the
> >> most important reason to use uffd, but it'd be nice if that guarantee
> >> would remain also for the UFFDIO_WRITEPROTECT API, not only for the
> >> other pgtable manipulations.
> >> 
> >>> Consider the following scenario with 3 CPUs (cpu2 is not shown):
> >>> 
> >>> cpu0				cpu1
> >>> ----				----
> >>> userfaultfd_writeprotect()
> >>> [ write-protecting ]
> >>> mwriteprotect_range()
> >>> mmap_read_lock()
> >>> change_protection()
> >>> change_protection_range()
> >>>  ...
> >>>  change_pte_range()
> >>>  [ defer TLB flushes]
> >>> 				userfaultfd_writeprotect()
> >>> 				 mmap_read_lock()
> >>> 				 change_protection()
> >>> 				 [ write-unprotect ]
> >>> 				 ...
> >>> 				  [ unprotect PTE logically ]

Is the uffd selftest failing with upstream or after your kernel
modification that removes the tlb flush from unprotect?

			} else if (uffd_wp_resolve) {
				/*
				 * Leave the write bit to be handled
				 * by PF interrupt handler, then
				 * things like COW could be properly
				 * handled.
				 */
				ptent = pte_clear_uffd_wp(ptent);
			}

Upstraem this will still do pages++, there's a tlb flush before
change_protection can return here, so I'm confused.


> >>> 				...
> >>> 				[ page-fault]
> >>> 				...
> >>> 				wp_page_copy()
> >>> 				[ set new writable page in PTE]
> >> 
> >> Can't we check mm_tlb_flush_pending(vma->vm_mm) if MM_CP_UFFD_WP_ALL
> >> is set and do an explicit (potentially spurious) tlb flush before
> >> write-unprotect?
> > 
> > There is a concrete scenario that I actually encountered and then there is a
> > general problem.
> > 
> > In general, the kernel code assumes that PTEs that are read from the
> > page-tables are coherent across all the TLBs, excluding permission promotion
> > (i.e., the PTE may have higher permissions in the page-tables than those
> > that are cached in the TLBs).
> > 
> > We therefore need to both: (a) protect change_protection_range() from the
> > changes of others who might defer TLB flushes without taking mmap_sem for
> > write (e.g., try_to_unmap_one()); and (b) to protect others (e.g.,
> > page-fault handlers) from concurrent changes of change_protection().
> > 
> > We have already encountered several similar bugs, and debugging such issues
> > s time consuming and these bugs impact is substantial (memory corruption,
> > security). So I think we should only stick to general solutions.
> > 
> > So perhaps your the approach of your proposed solution is feasible, but it
> > would have to be applied all over the place: we will need to add a check for
> > mm_tlb_flush_pending() and conditionally flush the TLB in every case in
> > which PTEs are read and there might be an assumption that the
> > access-permission reflect what the TLBs hold. This includes page-fault
> > handlers, but also NUMA migration code in change_protection(), softdirty
> > cleanup in clear_refs_write() and maybe others.
> > 
> > [ I have in mind another solution, such as keeping in each page-table a 
> > “table-generation” which is the mm-generation at the time of the change,
> > and only flush if “table-generation”==“mm-generation”, but it requires
> > some thought on how to avoid adding new memory barriers. ]
> > 
> > IOW: I think the change that you suggest is insufficient, and a proper
> > solution is too intrusive for “stable".
> > 
> > As for performance, I can add another patch later to remove the TLB flush
> > that is unnecessarily performed during change_protection_range() that does
> > permission promotion. I know that your concern is about the “protect” case

You may want to check flush_tlb_fix_spurious_fault for other archs
before proceeding with your patch later, assuming it wasn't already applied.

> > but I cannot think of a good immediate solution that avoids taking mmap_lock
> > for write.
> > 
> > Thoughts?
> 
> On a second thought (i.e., I don’t know what I was thinking), doing so —
> checking mm_tlb_flush_pending() on every PTE read which is potentially

Note the part "if MM_CP_UFFD_WP_ALL is set" and probably just
MM_CP_UFFD_WP.

> dangerous and flushing if needed - can lead to huge amount of TLB flushes
> and shootodowns as the counter might be elevated for considerable amount of
> time.
> 
> So this solution seems to me as a no-go.

I don't share your concern. What matters is the PT lock, so it
wouldn't be one per pte, but a least an order 9 higher, but let's
assume one flush per pte.

It's either huge mapping and then it's likely running without other
tlb flushing in background (postcopy snapshotting), or it's a granular
protect with distributed shared memory in which case the number of
changd ptes or huge_pmds tends to be always 1 anyway. So it doesn't
matter if it's deferred.

I agree it may require a larger tlb flush review not just mprotect
though, but it didn't sound particularly complex. Note the
UFFDIO_WRITEPROTECT is still relatively recent so backports won't
risk to reject so heavy as to require a band-aid.

My second thought is, I don't see exactly the bug and it's not clear
if it's upstream reproducing this, but assuming this happens on
upstream, even ignoring everything else happening in the tlb flush
code, this sounds like purely introduced by userfaultfd_writeprotect()
vs userfaultfd_writeprotect() (since it's the only place changing
protection with mmap_sem for reading and note we already unmap and
flush tlb with mmap_sem for reading in MADV_DONTNEED/MADV_FREE clears
the dirty bit etc..). Flushing tlbs with mmap_sem for reading is
nothing new, the only new thing is the flush after wrprotect.

So instead of altering any tlb flush code, would it be possible to
just stick to mmap_lock for reading and then serialize
userfaultfd_writeprotect() against itself with an additional
mm->mmap_wprotect_lock mutex? That'd be a very local change to
userfaultfd too.

Can you look if the rule mmap_sem for reading plus a new
mm->mmap_wprotect_lock mutex or the mmap_sem for writing, whenever
wrprotecting ptes, is enough to comply with the current tlb flushing
code, so not to require any change non local to uffd (modulo the
additional mutex).

Thanks,
Andrea

