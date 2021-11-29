Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E616F4620FD
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 20:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378904AbhK2TxC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 14:53:02 -0500
Received: from relay.sw.ru ([185.231.240.75]:55038 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351368AbhK2TvB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Nov 2021 14:51:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=MIME-Version:Message-Id:Date:Subject:From:
        Content-Type; bh=dcwyw/Iig8a34Qd2rAcqCwgIckKDocu7QbPlObndt7c=; b=slOqw4bem4yc
        vJfHuoaWuvbsooYDA1mtyJLXio/ZZl3xY5/7onDI5JYyIo4KbSUs2ACxq3V6/r5Pc2NzBkopd5+fa
        WBaoQtm7++eQjhIGCMcvctsW61XFEcFq6AgIqpp6lP4J1uBwci6zLww9Quufc7ocq2VRLpM6l5PTe
        9ke4A=;
Received: from [10.94.6.52] (helo=dhcp-172-16-24-175.sw.ru)
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <alexander.mikhalitsyn@virtuozzo.com>)
        id 1mrmcm-001ok7-0o; Mon, 29 Nov 2021 22:47:40 +0300
From:   Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        manfred@colorfullife.com
Cc:     Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Andrei Vagin <avagin@gmail.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH] shm: extend forced shm destroy to support objects from several IPC nses
Date:   Mon, 29 Nov 2021 22:47:37 +0300
Message-Id: <20211129194737.827232-1-alexander.mikhalitsyn@virtuozzo.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <163758370314212@kroah.com>
References: <163758370314212@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

For 4.14.y:

Upstream commit 85b6d24646e4 ("shm: extend forced shm destroy to support objects from several IPC nses")

Currently, the exit_shm() function not designed to work properly when
task->sysvshm.shm_clist holds shm objects from different IPC namespaces.

This is a real pain when sysctl kernel.shm_rmid_forced = 1, because it
leads to use-after-free (reproducer exists).

This is an attempt to fix the problem by extending exit_shm mechanism to
handle shm's destroy from several IPC ns'es.

To achieve that we do several things:

1. add a namespace (non-refcounted) pointer to the struct shmid_kernel

2. during new shm object creation (newseg()/shmget syscall) we
   initialize this pointer by current task IPC ns

3. exit_shm() fully reworked such that it traverses over all shp's in
   task->sysvshm.shm_clist and gets IPC namespace not from current task
   as it was before but from shp's object itself, then call
   shm_destroy(shp, ns).

Note: We need to be really careful here, because as it was said before
(1), our pointer to IPC ns non-refcnt'ed.  To be on the safe side we
using special helper get_ipc_ns_not_zero() which allows to get IPC ns
refcounter only if IPC ns not in the "state of destruction".

Q/A

Q: Why can we access shp->ns memory using non-refcounted pointer?
A: Because shp object lifetime is always shorther than IPC namespace
   lifetime, so, if we get shp object from the task->sysvshm.shm_clist
   while holding task_lock(task) nobody can steal our namespace.

Q: Does this patch change semantics of unshare/setns/clone syscalls?
A: No. It's just fixes non-covered case when process may leave IPC
   namespace without getting task->sysvshm.shm_clist list cleaned up.

Link: https://lkml.kernel.org/r/67bb03e5-f79c-1815-e2bf-949c67047418@colorfullife.com
Link: https://lkml.kernel.org/r/20211109151501.4921-1-manfred@colorfullife.com
Fixes: ab602f79915 ("shm: make exit_shm work proportional to task activity")
Co-developed-by: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Vasily Averin <vvs@virtuozzo.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 include/linux/ipc_namespace.h |  15 +++
 include/linux/sched/task.h    |   2 +-
 include/linux/shm.h           |  13 ++-
 ipc/shm.c                     | 176 +++++++++++++++++++++++++---------
 4 files changed, 159 insertions(+), 47 deletions(-)

diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h
index 474812abe773..e661765271ea 100644
--- a/include/linux/ipc_namespace.h
+++ b/include/linux/ipc_namespace.h
@@ -127,6 +127,16 @@ static inline struct ipc_namespace *get_ipc_ns(struct ipc_namespace *ns)
 	return ns;
 }
 
