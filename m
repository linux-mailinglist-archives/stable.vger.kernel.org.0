Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C07DA2CDDD1
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 19:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729250AbgLCSee (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 13:34:34 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:35160 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731753AbgLCSee (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Dec 2020 13:34:34 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R611e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=wenyang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UHR7EeT_1607020422;
Received: from localhost(mailfrom:wenyang@linux.alibaba.com fp:SMTPD_---0UHR7EeT_1607020422)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 04 Dec 2020 02:33:50 +0800
From:   Wen Yang <wenyang@linux.alibaba.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Xunlei Pang <xlpang@linux.alibaba.com>,
        linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        stable@vger.kernel.org, Wen Yang <wenyang@linux.alibaba.com>
Subject: [PATCH 09/10] proc: Use d_invalidate in proc_prune_siblings_dcache
Date:   Fri,  4 Dec 2020 02:32:03 +0800
Message-Id: <20201203183204.63759-10-wenyang@linux.alibaba.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20201203183204.63759-1-wenyang@linux.alibaba.com>
References: <20201203183204.63759-1-wenyang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

[ Upstream commit f90f3cafe8d56d593fc509a4185da1d5800efea4 ]

The function d_prune_aliases has the problem that it will only prune
aliases thare are completely unused.  It will not remove aliases for
the dcache or even think of removing mounts from the dcache.  For that
behavior d_invalidate is needed.

To use d_invalidate replace d_prune_aliases with d_find_alias followed
by d_invalidate and dput.

For completeness the directory and the non-directory cases are
separated because in theory (although not in currently in practice for
proc) directories can only ever have a single dentry while
non-directories can have hardlinks and thus multiple dentries.
As part of this separation use d_find_any_alias for directories
to spare d_find_alias the extra work of doing that.

Plus the differences between d_find_any_alias and d_find_alias makes
it clear why the directory and non-directory code and not share code.

To make it clear these routines now invalidate dentries rename
proc_prune_siblings_dache to proc_invalidate_siblings_dcache, and rename
proc_sys_prune_dcache proc_sys_invalidate_dcache.

V2: Split the directory and non-directory cases.  To make this
    code robust to future changes in proc.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: <stable@vger.kernel.org> # 4.9.x
(proc: fix up cherry-pick conflicts for f90f3cafe8d5)
Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
---
 fs/proc/inode.c       | 16 ++++++++++++++--
 fs/proc/internal.h    |  2 +-
 fs/proc/proc_sysctl.c |  8 ++++----
 3 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 739fb9c..2af9f4f 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -107,7 +107,7 @@ void __init proc_init_inodecache(void)
 					     init_once);
 }
 
-void proc_prune_siblings_dcache(struct hlist_head *inodes, spinlock_t *lock)
+void proc_invalidate_siblings_dcache(struct hlist_head *inodes, spinlock_t *lock)
 {
 	struct inode *inode;
 	struct proc_inode *ei;
@@ -136,7 +136,19 @@ void proc_prune_siblings_dcache(struct hlist_head *inodes, spinlock_t *lock)
 			continue;
 		}
 
-		d_prune_aliases(inode);
+		if (S_ISDIR(inode->i_mode)) {
+			struct dentry *dir = d_find_any_alias(inode);
+			if (dir) {
+				d_invalidate(dir);
+				dput(dir);
+			}
+		} else {
+			struct dentry *dentry;
+			while ((dentry = d_find_alias(inode))) {
+				d_invalidate(dentry);
+				dput(dentry);
+			}
+		}
 		iput(inode);
 		deactivate_super(sb);
 
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 9bc44a1..6a1d679 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -200,7 +200,7 @@ struct pde_opener {
 extern const struct inode_operations proc_pid_link_inode_operations;
 
 extern void proc_init_inodecache(void);
-void proc_prune_siblings_dcache(struct hlist_head *inodes, spinlock_t *lock);
+void proc_invalidate_siblings_dcache(struct hlist_head *inodes, spinlock_t *lock);
 extern struct inode *proc_get_inode(struct super_block *, struct proc_dir_entry *);
 extern int proc_fill_super(struct super_block *, void *data, int flags);
 extern void proc_entry_rundown(struct proc_dir_entry *);
diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index f19063b..b6668a5 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -260,9 +260,9 @@ static void unuse_table(struct ctl_table_header *p)
 			complete(p->unregistering);
 }
 
-static void proc_sys_prune_dcache(struct ctl_table_header *head)
+static void proc_sys_invalidate_dcache(struct ctl_table_header *head)
 {
-	proc_prune_siblings_dcache(&head->inodes, &sysctl_lock);
+	proc_invalidate_siblings_dcache(&head->inodes, &sysctl_lock);
 }
 
 /* called under sysctl_lock, will reacquire if has to wait */
@@ -284,10 +284,10 @@ static void start_unregistering(struct ctl_table_header *p)
 		spin_unlock(&sysctl_lock);
 	}
 	/*
-	 * Prune dentries for unregistered sysctls: namespaced sysctls
+	 * Invalidate dentries for unregistered sysctls: namespaced sysctls
 	 * can have duplicate names and contaminate dcache very badly.
 	 */
-	proc_sys_prune_dcache(p);
+	proc_sys_invalidate_dcache(p);
 	/*
 	 * do not remove from the list until nobody holds it; walking the
 	 * list in do_sysctl() relies on that.
-- 
1.8.3.1

