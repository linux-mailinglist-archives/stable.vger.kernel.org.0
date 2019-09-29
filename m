Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 809E0C14AA
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 15:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729095AbfI2N5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 09:57:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:37284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729136AbfI2N5F (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 09:57:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01D2B21882;
        Sun, 29 Sep 2019 13:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765424;
        bh=kBtRliQOvWOAIfklA+fU3jYBpG70TG7gR96SOShxmKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hGqg0yTwfLT69+qdSYIgo6EQpMHo7kqLcE5w67PTkpiB/p1xUzHSYOvx0ednbv3WM
         fuL3ysoDEUcZF8UDAixX29ff7xyTQxOVZ018BKmElofC7P9BXvJTDEBnVfmJj4QYaE
         2eAL50Y9p5QvaREENY6vl22zYd3U+2GytZxvuFuw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+71aff6ea121ffefc280f@syzkaller.appspotmail.com,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Pavel Machek <pavel@denx.de>
Subject: [PATCH 4.19 03/63] RDMA/restrack: Protect from reentry to resource return path
Date:   Sun, 29 Sep 2019 15:53:36 +0200
Message-Id: <20190929135031.899386837@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929135031.382429403@linuxfoundation.org>
References: <20190929135031.382429403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

commit fe9bc1644918aa1d02a889b4ca788bfb67f90816 upstream.

Nullify the resource task struct pointer to ensure that subsequent calls
won't try to release task_struct again.

------------[ cut here ]------------
ODEBUG: free active (active state 1) object type: rcu_head hint:
(null)
WARNING: CPU: 0 PID: 6048 at lib/debugobjects.c:329
debug_print_object+0x16a/0x210 lib/debugobjects.c:326
Kernel panic - not syncing: panic_on_warn set ...

CPU: 0 PID: 6048 Comm: syz-executor022 Not tainted
4.19.0-rc7-next-20181008+ #89
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x244/0x3ab lib/dump_stack.c:113
  panic+0x238/0x4e7 kernel/panic.c:184
  __warn.cold.8+0x163/0x1ba kernel/panic.c:536
  report_bug+0x254/0x2d0 lib/bug.c:186
  fixup_bug arch/x86/kernel/traps.c:178 [inline]
  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:271
  do_invalid_op+0x36/0x40 arch/x86/kernel/traps.c:290
  invalid_op+0x14/0x20 arch/x86/entry/entry_64.S:969
RIP: 0010:debug_print_object+0x16a/0x210 lib/debugobjects.c:326
Code: 41 88 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 92 00 00 00 48 8b 14
dd
60 02 41 88 4c 89 fe 48 c7 c7 00 f8 40 88 e8 36 2f b4 fd <0f> 0b 83 05
a9
f4 5e 06 01 48 83 c4 18 5b 41 5c 41 5d 41 5e 41 5f
RSP: 0018:ffff8801d8c3eda8 EFLAGS: 00010086
RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff8164d235 RDI: 0000000000000005
RBP: ffff8801d8c3ede8 R08: ffff8801d70aa280 R09: ffffed003b5c3eda
R10: ffffed003b5c3eda R11: ffff8801dae1f6d7 R12: 0000000000000001
R13: ffffffff8939a760 R14: 0000000000000000 R15: ffffffff8840fca0
  __debug_check_no_obj_freed lib/debugobjects.c:786 [inline]
  debug_check_no_obj_freed+0x3ae/0x58d lib/debugobjects.c:818
  kmem_cache_free+0x202/0x290 mm/slab.c:3759
  free_task_struct kernel/fork.c:163 [inline]
  free_task+0x16e/0x1f0 kernel/fork.c:457
  __put_task_struct+0x2e6/0x620 kernel/fork.c:730
  put_task_struct include/linux/sched/task.h:96 [inline]
  finish_task_switch+0x66c/0x900 kernel/sched/core.c:2715
  context_switch kernel/sched/core.c:2834 [inline]
  __schedule+0x8d7/0x21d0 kernel/sched/core.c:3480
  schedule+0xfe/0x460 kernel/sched/core.c:3524
  freezable_schedule include/linux/freezer.h:172 [inline]
  futex_wait_queue_me+0x3f9/0x840 kernel/futex.c:2530
  futex_wait+0x45c/0xa50 kernel/futex.c:2645
  do_futex+0x31a/0x26d0 kernel/futex.c:3528
  __do_sys_futex kernel/futex.c:3589 [inline]
  __se_sys_futex kernel/futex.c:3557 [inline]
  __x64_sys_futex+0x472/0x6a0 kernel/futex.c:3557
  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x446549
Code: e8 2c b3 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff
ff 0f 83 2b 09 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f3a998f5da8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: ffffffffffffffda RBX: 00000000006dbc38 RCX: 0000000000446549
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00000000006dbc38
RBP: 00000000006dbc30 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006dbc3c
R13: 2f646e6162696e69 R14: 666e692f7665642f R15: 00000000006dbd2c
Kernel Offset: disabled

Reported-by: syzbot+71aff6ea121ffefc280f@syzkaller.appspotmail.com
Fixes: ed7a01fd3fd7 ("RDMA/restrack: Release task struct which was hold by CM_ID object")
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Cc: Pavel Machek <pavel@denx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/core/restrack.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/infiniband/core/restrack.c
+++ b/drivers/infiniband/core/restrack.c
@@ -225,7 +225,9 @@ void rdma_restrack_del(struct rdma_restr
 	up_write(&dev->res.rwsem);
 
 out:
-	if (res->task)
+	if (res->task) {
 		put_task_struct(res->task);
+		res->task = NULL;
+	}
 }
 EXPORT_SYMBOL(rdma_restrack_del);


