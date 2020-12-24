Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FEB92E2320
	for <lists+stable@lfdr.de>; Thu, 24 Dec 2020 02:03:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726288AbgLXBCx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 20:02:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57821 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728341AbgLXBCx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Dec 2020 20:02:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608771686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eI3Bxq/JiaSESgMV6GfKzjBYUhMi1HltJIE2bnAQBfI=;
        b=bvM56Y10SkKdj0HjhHO9iqeWweGtjXSyLfwbxszyVlhcDZdAGQVKNiHrSG/ynLtPjOZXAG
        gT/CgrHtbLrMcUO44hYnIx0V76OO/pqYI8pm39R29ud48jr26rP1A8PE6UZPaWjrASPbns
        0+z7yHuc8ro4plNUkNn9h1IOsb25unA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-480-kxWMbL_XPLWjdYE1MsuroA-1; Wed, 23 Dec 2020 20:01:22 -0500
X-MC-Unique: kxWMbL_XPLWjdYE1MsuroA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C9C0A1005504;
        Thu, 24 Dec 2020 01:01:20 +0000 (UTC)
Received: from mail (ovpn-112-5.rdu2.redhat.com [10.10.112.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A961860C04;
        Thu, 24 Dec 2020 01:01:16 +0000 (UTC)
Date:   Wed, 23 Dec 2020 20:01:16 -0500
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Yu Zhao <yuzhao@google.com>, Andy Lutomirski <luto@kernel.org>,
        Peter Xu <peterx@redhat.com>,
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
Message-ID: <X+PoXCizo392PBX7@redhat.com>
References: <CAHk-=wh-bG4thjXUekLtrCg8FRrdWjtT40ibXXLSm_hzQG8eOw@mail.gmail.com>
 <CALCETrV=8tY7h=aaudWBEn-MJnNkm2wz5qjH49SYqwkjYTpOaA@mail.gmail.com>
 <X+JJqK91plkBVisG@redhat.com>
 <X+JhwVX3s5mU9ZNx@google.com>
 <X+Js/dFbC5P7C3oO@redhat.com>
 <X+KDwu1PRQ93E2LK@google.com>
 <X+Kxy3oBMSLz8Eaq@redhat.com>
 <X+K7JMrTEC9SpVIB@google.com>
 <X+O49HrcK1fBDk0Q@redhat.com>
 <CAHk-=whPCKbhw7+XGBgJ0bM-5QShV90T_yqy2DWp-uPPReTOrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whPCKbhw7+XGBgJ0bM-5QShV90T_yqy2DWp-uPPReTOrw@mail.gmail.com>
User-Agent: Mutt/2.0.3 (2020-12-04)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Linus,

On Wed, Dec 23, 2020 at 03:39:53PM -0800, Linus Torvalds wrote:
> On Wed, Dec 23, 2020 at 1:39 PM Andrea Arcangeli <aarcange@redhat.com> wrote:
> >
> > On Tue, Dec 22, 2020 at 08:36:04PM -0700, Yu Zhao wrote:
> > > Thanks for the details.
> >
> > I hope we can find a way put the page_mapcount back where there's a
> > page_count right now.
> 
> I really don't think that's ever going to happen - at least if you're
> talking about do_wp_page().

Yes, I was referring to do_wp_page().

> I refuse to make the *simple* core operations VM have to jump through
> hoops, and the old COW mapcount logic was that. I *much* prefer the
> newer COW code, because the rules are more straightforward.

Agreed. I don't have any practical alternative proposal in fact, it
was only an hypothetical wish/hope, echoing Hugh's view on this
matter.

> > page_count is far from optimal, but it is a feature it finally allowed
> > us to notice that various code (clear_refs_write included apparently
> > even after the fix) leaves stale too permissive TLB entries when it
> > shouldn't.
> 
> I absolutely agree that page_count isn't exactly optimal, but
> "mapcount" is just so much worse.

Agreed. The "isn't exactly optimal" part is the only explanation for
wish/hope.

> page_count() is at least _logical_, and has a very clear meaning:
> "this page has other users". mapcount() means something else, and is
> simply not sufficient or relevant wrt COW.
>
> That doesn't mean that page_mapcount() is wrong - it's just that it's
> wrong for COW. page_mapcount() is great for rmap, so that we can see
> when we need to shoot down a memory mapping of a page that gets
> released (truncate being the classic example).
> 
> I think that the mapcount games we used to have were horrible. I
> absolutely much prefer where we are now wrt COW.
> 
> The modern rules for COW handling are:
> 
>  - if we got a COW fault there might be another user, we copy (and
> this is where the page count makes so much logical sense).
> 
>  - if somebody needs to pin the page in the VM, we either make sure
> that it is pre-COWed and we
> 
>    (a) either never turn it back into a COW page (ie the fork()-time
> stuff we have for pinned pages)
> 
>    (b) or there is some explicit marker on the page or in the page
> table (ie the userfaultfd_pte_wp thing).
> 
> those are _so_ much more straightforward than the very complex rules
> we used to have that were actively buggy, in addition to requiring the
> page lock. So they were buggy and slow.

Agreed, this is a very solid solution that solves the problem the
mapcount had with GUP pins.

The only alternative but very vapourware thought I had on this matter,
is that all troubles start when we let a GUP-pinned page be unmapped
from the pgtables.

I already told Jens, is io_uring could use mmu notifier already (that
would make any io_uring GUP pin not count anymore with regard to
page_mapcount vs page_count difference) and vmsplice also needs some
handling or maybe become privileged.

The above two improvements are orthogonal with the COW issue since
long term GUP pins do more than just mlock and they break most
advanced VM features. It's not ok just to account GUP pins in rlimit
mlock.

The above two improvements however would go into the direction to make
mapcount more suitable for COW, but it'd still not be enough.

The transient GUP pins also would need to be taken care of, but we
could wait for those to be released, since those are guaranteed to be
released or something else, not just munmap()/MADV_DONTNEED, will
remain in D state.

Anyway.. until io_uring and vmsplice are solved first, it's pointless
to even wonder about transient GUP pins.

> And yes, I had forgotten about that userfaultfd_pte_wp() because I was
> being myopic and only looking at wp_page_copy(). So using that as a
> way to make sure that a page doesn't go through COW is a good way to
> avoid the COW race, but I think that thing requires a bit in the page
> table which might be a problem on some architectures?

Correct, it requires a bit in the pgtable.

The bit is required in order to disambiguate which regions have been
marked for wrprotect faults and which didn't.

A practical example would be: fork() called by an app with a very
large vma with VM_UFFD_WP set.

There would be a storm of WP userfaults if we didn't have the software
bit to detect exactly which pte were wrprotected by uffd-wp and which
ones were wrprotected by fork.

That bit then sends the COW fault to a safe place if wrprotect is
running (the problem is we didn't see the un-wrprotect would clear the
bit while the TLB flush of the wrprotect could be still pending).

The page_mapcount I guess hidden that race to begin with, just like it
did in clear_refs_write.

uffd-wp is similar to soft dirty: it won't work well without a pgtable
software bit. The software bit, to avoid storms of false positives
during memory pressure, also survives swapin/swapout, again like soft
dirty.

The bit requirement is handled through a per-arch option
arch/x86/Kconfig similarly to soft dirty.

        select HAVE_ARCH_USERFAULTFD_WP         if X86_64 && USERFAULTFD

From an high level, the extra bit in the pte/hugepmd could be seen as
holding the information that would be generated by split_vma()
followed by clearing VM_WRITE in the middle vma. Setting that bit
results in a cheaper runtime than allocating 2 more vmas with the
associated locking and rbtree size increase, but same accuracy.

Thanks,
Andrea

