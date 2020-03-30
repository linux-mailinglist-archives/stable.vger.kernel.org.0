Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF91219874B
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 00:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729019AbgC3WXA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 18:23:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:47494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728880AbgC3WW7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Mar 2020 18:22:59 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46E2120658;
        Mon, 30 Mar 2020 22:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585606978;
        bh=9GcIESwnvTg56wnTU3a8Ew82Eu8bbBUo9kqo8f7pu7g=;
        h=Date:From:To:Subject:From;
        b=HvQ6kkE60sWvM8mQfglT5vHKlbAve0y8k+gbMkyhta7sbaiFiKncnWjUmTG4BOpbz
         86wIdsmJ/YZYuTvx5CKsPwK213n0qG0sSWBs0QZZ2/NwtoiS6fuQgZa73xA/plS0ql
         2ZhT0xthSvl3SzJWZ+NmcqgipJu+vXAud8ylkkhk=
Date:   Mon, 30 Mar 2020 15:22:57 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, darrick.wong@oracle.com,
        hch@infradead.org, mm-commits@vger.kernel.org,
        naohiro.aota@wdc.com, qais.yousef@arm.com, stable@vger.kernel.org
Subject:  [merged]
 mm-swap-move-inode_lock-out-of-claim_swapfile.patch removed from -mm tree
Message-ID: <20200330222257.TlLPGi_Gm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/swapfile.c: move inode_lock out of claim_swapfile
has been removed from the -mm tree.  Its filename was
     mm-swap-move-inode_lock-out-of-claim_swapfile.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naohiro Aota <naohiro.aota@wdc.com>
Subject: mm/swapfile.c: move inode_lock out of claim_swapfile

claim_swapfile() currently keeps the inode locked when it is successful,
or the file is already swapfile (with -EBUSY).  And, on the other error
cases, it does not lock the inode.

This inconsistency of the lock state and return value is quite confusing
and actually causing a bad unlock balance as below in the "bad_swap"
section of __do_sys_swapon().

This commit fixes this issue by moving the inode_lock() and IS_SWAPFILE
check out of claim_swapfile().  The inode is unlocked in
"bad_swap_unlock_inode" section, so that the inode is ensured to be
unlocked at "bad_swap".  Thus, error handling codes after the locking now
jumps to "bad_swap_unlock_inode" instead of "bad_swap".

    =====================================
    WARNING: bad unlock balance detected!
    5.5.0-rc7+ #176 Not tainted
    -------------------------------------
    swapon/4294 is trying to release lock (&sb->s_type->i_mutex_key) at:
    [<ffffffff8173a6eb>] __do_sys_swapon+0x94b/0x3550
    but there are no more locks to release!

    other info that might help us debug this:
    no locks held by swapon/4294.

    stack backtrace:
    CPU: 5 PID: 4294 Comm: swapon Not tainted 5.5.0-rc7-BTRFS-ZNS+ #176
    Hardware name: ASUS All Series/H87-PRO, BIOS 2102 07/29/2014
    Call Trace:
     dump_stack+0xa1/0xea
     ? __do_sys_swapon+0x94b/0x3550
     print_unlock_imbalance_bug.cold+0x114/0x123
     ? __do_sys_swapon+0x94b/0x3550
     lock_release+0x562/0xed0
     ? kvfree+0x31/0x40
     ? lock_downgrade+0x770/0x770
     ? kvfree+0x31/0x40
     ? rcu_read_lock_sched_held+0xa1/0xd0
     ? rcu_read_lock_bh_held+0xb0/0xb0
     up_write+0x2d/0x490
     ? kfree+0x293/0x2f0
     __do_sys_swapon+0x94b/0x3550
     ? putname+0xb0/0xf0
     ? kmem_cache_free+0x2e7/0x370
     ? do_sys_open+0x184/0x3e0
     ? generic_max_swapfile_size+0x40/0x40
     ? do_syscall_64+0x27/0x4b0
     ? entry_SYSCALL_64_after_hwframe+0x49/0xbe
     ? lockdep_hardirqs_on+0x38c/0x590
     __x64_sys_swapon+0x54/0x80
     do_syscall_64+0xa4/0x4b0
     entry_SYSCALL_64_after_hwframe+0x49/0xbe
    RIP: 0033:0x7f15da0a0dc7

Link: http://lkml.kernel.org/r/20200206090132.154869-1-naohiro.aota@wdc.com
Fixes: 1638045c3677 ("mm: set S_SWAPFILE on blockdev swap devices")
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Tested-by: Qais Youef <qais.yousef@arm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

--- a/mm/swapfile.c~mm-swap-move-inode_lock-out-of-claim_swapfile
+++ a/mm/swapfile.c
@@ -2899,10 +2899,6 @@ static int claim_swapfile(struct swap_in
 		p->bdev = inode->i_sb->s_bdev;
 	}
 
-	inode_lock(inode);
-	if (IS_SWAPFILE(inode))
-		return -EBUSY;
-
 	return 0;
 }
 
