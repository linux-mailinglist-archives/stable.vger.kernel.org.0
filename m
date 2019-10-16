Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B343DD9F55
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437706AbfJPVyT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:54:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:44064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388866AbfJPVyS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:54:18 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6B5C21A4C;
        Wed, 16 Oct 2019 21:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262858;
        bh=kYzjHFeSJmYMO6kYfEMX+vU+jy9Iq1brizrumZUAVe8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=voKsnQzKq7FrAGwg4J1S3QS2RRSzqJbF6V/pc4uYxL6JCLJ9r9jUFxRbBbCSQeEOz
         GjQGCsEIxARygVMbcaOKOCmc5FlojKJ6KJ9h7tFF5GAs3mXi4iUAZBNNqEEZObZAL1
         S589xn1Ah640MvQbnfbva/mY5mYqpsvGCJ5DM5xI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, KeMeng Shi <shikemeng@huawei.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 24/92] sched/core: Fix migration to invalid CPU in __set_cpus_allowed_ptr()
Date:   Wed, 16 Oct 2019 14:49:57 -0700
Message-Id: <20191016214819.797335164@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214759.600329427@linuxfoundation.org>
References: <20191016214759.600329427@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: KeMeng Shi <shikemeng@huawei.com>

[ Upstream commit 714e501e16cd473538b609b3e351b2cc9f7f09ed ]

An oops can be triggered in the scheduler when running qemu on arm64:

 Unable to handle kernel paging request at virtual address ffff000008effe40
 Internal error: Oops: 96000007 [#1] SMP
 Process migration/0 (pid: 12, stack limit = 0x00000000084e3736)
 pstate: 20000085 (nzCv daIf -PAN -UAO)
 pc : __ll_sc___cmpxchg_case_acq_4+0x4/0x20
 lr : move_queued_task.isra.21+0x124/0x298
 ...
 Call trace:
  __ll_sc___cmpxchg_case_acq_4+0x4/0x20
  __migrate_task+0xc8/0xe0
  migration_cpu_stop+0x170/0x180
  cpu_stopper_thread+0xec/0x178
  smpboot_thread_fn+0x1ac/0x1e8
  kthread+0x134/0x138
  ret_from_fork+0x10/0x18

__set_cpus_allowed_ptr() will choose an active dest_cpu in affinity mask to
migrage the process if process is not currently running on any one of the
CPUs specified in affinity mask. __set_cpus_allowed_ptr() will choose an
invalid dest_cpu (dest_cpu >= nr_cpu_ids, 1024 in my virtual machine) if
CPUS in an affinity mask are deactived by cpu_down after cpumask_intersects
check. cpumask_test_cpu() of dest_cpu afterwards is overflown and may pass if
corresponding bit is coincidentally set. As a consequence, kernel will
access an invalid rq address associate with the invalid CPU in
migration_cpu_stop->__migrate_task->move_queued_task and the Oops occurs.

The reproduce the crash:

  1) A process repeatedly binds itself to cpu0 and cpu1 in turn by calling
  sched_setaffinity.

  2) A shell script repeatedly does "echo 0 > /sys/devices/system/cpu/cpu1/online"
  and "echo 1 > /sys/devices/system/cpu/cpu1/online" in turn.

  3) Oops appears if the invalid CPU is set in memory after tested cpumask.

Signed-off-by: KeMeng Shi <shikemeng@huawei.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Valentin Schneider <valentin.schneider@arm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/1568616808-16808-1-git-send-email-shikemeng@huawei.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 63be0bcfa286d..82cec9a666e7b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1162,7 +1162,8 @@ static int __set_cpus_allowed_ptr(struct task_struct *p,
 	if (cpumask_equal(&p->cpus_allowed, new_mask))
 		goto out;
 
-	if (!cpumask_intersects(new_mask, cpu_valid_mask)) {
+	dest_cpu = cpumask_any_and(cpu_valid_mask, new_mask);
+	if (dest_cpu >= nr_cpu_ids) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -1183,7 +1184,6 @@ static int __set_cpus_allowed_ptr(struct task_struct *p,
 	if (cpumask_test_cpu(task_cpu(p), new_mask))
 		goto out;
 
-	dest_cpu = cpumask_any_and(cpu_valid_mask, new_mask);
 	if (task_running(rq, p) || p->state == TASK_WAKING) {
 		struct migration_arg arg = { p, dest_cpu };
 		/* Need help from migration thread: drop lock and wait. */
-- 
2.20.1



