Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5A2143D6DF
	for <lists+stable@lfdr.de>; Thu, 28 Oct 2021 00:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbhJ0Wql (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 18:46:41 -0400
Received: from relay.sw.ru ([185.231.240.75]:45846 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230044AbhJ0Wqk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Oct 2021 18:46:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=MIME-Version:Message-Id:Date:Subject:From:
        Content-Type; bh=HRZkAzudbXNZeJFZXqrIvW6slJmS3Rw5KKlfumHvo1w=; b=CrCQwoBqhqQq
        eOFpwwKkxm/6iyL/WYDvzSQfuc7IgiaRhDiEPRQP05uxnJ0G3ZSTK+1WlksvKbVNIJYq2pFeGfSD5
        GXqTSGQIRigLXIpEGEPMNTn21eAcPh9tG7W8e0O7kVH3zWklMFdY9EywlKGC8yIUsupFzJ4Qk53eC
        uWZzE=;
Received: from [10.94.6.52] (helo=dhcp-172-16-24-175.sw.ru)
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <alexander.mikhalitsyn@virtuozzo.com>)
        id 1mfreW-007RG6-2L; Thu, 28 Oct 2021 01:44:12 +0300
From:   Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
To:     linux-kernel@vger.kernel.org
Cc:     Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andrei Vagin <avagin@gmail.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Vasily Averin <vvs@virtuozzo.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>,
        stable@vger.kernel.org
Subject: [PATCH 2/2] shm: extend forced shm destroy to support objects from several IPC nses
Date:   Thu, 28 Oct 2021 01:43:48 +0300
Message-Id: <20211027224348.611025-3-alexander.mikhalitsyn@virtuozzo.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20211027224348.611025-1-alexander.mikhalitsyn@virtuozzo.com>
References: <20211027224348.611025-1-alexander.mikhalitsyn@virtuozzo.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently, exit_shm function not designed to work properly when
task->sysvshm.shm_clist holds shm objects from different IPC namespaces.

This is a real pain when sysctl kernel.shm_rmid_forced = 1, because
it leads to use-after-free (reproducer exists).

That particular patch is attempt to fix the problem by extending exit_shm
mechanism to handle shm's destroy from several IPC ns'es.

To achieve that we do several things:
1. add namespace (non-refcounted) pointer to the struct shmid_kernel
2. during new shm object creation (newseg()/shmget syscall) we initialize
this pointer by current task IPC ns
3. exit_shm() fully reworked such that it traverses over all
shp's in task->sysvshm.shm_clist and gets IPC namespace not
from current task as it was before but from shp's object itself, then
call shm_destroy(shp, ns).

Note. We need to be really careful here, because as it was said before
(1), our pointer to IPC ns non-refcnt'ed. To be on the safe side we using
special helper get_ipc_ns_not_zero() which allows to get IPC ns refcounter
only if IPC ns not in the "state of destruction".

Q/A

Q: Why we can access shp->ns memory using non-refcounted pointer?
A: Because shp object lifetime is always shorther
than IPC namespace lifetime, so, if we get shp object from the
task->sysvshm.shm_clist while holding task_lock(task) nobody can
steal our namespace.

Q: Does this patch change semantics of unshare/setns/clone syscalls?
A: Not. It's just fixes non-covered case when process may leave
IPC namespace without getting task->sysvshm.shm_clist list cleaned up.

Fixes: ab602f79915 ("shm: make exit_shm work proportional to task activity")

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Vasily Averin <vvs@virtuozzo.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Alexander Mikhalitsyn <alexander@mihalicyn.com>
Cc: stable@vger.kernel.org
Co-developed-by: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
---
 include/linux/ipc_namespace.h |  15 +++
 include/linux/sched/task.h    |   2 +-
 include/linux/shm.h           |   2 +-
 ipc/shm.c                     | 170 +++++++++++++++++++++++++---------
 4 files changed, 142 insertions(+), 47 deletions(-)

diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h
index 05e22770af51..b75395ec8d52 100644
--- a/include/linux/ipc_namespace.h
+++ b/include/linux/ipc_namespace.h
@@ -131,6 +131,16 @@ static inline struct ipc_namespace *get_ipc_ns(struct ipc_namespace *ns)
 	return ns;
 }
 
