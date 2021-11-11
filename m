Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32E9144D01D
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 03:46:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234391AbhKKCtd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 21:49:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:54314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234346AbhKKCtd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 21:49:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFD586103C;
        Thu, 11 Nov 2021 02:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598805;
        bh=QRli3MnSNQt3e3Lk9eFRTDrEPXMPYs2vyDi3GD8MUus=;
        h=Date:From:To:Subject:From;
        b=DnD9iQzU6y0wSMzLAN1MF4jBdJGlhQzyVXXVuTqQEXg7thFb+sq24y5EjpdkDUkWn
         /OQlMJi5b0ZE62keNIGnSt9wk4QUymS/JK8B+ZOR8lAHrilt8eA4Dz8aBvBpM7s/pR
         qBk+G9BnQZxfXQCdhdh7/sXNefXJtqt/lB0KDPZc=
Date:   Wed, 10 Nov 2021 18:46:44 -0800
From:   akpm@linux-foundation.org
To:     cfijalkovich@google.com, hughd@google.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, rongwei.wang@linux.alibaba.com,
        shy828301@gmail.com, song@kernel.org, stable@vger.kernel.org,
        william.kucharski@oracle.com, willy@infradead.org,
        xuyu@linux.alibaba.com
Subject:  [merged]
 mm-thp-lock-filemap-when-truncating-page-cache.patch removed from -mm tree
Message-ID: <20211111024644.gPQXzoBKh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm, thp: lock filemap when truncating page cache
has been removed from the -mm tree.  Its filename was
     mm-thp-lock-filemap-when-truncating-page-cache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rongwei Wang <rongwei.wang@linux.alibaba.com>
Subject: mm, thp: lock filemap when truncating page cache

Patch series "fix two bugs for file THP".


This patch (of 2):

Transparent huge page has supported read-only non-shmem files.  The file-
backed THP is collapsed by khugepaged and truncated when written (for
shared libraries).

However, there is a race when multiple writers truncate the same page
cache concurrently.

In that case, subpage(s) of file THP can be revealed by find_get_entry in
truncate_inode_pages_range, which will trigger PageTail BUG_ON in
truncate_inode_page, as follows.

page:000000009e420ff2 refcount:1 mapcount:0 mapping:0000000000000000 index:0x7ff pfn:0x50c3ff
head:0000000075ff816d order:9 compound_mapcount:0 compound_pincount:0
flags: 0x37fffe0000010815(locked|uptodate|lru|arch_1|head)
raw: 37fffe0000000000 fffffe0013108001 dead000000000122 dead000000000400
raw: 0000000000000001 0000000000000000 00000000ffffffff 0000000000000000
head: 37fffe0000010815 fffffe001066bd48 ffff000404183c20 0000000000000000
head: 0000000000000600 0000000000000000 00000001ffffffff ffff000c0345a000
page dumped because: VM_BUG_ON_PAGE(PageTail(page))
------------[ cut here ]------------
kernel BUG at mm/truncate.c:213!
Internal error: Oops - BUG: 0 [#1] SMP
Modules linked in: xfs(E) libcrc32c(E) rfkill(E) ...
CPU: 14 PID: 11394 Comm: check_madvise_d Kdump: ...
Hardware name: ECS, BIOS 0.0.0 02/06/2015
pstate: 60400005 (nZCv daif +PAN -UAO -TCO BTYPE=--)
pc : truncate_inode_page+0x64/0x70
lr : truncate_inode_page+0x64/0x70
sp : ffff80001b60b900
x29: ffff80001b60b900 x28: 00000000000007ff
x27: ffff80001b60b9a0 x26: 0000000000000000
x25: 000000000000000f x24: ffff80001b60b9a0
x23: ffff80001b60ba18 x22: ffff0001e0999ea8
x21: ffff0000c21db300 x20: ffffffffffffffff
x19: fffffe001310ffc0 x18: 0000000000000020
x17: 0000000000000000 x16: 0000000000000000
x15: ffff0000c21db960 x14: 3030306666666620
x13: 6666666666666666 x12: 3130303030303030
x11: ffff8000117b69b8 x10: 00000000ffff8000
x9 : ffff80001012690c x8 : 0000000000000000
x7 : ffff8000114f69b8 x6 : 0000000000017ffd
x5 : ffff0007fffbcbc8 x4 : ffff80001b60b5c0
x3 : 0000000000000001 x2 : 0000000000000000
x1 : 0000000000000000 x0 : 0000000000000000
Call trace:
 truncate_inode_page+0x64/0x70
 truncate_inode_pages_range+0x550/0x7e4
 truncate_pagecache+0x58/0x80
 do_dentry_open+0x1e4/0x3c0
 vfs_open+0x38/0x44
 do_open+0x1f0/0x310
 path_openat+0x114/0x1dc
 do_filp_open+0x84/0x134
 do_sys_openat2+0xbc/0x164
 __arm64_sys_openat+0x74/0xc0
 el0_svc_common.constprop.0+0x88/0x220
 do_el0_svc+0x30/0xa0
 el0_svc+0x20/0x30
 el0_sync_handler+0x1a4/0x1b0
 el0_sync+0x180/0x1c0
Code: aa0103e0 900061e1 910ec021 9400d300 (d4210000)
---[ end trace f70cdb42cb7c2d42 ]---
Kernel panic - not syncing: Oops - BUG: Fatal exception

This patch mainly to lock filemap when one enter truncate_pagecache(),
avoiding truncating the same page cache concurrently.

Link: https://lkml.kernel.org/r/20211025092134.18562-1-rongwei.wang@linux.alibaba.com
Link: https://lkml.kernel.org/r/20211025092134.18562-2-rongwei.wang@linux.alibaba.com
Fixes: eb6ecbed0aa2 ("mm, thp: relax the VM_DENYWRITE constraint on file-backed THPs")
Signed-off-by: Xu Yu <xuyu@linux.alibaba.com>
Signed-off-by: Rongwei Wang <rongwei.wang@linux.alibaba.com>
Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Tested-by: Song Liu <song@kernel.org>
Cc: Collin Fijalkovich <cfijalkovich@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/open.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/open.c~mm-thp-lock-filemap-when-truncating-page-cache
+++ a/fs/open.c
@@ -856,8 +856,11 @@ static int do_dentry_open(struct file *f
 		 * of THPs into the page cache will fail.
 		 */
 		smp_mb();
-		if (filemap_nr_thps(inode->i_mapping))
+		if (filemap_nr_thps(inode->i_mapping)) {
+			filemap_invalidate_lock(inode->i_mapping);
 			truncate_pagecache(inode, 0);
+			filemap_invalidate_unlock(inode->i_mapping);
+		}
 	}
 
 	return 0;
_

Patches currently in -mm which might be from rongwei.wang@linux.alibaba.com are


