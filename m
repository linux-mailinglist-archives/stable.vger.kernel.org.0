Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 315CF2C6E64
	for <lists+stable@lfdr.de>; Sat, 28 Nov 2020 03:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728558AbgK1CPZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Nov 2020 21:15:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:38452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731627AbgK1CIf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Nov 2020 21:08:35 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7D4F22210;
        Sat, 28 Nov 2020 02:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606529314;
        bh=zAN4kQSGNx5You0VLeLf5Zd+BTYXxW0B7Ee/gz5EUeA=;
        h=Date:From:To:Subject:From;
        b=z8jWZdu+Solib+dzMMkLfJfK6WypDIvHbOrf0nhGSPiTb8wP5ZuZUimQNsvyxh4Oq
         IbgHo+bVUP8+vEJdb24SUws6YRA59ZEcLOwkhN+In6dxR9y/Rufit+xWVyQnlHtM1Z
         uwGL8Igfm+G7rmnB3QnXH0UoJHZ2qsH4Q0qWqk+8=
Date:   Fri, 27 Nov 2020 18:08:33 -0800
From:   akpm@linux-foundation.org
To:     dsterba@suse.com, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, vvghjk1234@gmail.com, willy@infradead.org
Subject:  [merged]
 mm-fix-readahead_page_batch-for-retry-entries.patch removed from -mm tree
Message-ID: <20201128020833.qtyNR4961%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: fix readahead_page_batch for retry entries
has been removed from the -mm tree.  Its filename was
     mm-fix-readahead_page_batch-for-retry-entries.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: fix readahead_page_batch for retry entries

Both btrfs and fuse have reported faults caused by seeing a retry entry
instead of the page they were looking for.  This was caused by a missing
check in the iterator.

As can be seen in the below panic log, the accessing 0x402 causes a
panic.  In the xarray.h, 0x402 means RETRY_ENTRY.

BUG: kernel NULL pointer dereference, address: 0000000000000402
CPU: 14 PID: 306003 Comm: as Not tainted 5.9.0-1-amd64 #1 Debian 5.9.1-1
Hardware name: Lenovo ThinkSystem SR665/7D2VCTO1WW, BIOS D8E106Q-1.01 05/30/2020
RIP: 0010:fuse_readahead+0x152/0x470 [fuse]
Code: 41 8b 57 18 4c 8d 54 10 ff 4c 89 d6 48 8d 7c 24 10 e8 d2 e3 28
f9 48 85 c0 0f 84 fe 00 00 00 44 89 f2 49 89 04 d4 44 8d 72 01 <48> 8b
10 41 8b 4f 1c 48 c1 ea 10 83 e2 01 80 fa 01 19 d2 81 e2 01
RSP: 0018:ffffad99ceaebc50 EFLAGS: 00010246
RAX: 0000000000000402 RBX: 0000000000000001 RCX: 0000000000000002
RDX: 0000000000000000 RSI: ffff94c5af90bd98 RDI: ffffad99ceaebc60
RBP: ffff94ddc1749a00 R08: 0000000000000402 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000100 R12: ffff94de6c429ce0
R13: ffff94de6c4d3700 R14: 0000000000000001 R15: ffffad99ceaebd68
FS:  00007f228c5c7040(0000) GS:ffff94de8ed80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000402 CR3: 0000001dbd9b4000 CR4: 0000000000350ee0
Call Trace:
  read_pages+0x83/0x270
  page_cache_readahead_unbounded+0x197/0x230
  generic_file_buffered_read+0x57a/0xa20
  new_sync_read+0x112/0x1a0
  vfs_read+0xf8/0x180
  ksys_read+0x5f/0xe0
  do_syscall_64+0x33/0x80
  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Link: https://lkml.kernel.org/r/20201103142852.8543-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20201103124349.16722-1-vvghjk1234@gmail.com
Fixes: 042124cc64c3 ("mm: add new readahead_control API")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reported-by: David Sterba <dsterba@suse.com>
Reported-by: Wonhyuk Yang <vvghjk1234@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/pagemap.h~mm-fix-readahead_page_batch-for-retry-entries
+++ a/include/linux/pagemap.h
@@ -906,6 +906,8 @@ static inline unsigned int __readahead_b
 	xas_set(&xas, rac->_index);
 	rcu_read_lock();
 	xas_for_each(&xas, page, rac->_index + rac->_nr_pages - 1) {
+		if (xas_retry(&xas, page))
+			continue;
 		VM_BUG_ON_PAGE(!PageLocked(page), page);
 		VM_BUG_ON_PAGE(PageTail(page), page);
 		array[i++] = page;
_

Patches currently in -mm which might be from willy@infradead.org are

sparc-fix-handling-of-page-table-constructor-failure.patch
mm-move-free_unref_page-to-mm-internalh.patch
mm-page-flags-fix-comment.patch
mm-page_alloc-add-__free_pages-documentation.patch
mm-support-thps-in-zero_user_segments.patch
mm-support-thps-in-zero_user_segments-fix.patch
mm-make-pagecache-tagged-lookups-return-only-head-pages.patch
mm-shmem-use-pagevec_lookup-in-shmem_unlock_mapping.patch
mm-swap-optimise-get_shadow_from_swap_cache.patch
mm-add-fgp_entry.patch
mm-filemap-rename-find_get_entry-to-mapping_get_entry.patch
mm-filemap-add-helper-for-finding-pages.patch
mm-filemap-add-helper-for-finding-pages-fix.patch
mm-filemap-add-mapping_seek_hole_data.patch
mm-filemap-add-mapping_seek_hole_data-fix.patch
iomap-use-mapping_seek_hole_data.patch
mm-add-and-use-find_lock_entries.patch
mm-add-and-use-find_lock_entries-fix.patch
mm-add-an-end-parameter-to-find_get_entries.patch
mm-add-an-end-parameter-to-pagevec_lookup_entries.patch
mm-remove-nr_entries-parameter-from-pagevec_lookup_entries.patch
mm-pass-pvec-directly-to-find_get_entries.patch
mm-remove-pagevec_lookup_entries.patch
mm-truncateshmem-handle-truncates-that-split-thps.patch
mm-truncateshmem-handle-truncates-that-split-thps-fix.patch
mm-filemap-return-only-head-pages-from-find_get_entries.patch

