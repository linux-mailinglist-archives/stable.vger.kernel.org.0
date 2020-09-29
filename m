Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F53B27CDCF
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387581AbgI2MrB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:47:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:43326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728819AbgI2LGP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:06:15 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46FDC21D43;
        Tue, 29 Sep 2020 11:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601377573;
        bh=URKAbkmRFe6QcAYdDdp+0syqtAevYnLmF19XLltt75Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2c4LxZSvLN5sA4E1XW88l+buQAHQlNbBbn/JPYzA5atjcE32E4lcS9/ROYqQoEH65
         NV9LdElcXcKOzPUa++47+o7sN2tPPeSZvgo2AgOxQd+4zXA3ZGKwqmAYuZ26eQxbUL
         3p+a1ivTpOjWq1kB4p9V9OI1l2YjUX12tcPlygfU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        David Miller <davem@davemloft.net>,
        Muchun Song <songmuchun@bytedance.com>,
        Chengming Zhou <zhouchengming@bytedance.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.4 81/85] kprobes: Fix to check probe enabled before disarm_kprobe_ftrace()
Date:   Tue, 29 Sep 2020 13:00:48 +0200
Message-Id: <20200929105932.243117682@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105928.198942536@linuxfoundation.org>
References: <20200929105928.198942536@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

commit 3031313eb3d549b7ad6f9fbcc52ba04412e3eb9e upstream.

Commit 0cb2f1372baa ("kprobes: Fix NULL pointer dereference at
kprobe_ftrace_handler") fixed one bug but not completely fixed yet.
If we run a kprobe_module.tc of ftracetest, kernel showed a warning
as below.

# ./ftracetest test.d/kprobe/kprobe_module.tc
=== Ftrace unit tests ===
[1] Kprobe dynamic event - probing module
...
[   22.400215] ------------[ cut here ]------------
[   22.400962] Failed to disarm kprobe-ftrace at trace_printk_irq_work+0x0/0x7e [trace_printk] (-2)
[   22.402139] WARNING: CPU: 7 PID: 200 at kernel/kprobes.c:1091 __disarm_kprobe_ftrace.isra.0+0x7e/0xa0
[   22.403358] Modules linked in: trace_printk(-)
[   22.404028] CPU: 7 PID: 200 Comm: rmmod Not tainted 5.9.0-rc2+ #66
[   22.404870] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1 04/01/2014
[   22.406139] RIP: 0010:__disarm_kprobe_ftrace.isra.0+0x7e/0xa0
[   22.406947] Code: 30 8b 03 eb c9 80 3d e5 09 1f 01 00 75 dc 49 8b 34 24 89 c2 48 c7 c7 a0 c2 05 82 89 45 e4 c6 05 cc 09 1f 01 01 e8 a9 c7 f0 ff <0f> 0b 8b 45 e4 eb b9 89 c6 48 c7 c7 70 c2 05 82 89 45 e4 e8 91 c7
[   22.409544] RSP: 0018:ffffc90000237df0 EFLAGS: 00010286
[   22.410385] RAX: 0000000000000000 RBX: ffffffff83066024 RCX: 0000000000000000
[   22.411434] RDX: 0000000000000001 RSI: ffffffff810de8d3 RDI: ffffffff810de8d3
[   22.412687] RBP: ffffc90000237e10 R08: 0000000000000001 R09: 0000000000000001
[   22.413762] R10: 0000000000000000 R11: 0000000000000001 R12: ffff88807c478640
[   22.414852] R13: ffffffff8235ebc0 R14: ffffffffa00060c0 R15: 0000000000000000
[   22.415941] FS:  00000000019d48c0(0000) GS:ffff88807d7c0000(0000) knlGS:0000000000000000
[   22.417264] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   22.418176] CR2: 00000000005bb7e3 CR3: 0000000078f7a000 CR4: 00000000000006a0
[   22.419309] Call Trace:
[   22.419990]  kill_kprobe+0x94/0x160
[   22.420652]  kprobes_module_callback+0x64/0x230
[   22.421470]  notifier_call_chain+0x4f/0x70
[   22.422184]  blocking_notifier_call_chain+0x49/0x70
[   22.422979]  __x64_sys_delete_module+0x1ac/0x240
[   22.423733]  do_syscall_64+0x38/0x50
[   22.424366]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   22.425176] RIP: 0033:0x4bb81d
[   22.425741] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e0 ff ff ff f7 d8 64 89 01 48
[   22.428726] RSP: 002b:00007ffc70fef008 EFLAGS: 00000246 ORIG_RAX: 00000000000000b0
[   22.430169] RAX: ffffffffffffffda RBX: 00000000019d48a0 RCX: 00000000004bb81d
[   22.431375] RDX: 0000000000000000 RSI: 0000000000000880 RDI: 00007ffc70fef028
[   22.432543] RBP: 0000000000000880 R08: 00000000ffffffff R09: 00007ffc70fef320
[   22.433692] R10: 0000000000656300 R11: 0000000000000246 R12: 00007ffc70fef028
[   22.434635] R13: 0000000000000000 R14: 0000000000000002 R15: 0000000000000000
[   22.435682] irq event stamp: 1169
[   22.436240] hardirqs last  enabled at (1179): [<ffffffff810df542>] console_unlock+0x422/0x580
[   22.437466] hardirqs last disabled at (1188): [<ffffffff810df19b>] console_unlock+0x7b/0x580
[   22.438608] softirqs last  enabled at (866): [<ffffffff81c0038e>] __do_softirq+0x38e/0x490
[   22.439637] softirqs last disabled at (859): [<ffffffff81a00f42>] asm_call_on_stack+0x12/0x20
[   22.440690] ---[ end trace 1e7ce7e1e4567276 ]---
[   22.472832] trace_kprobe: This probe might be able to register after target module is loaded. Continue.

This is because the kill_kprobe() calls disarm_kprobe_ftrace() even
if the given probe is not enabled. In that case, ftrace_set_filter_ip()
fails because the given probe point is not registered to ftrace.

Fix to check the given (going) probe is enabled before invoking
disarm_kprobe_ftrace().

Link: https://lkml.kernel.org/r/159888672694.1411785.5987998076694782591.stgit@devnote2

Fixes: 0cb2f1372baa ("kprobes: Fix NULL pointer dereference at kprobe_ftrace_handler")
Cc: Ingo Molnar <mingo@kernel.org>
Cc: "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: David Miller <davem@davemloft.net>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/kprobes.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -2035,9 +2035,10 @@ static void kill_kprobe(struct kprobe *p
 
 	/*
 	 * The module is going away. We should disarm the kprobe which
-	 * is using ftrace.
+	 * is using ftrace, because ftrace framework is still available at
+	 * MODULE_STATE_GOING notification.
 	 */
-	if (kprobe_ftrace(p))
+	if (kprobe_ftrace(p) && !kprobe_disabled(p) && !kprobes_all_disarmed)
 		disarm_kprobe_ftrace(p);
 }
 


