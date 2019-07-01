Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E536467B2
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 20:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbfFNSmC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 14:42:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:34348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725809AbfFNSmC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jun 2019 14:42:02 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7D1320673;
        Fri, 14 Jun 2019 18:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560537721;
        bh=BOB+LgHEdfjKrAyfiAdy8NVnlBrg826g8zX7o/uyBkg=;
        h=Date:From:To:Subject:From;
        b=pNZn5bhZLXDss8NILErp6hsvqoIG1p9dhV+VsBja0ftcvqlMjVUqTl8iWcjdcSxqx
         cOfW3TjJs8ceeMujXZMsuGO1XPMCYLh+T0cWUnzLv8OVFxlSLCuo9NcgmOIjT72VtV
         O9YLJBep7wGLMjMU6q1UI7PHbalLgtIdg20EgqsM=
Date:   Fri, 14 Jun 2019 11:42:00 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, jstancek@redhat.com, mgorman@suse.de,
        minchan@kernel.org, mm-commits@vger.kernel.org, namit@vmware.com,
        npiggin@gmail.com, peterz@infradead.org, stable@vger.kernel.org,
        will.deacon@arm.com, yang.shi@linux.alibaba.com
Subject:  [merged]
 mm-mmu_gather-remove-__tlb_reset_range-for-force-flush.patch removed from
 -mm tree
Message-ID: <20190614184200.oY5ovkK7A%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: mmu_gather: remove __tlb_reset_range() for force flush
has been removed from the -mm tree.  Its filename was
     mm-mmu_gather-remove-__tlb_reset_range-for-force-flush.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: mm: mmu_gather: remove __tlb_reset_range() for force flush

A few new fields were added to mmu_gather to make TLB flush smarter for
huge page by telling what level of page table is changed.

__tlb_reset_range() is used to reset all these page table state to
unchanged, which is called by TLB flush for parallel mapping changes for
the same range under non-exclusive lock (i.e.  read mmap_sem).  Before
commit dd2283f2605e ("mm: mmap: zap pages with read mmap_sem in munmap"),
the syscalls (e.g.  MADV_DONTNEED, MADV_FREE) which may update PTEs in
parallel don't remove page tables.  But, the forementioned commit may do
munmap() under read mmap_sem and free page tables.  This may result in
program hang on aarch64 reported by Jan Stancek.  The problem could be
reproduced by his test program with slightly modified below.

---8<---

static int map_size = 4096;
static int num_iter = 500;
static long threads_total;

static void *distant_area;

void *map_write_unmap(void *ptr)
{
	int *fd = ptr;
	unsigned char *map_address;
	int i, j = 0;

	for (i = 0; i < num_iter; i++) {
		map_address = mmap(distant_area, (size_t) map_size, PROT_WRITE | PROT_READ,
			MAP_SHARED | MAP_ANONYMOUS, -1, 0);
		if (map_address == MAP_FAILED) {
			perror("mmap");
			exit(1);
		}

		for (j = 0; j < map_size; j++)
			map_address[j] = 'b';

		if (munmap(map_address, map_size) == -1) {
			perror("munmap");
			exit(1);
		}
	}

	return NULL;
}

void *dummy(void *ptr)
{
	return NULL;
}