+static inline struct ipc_namespace *get_ipc_ns_not_zero(struct ipc_namespace *ns)
+{
+	if (ns) {
+		if (refcount_inc_not_zero(&ns->ns.count))
+			return ns;
+	}
+
+	return NULL;
+}
+
 extern void put_ipc_ns(struct ipc_namespace *ns);
 #else
 static inline struct ipc_namespace *copy_ipcs(unsigned long flags,
@@ -147,6 +157,11 @@ static inline struct ipc_namespace *get_ipc_ns(struct ipc_namespace *ns)
 	return ns;
 }
 
+static inline struct ipc_namespace *get_ipc_ns_not_zero(struct ipc_namespace *ns)
+{
+	return ns;
+}
+
 static inline void put_ipc_ns(struct ipc_namespace *ns)
 {
 }
diff --git a/include/linux/sched/task.h b/include/linux/sched/task.h
index ef02be869cf2..bfdf84dab4be 100644
--- a/include/linux/sched/task.h
+++ b/include/linux/sched/task.h
@@ -157,7 +157,7 @@ static inline struct vm_struct *task_stack_vm_area(const struct task_struct *t)
  * Protects ->fs, ->files, ->mm, ->group_info, ->comm, keyring
  * subscriptions and synchronises with wait4().  Also used in procfs.  Also
  * pins the final release of task.io_context.  Also protects ->cpuset and
- * ->cgroup.subsys[]. And ->vfork_done.
+ * ->cgroup.subsys[]. And ->vfork_done. And ->sysvshm.shm_clist.
  *
  * Nests both inside and outside of read_lock(&tasklist_lock).
  * It must not be nested with write_lock_irq(&tasklist_lock),
diff --git a/include/linux/shm.h b/include/linux/shm.h
index d8e69aed3d32..709f6d0451c0 100644
--- a/include/linux/shm.h
+++ b/include/linux/shm.h
@@ -11,7 +11,7 @@ struct file;
 
 #ifdef CONFIG_SYSVIPC
 struct sysv_shm {
-	struct list_head shm_clist;
+	struct list_head	shm_clist;
 };
 
 long do_shmat(int shmid, char __user *shmaddr, int shmflg, unsigned long *addr,
diff --git a/ipc/shm.c b/ipc/shm.c
index 748933e376ca..29667e17b12a 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -62,9 +62,18 @@ struct shmid_kernel /* private to the kernel */
 	struct pid		*shm_lprid;
 	struct ucounts		*mlock_ucounts;
 
-	/* The task created the shm object.  NULL if the task is dead. */
+	/*
+	 * The task created the shm object, for looking up
+	 * task->sysvshm.shm_clist_lock
+	 */
 	struct task_struct	*shm_creator;
-	struct list_head	shm_clist;	/* list by creator */
+
+	/*
+	 * list by creator. shm_clist_lock required for read/write
+	 * if list_empty(), then the creator is dead already
+	 */
+	struct list_head	shm_clist;
+	struct ipc_namespace	*ns;
 } __randomize_layout;
 
 /* shm_mode upper byte flags */
