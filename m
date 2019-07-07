Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 823C061693
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727693AbfGGTkx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:40:53 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57950 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727660AbfGGTiQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:16 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCzD-0006jQ-Cb; Sun, 07 Jul 2019 20:38:11 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz7-0005ed-UT; Sun, 07 Jul 2019 20:38:05 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Shaohua Li" <shli@kernel.org>, "Tejun Heo" <tj@kernel.org>,
        "Will Deacon" <will.deacon@arm.com>,
        "Paul McKenney" <paulmck@linux.vnet.ibm.com>,
        "Stephen Rothwell" <sfr@canb.auug.org.au>,
        "Dan Carpenter" <dan.carpenter@oracle.com>,
        "Alan Stern" <stern@rowland.harvard.edu>,
        "Andi Kleen" <ak@linux.intel.com>,
        "Daniel Jordan" <daniel.m.jordan@oracle.com>,
        "Dave Hansen" <dave.hansen@linux.intel.com>,
        "Andrea Parri" <andrea.parri@amarulasolutions.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Omar Sandoval" <osandov@fb.com>,
        "Huang, Ying" <ying.huang@intel.com>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.857980580@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 103/129] mm, swap: bounds check swap_info array
 accesses to avoid NULL derefs
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

From: Daniel Jordan <daniel.m.jordan@oracle.com>

commit c10d38cc8d3e43f946b6c2bf4602c86791587f30 upstream.

Dan Carpenter reports a potential NULL dereference in
get_swap_page_of_type:

  Smatch complains that the NULL checks on "si" aren't consistent.  This
  seems like a real bug because we have not ensured that the type is
  valid and so "si" can be NULL.

Add the missing check for NULL, taking care to use a read barrier to
ensure CPU1 observes CPU0's updates in the correct order:

     CPU0                           CPU1
     alloc_swap_info()              if (type >= nr_swapfiles)
       swap_info[type] = p              /* handle invalid entry */
       smp_wmb()                    smp_rmb()
       ++nr_swapfiles               p = swap_info[type]

Without smp_rmb, CPU1 might observe CPU0's write to nr_swapfiles before
CPU0's write to swap_info[type] and read NULL from swap_info[type].

Ying Huang noticed other places in swapfile.c don't order these reads
properly.  Introduce swap_type_to_swap_info to encourage correct usage.

Use READ_ONCE and WRITE_ONCE to follow the Linux Kernel Memory Model
(see tools/memory-model/Documentation/explanation.txt).

This ordering need not be enforced in places where swap_lock is held
(e.g.  si_swapinfo) because swap_lock serializes updates to nr_swapfiles
and the swap_info array.

