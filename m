Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB9F3A84A3
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 17:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232099AbhFOPvY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 11:51:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:44782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231983AbhFOPvL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 11:51:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F4C6616EA;
        Tue, 15 Jun 2021 15:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623772147;
        bh=ITivmQAGaoXCCsVk+7zGWpNcsKlNL4luOSCVnzjUX5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FAcfGooMM9UUhKV50DmmCVuQ7onjWvoJKwlwzSDZMjWRLDjNdWP4BGOH1/NHNv9DT
         n0VGzY9p2YVLYGSlkzbMuE1BXxSCyeeGV3oGX5PnfTAwHXyG8XYORUX9uwxwDt5F/A
         OHu3lj1xpmCJSEXlXk86LJcfrUt2IXrH6kVb7/sXBBThGRmwSQa6Gi61L8ZMuqL1nR
         J0CJ3XG1Sa7bKfLVcMucq54Ds9doG6o2k/wj79Jd5WAd8/dXZRJqWH1lTtg39gkAb0
         KI1dR+ySaPsYfVnMr5XKeHCICMBvOTABwTFdgyKd9+xMQ5QjEOdJAeokJ+6EEjdKNM
         zrRzPgg8KIMOw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Feng Tang <feng.tang@intel.com>,
        kernel test robot <oliver.sang@intel.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>, Peter Xu <peterx@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.12 33/33] mm: relocate 'write_protect_seq' in struct mm_struct
Date:   Tue, 15 Jun 2021 11:48:24 -0400
Message-Id: <20210615154824.62044-33-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210615154824.62044-1-sashal@kernel.org>
References: <20210615154824.62044-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Feng Tang <feng.tang@intel.com>

[ Upstream commit 2e3025434a6ba090c85871a1d4080ff784109e1f ]

0day robot reported a 9.2% regression for will-it-scale mmap1 test
case[1], caused by commit 57efa1fe5957 ("mm/gup: prevent gup_fast from
racing with COW during fork").

Further debug shows the regression is due to that commit changes the
offset of hot fields 'mmap_lock' inside structure 'mm_struct', thus some
cache alignment changes.

From the perf data, the contention for 'mmap_lock' is very severe and
takes around 95% cpu cycles, and it is a rw_semaphore

        struct rw_semaphore {
                atomic_long_t count;	/* 8 bytes */
                atomic_long_t owner;	/* 8 bytes */
                struct optimistic_spin_queue osq; /* spinner MCS lock */
                ...

Before commit 57efa1fe5957 adds the 'write_protect_seq', it happens to
have a very optimal cache alignment layout, as Linus explained:

 "and before the addition of the 'write_protect_seq' field, the
  mmap_sem was at offset 120 in 'struct mm_struct'.

  Which meant that count and owner were in two different cachelines,
  and then when you have contention and spend time in
  rwsem_down_write_slowpath(), this is probably *exactly* the kind
  of layout you want.

  Because first the rwsem_write_trylock() will do a cmpxchg on the
  first cacheline (for the optimistic fast-path), and then in the
  case of contention, rwsem_down_write_slowpath() will just access
  the second cacheline.

  Which is probably just optimal for a load that spends a lot of
  time contended - new waiters touch that first cacheline, and then
  they queue themselves up on the second cacheline."

After the commit, the rw_semaphore is at offset 128, which means the
'count' and 'owner' fields are now in the same cacheline, and causes
more cache bouncing.

Currently there are 3 "#ifdef CONFIG_XXX" before 'mmap_lock' which will
affect its offset:

  CONFIG_MMU
  CONFIG_MEMBARRIER
  CONFIG_HAVE_ARCH_COMPAT_MMAP_BASES

The layout above is on 64 bits system with 0day's default kernel config
(similar to RHEL-8.3's config), in which all these 3 options are 'y'.
And the layout can vary with different kernel configs.

Relayouting a structure is usually a double-edged sword, as sometimes it
can helps one case, but hurt other cases.  For this case, one solution
is, as the newly added 'write_protect_seq' is a 4 bytes long seqcount_t
(when CONFIG_DEBUG_LOCK_ALLOC=n), placing it into an existing 4 bytes
hole in 'mm_struct' will not change other fields' alignment, while
restoring the regression.

Link: https://lore.kernel.org/lkml/20210525031636.GB7744@xsang-OptiPlex-9020/ [1]
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Feng Tang <feng.tang@intel.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mm_types.h | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 5aacc1c10a45..8f0fb62e8975 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -445,13 +445,6 @@ struct mm_struct {
 		 */
 		atomic_t has_pinned;
 
-		/**
-		 * @write_protect_seq: Locked when any thread is write
-		 * protecting pages mapped by this mm to enforce a later COW,
-		 * for instance during page table copying for fork().
-		 */
-		seqcount_t write_protect_seq;
-
 #ifdef CONFIG_MMU
 		atomic_long_t pgtables_bytes;	/* PTE page table pages */
 #endif
@@ -460,6 +453,18 @@ struct mm_struct {
 		spinlock_t page_table_lock; /* Protects page tables and some
 					     * counters
 					     */
+		/*
+		 * With some kernel config, the current mmap_lock's offset
+		 * inside 'mm_struct' is at 0x120, which is very optimal, as
+		 * its two hot fields 'count' and 'owner' sit in 2 different
+		 * cachelines,  and when mmap_lock is highly contended, both
+		 * of the 2 fields will be accessed frequently, current layout
+		 * will help to reduce cache bouncing.
+		 *
+		 * So please be careful with adding new fields before
+		 * mmap_lock, which can easily push the 2 fields into one
+		 * cacheline.
+		 */
 		struct rw_semaphore mmap_lock;
 
 		struct list_head mmlist; /* List of maybe swapped mm's.	These
@@ -480,7 +485,15 @@ struct mm_struct {
 		unsigned long stack_vm;	   /* VM_STACK */
 		unsigned long def_flags;
 
+		/**
+		 * @write_protect_seq: Locked when any thread is write
+		 * protecting pages mapped by this mm to enforce a later COW,
+		 * for instance during page table copying for fork().
+		 */
+		seqcount_t write_protect_seq;
+
 		spinlock_t arg_lock; /* protect the below fields */
+
 		unsigned long start_code, end_code, start_data, end_data;
 		unsigned long start_brk, brk, start_stack;
 		unsigned long arg_start, arg_end, env_start, env_end;
-- 
2.30.2

