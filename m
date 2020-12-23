Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12D982E2251
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 23:07:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbgLWWGz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 17:06:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37073 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726240AbgLWWGy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Dec 2020 17:06:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608761127;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J9PT4G77O+Zst6KgeP/0LAqq9JqEQB90UKtHEK4FMsE=;
        b=h/2rGD0VG9ZHjbdPWJFY9NGpVeUt+eFVtsCjsinH7Y+kHpGfaymn5A3HTcC6ZSOr6+a08U
        MFZO+d8eFY/jFDGOTqBPXPJ9GNPPcMZcTN8B8zJBcDgVjjEjPgWa4X1+L/TSkm4WrqJ3Mw
        pJsOjLeI0/kS6WRe5XJXSRd+kYZ8tHo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-576-jQP4-k7iP7G1dHd36IjpLg-1; Wed, 23 Dec 2020 17:05:23 -0500
X-MC-Unique: jQP4-k7iP7G1dHd36IjpLg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 71CC01005D52;
        Wed, 23 Dec 2020 22:05:21 +0000 (UTC)
Received: from mail (ovpn-112-5.rdu2.redhat.com [10.10.112.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9737571C86;
        Wed, 23 Dec 2020 22:05:17 +0000 (UTC)
Date:   Wed, 23 Dec 2020 17:05:17 -0500
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Yu Zhao <yuzhao@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Minchan Kim <minchan@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Xu <peterx@redhat.com>, linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
Message-ID: <X+O/HT6d+UOa4GfB@redhat.com>
References: <X97pprdcRXusLGnq@google.com>
 <DDA15360-D6D4-46A8-95A4-5EE34107A407@gmail.com>
 <20201221172711.GE6640@xz-x1>
 <76B4F49B-ED61-47EA-9BE4-7F17A26B610D@gmail.com>
 <X+D0hTZCrWS3P5Pi@google.com>
 <CAHk-=wg_UBuo7ro1fpEGkMyFKA1+PxrE85f9J_AhUfr-nJPpLQ@mail.gmail.com>
 <9E301C7C-882A-4E0F-8D6D-1170E792065A@gmail.com>
 <CAHk-=wg-Y+svNy3CDkJjj0X_CJkSbpERLg64-Vqwq5u7SC4z0g@mail.gmail.com>
 <X+ESkna2z3WjjniN@google.com>
 <D4916F41-DE4A-42C6-8702-944382631A02@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <D4916F41-DE4A-42C6-8702-944382631A02@gmail.com>
User-Agent: Mutt/2.0.3 (2020-12-04)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 22, 2020 at 04:40:32AM -0800, Nadav Amit wrote:
> > On Dec 21, 2020, at 1:24 PM, Yu Zhao <yuzhao@google.com> wrote:
> > 
> > On Mon, Dec 21, 2020 at 12:26:22PM -0800, Linus Torvalds wrote:
> >> On Mon, Dec 21, 2020 at 12:23 PM Nadav Amit <nadav.amit@gmail.com> wrote:
> >>> Using mmap_write_lock() was my initial fix and there was a strong pushback
> >>> on this approach due to its potential impact on performance.
> >> 
> >> From whom?
> >> 
> >> Somebody who doesn't understand that correctness is more important
> >> than performance? And that userfaultfd is not the most important part
> >> of the system?
> >> 
> >> The fact is, userfaultfd is CLEARLY BUGGY.
> >> 
> >>          Linus
> > 
> > Fair enough.
> > 
> > Nadav, for your patch (you might want to update the commit message).
> > 
> > Reviewed-by: Yu Zhao <yuzhao@google.com>
> > 
> > While we are all here, there is also clear_soft_dirty() that could
> > use a similar fix…
> 
> Just an update as for why I have still not sent v2: I fixed
> clear_soft_dirty(), created a reproducer, and the reproducer kept failing.
> 
> So after some debugging, it appears that clear_refs_write() does not flush
> the TLB. It indeed calls tlb_finish_mmu() but since 0758cd830494
> ("asm-generic/tlb: avoid potential double flush”), tlb_finish_mmu() does not
> flush the TLB since there is clear_refs_write() does not call to
> __tlb_adjust_range() (unless there are nested TLBs are pending).
> 
> So I have a patch for this issue too: arguably the tlb_gather interface is
> not the right one for clear_refs_write() that does not clear PTEs but
> changes them.
> 
> Yet, sadly, my reproducer keeps falling (less frequently, but still). So I
> will keep debugging to see what goes wrong. I will send v2 once I figure out
> what the heck is wrong in the code or my reproducer.

If you put the page_mapcount check back in do_wp_page instead of
page_count, it'll stop reproducing but the bug is still very much
there...

It's a feature page_count finally shows you the corruption now by
virtue of the page_count being totally unreliable with all speculative
pagecache lookups randomly elevating it in the background.

The proof it worked by luck is that an unrelated change
(s/page_mapcount/page_count/) made the page fault behave slightly
different and broke clear_refs_write.

Even before page_mapcount was replaced with page_count, it has always
been forbidden to leave too permissive stale TLB entries out of sync
with a more restrictive pte/hugepmd permission past the PT unlock,
unless you're holding the mmap_write_lock.

So for example all rmap code has to flush before PT unlock release
too, usually it clears the pte as a whole but it's still a
downgrade.

The rmap_lock and the mmap_read_lock achieve the same: they keep the
vma stable but they can't stop the page fault from running (that's a
feature) so they have to flush inside the PT lock.

The tlb gather deals with preventing use after free (where userland
can modify kernel memory), but it cannot deal with the guarantee the
page fault requires.

So the clear_refs_write patch linked that alters the tlb flushing
appears a noop with respect to this bug. It cannot do anything to
prevent the page fault run with writable stale TLB entries with the
!pte_write.

If you don't add a marker here (it clears it, the exact opposite of
what should be happening), there's no way to avoid the mmap_write_lock
in my view.

static inline void clear_soft_dirty(struct vm_area_struct *vma,
		unsigned long addr, pte_t *pte)
{
	/*
	 * The soft-dirty tracker uses #PF-s to catch writes
	 * to pages, so write-protect the pte as well. See the
	 * Documentation/admin-guide/mm/soft-dirty.rst for full description
	 * of how soft-dirty works.
	 */
	pte_t ptent = *pte;

	if (pte_present(ptent)) {
		pte_t old_pte;

		old_pte = ptep_modify_prot_start(vma, addr, pte);
		ptent = pte_wrprotect(old_pte);
		ptent = pte_clear_soft_dirty(ptent);
+		ptent = pte_mkuffd_wp(ptent);
		ptep_modify_prot_commit(vma, addr, pte, old_pte, ptent);

One solution that would fix the userland mm corruption in
clear_refs_write is to take the mmap_read_lock, take some mutex
somewhere (vma/mm whatever), then in clear_soft_dirty make the above
modification adding the _PAGE_UFFD_WP, then flush tlb, release the
mutex and then release the mmap_read_lock.

Then here:

	if (userfaultfd_pte_wp(vma, *vmf->pte)) {
		pte_unmap_unlock(vmf->pte, vmf->ptl);
+		if (vma->vm_flags & VM_SOFTDIRTY)
+		   return handle_soft_dirty(vma);
		return handle_userfault(vmf, VM_UFFD_WP);

Of course handle_soft_dirty will have to take the mutex once (1
mutex_lock/unlock cycle to run after any pending flush).

And then we'll have to enforce uffd-wp cannot be registered if
VM_SOFTDIRTY is set or the other way around so that VM_UFFD* is
mutually exclusive with VM_SOFTDIRTY. So then we can also unify the
bit so they all use the same software bit in the pgtable (that's
something I considered anyway originally since it doesn't make whole
lot of sense to use the two features on the same vma at the same
time).

If the above is too complex, clear_refs_write will have to grind down
to I/O disk spindle speed as mprotect with
s/mmap_read_lock/mmap_write_lock/, unless it stops triggering
wrprotect faults altogether.

Thanks,
Andrea

