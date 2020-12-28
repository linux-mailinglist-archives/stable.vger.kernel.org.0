Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 068602E4049
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437917AbgL1OVa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:21:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:56598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502291AbgL1OVI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:21:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32EE7206E5;
        Mon, 28 Dec 2020 14:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165227;
        bh=vRFUL+1pz6to4bIUX6Fz9GCHt3FzbSN5eqBIwWBQnzk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L/e5b1+0sKNBplH1WXiSujfpo+31Eh3miyTw6vG14PTRLvPM/ZBO36VUIqf4w81gW
         gIP4BJpVr1Oqkh47rS3nHCHW9zTUlFycHp8rTvIjyPQVFsyXZ5YLDYNy5tCVf247CW
         6cpEu0ec0aRzX5hO3rG5O2UBD2/DNZTLu1gV81F0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 458/717] proc: fix lookup in /proc/net subdirectories after setns(2)
Date:   Mon, 28 Dec 2020 13:47:36 +0100
Message-Id: <20201228125042.911923213@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
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
index b84663252adda..6c0a05f55d6b1 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -349,6 +349,16 @@ static const struct file_operations proc_dir_operations = {
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
@@ -471,8 +481,8 @@ struct proc_dir_entry *proc_symlink(const char *name,
 }
 EXPORT_SYMBOL(proc_symlink);
 
-struct proc_dir_entry *proc_mkdir_data(const char *name, umode_t mode,
-		struct proc_dir_entry *parent, void *data)
+struct proc_dir_entry *_proc_mkdir(const char *name, umode_t mode,
+		struct proc_dir_entry *parent, void *data, bool force_lookup)
 {
 	struct proc_dir_entry *ent;
 
@@ -484,10 +494,20 @@ struct proc_dir_entry *proc_mkdir_data(const char *name, umode_t mode,
 		ent->data = data;
 		ent->proc_dir_ops = &proc_dir_operations;
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
index 917cc85e34663..afbe96b6bf77d 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -310,3 +310,10 @@ extern unsigned long task_statm(struct mm_struct *,
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
index ed8a6306990c4..1aa9236bf1af5 100644
--- a/fs/proc/proc_net.c
+++ b/fs/proc/proc_net.c
@@ -39,22 +39,6 @@ static struct net *get_proc_net(const struct inode *inode)
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
index 270cab43ca3da..000cc0533c336 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -80,6 +80,7 @@ extern void proc_flush_pid(struct pid *);
 
 extern struct proc_dir_entry *proc_symlink(const char *,
 		struct proc_dir_entry *, const char *);
+struct proc_dir_entry *_proc_mkdir(const char *, umode_t, struct proc_dir_entry *, void *, bool);
 extern struct proc_dir_entry *proc_mkdir(const char *, struct proc_dir_entry *);
 extern struct proc_dir_entry *proc_mkdir_data(const char *, umode_t,
 					      struct proc_dir_entry *, void *);
@@ -162,6 +163,11 @@ static inline struct proc_dir_entry *proc_symlink(const char *name,
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
@@ -199,7 +205,7 @@ struct net;
 static inline struct proc_dir_entry *proc_net_mkdir(
 	struct net *net, const char *name, struct proc_dir_entry *parent)
 {
-	return proc_mkdir_data(name, 0, parent, net);
+	return _proc_mkdir(name, 0, parent, net, true);
 }
 
 struct ns_common;
-- 
2.27.0



