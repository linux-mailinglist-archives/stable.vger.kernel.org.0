Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 909EC2CDDD5
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 19:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731752AbgLCSes (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 13:34:48 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:36226 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731765AbgLCSer (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Dec 2020 13:34:47 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=wenyang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UHR7EfG_1607020430;
Received: from localhost(mailfrom:wenyang@linux.alibaba.com fp:SMTPD_---0UHR7EfG_1607020430)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 04 Dec 2020 02:34:03 +0800
From:   Wen Yang <wenyang@linux.alibaba.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Xunlei Pang <xlpang@linux.alibaba.com>,
        linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        stable@vger.kernel.org, Wen Yang <wenyang@linux.alibaba.com>
Subject: [PATCH 10/10] proc: Use a list of inodes to flush from proc
Date:   Fri,  4 Dec 2020 02:32:04 +0800
Message-Id: <20201203183204.63759-11-wenyang@linux.alibaba.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20201203183204.63759-1-wenyang@linux.alibaba.com>
References: <20201203183204.63759-1-wenyang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

[ Upstream commit 7bc3e6e55acf065500a24621f3b313e7e5998acf ]

Rework the flushing of proc to use a list of directory inodes that
need to be flushed.

The list is kept on struct pid not on struct task_struct, as there is
a fixed connection between proc inodes and pids but at least for the
case of de_thread the pid of a task_struct changes.

This removes the dependency on proc_mnt which allows for different
mounts of proc having different mount options even in the same pid
namespace and this allows for the removal of proc_mnt which will
trivially the first mount of proc to honor it's mount options.

This flushing remains an optimization.  The functions
pid_delete_dentry and pid_revalidate ensure that ordinary dcache
management will not attempt to use dentries past the point their
respective task has died.  When unused the shrinker will
eventually be able to remove these dentries.

There is a case in de_thread where proc_flush_pid can be
called early for a given pid.  Which winds up being
safe (if suboptimal) as this is just an optiimization.

Only pid directories are put on the list as the other
per pid files are children of those directories and
d_invalidate on the directory will get them as well.

So that the pid can be used during flushing it's reference count is
taken in release_task and dropped in proc_flush_pid.  Further the call
of proc_flush_pid is moved after the tasklist_lock is released in
release_task so that it is certain that the pid has already been
unhashed when flushing it taking place.  This removes a small race
where a dentry could recreated.

As struct pid is supposed to be small and I need a per pid lock
I reuse the only lock that currently exists in struct pid the
the wait_pidfd.lock.

The net result is that this adds all of this functionality
with just a little extra list management overhead and
a single extra pointer in struct pid.

v2: Initialize pid->inodes.  I somehow failed to get that
    initialization into the initial version of the patch.  A boot
    failure was reported by "kernel test robot <lkp@intel.com>", and
    failure to initialize that pid->inodes matches all of the reported
    symptoms.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Fixes: f333c700c610 ("pidns: Add a limit on the number of pid namespaces")
Fixes: 60347f6716aa ("pid namespaces: prepare proc_flust_task() to flush entries from multiple proc trees")
Cc: <stable@vger.kernel.org> # 4.9.x: b3e5838: clone: add CLONE_PIDFD
Cc: <stable@vger.kernel.org> # 4.9.x: b53b0b9: pidfd: add polling support
Cc: <stable@vger.kernel.org> # 4.9.x: db978da: proc: Pass file mode to proc_pid_make_inode
Cc: <stable@vger.kernel.org> # 4.9.x: 68eb94f: proc: Better ownership of files for non-dumpable tasks in user namespaces
Cc: <stable@vger.kernel.org> # 4.9.x: e3912ac: proc: use %u for pid printing and slightly less stack
Cc: <stable@vger.kernel.org> # 4.9.x: 0afa5ca: proc: Rename in proc_inode rename sysctl_inodes sibling_inodes
Cc: <stable@vger.kernel.org> # 4.9.x: 26dbc60: proc: Generalize proc_sys_prune_dcache into proc_prune_siblings_dcache
Cc: <stable@vger.kernel.org> # 4.9.x: 7144801: proc: Clear the pieces of proc_inode that proc_evict_inode cares about
Cc: <stable@vger.kernel.org> # 4.9.x: f90f3ca: Use d_invalidate in proc_prune_siblings_dcache
Cc: <stable@vger.kernel.org> # 4.9.x
(proc: fix up cherry-pick conflicts for 7bc3e6e55acf)
Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
---
 fs/proc/base.c          | 111 ++++++++++++++++--------------------------------
 fs/proc/inode.c         |   2 +-
 fs/proc/internal.h      |   1 +
 include/linux/pid.h     |   1 +
 include/linux/proc_fs.h |   4 +-
 kernel/exit.c           |   5 ++-
 kernel/pid.c            |   1 +
 7 files changed, 45 insertions(+), 80 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 3502a40..11caf35 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1728,11 +1728,25 @@ void task_dump_owner(struct task_struct *task, mode_t mode,
 	*rgid = gid;
 }
 
+void proc_pid_evict_inode(struct proc_inode *ei)
+{
+	struct pid *pid = ei->pid;
+
+	if (S_ISDIR(ei->vfs_inode.i_mode)) {
+		spin_lock(&pid->wait_pidfd.lock);
+		hlist_del_init_rcu(&ei->sibling_inodes);
+		spin_unlock(&pid->wait_pidfd.lock);
+	}
+
+	put_pid(pid);
+}
+
 struct inode *proc_pid_make_inode(struct super_block * sb,
 				  struct task_struct *task, umode_t mode)
 {
 	struct inode * inode;
 	struct proc_inode *ei;
+	struct pid *pid;
 
 	/* We need a new inode */
 
@@ -1750,10 +1764,18 @@ struct inode *proc_pid_make_inode(struct super_block * sb,
 	/*
 	 * grab the reference to task.
 	 */
-	ei->pid = get_task_pid(task, PIDTYPE_PID);
-	if (!ei->pid)
+	pid = get_task_pid(task, PIDTYPE_PID);
+	if (!pid)
 		goto out_unlock;
 
+	/* Let the pid remember us for quick removal */
+	ei->pid = pid;
+	if (S_ISDIR(mode)) {
+		spin_lock(&pid->wait_pidfd.lock);
+		hlist_add_head_rcu(&ei->sibling_inodes, &pid->inodes);
+		spin_unlock(&pid->wait_pidfd.lock);
+	}
+
 	task_dump_owner(task, 0, &inode->i_uid, &inode->i_gid);
 	security_task_to_inode(task, inode);
 
@@ -3015,90 +3037,29 @@ static struct dentry *proc_tgid_base_lookup(struct inode *dir, struct dentry *de
 	.permission	= proc_pid_permission,
 };
 
-static void proc_flush_task_mnt(struct vfsmount *mnt, pid_t pid, pid_t tgid)
-{
-	struct dentry *dentry, *leader, *dir;
-	char buf[10 + 1];
-	struct qstr name;
-
-	name.name = buf;
-	name.len = snprintf(buf, sizeof(buf), "%u", pid);
-	/* no ->d_hash() rejects on procfs */
-	dentry = d_hash_and_lookup(mnt->mnt_root, &name);
-	if (dentry) {
-		d_invalidate(dentry);
-		dput(dentry);
-	}
-
-	if (pid == tgid)
-		return;
-
-	name.name = buf;
-	name.len = snprintf(buf, sizeof(buf), "%u", tgid);
-	leader = d_hash_and_lookup(mnt->mnt_root, &name);
-	if (!leader)
-		goto out;
-
-	name.name = "task";
-	name.len = strlen(name.name);
-	dir = d_hash_and_lookup(leader, &name);
-	if (!dir)
-		goto out_put_leader;
-
-	name.name = buf;
-	name.len = snprintf(buf, sizeof(buf), "%u", pid);
-	dentry = d_hash_and_lookup(dir, &name);
-	if (dentry) {
-		d_invalidate(dentry);
-		dput(dentry);
-	}
-
-	dput(dir);
-out_put_leader:
-	dput(leader);
-out:
-	return;
-}
-
 /**
- * proc_flush_task -  Remove dcache entries for @task from the /proc dcache.
- * @task: task that should be flushed.
+ * proc_flush_pid -  Remove dcache entries for @pid from the /proc dcache.
+ * @pid: pid that should be flushed.
  *
- * When flushing dentries from proc, one needs to flush them from global
- * proc (proc_mnt) and from all the namespaces' procs this task was seen
- * in. This call is supposed to do all of this job.
- *
- * Looks in the dcache for
- * /proc/@pid
- * /proc/@tgid/task/@pid
- * if either directory is present flushes it and all of it'ts children
- * from the dcache.
+ * This function walks a list of inodes (that belong to any proc
+ * filesystem) that are attached to the pid and flushes them from
+ * the dentry cache.
  *
  * It is safe and reasonable to cache /proc entries for a task until
  * that task exits.  After that they just clog up the dcache with
  * useless entries, possibly causing useful dcache entries to be
- * flushed instead.  This routine is proved to flush those useless
- * dcache entries at process exit time.
+ * flushed instead.  This routine is provided to flush those useless
+ * dcache entries when a process is reaped.
  *
  * NOTE: This routine is just an optimization so it does not guarantee
- *       that no dcache entries will exist at process exit time it
- *       just makes it very unlikely that any will persist.
+ *       that no dcache entries will exist after a process is reaped
+ *       it just makes it very unlikely that any will persist.
  */
 
-void proc_flush_task(struct task_struct *task)
+void proc_flush_pid(struct pid *pid)
 {
-	int i;
-	struct pid *pid, *tgid;
-	struct upid *upid;
-
-	pid = task_pid(task);
-	tgid = task_tgid(task);
-
-	for (i = 0; i <= pid->level; i++) {
-		upid = &pid->numbers[i];
-		proc_flush_task_mnt(upid->ns->proc_mnt, upid->nr,
-					tgid->numbers[i].nr);
-	}
+	proc_invalidate_siblings_dcache(&pid->inodes, &pid->wait_pidfd.lock);
+	put_pid(pid);
 }
 
 static int proc_pid_instantiate(struct inode *dir,
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 2af9f4f..8503444 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -39,7 +39,7 @@ static void proc_evict_inode(struct inode *inode)
 
 	/* Stop tracking associated processes */
 	if (ei->pid) {
-		put_pid(ei->pid);
+		proc_pid_evict_inode(ei);
 		ei->pid = NULL;
 	}
 
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 6a1d679..0c6ca639 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -151,6 +151,7 @@ extern int proc_pid_statm(struct seq_file *, struct pid_namespace *,
 extern const struct dentry_operations pid_dentry_operations;
 extern int pid_getattr(struct vfsmount *, struct dentry *, struct kstat *);
 extern int proc_setattr(struct dentry *, struct iattr *);
+extern void proc_pid_evict_inode(struct proc_inode *);
 extern struct inode *proc_pid_make_inode(struct super_block *, struct task_struct *, umode_t);
 extern int pid_revalidate(struct dentry *, unsigned int);
 extern int pid_delete_dentry(const struct dentry *);
diff --git a/include/linux/pid.h b/include/linux/pid.h
index f5552ba..04b4aaa 100644
--- a/include/linux/pid.h
+++ b/include/linux/pid.h
@@ -63,6 +63,7 @@ struct pid
 	unsigned int level;
 	/* lists of tasks that use this pid */
 	struct hlist_head tasks[PIDTYPE_MAX];
+	struct hlist_head inodes;
 	/* wait queue for pidfd notifications */
 	wait_queue_head_t wait_pidfd;
 	struct rcu_head rcu;
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index b97bf2e..d3580f5 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -12,7 +12,7 @@
 #ifdef CONFIG_PROC_FS
 
 extern void proc_root_init(void);
-extern void proc_flush_task(struct task_struct *);
+extern void proc_flush_pid(struct pid *);
 
 extern struct proc_dir_entry *proc_symlink(const char *,
 		struct proc_dir_entry *, const char *);
@@ -48,7 +48,7 @@ static inline void proc_root_init(void)
 {
 }
 
-static inline void proc_flush_task(struct task_struct *task)
+static inline void proc_flush_pid(struct pid *pid)
 {
 }
 
diff --git a/kernel/exit.c b/kernel/exit.c
index f9943ef..5e66030 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -168,6 +168,7 @@ static void delayed_put_task_struct(struct rcu_head *rhp)
 void release_task(struct task_struct *p)
 {
 	struct task_struct *leader;
+	struct pid *thread_pid;
 	int zap_leader;
 repeat:
 	/* don't need to get the RCU readlock here - the process is dead and
@@ -176,10 +177,9 @@ void release_task(struct task_struct *p)
 	atomic_dec(&__task_cred(p)->user->processes);
 	rcu_read_unlock();
 
-	proc_flush_task(p);
-
 	write_lock_irq(&tasklist_lock);
 	ptrace_release_task(p);
+	thread_pid = get_pid(p->pids[PIDTYPE_PID].pid);
 	__exit_signal(p);
 
 	/*
@@ -202,6 +202,7 @@ void release_task(struct task_struct *p)
 	}
 
 	write_unlock_irq(&tasklist_lock);
+	proc_flush_pid(thread_pid);
 	release_thread(p);
 	call_rcu(&p->rcu, delayed_put_task_struct);
 
diff --git a/kernel/pid.c b/kernel/pid.c
index e605398..fb32a81 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -334,6 +334,7 @@ struct pid *alloc_pid(struct pid_namespace *ns)
 		INIT_HLIST_HEAD(&pid->tasks[type]);
 
 	init_waitqueue_head(&pid->wait_pidfd);
+	INIT_HLIST_HEAD(&pid->inodes);
 
 	upid = pid->numbers + ns->level;
 	spin_lock_irq(&pidmap_lock);
-- 
1.8.3.1