+static inline struct ipc_namespace *get_ipc_ns_not_zero(struct ipc_namespace *ns)
+{
+	if (ns) {
+		if (refcount_inc_not_zero(&ns->count))
+			return ns;
+	}
+
+	return NULL;
+}
+
 extern void put_ipc_ns(struct ipc_namespace *ns);
 #else
 static inline struct ipc_namespace *copy_ipcs(unsigned long flags,
@@ -143,6 +153,11 @@ static inline struct ipc_namespace *get_ipc_ns(struct ipc_namespace *ns)
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
index 11b4fba82950..c3d157a37073 100644
--- a/include/linux/sched/task.h
+++ b/include/linux/sched/task.h
@@ -122,7 +122,7 @@ static inline struct vm_struct *task_stack_vm_area(const struct task_struct *t)
  * Protects ->fs, ->files, ->mm, ->group_info, ->comm, keyring
  * subscriptions and synchronises with wait4().  Also used in procfs.  Also
  * pins the final release of task.io_context.  Also protects ->cpuset and
- * ->cgroup.subsys[]. And ->vfork_done.
+ * ->cgroup.subsys[]. And ->vfork_done. And ->sysvshm.shm_clist.
  *
  * Nests both inside and outside of read_lock(&tasklist_lock).
  * It must not be nested with write_lock_irq(&tasklist_lock),
diff --git a/include/linux/shm.h b/include/linux/shm.h
index 2bbafacfbfc9..3ef303df784e 100644
--- a/include/linux/shm.h
+++ b/include/linux/shm.h
@@ -20,9 +20,18 @@ struct shmid_kernel /* private to the kernel */
 	pid_t			shm_lprid;
 	struct user_struct	*mlock_user;
 
-	/* The task created the shm object.  NULL if the task is dead. */
+	/*
+	 * The task created the shm object, for
+	 * task_lock(shp->shm_creator)
+	 */
 	struct task_struct	*shm_creator;
-	struct list_head	shm_clist;	/* list by creator */
+
+	/*
+	 * List by creator. task_lock(->shm_creator) required for read/write.
+	 * If list_empty(), then the creator is dead already.
+	 */
+	struct list_head	shm_clist;
+	struct ipc_namespace	*ns;
 } __randomize_layout;
 
 /* shm_mode upper byte flags */
diff --git a/ipc/shm.c b/ipc/shm.c
index 44cca2529a95..d3cebe4e23e3 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -92,6 +92,7 @@ static void do_shm_rmid(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
 	struct shmid_kernel *shp;
 
 	shp = container_of(ipcp, struct shmid_kernel, shm_perm);
+	WARN_ON(ns != shp->ns);
 
 	if (shp->shm_nattch) {
 		shp->shm_perm.mode |= SHM_DEST;
@@ -185,10 +186,43 @@ static void shm_rcu_free(struct rcu_head *head)
 	kvfree(shp);
 }
 
-static inline void shm_rmid(struct ipc_namespace *ns, struct shmid_kernel *s)
+/*
+ * It has to be called with shp locked.
+ * It must be called before ipc_rmid()
+ */
+static inline void shm_clist_rm(struct shmid_kernel *shp)
+{
+	struct task_struct *creator;
+
+	/* ensure that shm_creator does not disappear */
+	rcu_read_lock();
+
+	/*
+	 * A concurrent exit_shm may do a list_del_init() as well.
+	 * Just do nothing if exit_shm already did the work
+	 */
+	if (!list_empty(&shp->shm_clist)) {
+		/*
+		 * shp->shm_creator is guaranteed to be valid *only*
+		 * if shp->shm_clist is not empty.
+		 */
+		creator = shp->shm_creator;
+
+		task_lock(creator);
+		/*
+		 * list_del_init() is a nop if the entry was already removed
+		 * from the list.
+		 */
+		list_del_init(&shp->shm_clist);
+		task_unlock(creator);
+	}
+	rcu_read_unlock();
+}
+
+static inline void shm_rmid(struct shmid_kernel *s)
 {
-	list_del(&s->shm_clist);
-	ipc_rmid(&shm_ids(ns), &s->shm_perm);
+	shm_clist_rm(s);
+	ipc_rmid(&shm_ids(s->ns), &s->shm_perm);
 }
 
 
@@ -243,7 +277,7 @@ static void shm_destroy(struct ipc_namespace *ns, struct shmid_kernel *shp)
 	shm_file = shp->shm_file;
 	shp->shm_file = NULL;
 	ns->shm_tot -= (shp->shm_segsz + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	shm_rmid(ns, shp);
+	shm_rmid(shp);
 	shm_unlock(shp);
 	if (!is_file_hugepages(shm_file))
 		shmem_lock(shm_file, 0, shp->mlock_user);
@@ -264,10 +298,10 @@ static void shm_destroy(struct ipc_namespace *ns, struct shmid_kernel *shp)
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
 
@@ -298,7 +332,7 @@ static void shm_close(struct vm_area_struct *vma)
 	shp->shm_lprid = task_tgid_vnr(current);
 	shp->shm_dtim = ktime_get_real_seconds();
 	shp->shm_nattch--;
-	if (shm_may_destroy(ns, shp))
+	if (shm_may_destroy(shp))
 		shm_destroy(ns, shp);
 	else
 		shm_unlock(shp);
@@ -319,10 +353,10 @@ static int shm_try_destroy_orphaned(int id, void *p, void *data)
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
@@ -340,48 +374,97 @@ void shm_destroy_orphaned(struct ipc_namespace *ns)
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
+		 * 1) Get pointer to the ipc namespace. It is worth to say
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
+		 * 2) If kernel.shm_rmid_forced is not set then only keep track of
+		 * which shmids are orphaned, so that a later set of the sysctl
+		 * can clean them up.
+		 */
+		if (!ns->shm_rmid_forced)
+			goto unlink_continue;
 
