Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D39466C60F
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232708AbjAPQOJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:14:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232860AbjAPQNV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:13:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C5A2B633
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:08:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32E85B81085
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:07:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D7B1C433EF;
        Mon, 16 Jan 2023 16:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885277;
        bh=tvsS9YRoXocBA7Ps6OFhobScpHoRh7AjELgpYeXiXbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vZzwwGox9X03XXKsKkmA1Z8lJNlvkiVMmFH+Sn/7URyvKK+MkhIk8w5JloI1rKmYy
         HJlaQKGiI+BoE3Bp52RYRr54SQ0zcMbposIeFCz9dujilHJ2PJ5hyig+7o9901BQQ1
         rQ8b3Z1Cr0O+r8VfM/aFsyHl40ZFyMUCL5HfzdUo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Peter Newman <peternewman@google.com>,
        "Borislav Petkov (AMD)" <bp@alien8.de>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Babu Moger <babu.moger@amd.com>, stable@kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 56/64] x86/resctrl: Fix task CLOSID/RMID update race
Date:   Mon, 16 Jan 2023 16:52:03 +0100
Message-Id: <20230116154745.511604307@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154743.577276578@linuxfoundation.org>
References: <20230116154743.577276578@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Newman <peternewman@google.com>

[ Upstream commit fe1f0714385fbcf76b0cbceb02b7277d842014fc ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/resctrl/rdtgroup.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index f2ad3c117426..ff26de11b3f1 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -577,8 +577,10 @@ static int __rdtgroup_move_task(struct task_struct *tsk,
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
@@ -2313,6 +2315,14 @@ static void rdt_move_group_tasks(struct rdtgroup *from, struct rdtgroup *to,
 			t->closid = to->closid;
 			t->rmid = to->mon.rmid;
 
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
-- 
2.35.1



