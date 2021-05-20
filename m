Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04AAF38A7D5
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235526AbhETKnN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:43:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:44304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237462AbhETKlL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:41:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D21B4613ED;
        Thu, 20 May 2021 09:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504554;
        bh=74VbruHWQHxMKlgB1bYLRa4tnPEeiOMZzjExkT2zFTE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AG4gEQc4uN1i4SjhRcV6XM7x0wxZa0lLIHEVev/R+mpgsyu0esvqOPPJtZbNqM0bn
         Y8ylcFtzGGQUF3xYBjjLPciAmAPsvTOrBStYGQodHzGcmHDS1w9PJL3+JXQyzWw6IB
         2d8o7gE3pJrsmrCEmpkZlCmDijiusKoyJu3nwK8o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Boyer <andrew.boyer@dell.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Doug Ledford <dledford@redhat.com>,
        Edwin Peer <edwin.peer@broadcom.com>
Subject: [PATCH 4.14 298/323] RDMA/i40iw: Avoid panic when reading back the IRQ affinity hint
Date:   Thu, 20 May 2021 11:23:10 +0200
Message-Id: <20210520092130.440323113@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Boyer <andrew.boyer@dell.com>

commit 43731753c4b7d832775cf6b2301dd0447a5a1851 upstream.

The current code sets an affinity hint with a cpumask_t stored on the
stack. This value can then be accessed through /proc/irq/*/affinity_hint/,
causing a segfault or returning corrupt data.

Move the cpumask_t into struct i40iw_msix_vector so it is available later.

Backtrace:
BUG: unable to handle kernel paging request at ffffb16e600e7c90
IP: irq_affinity_hint_proc_show+0x60/0xf0
PGD 17c0c6d067
PUD 17c0c6e067
PMD 15d4a0e067
PTE 0

Oops: 0000 [#1] SMP
Modules linked in: ...
CPU: 3 PID: 172543 Comm: grep Tainted: G           OE   ... #1
Hardware name: ...
task: ffff9a5caee08000 task.stack: ffffb16e659d8000
RIP: 0010:irq_affinity_hint_proc_show+0x60/0xf0
RSP: 0018:ffffb16e659dbd20 EFLAGS: 00010086
RAX: 0000000000000246 RBX: ffffb16e659dbd20 RCX: 0000000000000000
RDX: ffffb16e600e7c90 RSI: 0000000000000003 RDI: 0000000000000046
RBP: ffffb16e659dbd88 R08: 0000000000000038 R09: 0000000000000001
R10: 0000000070803079 R11: 0000000000000000 R12: ffff9a59d1d97a00
R13: ffff9a5da47a6cd8 R14: ffff9a5da47a6c00 R15: ffff9a59d1d97a00
FS:  00007f946c31d740(0000) GS:ffff9a5dc1800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffb16e600e7c90 CR3: 00000016a4339000 CR4: 00000000007406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 seq_read+0x12d/0x430
 ? sched_clock_cpu+0x11/0xb0
 proc_reg_read+0x48/0x70
 __vfs_read+0x37/0x140
 ? security_file_permission+0xa0/0xc0
 vfs_read+0x96/0x140
 SyS_read+0x58/0xc0
 do_syscall_64+0x5a/0x190
 entry_SYSCALL64_slow_path+0x25/0x25
RIP: 0033:0x7f946bbc97e0
RSP: 002b:00007ffdd0c4ae08 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
RAX: ffffffffffffffda RBX: 000000000096b000 RCX: 00007f946bbc97e0
RDX: 000000000096b000 RSI: 00007f946a2f0000 RDI: 0000000000000004
RBP: 0000000000001000 R08: 00007f946a2ef011 R09: 000000000000000a
R10: 0000000000001000 R11: 0000000000000246 R12: 00007f946a2f0000
R13: 0000000000000004 R14: 0000000000000000 R15: 00007f946a2f0000
Code: b9 08 00 00 00 49 89 c6 48 89 df 31 c0 4d 8d ae d8 00 00 00 f3 48 ab 4c 89 ef e8 6c 9a 56 00 49 8b 96 30 01 00 00 48 85 d2 74 3f <48> 8b 0a 48 89 4d 98 48 8b 4a 08 48 89 4d a0 48 8b 4a 10 48 89
RIP: irq_affinity_hint_proc_show+0x60/0xf0 RSP: ffffb16e659dbd20
CR2: ffffb16e600e7c90

Fixes: 8e06af711bf2 ("i40iw: add main, hdr, status")
Signed-off-by: Andrew Boyer <andrew.boyer@dell.com>
Reviewed-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Doug Ledford <dledford@redhat.com>
CC: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/i40iw/i40iw.h      |    1 +
 drivers/infiniband/hw/i40iw/i40iw_main.c |    7 +++----
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/infiniband/hw/i40iw/i40iw.h
+++ b/drivers/infiniband/hw/i40iw/i40iw.h
@@ -210,6 +210,7 @@ struct i40iw_msix_vector {
 	u32 irq;
 	u32 cpu_affinity;
 	u32 ceq_id;
+	cpumask_t mask;
 };
 
 struct l2params_work {
--- a/drivers/infiniband/hw/i40iw/i40iw_main.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_main.c
@@ -676,7 +676,6 @@ static enum i40iw_status_code i40iw_conf
 							 struct i40iw_msix_vector *msix_vec)
 {
 	enum i40iw_status_code status;
-	cpumask_t mask;
 
 	if (iwdev->msix_shared && !ceq_id) {
 		tasklet_init(&iwdev->dpc_tasklet, i40iw_dpc, (unsigned long)iwdev);
@@ -686,9 +685,9 @@ static enum i40iw_status_code i40iw_conf
 		status = request_irq(msix_vec->irq, i40iw_ceq_handler, 0, "CEQ", iwceq);
 	}
 
-	cpumask_clear(&mask);
-	cpumask_set_cpu(msix_vec->cpu_affinity, &mask);
-	irq_set_affinity_hint(msix_vec->irq, &mask);
+	cpumask_clear(&msix_vec->mask);
+	cpumask_set_cpu(msix_vec->cpu_affinity, &msix_vec->mask);
+	irq_set_affinity_hint(msix_vec->irq, &msix_vec->mask);
 
 	if (status) {
 		i40iw_pr_err("ceq irq config fail\n");


