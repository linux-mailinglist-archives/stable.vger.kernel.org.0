Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 763B04A557A
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 04:07:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232940AbiBADHW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 22:07:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232834AbiBADHV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 22:07:21 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48F8EC061714
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 19:07:21 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id c7-20020a25a2c7000000b00613e4dbaf97so30502797ybn.13
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 19:07:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=FM1uMC4XyRA1UkD4AdAtKmQZuCrBbmoPid6MOt1filM=;
        b=lxb1v1T+aAub+GDh3JXFBdrKYycNxzsPW0XFupgPFKmA/hDPPiwnD1ZquUJbqrXjJm
         ccbUdFpprcqYH3GCC9DEcX7DsBxRHYcKOuNmKUGs6uGhSaoynePhOX2GdNFQfxwWQD1/
         xpXBomJMd7DoVukq5IwFy+WfF+Bs/t/rhHNS5K3NlSL+sy8f5CnVuyFJtJa73Qn8u5AI
         VI9EhbLH1Gi7oc3rttF3j74WC03BbczH5Pq/lKbXtUd/hdr8F3NFCC9ap5S0uHDXHUZr
         MFaj01mbNhRpCg8fp2Eyxa+J6oqoB/0BvUEPA6stbrg/lUEqG2A0MmVR1P+O26QW3I97
         U/UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=FM1uMC4XyRA1UkD4AdAtKmQZuCrBbmoPid6MOt1filM=;
        b=tJmFT6CMViiV+PVYFuYPz+TDYWRSbeYi7seCgoPHKSuMZmAQrsOj9wQVj0NQGJcMJ0
         2QFb/+67rj0ZwAYy0C7J8U+fyD7qOF7ShZc4p2UX9RlsKOylNxnT3Qi2PBNjmY1vzaPp
         xMesM0tzDhLBGM5Ydfe8XVAoaIEDbeY3I7XnV5MIlX8MM5rlXCyq7Le492WU+jEUhXne
         HmRFl2l2K542Ea/uLR2i5uNZ/ZOBtj4uH2pcYGHBNCRuIYsZt0rFeLuSOYkKnbUDeKUW
         +GeqoPS3SB5OJgiC5zAbZ5CbhI9i+G7k9GLs5119xXbUQ5PqAE5OkKxmsLzlQiYWG9Gq
         Mcgw==
X-Gm-Message-State: AOAM530e5ZVWBZaUO9TZaWejJ8wUYsa/qHDuhE+NFdojLzcAXQNhCE45
        KdsSoI2QqENUDjdhWPSLSbJln5LjbuI=
X-Google-Smtp-Source: ABdhPJw9HvudEBl99cydrvjp69f7Ef1BFI18y+XaE/PiOVQpNXHEGRjgtnu0wfqa0RCo9SZIB5I8aagVYZs=
X-Received: from surenb-desktop.mtv.corp.google.com ([2620:15c:211:200:6019:31f1:af4:38a4])
 (user=surenb job=sendgmr) by 2002:a81:e04:: with SMTP id 4mr1727ywo.363.1643684839868;
 Mon, 31 Jan 2022 19:07:19 -0800 (PST)
Date:   Mon, 31 Jan 2022 19:07:15 -0800
Message-Id: <20220201030715.2779239-1-surenb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
Subject: [PATCH for-v5.4.x 1/1] psi: Fix uaf issue when psi trigger is
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
[surenb: backported to 5.4 kernel]
CC: stable@vger.kernel.org # 5.4
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 Documentation/accounting/psi.rst |  3 +-
 include/linux/psi.h              |  2 +-
 include/linux/psi_types.h        |  3 --
 kernel/cgroup/cgroup.c           | 11 ++++--
 kernel/sched/psi.c               | 66 ++++++++++++++------------------
 5 files changed, 40 insertions(+), 45 deletions(-)

diff --git a/Documentation/accounting/psi.rst b/Documentation/accounting/psi.rst
index 621111ce5740..28c0461ba2e1 100644
--- a/Documentation/accounting/psi.rst
+++ b/Documentation/accounting/psi.rst
@@ -90,7 +90,8 @@ Triggers can be set on more than one psi metric and more than one trigger
 for the same psi metric can be specified. However for each trigger a separate
 file descriptor is required to be able to poll it separately from others,
 therefore for each trigger a separate open() syscall should be made even
-when opening the same psi interface file.
+when opening the same psi interface file. Write operations to a file descriptor
+with an already existing psi trigger will fail with EBUSY.
 
 Monitors activate only when system enters stall state for the monitored
 psi metric and deactivates upon exit from the stall state. While system is
diff --git a/include/linux/psi.h b/include/linux/psi.h
index 7b3de7321219..7712b5800927 100644
--- a/include/linux/psi.h
+++ b/include/linux/psi.h
@@ -31,7 +31,7 @@ void cgroup_move_task(struct task_struct *p, struct css_set *to);
 
 struct psi_trigger *psi_trigger_create(struct psi_group *group,
 			char *buf, size_t nbytes, enum psi_res res);
-void psi_trigger_replace(void **trigger_ptr, struct psi_trigger *t);
+void psi_trigger_destroy(struct psi_trigger *t);
 
 __poll_t psi_trigger_poll(void **trigger_ptr, struct file *file,
 			poll_table *wait);
diff --git a/include/linux/psi_types.h b/include/linux/psi_types.h
index 07aaf9b82241..0023052eab23 100644
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
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 1904ffcee0f1..ce1745ac7b8c 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3659,6 +3659,12 @@ static ssize_t cgroup_pressure_write(struct kernfs_open_file *of, char *buf,
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
@@ -3666,8 +3672,7 @@ static ssize_t cgroup_pressure_write(struct kernfs_open_file *of, char *buf,
 		return PTR_ERR(new);
 	}
 
-	psi_trigger_replace(&of->priv, new);
-
+	smp_store_release(&of->priv, new);
 	cgroup_put(cgrp);
 
 	return nbytes;
@@ -3702,7 +3707,7 @@ static __poll_t cgroup_pressure_poll(struct kernfs_open_file *of,
 
 static void cgroup_pressure_release(struct kernfs_open_file *of)
 {
-	psi_trigger_replace(&of->priv, NULL);
+	psi_trigger_destroy(of->priv);
 }
 #endif /* CONFIG_PSI */
 
diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index 9154e745f097..9dd83eb74a9d 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -1046,7 +1046,6 @@ struct psi_trigger *psi_trigger_create(struct psi_group *group,
 	t->event = 0;
 	t->last_event_time = 0;
 	init_waitqueue_head(&t->event_wait);
-	kref_init(&t->refcount);
 
 	mutex_lock(&group->trigger_lock);
 
@@ -1079,15 +1078,19 @@ struct psi_trigger *psi_trigger_create(struct psi_group *group,
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
@@ -1122,9 +1125,9 @@ static void psi_trigger_destroy(struct kref *ref)
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
@@ -1146,18 +1149,6 @@ static void psi_trigger_destroy(struct kref *ref)
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
@@ -1167,24 +1158,15 @@ __poll_t psi_trigger_poll(void **trigger_ptr,
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
 
@@ -1208,14 +1190,24 @@ static ssize_t psi_write(struct file *file, const char __user *user_buf,
 
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
@@ -1250,7 +1242,7 @@ static int psi_fop_release(struct inode *inode, struct file *file)
 {
 	struct seq_file *seq = file->private_data;
 
-	psi_trigger_replace(&seq->private, NULL);
+	psi_trigger_destroy(seq->private);
 	return single_release(inode, file);
 }
 
-- 
2.35.0.rc2.247.g8bbb082509-goog

