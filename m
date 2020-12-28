Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 421A92E3DEA
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438039AbgL1OVq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:21:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:56840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438032AbgL1OVp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:21:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D822C206D4;
        Mon, 28 Dec 2020 14:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165283;
        bh=hanN+jJ08QqLvLszB1Itv4y4i4X+x6Mlz58qZirZ3TA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lJWVZ2GTTz9iKyqlQii29V+xckatYrfcADv4DnjzBf/Oy3EpB9wqF4dBuitQvg4hV
         +fhUQlAqb7kHpiUpplFMeaiAeGeaQtKBNJpCQPcydf/w7qpVuUqLUgmVjqZ28z1N3Y
         ZkYxlfFMBsn63jOzzcRP35gHJqGd0w/HmrBmshZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
        Peter Xu <peterx@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>,
        Hugh Dickins <hughd@google.com>, Jann Horn <jannh@google.com>,
        Kirill Shutemov <kirill@shutemov.name>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Michal Hocko <mhocko@suse.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>
Subject: [PATCH 5.10 447/717] mm/gup: prevent gup_fast from racing with COW during fork
Date:   Mon, 28 Dec 2020 13:47:25 +0100
Message-Id: <20201228125042.389079342@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 57efa1fe5957694fa541c9062de0a127f0b9acb0 ]

