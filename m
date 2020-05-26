Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C29BE198FED
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731149AbgCaJHd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:07:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:49230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731235AbgCaJH0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:07:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C37C20675;
        Tue, 31 Mar 2020 09:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645645;
        bh=bg3dzst6b/qDwfReX3F+WLNx7bdv+k/dh8LP372xMk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TsnD06R8HDaEDyrV6VM66vG4vToXdBuqQ2EJJCxzuB6CYhms/N67XW31tmhHKS4Mz
         C/xMuglQScvHzZL4eZLj7t3j9uYRQ/TNkkUC4w7BjQgm1d9P4rVM2lr3Y73mHXP0MW
         3TKLewLcAKrbJ0SNiHLk/AEYDxCn8tvVs2WeW2t8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Qais Youef <qais.yousef@arm.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.5 111/170] mm/swapfile.c: move inode_lock out of claim_swapfile
Date:   Tue, 31 Mar 2020 10:58:45 +0200
Message-Id: <20200331085435.972835256@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085423.990189598@linuxfoundation.org>
References: <20200331085423.990189598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naohiro Aota <naohiro.aota@wdc.com>

commit d795a90e2ba024dbf2f22107ae89c210b98b08b8 upstream.

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
    swapon/4294 is trying to release lock (&sb->s_type->i_mutex_key) at: __do_sys_swapon+0x94b/0x3550
    but there are no more locks to release!

    other info that might help us debug this:
    no locks held by swapon/4294.

    stack backtrace:
    CPU: 5 PID: 4294 Comm: swapon Not tainted 5.5.0-rc7-BTRFS-ZNS+ #176
    Hardware name: ASUS All Series/H87-PRO, BIOS 2102 07/29/2014
    Call Trace:
     dump_stack+0xa1/0xea
     print_unlock_imbalance_bug.cold+0x114/0x123
     lock_release+0x562/0xed0
     up_write+0x2d/0x490
     __do_sys_swapon+0x94b/0x3550
     __x64_sys_swapon+0x54/0x80
     do_syscall_64+0xa4/0x4b0
     entry_SYSCALL_64_after_hwframe+0x49/0xbe
    RIP: 0033:0x7f15da0a0dc7

Fixes: 1638045c3677 ("mm: set S_SWAPFILE on blockdev swap devices")
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Qais Youef <qais.yousef@arm.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/20200206090132.154869-1-naohiro.aota@wdc.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/swapfile.c |   39 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2899,10 +2899,6 @@ static int claim_swapfile(struct swap_in
 		p->bdev = inode->i_sb->s_bdev;
 	}
 
-	inode_lock(inode);
-	if (IS_SWAPFILE(inode))
-		return -EBUSY;
-
 	return 0;
 }
 
@@ -3157,17 +3153,22 @@ SYSCALL_DEFINE2(swapon, const char __use
 	mapping = swap_file->f_mapping;
 	inode = mapping->host;
 
-	/* If S_ISREG(inode->i_mode) will do inode_lock(inode); */
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
@@ -3179,14 +3180,14 @@ SYSCALL_DEFINE2(swapon, const char __use
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


