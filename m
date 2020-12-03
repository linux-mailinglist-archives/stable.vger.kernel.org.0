Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C80A52CDDC6
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 19:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731703AbgLCSdy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 13:33:54 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:51471 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726462AbgLCSdy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Dec 2020 13:33:54 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=wenyang@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0UHRKr11_1607020381;
Received: from localhost(mailfrom:wenyang@linux.alibaba.com fp:SMTPD_---0UHRKr11_1607020381)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 04 Dec 2020 02:33:11 +0800
From:   Wen Yang <wenyang@linux.alibaba.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Xunlei Pang <xlpang@linux.alibaba.com>,
        linux-kernel@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Alexander Viro <viro@ftp.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        stable@vger.kernel.org, Wen Yang <wenyang@linux.alibaba.com>
Subject: [PATCH 05/10] proc: use %u for pid printing and slightly less stack
Date:   Fri,  4 Dec 2020 02:31:59 +0800
Message-Id: <20201203183204.63759-6-wenyang@linux.alibaba.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20201203183204.63759-1-wenyang@linux.alibaba.com>
References: <20201203183204.63759-1-wenyang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>

[ Upstream commit e3912ac37e07a13c70675cd75020694de4841c74 ]

PROC_NUMBUF is 13 which is enough for "negative int + \n + \0".

However PIDs and TGIDs are never negative and newline is not a concern,
so use just 10 per integer.

Link: http://lkml.kernel.org/r/20171120203005.GA27743@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Alexander Viro <viro@ftp.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <stable@vger.kernel.org> # 4.9.x
Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
---
 fs/proc/base.c        | 16 ++++++++--------
 fs/proc/fd.c          |  2 +-
 fs/proc/self.c        |  6 +++---
 fs/proc/thread_self.c |  5 ++---
 4 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 5bfdb61..3502a40 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -3018,11 +3018,11 @@ static struct dentry *proc_tgid_base_lookup(struct inode *dir, struct dentry *de
 static void proc_flush_task_mnt(struct vfsmount *mnt, pid_t pid, pid_t tgid)
 {
 	struct dentry *dentry, *leader, *dir;
-	char buf[PROC_NUMBUF];
+	char buf[10 + 1];
 	struct qstr name;
 
 	name.name = buf;
-	name.len = snprintf(buf, sizeof(buf), "%d", pid);
+	name.len = snprintf(buf, sizeof(buf), "%u", pid);
 	/* no ->d_hash() rejects on procfs */
 	dentry = d_hash_and_lookup(mnt->mnt_root, &name);
 	if (dentry) {
@@ -3034,7 +3034,7 @@ static void proc_flush_task_mnt(struct vfsmount *mnt, pid_t pid, pid_t tgid)
 		return;
 
 	name.name = buf;
-	name.len = snprintf(buf, sizeof(buf), "%d", tgid);
+	name.len = snprintf(buf, sizeof(buf), "%u", tgid);
 	leader = d_hash_and_lookup(mnt->mnt_root, &name);
 	if (!leader)
 		goto out;
@@ -3046,7 +3046,7 @@ static void proc_flush_task_mnt(struct vfsmount *mnt, pid_t pid, pid_t tgid)
 		goto out_put_leader;
 
 	name.name = buf;
-	name.len = snprintf(buf, sizeof(buf), "%d", pid);
+	name.len = snprintf(buf, sizeof(buf), "%u", pid);
 	dentry = d_hash_and_lookup(dir, &name);
 	if (dentry) {
 		d_invalidate(dentry);
@@ -3226,14 +3226,14 @@ int proc_pid_readdir(struct file *file, struct dir_context *ctx)
 	for (iter = next_tgid(ns, iter);
 	     iter.task;
 	     iter.tgid += 1, iter = next_tgid(ns, iter)) {
-		char name[PROC_NUMBUF];
+		char name[10 + 1];
 		int len;
 
 		cond_resched();
 		if (!has_pid_permissions(ns, iter.task, 2))
 			continue;
 
-		len = snprintf(name, sizeof(name), "%d", iter.tgid);
+		len = snprintf(name, sizeof(name), "%u", iter.tgid);
 		ctx->pos = iter.tgid + TGID_OFFSET;
 		if (!proc_fill_cache(file, ctx, name, len,
 				     proc_pid_instantiate, iter.task, NULL)) {
@@ -3557,10 +3557,10 @@ static int proc_task_readdir(struct file *file, struct dir_context *ctx)
 	for (task = first_tid(proc_pid(inode), tid, ctx->pos - 2, ns);
 	     task;
 	     task = next_tid(task), ctx->pos++) {
-		char name[PROC_NUMBUF];
+		char name[10 + 1];
 		int len;
 		tid = task_pid_nr_ns(task, ns);
-		len = snprintf(name, sizeof(name), "%d", tid);
+		len = snprintf(name, sizeof(name), "%u", tid);
 		if (!proc_fill_cache(file, ctx, name, len,
 				proc_task_instantiate, task, NULL)) {
 			/* returning this tgid failed, save it as the first
diff --git a/fs/proc/fd.c b/fs/proc/fd.c
index 00ce153..390c2fe 100644
--- a/fs/proc/fd.c
+++ b/fs/proc/fd.c
@@ -235,7 +235,7 @@ static int proc_readfd_common(struct file *file, struct dir_context *ctx,
 	for (fd = ctx->pos - 2;
 	     fd < files_fdtable(files)->max_fds;
 	     fd++, ctx->pos++) {
-		char name[PROC_NUMBUF];
+		char name[10 + 1];
 		int len;
 
 		if (!fcheck_files(files, fd))
diff --git a/fs/proc/self.c b/fs/proc/self.c
index f6e2e3f..dd06755 100644
--- a/fs/proc/self.c
+++ b/fs/proc/self.c
@@ -35,11 +35,11 @@ static const char *proc_self_get_link(struct dentry *dentry,
 
 	if (!tgid)
 		return ERR_PTR(-ENOENT);
-	/* 11 for max length of signed int in decimal + NULL term */
-	name = kmalloc(12, dentry ? GFP_KERNEL : GFP_ATOMIC);
+	/* max length of unsigned int in decimal + NULL term */
+	name = kmalloc(10 + 1, dentry ? GFP_KERNEL : GFP_ATOMIC);
 	if (unlikely(!name))
 		return dentry ? ERR_PTR(-ENOMEM) : ERR_PTR(-ECHILD);
-	sprintf(name, "%d", tgid);
+	sprintf(name, "%u", tgid);
 	set_delayed_call(done, kfree_link, name);
 	return name;
 }
diff --git a/fs/proc/thread_self.c b/fs/proc/thread_self.c
index 02d1db8..44e0921 100644
--- a/fs/proc/thread_self.c
+++ b/fs/proc/thread_self.c
@@ -30,11 +30,10 @@ static const char *proc_thread_self_get_link(struct dentry *dentry,
 
 	if (!pid)
 		return ERR_PTR(-ENOENT);
-	name = kmalloc(PROC_NUMBUF + 6 + PROC_NUMBUF,
-				dentry ? GFP_KERNEL : GFP_ATOMIC);
+	name = kmalloc(10 + 6 + 10 + 1, dentry ? GFP_KERNEL : GFP_ATOMIC);
 	if (unlikely(!name))
 		return dentry ? ERR_PTR(-ENOMEM) : ERR_PTR(-ECHILD);
-	sprintf(name, "%d/task/%d", tgid, pid);
+	sprintf(name, "%u/task/%u", tgid, pid);
 	set_delayed_call(done, kfree_link, name);
 	return name;
 }
-- 
1.8.3.1

