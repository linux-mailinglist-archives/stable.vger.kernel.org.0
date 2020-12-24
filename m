Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 815102E28A3
	for <lists+stable@lfdr.de>; Thu, 24 Dec 2020 19:51:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728679AbgLXSvV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Dec 2020 13:51:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24669 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727778AbgLXSvV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Dec 2020 13:51:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608835793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fvln02DZKfguoku+F6M7BJCoV9697cOmd+bRgSlt6FU=;
        b=SMsq0mXHxnbnKb+tyyrHSDlZnaOD7HtePPdOPBEA0QEL7L9cJoXkYuXRuUXqiBjzIs+Nz7
        Zh2DU0zJhalLjLH9ILh4WgkHrbv79F7Z08MFrVVzqJyCjf2ivENa14twl30lb8g5c+yRc9
        PEBVqPCYLYGq6HIolEztioHn7+VWDOQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-576-4WCLwe2KOjyqoyrNmZmgWA-1; Thu, 24 Dec 2020 13:49:52 -0500
X-MC-Unique: 4WCLwe2KOjyqoyrNmZmgWA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 195E0801817;
        Thu, 24 Dec 2020 18:49:50 +0000 (UTC)
Received: from mail (ovpn-112-5.rdu2.redhat.com [10.10.112.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 37F8160C15;
        Thu, 24 Dec 2020 18:49:46 +0000 (UTC)
Date:   Thu, 24 Dec 2020 13:49:45 -0500
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Yu Zhao <yuzhao@google.com>, Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Xu <peterx@redhat.com>, linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
Message-ID: <X+TiyehLLKEUO7Bs@redhat.com>
References: <X+PE38s2Egq4nzKv@google.com>
 <C332B03D-30B1-4C9C-99C2-E76988BFC4A1@amacapital.net>
 <X+P2OnR+ipY8d2qL@redhat.com>
 <3A6A1049-24C6-4B2D-8C59-21B549F742B4@gmail.com>
 <X+QMKC7jPEeThjB1@google.com>
 <X+QShVIUbYKAsc35@redhat.com>
 <06DF7858-1447-4531-9B5C-E20C44F0AF54@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06DF7858-1447-4531-9B5C-E20C44F0AF54@gmail.com>
User-Agent: Mutt/2.0.3 (2020-12-04)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 23, 2020 at 09:18:09PM -0800, Nadav Amit wrote:
> I am not trying to be argumentative, and I did not think through about an
> alternative solution. It sounds to me that your proposed solution is correct
> and would probably be eventually (slightly) more efficient than anything
> that I can propose.

On a side note, on the last proposed solution, I've been wondering
about the memory ordering mm_tlb_flush_pending.

There's plenty of locking before the point where the actual data is
read, but it's not a release/acquire full barrier (or more accurately
it is only on x86), so smp_rmb() seems needed before cow_user_page to
be sure no data can be read before we read the value of
mm_tlb_flush_pending.

To avoid an explicit smp_rmb() and to inherit the implicit smp_mb()
from the release/acquire of PT unlock/PT lock, we'd need to put the
flush before the previous PT unlock. (note, not after the next PT lock
or it'd be even worse).

So this made me look also the inc/dec:

+	smp_mb__before_atomic();
	atomic_dec(&mm->tlb_flush_pending);

Without the above, can't the CPU decrement the tlb_flush_pending while
the IPI to ack didn't arrive yet in csd_lock_wait?

The smp_rmb() is still needed in the page fault (implicit or explicit
doesn't matter), but we also need a smp_mb__before_atomic() above to
really make this work.

> Yet, I do want to explain my position. Reasoning on TLB flushes is hard, as
> this long thread shows. The question is whether it has to be so hard. In
> theory, we can only think about architectural considerations - whether a PTE
> permissions are promoted/demoted and whether the PTE was changed/cleared.
> 
> Obviously, it is more complex than that. Yet, once you add into the equation
> various parameters such as the VMA flags or whether a page is locked (which
> Mel told me was once a consideration), things become much more complicated.
> If all the logic of TLB flushes had been concentrated in a single point and
> maintenance of this code did not require thought about users and use-cases,
> I think things would have been much simpler, at least for me.

In your previous email you also suggested to add range invalidates and
bloom filter to index them by the address in the page fault since it'd
help MADV_PAGEOUT. That would increase complexity and it won't go
exactly in the above direction.

I assume that here nobody wants to add gratuitous complexity, and I
never suggested the code shouldn't become simpler and easier to
understand and maintain. But we can't solve everything in a single
thread in terms of cleaning up and auditing the entirety of the TLB
code.

To refocus: the only short term objective in this thread, is to fix
the data corruption in uffd-wp and clear_refs_write without
introducing new performance regressions compared to the previous
clear_refs_write runtime.

Once that is fixed and we didn't introduce a performance regression
while fixing an userland memory corruption regression (i.e. not really
a regression in theory, but in practice it is because it worked by
luck), then we can look at all the rest without hurry.

So if already want to start the cleanups like I mentioned in a
previous email, and I'll say it more explicitly, the tlb gather is for
freeing memory, it's just pure overhead and gives a false sense of
security, like it can make any difference, when just changing
protection with mmap_read_lock. It wouldn't be needed with the write
lock and it can't help solve the races that trigger with
mmap_read_lock either.

It is needed when you have to store the page pointer outside the pte,
clear a pte, flush the tlb and only then put_page. So it is needed to
keep tracks of which pages got cleared in the ptes so you don't have
to issue a tlb flush for each single pte that gets cleared.

So the only case when to use the tlb_gather is when you must make the
pte stop pointing to the page and you need an external storage that
will keep track of those pages that we cannot yet lose track of since
we didn't do put_page yet. That kind of external storage to keep track
of the pages that have pending tlb flushes, is never needed in
change_protection and clear_refs_write.

change_protection is already correct in that respect, it doesn't use
the tlb_gather. clear_refs_write is not ok and it need to stop using
tlb_gather_mmu/tlb_finish_mmu.

* tlb_gather_mmu - initialize an mmu_gather structure for page-table tear-down

See also the tear-down mention which doesn't apply to clear_refs_write.

clear_refs_write needs to become identical to
change_protection_range. Just increasing inc_tlb_flush_pending and
then doing a flush of the range right before the
dec_tlb_flush_pending.

That change is actually orthogonal to the regression fix to teach the
COW to deal with stale TLB entries and it will clean up the code.

So to pursue your simplification objective you could already go ahead
doing this improvement since it's very confusing to see the
clear_refs_write use something that it shouldn't use like if it
actually could make any difference and then seeing an incremental
patch trying to perfect the tlb_gather logic in clear_refs instead of
removing it. In fact it's so strange that it's hard to suggest
dropping tlb_gather entirely, I feel like I must be missing
something, so if I miss something this would be a good time to explain
me why tlb_gather is used in clear_refs.

Once that is also done, we can look at the flush_tlb_batched_pending
that I see you mentioned to Yu. I didn't go check it yet, but we can
certainly look at it deeper later, maybe starting a new thread for
it is simpler?

In the short term, for this thread, we can't solve everything at once
and reduce the complexity at the same time.

So refocusing on the memory ordering of dec_tlb_flush_pending and the
mm_tlb_flush_pending mentioned above, to find a proper abstraction and
write proper documentation for the flush in wp_copy_page would be
ideal. Then we can do the rest.

On my to-list before worrying about the rest in fact I also need to
re-send (I already proposed it for merging a few times on lkml) of the
ARM64 tlb flushing optimization to skip the hardware SMP un-scalable
ITLB broadcast for single threaded processes or multithreaded
processes that are temporarily running single threaded or bind to a
single CPU, which increases SMP scalability of the arm64 TLB flushing
by an order of magnitude for some workloads and we had to ship in
production already).

Thanks,
Andrea

