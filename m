Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 387FB43F1EC
	for <lists+stable@lfdr.de>; Thu, 28 Oct 2021 23:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbhJ1VjA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Oct 2021 17:39:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:56056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231431AbhJ1Viz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 Oct 2021 17:38:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6D0460FE3;
        Thu, 28 Oct 2021 21:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635456988;
        bh=aeSrNUgYe3Oyyq9OiXG7KE2T7As8gX/jaK/M4JcUfrg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=DLAQWprQzdIAs+t5/prJn1PQoiRK1UztNC77SOoNdv0td6MYZWGrRsj5GatqRngX7
         3/ILjtbVbmdORpYsL+iXQzpRSt3hIH/88DKTk5jK1iuFkPhnrrKTjnB582pJQHCOBR
         e06GZB/LxZX8jJqoZFXUEsLXSuxEH1Zu5jXEaS7g=
Date:   Thu, 28 Oct 2021 14:36:27 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hughd@google.com,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        rongwei.wang@linux.alibaba.com, shy828301@gmail.com,
        song@kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, william.kucharski@oracle.com,
        willy@infradead.org, xuyu@linux.alibaba.com
Subject:  [patch 08/11] mm, thp: bail out early in collapse_file
 for writeback page
Message-ID: <20211028213627.gvE1DZ9-z%akpm@linux-foundation.org>
In-Reply-To: <20211028143506.5f5d5e2cd1f768a1da864844@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rongwei Wang <rongwei.wang@linux.alibaba.com>
Subject: mm, thp: bail out early in collapse_file for writeback page

Currently collapse_file does not explicitly check PG_writeback, instead,
page_has_private and try_to_release_page are used to filter writeback
pages.  This does not work for xfs with blocksize equal to or larger than
pagesize, because in such case xfs has no page->private.

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
pc : end_page_writeback+0x1c0/0x214
lr : end_page_writeback+0x1c0/0x214
sp : ffff800011ce3cc0
x29: ffff800011ce3cc0 x28: 0000000000000000
x27: ffff000c04608040 x26: 0000000000000000
x25: ffff000c04608040 x24: 0000000000001000
x23: ffff0003f88c8530 x22: 0000000000001000
x21: ffff0003f88c8530 x20: 0000000000000000
x19: fffffe00201bcc80 x18: 0000000000000030
x17: 0000000000000000 x16: 0000000000000000
x15: ffff000c018f9760 x14: ffffffffffffffff
x13: ffff8000119d72b0 x12: ffff8000119d6ee3
x11: ffff8000117b69b8 x10: 00000000ffff8000
x9 : ffff800010617534 x8 : 0000000000000000
x7 : ffff8000114f69b8 x6 : 000000000000000f
x5 : 0000000000000000 x4 : 0000000000000000
x3 : 0000000000000400 x2 : 0000000000000000
x1 : 0000000000000000 x0 : 0000000000000000
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
---

 mm/khugepaged.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/khugepaged.c~mm-thp-bail-out-early-in-collapse_file-for-writeback-page
+++ a/mm/khugepaged.c
@@ -1763,6 +1763,10 @@ static void collapse_file(struct mm_stru
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
@@ -1798,7 +1802,8 @@ static void collapse_file(struct mm_stru
 			goto out_unlock;
 		}
 
-		if (!is_shmem && PageDirty(page)) {
+		if (!is_shmem && (PageDirty(page) ||
+				  PageWriteback(page))) {
 			/*
 			 * khugepaged only works on read-only fd, so this
 			 * page is dirty because it hasn't been flushed
_
