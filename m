Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5441A195A5
	for <lists+stable@lfdr.de>; Fri, 10 May 2019 01:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbfEIX1G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 19:27:06 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:35073 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726108AbfEIX1G (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 May 2019 19:27:06 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=yang.shi@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0TRHabNi_1557444414;
Received: from e19h19392.et15sqa.tbsite.net(mailfrom:yang.shi@linux.alibaba.com fp:SMTPD_---0TRHabNi_1557444414)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 10 May 2019 07:27:02 +0800
From:   Yang Shi <yang.shi@linux.alibaba.com>
To:     jstancek@redhat.com, peterz@infradead.org, will.deacon@arm.com,
        namit@vmware.com, minchan@kernel.org, mgorman@suse.de
Cc:     yang.shi@linux.alibaba.com, stable@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [v2 PATCH] mm: mmu_gather: remove __tlb_reset_range() for force flush
Date:   Fri, 10 May 2019 07:26:54 +0800
Message-Id: <1557444414-12090-1-git-send-email-yang.shi@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A few new fields were added to mmu_gather to make TLB flush smarter for
huge page by telling what level of page table is changed.

__tlb_reset_range() is used to reset all these page table state to
unchanged, which is called by TLB flush for parallel mapping changes for
the same range under non-exclusive lock (i.e. read mmap_sem).  Before
commit dd2283f2605e ("mm: mmap: zap pages with read mmap_sem in
munmap"), the syscalls (e.g. MADV_DONTNEED, MADV_FREE) which may update
PTEs in parallel don't remove page tables.  But, the forementioned
commit may do munmap() under read mmap_sem and free page tables.  This
may result in program hang on aarch64 reported by Jan Stancek.  The
problem could be reproduced by his test program with slightly modified
below.

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

__tlb_reset_range() would reset freed_tables and cleared_* bits, but
this may cause inconsistency for munmap() which do free page tables.
Then it may result in some architectures, e.g. aarch64, may not flush
TLB completely as expected to have stale TLB entries remained.

The original proposed fix came from Jan Stancek who mainly debugged this
issue, I just wrapped up everything together.

Reported-by: Jan Stancek <jstancek@redhat.com>
Tested-by: Jan Stancek <jstancek@redhat.com>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Nadav Amit <namit@vmware.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: stable@vger.kernel.org
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Jan Stancek <jstancek@redhat.com>
---
v2: Reworked the commit log per Peter and Will
    Adopted the suggestion from Peter

 mm/mmu_gather.c | 39 ++++++++++++++++++++++++++++++++-------
 1 file changed, 32 insertions(+), 7 deletions(-)

diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
index 99740e1..469492d 100644
--- a/mm/mmu_gather.c
+++ b/mm/mmu_gather.c
@@ -245,14 +245,39 @@ void tlb_finish_mmu(struct mmu_gather *tlb,
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
-	if (mm_tlb_flush_nested(tlb->mm)) {
-		__tlb_reset_range(tlb);
-		__tlb_adjust_range(tlb, start, end - start);
+	if (mm_tlb_flush_nested(tlb->mm) && !tlb->fullmm) {
+		/*
+		 * Since we can't tell what we actually should have
+		 * flushed, flush everything in the given range.
+		 */
+		tlb->freed_tables = 1;
+		tlb->cleared_ptes = 1;
+		tlb->cleared_pmds = 1;
+		tlb->cleared_puds = 1;
+		tlb->cleared_p4ds = 1;
+
+		/*
+		 * Some architectures, e.g. ARM, that have range invalidation
+		 * and care about VM_EXEC for I-Cache invalidation, need force
+		 * vma_exec set.
+		 */
+		tlb->vma_exec = 1;
+
+		/* Force vma_huge clear to guarantee safer flush */
+		tlb->vma_huge = 0;
+
+		tlb->start = start;
+		tlb->end = end;
 	}
 
 	tlb_flush_mmu(tlb);
-- 
1.8.3.1

