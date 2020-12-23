Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2F612E209C
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 19:55:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbgLWSxg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 13:53:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32227 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726384AbgLWSxf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Dec 2020 13:53:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608749528;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nirhQ0v89JBa/obnWzdEB/CYDDTajoqPDYQzAo3/nb0=;
        b=Ydx6lgSQEV6qS2rcataWKKaV1QVy0oZav8AOU3DEuTVfXgOWrOnGsvD5P2C2FO5p5J3wDe
        F/JVRP5zYZGm3BP1YZQrtKCnhnH5oJGeL9rUWdZ+8fUfQ/sjE/m6wPSmPialB0vNxCpttS
        XeBzX/uJB1swS7rJtdkgRhqqM/wpSCU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-tGodstCLPfyySGTuSzpNXw-1; Wed, 23 Dec 2020 13:52:06 -0500
X-MC-Unique: tGodstCLPfyySGTuSzpNXw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 61A9E800D55;
        Wed, 23 Dec 2020 18:52:04 +0000 (UTC)
Received: from mail (ovpn-112-5.rdu2.redhat.com [10.10.112.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E287210013C1;
        Wed, 23 Dec 2020 18:51:59 +0000 (UTC)
Date:   Wed, 23 Dec 2020 13:51:59 -0500
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Yu Zhao <yuzhao@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Nadav Amit <nadav.amit@gmail.com>,
        linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
Message-ID: <X+ORz1CVIhzKvunq@redhat.com>
References: <CALCETrV=8tY7h=aaudWBEn-MJnNkm2wz5qjH49SYqwkjYTpOaA@mail.gmail.com>
 <X+JJqK91plkBVisG@redhat.com>
 <X+JhwVX3s5mU9ZNx@google.com>
 <X+Js/dFbC5P7C3oO@redhat.com>
 <X+KDwu1PRQ93E2LK@google.com>
 <CAHk-=wiBWkgxLtwD7n01irD7hTQzuumtrqCkxxZx=6dbiGKUqQ@mail.gmail.com>
 <CAHk-=wjG7xx7Gsb=K0DteB1SPcKjus02zY2gFUoxMY5mm7tfsA@mail.gmail.com>
 <CAHk-=wjNv1GQn+8stK419HAqK0ofkJ1vOR9YSWSNjbW3T5as9A@mail.gmail.com>
 <X+MWppLjiR7hLgg9@google.com>
 <20201223162416.GD6404@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201223162416.GD6404@xz-x1>
User-Agent: Mutt/2.0.3 (2020-12-04)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 23, 2020 at 11:24:16AM -0500, Peter Xu wrote:
> I think this is not against Linus's example - where cpu2 does not have tlb
> cached so it sees RO while cpu3 does have tlb cached so cpu3 can still modify
> it.  So IMHO there's no problem here.
> 
> But I do think in step 2 here we overlooked _PAGE_UFFD_WP bit.  Note that if
> it's uffd-wp wr-protection it's always applied along with removing of the write
> bit in change_pte_range():
> 
>         if (uffd_wp) {
>                 ptent = pte_wrprotect(ptent);
>                 ptent = pte_mkuffd_wp(ptent);
>         }
> 
> So instead of being handled as COW page do_wp_page() will always trap
> userfaultfd-wp first, hence no chance to race with COW.
> 
> COW could only trigger after another uffd-wp-resolve ioctl which could remove
> the _PAGE_UFFD_WP bit, but with Andrea's theory unprotect will only happen
> after all wr-protect completes, which guarantees that when reaching the COW
> path the tlb must has been flushed anyways.  Then no one should be modifying
> the page anymore even without pgtable lock in COW path.
> 
> So IIUC what Linus proposed on "flushing tlb within pgtable lock" seems to
> work, but it just may cause more tlb flush than Andrea's proposal especially
> when the protection range is large (it's common to have a huge protection range
> for e.g. VM live snapshotting, where we'll protect all guest rw ram).
> 
> My understanding of current issue is that either we can take Andrea's proposal
> (although I think the group rwsem may not be extremely better than a per-mm
> rwsem, which I don't know... at least not worst than that?), or we can also go
> the other way (also as Andrea mentioned) so that when wr-protect:
> 
>   - for <=2M range (pmd or less), we take read rwsem, but flush tlb within
>     pgtable lock
> 
>   - for >2M range, we take write rwsem directly but flush tlb once

I fully agree indeed.

I still have to fully understand how the clear_refs_write was fixed.

clear_refs_write has not even a "catcher" in the page fault but it
clears the pte_write under mmap_read_lock and it doesn't flush before
releasing the PT lock. It appears way more broken than
userfaultfd_writeprotect ever was.

static inline void clear_soft_dirty(struct vm_area_struct *vma,
		unsigned long addr, pte_t *pte)
{
	/*
	 * The soft-dirty tracker uses #PF-s to catch writes
	 * to pages, so write-protect the pte as well. See the
	 * Documentation/admin-guide/mm/soft-dirty.rst for full description
	 * of how soft-dirty works.
	 */

       https://patchwork.kernel.org/project/linux-mm/patch/20201210121110.10094-2-will@kernel.org/

"Although this is fine when simply aging the ptes, in the case of
clearing the "soft-dirty" state we can end up with entries where
pte_write() is false, yet a writable mapping remains in the TLB.

Fix this by avoiding the mmu_gather API altogether: managing both the
'tlb_flush_pending' flag on the 'mm_struct' and explicit TLB
invalidation for the sort-dirty path, much like mprotect() does
already"

NOTE: about the above comment, that mprotect takes
mmap_read_lock. Your above code change in the commit above, still has
mmap_read_lock, there's still no similarity with mprotect whatsoever.

Did you test what happens when clear_refs_write leaves writable stale
TLB and you run do_wp_page copies the page while the other CPU still
is writing to the page? Has clear_refs_write a selftest as aggressive
and racy as the uffd selftest to reproduce that workload?

The race fixed with the group lock internally to uffd, is possible
thanks to marker+catcher in NUMA balancing style? But that's not there
for clear_refs_write even after the above commit.

It doesn't appear either that this patch is adding a synchronous tlb
flush inside the PT lock either.

Overall, it would be unfair if clear_refs_write is allowed to do the
same thing that userfaultfd_writeprotect has to do, but with the
mmap_read_lock, if userfaultfd_writeprotect will be forced to take
mmap_write_lock.

In my view there are 3 official ways to deal with this:

1) set a marker in the pte/hugepmd inside the PT lock, and add a
   catcher for the marker in the page fault to send the page fault to
   a dead end while there are stale TLB entries

   cases: userfaultfd_writeprotect() and NUMA balancing

2) take mmap_write_lock

   case: mprotect

3) flush the TLB before the PT lock release

   case: KSM write_protect_page

Where does the below patch land in the 3 cases? It doesn't fit any of
them and what it does looks still not sufficient to fix the userfault
memory corruption.

     https://patchwork.kernel.org/project/linux-mm/patch/20201210121110.10094-2-will@kernel.org/

It'd be backwards if the complexity of the kernel was increased for
clear_refs_write, but forbidden for the O(1) API that delivers the
exact same information (clear_refs_write API delivers that info in
O(N)).

We went the last mile to guarantee uffd can be always used fully
securely unprivileged and by default in current Linus's tree and in
future Android out of the box. It's simply impossible with the current
defaults, to use uffd to enlarge the any kernel user-after-free race
window either, so even that concern is gone. From on those research
testcases will stick to fuse instead I guess.

Thanks,
Andrea

