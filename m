Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C19BA2E2414
	for <lists+stable@lfdr.de>; Thu, 24 Dec 2020 04:35:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728761AbgLXDdh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 22:33:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53813 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728280AbgLXDdh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Dec 2020 22:33:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608780730;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ImpOp2pBt8kaX5JJ3UIMDw0UYm4eN1THLKEsdyHiJvY=;
        b=SesEsujSbQs5f9bYsFnGMH28n06EdnVfkxBJPiqoR5XZXx9yphcGPZzlACZfc2P7PtAqw5
        imvmV86HqFSZaI7WRr0XDEZEGcETWIO1eDHP0zSlKl3wQoQqjJhknCKwMMdofE7jOPGl9f
        G9+TtSSLw9UdxOFc/ABN0ujfCw0+Wug=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-506-dpp3bLvUO_GEMxrAAloCNA-1; Wed, 23 Dec 2020 22:32:09 -0500
X-MC-Unique: dpp3bLvUO_GEMxrAAloCNA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EB16A180DE0C;
        Thu, 24 Dec 2020 03:32:06 +0000 (UTC)
Received: from mail (ovpn-112-5.rdu2.redhat.com [10.10.112.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E2845D9CC;
        Thu, 24 Dec 2020 03:31:59 +0000 (UTC)
Date:   Wed, 23 Dec 2020 22:31:59 -0500
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Yu Zhao <yuzhao@google.com>, Andy Lutomirski <luto@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
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
Message-ID: <X+QLr1WmGXMs33Ld@redhat.com>
References: <X+PE38s2Egq4nzKv@google.com>
 <C332B03D-30B1-4C9C-99C2-E76988BFC4A1@amacapital.net>
 <X+P2OnR+ipY8d2qL@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X+P2OnR+ipY8d2qL@redhat.com>
User-Agent: Mutt/2.0.3 (2020-12-04)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 23, 2020 at 09:00:26PM -0500, Andrea Arcangeli wrote:
> One other near zero cost improvement easy to add if this would be "if
> (vma->vm_flags & (VM_SOFTDIRTY|VM_UFFD_WP))" and it could be made

The next worry then is if UFFDIO_WRITEPROTECT is very large then there
would be a flood of wrprotect faults, and they'd end up all issuing a
tlb flush during the UFFDIO_WRITEPROTECT itself which again is a
performance concern for certain uffd-wp use cases.

Those use cases would be for example redis and postcopy live
snapshotting, to use it for async snapshots, unprivileged too in the
case of redis if it temporarily uses bounce buffers for the syscall
I/O for the duration of the snapshot. hypervisors tuned profiles need
to manually lift the unprivileged_userfaultfd to 1 unless their jailer
leaves one capability in the snapshot thread.

Moving the check after userfaultfd_pte_wp would solve
userfaultfd_writeprotect(mode_wp=true), but that still wouldn't avoid
a flood of tlb flushes during userfaultfd_writeprotect(mode_wp=false)
because change_protection doesn't restore the pte_write:

			} else if (uffd_wp_resolve) {
				/*
				 * Leave the write bit to be handled
				 * by PF interrupt handler, then
				 * things like COW could be properly
				 * handled.
				 */
				ptent = pte_clear_uffd_wp(ptent);
			}

When the snapshot is complete userfaultfd_writeprotect(mode_wp=false)
would need to run again on the whole range which can be very big
again.

Orthogonally I think we should also look to restore the pte_write
above orthogonally in uffd-wp, so it'll get yet an extra boost if
compared to current redis snapshotting fork(), that cannot restore all
pte_write after the snapshot child quit and forces a flood of spurious
wrprotect faults (uffd-wp can solve that too).

However, even if uffd-wp restored the pte_write, things would remain
suboptimal for a terabyte process under clear_refs, since softdirty
wrprotect faults that start happening while softdirty is still running
on the mm, won't be caught in userfaultfd_pte_wp.

Something like below, if cleaned up, abstracted properly and
documented well in the two places involved, will have a better chance
to perform optimally for softdirty too.

And on a side note the CONFIG_MEM_SOFT_DIRTY compile time check is
compulsory because VM_SOFTDIRTY is defined to zero if softdirty is not
built in. (for VM_UFFD_WP the CONFIG_HAVE_ARCH_USERFAULTFD_WP can be
removed and it won't make any measurable difference even when
USERFAULTFD=n)

RFC untested below, it's supposed to fix the softdirty testcase too,
even without the incremental fix, since it already does tlb_gather_mmu
before walk_page_range and tlb_finish_mmu after it and that appears
enough to define the inc/dec_tlb_flush_pending.

diff --git a/mm/memory.c b/mm/memory.c
index 7d608765932b..66fd6d070c47 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2844,11 +2844,26 @@ static vm_fault_t wp_page_copy(struct vm_fault *vmf)
 		if (!new_page)
 			goto oom;
 	} else {
+		bool in_uffd_wp, in_softdirty;
 		new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma,
 				vmf->address);
 		if (!new_page)
 			goto oom;
 
+#ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
+		in_uffd_wp = !!(vma->vm_flags & VM_UFFD_WP);
+#else
+		in_uffd_wp = false;
+#endif
+#ifdef CONFIG_MEM_SOFT_DIRTY
+		in_softdirty = !(vma->vm_flags & VM_SOFTDIRTY);
+#else
+		in_softdirty = false;
+#endif
+		if ((in_uffd_wp || in_softdirty) &&
+		    mm_tlb_flush_pending(mm))
+			flush_tlb_page(vma, vmf->address);
+
 		if (!cow_user_page(new_page, old_page, vmf)) {
 			/*
 			 * COW failed, if the fault was solved by other,

