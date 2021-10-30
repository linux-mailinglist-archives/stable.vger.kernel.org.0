Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC7644408B9
	for <lists+stable@lfdr.de>; Sat, 30 Oct 2021 14:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231932AbhJ3M2m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Oct 2021 08:28:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:35276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231907AbhJ3M2m (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 30 Oct 2021 08:28:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9CAC60F45;
        Sat, 30 Oct 2021 12:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635596772;
        bh=WRChnOc7K+fbQnnV3gndGNdLpDQIEZbg+h6a4vxkcFE=;
        h=Subject:To:Cc:From:Date:From;
        b=oNEEKcGcnxeqKVuvppge5XZpo204gl7yiXktJMG3BCLgNRJh/cHF523sakZNU34Te
         PkeHaeGv3fHZaggYq4MSwgbFaAIsUfYJT01OD+cOT6WBIoDHgwbotgNT+Op0dZwtHN
         qtnNdo7zd9F524k16HQPyCZNgmAComSeLgaOBTU4=
Subject: FAILED: patch "[PATCH] mm, thp: bail out early in collapse_file for writeback page" failed to apply to 5.4-stable tree
To:     rongwei.wang@linux.alibaba.com, akpm@linux-foundation.org,
        hughd@google.com, kirill.shutemov@linux.intel.com,
        mike.kravetz@oracle.com, shy828301@gmail.com, song@kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        william.kucharski@oracle.com, willy@infradead.org,
        xuyu@linux.alibaba.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 30 Oct 2021 14:26:10 +0200
Message-ID: <163559677070179@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 74c42e1baacf206338b1dd6b6199ac964512b5bb Mon Sep 17 00:00:00 2001
From: Rongwei Wang <rongwei.wang@linux.alibaba.com>
Date: Thu, 28 Oct 2021 14:36:27 -0700
Subject: [PATCH] mm, thp: bail out early in collapse_file for writeback page

Currently collapse_file does not explicitly check PG_writeback, instead,
page_has_private and try_to_release_page are used to filter writeback
pages.  This does not work for xfs with blocksize equal to or larger
than pagesize, because in such case xfs has no page->private.

This makes collapse_file bail out early for writeback page.  Otherwise,
xfs end_page_writeback will panic as follows.

  page:fffffe00201bcc80 refcount:0 mapcount:0 mapping:ffff0003f88c86a8 index:0x0 pfn:0x84ef32
  aops:xfs_address_space_operations [xfs] ino:30000b7 dentry name:"libtest.so"
  flags: 0x57fffe0000008027(locked|referenced|uptodate|active|writeback)
  raw: 57fffe0000008027 ffff80001b48bc28 ffff80001b48bc28 ffff0003f88c86a8
  raw: 0000000000000000 0000000000000000 00000000ffffffff ffff0000c3e9a000
  page dumped because: VM_BUG_ON_PAGE(((unsigned int) page_ref_count(page) + 127u <= 127u))
  page->mem_cgroup:ffff0000c3e9a000
  ------------[ cut here ]------------
  kernel BUG at include/linux/mm.h:1212!
  Internal error: Oops - BUG: 0 [#1] SMP
  Modules linked in:
  BUG: Bad page state in process khugepaged  pfn:84ef32
   xfs(E)
  page:fffffe00201bcc80 refcount:0 mapcount:0 mapping:0 index:0x0 pfn:0x84ef32
   libcrc32c(E) rfkill(E) aes_ce_blk(E) crypto_simd(E) ...
  CPU: 25 PID: 0 Comm: swapper/25 Kdump: loaded Tainted: ...
  pstate: 60400005 (nZCv daif +PAN -UAO -TCO BTYPE=--)
  Call trace:
    end_page_writeback+0x1c0/0x214
    iomap_finish_page_writeback+0x13c/0x204
    iomap_finish_ioend+0xe8/0x19c
    iomap_writepage_end_bio+0x38/0x50
    bio_endio+0x168/0x1ec
    blk_update_request+0x278/0x3f0
    blk_mq_end_request+0x34/0x15c
    virtblk_request_done+0x38/0x74 [virtio_blk]
    blk_done_softirq+0xc4/0x110
    __do_softirq+0x128/0x38c
    __irq_exit_rcu+0x118/0x150
    irq_exit+0x1c/0x30
    __handle_domain_irq+0x8c/0xf0
    gic_handle_irq+0x84/0x108
    el1_irq+0xcc/0x180
    arch_cpu_idle+0x18/0x40
    default_idle_call+0x4c/0x1a0
    cpuidle_idle_call+0x168/0x1e0
    do_idle+0xb4/0x104
    cpu_startup_entry+0x30/0x9c
    secondary_start_kernel+0x104/0x180
  Code: d4210000 b0006161 910c8021 94013f4d (d4210000)
  ---[ end trace 4a88c6a074082f8c ]---
  Kernel panic - not syncing: Oops - BUG: Fatal exception in interrupt

Link: https://lkml.kernel.org/r/20211022023052.33114-1-rongwei.wang@linux.alibaba.com
Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
Signed-off-by: Rongwei Wang <rongwei.wang@linux.alibaba.com>
Signed-off-by: Xu Yu <xuyu@linux.alibaba.com>
Suggested-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Song Liu <song@kernel.org>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 045cc579f724..48de4e1b0783 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1763,6 +1763,10 @@ static void collapse_file(struct mm_struct *mm,
 				filemap_flush(mapping);
 				result = SCAN_FAIL;
 				goto xa_unlocked;
+			} else if (PageWriteback(page)) {
+				xas_unlock_irq(&xas);
+				result = SCAN_FAIL;
+				goto xa_unlocked;
 			} else if (trylock_page(page)) {
 				get_page(page);
 				xas_unlock_irq(&xas);
@@ -1798,7 +1802,8 @@ static void collapse_file(struct mm_struct *mm,
 			goto out_unlock;
 		}
 
-		if (!is_shmem && PageDirty(page)) {
+		if (!is_shmem && (PageDirty(page) ||
+				  PageWriteback(page))) {
 			/*
 			 * khugepaged only works on read-only fd, so this
 			 * page is dirty because it hasn't been flushed

