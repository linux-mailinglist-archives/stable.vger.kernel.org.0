Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64D9C2ECB41
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 08:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727468AbhAGHyF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 02:54:05 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:54133 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727416AbhAGHyE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 02:54:04 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=wenyang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UKzE3St_1610005999;
Received: from localhost(mailfrom:wenyang@linux.alibaba.com fp:SMTPD_---0UKzE3St_1610005999)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 07 Jan 2021 15:53:19 +0800
From:   Wen Yang <wenyang@linux.alibaba.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Xunlei Pang <xlpang@linux.alibaba.com>,
        linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        stable@vger.kernel.org, Wen Yang <wenyang@linux.alibaba.com>
Subject: [PATCH 4.19 4/7] proc: Generalize proc_sys_prune_dcache into proc_prune_siblings_dcache
Date:   Thu,  7 Jan 2021 15:53:11 +0800
Message-Id: <20210107075314.62683-5-wenyang@linux.alibaba.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210107075314.62683-1-wenyang@linux.alibaba.com>
References: <20210107075314.62683-1-wenyang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

[ Upstream commit 26dbc60f385ff9cff475ea2a3bad02e80fd6fa43 ]

This prepares the way for allowing the pid part of proc to use this
dcache pruning code as well.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: <stable@vger.kernel.org> # 4.19.x
Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
---
 fs/proc/inode.c       | 38 ++++++++++++++++++++++++++++++++++++++
 fs/proc/internal.h    |  1 +
 fs/proc/proc_sysctl.c | 35 +----------------------------------
 3 files changed, 40 insertions(+), 34 deletions(-)

diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index e5334ed..fffc7e4 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -112,6 +112,44 @@ void __init proc_init_kmemcache(void)
 	BUILD_BUG_ON(sizeof(struct proc_dir_entry) >= SIZEOF_PDE);
 }
 
+void proc_prune_siblings_dcache(struct hlist_head *inodes, spinlock_t *lock)
+{
+	struct inode *inode;
+	struct proc_inode *ei;
+	struct hlist_node *node;
+	struct super_block *sb;
+
+	rcu_read_lock();
+	for (;;) {
+		node = hlist_first_rcu(inodes);
+		if (!node)
+			break;
+		ei = hlist_entry(node, struct proc_inode, sibling_inodes);
+		spin_lock(lock);
+		hlist_del_init_rcu(&ei->sibling_inodes);
+		spin_unlock(lock);
+
+		inode = &ei->vfs_inode;
+		sb = inode->i_sb;
+		if (!atomic_inc_not_zero(&sb->s_active))
+			continue;
+		inode = igrab(inode);
+		rcu_read_unlock();
+		if (unlikely(!inode)) {
+			deactivate_super(sb);
+			rcu_read_lock();
+			continue;
+		}
+
+		d_prune_aliases(inode);
+		iput(inode);
+		deactivate_super(sb);
+
+		rcu_read_lock();
+	}
+	rcu_read_unlock();
+}
+
 static int proc_show_options(struct seq_file *seq, struct dentry *root)
 {
 	struct super_block *sb = root->d_sb;
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index d922c01..6cae472 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -210,6 +210,7 @@ struct pde_opener {
 extern const struct inode_operations proc_pid_link_inode_operations;
 
 void proc_init_kmemcache(void);
+void proc_prune_siblings_dcache(struct hlist_head *inodes, spinlock_t *lock);
 void set_proc_pid_nlink(void);
 extern struct inode *proc_get_inode(struct super_block *, struct proc_dir_entry *);
 extern int proc_fill_super(struct super_block *, void *data, int flags);
diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 0f578f6..57b16bf 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -264,40 +264,7 @@ static void unuse_table(struct ctl_table_header *p)
 
 static void proc_sys_prune_dcache(struct ctl_table_header *head)
 {
-	struct inode *inode;
-	struct proc_inode *ei;
-	struct hlist_node *node;
-	struct super_block *sb;
-
-	rcu_read_lock();
-	for (;;) {
-		node = hlist_first_rcu(&head->inodes);
-		if (!node)
-			break;
-		ei = hlist_entry(node, struct proc_inode, sibling_inodes);
-		spin_lock(&sysctl_lock);
-		hlist_del_init_rcu(&ei->sibling_inodes);
-		spin_unlock(&sysctl_lock);
-
-		inode = &ei->vfs_inode;
-		sb = inode->i_sb;
-		if (!atomic_inc_not_zero(&sb->s_active))
-			continue;
-		inode = igrab(inode);
-		rcu_read_unlock();
-		if (unlikely(!inode)) {
-			deactivate_super(sb);
-			rcu_read_lock();
-			continue;
-		}
-
-		d_prune_aliases(inode);
-		iput(inode);
-		deactivate_super(sb);
-
-		rcu_read_lock();
-	}
-	rcu_read_unlock();
+	proc_prune_siblings_dcache(&head->inodes, &sysctl_lock);
 }
 
 /* called under sysctl_lock, will reacquire if has to wait */
-- 
1.8.3.1

