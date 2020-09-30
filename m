Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE8027E957
	for <lists+stable@lfdr.de>; Wed, 30 Sep 2020 15:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730155AbgI3NTP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Sep 2020 09:19:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:52696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730140AbgI3NTO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Sep 2020 09:19:14 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CA0720754;
        Wed, 30 Sep 2020 13:19:14 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kNc0n-002M7g-9p; Wed, 30 Sep 2020 09:19:13 -0400
Message-ID: <20200930131913.182910382@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 30 Sep 2020 09:18:46 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org,
        Anna-Maria Behnsen <anna-maria@linutronix.de>
Subject: [for-linus][PATCH 1/2] tracing: Fix trace_find_next_entry() accounting of temp buffer size
References: <20200930131845.346190751@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The temp buffer size variable for trace_find_next_entry() was incorrectly
being updated when the size did not change. The temp buffer size should only
be updated when it is reallocated.

This is mostly an issue when used with ftrace_dump(). That's because
ftrace_dump() can not allocate a new buffer, and instead uses a temporary
buffer with a fix size. But the variable that keeps track of that size is
incorrectly updated with each call, and it could fall into the path that
would try to reallocate the buffer and produce a warning.

 ------------[ cut here ]------------
 WARNING: CPU: 1 PID: 1601 at kernel/trace/trace.c:3548
trace_find_next_entry+0xd0/0xe0
 Modules linked in [..]
 CPU: 1 PID: 1601 Comm: bash Not tainted 5.9.0-rc5-test+ #521
 Hardware name: Hewlett-Packard HP Compaq Pro 6300 SFF/339A, BIOS K01 v03.03
07/14/2016
 RIP: 0010:trace_find_next_entry+0xd0/0xe0
 Code: 40 21 00 00 4c 89 e1 31 d2 4c 89 ee 48 89 df e8 c6 9e ff ff 89 ab 54
21 00 00 5b 5d 41 5c 41 5d c3 48 63 d5 eb bf 31 c0 eb f0 <0f> 0b 48 63 d5 eb
b4 66 0f 1f 84 00 00 00 00 00 53 48 8d 8f 60 21
 RSP: 0018:ffff95a4f2e8bd70 EFLAGS: 00010046
 RAX: ffffffff96679fc0 RBX: ffffffff97910de0 RCX: ffffffff96679fc0
 RDX: ffff95a4f2e8bd98 RSI: ffff95a4ee321098 RDI: ffffffff97913000
 RBP: 0000000000000018 R08: 0000000000000000 R09: 0000000000000000
 R10: 0000000000000001 R11: 0000000000000046 R12: ffff95a4f2e8bd98
 R13: 0000000000000000 R14: ffff95a4ee321098 R15: 00000000009aa301
 FS:  00007f8565484740(0000) GS:ffff95a55aa40000(0000)
knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 000055876bd43d90 CR3: 00000000b76e6003 CR4: 00000000001706e0
 Call Trace:
  trace_print_lat_context+0x58/0x2d0
  ? cpumask_next+0x16/0x20
  print_trace_line+0x1a4/0x4f0
  ftrace_dump.cold+0xad/0x12c
  __handle_sysrq.cold+0x51/0x126
  write_sysrq_trigger+0x3f/0x4a
  proc_reg_write+0x53/0x80
  vfs_write+0xca/0x210
  ksys_write+0x70/0xf0
  do_syscall_64+0x33/0x40
  entry_SYSCALL_64_after_hwframe+0x44/0xa9
 RIP: 0033:0x7f8565579487
 Code: 64 89 02 48 c7 c0 ff ff ff ff eb bb 0f 1f 80 00 00 00 00 f3 0f 1e fa
64 8b 04 25 18 00 00 00 85 c0 75 10 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff
77 51 c3 48 83 ec 28 48 89 54 24 18 48 89 74 24
 RSP: 002b:00007ffd40707948 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
 RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f8565579487
 RDX: 0000000000000002 RSI: 000055876bd74de0 RDI: 0000000000000001
 RBP: 000055876bd74de0 R08: 000000000000000a R09: 0000000000000001
 R10: 000055876bdec280 R11: 0000000000000246 R12: 0000000000000002
 R13: 00007f856564a500 R14: 0000000000000002 R15: 00007f856564a700
 irq event stamp: 109958
 ---[ end trace 7aab5b7e51484b00 ]---

Not only fix the updating of the temp buffer, but also do not free the temp
buffer before a new buffer is allocated (there's no reason to not continue
to use the current temp buffer if an allocation fails).

Cc: stable@vger.kernel.org
Fixes: 8e99cf91b99bb ("tracing: Do not allocate buffer in trace_find_next_entry() in atomic")
Reported-by: Anna-Maria Behnsen <anna-maria@linutronix.de>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 2a7c26345e83..d3e5de717df2 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3546,13 +3546,15 @@ struct trace_entry *trace_find_next_entry(struct trace_iterator *iter,
 	if (iter->ent && iter->ent != iter->temp) {
 		if ((!iter->temp || iter->temp_size < iter->ent_size) &&
 		    !WARN_ON_ONCE(iter->temp == static_temp_buf)) {
-			kfree(iter->temp);
-			iter->temp = kmalloc(iter->ent_size, GFP_KERNEL);
-			if (!iter->temp)
+			void *temp;
+			temp = kmalloc(iter->ent_size, GFP_KERNEL);
+			if (!temp)
 				return NULL;
+			kfree(iter->temp);
+			iter->temp = temp;
+			iter->temp_size = iter->ent_size;
 		}
 		memcpy(iter->temp, iter->ent, iter->ent_size);
-		iter->temp_size = iter->ent_size;
 		iter->ent = iter->temp;
 	}
 	entry = __find_next_entry(iter, ent_cpu, NULL, ent_ts);
-- 
2.28.0


