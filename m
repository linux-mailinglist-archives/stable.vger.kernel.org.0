Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32BDA42861F
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 07:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbhJKFML (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 01:12:11 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:35949 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230152AbhJKFML (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Oct 2021 01:12:11 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=rongwei.wang@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UrKrhCr_1633929008;
Received: from localhost.localdomain(mailfrom:rongwei.wang@linux.alibaba.com fp:SMTPD_---0UrKrhCr_1633929008)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 11 Oct 2021 13:10:09 +0800
From:   Rongwei Wang <rongwei.wang@linux.alibaba.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, akpm@linux-foundation.org,
        willy@infradead.org, song@kernel.org, william.kucharski@oracle.com,
        hughd@google.com, shy828301@gmail.com
Subject: [PATCH v4 RESEND 2/2] mm, thp: bail out early in collapse_file for writeback page
Date:   Mon, 11 Oct 2021 13:08:07 +0800
Message-Id: <20211011050807.1732-1-rongwei.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211011022241.97072-3-rongwei.wang@linux.alibaba.com>
References: <20211011022241.97072-3-rongwei.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently collapse_file does not explicitly check PG_writeback, instead,
page_has_private and try_to_release_page are used to filter writeback
pages. This does not work for xfs with blocksize equal to or larger
than pagesize, because in such case xfs has no page->private.

This makes collapse_file bail out early for writeback page. Otherwise,
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

Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
Suggested-by: Yang Shi <shy828301@gmail.com>
Signed-off-by: Xu Yu <xuyu@linux.alibaba.com>
Signed-off-by: Rongwei Wang <rongwei.wang@linux.alibaba.com>
Cc: stable@vger.kernel.org
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Yang Shi <shy828301@gmail.com>
---
 mm/khugepaged.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

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
-- 
2.27.0

