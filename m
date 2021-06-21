Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3B93AEE82
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231805AbhFUQ3t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:29:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:49176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231137AbhFUQ2Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:28:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE73461360;
        Mon, 21 Jun 2021 16:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292606;
        bh=91e13lMOwpYNY13RKtba1tRp3vBbx36wNlvkRJiK5l0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GIGButsCIkfWHp31iPOZLhKaJ6t60dQWKZRtij7YQyLy7EtREhS3ryWfPVafhly46
         GDSdG9aDdkwBBWg8v1/G3lcGL1aoLnRxXlF4eG6xAOPdrLEzJdCti4Yox11THlGMn0
         Vkd4FuX8nD063T2RXXLVa1ULqFOzPACc+4PRjVz8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Changbin Du <changbin.du@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 045/146] net: make get_net_ns return error if NET_NS is disabled
Date:   Mon, 21 Jun 2021 18:14:35 +0200
Message-Id: <20210621154912.823486108@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index e9cb30d8cbfb..9aa530d497da 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -437,6 +437,4 @@ extern int __sys_getpeername(int fd, struct sockaddr __user *usockaddr,
 extern int __sys_socketpair(int family, int type, int protocol,
 			    int __user *usockvec);
 extern int __sys_shutdown(int fd, int how);
-
-extern struct ns_common *get_net_ns(struct ns_common *ns);
 #endif /* _LINUX_SOCKET_H */
diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 22bc07f4b043..eb0e7731f3b1 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -203,6 +203,8 @@ struct net *copy_net_ns(unsigned long flags, struct user_namespace *user_ns,
 void net_ns_get_ownership(const struct net *net, kuid_t *uid, kgid_t *gid);
 
 void net_ns_barrier(void);
+
+struct ns_common *get_net_ns(struct ns_common *ns);
 #else /* CONFIG_NET_NS */
 #include <linux/sched.h>
 #include <linux/nsproxy.h>
@@ -222,6 +224,11 @@ static inline void net_ns_get_ownership(const struct net *net,
 }
 
 static inline void net_ns_barrier(void) {}
+
+static inline struct ns_common *get_net_ns(struct ns_common *ns)
+{
+	return ERR_PTR(-EINVAL);
+}
 #endif /* CONFIG_NET_NS */
 
 
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index dbc66b896287..5c9d95f30be6 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -650,6 +650,18 @@ void __put_net(struct net *net)
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
index 6e6cccc2104f..002d5952ae5d 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1080,19 +1080,6 @@ static long sock_do_ioctl(struct net *net, struct socket *sock,
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



