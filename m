Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 827AC2CDDBF
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 19:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731674AbgLCSdf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 13:33:35 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:52330 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728065AbgLCSdf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Dec 2020 13:33:35 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=wenyang@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UHQtLl0_1607020361;
Received: from localhost(mailfrom:wenyang@linux.alibaba.com fp:SMTPD_---0UHQtLl0_1607020361)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 04 Dec 2020 02:32:51 +0800
From:   Wen Yang <wenyang@linux.alibaba.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Xunlei Pang <xlpang@linux.alibaba.com>,
        linux-kernel@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Paul Moore <paul@paul-moore.com>, stable@vger.kernel.org,
        Wen Yang <wenyang@linux.alibaba.com>
Subject: [PATCH 03/10] proc: Pass file mode to proc_pid_make_inode
Date:   Fri,  4 Dec 2020 02:31:57 +0800
Message-Id: <20201203183204.63759-4-wenyang@linux.alibaba.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20201203183204.63759-1-wenyang@linux.alibaba.com>
References: <20201203183204.63759-1-wenyang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit db978da8fa1d0819b210c137d31a339149b88875 ]

Pass the file mode of the proc inode to be created to
proc_pid_make_inode.  In proc_pid_make_inode, initialize inode->i_mode
before calling security_task_to_inode.  This allows selinux to set
isec->sclass right away without introducing "half-initialized" inode
security structs.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Cc: <stable@vger.kernel.org> # 4.9.x
Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
---
 fs/proc/base.c           | 23 +++++++++--------------
 fs/proc/fd.c             |  6 ++----
 fs/proc/internal.h       |  2 +-
 fs/proc/namespaces.c     |  3 +--
 security/selinux/hooks.c |  1 +
 5 files changed, 14 insertions(+), 21 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index b9e4183..ee2e0ec 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1676,7 +1676,8 @@ static int proc_pid_readlink(struct dentry * dentry, char __user * buffer, int b
 
 /* building an inode */
 
-struct inode *proc_pid_make_inode(struct super_block * sb, struct task_struct *task)
+struct inode *proc_pid_make_inode(struct super_block * sb,
+				  struct task_struct *task, umode_t mode)
 {
 	struct inode * inode;
 	struct proc_inode *ei;
@@ -1690,6 +1691,7 @@ struct inode *proc_pid_make_inode(struct super_block * sb, struct task_struct *t
 
 	/* Common stuff */
 	ei = PROC_I(inode);
+	inode->i_mode = mode;
 	inode->i_ino = get_next_ino();
 	inode->i_mtime = inode->i_atime = inode->i_ctime = current_time(inode);
 	inode->i_op = &proc_def_inode_operations;
@@ -2041,7 +2043,9 @@ struct map_files_info {
 	struct proc_inode *ei;
 	struct inode *inode;
 
-	inode = proc_pid_make_inode(dir->i_sb, task);
+	inode = proc_pid_make_inode(dir->i_sb, task, S_IFLNK |
+				    ((mode & FMODE_READ ) ? S_IRUSR : 0) |
+				    ((mode & FMODE_WRITE) ? S_IWUSR : 0));
 	if (!inode)
 		return -ENOENT;
 
@@ -2050,12 +2054,6 @@ struct map_files_info {
 
 	inode->i_op = &proc_map_files_link_inode_operations;
 	inode->i_size = 64;
-	inode->i_mode = S_IFLNK;
-
-	if (mode & FMODE_READ)
-		inode->i_mode |= S_IRUSR;
-	if (mode & FMODE_WRITE)
-		inode->i_mode |= S_IWUSR;
 
 	d_set_d_op(dentry, &tid_map_files_dentry_operations);
 	d_add(dentry, inode);
@@ -2409,12 +2407,11 @@ static int proc_pident_instantiate(struct inode *dir,
 	struct inode *inode;
 	struct proc_inode *ei;
 
-	inode = proc_pid_make_inode(dir->i_sb, task);
+	inode = proc_pid_make_inode(dir->i_sb, task, p->mode);
 	if (!inode)
 		goto out;
 
 	ei = PROC_I(inode);
-	inode->i_mode = p->mode;
 	if (S_ISDIR(inode->i_mode))
 		set_nlink(inode, 2);	/* Use getattr to fix if necessary */
 	if (p->iop)
@@ -3096,11 +3093,10 @@ static int proc_pid_instantiate(struct inode *dir,
 {
 	struct inode *inode;
 
-	inode = proc_pid_make_inode(dir->i_sb, task);
+	inode = proc_pid_make_inode(dir->i_sb, task, S_IFDIR | S_IRUGO | S_IXUGO);
 	if (!inode)
 		goto out;
 
-	inode->i_mode = S_IFDIR|S_IRUGO|S_IXUGO;
 	inode->i_op = &proc_tgid_base_inode_operations;
 	inode->i_fop = &proc_tgid_base_operations;
 	inode->i_flags|=S_IMMUTABLE;
@@ -3391,11 +3387,10 @@ static int proc_task_instantiate(struct inode *dir,
 	struct dentry *dentry, struct task_struct *task, const void *ptr)
 {
 	struct inode *inode;
-	inode = proc_pid_make_inode(dir->i_sb, task);
+	inode = proc_pid_make_inode(dir->i_sb, task, S_IFDIR | S_IRUGO | S_IXUGO);
 
 	if (!inode)
 		goto out;
-	inode->i_mode = S_IFDIR|S_IRUGO|S_IXUGO;
 	inode->i_op = &proc_tid_base_inode_operations;
 	inode->i_fop = &proc_tid_base_operations;
 	inode->i_flags|=S_IMMUTABLE;
diff --git a/fs/proc/fd.c b/fs/proc/fd.c
index d21dafe..4274f83 100644
--- a/fs/proc/fd.c
+++ b/fs/proc/fd.c
@@ -183,14 +183,13 @@ static int proc_fd_link(struct dentry *dentry, struct path *path)
 	struct proc_inode *ei;
 	struct inode *inode;
 
-	inode = proc_pid_make_inode(dir->i_sb, task);
+	inode = proc_pid_make_inode(dir->i_sb, task, S_IFLNK);
 	if (!inode)
 		goto out;
 
 	ei = PROC_I(inode);
 	ei->fd = fd;
 
-	inode->i_mode = S_IFLNK;
 	inode->i_op = &proc_pid_link_inode_operations;
 	inode->i_size = 64;
 
@@ -322,14 +321,13 @@ int proc_fd_permission(struct inode *inode, int mask)
 	struct proc_inode *ei;
 	struct inode *inode;
 
-	inode = proc_pid_make_inode(dir->i_sb, task);
+	inode = proc_pid_make_inode(dir->i_sb, task, S_IFREG | S_IRUSR);
 	if (!inode)
 		goto out;
 
 	ei = PROC_I(inode);
 	ei->fd = fd;
 
-	inode->i_mode = S_IFREG | S_IRUSR;
 	inode->i_fop = &proc_fdinfo_file_operations;
 
 	d_set_d_op(dentry, &tid_fd_dentry_operations);
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index c0bdece..5bc057b 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -163,7 +163,7 @@ extern int proc_pid_statm(struct seq_file *, struct pid_namespace *,
 extern const struct dentry_operations pid_dentry_operations;
 extern int pid_getattr(struct vfsmount *, struct dentry *, struct kstat *);
 extern int proc_setattr(struct dentry *, struct iattr *);
-extern struct inode *proc_pid_make_inode(struct super_block *, struct task_struct *);
+extern struct inode *proc_pid_make_inode(struct super_block *, struct task_struct *, umode_t);
 extern int pid_revalidate(struct dentry *, unsigned int);
 extern int pid_delete_dentry(const struct dentry *);
 extern int proc_pid_readdir(struct file *, struct dir_context *);
diff --git a/fs/proc/namespaces.c b/fs/proc/namespaces.c
index 51b8b0a..766f0c6 100644
--- a/fs/proc/namespaces.c
+++ b/fs/proc/namespaces.c
@@ -92,12 +92,11 @@ static int proc_ns_instantiate(struct inode *dir,
 	struct inode *inode;
 	struct proc_inode *ei;
 
-	inode = proc_pid_make_inode(dir->i_sb, task);
+	inode = proc_pid_make_inode(dir->i_sb, task, S_IFLNK | S_IRWXUGO);
 	if (!inode)
 		goto out;
 
 	ei = PROC_I(inode);
-	inode->i_mode = S_IFLNK|S_IRWXUGO;
 	inode->i_op = &proc_ns_link_inode_operations;
 	ei->ns_ops = ns_ops;
 
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index a2b63a6..98b5f40 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3967,6 +3967,7 @@ static void selinux_task_to_inode(struct task_struct *p,
 	struct inode_security_struct *isec = inode->i_security;
 	u32 sid = task_sid(p);
 
+	isec->sclass = inode_mode_to_security_class(inode->i_mode);
 	isec->sid = sid;
 	isec->initialized = LABEL_INITIALIZED;
 }
-- 
1.8.3.1

