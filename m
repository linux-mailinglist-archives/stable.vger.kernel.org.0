Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB15A24F824
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730106AbgHXIwi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:52:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:58798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730096AbgHXIwb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:52:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCE35204FD;
        Mon, 24 Aug 2020 08:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598259150;
        bh=Ugp5lYXLez/YXQk+NIdZCZFpUpaFzz9EnvVK/Mz/9/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FThjYJu80c3+APTjDJtimhguCryfGbH7fU6EKjLxMpzRfTkrm4RTJQzTjKp0ANZ87
         8tZGWeudqw+amd2fb3aUqEnLyqwgBiTMd39v8WaceObJoH98MTIGWbkX1CkUC12rsp
         AIgNp08QEIFMcDfXrVirWpEL/4x4Yzbj4ZdiMbvM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sarah Newman <srn@prgmr.com>, Juergen Gross <jgross@suse.com>,
        Chris Brannon <cmb@prgmr.com>
Subject: [PATCH 4.9 39/39] xen: dont reschedule in preemption off sections
Date:   Mon, 24 Aug 2020 10:31:38 +0200
Message-Id: <20200824082350.536997077@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082348.445866152@linuxfoundation.org>
References: <20200824082348.445866152@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

For support of long running hypercalls xen_maybe_preempt_hcall() is
calling cond_resched() in case a hypercall marked as preemptible has
been interrupted.

Normally this is no problem, as only hypercalls done via some ioctl()s
are marked to be preemptible. In rare cases when during such a
preemptible hypercall an interrupt occurs and any softirq action is
started from irq_exit(), a further hypercall issued by the softirq
handler will be regarded to be preemptible, too. This might lead to
rescheduling in spite of the softirq handler potentially having set
preempt_disable(), leading to splats like:

BUG: sleeping function called from invalid context at drivers/xen/preempt.c:37
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 20775, name: xl
INFO: lockdep is turned off.
CPU: 1 PID: 20775 Comm: xl Tainted: G D W 5.4.46-1_prgmr_debug.el7.x86_64 #1
Call Trace:
<IRQ>
dump_stack+0x8f/0xd0
___might_sleep.cold.76+0xb2/0x103
xen_maybe_preempt_hcall+0x48/0x70
xen_do_hypervisor_callback+0x37/0x40
RIP: e030:xen_hypercall_xen_version+0xa/0x20
Code: ...
RSP: e02b:ffffc900400dcc30 EFLAGS: 00000246
RAX: 000000000004000d RBX: 0000000000000200 RCX: ffffffff8100122a
RDX: ffff88812e788000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffffff83ee3ad0 R08: 0000000000000001 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000246 R12: ffff8881824aa0b0
R13: 0000000865496000 R14: 0000000865496000 R15: ffff88815d040000
? xen_hypercall_xen_version+0xa/0x20
? xen_force_evtchn_callback+0x9/0x10
? check_events+0x12/0x20
? xen_restore_fl_direct+0x1f/0x20
? _raw_spin_unlock_irqrestore+0x53/0x60
? debug_dma_sync_single_for_cpu+0x91/0xc0
? _raw_spin_unlock_irqrestore+0x53/0x60
? xen_swiotlb_sync_single_for_cpu+0x3d/0x140
? mlx4_en_process_rx_cq+0x6b6/0x1110 [mlx4_en]
? mlx4_en_poll_rx_cq+0x64/0x100 [mlx4_en]
? net_rx_action+0x151/0x4a0
? __do_softirq+0xed/0x55b
? irq_exit+0xea/0x100
? xen_evtchn_do_upcall+0x2c/0x40
? xen_do_hypervisor_callback+0x29/0x40
</IRQ>
? xen_hypercall_domctl+0xa/0x20
? xen_hypercall_domctl+0x8/0x20
? privcmd_ioctl+0x221/0x990 [xen_privcmd]
? do_vfs_ioctl+0xa5/0x6f0
? ksys_ioctl+0x60/0x90
? trace_hardirqs_off_thunk+0x1a/0x20
? __x64_sys_ioctl+0x16/0x20
? do_syscall_64+0x62/0x250
? entry_SYSCALL_64_after_hwframe+0x49/0xbe

Fix that by testing preempt_count() before calling cond_resched().

In kernel 5.8 this can't happen any more due to the entry code rework
(more than 100 patches, so not a candidate for backporting).

The issue was introduced in kernel 4.3, so this patch should go into
all stable kernels in [4.3 ... 5.7].

Reported-by: Sarah Newman <srn@prgmr.com>
Fixes: 0fa2f5cb2b0ecd8 ("sched/preempt, xen: Use need_resched() instead of should_resched()")
Cc: Sarah Newman <srn@prgmr.com>
Cc: stable@vger.kernel.org
Signed-off-by: Juergen Gross <jgross@suse.com>
Tested-by: Chris Brannon <cmb@prgmr.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/preempt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/xen/preempt.c
+++ b/drivers/xen/preempt.c
@@ -31,7 +31,7 @@ EXPORT_SYMBOL_GPL(xen_in_preemptible_hca
 asmlinkage __visible void xen_maybe_preempt_hcall(void)
 {
 	if (unlikely(__this_cpu_read(xen_in_preemptible_hcall)
-		     && need_resched())) {
+		     && need_resched() && !preempt_count())) {
 		/*
 		 * Clear flag as we may be rescheduled on a different
 		 * cpu.


