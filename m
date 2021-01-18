Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E89112F9F52
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 13:18:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389992AbhARMRw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 07:17:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:37938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390881AbhARLqP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:46:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF286224B0;
        Mon, 18 Jan 2021 11:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970345;
        bh=RruCIzkrTDhcZ24KmkI1cg/SgroFrb9eD/uIl9I/HYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qMW3GoEVZPj8Z6avYNPNve0/MMpk0Unwp+Hygmz/2y7KCjY2Jfo44wGn0WIqzmWmc
         OF5ZU1mzkEivmFEChJ5fALSL1FMbSO9A9wXTWPVhupRbx58pLIIF9kmqGRVT4q+GNW
         lVkk+o8/8aErDtGsKeB+41aavaJfyVjG0kyKXLZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Lemon <jonathan.lemon@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 100/152] bpf: Save correct stopping point in file seq iteration
Date:   Mon, 18 Jan 2021 12:34:35 +0100
Message-Id: <20210118113357.536129977@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Lemon <bsd@fb.com>

[ Upstream commit 69ca310f34168eae0ada434796bfc22fb4a0fa26 ]

On some systems, some variant of the following splat is
repeatedly seen.  The common factor in all traces seems
to be the entry point to task_file_seq_next().  With the
patch, all warnings go away.

    rcu: INFO: rcu_sched self-detected stall on CPU
    rcu: \x0926-....: (20992 ticks this GP) idle=d7e/1/0x4000000000000002 softirq=81556231/81556231 fqs=4876
    \x09(t=21033 jiffies g=159148529 q=223125)
    NMI backtrace for cpu 26
    CPU: 26 PID: 2015853 Comm: bpftool Kdump: loaded Not tainted 5.6.13-0_fbk4_3876_gd8d1f9bf80bb #1
    Hardware name: Quanta Twin Lakes MP/Twin Lakes Passive MP, BIOS F09_3A12 10/08/2018
    Call Trace:
     <IRQ>
     dump_stack+0x50/0x70
     nmi_cpu_backtrace.cold.6+0x13/0x50
     ? lapic_can_unplug_cpu.cold.30+0x40/0x40
     nmi_trigger_cpumask_backtrace+0xba/0xca
     rcu_dump_cpu_stacks+0x99/0xc7
     rcu_sched_clock_irq.cold.90+0x1b4/0x3aa
     ? tick_sched_do_timer+0x60/0x60
     update_process_times+0x24/0x50
     tick_sched_timer+0x37/0x70
     __hrtimer_run_queues+0xfe/0x270
     hrtimer_interrupt+0xf4/0x210
     smp_apic_timer_interrupt+0x5e/0x120
     apic_timer_interrupt+0xf/0x20
     </IRQ>
    RIP: 0010:get_pid_task+0x38/0x80
    Code: 89 f6 48 8d 44 f7 08 48 8b 00 48 85 c0 74 2b 48 83 c6 55 48 c1 e6 04 48 29 f0 74 19 48 8d 78 20 ba 01 00 00 00 f0 0f c1 50 20 <85> d2 74 27 78 11 83 c2 01 78 0c 48 83 c4 08 c3 31 c0 48 83 c4 08
    RSP: 0018:ffffc9000d293dc8 EFLAGS: 00000202 ORIG_RAX: ffffffffffffff13
    RAX: ffff888637c05600 RBX: ffffc9000d293e0c RCX: 0000000000000000
    RDX: 0000000000000001 RSI: 0000000000000550 RDI: ffff888637c05620
    RBP: ffffffff8284eb80 R08: ffff88831341d300 R09: ffff88822ffd8248
    R10: ffff88822ffd82d0 R11: 00000000003a93c0 R12: 0000000000000001
    R13: 00000000ffffffff R14: ffff88831341d300 R15: 0000000000000000
     ? find_ge_pid+0x1b/0x20
     task_seq_get_next+0x52/0xc0
     task_file_seq_get_next+0x159/0x220
     task_file_seq_next+0x4f/0xa0
     bpf_seq_read+0x159/0x390
     vfs_read+0x8a/0x140
     ksys_read+0x59/0xd0
     do_syscall_64+0x42/0x110
     entry_SYSCALL_64_after_hwframe+0x44/0xa9
    RIP: 0033:0x7f95ae73e76e
    Code: Bad RIP value.
    RSP: 002b:00007ffc02c1dbf8 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
    RAX: ffffffffffffffda RBX: 000000000170faa0 RCX: 00007f95ae73e76e
    RDX: 0000000000001000 RSI: 00007ffc02c1dc30 RDI: 0000000000000007
    RBP: 00007ffc02c1ec70 R08: 0000000000000005 R09: 0000000000000006
    R10: fffffffffffff20b R11: 0000000000000246 R12: 00000000019112a0
    R13: 0000000000000000 R14: 0000000000000007 R15: 00000000004283c0

If unable to obtain the file structure for the current task,
proceed to the next task number after the one returned from
task_seq_get_next(), instead of the next task number from the
original iterator.

Also, save the stopping task number from task_seq_get_next()
on failure in case of restarts.

Fixes: eaaacd23910f ("bpf: Add task and task/file iterator targets")
Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20201218185032.2464558-2-jonathan.lemon@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/task_iter.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
index 767c93d38bf55..f3d3a562a802a 100644
--- a/kernel/bpf/task_iter.c
+++ b/kernel/bpf/task_iter.c
@@ -158,13 +158,14 @@ task_file_seq_get_next(struct bpf_iter_seq_task_file_info *info)
 		if (!curr_task) {
 			info->task = NULL;
 			info->files = NULL;
+			info->tid = curr_tid;
 			return NULL;
 		}
 
 		curr_files = get_files_struct(curr_task);
 		if (!curr_files) {
 			put_task_struct(curr_task);
-			curr_tid = ++(info->tid);
+			curr_tid = curr_tid + 1;
 			info->fd = 0;
 			goto again;
 		}
-- 
2.27.0



