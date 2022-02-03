Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 304DF4A887F
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 17:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234920AbiBCQTX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 11:19:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352179AbiBCQTW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 11:19:22 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C1D7C061401
        for <stable@vger.kernel.org>; Thu,  3 Feb 2022 08:19:22 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id r59so2856386pjg.4
        for <stable@vger.kernel.org>; Thu, 03 Feb 2022 08:19:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iGBChkCWnTbgPPOBwN9awx2yKgQkcYggUtrAhJJ2gIM=;
        b=us5jN9fEnyeMy/verfBT3tD3AWIdjrGlWPuNTbhCanmymdv/y41nLY97O0DwD1KqzE
         wIRiAz+FP638+ylzqYzE1p6vqHSeun3TTmX8MRjCavGSShkai5SAsiujZ0DwnKejkWTp
         k4hfSlrK9jfTXzffHtbZCENT/ozSWj3T9aCvaytBPZ/qaK1NgRsiGdXVMzQMohllRsAx
         UyrKRR9fvdV12y47JS/tOVZMPFHLd4kc8SM+xJxrEOagQiO8swILyuGhho7cXOP9e/dr
         drTDnw0HtmDTYvw3mHXqo1zfo5PwX5mtG5sq8fgLJXj97hMrHjL5kiYENrGICZUq3Ctr
         N3TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iGBChkCWnTbgPPOBwN9awx2yKgQkcYggUtrAhJJ2gIM=;
        b=2Y9BIYl9oI9orh535o0tvqiU/k5NJR2MoRPSrYREn+Y9id/lZHU71+DFlshvr/15by
         GqcSnWZkiiW2bS0dBRY9vD1ii3aH9jvw0DbGMBTz5sPAphXWi1bHXLF3+jUsbHJI69rL
         VgD/prBxxkr4lW7EMvFv9DyAYYBj5QRbg6Om+0Dwl8KgE5uTmYUPmD3YyKd/02fZ4kuN
         ExVDC5/ZPZiVcQigbiIVprdP6xp7iZP/ORNAPeTgac5GSd3jA8w+h0vxj3B3LmfMyRKW
         6uKkPYy85SUXdXcxjWmTx7rVVTRbguUBlutV0Nu9nBllADJPBnjimyd0A+ne4lcjqDUN
         wFVg==
X-Gm-Message-State: AOAM531qJZtPD2vGdms087JV7JRsuvqxwTwFemdtngKTY4hMjoh/WaTQ
        sIYJXv0VdgrvzTl4TZ0om0Yh6A==
X-Google-Smtp-Source: ABdhPJzssGkXnHCtK3/m+umnyySPBdzHipEA8Y87gniVoV+4o5ha2kz0HYBz+8HkLRdDkHW+XKZIXQ==
X-Received: by 2002:a17:90a:564f:: with SMTP id d15mr14604221pji.238.1643905162124;
        Thu, 03 Feb 2022 08:19:22 -0800 (PST)
Received: from localhost.localdomain ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id o5sm30525001pfk.172.2022.02.03.08.19.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 08:19:21 -0800 (PST)
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
To:     peterz@infradead.org
Cc:     Tadeusz Struk <tadeusz.struk@linaro.org>,
        Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Zhang Qiao <zhangqiao22@huawei.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+af7a719bc92395ee41b3@syzkaller.appspotmail.com
Subject: [PATCH v5] sched/fair: Fix fault in reweight_entity
Date:   Thu,  3 Feb 2022 08:18:46 -0800
Message-Id: <20220203161846.1160750-1-tadeusz.struk@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Syzbot found a GPF in reweight_entity. This has been bisected to commit
4ef0c5c6b5ba ("kernel/sched: Fix sched_fork() access an invalid sched_task_group")

There is a race between sched_post_fork() and setpriority(PRIO_PGRP)
within a thread group that causes a null-ptr-deref in reweight_entity()
in CFS. The scenario is that the main process spawns number of new
threads, which then call setpriority(PRIO_PGRP, 0, -20), wait, and exit.
For each of the new threads the copy_process() gets invoked, which adds
the new task_struct and calls sched_post_fork() for it.

