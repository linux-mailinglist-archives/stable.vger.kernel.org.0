Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8687A491B3
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 22:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726001AbfFQUwh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 16:52:37 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:56573 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725497AbfFQUwh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jun 2019 16:52:37 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04446;MF=yang.shi@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0TURrDIY_1560804746;
Received: from US-143344MP.local(mailfrom:yang.shi@linux.alibaba.com fp:SMTPD_---0TURrDIY_1560804746)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 18 Jun 2019 04:52:32 +0800
Subject: Re: [5.1-stable PATCH] mm: mmu_gather: remove __tlb_reset_range() for
 force flush
To:     gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        aneesh.kumar@linux.ibm.com, jstancek@redhat.com, mgorman@suse.de,
        minchan@kernel.org, namit@vmware.com, npiggin@gmail.com,
        peterz@infradead.org, will.deacon@arm.com
Cc:     stable@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
References: <1560804390-28494-1-git-send-email-yang.shi@linux.alibaba.com>
From:   Yang Shi <yang.shi@linux.alibaba.com>
Message-ID: <ec95c6bc-fcf8-e83b-b260-0d9e13ebb870@linux.alibaba.com>
Date:   Mon, 17 Jun 2019 13:52:17 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:52.0)
 Gecko/20100101 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <1560804390-28494-1-git-send-email-yang.shi@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch is wrong, please disregard this one. The corrected one will 
be posted soon. Sorry for the inconvenience.


Yang



On 6/17/19 1:46 PM, Yang Shi wrote:
> A few new fields were added to mmu_gather to make TLB flush smarter for
> huge page by telling what level of page table is changed.
>
> __tlb_reset_range() is used to reset all these page table state to
> unchanged, which is called by TLB flush for parallel mapping changes for
> the same range under non-exclusive lock (i.e. read mmap_sem).  Before
> commit dd2283f2605e ("mm: mmap: zap pages with read mmap_sem in
> munmap"), the syscalls (e.g. MADV_DONTNEED, MADV_FREE) which may update
> PTEs in parallel don't remove page tables.  But, the forementioned
> commit may do munmap() under read mmap_sem and free page tables.  This
> may result in program hang on aarch64 reported by Jan Stancek.  The
> problem could be reproduced by his test program with slightly modified
> below.
>
> ---8<---
>
> static int map_size = 4096;
> static int num_iter = 500;
> static long threads_total;
>
> static void *distant_area;
>
> void *map_write_unmap(void *ptr)
> {
> 	int *fd = ptr;
> 	unsigned char *map_address;
> 	int i, j = 0;
>
> 	for (i = 0; i < num_iter; i++) {
> 		map_address = mmap(distant_area, (size_t) map_size, PROT_WRITE | PROT_READ,
> 			MAP_SHARED | MAP_ANONYMOUS, -1, 0);
> 		if (map_address == MAP_FAILED) {
> 			perror("mmap");
> 			exit(1);
> 		}
>
> 		for (j = 0; j < map_size; j++)
> 			map_address[j] = 'b';
>
> 		if (munmap(map_address, map_size) == -1) {
> 			perror("munmap");
> 			exit(1);
> 		}
> 	}
>
> 	return NULL;
> }
>
> void *dummy(void *ptr)
> {
> 	return NULL;
> }
>
> int main(void)
> {
> 	pthread_t thid[2];
>
> 	/* hint for mmap in map_write_unmap() */
> 	distant_area = mmap(0, DISTANT_MMAP_SIZE, PROT_WRITE | PROT_READ,
> 			MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
> 	munmap(distant_area, (size_t)DISTANT_MMAP_SIZE);
> 	distant_area += DISTANT_MMAP_SIZE / 2;
>
> 	while (1) {
> 		pthread_create(&thid[0], NULL, map_write_unmap, NULL);
> 		pthread_create(&thid[1], NULL, dummy, NULL);
>
> 		pthread_join(thid[0], NULL);
> 		pthread_join(thid[1], NULL);
> 	}
> }
> ---8<---
>
> The program may bring in parallel execution like below:
>
>          t1                                        t2
> munmap(map_address)
>    downgrade_write(&mm->mmap_sem);
>    unmap_region()
>    tlb_gather_mmu()
>      inc_tlb_flush_pending(tlb->mm);
>    free_pgtables()
>      tlb->freed_tables = 1
>      tlb->cleared_pmds = 1
>
>                                          pthread_exit()
>                                          madvise(thread_stack, 8M, MADV_DONTNEED)
>                                            zap_page_range()
>                                              tlb_gather_mmu()
>                                                inc_tlb_flush_pending(tlb->mm);
>
>    tlb_finish_mmu()
>      if (mm_tlb_flush_nested(tlb->mm))
>        __tlb_reset_range()
>
> __tlb_reset_range() would reset freed_tables and cleared_* bits, but
> this may cause inconsistency for munmap() which do free page tables.
> Then it may result in some architectures, e.g. aarch64, may not flush
> TLB completely as expected to have stale TLB entries remained.
>
> Use fullmm flush since it yields much better performance on aarch64 and
> non-fullmm doesn't yields significant difference on x86.
>
> The original proposed fix came from Jan Stancek who mainly debugged this
> issue, I just wrapped up everything together.
>
> Fixes: dd2283f2605e ("mm: mmap: zap pages with read mmap_sem in munmap")
> Reported-by: Jan Stancek <jstancek@redhat.com>
> Tested-by: Jan Stancek <jstancek@redhat.com>
> Suggested-by: Will Deacon <will.deacon@arm.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Nick Piggin <npiggin@gmail.com>
> Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
> Cc: Nadav Amit <namit@vmware.com>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: stable@vger.kernel.org  4.20+
> Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
> Signed-off-by: Jan Stancek <jstancek@redhat.com>
> ---
>   mm/mmu_gather.c | 23 ++++++++++++++++++++++-
>   1 file changed, 22 insertions(+), 1 deletion(-)
>
> diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
> index f2f03c6..3543b82 100644
> --- a/mm/mmu_gather.c
> +++ b/mm/mmu_gather.c
> @@ -92,9 +92,30 @@ void arch_tlb_finish_mmu(struct mmu_gather *tlb,
>   {
>   	struct mmu_gather_batch *batch, *next;
>   
> +	/*
> +	 * If there are parallel threads are doing PTE changes on same range
> +	 * under non-exclusive lock (e.g., mmap_sem read-side) but defer TLB
> +	 * flush by batching, one thread may end up seeing inconsistent PTEs
> +	 * and result in having stale TLB entries.  So flush TLB forcefully
> +	 * if we detect parallel PTE batching threads.
> +	 *
> +	 * However, some syscalls, e.g. munmap(), may free page tables, this
> +	 * needs force flush everything in the given range. Otherwise this
> +	 * may result in having stale TLB entries for some architectures,
> +	 * e.g. aarch64, that could specify flush what level TLB.
> +	 */
>   	if (force) {
> +		/*
> +		 * The aarch64 yields better performance with fullmm by
> +		 * avoiding multiple CPUs spamming TLBI messages at the
> +		 * same time.
> +		 *
> +		 * On x86 non-fullmm doesn't yield significant difference
> +		 * against fullmm.
> +		 */
> +		tlb->fullmm = 1;
>   		__tlb_reset_range(tlb);
> -		__tlb_adjust_range(tlb, start, end - start);
> +		tlb->freed_tables = 1;
>   	}
>   
>   	tlb_flush_mmu(tlb);

