Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C32E55E718
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 16:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726993AbfGCOsk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 10:48:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:44840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726805AbfGCOsj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Jul 2019 10:48:39 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCBC5218BC;
        Wed,  3 Jul 2019 14:48:38 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92)
        (envelope-from <rostedt@goodmis.org>)
        id 1higYn-0005iY-Sv; Wed, 03 Jul 2019 10:48:37 -0400
Message-Id: <20190703144837.784034158@goodmis.org>
User-Agent: quilt/0.65
Date:   Wed, 03 Jul 2019 10:47:45 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Eiichi Tsukata <devel@etsukata.com>
Subject: [for-linus][PATCH 4/5] tracing/snapshot: Resize spare buffer if size changed
References: <20190703144741.181267753@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eiichi Tsukata <devel@etsukata.com>

Current snapshot implementation swaps two ring_buffers even though their
sizes are different from each other, that can cause an inconsistency
between the contents of buffer_size_kb file and the current buffer size.

For example:

  # cat buffer_size_kb
  7 (expanded: 1408)
  # echo 1 > events/enable
  # grep bytes per_cpu/cpu0/stats
  bytes: 1441020
  # echo 1 > snapshot             // current:1408, spare:1408
  # echo 123 > buffer_size_kb     // current:123,  spare:1408
  # echo 1 > snapshot             // current:1408, spare:123
  # grep bytes per_cpu/cpu0/stats
  bytes: 1443700
  # cat buffer_size_kb
  123                             // != current:1408

And also, a similar per-cpu case hits the following WARNING:

Reproducer:

  # echo 1 > per_cpu/cpu0/snapshot
  # echo 123 > buffer_size_kb
  # echo 1 > per_cpu/cpu0/snapshot

WARNING:

  WARNING: CPU: 0 PID: 1946 at kernel/trace/trace.c:1607 update_max_tr_single.part.0+0x2b8/0x380
  Modules linked in:
  CPU: 0 PID: 1946 Comm: bash Not tainted 5.2.0-rc6 #20
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-2.fc30 04/01/2014
  RIP: 0010:update_max_tr_single.part.0+0x2b8/0x380
  Code: ff e8 dc da f9 ff 0f 0b e9 88 fe ff ff e8 d0 da f9 ff 44 89 ee bf f5 ff ff ff e8 33 dc f9 ff 41 83 fd f5 74 96 e8 b8 da f9 ff <0f> 0b eb 8d e8 af da f9 ff 0f 0b e9 bf fd ff ff e8 a3 da f9 ff 48
  RSP: 0018:ffff888063e4fca0 EFLAGS: 00010093
  RAX: ffff888066214380 RBX: ffffffff99850fe0 RCX: ffffffff964298a8
  RDX: 0000000000000000 RSI: 00000000fffffff5 RDI: 0000000000000005
  RBP: 1ffff1100c7c9f96 R08: ffff888066214380 R09: ffffed100c7c9f9b
  R10: ffffed100c7c9f9a R11: 0000000000000003 R12: 0000000000000000
  R13: 00000000ffffffea R14: ffff888066214380 R15: ffffffff99851060
  FS:  00007f9f8173c700(0000) GS:ffff88806d000000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000000714dc0 CR3: 0000000066fa6000 CR4: 00000000000006f0
  Call Trace:
   ? trace_array_printk_buf+0x140/0x140
   ? __mutex_lock_slowpath+0x10/0x10
   tracing_snapshot_write+0x4c8/0x7f0
   ? trace_printk_init_buffers+0x60/0x60
   ? selinux_file_permission+0x3b/0x540
   ? tracer_preempt_off+0x38/0x506
   ? trace_printk_init_buffers+0x60/0x60
   __vfs_write+0x81/0x100
   vfs_write+0x1e1/0x560
   ksys_write+0x126/0x250
   ? __ia32_sys_read+0xb0/0xb0
   ? do_syscall_64+0x1f/0x390
   do_syscall_64+0xc1/0x390
   entry_SYSCALL_64_after_hwframe+0x49/0xbe

This patch adds resize_buffer_duplicate_size() to check if there is a
difference between current/spare buffer sizes and resize a spare buffer
if necessary.

Link: http://lkml.kernel.org/r/20190625012910.13109-1-devel@etsukata.com

Cc: stable@vger.kernel.org
Fixes: ad909e21bbe69 ("tracing: Add internal tracing_snapshot() functions")
Signed-off-by: Eiichi Tsukata <devel@etsukata.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 4122ccde6ec2..c3aabb576fe5 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -6719,11 +6719,13 @@ tracing_snapshot_write(struct file *filp, const char __user *ubuf, size_t cnt,
 			break;
 		}
 #endif
-		if (!tr->allocated_snapshot) {
+		if (tr->allocated_snapshot)
+			ret = resize_buffer_duplicate_size(&tr->max_buffer,
+					&tr->trace_buffer, iter->cpu_file);
+		else
 			ret = tracing_alloc_snapshot_instance(tr);
-			if (ret < 0)
-				break;
-		}
+		if (ret < 0)
+			break;
 		local_irq_disable();
 		/* Now, we're going to swap */
 		if (iter->cpu_file == RING_BUFFER_ALL_CPUS)
-- 
2.20.1


