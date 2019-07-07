Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5921D616C3
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727997AbfGGTmb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:42:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57652 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727618AbfGGTiM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:12 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCzA-0006kg-7U; Sun, 07 Jul 2019 20:38:08 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz7-0005eY-RS; Sun, 07 Jul 2019 20:38:05 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Andrey Konovalov" <andreyknvl@google.com>,
        "Hugh Dickins" <hughd@google.com>,
        "Al Viro" <viro@zeniv.linux.org.uk>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.978666923@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 102/129] mm: fix potential data race in SyS_swapon
In-Reply-To: <lsq.1562518456.876074874@decadent.org.uk>
X-SA-Exim-Connect-IP: 94.197.121.43
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.70-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Hugh Dickins <hughd@google.com>

commit 6f179af88f60b32c2855e7f3e16ea8e336a7043f upstream.

While running KernelThreadSanitizer (ktsan) on upstream kernel with
trinity, we got a few reports from SyS_swapon, here is one of them:

Read of size 8 by thread T307 (K7621):
 [<     inlined    >] SyS_swapon+0x3c0/0x1850 SYSC_swapon mm/swapfile.c:2395
 [<ffffffff812242c0>] SyS_swapon+0x3c0/0x1850 mm/swapfile.c:2345
 [<ffffffff81e97c8a>] ia32_do_call+0x1b/0x25

Looks like the swap_lock should be taken when iterating through the
swap_info array on lines 2392 - 2401: q->swap_file may be reset to
NULL by another thread before it is dereferenced for f_mapping.

But why is that iteration needed at all?  Doesn't the claim_swapfile()
which follows do all that is needed to check for a duplicate entry -
FMODE_EXCL on a bdev, testing IS_SWAPFILE under i_mutex on a regfile?

Well, not quite: bd_may_claim() allows the same "holder" to claim the
bdev again, so we do need to use a different holder than "sys_swapon";
and we should not replace appropriate -EBUSY by inappropriate -EINVAL.

Index i was reused in a cpu loop further down: renamed cpu there.

Reported-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mm/swapfile.c | 25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2144,11 +2144,10 @@ static int claim_swapfile(struct swap_in
 	if (S_ISBLK(inode->i_mode)) {
 		p->bdev = bdgrab(I_BDEV(inode));
 		error = blkdev_get(p->bdev,
-				   FMODE_READ | FMODE_WRITE | FMODE_EXCL,
-				   sys_swapon);
+				   FMODE_READ | FMODE_WRITE | FMODE_EXCL, p);
 		if (error < 0) {
 			p->bdev = NULL;
-			return -EINVAL;
+			return error;
 		}
 		p->old_block_size = block_size(p->bdev);
 		error = set_blocksize(p->bdev, PAGE_SIZE);
@@ -2365,7 +2364,6 @@ SYSCALL_DEFINE2(swapon, const char __use
 	struct filename *name;
 	struct file *swap_file = NULL;
 	struct address_space *mapping;
-	int i;
 	int prio;
 	int error;
 	union swap_header *swap_header;
@@ -2405,19 +2403,8 @@ SYSCALL_DEFINE2(swapon, const char __use
 
 	p->swap_file = swap_file;
 	mapping = swap_file->f_mapping;
-
-	for (i = 0; i < nr_swapfiles; i++) {
-		struct swap_info_struct *q = swap_info[i];
-
-		if (q == p || !q->swap_file)
-			continue;
-		if (mapping == q->swap_file->f_mapping) {
-			error = -EBUSY;
-			goto bad_swap;
-		}
-	}
-
 	inode = mapping->host;
+
 	/* If S_ISREG(inode->i_mode) will do mutex_lock(&inode->i_mutex); */
 	error = claim_swapfile(p, inode);
 	if (unlikely(error))
@@ -2450,6 +2437,8 @@ SYSCALL_DEFINE2(swapon, const char __use
 		goto bad_swap;
 	}
 	if (p->bdev && blk_queue_nonrot(bdev_get_queue(p->bdev))) {
+		int cpu;
+
 		p->flags |= SWP_SOLIDSTATE;
 		/*
 		 * select a random position to start with to help wear leveling
@@ -2468,9 +2457,9 @@ SYSCALL_DEFINE2(swapon, const char __use
 			error = -ENOMEM;
 			goto bad_swap;
 		}
-		for_each_possible_cpu(i) {
+		for_each_possible_cpu(cpu) {
 			struct percpu_cluster *cluster;
-			cluster = per_cpu_ptr(p->percpu_cluster, i);
+			cluster = per_cpu_ptr(p->percpu_cluster, cpu);
 			cluster_set_null(&cluster->index);
 		}
 	}

