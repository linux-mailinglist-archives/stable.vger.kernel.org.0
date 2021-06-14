Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6303A6347
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234115AbhFNLLu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:11:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:39872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235165AbhFNLJM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:09:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFB0561166;
        Mon, 14 Jun 2021 10:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667594;
        bh=H8YZ+zpXrrz7Ipx8iYndMHa+HWjT9DOs5R514j5F51Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dI5TsL2U6SB4Tumc1K/41ZOGB4FHkgHeSzUszEJPcXF4Z9QxHA6wyATm6lVL6bgPG
         ZIgHFKGM9K4xbHVhavly2ZNh3sTqePHgY8eVsGsmRn040feZID2LLASqbcxqXd2Tm8
         9uvQDDMtTT95RKzdVOLqSyCBXwxnfK4tXlOYFboE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Xunlei Pang <xlpang@linux.alibaba.com>,
        yinbinbin <yinbinbin@alibabacloud.com>,
        Wetp Zhang <wetp.zy@linux.alibaba.com>,
        James Wang <jnwang@linux.alibaba.com>,
        Liangyan <liangyan.peng@linux.alibaba.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.10 131/131] tracing: Correct the length check which causes memory corruption
Date:   Mon, 14 Jun 2021 12:28:12 +0200
Message-Id: <20210614102657.478134374@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102652.964395392@linuxfoundation.org>
References: <20210614102652.964395392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liangyan <liangyan.peng@linux.alibaba.com>

commit 3e08a9f9760f4a70d633c328a76408e62d6f80a3 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2734,7 +2734,7 @@ trace_event_buffer_lock_reserve(struct t
 	    (entry = this_cpu_read(trace_buffered_event))) {
 		/* Try to use the per cpu buffer first */
 		val = this_cpu_inc_return(trace_buffered_event_cnt);
-		if ((len < (PAGE_SIZE - sizeof(*entry))) && val == 1) {
+		if ((len < (PAGE_SIZE - sizeof(*entry) - sizeof(entry->array[0]))) && val == 1) {
 			trace_event_setup(entry, type, flags, pc);
 			entry->array[0] = len;
 			return entry;


