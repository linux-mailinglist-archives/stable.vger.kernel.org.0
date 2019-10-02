Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01FDFC91A7
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 21:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729300AbfJBTKo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 15:10:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35866 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729311AbfJBTIQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Oct 2019 15:08:16 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyu-00035s-EK; Wed, 02 Oct 2019 20:08:12 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyq-0003gg-LL; Wed, 02 Oct 2019 20:08:08 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        "Eiichi Tsukata" <devel@etsukata.com>
Date:   Wed, 02 Oct 2019 20:06:51 +0100
Message-ID: <lsq.1570043211.462979156@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 84/87] tracing/snapshot: Resize spare buffer if size
 changed
In-Reply-To: <lsq.1570043210.379046399@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.75-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Eiichi Tsukata <devel@etsukata.com>

commit 46cc0b44428d0f0e81f11ea98217fc0edfbeab07 upstream.

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

Fixes: ad909e21bbe69 ("tracing: Add internal tracing_snapshot() functions")
Signed-off-by: Eiichi Tsukata <devel@etsukata.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/trace/trace.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5102,11 +5102,13 @@ tracing_snapshot_write(struct file *filp
 			break;
 		}
 #endif
-		if (!tr->allocated_snapshot) {
+		if (tr->allocated_snapshot)
+			ret = resize_buffer_duplicate_size(&tr->max_buffer,
+					&tr->trace_buffer, iter->cpu_file);
+		else
 			ret = alloc_snapshot(tr);
-			if (ret < 0)
-				break;
-		}
+		if (ret < 0)
+			break;
 		local_irq_disable();
 		/* Now, we're going to swap */
 		if (iter->cpu_file == RING_BUFFER_ALL_CPUS)