-		if (shm_may_destroy(ns, shp)) {
-			shm_lock_by_ptr(shp);
-			shm_destroy(ns, shp);
+		/*
+		 * 3) get a reference to the namespace.
+		 *    The refcount could be already 0. If it is 0, then
+		 *    the shm objects will be free by free_ipc_work().
+		 */
+		ns = get_ipc_ns_not_zero(ns);
+		if (!ns) {
+unlink_continue:
+			list_del_init(&shp->shm_clist);
+			task_unlock(task);
+			continue;
 		}
-	}
 
-	/* Remove the list head from any segments still attached. */
-	list_del(&task->sysvshm.shm_clist);
-	up_write(&shm_ids(ns).rwsem);
+		/*
+		 * 4) get a reference to shp.
+		 *   This cannot fail: shm_clist_rm() is called before
+		 *   ipc_rmid(), thus the refcount cannot be 0.
+		 */
+		WARN_ON(!ipc_rcu_getref(&shp->shm_perm));
+
+		/*
+		 * 5) unlink the shm segment from the list of segments
+		 *    created by current.
+		 *    This must be done last. After unlinking,
+		 *    only the refcounts obtained above prevent IPC_RMID
+		 *    from destroying the segment or the namespace.
+		 */
+		list_del_init(&shp->shm_clist);
+
+		task_unlock(task);
+
+		/*
+		 * 6) we have all references
+		 *    Thus lock & if needed destroy shp.
+		 */
+		down_write(&shm_ids(ns).rwsem);
+		shm_lock_by_ptr(shp);
+		/*
+		 * rcu_read_lock was implicitly taken in shm_lock_by_ptr, it's
+		 * safe to call ipc_rcu_putref here
+		 */
+		ipc_rcu_putref(&shp->shm_perm, shm_rcu_free);
+
+		if (ipc_valid_object(&shp->shm_perm)) {
+			if (shm_may_destroy(shp))
+				shm_destroy(ns, shp);
+			else
+				shm_unlock(shp);
+		} else {
+			/*
+			 * Someone else deleted the shp from namespace
+			 * idr/kht while we have waited.
+			 * Just unlock and continue.
+			 */
+			shm_unlock(shp);
+		}
+
+		up_write(&shm_ids(ns).rwsem);
+		put_ipc_ns(ns); /* paired with get_ipc_ns_not_zero */
+	}
 }
 
 static int shm_fault(struct vm_fault *vmf)
@@ -625,7 +708,11 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
 	if (error < 0)
 		goto no_id;
 
+	shp->ns = ns;
+
+	task_lock(current);
 	list_add(&shp->shm_clist, &current->sysvshm.shm_clist);
+	task_unlock(current);
 
 	/*
 	 * shmid gets reported as "inode#" in /proc/pid/maps.
@@ -1449,7 +1536,8 @@ long do_shmat(int shmid, char __user *shmaddr, int shmflg,
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

