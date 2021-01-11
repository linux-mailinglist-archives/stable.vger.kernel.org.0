Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38EDC2F169E
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730599AbhAKNHe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:07:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:54966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730593AbhAKNHb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:07:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05507225AB;
        Mon, 11 Jan 2021 13:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370410;
        bh=EheAuyzw+jK4MPseS+6BEeu/4qczKLJmqGPGp20lZp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zpsV62HIwA9DfbpWnKB/uFotIdjOTY6hbTpsFhMP4e7qMrMZvsTQ8w1IPUK1/Acm0
         IcEXc1QcVzetsOHHxshz6qgWwGnJKWZ4wcDa7m2CCeHe8xHLrVcGf6nUxfMrzoaB2/
         Qb1w5dTZAknesqnd6GN96DPld13I0GU5QxnaRwxk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 10/77] proc: fix lookup in /proc/net subdirectories after setns(2)
Date:   Mon, 11 Jan 2021 14:01:19 +0100
Message-Id: <20210111130036.910114483@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130036.414620026@linuxfoundation.org>
References: <20210111130036.414620026@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>

[ Upstream commit c6c75deda81344c3a95d1d1f606d5cee109e5d54 ]

Commit 1fde6f21d90f ("proc: fix /proc/net/* after setns(2)") only forced
revalidation of regular files under /proc/net/

However, /proc/net/ is unusual in the sense of /proc/net/foo handlers
take netns pointer from parent directory which is old netns.

Steps to reproduce:

	(void)open("/proc/net/sctp/snmp", O_RDONLY);
	unshare(CLONE_NEWNET);

	int fd = open("/proc/net/sctp/snmp", O_RDONLY);
	read(fd, &c, 1);

Read will read wrong data from original netns.

Patch forces lookup on every directory under /proc/net .

Link: https://lkml.kernel.org/r/20201205160916.GA109739@localhost.localdomain
Fixes: 1da4d377f943 ("proc: revalidate misc dentries")
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Reported-by: "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/generic.c       | 24 ++++++++++++++++++++++--
 fs/proc/internal.h      |  7 +++++++
 fs/proc/proc_net.c      | 16 ----------------
 include/linux/proc_fs.h |  8 +++++++-
 4 files changed, 36 insertions(+), 19 deletions(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 7820fe524cb03..bab10368a04d8 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -341,6 +341,16 @@ static const struct file_operations proc_dir_operations = {
 	.iterate_shared		= proc_readdir,
 };
 
+static int proc_net_d_revalidate(struct dentry *dentry, unsigned int flags)
+{
+	return 0;
+}
+
+const struct dentry_operations proc_net_dentry_ops = {
+	.d_revalidate	= proc_net_d_revalidate,
+	.d_delete	= always_delete_dentry,
+};
+
 /*
  * proc directories can do almost nothing..
  */
@@ -463,8 +473,8 @@ struct proc_dir_entry *proc_symlink(const char *name,
 }
 EXPORT_SYMBOL(proc_symlink);
 
-struct proc_dir_entry *proc_mkdir_data(const char *name, umode_t mode,
-		struct proc_dir_entry *parent, void *data)
+struct proc_dir_entry *_proc_mkdir(const char *name, umode_t mode,
+		struct proc_dir_entry *parent, void *data, bool force_lookup)
 {
 	struct proc_dir_entry *ent;
 
@@ -476,10 +486,20 @@ struct proc_dir_entry *proc_mkdir_data(const char *name, umode_t mode,
 		ent->data = data;
 		ent->proc_fops = &proc_dir_operations;
 		ent->proc_iops = &proc_dir_inode_operations;
+		if (force_lookup) {
+			pde_force_lookup(ent);
+		}
 		ent = proc_register(parent, ent);
 	}
 	return ent;
 }
+EXPORT_SYMBOL_GPL(_proc_mkdir);
+
+struct proc_dir_entry *proc_mkdir_data(const char *name, umode_t mode,
+		struct proc_dir_entry *parent, void *data)
+{
+	return _proc_mkdir(name, mode, parent, data, false);
+}
 EXPORT_SYMBOL_GPL(proc_mkdir_data);
 
 struct proc_dir_entry *proc_mkdir_mode(const char *name, umode_t mode,
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 95b14196f2842..4f14906ef16b5 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -305,3 +305,10 @@ extern unsigned long task_statm(struct mm_struct *,
 				unsigned long *, unsigned long *,
 				unsigned long *, unsigned long *);
 extern void task_mem(struct seq_file *, struct mm_struct *);
+
+extern const struct dentry_operations proc_net_dentry_ops;
+static inline void pde_force_lookup(struct proc_dir_entry *pde)
+{
+	/* /proc/net/ entries can be changed under us by setns(CLONE_NEWNET) */
+	pde->proc_dops = &proc_net_dentry_ops;
+}
diff --git a/fs/proc/proc_net.c b/fs/proc/proc_net.c
index a7b12435519e0..096bcc1e7a8a5 100644
--- a/fs/proc/proc_net.c
+++ b/fs/proc/proc_net.c
@@ -38,22 +38,6 @@ static struct net *get_proc_net(const struct inode *inode)
 	return maybe_get_net(PDE_NET(PDE(inode)));
 }
 
-static int proc_net_d_revalidate(struct dentry *dentry, unsigned int flags)
-{
-	return 0;
-}
-
-static const struct dentry_operations proc_net_dentry_ops = {
-	.d_revalidate	= proc_net_d_revalidate,
-	.d_delete	= always_delete_dentry,
-};
-
-static void pde_force_lookup(struct proc_dir_entry *pde)
-{
-	/* /proc/net/ entries can be changed under us by setns(CLONE_NEWNET) */
-	pde->proc_dops = &proc_net_dentry_ops;
-}
-
 static int seq_open_net(struct inode *inode, struct file *file)
 {
 	unsigned int state_size = PDE(inode)->state_size;
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index d0e1f1522a78e..5141657a0f7f6 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -21,6 +21,7 @@ extern void proc_flush_task(struct task_struct *);
 
 extern struct proc_dir_entry *proc_symlink(const char *,
 		struct proc_dir_entry *, const char *);
+struct proc_dir_entry *_proc_mkdir(const char *, umode_t, struct proc_dir_entry *, void *, bool);
 extern struct proc_dir_entry *proc_mkdir(const char *, struct proc_dir_entry *);
 extern struct proc_dir_entry *proc_mkdir_data(const char *, umode_t,
 					      struct proc_dir_entry *, void *);
@@ -89,6 +90,11 @@ static inline struct proc_dir_entry *proc_symlink(const char *name,
 static inline struct proc_dir_entry *proc_mkdir(const char *name,
 	struct proc_dir_entry *parent) {return NULL;}
 static inline struct proc_dir_entry *proc_create_mount_point(const char *name) { return NULL; }
+static inline struct proc_dir_entry *_proc_mkdir(const char *name, umode_t mode,
+		struct proc_dir_entry *parent, void *data, bool force_lookup)
+{
+	return NULL;
+}
 static inline struct proc_dir_entry *proc_mkdir_data(const char *name,
 	umode_t mode, struct proc_dir_entry *parent, void *data) { return NULL; }
 static inline struct proc_dir_entry *proc_mkdir_mode(const char *name,
@@ -121,7 +127,7 @@ struct net;
 static inline struct proc_dir_entry *proc_net_mkdir(
 	struct net *net, const char *name, struct proc_dir_entry *parent)
 {
-	return proc_mkdir_data(name, 0, parent, net);
+	return _proc_mkdir(name, 0, parent, net, true);
 }
 
 struct ns_common;
-- 
2.27.0