In the above scenario there is a possibility that setpriority(PRIO_PGRP)
and set_one_prio() will be called for a thread in the group that is just
being created by copy_process(), and for which the sched_post_fork() has
not been executed yet. This will trigger a null pointer dereference in
reweight_entity(), as it will try to access the run queue pointer, which
hasn't been set. This results it a crash as shown below:

KASAN: null-ptr-deref in range [0x00000000000000a0-0x00000000000000a7]
CPU: 0 PID: 2392 Comm: reduced_repro Not tainted 5.16.0-11201-gb42c5a161ea3
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1.fc35
RIP: 0010:reweight_entity+0x15d/0x440
RSP: 0018:ffffc900035dfcf8 EFLAGS: 00010006
Call Trace:
<TASK>
reweight_task+0xde/0x1c0
set_load_weight+0x21c/0x2b0
set_user_nice.part.0+0x2d1/0x519
set_user_nice.cold+0x8/0xd
set_one_prio+0x24f/0x263
__do_sys_setpriority+0x2d3/0x640
__x64_sys_setpriority+0x84/0x8b
do_syscall_64+0x35/0xb0
entry_SYSCALL_64_after_hwframe+0x44/0xae
</TASK>
---[ end trace 9dc80a9d378ed00a ]---

Before the mentioned change the cfs_rq pointer for the task  has been
set in sched_fork(), which is called much earlier in copy_process(),
before the new task is added to the thread_group.
Now it is done in the sched_post_fork(), which is called after that.
To fix the issue the remove the update_load param from the
update_load param() function and call reweight_task() only if the task
flag doesn't have the TASK_NEW flag set.

Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ben Segall <bsegall@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Daniel Bristot de Oliveira <bristot@redhat.com>
Cc: Zhang Qiao <zhangqiao22@huawei.com>
Cc: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

Link: https://syzkaller.appspot.com/bug?id=9d9c27adc674e3a7932b22b61c79a02da82cbdc1
Fixes: 4ef0c5c6b5ba ("kernel/sched: Fix sched_fork() access an invalid sched_task_group")
Reported-by: syzbot+af7a719bc92395ee41b3@syzkaller.appspotmail.com
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
---
Changes in v5:
- Changed the order of local variables declaration in set_load_weight
  to comply with the coding standard

Changes in v4:
- Removed the update_load param from set_load_weight() and call
  reweight_task() based on the TASK_NEW flag

Changes in v3:
- Removed the new check and changed the update_load condition from
  always true to true if p->state != TASK_NEW

Changes in v2:
- Added a check in set_user_nice(), and return from there if the task
  is not fully setup instead of returning from reweight_entity()
---
 kernel/sched/core.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 848eaa0efe0e..fcf0c180617c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1214,8 +1214,9 @@ int tg_nop(struct task_group *tg, void *data)
 }
 #endif
 
-static void set_load_weight(struct task_struct *p, bool update_load)
+static void set_load_weight(struct task_struct *p)
 {
+	bool update_load = !(READ_ONCE(p->__state) & TASK_NEW);
 	int prio = p->static_prio - MAX_RT_PRIO;
 	struct load_weight *load = &p->se.load;
 
@@ -4406,7 +4407,7 @@ int sched_fork(unsigned long clone_flags, struct task_struct *p)
 			p->static_prio = NICE_TO_PRIO(0);
 
 		p->prio = p->normal_prio = p->static_prio;
-		set_load_weight(p, false);
+		set_load_weight(p);
 
 		/*
 		 * We don't need the reset flag anymore after the fork. It has
@@ -6921,7 +6922,7 @@ void set_user_nice(struct task_struct *p, long nice)
 		put_prev_task(rq, p);
 
 	p->static_prio = NICE_TO_PRIO(nice);
-	set_load_weight(p, true);
+	set_load_weight(p);
 	old_prio = p->prio;
 	p->prio = effective_prio(p);
 
@@ -7212,7 +7213,7 @@ static void __setscheduler_params(struct task_struct *p,
 	 */
 	p->rt_priority = attr->sched_priority;
 	p->normal_prio = normal_prio(p);
-	set_load_weight(p, true);
+	set_load_weight(p);
 }
 
 /*
@@ -9445,7 +9446,7 @@ void __init sched_init(void)
 #endif
 	}
 
-	set_load_weight(&init_task, false);
+	set_load_weight(&init_task);
 
 	/*
 	 * The boot idle thread does lazy MMU switching as well:
-- 
2.34.1