@@ -3157,36 +3153,41 @@ SYSCALL_DEFINE2(swapon, const char __use
 	mapping = swap_file->f_mapping;
 	inode = mapping->host;
 
-	/* will take i_rwsem; */
 	error = claim_swapfile(p, inode);
 	if (unlikely(error))
 		goto bad_swap;
 
+	inode_lock(inode);
+	if (IS_SWAPFILE(inode)) {
+		error = -EBUSY;
+		goto bad_swap_unlock_inode;
+	}
+
 	/*
 	 * Read the swap header.
 	 */
 	if (!mapping->a_ops->readpage) {
 		error = -EINVAL;
-		goto bad_swap;
+		goto bad_swap_unlock_inode;
 	}
 	page = read_mapping_page(mapping, 0, swap_file);
 	if (IS_ERR(page)) {
 		error = PTR_ERR(page);
-		goto bad_swap;
+		goto bad_swap_unlock_inode;
 	}
 	swap_header = kmap(page);
 
 	maxpages = read_swap_header(p, swap_header, inode);
 	if (unlikely(!maxpages)) {
 		error = -EINVAL;
-		goto bad_swap;
+		goto bad_swap_unlock_inode;
 	}
 
 	/* OK, set up the swap map and apply the bad block list */
 	swap_map = vzalloc(maxpages);
 	if (!swap_map) {
 		error = -ENOMEM;
-		goto bad_swap;
+		goto bad_swap_unlock_inode;
 	}
 
 	if (bdi_cap_stable_pages_required(inode_to_bdi(inode)))
@@ -3211,7 +3212,7 @@ SYSCALL_DEFINE2(swapon, const char __use
 					GFP_KERNEL);
 		if (!cluster_info) {
 			error = -ENOMEM;
-			goto bad_swap;
+			goto bad_swap_unlock_inode;
 		}
 
 		for (ci = 0; ci < nr_cluster; ci++)
@@ -3220,7 +3221,7 @@ SYSCALL_DEFINE2(swapon, const char __use
 		p->percpu_cluster = alloc_percpu(struct percpu_cluster);
 		if (!p->percpu_cluster) {
 			error = -ENOMEM;
-			goto bad_swap;
+			goto bad_swap_unlock_inode;
 		}
 		for_each_possible_cpu(cpu) {
 			struct percpu_cluster *cluster;
@@ -3234,13 +3235,13 @@ SYSCALL_DEFINE2(swapon, const char __use
 
 	error = swap_cgroup_swapon(p->type, maxpages);
 	if (error)
-		goto bad_swap;
+		goto bad_swap_unlock_inode;
 
 	nr_extents = setup_swap_map_and_extents(p, swap_header, swap_map,
 		cluster_info, maxpages, &span);
 	if (unlikely(nr_extents < 0)) {
 		error = nr_extents;
-		goto bad_swap;
+		goto bad_swap_unlock_inode;
 	}
 	/* frontswap enabled? set up bit-per-page map for frontswap */
 	if (IS_ENABLED(CONFIG_FRONTSWAP))
@@ -3280,7 +3281,7 @@ SYSCALL_DEFINE2(swapon, const char __use
 
 	error = init_swap_address_space(p->type, maxpages);
 	if (error)
-		goto bad_swap;
+		goto bad_swap_unlock_inode;
 
 	/*
 	 * Flush any pending IO and dirty mappings before we start using this
@@ -3290,7 +3291,7 @@ SYSCALL_DEFINE2(swapon, const char __use
 	error = inode_drain_writes(inode);
 	if (error) {
 		inode->i_flags &= ~S_SWAPFILE;
-		goto bad_swap;
+		goto bad_swap_unlock_inode;
 	}
 
 	mutex_lock(&swapon_mutex);
@@ -3315,6 +3316,8 @@ SYSCALL_DEFINE2(swapon, const char __use
 
 	error = 0;
 	goto out;
+bad_swap_unlock_inode:
+	inode_unlock(inode);
 bad_swap:
 	free_percpu(p->percpu_cluster);
 	p->percpu_cluster = NULL;
@@ -3322,6 +3325,7 @@ bad_swap:
 		set_blocksize(p->bdev, p->old_block_size);
 		blkdev_put(p->bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL);
 	}
+	inode = NULL;
 	destroy_swap_extents(p);
 	swap_cgroup_swapoff(p->type);
 	spin_lock(&swap_lock);
@@ -3333,13 +3337,8 @@ bad_swap:
 	kvfree(frontswap_map);
 	if (inced_nr_rotate_swap)
 		atomic_dec(&nr_rotate_swap);
-	if (swap_file) {
-		if (inode) {
-			inode_unlock(inode);
-			inode = NULL;
-		}
+	if (swap_file)
 		filp_close(swap_file, NULL);
-	}
 out:
 	if (page && !IS_ERR(page)) {
 		kunmap(page);
_

Patches currently in -mm which might be from naohiro.aota@wdc.com are


