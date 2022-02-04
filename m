Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA8984A95DF
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244152AbiBDJUt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:20:49 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40016 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356576AbiBDJUh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:20:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F3AE615E3;
        Fri,  4 Feb 2022 09:20:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0522C004E1;
        Fri,  4 Feb 2022 09:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966435;
        bh=SiOTYl4HAbhjx6akmKnFtzuK+pK0LowwAHkRI2cD5fY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2wS98hxrT4/HnO8Wrp0qf86rHvcAkaWCpGTLjPcrjtMyHcPcz80o0HQh7VjUbLMou
         dkJ5oEBqGx4a8SYlx/YHhpRx2BZhqojSp3V5GGAsv1MHEKfo0oEaLf8Pk6y1Jo/Fgb
         BfAF8qpwN9j/kHvXwSIcfJI3cuMruQCYD0FIgbSM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+cdb5dd11c97cc532efad@syzkaller.appspotmail.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Suren Baghdasaryan <surenb@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Eric Biggers <ebiggers@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 5.4 02/10] psi: Fix uaf issue when psi trigger is destroyed while being polled
Date:   Fri,  4 Feb 2022 10:20:15 +0100
Message-Id: <20220204091912.407481190@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220204091912.329106021@linuxfoundation.org>
References: <20220204091912.329106021@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suren Baghdasaryan <surenb@google.com>

commit a06247c6804f1a7c86a2e5398a4c1f1db1471848 upstream.

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
[surenb: backported to 5.4 kernel]
CC: stable@vger.kernel.org # 5.4
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/accounting/psi.rst |    3 +
 include/linux/psi.h              |    2 -
 include/linux/psi_types.h        |    3 -
 kernel/cgroup/cgroup.c           |   11 ++++--
 kernel/sched/psi.c               |   66 +++++++++++++++++----------------------
 5 files changed, 40 insertions(+), 45 deletions(-)

--- a/Documentation/accounting/psi.rst
+++ b/Documentation/accounting/psi.rst
@@ -90,7 +90,8 @@ Triggers can be set on more than one psi
 for the same psi metric can be specified. However for each trigger a separate
 file descriptor is required to be able to poll it separately from others,
 therefore for each trigger a separate open() syscall should be made even
-when opening the same psi interface file.
+when opening the same psi interface file. Write operations to a file descriptor
+with an already existing psi trigger will fail with EBUSY.
 
 Monitors activate only when system enters stall state for the monitored
 psi metric and deactivates upon exit from the stall state. While system is
--- a/include/linux/psi.h
+++ b/include/linux/psi.h
@@ -31,7 +31,7 @@ void cgroup_move_task(struct task_struct
 
 struct psi_trigger *psi_trigger_create(struct psi_group *group,
 			char *buf, size_t nbytes, enum psi_res res);
-void psi_trigger_replace(void **trigger_ptr, struct psi_trigger *t);
+void psi_trigger_destroy(struct psi_trigger *t);
 
 __poll_t psi_trigger_poll(void **trigger_ptr, struct file *file,
 			poll_table *wait);
--- a/include/linux/psi_types.h
+++ b/include/linux/psi_types.h
@@ -120,9 +120,6 @@ struct psi_trigger {
 	 * events to one per window
 	 */
 	u64 last_event_time;
-
-	/* Refcounting to prevent premature destruction */
-	struct kref refcount;
 };
 
 struct psi_group {
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3659,6 +3659,12 @@ static ssize_t cgroup_pressure_write(str
 	cgroup_get(cgrp);
 	cgroup_kn_unlock(of->kn);
 
+	/* Allow only one trigger per file descriptor */
+	if (of->priv) {
+		cgroup_put(cgrp);
+		return -EBUSY;
+	}
+
 	psi = cgroup_ino(cgrp) == 1 ? &psi_system : &cgrp->psi;
 	new = psi_trigger_create(psi, buf, nbytes, res);
 	if (IS_ERR(new)) {
@@ -3666,8 +3672,7 @@ static ssize_t cgroup_pressure_write(str
 		return PTR_ERR(new);
 	}
 
-	psi_trigger_replace(&of->priv, new);
-
+	smp_store_release(&of->priv, new);
 	cgroup_put(cgrp);
 
 	return nbytes;
@@ -3702,7 +3707,7 @@ static __poll_t cgroup_pressure_poll(str
 
 static void cgroup_pressure_release(struct kernfs_open_file *of)
 {
-	psi_trigger_replace(&of->priv, NULL);
+	psi_trigger_destroy(of->priv);
 }
 #endif /* CONFIG_PSI */
 
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -1046,7 +1046,6 @@ struct psi_trigger *psi_trigger_create(s
 	t->event = 0;
 	t->last_event_time = 0;
 	init_waitqueue_head(&t->event_wait);
-	kref_init(&t->refcount);
 
 	mutex_lock(&group->trigger_lock);
 
@@ -1079,15 +1078,19 @@ struct psi_trigger *psi_trigger_create(s
 	return t;
 }
 
-static void psi_trigger_destroy(struct kref *ref)
+void psi_trigger_destroy(struct psi_trigger *t)
 {
-	struct psi_trigger *t = container_of(ref, struct psi_trigger, refcount);
-	struct psi_group *group = t->group;
+	struct psi_group *group;
 	struct kthread_worker *kworker_to_destroy = NULL;
 
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
@@ -1122,9 +1125,9 @@ static void psi_trigger_destroy(struct k
 	mutex_unlock(&group->trigger_lock);
 
 	/*
-	 * Wait for both *trigger_ptr from psi_trigger_replace and
-	 * poll_kworker RCUs to complete their read-side critical sections
-	 * before destroying the trigger and optionally the poll_kworker
+	 * Wait for psi_schedule_poll_work RCU to complete its read-side
+	 * critical section before destroying the trigger and optionally the
+	 * poll_task.
 	 */
 	synchronize_rcu();
 	/*
@@ -1146,18 +1149,6 @@ static void psi_trigger_destroy(struct k
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
@@ -1167,24 +1158,15 @@ __poll_t psi_trigger_poll(void **trigger
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
 
@@ -1208,14 +1190,24 @@ static ssize_t psi_write(struct file *fi
 
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
@@ -1250,7 +1242,7 @@ static int psi_fop_release(struct inode
 {
 	struct seq_file *seq = file->private_data;
 
-	psi_trigger_replace(&seq->private, NULL);
+	psi_trigger_destroy(seq->private);
 	return single_release(inode, file);
 }
 


