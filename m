Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C56EE3629
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 17:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409573AbfJXPHV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 11:07:21 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5174 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2407327AbfJXPHV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 24 Oct 2019 11:07:21 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 408701071410A51A4E65;
        Thu, 24 Oct 2019 23:07:15 +0800 (CST)
Received: from linux-ibm.site (10.175.102.37) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Thu, 24 Oct 2019 23:07:08 +0800
From:   zhong jiang <zhongjiang@huawei.com>
To:     <gregkh@linuxfoundation.org>
CC:     <willy@infradead.org>, <stable@vger.kernel.org>, <vbabka@suse.cz>,
        <mhocko@suse.com>, <linux-mm@kvack.org>, <zhongjiang@huawei.com>
Subject: [RPF STABLE PATCH] mm/memfd: should be lock the radix_tree when iterating its slot
Date:   Thu, 24 Oct 2019 23:03:20 +0800
Message-ID: <1571929400-12147-1-git-send-email-zhongjiang@huawei.com>
X-Mailer: git-send-email 1.7.12.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.102.37]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Recently, We test an linux 4.19 stable and find the following issue.

kernel BUG at lib/radix-tree.c:1429!
invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 7 PID: 6935 Comm: syz-executor.2 Not tainted 4.19.36 #25
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
RIP: 0010:radix_tree_tag_set+0x200/0x2f0 lib/radix-tree.c:1429
Code: 00 00 5b 5d 41 5c 41 5d 41 5e 41 5f c3 48 89 44 24 10 e8 a3 29 7e fe 48 8b 44 24 10 48 0f ab 03 e9 d2 fe ff ff e8 90 29 7e fe <0f> 0b 48 c7 c7 e0 5a 87 84 e8 f0 e7 08 ff 4c 89 ef e8 4a ff ac fe
RSP: 0018:ffff88837b13fb60 EFLAGS: 00010016
RAX: 0000000000040000 RBX: ffff8883c5515d58 RCX: ffffffff82cb2ef0
RDX: 0000000000000b72 RSI: ffffc90004cf2000 RDI: ffff8883c5515d98
RBP: ffff88837b13fb98 R08: ffffed106f627f7e R09: ffffed106f627f7e
R10: 0000000000000001 R11: ffffed106f627f7d R12: 0000000000000004
R13: ffffea000d7fea80 R14: 1ffff1106f627f6f R15: 0000000000000002
FS:  00007fa1b8df2700(0000) GS:ffff8883e2fc0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fa1b8df1db8 CR3: 000000037d4d2001 CR4: 0000000000160ee0
Call Trace:
 memfd_tag_pins mm/memfd.c:51 [inline]
 memfd_wait_for_pins+0x2c5/0x12d0 mm/memfd.c:81
 memfd_add_seals mm/memfd.c:215 [inline]
 memfd_fcntl+0x33d/0x4a0 mm/memfd.c:247
 do_fcntl+0x589/0xeb0 fs/fcntl.c:421
 __do_sys_fcntl fs/fcntl.c:463 [inline]
 __se_sys_fcntl fs/fcntl.c:448 [inline]
 __x64_sys_fcntl+0x12d/0x180 fs/fcntl.c:448
 do_syscall_64+0xc8/0x580 arch/x86/entry/common.c:293

By reviewing the code, I find that there is an race between iterate
the radix_tree and radix_tree_insert/delete. Because the former just
access its slot in rcu protected period. but it fails to prevent the
radix_tree from being changed.

Cc: stable@vger.kernel.org
Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 mm/memfd.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/mm/memfd.c b/mm/memfd.c
index 2bb5e25..0b3fedc 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -37,8 +37,8 @@ static void memfd_tag_pins(struct address_space *mapping)
 
 	lru_add_drain();
 	start = 0;
-	rcu_read_lock();
 
+	xa_lock_irq(&mapping->i_pages);
 	radix_tree_for_each_slot(slot, &mapping->i_pages, &iter, start) {
 		page = radix_tree_deref_slot(slot);
 		if (!page || radix_tree_exception(page)) {
@@ -47,18 +47,16 @@ static void memfd_tag_pins(struct address_space *mapping)
 				continue;
 			}
 		} else if (page_count(page) - page_mapcount(page) > 1) {
-			xa_lock_irq(&mapping->i_pages);
 			radix_tree_tag_set(&mapping->i_pages, iter.index,
 					   MEMFD_TAG_PINNED);
-			xa_unlock_irq(&mapping->i_pages);
 		}
 
 		if (need_resched()) {
 			slot = radix_tree_iter_resume(slot, &iter);
-			cond_resched_rcu();
+			cond_resched_lock(&mapping->i_pages.xa_lock);
 		}
 	}
-	rcu_read_unlock();
+	xa_unlock_irq(&mapping->i_pages);
 }
 
 /*
-- 
1.7.12.4

