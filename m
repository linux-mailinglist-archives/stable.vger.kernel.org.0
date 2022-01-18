Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0525749249D
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 12:19:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240489AbiARLSt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 06:18:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240107AbiARLSU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 06:18:20 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54837C06175D;
        Tue, 18 Jan 2022 03:18:18 -0800 (PST)
Date:   Tue, 18 Jan 2022 11:18:15 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1642504696;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GqoAFL0JWBOhluJwE19gB75UsbdI9fwSHVl9tzuAJwk=;
        b=vp1ynFSGPX5wWu0bt+EInnbp/pG9C+t+ujhWJGAEuA0qeYnCuJ1l3kor9871mbGi1HlUQF
        wtZk4B0vQEn604s1xnZANXak3MkIKb06kxUUXHon5DPLIbvA7TY89WFxvlShc7W1E/WpbA
        aZLEanVsgqqwfzvVZEylb59t+uRp5nOb9okrWKPKUBb4HqjAtqgG4SZPDJ9ITuaMTW/ET3
        wWsSzwNqF2vYU/HRWTbAOG70TVRdDbW0/D9ARNX44xKa0HUYvlAdRUh6gHz+6gOApx+wWP
        5qX6Lm8S6LJQQ+r9tal0SQVHa0xA4mXxqYgCLXZyg7MjQfMhsgYy63iKHnBPJQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1642504696;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GqoAFL0JWBOhluJwE19gB75UsbdI9fwSHVl9tzuAJwk=;
        b=HHpjb0Cz+stDEINz0UmppAR9jYbe4wh2Q5p7IoGyZtfAPYmMcpuROq0aw1N6E1bTJDgmTU
        9AucsSTfXlkGLPCg==
From:   "tip-bot2 for Suren Baghdasaryan" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: sched/urgent] psi: Fix uaf issue when psi trigger is destroyed
 while being polled
Cc:     syzbot+cdb5dd11c97cc532efad@syzkaller.appspotmail.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Suren Baghdasaryan <surenb@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Eric Biggers <ebiggers@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20220111232309.1786347-1-surenb@google.com>
References: <20220111232309.1786347-1-surenb@google.com>
MIME-Version: 1.0
Message-ID: <164250469550.16921.16606068093554965740.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the sched/urgent branch of tip:

Commit-ID:     a06247c6804f1a7c86a2e5398a4c1f1db1471848
Gitweb:        https://git.kernel.org/tip/a06247c6804f1a7c86a2e5398a4c1f1db1471848
Author:        Suren Baghdasaryan <surenb@google.com>
AuthorDate:    Tue, 11 Jan 2022 15:23:09 -08:00
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Tue, 18 Jan 2022 12:09:57 +01:00

psi: Fix uaf issue when psi trigger is destroyed while being polled

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
Reported-by: syzbot+cdb5dd11c97cc532efad@syzkaller.appspotmail.com
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Analyzed-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220111232309.1786347-1-surenb@google.com
---
 Documentation/accounting/psi.rst |  3 +-
 include/linux/psi.h              |  2 +-
 include/linux/psi_types.h        |  3 +-
 kernel/cgroup/cgroup.c           | 11 +++--
 kernel/sched/psi.c               | 66 +++++++++++++------------------
 5 files changed, 40 insertions(+), 45 deletions(-)

diff --git a/Documentation/accounting/psi.rst b/Documentation/accounting/psi.rst
index f2b3439..860fe65 100644
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
index a70ca83..f8ce53b 100644
--- a/include/linux/psi.h
+++ b/include/linux/psi.h
@@ -33,7 +33,7 @@ void cgroup_move_task(struct task_struct *p, struct css_set *to);
 
 struct psi_trigger *psi_trigger_create(struct psi_group *group,
 			char *buf, size_t nbytes, enum psi_res res);
-void psi_trigger_replace(void **trigger_ptr, struct psi_trigger *t);
+void psi_trigger_destroy(struct psi_trigger *t);
 
 __poll_t psi_trigger_poll(void **trigger_ptr, struct file *file,
 			poll_table *wait);
diff --git a/include/linux/psi_types.h b/include/linux/psi_types.h
index 516c0fe..1a3cef2 100644
--- a/include/linux/psi_types.h
+++ b/include/linux/psi_types.h
@@ -141,9 +141,6 @@ struct psi_trigger {
 	 * events to one per window
 	 */
 	u64 last_event_time;
-
-	/* Refcounting to prevent premature destruction */
-	struct kref refcount;
 };
 
 struct psi_group {
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index b31e146..9d05c3c 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3643,6 +3643,12 @@ static ssize_t cgroup_pressure_write(struct kernfs_open_file *of, char *buf,
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
@@ -3650,8 +3656,7 @@ static ssize_t cgroup_pressure_write(struct kernfs_open_file *of, char *buf,
 		return PTR_ERR(new);
 	}
 
-	psi_trigger_replace(&ctx->psi.trigger, new);
-
+	smp_store_release(&ctx->psi.trigger, new);
 	cgroup_put(cgrp);
 
 	return nbytes;
@@ -3690,7 +3695,7 @@ static void cgroup_pressure_release(struct kernfs_open_file *of)
 {
 	struct cgroup_file_ctx *ctx = of->priv;
 
-	psi_trigger_replace(&ctx->psi.trigger, NULL);
+	psi_trigger_destroy(ctx->psi.trigger);
 }
 
 bool cgroup_psi_enabled(void)
diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index a679613..c137c4d 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -1162,7 +1162,6 @@ struct psi_trigger *psi_trigger_create(struct psi_group *group,
 	t->event = 0;
 	t->last_event_time = 0;
 	init_waitqueue_head(&t->event_wait);
-	kref_init(&t->refcount);
 
 	mutex_lock(&group->trigger_lock);
 
@@ -1191,15 +1190,19 @@ struct psi_trigger *psi_trigger_create(struct psi_group *group,
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
@@ -1235,9 +1238,9 @@ static void psi_trigger_destroy(struct kref *ref)
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
@@ -1254,18 +1257,6 @@ static void psi_trigger_destroy(struct kref *ref)
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
@@ -1275,24 +1266,15 @@ __poll_t psi_trigger_poll(void **trigger_ptr,
 	if (static_branch_likely(&psi_disabled))
 		return DEFAULT_POLLMASK | EPOLLERR | EPOLLPRI;
 
-	rcu_read_lock();
-
-	t = rcu_dereference(*(void __rcu __force **)trigger_ptr);
-	if (!t) {
-		rcu_read_unlock();
+	t = smp_load_acquire(trigger_ptr);
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
 
@@ -1316,14 +1298,24 @@ static ssize_t psi_write(struct file *file, const char __user *user_buf,
 
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
+	smp_store_release(&seq->private, new);
 	mutex_unlock(&seq->lock);
 
 	return nbytes;
@@ -1358,7 +1350,7 @@ static int psi_fop_release(struct inode *inode, struct file *file)
 {
 	struct seq_file *seq = file->private_data;
 
-	psi_trigger_replace(&seq->private, NULL);
+	psi_trigger_destroy(seq->private);
 	return single_release(inode, file);
 }
 
