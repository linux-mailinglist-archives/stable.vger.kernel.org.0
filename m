Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3C8648A82A
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 08:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234736AbiAKHMR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 02:12:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234167AbiAKHMR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 02:12:17 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B444C061751
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 23:12:17 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id k130-20020a255688000000b0060c3dcae580so31905985ybb.6
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 23:12:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=gL02OzoXrEvS6yM+RCCZvdaq2BmYF8okPdc8VL1LbQI=;
        b=oyeJrIAAK1yheh7kW1CD5A8TyJNkBJfNBJil/N5qjWGvALJEIHaPoVJmMAXMHQNhCm
         oHwJoul+BypWnt6hzL+N3D42jm7Evj9e+NXsWWFZdg1lYpZcW8NrcWT5i8WAsKp+0Xjw
         EXq9FAIDgIsITHbkJF5Mrqh3CSvMqrjsdBmYDWDBXbcczmG4zv1slOTUmF7CZ9nEFGds
         69nL3JCe7NBRPNE2ZPugN84ywBZfiC1L4h62fOZbCAl1aH6bhKqR3YFslUJ/O+K2CZrE
         8Ip6BEDDi+SpmicLxYmusJEfeBnE6p6eCR0ID6CnzMPt0ApkRL+GKmnQlPs+B0ajHuDt
         3UbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=gL02OzoXrEvS6yM+RCCZvdaq2BmYF8okPdc8VL1LbQI=;
        b=Bi2Kp0dqQ40oJHv9paVKwoYjzT6E2TgHSDw1lJokX3DUtchmAoS0+CxtnvxRoLxvRJ
         7+/FD7INSoRKpRf1NRoCc5IZuYMTA01VnB83xZndfcWZLd3QqxITofDjZzMIiGwzNwAe
         T5X+r0T5ROg0jUaUOIChFuUP41SB1hpabZRavyWsF/tq3CSxCk1qYLXpDWiqwop9xVIo
         48RWtqnDrPtVrUWms5ObXNxskOLAG9IhUP2aCYJvImcWynh6RM0XxY7WerK2Dih7X4mS
         WMn8AVUL/VGkrDEN5/dZjy0R5TvYaldJMnV5q4s8YNgSOCJGHdDtHn55wbig9KEznJa8
         L9Tw==
X-Gm-Message-State: AOAM533eKk6MCU2u8O1QLXawg1uJjmFcULsZZ4unrKKmTIbHZjW81IAo
        g9FZD36eplKzxcxzAvUlIE0w5mNfySA=
X-Google-Smtp-Source: ABdhPJzGlHjtp2CkmPG6HcEhPzBZEldyoHML3rPfehSATz3eKSCYITOJCk7fvB7R8rO4Ml1wT0l5i3+tABA=
X-Received: from surenb-desktop.mtv.corp.google.com ([2620:15c:211:200:9b5c:3864:3d9f:19c4])
 (user=surenb job=sendgmr) by 2002:a05:6902:1366:: with SMTP id
 bt6mr4166998ybb.554.1641885136166; Mon, 10 Jan 2022 23:12:16 -0800 (PST)
Date:   Mon, 10 Jan 2022 23:12:12 -0800
Message-Id: <20220111071212.1210124-1-surenb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.575.g55b058a8bb-goog
Subject: [PATCH v2 1/1] psi: Fix uaf issue when psi trigger is destroyed while
 being polled
From:   Suren Baghdasaryan <surenb@google.com>
To:     hannes@cmpxchg.org
Cc:     torvalds@linux-foundation.org, ebiggers@kernel.org, tj@kernel.org,
        lizefan.x@bytedance.com, mingo@redhat.com, peterz@infradead.org,
        juri.lelli@redhat.com, vincent.guittot@linaro.org,
        dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
        mgorman@suse.de, bristot@redhat.com, corbet@lwn.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@android.com, surenb@google.com,
        syzbot+cdb5dd11c97cc532efad@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

With write operation on psi files replacing old trigger with a new one,
the lifetime of its waitqueue is totally arbitrary. Overwriting an
existing trigger causes its waitqueue to be freed and pending poll()
will stumble on trigger->event_wait which was destroyed.
Fix this by disallowing to redefine an existing psi trigger. If a write
operation is used on a file descriptor with an already existing psi
trigger, the operation will fail with EBUSY error.
Also bypass a check for psi_disabled in the psi_trigger_destroy as the
flag can be flipped after the trigger is created, leading to a memory
leak.

