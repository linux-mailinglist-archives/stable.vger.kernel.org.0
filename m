Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B04BC3B626B
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235022AbhF1Ore (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:47:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:50214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234826AbhF1OmN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:42:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F03C61984;
        Mon, 28 Jun 2021 14:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890821;
        bh=B6kM6t0+RxjaLk5lpToz33jwMFXQVmWWo5pEl6MUHqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kw83sSJDRUY4P4inboaC8p6DVZz2RR8vg98dsVBFrExr2lniBvB1j2wE0JU/Wn+HP
         2VJCy8ahYpLxIZvAGOxseFXS3fuNAp9eM/5qZr1TyLbKX7bOIVfX6q+jt6BVuPoGC0
         EEfDY7MjmiPcOUG/r3NqAoSqLJ4qThNzEWWeUO48eqmljK37ycYh2rQmJN+wp6EEnK
         eqHe0EUQyrKLCUTyTAvAlAvY5sfsB5KUDWUwbiaQV84U7/wVmKujTF8qVDndlBbq5n
         SZpwRYaJtNGWS5mi4NBT2Ab1NfnroBITmWohwqj35XLEPBmoysi3QuLVbSSnoTmLcd
         eH+TQbsy4w0HA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Changbin Du <changbin.du@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 038/109] net: make get_net_ns return error if NET_NS is disabled
Date:   Mon, 28 Jun 2021 10:31:54 -0400
Message-Id: <20210628143305.32978-39-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143305.32978-1-sashal@kernel.org>
References: <20210628143305.32978-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.196-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.196-rc1
X-KernelTest-Deadline: 2021-06-30T14:32+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Changbin Du <changbin.du@gmail.com>

[ Upstream commit ea6932d70e223e02fea3ae20a4feff05d7c1ea9a ]

There is a panic in socket ioctl cmd SIOCGSKNS when NET_NS is not enabled.
The reason is that nsfs tries to access ns->ops but the proc_ns_operations
is not implemented in this case.

[7.670023] Unable to handle kernel NULL pointer dereference at virtual address 00000010
[7.670268] pgd = 32b54000
[7.670544] [00000010] *pgd=00000000
[7.671861] Internal error: Oops: 5 [#1] SMP ARM
[7.672315] Modules linked in:
[7.672918] CPU: 0 PID: 1 Comm: systemd Not tainted 5.13.0-rc3-00375-g6799d4f2da49 #16
[7.673309] Hardware name: Generic DT based system
[7.673642] PC is at nsfs_evict+0x24/0x30
[7.674486] LR is at clear_inode+0x20/0x9c

The same to tun SIOCGSKNS command.

To fix this problem, we make get_net_ns() return -EINVAL when NET_NS is
disabled. Meanwhile move it to right place net/core/net_namespace.c.

Signed-off-by: Changbin Du <changbin.du@gmail.com>
Fixes: c62cce2caee5 ("net: add an ioctl to get a socket network namespace")
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/socket.h      |  2 --
 include/net/net_namespace.h |  7 +++++++
 net/core/net_namespace.c    | 12 ++++++++++++
 net/socket.c                | 13 -------------
 4 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index cc1d3f1b7656..15a7eb24f63c 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -384,6 +384,4 @@ extern int __sys_getpeername(int fd, struct sockaddr __user *usockaddr,
 extern int __sys_socketpair(int family, int type, int protocol,
 			    int __user *usockvec);
 extern int __sys_shutdown(int fd, int how);
-
-extern struct ns_common *get_net_ns(struct ns_common *ns);
 #endif /* _LINUX_SOCKET_H */
diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 5007eaba207d..bc88ac6c2e1d 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -175,6 +175,8 @@ struct net *copy_net_ns(unsigned long flags, struct user_namespace *user_ns,
 void net_ns_get_ownership(const struct net *net, kuid_t *uid, kgid_t *gid);
 
 void net_ns_barrier(void);
+
+struct ns_common *get_net_ns(struct ns_common *ns);
 #else /* CONFIG_NET_NS */
 #include <linux/sched.h>
 #include <linux/nsproxy.h>
@@ -194,6 +196,11 @@ static inline void net_ns_get_ownership(const struct net *net,
 }
 
 static inline void net_ns_barrier(void) {}
+
+static inline struct ns_common *get_net_ns(struct ns_common *ns)
+{
+	return ERR_PTR(-EINVAL);
+}
 #endif /* CONFIG_NET_NS */
 
 
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index c60123dff803..939d8a31eb82 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -598,6 +598,18 @@ void __put_net(struct net *net)
 }
 EXPORT_SYMBOL_GPL(__put_net);
 
+/**
+ * get_net_ns - increment the refcount of the network namespace
+ * @ns: common namespace (net)
+ *
+ * Returns the net's common namespace.
+ */
+struct ns_common *get_net_ns(struct ns_common *ns)
+{
+	return &get_net(container_of(ns, struct net, ns))->ns;
+}
+EXPORT_SYMBOL_GPL(get_net_ns);
+
 struct net *get_net_ns_by_fd(int fd)
 {
 	struct file *file;
diff --git a/net/socket.c b/net/socket.c
index 1ed7be54815a..f14bca00ff01 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1048,19 +1048,6 @@ static long sock_do_ioctl(struct net *net, struct socket *sock,
  *	what to do with it - that's up to the protocol still.
  */
 
-/**
- *	get_net_ns - increment the refcount of the network namespace
- *	@ns: common namespace (net)
- *
- *	Returns the net's common namespace.
- */
-
-struct ns_common *get_net_ns(struct ns_common *ns)
-{
-	return &get_net(container_of(ns, struct net, ns))->ns;
-}
-EXPORT_SYMBOL_GPL(get_net_ns);
-
 static long sock_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 {
 	struct socket *sock;
-- 
2.30.2

