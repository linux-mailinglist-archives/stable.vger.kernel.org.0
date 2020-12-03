Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC8A42CDDC8
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 19:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731713AbgLCSeF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 13:34:05 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:42292 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729312AbgLCSeF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Dec 2020 13:34:05 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R401e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=wenyang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UHQtLoS_1607020391;
Received: from localhost(mailfrom:wenyang@linux.alibaba.com fp:SMTPD_---0UHQtLoS_1607020391)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 04 Dec 2020 02:33:22 +0800
From:   Wen Yang <wenyang@linux.alibaba.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Xunlei Pang <xlpang@linux.alibaba.com>,
        linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        stable@vger.kernel.org, Wen Yang <wenyang@linux.alibaba.com>
Subject: [PATCH 06/10] proc: Rename in proc_inode rename sysctl_inodes sibling_inodes
Date:   Fri,  4 Dec 2020 02:32:00 +0800
Message-Id: <20201203183204.63759-7-wenyang@linux.alibaba.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20201203183204.63759-1-wenyang@linux.alibaba.com>
References: <20201203183204.63759-1-wenyang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

[ Upstream commit 0afa5ca82212247456f9de1468b595a111fee633 ]

I about to need and use the same functionality for pid based
inodes and there is no point in adding a second field when
this field is already here and serving the same purporse.

Just give the field a generic name so it is clear that
it is no longer sysctl specific.

Also for good measure initialize sibling_inodes when
proc_inode is initialized.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: <stable@vger.kernel.org> # 4.9.x
Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
---
 fs/proc/inode.c       | 1 +
 fs/proc/internal.h    | 2 +-
 fs/proc/proc_sysctl.c | 8 ++++----
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index a289349..14d9c1d 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -67,6 +67,7 @@ static struct inode *proc_alloc_inode(struct super_block *sb)
 	ei->pde = NULL;
 	ei->sysctl = NULL;
 	ei->sysctl_entry = NULL;
+	INIT_HLIST_NODE(&ei->sibling_inodes);
 	ei->ns_ops = NULL;
 	inode = &ei->vfs_inode;
 	return inode;
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 103435f..409b5c5 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -65,7 +65,7 @@ struct proc_inode {
 	struct proc_dir_entry *pde;
 	struct ctl_table_header *sysctl;
 	struct ctl_table *sysctl_entry;
-	struct hlist_node sysctl_inodes;
+	struct hlist_node sibling_inodes;
 	const struct proc_ns_operations *ns_ops;
 	struct inode vfs_inode;
 };
diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 191573a..671490e 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -272,9 +272,9 @@ static void proc_sys_prune_dcache(struct ctl_table_header *head)
 		node = hlist_first_rcu(&head->inodes);
 		if (!node)
 			break;
-		ei = hlist_entry(node, struct proc_inode, sysctl_inodes);
+		ei = hlist_entry(node, struct proc_inode, sibling_inodes);
 		spin_lock(&sysctl_lock);
-		hlist_del_init_rcu(&ei->sysctl_inodes);
+		hlist_del_init_rcu(&ei->sibling_inodes);
 		spin_unlock(&sysctl_lock);
 
 		inode = &ei->vfs_inode;
@@ -480,7 +480,7 @@ static struct inode *proc_sys_make_inode(struct super_block *sb,
 	}
 	ei->sysctl = head;
 	ei->sysctl_entry = table;
-	hlist_add_head_rcu(&ei->sysctl_inodes, &head->inodes);
+	hlist_add_head_rcu(&ei->sibling_inodes, &head->inodes);
 	head->count++;
 	spin_unlock(&sysctl_lock);
 
@@ -511,7 +511,7 @@ static struct inode *proc_sys_make_inode(struct super_block *sb,
 void proc_sys_evict_inode(struct inode *inode, struct ctl_table_header *head)
 {
 	spin_lock(&sysctl_lock);
-	hlist_del_init_rcu(&PROC_I(inode)->sysctl_inodes);
+	hlist_del_init_rcu(&PROC_I(inode)->sibling_inodes);
 	if (!--head->count)
 		kfree_rcu(head, rcu);
 	spin_unlock(&sysctl_lock);
-- 
1.8.3.1

