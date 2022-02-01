Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 608BC4A5571
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 04:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232851AbiBADGW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 22:06:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232834AbiBADGV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 22:06:21 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3510C061714
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 19:06:21 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id t91-20020a25aae4000000b0061963cce3c1so18196276ybi.11
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 19:06:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=b4bwDGfGUCWZUAoBjOkcEkaFpUoYs81zxKaXxpVFoUE=;
        b=oYQ6y/P6BGqDHY0H5IIF03LSLL9UwlCAT9Je44CX6sik5QT/gLj9UYk8j4eRNMCtvT
         S+dJvnrvtodWPnwLoNxIPbdXGwoGvWs3CYRQvY0cYZx/rFkdd06QcGMWoQsf030xwdUF
         C1GwPAtes0tZO7PM/bHP55HqvgHqrC8WTKN3rfzAuV5O22PSHPd/t4/UsnFA3hDc+ub9
         RuQGv9EMpvJyS6n68S0v88syeMFQzEFQxbrzXmFCW4zHdVwSLC2M9y3cOldEet2ezvfc
         +d9VK0x4/gfRWQsKq+hKK/nK98bF2cHVvsQ8CKH9DLohFMmCUITg07riLYzlzpcGeXuX
         Z8FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=b4bwDGfGUCWZUAoBjOkcEkaFpUoYs81zxKaXxpVFoUE=;
        b=h35nQaYrQub6DpVU+/OLMMuC7+NHdnSeDP/FSCJkx6+ZjHvMyvp9vNaUVN0t1bAtNH
         A15HrXV3yWX1hhwk5yf40xv0+aLDHhLQuw0VRkpNUMp3/0QU10LFHMJ/hP+8hQTVKcsG
         W61sLxpQFHshnonzweswSBwMiRBBkBhxRLFxYBcOj1wmztcprBb1VChQ1siaMTAswaC+
         TkRega/Z3E/G7z4P6B0hbqjuQY205/WLOZ1rqXU1EW3Y5fpjt3gB8tvVtgnXDM5/cllD
         CS8NkNa4PTnv/YDksBO99AZG1PSAUxdfnwaPOi12b4Gh11ZZxJzx/XzJEtbxY9i+LRGs
         CyAw==
X-Gm-Message-State: AOAM531IUaqs6kjQRAUac/ykZnyF+m2b7s5J9ujoM0AiHc90MZxQUwRN
        KuKrcs/4PPSSfNdjyUwTndUOVB7lIWI=
X-Google-Smtp-Source: ABdhPJwFtsBJwCdcz4JfgVj7Zd4c8b+xVOga8tYY0ckVY+0ka6gwZGDZIVYNpqto784pAoOqNs/MWjJrIIc=
X-Received: from surenb-desktop.mtv.corp.google.com ([2620:15c:211:200:6019:31f1:af4:38a4])
 (user=surenb job=sendgmr) by 2002:a81:3a05:: with SMTP id h5mr1700ywa.203.1643684780367;
 Mon, 31 Jan 2022 19:06:20 -0800 (PST)
Date:   Mon, 31 Jan 2022 19:06:16 -0800
Message-Id: <20220201030616.2778754-1-surenb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
Subject: [PATCH for-v5.10.x 1/1] psi: Fix uaf issue when psi trigger is
 destroyed while being polled
From:   Suren Baghdasaryan <surenb@google.com>
To:     gregkh@linuxfoundation.org
Cc:     ebiggers@google.com, ebiggers@kernel.org, hannes@cmpxchg.org,
        peterz@infradead.org, torvalds@linux-foundation.org,
        stable@vger.kernel.org, surenb@google.com,
        syzbot+cdb5dd11c97cc532efad@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
[surenb: backported to 5.10 kernel]
CC: stable@vger.kernel.org # 5.10
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
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
index 7361023f3fdd..db4ecfaab879 100644
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
index b95f3211566a..17d74f62c181 100644
--- a/include/linux/psi_types.h
+++ b/include/linux/psi_types.h
@@ -128,9 +128,6 @@ struct psi_trigger {
 	 * events to one per window
 	 */
 	u64 last_event_time;
-
-	/* Refcounting to prevent premature destruction */
-	struct kref refcount;
 };
 
 struct psi_group {
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index a86857edaa57..4927289a91a9 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3601,6 +3601,12 @@ static ssize_t cgroup_pressure_write(struct kernfs_open_file *of, char *buf,
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
@@ -3608,8 +3614,7 @@ static ssize_t cgroup_pressure_write(struct kernfs_open_file *of, char *buf,
 		return PTR_ERR(new);
 	}
 
-	psi_trigger_replace(&of->priv, new);
-
+	smp_store_release(&of->priv, new);
 	cgroup_put(cgrp);
 
 	return nbytes;
@@ -3644,7 +3649,7 @@ static __poll_t cgroup_pressure_poll(struct kernfs_open_file *of,
 
 static void cgroup_pressure_release(struct kernfs_open_file *of)
 {
-	psi_trigger_replace(&of->priv, NULL);
+	psi_trigger_destroy(of->priv);
 }
 #endif /* CONFIG_PSI */
 
diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index d50a31ecedee..b7f38f3ad42a 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -1116,7 +1116,6 @@ struct psi_trigger *psi_trigger_create(struct psi_group *group,
 	t->event = 0;
 	t->last_event_time = 0;
 	init_waitqueue_head(&t->event_wait);
-	kref_init(&t->refcount);
 
 	mutex_lock(&group->trigger_lock);
 
@@ -1145,15 +1144,19 @@ struct psi_trigger *psi_trigger_create(struct psi_group *group,
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
@@ -1189,9 +1192,9 @@ static void psi_trigger_destroy(struct kref *ref)
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
@@ -1208,18 +1211,6 @@ static void psi_trigger_destroy(struct kref *ref)
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
@@ -1229,24 +1220,15 @@ __poll_t psi_trigger_poll(void **trigger_ptr,
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
 
@@ -1270,14 +1252,24 @@ static ssize_t psi_write(struct file *file, const char __user *user_buf,
 
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
@@ -1312,7 +1304,7 @@ static int psi_fop_release(struct inode *inode, struct file *file)
 {
 	struct seq_file *seq = file->private_data;
 
-	psi_trigger_replace(&seq->private, NULL);
+	psi_trigger_destroy(seq->private);
 	return single_release(inode, file);
 }
 
-- 
2.35.0.rc2.247.g8bbb082509-goog

