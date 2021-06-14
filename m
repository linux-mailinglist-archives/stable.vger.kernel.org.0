Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 588D53A5B36
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 02:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232238AbhFNAxW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 13 Jun 2021 20:53:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:58504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232076AbhFNAxW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 13 Jun 2021 20:53:22 -0400
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B737160FE4;
        Mon, 14 Jun 2021 00:51:19 +0000 (UTC)
Date:   Sun, 13 Jun 2021 20:51:18 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <gregkh@linuxfoundation.org>
Cc:     liangyan.peng@linux.alibaba.com, jnwang@linux.alibaba.com,
        mingo@redhat.com, wetp.zy@linux.alibaba.com,
        xlpang@linux.alibaba.com, yinbinbin@alibabacloud.com,
        <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] tracing: Correct the length check which
 causes memory" failed to apply to 5.10-stable tree
Message-ID: <20210613205118.0848b3dc@rorschach.local.home>
In-Reply-To: <162358538716087@kroah.com>
References: <162358538716087@kroah.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 13 Jun 2021 13:56:27 +0200
<gregkh@linuxfoundation.org> wrote:

> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 


The below works for 4.9 through 5.10. But will not work for 4.4.

-- Steve

From 3e08a9f9760f4a70d633c328a76408e62d6f80a3 Mon Sep 17 00:00:00 2001
From: Liangyan <liangyan.peng@linux.alibaba.com>
Date: Mon, 7 Jun 2021 20:57:34 +0800
Subject: [PATCH] tracing: Correct the length check which causes memory
 corruption

We've suffered from severe kernel crashes due to memory corruption on
our production environment, like,

Call Trace:
[1640542.554277] general protection fault: 0000 [#1] SMP PTI
[1640542.554856] CPU: 17 PID: 26996 Comm: python Kdump: loaded Tainted:G
[1640542.556629] RIP: 0010:kmem_cache_alloc+0x90/0x190
[1640542.559074] RSP: 0018:ffffb16faa597df8 EFLAGS: 00010286
[1640542.559587] RAX: 0000000000000000 RBX: 0000000000400200 RCX:
0000000006e931bf
[1640542.560323] RDX: 0000000006e931be RSI: 0000000000400200 RDI:
ffff9a45ff004300
[1640542.560996] RBP: 0000000000400200 R08: 0000000000023420 R09:
0000000000000000
[1640542.561670] R10: 0000000000000000 R11: 0000000000000000 R12:
ffffffff9a20608d
[1640542.562366] R13: ffff9a45ff004300 R14: ffff9a45ff004300 R15:
696c662f65636976
[1640542.563128] FS:  00007f45d7c6f740(0000) GS:ffff9a45ff840000(0000)
knlGS:0000000000000000
[1640542.563937] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[1640542.564557] CR2: 00007f45d71311a0 CR3: 000000189d63e004 CR4:
00000000003606e0
[1640542.565279] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[1640542.566069] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[1640542.566742] Call Trace:
[1640542.567009]  anon_vma_clone+0x5d/0x170
[1640542.567417]  __split_vma+0x91/0x1a0
[1640542.567777]  do_munmap+0x2c6/0x320
[1640542.568128]  vm_munmap+0x54/0x70
[1640542.569990]  __x64_sys_munmap+0x22/0x30
[1640542.572005]  do_syscall_64+0x5b/0x1b0
[1640542.573724]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[1640542.575642] RIP: 0033:0x7f45d6e61e27

James Wang has reproduced it stably on the latest 4.19 LTS.
After some debugging, we finally proved that it's due to ftrace
buffer out-of-bound access using a debug tool as follows:
[   86.775200] BUG: Out-of-bounds write at addr 0xffff88aefe8b7000
[   86.780806]  no_context+0xdf/0x3c0
[   86.784327]  __do_page_fault+0x252/0x470
[   86.788367]  do_page_fault+0x32/0x140
[   86.792145]  page_fault+0x1e/0x30
[   86.795576]  strncpy_from_unsafe+0x66/0xb0
[   86.799789]  fetch_memory_string+0x25/0x40
[   86.804002]  fetch_deref_string+0x51/0x60
[   86.808134]  kprobe_trace_func+0x32d/0x3a0
[   86.812347]  kprobe_dispatcher+0x45/0x50
[   86.816385]  kprobe_ftrace_handler+0x90/0xf0
[   86.820779]  ftrace_ops_assist_func+0xa1/0x140
[   86.825340]  0xffffffffc00750bf
[   86.828603]  do_sys_open+0x5/0x1f0
[   86.832124]  do_syscall_64+0x5b/0x1b0
[   86.835900]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

commit b220c049d519 ("tracing: Check length before giving out
the filter buffer") adds length check to protect trace data
overflow introduced in 0fc1b09ff1ff, seems that this fix can't prevent
overflow entirely, the length check should also take the sizeof
entry->array[0] into account, since this array[0] is filled the
length of trace data and occupy addtional space and risk overflow.

Link: https://lkml.kernel.org/r/20210607125734.1770447-1-liangyan.peng@linux.alibaba.com

Cc: stable@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Xunlei Pang <xlpang@linux.alibaba.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Fixes: b220c049d519 ("tracing: Check length before giving out the filter buffer")
Reviewed-by: Xunlei Pang <xlpang@linux.alibaba.com>
Reviewed-by: yinbinbin <yinbinbin@alibabacloud.com>
Reviewed-by: Wetp Zhang <wetp.zy@linux.alibaba.com>
Tested-by: James Wang <jnwang@linux.alibaba.com>
Signed-off-by: Liangyan <liangyan.peng@linux.alibaba.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-test.git/kernel/trace/trace.c
===================================================================
--- linux-test.git.orig/kernel/trace/trace.c
+++ linux-test.git/kernel/trace/trace.c
@@ -2734,7 +2734,7 @@ trace_event_buffer_lock_reserve(struct t
 	    (entry = this_cpu_read(trace_buffered_event))) {
 		/* Try to use the per cpu buffer first */
 		val = this_cpu_inc_return(trace_buffered_event_cnt);
-		if ((len < (PAGE_SIZE - sizeof(*entry))) && val == 1) {
+		if ((len < (PAGE_SIZE - sizeof(*entry) - sizeof(entry->array[0]))) && val == 1) {
 			trace_event_setup(entry, type, flags, pc);
 			entry->array[0] = len;
 			return entry;