@@ -115,6 +124,7 @@ static void do_shm_rmid(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
 	struct shmid_kernel *shp;
 
 	shp = container_of(ipcp, struct shmid_kernel, shm_perm);
+	WARN_ON(ns != shp->ns);
 
 	if (shp->shm_nattch) {
 		shp->shm_perm.mode |= SHM_DEST;
@@ -225,10 +235,36 @@ static void shm_rcu_free(struct rcu_head *head)
 	kfree(shp);
 }
 
-static inline void shm_rmid(struct ipc_namespace *ns, struct shmid_kernel *s)
+/*
+ * It has to be called with shp locked.
+ * It must be called before ipc_rmid()
+ */
+static inline void shm_clist_rm(struct shmid_kernel *shp)
 {
-	list_del(&s->shm_clist);
-	ipc_rmid(&shm_ids(ns), &s->shm_perm);
+	struct task_struct *creator;
+
+	/*
+	 * A concurrent exit_shm may do a list_del_init() as well.
+	 * Just do nothing if exit_shm already did the work
+	 */
+	if (list_empty(&shp->shm_clist))
+		return;
+
+	/*
+	 * shp->shm_creator is guaranteed to be valid *only*
+	 * if shp->shm_clist is not empty.
+	 */
+	creator = shp->shm_creator;
+
+	task_lock(creator);
+	list_del_init(&shp->shm_clist);
+	task_unlock(creator);
+}
+
+static inline void shm_rmid(struct shmid_kernel *s)
+{
+	shm_clist_rm(s);
+	ipc_rmid(&shm_ids(s->ns), &s->shm_perm);
 }
 
 
@@ -283,7 +319,7 @@ static void shm_destroy(struct ipc_namespace *ns, struct shmid_kernel *shp)
 	shm_file = shp->shm_file;
 	shp->shm_file = NULL;
 	ns->shm_tot -= (shp->shm_segsz + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	shm_rmid(ns, shp);
+	shm_rmid(shp);
 	shm_unlock(shp);
 	if (!is_file_hugepages(shm_file))
 		shmem_lock(shm_file, 0, shp->mlock_ucounts);
@@ -306,10 +342,10 @@ static void shm_destroy(struct ipc_namespace *ns, struct shmid_kernel *shp)
  *
  * 2) sysctl kernel.shm_rmid_forced is set to 1.
  */
-static bool shm_may_destroy(struct ipc_namespace *ns, struct shmid_kernel *shp)
+static bool shm_may_destroy(struct shmid_kernel *shp)
 {
 	return (shp->shm_nattch == 0) &&
-	       (ns->shm_rmid_forced ||
+	       (shp->ns->shm_rmid_forced ||
 		(shp->shm_perm.mode & SHM_DEST));
 }
 
@@ -340,7 +376,7 @@ static void shm_close(struct vm_area_struct *vma)
 	ipc_update_pid(&shp->shm_lprid, task_tgid(current));
 	shp->shm_dtim = ktime_get_real_seconds();
 	shp->shm_nattch--;
-	if (shm_may_destroy(ns, shp))
+	if (shm_may_destroy(shp))
 		shm_destroy(ns, shp);
 	else
 		shm_unlock(shp);
@@ -361,10 +397,10 @@ static int shm_try_destroy_orphaned(int id, void *p, void *data)
 	 *
 	 * As shp->* are changed under rwsem, it's safe to skip shp locking.
 	 */
-	if (shp->shm_creator != NULL)
+	if (!list_empty(&shp->shm_clist))
 		return 0;
 
-	if (shm_may_destroy(ns, shp)) {
+	if (shm_may_destroy(shp)) {
 		shm_lock_by_ptr(shp);
 		shm_destroy(ns, shp);
 	}
@@ -382,48 +418,87 @@ void shm_destroy_orphaned(struct ipc_namespace *ns)
 /* Locking assumes this will only be called with task == current */
 void exit_shm(struct task_struct *task)
 {
-	struct ipc_namespace *ns = task->nsproxy->ipc_ns;
-	struct shmid_kernel *shp, *n;
+	for (;;) {
+		struct shmid_kernel *shp;
+		struct ipc_namespace *ns;
 
-	if (list_empty(&task->sysvshm.shm_clist))
-		return;
+		task_lock(task);
+
+		if (list_empty(&task->sysvshm.shm_clist)) {
+			task_unlock(task);
+			break;
+		}
+
+		shp = list_first_entry(&task->sysvshm.shm_clist, struct shmid_kernel,
+				shm_clist);
+
+		/* 1) unlink */
+		list_del_init(&shp->shm_clist);
 
-	/*
-	 * If kernel.shm_rmid_forced is not set then only keep track of
-	 * which shmids are orphaned, so that a later set of the sysctl
-	 * can clean them up.
-	 */
-	if (!ns->shm_rmid_forced) {
-		down_read(&shm_ids(ns).rwsem);
-		list_for_each_entry(shp, &task->sysvshm.shm_clist, shm_clist)
-			shp->shm_creator = NULL;
 		/*
-		 * Only under read lock but we are only called on current
-		 * so no entry on the list will be shared.
+		 * 2) Get pointer to the ipc namespace. It is worth to say
+		 * that this pointer is guaranteed to be valid because
+		 * shp lifetime is always shorter than namespace lifetime
+		 * in which shp lives.
+		 * We taken task_lock it means that shp won't be freed.
 		 */
-		list_del(&task->sysvshm.shm_clist);
-		up_read(&shm_ids(ns).rwsem);
-		return;
-	}
+		ns = shp->ns;
 
-	/*
-	 * Destroy all already created segments, that were not yet mapped,
-	 * and mark any mapped as orphan to cover the sysctl toggling.
-	 * Destroy is skipped if shm_may_destroy() returns false.
-	 */
-	down_write(&shm_ids(ns).rwsem);
-	list_for_each_entry_safe(shp, n, &task->sysvshm.shm_clist, shm_clist) {
-		shp->shm_creator = NULL;
+		/*
+		 * 3) If kernel.shm_rmid_forced is not set then only keep track of
+		 * which shmids are orphaned, so that a later set of the sysctl
+		 * can clean them up.
+		 */
+		if (!ns->shm_rmid_forced) {
+			task_unlock(task);
+			continue;
+		}
 
-		if (shm_may_destroy(ns, shp)) {
+		/*
+		 * 4) get a reference to the namespace.
+		 *    The refcount could be already 0. If it is 0, then
+		 *    the shm objects will be free by free_ipc_work().
+		 */
+		ns = get_ipc_ns_not_zero(ns);
+		if (ns) {
+			/*
+			 * 5) get a reference to the shp itself.
+			 *   This cannot fail: shm_clist_rm() is called before
+			 *   ipc_rmid(), thus the refcount cannot be 0.
+			 */
+			WARN_ON(!ipc_rcu_getref(&shp->shm_perm));
+		}
+
+		task_unlock(task);
+
+		if (ns) {
+			down_write(&shm_ids(ns).rwsem);
 			shm_lock_by_ptr(shp);
-			shm_destroy(ns, shp);
+			/*
+			 * rcu_read_lock was implicitly taken in
+			 * shm_lock_by_ptr, it's safe to call
+			 * ipc_rcu_putref here
+			 */
+			ipc_rcu_putref(&shp->shm_perm, shm_rcu_free);
+
+			if (ipc_valid_object(&shp->shm_perm)) {
+				if (shm_may_destroy(shp))
+					shm_destroy(ns, shp);
+				else
+					shm_unlock(shp);
+			} else {
+				/*
+				 * Someone else deleted the shp from namespace
+				 * idr/kht while we have waited.
+				 * Just unlock and continue.
+				 */
+				shm_unlock(shp);
+			}
+
+			up_write(&shm_ids(ns).rwsem);
+			put_ipc_ns(ns); /* paired with get_ipc_ns_not_zero */
 		}
 	}
-
-	/* Remove the list head from any segments still attached. */
-	list_del(&task->sysvshm.shm_clist);
-	up_write(&shm_ids(ns).rwsem);
 }
 
 static vm_fault_t shm_fault(struct vm_fault *vmf)
@@ -680,7 +755,11 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
 	if (error < 0)
 		goto no_id;
 
+	shp->ns = ns;
+
+	task_lock(current);
 	list_add(&shp->shm_clist, &current->sysvshm.shm_clist);
+	task_unlock(current);
 
 	/*
 	 * shmid gets reported as "inode#" in /proc/pid/maps.
@@ -1573,7 +1652,8 @@ long do_shmat(int shmid, char __user *shmaddr, int shmflg,
 	down_write(&shm_ids(ns).rwsem);
 	shp = shm_lock(ns, shmid);
 	shp->shm_nattch--;
-	if (shm_may_destroy(ns, shp))
+
+	if (shm_may_destroy(shp))
 		shm_destroy(ns, shp);
 	else
 		shm_unlock(shp);
-- 
2.31.1