Fixes: 0e94682b73bf ("psi: introduce psi monitor")
Cc: stable@vger.kernel.org
Reported-by: syzbot+cdb5dd11c97cc532efad@syzkaller.appspotmail.com
Analyzed-by: Eric Biggers <ebiggers@kernel.org>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
Changes in v2:
- Added Fixes tag, per Eric Biggers
- CC'ed stable@vger.kernel.org, per Eric Biggers
- Removed unnecessary READ_ONCE/WRITE_ONCE, per Eric Biggers
- Changed psi_trigger_destroy to accept psi_trigger pointer, per Eric Biggers

 Documentation/accounting/psi.rst |  3 +-
 include/linux/psi.h              |  2 +-
 include/linux/psi_types.h        |  3 --
 kernel/cgroup/cgroup.c           | 11 ++++--
 kernel/sched/psi.c               | 66 ++++++++++++++------------------
 5 files changed, 40 insertions(+), 45 deletions(-)

diff --git a/Documentation/accounting/psi.rst b/Documentation/accounting/psi.rst
index f2b3439edcc2..860fe651d645 100644
--- a/Documentation/accounting/psi.rst
+++ b/Documentation/accounting/psi.rst
@@ -92,7 +92,8 @@ Triggers can be set on more than one psi metric and more than one trigger
 for the same psi metric can be specified. However for each trigger a separate
 file descriptor is required to be able to poll it separately from others,
 therefore for each trigger a separate open() syscall should be made even
-when opening the same psi interface file.
+when opening the same psi interface file. Write operations to a file descriptor
+with an already existing psi trigger will fail with EBUSY.
 
 Monitors activate only when system enters stall state for the monitored
 psi metric and deactivates upon exit from the stall state. While system is
diff --git a/include/linux/psi.h b/include/linux/psi.h
index 65eb1476ac70..74f7148dfb9f 100644
--- a/include/linux/psi.h
+++ b/include/linux/psi.h
@@ -32,7 +32,7 @@ void cgroup_move_task(struct task_struct *p, struct css_set *to);
 
 struct psi_trigger *psi_trigger_create(struct psi_group *group,
 			char *buf, size_t nbytes, enum psi_res res);
-void psi_trigger_replace(void **trigger_ptr, struct psi_trigger *t);
+void psi_trigger_destroy(struct psi_trigger *t);
 
 __poll_t psi_trigger_poll(void **trigger_ptr, struct file *file,
 			poll_table *wait);
