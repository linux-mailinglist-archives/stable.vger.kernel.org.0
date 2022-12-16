Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76E6364EC22
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 14:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiLPNbh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 08:31:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230413AbiLPNbb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 08:31:31 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 968201A807
        for <stable@vger.kernel.org>; Fri, 16 Dec 2022 05:31:30 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-410f1a84ed2so28336707b3.15
        for <stable@vger.kernel.org>; Fri, 16 Dec 2022 05:31:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mGkn4hSq2I1CrIC6jits2ZltjIfFLPapjY5ehR6Imtg=;
        b=em04It3V5ypOLrAQENzwgihctcJkIQbrcrYLF3PbrSYR7jBxMNXFItI7e1Gfx1/cVU
         aer6JQvyR1i/+p8d/r1iyZDwENn5RAG7wv1aausS2BIBHVuoaopYLYJyzfJD+HF/l+ix
         m6c6vRrBTjerzCE5FiCcHP2U29cvkQI1u5DhxGLqi+JEZnOTYkNE4CDWf5/bAZgb6+nb
         pnz4Tg9nPwrOfJrBxNh0iaMqlO9MIyKDpnCdIGZic9m6oUI8qiUgcOrf7HpMhwwL4Ich
         F0jENiesiGToTgV556Q8RnsPG9bmFctdiDSEtCejU8OWkzmNO54eUEtRwF7RxbN0ck8m
         MwGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mGkn4hSq2I1CrIC6jits2ZltjIfFLPapjY5ehR6Imtg=;
        b=zIIEbumcb1cmhxTIgUk0mL5Lhq4nhA2lCC0OvGPY0LkUCzxLtWPH3p0o9P3vOy+V74
         mnOcJXDdMlsK8NcSd71jMaSmXxSjVtdXm98K2lIZDAabwW+92h6bIvXaqMMi8BMpfefK
         aKO2L7pE6o17JITv2uknAwTjfgPXiVmIwhfcplRMc4rbmHJJm5DXhQnQALkxpK4JdYzm
         Y0+fKcfI/9EzYmMpXj4q9y+SKE+VGqVx3pbwYfD3inD+eap+Cmcr7CyA/UHvkuydNc6a
         GyaZa2JaJKHBWUSLFXfkSAaSmBBx9MzYHK4TzvhNyU3vgN3Xm3q+9mLm5aj6pQ0om2yG
         rsww==
X-Gm-Message-State: ANoB5pkRnqeik+6GygDvbV7JkPwx0Fe5ZAkIrKUG64xGSXhc568z0RRd
        TMGQmnFANa5r7g6HRuzW/mYEckee+T17n0Algw==
X-Google-Smtp-Source: AA0mqf7wJg7bCXK5M5geSxw1lvEY7MrWbroWjCOngpadjn4N95aS+wxgdXR+o6NKvvr6/7/P18Mfnf0QLsQ5LAShSQ==
X-Received: from peternewman10.zrh.corp.google.com ([2a00:79e0:9d:6:996f:f64e:1a0c:cc8c])
 (user=peternewman job=sendgmr) by 2002:a0d:f7c4:0:b0:370:2d8c:8193 with SMTP
 id h187-20020a0df7c4000000b003702d8c8193mr8573031ywf.221.1671197489843; Fri,
 16 Dec 2022 05:31:29 -0800 (PST)
Date:   Fri, 16 Dec 2022 14:31:25 +0100
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221216133125.3159406-1-peternewman@google.com>
Subject: [PATCH v6] x86/resctrl: Fix task CLOSID/RMID update race
From:   Peter Newman <peternewman@google.com>
To:     reinette.chatre@intel.com, fenghua.yu@intel.com
Cc:     bp@alien8.de, derkling@google.com, eranian@google.com,
        hpa@zytor.com, james.morse@arm.com, jannh@google.com,
        kpsingh@google.com, linux-kernel@vger.kernel.org, mingo@redhat.com,
        tglx@linutronix.de, x86@kernel.org,
        Peter Newman <peternewman@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When the user moves a running task to a new rdtgroup using the tasks
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

In a memory bandwidth-metered compute host, malicious jobs could exploit
this race to remain in a previous CLOSID or RMID in order to dodge a
class-of-service downgrade imposed by an admin or to steal bandwidth.

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

Fixes: ae28d1aae48a ("x86/resctrl: Use an IPI instead of task_work_add() to update PQR_ASSOC MSR")
Fixes: 0efc89be9471 ("x86/intel_rdt: Update task closid immediately on CPU in rmdir and unmount")
Signed-off-by: Peter Newman <peternewman@google.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Cc: stable@vger.kernel.org
---
Patch history:

v6:
 - Explain exploit case in changelog for stable
 - Add Fixes: lines
v5:
 - Just put an smp_mb() between CLOSID/RMID stores and task_curr() calls
 - Add a diagram detailing the race to the changelog
v4:
 - Reorder the patches so that justification for sending more IPIs can
   reference the patch fixing __rdtgroup_move_task().
 - Correct tense of wording used in changelog and comments
v3:
 - Split the handling of multi-task and single-task operations into
   separate patches, now that they're handled differently.
 - Clarify justification in the commit message, including moving some of
   it out of inline code comment.
v2:
 - Following Reinette's suggestion: use task_call_func() for single
   task, IPI broadcast for group movements.
 - Rebased to v6.1-rc4

v1: https://lore.kernel.org/lkml/20221103141641.3055981-1-peternewman@google.com/
v2: https://lore.kernel.org/lkml/20221110135346.2209839-1-peternewman@google.com/
v3: https://lore.kernel.org/lkml/20221115141953.816851-1-peternewman@google.com/
v4: https://lore.kernel.org/lkml/20221129111055.953833-1-peternewman@google.com/
v5: https://lore.kernel.org/lkml/20221214114447.1935755-1-peternewman@google.com/

---
 arch/x86/kernel/cpu/resctrl/rdtgroup.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

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

base-commit: 830b3c68c1fb1e9176028d02ef86f3cf76aa2476
--
2.39.0.314.g84b9a713c41-goog

