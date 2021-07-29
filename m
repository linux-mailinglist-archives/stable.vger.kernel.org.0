Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 198BD3DA4E1
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 15:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237981AbhG2N4p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 09:56:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:46614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237933AbhG2N4n (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Jul 2021 09:56:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE4C960F46;
        Thu, 29 Jul 2021 13:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627567000;
        bh=HZzYlplzIxhGgHBx4RY8xNgnktFsGJ7+QA8AIMwpK80=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HGazIa06IGeWFQm9LlVRWPVFp2CKPg4QOu9v8nKDOKWKS63O7YCx/yA7eBYo16AZ8
         tMkPHan61a+ji/RreIYi0Begl+1/sixR5+8GkuX6TX64bNo3bfi/RCwCgaXBP+eMUZ
         2N0KGIqoZU4VXmHssziwEeEP6Pv6unWihUK6Uh9E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.19 04/17] net: split out functions related to registering inflight socket files
Date:   Thu, 29 Jul 2021 15:54:05 +0200
Message-Id: <20210729135137.400360904@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210729135137.260993951@linuxfoundation.org>
References: <20210729135137.260993951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit f4e65870e5cede5ca1ec0006b6c9803994e5f7b8 upstream.

We need this functionality for the io_uring file registration, but
we cannot rely on it since CONFIG_UNIX can be modular. Move the helpers
to a separate file, that's always builtin to the kernel if CONFIG_UNIX is
m/y.

No functional changes in this patch, just moving code around.

Reviewed-by: Hannes Reinecke <hare@suse.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[ backported to older kernels to get access to unix_gc_lock - gregkh ]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/af_unix.h |    1 
 net/Makefile          |    2 
 net/unix/Kconfig      |    5 +
 net/unix/Makefile     |    2 
 net/unix/af_unix.c    |   63 ---------------------
 net/unix/garbage.c    |   68 ----------------------
 net/unix/scm.c        |  148 ++++++++++++++++++++++++++++++++++++++++++++++++++
 net/unix/scm.h        |   10 +++
 8 files changed, 171 insertions(+), 128 deletions(-)
 create mode 100644 net/unix/scm.c
 create mode 100644 net/unix/scm.h

--- a/include/net/af_unix.h
+++ b/include/net/af_unix.h
@@ -10,6 +10,7 @@
 
 void unix_inflight(struct user_struct *user, struct file *fp);
 void unix_notinflight(struct user_struct *user, struct file *fp);
+void unix_destruct_scm(struct sk_buff *skb);
 void unix_gc(void);
 void wait_for_unix_gc(void);
 struct sock *unix_get_socket(struct file *filp);
--- a/net/Makefile
+++ b/net/Makefile
@@ -18,7 +18,7 @@ obj-$(CONFIG_NETFILTER)		+= netfilter/
 obj-$(CONFIG_INET)		+= ipv4/
 obj-$(CONFIG_TLS)		+= tls/
 obj-$(CONFIG_XFRM)		+= xfrm/
-obj-$(CONFIG_UNIX)		+= unix/
+obj-$(CONFIG_UNIX_SCM)		+= unix/
 obj-$(CONFIG_NET)		+= ipv6/
 obj-$(CONFIG_BPFILTER)		+= bpfilter/
 obj-$(CONFIG_PACKET)		+= packet/
--- a/net/unix/Kconfig
+++ b/net/unix/Kconfig
@@ -19,6 +19,11 @@ config UNIX
 
 	  Say Y unless you know what you are doing.
 
+config UNIX_SCM
+	bool
+	depends on UNIX
+	default y
+
 config UNIX_DIAG
 	tristate "UNIX: socket monitoring interface"
 	depends on UNIX
--- a/net/unix/Makefile
+++ b/net/unix/Makefile
@@ -10,3 +10,5 @@ unix-$(CONFIG_SYSCTL)	+= sysctl_net_unix
 
 obj-$(CONFIG_UNIX_DIAG)	+= unix_diag.o
 unix_diag-y		:= diag.o
+
+obj-$(CONFIG_UNIX_SCM)	+= scm.o
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -119,6 +119,8 @@
 #include <linux/freezer.h>
 #include <linux/file.h>
 
+#include "scm.h"
+
 struct hlist_head unix_socket_table[2 * UNIX_HASH_SIZE];
 EXPORT_SYMBOL_GPL(unix_socket_table);
 DEFINE_SPINLOCK(unix_table_lock);
@@ -1515,67 +1517,6 @@ out:
 	return err;
 }
 
