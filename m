Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA2C66B187
	for <lists+stable@lfdr.de>; Sun, 15 Jan 2023 15:31:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbjAOObG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Jan 2023 09:31:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbjAOObF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Jan 2023 09:31:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 381514C0B
        for <stable@vger.kernel.org>; Sun, 15 Jan 2023 06:31:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0C46B80B66
        for <stable@vger.kernel.org>; Sun, 15 Jan 2023 14:31:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24883C433EF;
        Sun, 15 Jan 2023 14:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673793061;
        bh=OyvCG0ZcEVL8oeRsOspMU9NUJMfwfk3fo1IpBCQyYRs=;
        h=Subject:To:Cc:From:Date:From;
        b=hfUCSPbZ7gvJ+ExizHboeta6vYO5oanqnNPyM0za+3Q0CccAwLNB0FwCm53UTdBVz
         9CZsMtW+BUwbQMGxKyUVLGPOq0QwJpEsl9nrDPzqWLMbviIDKuMbih2Y1a0TKPXcwp
         xgiRN8FNrD3VleVZHJKfG1bcec1tn2w8Zm2XWBi0=
Subject: FAILED: patch "[PATCH] x86/resctrl: Fix task CLOSID/RMID update race" failed to apply to 4.14-stable tree
To:     peternewman@google.com, babu.moger@amd.com, bp@alien8.de,
        reinette.chatre@intel.com, stable@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 15 Jan 2023 15:30:45 +0100
Message-ID: <16737930455346@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

fe1f0714385f ("x86/resctrl: Fix task CLOSID/RMID update race")
e0ad6dc8969f ("x86/resctrl: Use task_curr() instead of task_struct->on_cpu to prevent unnecessary IPI")
ae28d1aae48a ("x86/resctrl: Use an IPI instead of task_work_add() to update PQR_ASSOC MSR")
758999246965 ("x86/resctrl: Add necessary kernfs_put() calls to prevent refcount leak")
fd8d9db3559a ("x86/resctrl: Remove superfluous kernfs_get() calls to prevent refcount leak")
91989c707884 ("task_work: cleanup notification modes")
216578e55ac9 ("io_uring: fix REQ_F_COMP_LOCKED by killing it")
4edf20f99902 ("io_uring: dig out COMP_LOCK from deep call chain")
b1b74cfc1967 ("io_uring: don't unnecessarily clear F_LINK_TIMEOUT")
6ad4bf6ea160 ("Merge tag 'io_uring-5.10-2020-10-12' of git://git.kernel.dk/linux-block")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From fe1f0714385fbcf76b0cbceb02b7277d842014fc Mon Sep 17 00:00:00 2001
From: Peter Newman <peternewman@google.com>
Date: Tue, 20 Dec 2022 17:11:23 +0100
Subject: [PATCH] x86/resctrl: Fix task CLOSID/RMID update race

When the user moves a running task to a new rdtgroup using the task's
file interface or by deleting its rdtgroup, the resulting change in
CLOSID/RMID must be immediately propagated to the PQR_ASSOC MSR on the
task(s) CPUs.

x86 allows reordering loads with prior stores, so if the task starts
running between a task_curr() check that the CPU hoisted before the
stores in the CLOSID/RMID update then it can start running with the old
CLOSID/RMID until it is switched again because __rdtgroup_move_task()
failed to determine that it needs to be interrupted to obtain the new
CLOSID/RMID.

Refer to the diagram below:

CPU 0                                   CPU 1
-----                                   -----
__rdtgroup_move_task():
  curr <- t1->cpu->rq->curr
                                        __schedule():
                                          rq->curr <- t1
                                        resctrl_sched_in():
                                          t1->{closid,rmid} -> {1,1}
  t1->{closid,rmid} <- {2,2}
  if (curr == t1) // false
   IPI(t1->cpu)

A similar race impacts rdt_move_group_tasks(), which updates tasks in a
deleted rdtgroup.

In both cases, use smp_mb() to order the task_struct::{closid,rmid}
stores before the loads in task_curr().  In particular, in the
rdt_move_group_tasks() case, simply execute an smp_mb() on every
iteration with a matching task.

It is possible to use a single smp_mb() in rdt_move_group_tasks(), but
this would require two passes and a means of remembering which
task_structs were updated in the first loop. However, benchmarking
results below showed too little performance impact in the simple
approach to justify implementing the two-pass approach.

Times below were collected using `perf stat` to measure the time to
remove a group containing a 1600-task, parallel workload.

CPU: Intel(R) Xeon(R) Platinum P-8136 CPU @ 2.00GHz (112 threads)

  # mkdir /sys/fs/resctrl/test
  # echo $$ > /sys/fs/resctrl/test/tasks
  # perf bench sched messaging -g 40 -l 100000

task-clock time ranges collected using:

  # perf stat rmdir /sys/fs/resctrl/test

Baseline:                     1.54 - 1.60 ms
smp_mb() every matching task: 1.57 - 1.67 ms

  [ bp: Massage commit message. ]

Fixes: ae28d1aae48a ("x86/resctrl: Use an IPI instead of task_work_add() to update PQR_ASSOC MSR")
Fixes: 0efc89be9471 ("x86/intel_rdt: Update task closid immediately on CPU in rmdir and unmount")
Signed-off-by: Peter Newman <peternewman@google.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Babu Moger <babu.moger@amd.com>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/r/20221220161123.432120-1-peternewman@google.com

diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index e5a48f05e787..5993da21d822 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -580,8 +580,10 @@ static int __rdtgroup_move_task(struct task_struct *tsk,
 	/*
 	 * Ensure the task's closid and rmid are written before determining if
 	 * the task is current that will decide if it will be interrupted.
+	 * This pairs with the full barrier between the rq->curr update and
+	 * resctrl_sched_in() during context switch.
 	 */
-	barrier();
+	smp_mb();
 
 	/*
 	 * By now, the task's closid and rmid are set. If the task is current
@@ -2401,6 +2403,14 @@ static void rdt_move_group_tasks(struct rdtgroup *from, struct rdtgroup *to,
 			WRITE_ONCE(t->closid, to->closid);
 			WRITE_ONCE(t->rmid, to->mon.rmid);
 
+			/*
+			 * Order the closid/rmid stores above before the loads
+			 * in task_curr(). This pairs with the full barrier
+			 * between the rq->curr update and resctrl_sched_in()
+			 * during context switch.
+			 */
+			smp_mb();
+
 			/*
 			 * If the task is on a CPU, set the CPU in the mask.
 			 * The detection is inaccurate as tasks might move or