Since commit 70e806e4e645 ("mm: Do early cow for pinned pages during
fork() for ptes") pages under a FOLL_PIN will not be write protected
during COW for fork.  This means that pages returned from
pin_user_pages(FOLL_WRITE) should not become write protected while the pin
is active.

However, there is a small race where get_user_pages_fast(FOLL_PIN) can
establish a FOLL_PIN at the same time copy_present_page() is write
protecting it:

        CPU 0                             CPU 1
   get_user_pages_fast()
    internal_get_user_pages_fast()
                                       copy_page_range()
                                         pte_alloc_map_lock()
                                           copy_present_page()
                                             atomic_read(has_pinned) == 0
					     page_maybe_dma_pinned() == false
     atomic_set(has_pinned, 1);
     gup_pgd_range()
      gup_pte_range()
       pte_t pte = gup_get_pte(ptep)
       pte_access_permitted(pte)
       try_grab_compound_head()
                                             pte = pte_wrprotect(pte)
	                                     set_pte_at();
                                         pte_unmap_unlock()
      // GUP now returns with a write protected page

The first attempt to resolve this by using the write protect caused
problems (and was missing a barrrier), see commit f3c64eda3e50 ("mm: avoid
early COW write protect games during fork()")

Instead wrap copy_p4d_range() with the write side of a seqcount and check
the read side around gup_pgd_range().  If there is a collision then
get_user_pages_fast() fails and falls back to slow GUP.

Slow GUP is safe against this race because copy_page_range() is only
called while holding the exclusive side of the mmap_lock on the src
mm_struct.

[akpm@linux-foundation.org: coding style fixes]
  Link: https://lore.kernel.org/r/CAHk-=wi=iCnYCARbPGjkVJu9eyYeZ13N64tZYLdOB8CP5Q_PLw@mail.gmail.com

Link: https://lkml.kernel.org/r/2-v4-908497cf359a+4782-gup_fork_jgg@nvidia.com
Fixes: f3c64eda3e50 ("mm: avoid early COW write protect games during fork()")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Peter Xu <peterx@redhat.com>
Acked-by: "Ahmed S. Darwish" <a.darwish@linutronix.de>	[seqcount_t parts]
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kirill Shutemov <kirill@shutemov.name>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Leon Romanovsky <leonro@nvidia.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/tboot.c    |  1 +
 drivers/firmware/efi/efi.c |  1 +
 include/linux/mm_types.h   |  8 ++++++++
 kernel/fork.c              |  1 +
 mm/gup.c                   | 18 ++++++++++++++++++
 mm/init-mm.c               |  1 +
 mm/memory.c                | 13 ++++++++++++-
 7 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/tboot.c b/arch/x86/kernel/tboot.c
index ae64f98ec2ab6..4c09ba1102047 100644
--- a/arch/x86/kernel/tboot.c
+++ b/arch/x86/kernel/tboot.c
@@ -93,6 +93,7 @@ static struct mm_struct tboot_mm = {
 	.pgd            = swapper_pg_dir,
 	.mm_users       = ATOMIC_INIT(2),
 	.mm_count       = ATOMIC_INIT(1),
+	.write_protect_seq = SEQCNT_ZERO(tboot_mm.write_protect_seq),
 	MMAP_LOCK_INITIALIZER(init_mm)
 	.page_table_lock =  __SPIN_LOCK_UNLOCKED(init_mm.page_table_lock),
 	.mmlist         = LIST_HEAD_INIT(init_mm.mmlist),
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 6c6eec044a978..df3f9bcab581c 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -57,6 +57,7 @@ struct mm_struct efi_mm = {
 	.mm_rb			= RB_ROOT,
 	.mm_users		= ATOMIC_INIT(2),
 	.mm_count		= ATOMIC_INIT(1),
+	.write_protect_seq      = SEQCNT_ZERO(efi_mm.write_protect_seq),
 	MMAP_LOCK_INITIALIZER(efi_mm)
 	.page_table_lock	= __SPIN_LOCK_UNLOCKED(efi_mm.page_table_lock),
 	.mmlist			= LIST_HEAD_INIT(efi_mm.mmlist),
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 5a9238f6caad9..915f4f100383b 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -14,6 +14,7 @@
 #include <linux/uprobes.h>
 #include <linux/page-flags-layout.h>
 #include <linux/workqueue.h>
+#include <linux/seqlock.h>
 
 #include <asm/mmu.h>
 
@@ -446,6 +447,13 @@ struct mm_struct {
 		 */
 		atomic_t has_pinned;
 
+		/**
+		 * @write_protect_seq: Locked when any thread is write
+		 * protecting pages mapped by this mm to enforce a later COW,
+		 * for instance during page table copying for fork().
+		 */
+		seqcount_t write_protect_seq;
+
 #ifdef CONFIG_MMU
 		atomic_long_t pgtables_bytes;	/* PTE page table pages */
 #endif
diff --git a/kernel/fork.c b/kernel/fork.c
index 6d266388d3804..dc55f68a6ee36 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1007,6 +1007,7 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
 	mm->vmacache_seqnum = 0;
 	atomic_set(&mm->mm_users, 1);
 	atomic_set(&mm->mm_count, 1);
+	seqcount_init(&mm->write_protect_seq);
 	mmap_init_lock(mm);
 	INIT_LIST_HEAD(&mm->mmlist);
 	mm->core_state = NULL;
diff --git a/mm/gup.c b/mm/gup.c
index c7e24301860ab..9c6a2f5001c5c 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2684,11 +2684,18 @@ static unsigned long lockless_pages_from_mm(unsigned long start,
 {
 	unsigned long flags;
 	int nr_pinned = 0;
+	unsigned seq;
 
 	if (!IS_ENABLED(CONFIG_HAVE_FAST_GUP) ||
 	    !gup_fast_permitted(start, end))
 		return 0;
 
+	if (gup_flags & FOLL_PIN) {
+		seq = raw_read_seqcount(&current->mm->write_protect_seq);
+		if (seq & 1)
+			return 0;
+	}
+
 	/*
 	 * Disable interrupts. The nested form is used, in order to allow full,
 	 * general purpose use of this routine.
@@ -2703,6 +2710,17 @@ static unsigned long lockless_pages_from_mm(unsigned long start,
 	local_irq_save(flags);
 	gup_pgd_range(start, end, gup_flags, pages, &nr_pinned);
 	local_irq_restore(flags);
+
+	/*
+	 * When pinning pages for DMA there could be a concurrent write protect
+	 * from fork() via copy_page_range(), in this case always fail fast GUP.
+	 */
+	if (gup_flags & FOLL_PIN) {
+		if (read_seqcount_retry(&current->mm->write_protect_seq, seq)) {
+			unpin_user_pages(pages, nr_pinned);
+			return 0;
+		}
+	}
 	return nr_pinned;
 }
 
diff --git a/mm/init-mm.c b/mm/init-mm.c
index 3a613c85f9ede..153162669f806 100644
--- a/mm/init-mm.c
+++ b/mm/init-mm.c
@@ -31,6 +31,7 @@ struct mm_struct init_mm = {
 	.pgd		= swapper_pg_dir,
 	.mm_users	= ATOMIC_INIT(2),
 	.mm_count	= ATOMIC_INIT(1),
+	.write_protect_seq = SEQCNT_ZERO(init_mm.write_protect_seq),
 	MMAP_LOCK_INITIALIZER(init_mm)
 	.page_table_lock =  __SPIN_LOCK_UNLOCKED(init_mm.page_table_lock),
 	.arg_lock	=  __SPIN_LOCK_UNLOCKED(init_mm.arg_lock),
diff --git a/mm/memory.c b/mm/memory.c
index c48f8df6e5026..50632c4366b8a 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1171,6 +1171,15 @@ copy_page_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma)
 		mmu_notifier_range_init(&range, MMU_NOTIFY_PROTECTION_PAGE,
 					0, src_vma, src_mm, addr, end);
 		mmu_notifier_invalidate_range_start(&range);
+		/*
+		 * Disabling preemption is not needed for the write side, as
+		 * the read side doesn't spin, but goes to the mmap_lock.
+		 *
+		 * Use the raw variant of the seqcount_t write API to avoid
+		 * lockdep complaining about preemptibility.
+		 */
+		mmap_assert_write_locked(src_mm);
+		raw_write_seqcount_begin(&src_mm->write_protect_seq);
 	}
 
 	ret = 0;
@@ -1187,8 +1196,10 @@ copy_page_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma)
 		}
 	} while (dst_pgd++, src_pgd++, addr = next, addr != end);
 
-	if (is_cow)
+	if (is_cow) {
+		raw_write_seqcount_end(&src_mm->write_protect_seq);
 		mmu_notifier_invalidate_range_end(&range);
+	}
 	return ret;
 }
 
-- 
2.27.0