diff --git a/include/linux/psi_types.h b/include/linux/psi_types.h
index 0a23300d49af..6537d0c92825 100644
--- a/include/linux/psi_types.h
+++ b/include/linux/psi_types.h
@@ -129,9 +129,6 @@ struct psi_trigger {
 	 * events to one per window
 	 */
 	u64 last_event_time;
-
-	/* Refcounting to prevent premature destruction */
-	struct kref refcount;
 };
 
 struct psi_group {
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index cafb8c114a21..93b51a2104f7 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3642,6 +3642,12 @@ static ssize_t cgroup_pressure_write(struct kernfs_open_file *of, char *buf,
 	cgroup_get(cgrp);
 	cgroup_kn_unlock(of->kn);
 
+	/* Allow only one trigger per file descriptor */
+	if (ctx->psi.trigger) {
+		cgroup_put(cgrp);
+		return -EBUSY;
+	}
+
 	psi = cgroup_ino(cgrp) == 1 ? &psi_system : &cgrp->psi;
 	new = psi_trigger_create(psi, buf, nbytes, res);
 	if (IS_ERR(new)) {
@@ -3649,8 +3655,7 @@ static ssize_t cgroup_pressure_write(struct kernfs_open_file *of, char *buf,
 		return PTR_ERR(new);
 	}
 
-	psi_trigger_replace(&ctx->psi.trigger, new);
-
+	ctx->psi.trigger = new;
 	cgroup_put(cgrp);
 
 	return nbytes;
@@ -3689,7 +3694,7 @@ static void cgroup_pressure_release(struct kernfs_open_file *of)
 {
 	struct cgroup_file_ctx *ctx = of->priv;
 
-	psi_trigger_replace(&ctx->psi.trigger, NULL);
+	psi_trigger_destroy(ctx->psi.trigger);
 }
 
 bool cgroup_psi_enabled(void)
diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index 1652f2bb54b7..1fe4b8d3ae98 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -1151,7 +1151,6 @@ struct psi_trigger *psi_trigger_create(struct psi_group *group,
 	t->event = 0;
 	t->last_event_time = 0;
 	init_waitqueue_head(&t->event_wait);
-	kref_init(&t->refcount);
 
 	mutex_lock(&group->trigger_lock);
 
@@ -1180,15 +1179,19 @@ struct psi_trigger *psi_trigger_create(struct psi_group *group,
 	return t;
 }
 
-static void psi_trigger_destroy(struct kref *ref)
+void psi_trigger_destroy(struct psi_trigger *t)
 {
-	struct psi_trigger *t = container_of(ref, struct psi_trigger, refcount);
-	struct psi_group *group = t->group;
+	struct psi_group *group;
 	struct task_struct *task_to_destroy = NULL;
 
-	if (static_branch_likely(&psi_disabled))
+	/*
+	 * We do not check psi_disabled since it might have been disabled after
+	 * the trigger got created.
+	 */
+	if (!t)
 		return;
 
+	group = t->group;
 	/*
 	 * Wakeup waiters to stop polling. Can happen if cgroup is deleted
 	 * from under a polling process.
@@ -1224,9 +1227,9 @@ static void psi_trigger_destroy(struct kref *ref)
 	mutex_unlock(&group->trigger_lock);
 
 	/*
-	 * Wait for both *trigger_ptr from psi_trigger_replace and
-	 * poll_task RCUs to complete their read-side critical sections
-	 * before destroying the trigger and optionally the poll_task
+	 * Wait for psi_schedule_poll_work RCU to complete its read-side
+	 * critical section before destroying the trigger and optionally the
+	 * poll_task.
 	 */
 	synchronize_rcu();
 	/*
@@ -1243,18 +1246,6 @@ static void psi_trigger_destroy(struct kref *ref)
 	kfree(t);
 }
 
-void psi_trigger_replace(void **trigger_ptr, struct psi_trigger *new)
-{
-	struct psi_trigger *old = *trigger_ptr;
-
-	if (static_branch_likely(&psi_disabled))
-		return;
-
-	rcu_assign_pointer(*trigger_ptr, new);
-	if (old)
-		kref_put(&old->refcount, psi_trigger_destroy);
-}
-
 __poll_t psi_trigger_poll(void **trigger_ptr,
 				struct file *file, poll_table *wait)
 {
@@ -1264,24 +1255,15 @@ __poll_t psi_trigger_poll(void **trigger_ptr,
 	if (static_branch_likely(&psi_disabled))
 		return DEFAULT_POLLMASK | EPOLLERR | EPOLLPRI;
 
-	rcu_read_lock();
-
-	t = rcu_dereference(*(void __rcu __force **)trigger_ptr);
-	if (!t) {
-		rcu_read_unlock();
+	t = READ_ONCE(*trigger_ptr);
+	if (!t)
 		return DEFAULT_POLLMASK | EPOLLERR | EPOLLPRI;
-	}
-	kref_get(&t->refcount);
-
-	rcu_read_unlock();
 
 	poll_wait(file, &t->event_wait, wait);
 
 	if (cmpxchg(&t->event, 1, 0) == 1)
 		ret |= EPOLLPRI;
 
-	kref_put(&t->refcount, psi_trigger_destroy);
-
 	return ret;
 }
 
@@ -1305,14 +1287,24 @@ static ssize_t psi_write(struct file *file, const char __user *user_buf,
 
 	buf[buf_size - 1] = '\0';
 
-	new = psi_trigger_create(&psi_system, buf, nbytes, res);
-	if (IS_ERR(new))
-		return PTR_ERR(new);
-
 	seq = file->private_data;
+
 	/* Take seq->lock to protect seq->private from concurrent writes */
 	mutex_lock(&seq->lock);
-	psi_trigger_replace(&seq->private, new);
+
+	/* Allow only one trigger per file descriptor */
+	if (seq->private) {
+		mutex_unlock(&seq->lock);
+		return -EBUSY;
+	}
+
+	new = psi_trigger_create(&psi_system, buf, nbytes, res);
+	if (IS_ERR(new)) {
+		mutex_unlock(&seq->lock);
+		return PTR_ERR(new);
+	}
+
+	seq->private = new;
 	mutex_unlock(&seq->lock);
 
 	return nbytes;
@@ -1347,7 +1339,7 @@ static int psi_fop_release(struct inode *inode, struct file *file)
 {
 	struct seq_file *seq = file->private_data;
 
-	psi_trigger_replace(&seq->private, NULL);
+	psi_trigger_destroy(seq->private);
 	return single_release(inode, file);
 }
 
-- 
2.34.1.575.g55b058a8bb-goog