Link: http://lkml.kernel.org/r/20190131024410.29859-1-daniel.m.jordan@oracle.com
Fixes: ec8acf20afb8 ("swap: add per-partition lock for swapfile")
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Suggested-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Andrea Parri <andrea.parri@amarulasolutions.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Omar Sandoval <osandov@fb.com>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Tejun Heo <tj@kernel.org>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[bwh: Backported to 3.16:
 - Add swp_swap_info(), as done in upstream commit 0bcac06f27d7
   "mm, swap: skip swapcache for swapin of synchronous device"
 - Use ACCESS_ONCE() instead of {READ,WRITE}_ONCE()
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -451,6 +451,7 @@ extern sector_t map_swap_page(struct pag
 extern sector_t swapdev_block(int, pgoff_t);
 extern int page_swapcount(struct page *);
 extern struct swap_info_struct *page_swap_info(struct page *);
+extern struct swap_info_struct *swp_swap_info(swp_entry_t entry);
 extern int reuse_swap_page(struct page *);
 extern int try_to_free_swap(struct page *);
 struct backing_dev_info;
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -86,6 +86,15 @@ static DECLARE_WAIT_QUEUE_HEAD(proc_poll
 /* Activity counter to indicate that a swapon or swapoff has occurred */
 static atomic_t proc_poll_event = ATOMIC_INIT(0);
 
+static struct swap_info_struct *swap_type_to_swap_info(int type)
+{
+	if (type >= ACCESS_ONCE(nr_swapfiles))
+		return NULL;
+
+	smp_rmb();	/* Pairs with smp_wmb in alloc_swap_info. */
+	return ACCESS_ONCE(swap_info[type]);
+}
+
 static inline unsigned char swap_count(unsigned char ent)
 {
 	return ent & ~SWAP_HAS_CACHE;	/* may include COUNT_CONTINUED flag */
@@ -703,12 +712,14 @@ noswap:
 /* The only caller of this function is now suspend routine */
 swp_entry_t get_swap_page_of_type(int type)
 {
-	struct swap_info_struct *si;
+	struct swap_info_struct *si = swap_type_to_swap_info(type);
 	pgoff_t offset;
 
-	si = swap_info[type];
+	if (!si)
+		goto fail;
+
 	spin_lock(&si->lock);
-	if (si && (si->flags & SWP_WRITEOK)) {
+	if (si->flags & SWP_WRITEOK) {
 		atomic_long_dec(&nr_swap_pages);
 		/* This is called for allocating swap entry, not cache */
 		offset = scan_swap_map(si, 1);
@@ -719,6 +730,7 @@ swp_entry_t get_swap_page_of_type(int ty
 		atomic_long_inc(&nr_swap_pages);
 	}
 	spin_unlock(&si->lock);
+fail:
 	return (swp_entry_t) {0};
 }
 
@@ -730,9 +742,9 @@ static struct swap_info_struct *swap_inf
 	if (!entry.val)
 		goto out;
 	type = swp_type(entry);
-	if (type >= nr_swapfiles)
+	p = swap_type_to_swap_info(type);
+	if (!p)
 		goto bad_nofile;
-	p = swap_info[type];
 	if (!(p->flags & SWP_USED))
 		goto bad_device;
 	offset = swp_offset(entry);
@@ -1037,10 +1049,9 @@ int swap_type_of(dev_t device, sector_t
 sector_t swapdev_block(int type, pgoff_t offset)
 {
 	struct block_device *bdev;
+	struct swap_info_struct *si = swap_type_to_swap_info(type);
 
-	if ((unsigned int)type >= nr_swapfiles)
-		return 0;
-	if (!(swap_info[type]->flags & SWP_WRITEOK))
+	if (!si || !(si->flags & SWP_WRITEOK))
 		return 0;
 	return map_swap_entry(swp_entry(type, offset), &bdev);
 }
@@ -1584,7 +1595,7 @@ static sector_t map_swap_entry(swp_entry
 	struct swap_extent *se;
 	pgoff_t offset;
 
-	sis = swap_info[swp_type(entry)];
+	sis = swp_swap_info(entry);
 	*bdev = sis->bdev;
 
 	offset = swp_offset(entry);
@@ -1982,9 +1993,7 @@ static void *swap_start(struct seq_file
 	if (!l)
 		return SEQ_START_TOKEN;
 
-	for (type = 0; type < nr_swapfiles; type++) {
-		smp_rmb();	/* read nr_swapfiles before swap_info[type] */
-		si = swap_info[type];
+	for (type = 0; (si = swap_type_to_swap_info(type)); type++) {
 		if (!(si->flags & SWP_USED) || !si->swap_map)
 			continue;
 		if (!--l)
@@ -2004,9 +2013,7 @@ static void *swap_next(struct seq_file *
 	else
 		type = si->type + 1;
 
-	for (; type < nr_swapfiles; type++) {
-		smp_rmb();	/* read nr_swapfiles before swap_info[type] */
-		si = swap_info[type];
+	for (; (si = swap_type_to_swap_info(type)); type++) {
 		if (!(si->flags & SWP_USED) || !si->swap_map)
 			continue;
 		++*pos;
@@ -2111,14 +2118,14 @@ static struct swap_info_struct *alloc_sw
 	}
 	if (type >= nr_swapfiles) {
 		p->type = type;
-		swap_info[type] = p;
+		ACCESS_ONCE(swap_info[type]) = p;
 		/*
 		 * Write swap_info[type] before nr_swapfiles, in case a
 		 * racing procfs swap_start() or swap_next() is reading them.
 		 * (We never shrink nr_swapfiles, we never free this entry.)
 		 */
 		smp_wmb();
-		nr_swapfiles++;
+		ACCESS_ONCE(nr_swapfiles) = nr_swapfiles + 1;
 	} else {
 		kfree(p);
 		p = swap_info[type];
@@ -2598,7 +2605,7 @@ void si_swapinfo(struct sysinfo *val)
 static int __swap_duplicate(swp_entry_t entry, unsigned char usage)
 {
 	struct swap_info_struct *p;
-	unsigned long offset, type;
+	unsigned long offset;
 	unsigned char count;
 	unsigned char has_cache;
 	int err = -EINVAL;
@@ -2606,10 +2613,10 @@ static int __swap_duplicate(swp_entry_t
 	if (non_swap_entry(entry))
 		goto out;
 
-	type = swp_type(entry);
-	if (type >= nr_swapfiles)
+	p = swp_swap_info(entry);
+	if (!p)
 		goto bad_file;
-	p = swap_info[type];
+
 	offset = swp_offset(entry);
 
 	spin_lock(&p->lock);
@@ -2704,11 +2711,16 @@ int swapcache_prepare(swp_entry_t entry)
 	return __swap_duplicate(entry, SWAP_HAS_CACHE);
 }
 
+struct swap_info_struct *swp_swap_info(swp_entry_t entry)
+{
+	return swap_type_to_swap_info(swp_type(entry));
+}
+
 struct swap_info_struct *page_swap_info(struct page *page)
 {
-	swp_entry_t swap = { .val = page_private(page) };
+	swp_entry_t entry = { .val = page_private(page) };
 	BUG_ON(!PageSwapCache(page));
-	return swap_info[swp_type(swap)];
+	return swp_swap_info(entry);
 }
 
 /*

