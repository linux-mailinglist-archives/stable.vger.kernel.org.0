Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDCD549552B
	for <lists+stable@lfdr.de>; Thu, 20 Jan 2022 21:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377518AbiATUB6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jan 2022 15:01:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377500AbiATUB6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jan 2022 15:01:58 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9F61C061574
        for <stable@vger.kernel.org>; Thu, 20 Jan 2022 12:01:57 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id r11so6195651pgr.6
        for <stable@vger.kernel.org>; Thu, 20 Jan 2022 12:01:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TinsR6fwhbMn8mnFX1YE59uVnDN8ArT+vYrOu2Poyew=;
        b=ZjLrcQEGPB04NxTW8f2C5j3T6ETKzqiv0H2LBpfT9SPGbhQTy8pUeaWxA+LqhCWBjh
         GQxpBsa8eq5HEnqF+rOxMh6h8L76HVeYRGdP7R3h8XdDJAMC9oDiJOi4CwcHZ234EDiO
         46MKayb5qnUAcZTpWf7nfhCf2bQA2OeyXoFlD1onxqzIvCmPuCMZoyU7FvRj/BOxNVXb
         q3xluIKFUs6JJzopkpJDZmFNOf6HXQ6hIUY9ACx2sOJyVGQzSOTGY0rIsk10sDD3yBSL
         AfO8r68v0QrLo5sJCtUG9ObailBZiaI62+lc+XoViYMyV5djv8ACAAOyFPzJK7IH+EsG
         ExpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TinsR6fwhbMn8mnFX1YE59uVnDN8ArT+vYrOu2Poyew=;
        b=H3EuebLEC2qU6Ne4E9aZ+/Dgtdhn4/PhhjPn8XIcDFj5UyndZsajLmJLGWhmAsNxdF
         4wObPCa0TNXLoQCPs3ANoFLC8YcWj57UevmlI49zOFhPp/O4xijxw1HeJaN6DN4LrHvm
         BrseckWudu7Obqwj5hncOdj84+DRqHA8PtOsutaaW1DvJsoig19X+QtXh3soku45V9oh
         Y2daPm3wwA/KoMsYmwKGM41XQONO8waH+qN2kLlCc8my+vwAxt0cEh3c3imomLfLRKw+
         ZVwwW6phutWXmjlANiQD5WhRYjduZj+JvFeBU8CSrj/QyB+lziZS8kJrAMdEeIkdWlrr
         LCWw==
X-Gm-Message-State: AOAM533sazdMwJJj+53WzU5QbfFm6m5rWrH6rRCLODIO/RCTv/xd/fQD
        TUHK2Xrf41ywJ4vxP4c0NnD0nw==
X-Google-Smtp-Source: ABdhPJxBGzyGMNzupDgYFLIBpsDmpYwNhvD/X4HuX6a01w/mLd74reeYcK4cSwfdQnRitfb5IwWXLg==
X-Received: by 2002:a63:774c:: with SMTP id s73mr280660pgc.473.1642708917266;
        Thu, 20 Jan 2022 12:01:57 -0800 (PST)
Received: from localhost.localdomain ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id n26sm638089pgf.49.2022.01.20.12.01.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 12:01:56 -0800 (PST)
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
Subject: [PATCH v2] sched/fair: Fix fault in reweight_entity
Date:   Thu, 20 Jan 2022 12:01:39 -0800
Message-Id: <20220120200139.118978-1-tadeusz.struk@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Syzbot found a GPF in reweight_entity(). This has been bisected to commit
4ef0c5c6b5ba ("kernel/sched: Fix sched_fork() access an invalid sched_task_group")

There is a race between sched_post_fork() and setpriority(PRIO_PGRP)
within a thread group that causes a null-ptr-deref in reweight_entity()
in CFS. The scenario is that the main process spawns number of new
threads, which then call setpriority(PRIO_PGRP, 0, prio), wait, and exit.
For each of the new threads the copy_process() gets invoked, which adds
the new task_struct to the group, and eventually calls sched_post_fork() for it.

In the above scenario there is a possibility that setpriority(PRIO_PGRP)
and set_one_prio() will be called for a thread in the group that is just
being created by copy_process(), and for which the sched_post_fork() has
not been executed yet. This will trigger a null pointer dereference in
reweight_entity(), as it will try to access the run queue pointer, which
hasn't been set. This results it a crash as shown below:

KASAN: null-ptr-deref in range [0x00000000000000a0-0x00000000000000a7]
CPU: 0 PID: 2392 Comm: reduced_repro Not tainted 5.16.0-11201-gb42c5a161ea3
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1.fc35 04/01/2014
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
Now it is done in the sched_post_fork(), which is called after that.

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
Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
---
Changes in v2:
- Added a check in set_user_nice(), and return from there if the task
  is not fully setup instead of returning from reweight_entity()
---
 kernel/sched/core.c  |  4 ++++
 kernel/sched/sched.h | 11 +++++++++++
 2 files changed, 15 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 2e4ae00e52d1..c3e74b6d595b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6897,6 +6897,10 @@ void set_user_nice(struct task_struct *p, long nice)
 
 	if (task_nice(p) == nice || nice < MIN_NICE || nice > MAX_NICE)
 		return;
+
+	/* Check if the task's schedule run queue is setup correctly */
+	if (!task_rq_ready(p))
+		return;
 	/*
 	 * We have to be careful, if called from sys_setpriority(),
 	 * the task might be in the middle of scheduling on another CPU.
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index de53be905739..464f629bff5a 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1394,6 +1394,12 @@ static inline struct cfs_rq *group_cfs_rq(struct sched_entity *grp)
 	return grp->my_q;
 }
 
+/* returns true if cfs run queue is set for the task */
+static inline bool task_rq_ready(struct task_struct *p)
+{
+	return !!task_cfs_rq(p);
+}
+
 #else
 
 static inline struct task_struct *task_of(struct sched_entity *se)
@@ -1419,6 +1425,11 @@ static inline struct cfs_rq *group_cfs_rq(struct sched_entity *grp)
 {
 	return NULL;
 }
+
+static inline bool task_rq_ready(struct task_struct *p)
+{
+	return true;
+}
 #endif
 
 extern void update_rq_clock(struct rq *rq);
-- 
2.34.1