-static void unix_detach_fds(struct scm_cookie *scm, struct sk_buff *skb)
-{
-	int i;
-
-	scm->fp = UNIXCB(skb).fp;
-	UNIXCB(skb).fp = NULL;
-
-	for (i = scm->fp->count-1; i >= 0; i--)
-		unix_notinflight(scm->fp->user, scm->fp->fp[i]);
-}
-
-static void unix_destruct_scm(struct sk_buff *skb)
-{
-	struct scm_cookie scm;
-	memset(&scm, 0, sizeof(scm));
-	scm.pid  = UNIXCB(skb).pid;
-	if (UNIXCB(skb).fp)
-		unix_detach_fds(&scm, skb);
-
-	/* Alas, it calls VFS */
-	/* So fscking what? fput() had been SMP-safe since the last Summer */
-	scm_destroy(&scm);
-	sock_wfree(skb);
-}
-
-/*
- * The "user->unix_inflight" variable is protected by the garbage
- * collection lock, and we just read it locklessly here. If you go
- * over the limit, there might be a tiny race in actually noticing
- * it across threads. Tough.
- */
-static inline bool too_many_unix_fds(struct task_struct *p)
-{
-	struct user_struct *user = current_user();
-
-	if (unlikely(user->unix_inflight > task_rlimit(p, RLIMIT_NOFILE)))
-		return !capable(CAP_SYS_RESOURCE) && !capable(CAP_SYS_ADMIN);
-	return false;
-}
-
-static int unix_attach_fds(struct scm_cookie *scm, struct sk_buff *skb)
-{
-	int i;
-
-	if (too_many_unix_fds(current))
-		return -ETOOMANYREFS;
-
-	/*
-	 * Need to duplicate file references for the sake of garbage
-	 * collection.  Otherwise a socket in the fps might become a
-	 * candidate for GC while the skb is not yet queued.
-	 */
-	UNIXCB(skb).fp = scm_fp_dup(scm->fp);
-	if (!UNIXCB(skb).fp)
-		return -ENOMEM;
-
-	for (i = scm->fp->count - 1; i >= 0; i--)
-		unix_inflight(scm->fp->user, scm->fp->fp[i]);
-	return 0;
-}
-
 static int unix_scm_to_skb(struct scm_cookie *scm, struct sk_buff *skb, bool send_fds)
 {
 	int err = 0;
--- a/net/unix/garbage.c
+++ b/net/unix/garbage.c
@@ -86,77 +86,13 @@
 #include <net/scm.h>
 #include <net/tcp_states.h>
 
+#include "scm.h"
+
 /* Internal data structures and random procedures: */
 
-static LIST_HEAD(gc_inflight_list);
 static LIST_HEAD(gc_candidates);
-static DEFINE_SPINLOCK(unix_gc_lock);
 static DECLARE_WAIT_QUEUE_HEAD(unix_gc_wait);
 
-unsigned int unix_tot_inflight;
-
-struct sock *unix_get_socket(struct file *filp)
-{
-	struct sock *u_sock = NULL;
-	struct inode *inode = file_inode(filp);
-
-	/* Socket ? */
-	if (S_ISSOCK(inode->i_mode) && !(filp->f_mode & FMODE_PATH)) {
-		struct socket *sock = SOCKET_I(inode);
-		struct sock *s = sock->sk;
-
-		/* PF_UNIX ? */
-		if (s && sock->ops && sock->ops->family == PF_UNIX)
-			u_sock = s;
-	}
-	return u_sock;
-}
-
-/* Keep the number of times in flight count for the file
- * descriptor if it is for an AF_UNIX socket.
- */
-
-void unix_inflight(struct user_struct *user, struct file *fp)
-{
-	struct sock *s = unix_get_socket(fp);
-
-	spin_lock(&unix_gc_lock);
-
-	if (s) {
-		struct unix_sock *u = unix_sk(s);
-
-		if (atomic_long_inc_return(&u->inflight) == 1) {
-			BUG_ON(!list_empty(&u->link));
-			list_add_tail(&u->link, &gc_inflight_list);
-		} else {
-			BUG_ON(list_empty(&u->link));
-		}
-		unix_tot_inflight++;
-	}
-	user->unix_inflight++;
-	spin_unlock(&unix_gc_lock);
-}
-
-void unix_notinflight(struct user_struct *user, struct file *fp)
-{
-	struct sock *s = unix_get_socket(fp);
-
-	spin_lock(&unix_gc_lock);
-
-	if (s) {
-		struct unix_sock *u = unix_sk(s);
-
-		BUG_ON(!atomic_long_read(&u->inflight));
-		BUG_ON(list_empty(&u->link));
-
-		if (atomic_long_dec_and_test(&u->inflight))
-			list_del_init(&u->link);
-		unix_tot_inflight--;
-	}
-	user->unix_inflight--;
-	spin_unlock(&unix_gc_lock);
-}
-
 static void scan_inflight(struct sock *x, void (*func)(struct unix_sock *),
 			  struct sk_buff_head *hitlist)
 {
--- /dev/null
+++ b/net/unix/scm.c
@@ -0,0 +1,148 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/socket.h>
+#include <linux/net.h>
+#include <linux/fs.h>
+#include <net/af_unix.h>
+#include <net/scm.h>
+#include <linux/init.h>
+
+#include "scm.h"
+
+unsigned int unix_tot_inflight;
+EXPORT_SYMBOL(unix_tot_inflight);
+
+LIST_HEAD(gc_inflight_list);
+EXPORT_SYMBOL(gc_inflight_list);
+
+DEFINE_SPINLOCK(unix_gc_lock);
+EXPORT_SYMBOL(unix_gc_lock);
+
+struct sock *unix_get_socket(struct file *filp)
+{
+	struct sock *u_sock = NULL;
+	struct inode *inode = file_inode(filp);
+
+	/* Socket ? */
+	if (S_ISSOCK(inode->i_mode) && !(filp->f_mode & FMODE_PATH)) {
+		struct socket *sock = SOCKET_I(inode);
+		struct sock *s = sock->sk;
+
+		/* PF_UNIX ? */
+		if (s && sock->ops && sock->ops->family == PF_UNIX)
+			u_sock = s;
+	}
+	return u_sock;
+}
+EXPORT_SYMBOL(unix_get_socket);
+
+/* Keep the number of times in flight count for the file
+ * descriptor if it is for an AF_UNIX socket.
+ */
+void unix_inflight(struct user_struct *user, struct file *fp)
+{
+	struct sock *s = unix_get_socket(fp);
+
+	spin_lock(&unix_gc_lock);
+
+	if (s) {
+		struct unix_sock *u = unix_sk(s);
+
+		if (atomic_long_inc_return(&u->inflight) == 1) {
+			BUG_ON(!list_empty(&u->link));
+			list_add_tail(&u->link, &gc_inflight_list);
+		} else {
+			BUG_ON(list_empty(&u->link));
+		}
+		unix_tot_inflight++;
+	}
+	user->unix_inflight++;
+	spin_unlock(&unix_gc_lock);
+}
+
+void unix_notinflight(struct user_struct *user, struct file *fp)
+{
+	struct sock *s = unix_get_socket(fp);
+
+	spin_lock(&unix_gc_lock);
+
+	if (s) {
+		struct unix_sock *u = unix_sk(s);
+
+		BUG_ON(!atomic_long_read(&u->inflight));
+		BUG_ON(list_empty(&u->link));
+
+		if (atomic_long_dec_and_test(&u->inflight))
+			list_del_init(&u->link);
+		unix_tot_inflight--;
+	}
+	user->unix_inflight--;
+	spin_unlock(&unix_gc_lock);
+}
+
+/*
+ * The "user->unix_inflight" variable is protected by the garbage
+ * collection lock, and we just read it locklessly here. If you go
+ * over the limit, there might be a tiny race in actually noticing
+ * it across threads. Tough.
+ */
+static inline bool too_many_unix_fds(struct task_struct *p)
+{
+	struct user_struct *user = current_user();
+
+	if (unlikely(user->unix_inflight > task_rlimit(p, RLIMIT_NOFILE)))
+		return !capable(CAP_SYS_RESOURCE) && !capable(CAP_SYS_ADMIN);
+	return false;
+}
+
+int unix_attach_fds(struct scm_cookie *scm, struct sk_buff *skb)
+{
+	int i;
+
+	if (too_many_unix_fds(current))
+		return -ETOOMANYREFS;
+
+	/*
+	 * Need to duplicate file references for the sake of garbage
+	 * collection.  Otherwise a socket in the fps might become a
+	 * candidate for GC while the skb is not yet queued.
+	 */
+	UNIXCB(skb).fp = scm_fp_dup(scm->fp);
+	if (!UNIXCB(skb).fp)
+		return -ENOMEM;
+
+	for (i = scm->fp->count - 1; i >= 0; i--)
+		unix_inflight(scm->fp->user, scm->fp->fp[i]);
+	return 0;
+}
+EXPORT_SYMBOL(unix_attach_fds);
+
+void unix_detach_fds(struct scm_cookie *scm, struct sk_buff *skb)
+{
+	int i;
+
+	scm->fp = UNIXCB(skb).fp;
+	UNIXCB(skb).fp = NULL;
+
+	for (i = scm->fp->count-1; i >= 0; i--)
+		unix_notinflight(scm->fp->user, scm->fp->fp[i]);
+}
+EXPORT_SYMBOL(unix_detach_fds);
+
+void unix_destruct_scm(struct sk_buff *skb)
+{
+	struct scm_cookie scm;
+
+	memset(&scm, 0, sizeof(scm));
+	scm.pid  = UNIXCB(skb).pid;
+	if (UNIXCB(skb).fp)
+		unix_detach_fds(&scm, skb);
+
+	/* Alas, it calls VFS */
+	/* So fscking what? fput() had been SMP-safe since the last Summer */
+	scm_destroy(&scm);
+	sock_wfree(skb);
+}
+EXPORT_SYMBOL(unix_destruct_scm);
--- /dev/null
+++ b/net/unix/scm.h
@@ -0,0 +1,10 @@
+#ifndef NET_UNIX_SCM_H
+#define NET_UNIX_SCM_H
+
+extern struct list_head gc_inflight_list;
+extern spinlock_t unix_gc_lock;
+
+int unix_attach_fds(struct scm_cookie *scm, struct sk_buff *skb);
+void unix_detach_fds(struct scm_cookie *scm, struct sk_buff *skb);
+
+#endif


