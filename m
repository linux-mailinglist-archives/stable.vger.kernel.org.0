Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D97092CDDC2
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 19:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727713AbgLCSdo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 13:33:44 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:60320 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726462AbgLCSdo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Dec 2020 13:33:44 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=wenyang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UHRBP-0_1607020372;
Received: from localhost(mailfrom:wenyang@linux.alibaba.com fp:SMTPD_---0UHRBP-0_1607020372)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 04 Dec 2020 02:33:01 +0800
From:   Wen Yang <wenyang@linux.alibaba.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Xunlei Pang <xlpang@linux.alibaba.com>,
        linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        stable@vger.kernel.org, Wen Yang <wenyang@linux.alibaba.com>
Subject: [PATCH 04/10] proc: Better ownership of files for non-dumpable tasks in user namespaces
Date:   Fri,  4 Dec 2020 02:31:58 +0800
Message-Id: <20201203183204.63759-5-wenyang@linux.alibaba.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20201203183204.63759-1-wenyang@linux.alibaba.com>
References: <20201203183204.63759-1-wenyang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

[ Upstream commit 68eb94f16227336a5773b83ecfa8290f1d6b78ce ]

Instead of making the files owned by the GLOBAL_ROOT_USER.  Make
non-dumpable files whose mm has always lived in a user namespace owned
by the user namespace root.  This allows the container root to have
things work as expected in a container.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: <stable@vger.kernel.org> # 4.9.x
Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
---
 fs/proc/base.c     | 102 ++++++++++++++++++++++++++++++-----------------------
 fs/proc/fd.c       |  12 +------
 fs/proc/internal.h |  16 ++-------
 3 files changed, 61 insertions(+), 69 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index ee2e0ec..5bfdb61 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1676,12 +1676,63 @@ static int proc_pid_readlink(struct dentry * dentry, char __user * buffer, int b
 
 /* building an inode */
 
+void task_dump_owner(struct task_struct *task, mode_t mode,
+		     kuid_t *ruid, kgid_t *rgid)
+{
+	/* Depending on the state of dumpable compute who should own a
+	 * proc file for a task.
+	 */
+	const struct cred *cred;
+	kuid_t uid;
+	kgid_t gid;
+
+	/* Default to the tasks effective ownership */
+	rcu_read_lock();
+	cred = __task_cred(task);
+	uid = cred->euid;
+	gid = cred->egid;
+	rcu_read_unlock();
+
+	/*
+	 * Before the /proc/pid/status file was created the only way to read
+	 * the effective uid of a /process was to stat /proc/pid.  Reading
+	 * /proc/pid/status is slow enough that procps and other packages
+	 * kept stating /proc/pid.  To keep the rules in /proc simple I have
+	 * made this apply to all per process world readable and executable
+	 * directories.
+	 */
+	if (mode != (S_IFDIR|S_IRUGO|S_IXUGO)) {
+		struct mm_struct *mm;
+		task_lock(task);
+		mm = task->mm;
+		/* Make non-dumpable tasks owned by some root */
+		if (mm) {
+			if (get_dumpable(mm) != SUID_DUMP_USER) {
+				struct user_namespace *user_ns = mm->user_ns;
+
+				uid = make_kuid(user_ns, 0);
+				if (!uid_valid(uid))
+					uid = GLOBAL_ROOT_UID;
+
+				gid = make_kgid(user_ns, 0);
+				if (!gid_valid(gid))
+					gid = GLOBAL_ROOT_GID;
+			}
+		} else {
+			uid = GLOBAL_ROOT_UID;
+			gid = GLOBAL_ROOT_GID;
+		}
+		task_unlock(task);
+	}
+	*ruid = uid;
+	*rgid = gid;
+}
+
 struct inode *proc_pid_make_inode(struct super_block * sb,
 				  struct task_struct *task, umode_t mode)
 {
 	struct inode * inode;
 	struct proc_inode *ei;
-	const struct cred *cred;
 
 	/* We need a new inode */
 
@@ -1703,13 +1754,7 @@ struct inode *proc_pid_make_inode(struct super_block * sb,
 	if (!ei->pid)
 		goto out_unlock;
 
-	if (task_dumpable(task)) {
-		rcu_read_lock();
-		cred = __task_cred(task);
-		inode->i_uid = cred->euid;
-		inode->i_gid = cred->egid;
-		rcu_read_unlock();
-	}
+	task_dump_owner(task, 0, &inode->i_uid, &inode->i_gid);
 	security_task_to_inode(task, inode);
 
 out:
@@ -1724,7 +1769,6 @@ int pid_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
 {
 	struct inode *inode = d_inode(dentry);
 	struct task_struct *task;
-	const struct cred *cred;
 	struct pid_namespace *pid = dentry->d_sb->s_fs_info;
 
 	generic_fillattr(inode, stat);
@@ -1742,12 +1786,7 @@ int pid_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
 			 */
 			return -ENOENT;
 		}
-		if ((inode->i_mode == (S_IFDIR|S_IRUGO|S_IXUGO)) ||
-		    task_dumpable(task)) {
-			cred = __task_cred(task);
-			stat->uid = cred->euid;
-			stat->gid = cred->egid;
-		}
+		task_dump_owner(task, inode->i_mode, &stat->uid, &stat->gid);
 	}
 	rcu_read_unlock();
 	return 0;
@@ -1763,18 +1802,11 @@ int pid_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
  * Rewrite the inode's ownerships here because the owning task may have
  * performed a setuid(), etc.
  *
- * Before the /proc/pid/status file was created the only way to read
- * the effective uid of a /process was to stat /proc/pid.  Reading
- * /proc/pid/status is slow enough that procps and other packages
- * kept stating /proc/pid.  To keep the rules in /proc simple I have
- * made this apply to all per process world readable and executable
- * directories.
  */
 int pid_revalidate(struct dentry *dentry, unsigned int flags)
 {
 	struct inode *inode;
 	struct task_struct *task;
-	const struct cred *cred;
 
 	if (flags & LOOKUP_RCU)
 		return -ECHILD;
@@ -1783,17 +1815,8 @@ int pid_revalidate(struct dentry *dentry, unsigned int flags)
 	task = get_proc_task(inode);
 
 	if (task) {
-		if ((inode->i_mode == (S_IFDIR|S_IRUGO|S_IXUGO)) ||
-		    task_dumpable(task)) {
-			rcu_read_lock();
-			cred = __task_cred(task);
-			inode->i_uid = cred->euid;
-			inode->i_gid = cred->egid;
-			rcu_read_unlock();
-		} else {
-			inode->i_uid = GLOBAL_ROOT_UID;
-			inode->i_gid = GLOBAL_ROOT_GID;
-		}
+		task_dump_owner(task, inode->i_mode, &inode->i_uid, &inode->i_gid);
+
 		inode->i_mode &= ~(S_ISUID | S_ISGID);
 		security_task_to_inode(task, inode);
 		put_task_struct(task);
@@ -1915,7 +1938,6 @@ static int map_files_d_revalidate(struct dentry *dentry, unsigned int flags)
 	bool exact_vma_exists = false;
 	struct mm_struct *mm = NULL;
 	struct task_struct *task;
-	const struct cred *cred;
 	struct inode *inode;
 	int status = 0;
 
@@ -1940,16 +1962,8 @@ static int map_files_d_revalidate(struct dentry *dentry, unsigned int flags)
 	mmput(mm);
 
 	if (exact_vma_exists) {
-		if (task_dumpable(task)) {
-			rcu_read_lock();
-			cred = __task_cred(task);
-			inode->i_uid = cred->euid;
-			inode->i_gid = cred->egid;
-			rcu_read_unlock();
-		} else {
-			inode->i_uid = GLOBAL_ROOT_UID;
-			inode->i_gid = GLOBAL_ROOT_GID;
-		}
+		task_dump_owner(task, 0, &inode->i_uid, &inode->i_gid);
+
 		security_task_to_inode(task, inode);
 		status = 1;
 	}
diff --git a/fs/proc/fd.c b/fs/proc/fd.c
index 4274f83..00ce153 100644
--- a/fs/proc/fd.c
+++ b/fs/proc/fd.c
@@ -84,7 +84,6 @@ static int tid_fd_revalidate(struct dentry *dentry, unsigned int flags)
 {
 	struct files_struct *files;
 	struct task_struct *task;
-	const struct cred *cred;
 	struct inode *inode;
 	unsigned int fd;
 
@@ -108,16 +107,7 @@ static int tid_fd_revalidate(struct dentry *dentry, unsigned int flags)
 				rcu_read_unlock();
 				put_files_struct(files);
 
-				if (task_dumpable(task)) {
-					rcu_read_lock();
-					cred = __task_cred(task);
-					inode->i_uid = cred->euid;
-					inode->i_gid = cred->egid;
-					rcu_read_unlock();
-				} else {
-					inode->i_uid = GLOBAL_ROOT_UID;
-					inode->i_gid = GLOBAL_ROOT_GID;
-				}
+				task_dump_owner(task, 0, &inode->i_uid, &inode->i_gid);
 
 				if (S_ISLNK(inode->i_mode)) {
 					unsigned i_mode = S_IFLNK;
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 5bc057b..103435f 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -98,20 +98,8 @@ static inline struct task_struct *get_proc_task(struct inode *inode)
 	return get_pid_task(proc_pid(inode), PIDTYPE_PID);
 }
 
-static inline int task_dumpable(struct task_struct *task)
-{
-	int dumpable = 0;
-	struct mm_struct *mm;
-
-	task_lock(task);
-	mm = task->mm;
-	if (mm)
-		dumpable = get_dumpable(mm);
-	task_unlock(task);
-	if (dumpable == SUID_DUMP_USER)
-		return 1;
-	return 0;
-}
+void task_dump_owner(struct task_struct *task, mode_t mode,
+		     kuid_t *ruid, kgid_t *rgid);
 
 static inline unsigned name_to_int(const struct qstr *qstr)
 {
-- 
1.8.3.1

