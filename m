Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D49362ECB33
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 08:55:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727322AbhAGHxe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 02:53:34 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:36086 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727286AbhAGHxd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 02:53:33 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R621e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=wenyang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UKzNwAb_1610005958;
Received: from localhost(mailfrom:wenyang@linux.alibaba.com fp:SMTPD_---0UKzNwAb_1610005958)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 07 Jan 2021 15:52:38 +0800
From:   Wen Yang <wenyang@linux.alibaba.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Xunlei Pang <xlpang@linux.alibaba.com>,
        linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        stable@vger.kernel.org, Wen Yang <wenyang@linux.alibaba.com>
Subject: [PATCH v2 4.9 07/10] proc: Generalize proc_sys_prune_dcache into proc_prune_siblings_dcache
Date:   Thu,  7 Jan 2021 15:52:19 +0800
Message-Id: <20210107075222.62623-8-wenyang@linux.alibaba.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210107075222.62623-1-wenyang@linux.alibaba.com>
References: <20210107075222.62623-1-wenyang@linux.alibaba.com>
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
Cc: <stable@vger.kernel.org> # 4.9.x
(proc: fix up cherry-pick conflicts for 26dbc60f385f)
Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
---
 fs/proc/inode.c       | 38 ++++++++++++++++++++++++++++++++++++++
 fs/proc/internal.h    |  1 +
 fs/proc/proc_sysctl.c | 35 +----------------------------------
 3 files changed, 40 insertions(+), 34 deletions(-)

diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 14d9c1d..920c761 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -101,6 +101,44 @@ void __init proc_init_inodecache(void)
 					     init_once);
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
index 409b5c5..9bc44a1 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -200,6 +200,7 @@ struct pde_opener {
 extern const struct inode_operations proc_pid_link_inode_operations;
 
 extern void proc_init_inodecache(void);
+void proc_prune_siblings_dcache(struct hlist_head *inodes, spinlock_t *lock);
 extern struct inode *proc_get_inode(struct super_block *, struct proc_dir_entry *);
 extern int proc_fill_super(struct super_block *, void *data, int flags);
 extern void proc_entry_rundown(struct proc_dir_entry *);
diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 671490e..f19063b 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -262,40 +262,7 @@ static void unuse_table(struct ctl_table_header *p)
 
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

