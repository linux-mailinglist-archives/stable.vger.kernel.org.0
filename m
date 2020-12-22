Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8A22E0F0E
	for <lists+stable@lfdr.de>; Tue, 22 Dec 2020 20:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbgLVTpp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 14:45:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54108 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726261AbgLVTpo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Dec 2020 14:45:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608666257;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tI9RK4cFAHT2wID3U52x1nikQbt8aqU7ArNiStfO7ZQ=;
        b=VxPepqfPH7KJCeZ5h1Z8xXNz/+aSvSqtHXiM18gepV5NTEjY4B9eW4ygNBTrLYty3ATrGT
        bv5DlQbPc1wOGEG7uv1zNiOpscDkdjl9Zu0BTL9PtAoUMJx/wqAqEpx9TUThgdX12JHJhX
        zS7j544gE54KcB43sdJOZivBFYmMxbI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-396-hC779z6sNvil__MY8cjkwg-1; Tue, 22 Dec 2020 14:44:14 -0500
X-MC-Unique: hC779z6sNvil__MY8cjkwg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 596A0801817;
        Tue, 22 Dec 2020 19:44:12 +0000 (UTC)
Received: from mail (ovpn-112-5.rdu2.redhat.com [10.10.112.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C13D460BF1;
        Tue, 22 Dec 2020 19:44:08 +0000 (UTC)
Date:   Tue, 22 Dec 2020 14:44:08 -0500
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Peter Xu <peterx@redhat.com>, Yu Zhao <yuzhao@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
Message-ID: <X+JMiHv+EktzyZgr@redhat.com>
References: <20201221172711.GE6640@xz-x1>
 <76B4F49B-ED61-47EA-9BE4-7F17A26B610D@gmail.com>
 <X+D0hTZCrWS3P5Pi@google.com>
 <CAHk-=wg_UBuo7ro1fpEGkMyFKA1+PxrE85f9J_AhUfr-nJPpLQ@mail.gmail.com>
 <9E301C7C-882A-4E0F-8D6D-1170E792065A@gmail.com>
 <CAHk-=wg-Y+svNy3CDkJjj0X_CJkSbpERLg64-Vqwq5u7SC4z0g@mail.gmail.com>
 <X+ESkna2z3WjjniN@google.com>
 <1FCC8F93-FF29-44D3-A73A-DF943D056680@gmail.com>
 <20201221223041.GL6640@xz-x1>
 <B8095F3C-81E3-4AF9-A6A5-F597D51264BD@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <B8095F3C-81E3-4AF9-A6A5-F597D51264BD@gmail.com>
User-Agent: Mutt/2.0.3 (2020-12-04)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 21, 2020 at 02:55:12PM -0800, Nadav Amit wrote:
> wouldn’t mmap_write_downgrade() be executed before mprotect_fixup() (so

I assume you mean "in" mprotect_fixup, after change_protection.

If you would downgrade the mmap_lock to read there, then it'd severely
slowdown the non contention case, if there's more than vma that needs
change_protection.

You'd need to throw away the prev->vm_next info and you'd need to do a
new find_vma after droping the mmap_lock for reading and re-taking the
mmap_lock for writing at every iteration of the loop.

To do less harm to the non-contention case you could perhaps walk
vma->vm_next and check if it's outside the mprotect range and only
downgrade in such case. So let's assume we intend to optimize with
mmap_write_downgrade only the last vma.

The problem is once you had to take mmap_lock for writing, you already
stalled for I/O and waited all concurrent page faults and blocked them
as well for the vma allocations in split_vma, so that extra boost in
SMP scalability you get is lost in the noise there at best.

And the risk is that at worst that extra locked op of
mmap_write_downgrade() will hurt SMP scalability because it would
increase the locked ops of mprotect on the hottest false-shared
cacheline by 50% and that may outweight the benefit from unblocking
the page faults half a usec sooner on large systems.

But the ultimate reason why mprotect cannot do mmap_write_downgrade()
while userfaultfd_writeprotect can do mmap_read_lock and avoid the
mmap_write_lock altogether, is that mprotect leaves no mark in the
pte/hugepmd that allows to detect when the TLB is stale in order to
redirect the page fault in a dead end (handle_userfault() or
do_numa_page) until after the TLB has been flushed as it happens in
the the 4 cases below:

	/*
	 * STALE_TLB_WARNING: while the uffd_wp bit is set, the TLB
	 * can be stale. We cannot allow do_wp_page to proceed or
	 * it'll wrongly assume that nobody can still be writing to
	 * the page if !pte_write.
	 */
	if (userfaultfd_pte_wp(vma, *vmf->pte)) {
		/*
		 * STALE_TLB_WARNING: while the uffd_wp bit is set,
		 * the TLB can be stale. We cannot allow wp_huge_pmd()
		 * to proceed or it'll wrongly assume that nobody can
		 * still be writing to the page if !pmd_write.
		 */
		if (userfaultfd_huge_pmd_wp(vmf->vma, orig_pmd))
	/*
	 * STALE_TLB_WARNING: if the pte is NUMA protnone the TLB can
	 * be stale.
	 */
	if (pte_protnone(vmf->orig_pte) && vma_is_accessible(vmf->vma))
			/*
			 * STALE_TLB_WARNING: if the pmd is NUMA
			 * protnone the TLB can be stale.
			 */
			if (pmd_protnone(orig_pmd) && vma_is_accessible(vma))

Thanks,
Andrea

