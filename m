Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 889A6594DE2
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232926AbiHPArD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345152AbiHPAon (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:44:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E356419355A;
        Mon, 15 Aug 2022 13:41:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80AAA611FA;
        Mon, 15 Aug 2022 20:41:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 621A8C433C1;
        Mon, 15 Aug 2022 20:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596081;
        bh=nVMdcBlouv+h8tgYWELNWyRba2uklD9juymNbC0d7V8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NL/vWSzo+4kW9oEB5PDjBwle+BcO9LeJFYNLuU4gH0qAq+PiTk/yq6r4/WB+on4De
         0bsQlNyc1Xv/aDoUdT2e9mLEvB8QXdHmkMHCHaxxSwYkOTgnje2FqLcuubQUGYylo5
         4Vm9PLe2xhRINDDzyU9YHROlaQzxPUnCKqa8JjCk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhihao Cheng <chengzhihao1@huawei.com>,
        Zhang Yi <yi.zhang@huawei.com>,
        Brian Foster <bfoster@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Matthew Wilcox <willy@infradead.org>,
        Baoquan He <bhe@redhat.com>,
        Kalesh Singh <kaleshsingh@google.com>,
        Yu Kuai <yukuai3@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0966/1157] proc: fix a dentry lock race between release_task and lookup
Date:   Mon, 15 Aug 2022 20:05:22 +0200
Message-Id: <20220815180518.321198085@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit d919a1e79bac890421537cf02ae773007bf55e6b ]

Commit 7bc3e6e55acf06 ("proc: Use a list of inodes to flush from proc")
moved proc_flush_task() behind __exit_signal().  Then, process systemd can
take long period high cpu usage during releasing task in following
concurrent processes:

  systemd                                 ps
kernel_waitid                 stat(/proc/tgid)
  do_wait                       filename_lookup
    wait_consider_task            lookup_fast
      release_task
        __exit_signal
          __unhash_process
            detach_pid
              __change_pid // remove task->pid_links
                                     d_revalidate -> pid_revalidate  // 0
                                     d_invalidate(/proc/tgid)
                                       shrink_dcache_parent(/proc/tgid)
                                         d_walk(/proc/tgid)
                                           spin_lock_nested(/proc/tgid/fd)
                                           // iterating opened fd
        proc_flush_pid                                    |
           d_invalidate (/proc/tgid/fd)                   |
              shrink_dcache_parent(/proc/tgid/fd)         |
                shrink_dentry_list(subdirs)               ↓
                  shrink_lock_dentry(/proc/tgid/fd) --> race on dentry lock

Function d_invalidate() will remove dentry from hash firstly, but why does
proc_flush_pid() process dentry '/proc/tgid/fd' before dentry
'/proc/tgid'?  That's because proc_pid_make_inode() adds proc inode in
reverse order by invoking hlist_add_head_rcu().  But proc should not add
any inodes under '/proc/tgid' except '/proc/tgid/task/pid', fix it by
adding inode into 'pid->inodes' only if the inode is /proc/tgid or
/proc/tgid/task/pid.

Performance regression:
Create 200 tasks, each task open one file for 50,000 times. Kill all
tasks when opened files exceed 10,000,000 (cat /proc/sys/fs/file-nr).

Before fix:
$ time killall -wq aa
  real    4m40.946s   # During this period, we can see 'ps' and 'systemd'
			taking high cpu usage.

After fix:
$ time killall -wq aa
  real    1m20.732s   # During this period, we can see 'systemd' taking
			high cpu usage.

Link: https://lkml.kernel.org/r/20220713130029.4133533-1-chengzhihao1@huawei.com
Fixes: 7bc3e6e55acf06 ("proc: Use a list of inodes to flush from proc")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216054
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Suggested-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/base.c | 46 ++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 38 insertions(+), 8 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 8dfa36a99c74..93f7e3d971e4 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1885,7 +1885,7 @@ void proc_pid_evict_inode(struct proc_inode *ei)
 	put_pid(pid);
 }
 
-struct inode *proc_pid_make_inode(struct super_block * sb,
+struct inode *proc_pid_make_inode(struct super_block *sb,
 				  struct task_struct *task, umode_t mode)
 {
 	struct inode * inode;
@@ -1914,11 +1914,6 @@ struct inode *proc_pid_make_inode(struct super_block * sb,
 
 	/* Let the pid remember us for quick removal */
 	ei->pid = pid;
-	if (S_ISDIR(mode)) {
-		spin_lock(&pid->lock);
-		hlist_add_head_rcu(&ei->sibling_inodes, &pid->inodes);
-		spin_unlock(&pid->lock);
-	}
 
 	task_dump_owner(task, 0, &inode->i_uid, &inode->i_gid);
 	security_task_to_inode(task, inode);
@@ -1931,6 +1926,39 @@ struct inode *proc_pid_make_inode(struct super_block * sb,
 	return NULL;
 }
 
+/*
+ * Generating an inode and adding it into @pid->inodes, so that task will
+ * invalidate inode's dentry before being released.
+ *
+ * This helper is used for creating dir-type entries under '/proc' and
+ * '/proc/<tgid>/task'. Other entries(eg. fd, stat) under '/proc/<tgid>'
+ * can be released by invalidating '/proc/<tgid>' dentry.
+ * In theory, dentries under '/proc/<tgid>/task' can also be released by
+ * invalidating '/proc/<tgid>' dentry, we reserve it to handle single
+ * thread exiting situation: Any one of threads should invalidate its
+ * '/proc/<tgid>/task/<pid>' dentry before released.
+ */
+static struct inode *proc_pid_make_base_inode(struct super_block *sb,
+				struct task_struct *task, umode_t mode)
+{
+	struct inode *inode;
+	struct proc_inode *ei;
+	struct pid *pid;
+
+	inode = proc_pid_make_inode(sb, task, mode);
+	if (!inode)
+		return NULL;
+
+	/* Let proc_flush_pid find this directory inode */
+	ei = PROC_I(inode);
+	pid = ei->pid;
+	spin_lock(&pid->lock);
+	hlist_add_head_rcu(&ei->sibling_inodes, &pid->inodes);
+	spin_unlock(&pid->lock);
+
+	return inode;
+}
+
 int pid_getattr(struct user_namespace *mnt_userns, const struct path *path,
 		struct kstat *stat, u32 request_mask, unsigned int query_flags)
 {
@@ -3369,7 +3397,8 @@ static struct dentry *proc_pid_instantiate(struct dentry * dentry,
 {
 	struct inode *inode;
 
-	inode = proc_pid_make_inode(dentry->d_sb, task, S_IFDIR | S_IRUGO | S_IXUGO);
+	inode = proc_pid_make_base_inode(dentry->d_sb, task,
+					 S_IFDIR | S_IRUGO | S_IXUGO);
 	if (!inode)
 		return ERR_PTR(-ENOENT);
 
@@ -3671,7 +3700,8 @@ static struct dentry *proc_task_instantiate(struct dentry *dentry,
 	struct task_struct *task, const void *ptr)
 {
 	struct inode *inode;
-	inode = proc_pid_make_inode(dentry->d_sb, task, S_IFDIR | S_IRUGO | S_IXUGO);
+	inode = proc_pid_make_base_inode(dentry->d_sb, task,
+					 S_IFDIR | S_IRUGO | S_IXUGO);
 	if (!inode)
 		return ERR_PTR(-ENOENT);
 
-- 
2.35.1