int main(void)
{
	pthread_t thid[2];

	/* hint for mmap in map_write_unmap() */
	distant_area = mmap(0, DISTANT_MMAP_SIZE, PROT_WRITE | PROT_READ,
			MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
	munmap(distant_area, (size_t)DISTANT_MMAP_SIZE);
	distant_area += DISTANT_MMAP_SIZE / 2;

	while (1) {
		pthread_create(&thid[0], NULL, map_write_unmap, NULL);
		pthread_create(&thid[1], NULL, dummy, NULL);

		pthread_join(thid[0], NULL);
		pthread_join(thid[1], NULL);
	}
}
---8<---

The program may bring in parallel execution like below:

        t1                                        t2
munmap(map_address)
  downgrade_write(&mm->mmap_sem);
  unmap_region()
  tlb_gather_mmu()
    inc_tlb_flush_pending(tlb->mm);
  free_pgtables()
    tlb->freed_tables = 1
    tlb->cleared_pmds = 1

                                        pthread_exit()
                                        madvise(thread_stack, 8M, MADV_DONTNEED)
                                          zap_page_range()
                                            tlb_gather_mmu()
                                              inc_tlb_flush_pending(tlb->mm);

  tlb_finish_mmu()
    if (mm_tlb_flush_nested(tlb->mm))
      __tlb_reset_range()

__tlb_reset_range() would reset freed_tables and cleared_* bits, but this
may cause inconsistency for munmap() which do free page tables.  Then it
may result in some architectures, e.g.  aarch64, may not flush TLB
completely as expected to have stale TLB entries remained.

Use fullmm flush since it yields much better performance on aarch64 and
non-fullmm doesn't yields significant difference on x86.

The original proposed fix came from Jan Stancek who mainly debugged this
issue, I just wrapped up everything together.

Jan's testing results:

v5.2-rc2-24-gbec7550cca10
--------------------------
         mean     stddev
real    37.382   2.780
user     1.420   0.078
sys     54.658   1.855

v5.2-rc2-24-gbec7550cca10 + "mm: mmu_gather: remove __tlb_reset_range() for force flush"
---------------------------------------------------------------------------------------_
         mean     stddev
real    37.119   2.105
user     1.548   0.087
sys     55.698   1.357

[akpm@linux-foundation.org: coding-style fixes]
Link: http://lkml.kernel.org/r/1558322252-113575-1-git-send-email-yang.shi@linux.alibaba.com
Fixes: dd2283f2605e ("mm: mmap: zap pages with read mmap_sem in munmap")
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Jan Stancek <jstancek@redhat.com>
Reported-by: Jan Stancek <jstancek@redhat.com>
Tested-by: Jan Stancek <jstancek@redhat.com>
Suggested-by: Will Deacon <will.deacon@arm.com>
Tested-by: Will Deacon <will.deacon@arm.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Nick Piggin <npiggin@gmail.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Nadav Amit <namit@vmware.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: <stable@vger.kernel.org>	[4.20+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmu_gather.c |   24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

--- a/mm/mmu_gather.c~mm-mmu_gather-remove-__tlb_reset_range-for-force-flush
+++ a/mm/mmu_gather.c
@@ -245,14 +245,28 @@ void tlb_finish_mmu(struct mmu_gather *t
 {
 	/*
 	 * If there are parallel threads are doing PTE changes on same range
-	 * under non-exclusive lock(e.g., mmap_sem read-side) but defer TLB
-	 * flush by batching, a thread has stable TLB entry can fail to flush
-	 * the TLB by observing pte_none|!pte_dirty, for example so flush TLB
-	 * forcefully if we detect parallel PTE batching threads.
+	 * under non-exclusive lock (e.g., mmap_sem read-side) but defer TLB
+	 * flush by batching, one thread may end up seeing inconsistent PTEs
+	 * and result in having stale TLB entries.  So flush TLB forcefully
+	 * if we detect parallel PTE batching threads.
+	 *
+	 * However, some syscalls, e.g. munmap(), may free page tables, this
+	 * needs force flush everything in the given range. Otherwise this
+	 * may result in having stale TLB entries for some architectures,
+	 * e.g. aarch64, that could specify flush what level TLB.
 	 */
 	if (mm_tlb_flush_nested(tlb->mm)) {
+		/*
+		 * The aarch64 yields better performance with fullmm by
+		 * avoiding multiple CPUs spamming TLBI messages at the
+		 * same time.
+		 *
+		 * On x86 non-fullmm doesn't yield significant difference
+		 * against fullmm.
+		 */
+		tlb->fullmm = 1;
 		__tlb_reset_range(tlb);
-		__tlb_adjust_range(tlb, start, end - start);
+		tlb->freed_tables = 1;
 	}
 
 	tlb_flush_mmu(tlb);
_

Patches currently in -mm which might be from yang.shi@linux.alibaba.com are

mm-filemap-correct-the-comment-about-vm_fault_retry.patch
mm-vmscan-remove-double-slab-pressure-by-incing-sc-nr_scanned.patch
mm-vmscan-correct-some-vmscan-counters-for-thp-swapout.patch

