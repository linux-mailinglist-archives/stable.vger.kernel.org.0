Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 438B43B626A
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234601AbhF1Ord (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:47:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:51824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234823AbhF1OmM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:42:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C86A61CE3;
        Mon, 28 Jun 2021 14:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890820;
        bh=I0yoxm2/iwUa+LuFN8giFyvNDt85UwRfNu+mHCAX/js=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s8AZkDNSO2inW3ZbNZkUWHq/VR0F10JaF2WKZMspo/9B+UWEK2IURQdumeUng4EUV
         H/ghC5volaSiB3dMB0BDmKmPnKqKR/Fh4zbte6m91IoW5EenYB2S69xh46pz7t/pH7
         oi7wBDClUkSQQ6Hez92tBPKvejDv4oJ88ea2XZMrlSNqo0O+EeO/ssZqT6jFnCttdZ
         o7+nuD9uJ1jQ8zdRr7PLygRwh8M1THvzYn87FX5lpWLcugbvvPifv0Uu2l8jT8wITe
         vVqsQJod6Ph6PtCSu4r3Xsqwep7+xr8YL/G27tTnJLqRLbzhuX6D/x0eYJ/8Dg6saw
         Q2PQsO037po8A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pedro Tammela <pctammela@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 037/109] net: add documentation to socket.c
Date:   Mon, 28 Jun 2021 10:31:53 -0400
Message-Id: <20210628143305.32978-38-sashal@kernel.org>
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

From: Pedro Tammela <pctammela@gmail.com>

[ Upstream commit 8a3c245c031944f2176118270e7bc5d4fd4a1075 ]

Adds missing sphinx documentation to the
socket.c's functions. Also fixes some whitespaces.

I also changed the style of older documentation as an
effort to have an uniform documentation style.

Signed-off-by: Pedro Tammela <pctammela@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/net.h    |   6 +
 include/linux/socket.h |  12 +-
 net/socket.c           | 277 ++++++++++++++++++++++++++++++++++++++---
 3 files changed, 271 insertions(+), 24 deletions(-)

diff --git a/include/linux/net.h b/include/linux/net.h
index e0930678c8bf..41dc703b261c 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -83,6 +83,12 @@ enum sock_type {
 
 #endif /* ARCH_HAS_SOCKET_TYPES */
 
+/**
+ * enum sock_shutdown_cmd - Shutdown types
+ * @SHUT_RD: shutdown receptions
+ * @SHUT_WR: shutdown transmissions
+ * @SHUT_RDWR: shutdown receptions/transmissions
+ */
 enum sock_shutdown_cmd {
 	SHUT_RD,
 	SHUT_WR,
diff --git a/include/linux/socket.h b/include/linux/socket.h
index 7ed4713d5337..cc1d3f1b7656 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -26,7 +26,7 @@ typedef __kernel_sa_family_t	sa_family_t;
 /*
  *	1003.1g requires sa_family_t and that sa_data is char.
  */
- 
+
 struct sockaddr {
 	sa_family_t	sa_family;	/* address family, AF_xxx	*/
 	char		sa_data[14];	/* 14 bytes of protocol address	*/
@@ -44,7 +44,7 @@ struct linger {
  *	system, not 4.3. Thus msg_accrights(len) are now missing. They
  *	belong in an obscure libc emulation or the bin.
  */
- 
+
 struct msghdr {
 	void		*msg_name;	/* ptr to socket address structure */
 	int		msg_namelen;	/* size of socket address structure */
@@ -54,7 +54,7 @@ struct msghdr {
 	unsigned int	msg_flags;	/* flags on received message */
 	struct kiocb	*msg_iocb;	/* ptr to iocb for async requests */
 };
- 
+
 struct user_msghdr {
 	void		__user *msg_name;	/* ptr to socket address structure */
 	int		msg_namelen;		/* size of socket address structure */
@@ -122,7 +122,7 @@ struct cmsghdr {
  *	inside range, given by msg->msg_controllen before using
  *	ancillary object DATA.				--ANK (980731)
  */
- 
+
 static inline struct cmsghdr * __cmsg_nxthdr(void *__ctl, __kernel_size_t __size,
 					       struct cmsghdr *__cmsg)
 {
@@ -264,10 +264,10 @@ struct ucred {
 /* Maximum queue length specifiable by listen.  */
 #define SOMAXCONN	128
 
-/* Flags we can use with send/ and recv. 
+/* Flags we can use with send/ and recv.
    Added those for 1003.1g not all are supported yet
  */
- 
+
 #define MSG_OOB		1
 #define MSG_PEEK	2
 #define MSG_DONTROUTE	4
diff --git a/net/socket.c b/net/socket.c
index 29169045dcfe..1ed7be54815a 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -384,6 +384,18 @@ static struct file_system_type sock_fs_type = {
  *	but we take care of internal coherence yet.
  */
 
+/**
+ *	sock_alloc_file - Bind a &socket to a &file
+ *	@sock: socket
+ *	@flags: file status flags
+ *	@dname: protocol name
+ *
+ *	Returns the &file bound with @sock, implicitly storing it
+ *	in sock->file. If dname is %NULL, sets to "".
+ *	On failure the return is a ERR pointer (see linux/err.h).
+ *	This function uses GFP_KERNEL internally.
+ */
+
 struct file *sock_alloc_file(struct socket *sock, int flags, const char *dname)
 {
 	struct file *file;
@@ -424,6 +436,14 @@ static int sock_map_fd(struct socket *sock, int flags)
 	return PTR_ERR(newfile);
 }
 
+/**
+ *	sock_from_file - Return the &socket bounded to @file.
+ *	@file: file
+ *	@err: pointer to an error code return
+ *
+ *	On failure returns %NULL and assigns -ENOTSOCK to @err.
+ */
+
 struct socket *sock_from_file(struct file *file, int *err)
 {
 	if (file->f_op == &socket_file_ops)
@@ -532,11 +552,11 @@ static const struct inode_operations sockfs_inode_ops = {
 };
 
 /**
- *	sock_alloc	-	allocate a socket
+ *	sock_alloc - allocate a socket
  *
  *	Allocate a new inode and socket object. The two are bound together
  *	and initialised. The socket is then returned. If we are out of inodes
- *	NULL is returned.
+ *	NULL is returned. This functions uses GFP_KERNEL internally.
  */
 
 struct socket *sock_alloc(void)
@@ -561,7 +581,7 @@ struct socket *sock_alloc(void)
 EXPORT_SYMBOL(sock_alloc);
 
 /**
- *	sock_release	-	close a socket
+ *	sock_release - close a socket
  *	@sock: socket to close
  *
  *	The socket is released from the protocol stack if it has a release
@@ -617,6 +637,15 @@ void __sock_tx_timestamp(__u16 tsflags, __u8 *tx_flags)
 }
 EXPORT_SYMBOL(__sock_tx_timestamp);
 
+/**
+ *	sock_sendmsg - send a message through @sock
+ *	@sock: socket
+ *	@msg: message to send
+ *
+ *	Sends @msg through @sock, passing through LSM.
+ *	Returns the number of bytes sent, or an error code.
+ */
+
 static inline int sock_sendmsg_nosec(struct socket *sock, struct msghdr *msg)
 {
 	int ret = sock->ops->sendmsg(sock, msg, msg_data_left(msg));
@@ -633,6 +662,18 @@ int sock_sendmsg(struct socket *sock, struct msghdr *msg)
 }
 EXPORT_SYMBOL(sock_sendmsg);
 
+/**
+ *	kernel_sendmsg - send a message through @sock (kernel-space)
+ *	@sock: socket
+ *	@msg: message header
+ *	@vec: kernel vec
+ *	@num: vec array length
+ *	@size: total message data size
+ *
+ *	Builds the message data with @vec and sends it through @sock.
+ *	Returns the number of bytes sent, or an error code.
+ */
+
 int kernel_sendmsg(struct socket *sock, struct msghdr *msg,
 		   struct kvec *vec, size_t num, size_t size)
 {
@@ -641,6 +682,19 @@ int kernel_sendmsg(struct socket *sock, struct msghdr *msg,
 }
 EXPORT_SYMBOL(kernel_sendmsg);
 
+/**
+ *	kernel_sendmsg_locked - send a message through @sock (kernel-space)
+ *	@sk: sock
+ *	@msg: message header
+ *	@vec: output s/g array
+ *	@num: output s/g array length
+ *	@size: total message data size
+ *
+ *	Builds the message data with @vec and sends it through @sock.
+ *	Returns the number of bytes sent, or an error code.
+ *	Caller must hold @sk.
+ */
+
 int kernel_sendmsg_locked(struct sock *sk, struct msghdr *msg,
 			  struct kvec *vec, size_t num, size_t size)
 {
@@ -789,6 +843,16 @@ void __sock_recv_ts_and_drops(struct msghdr *msg, struct sock *sk,
 }
 EXPORT_SYMBOL_GPL(__sock_recv_ts_and_drops);
 
+/**
+ *	sock_recvmsg - receive a message from @sock
+ *	@sock: socket
+ *	@msg: message to receive
+ *	@flags: message flags
+ *
+ *	Receives @msg from @sock, passing through LSM. Returns the total number
+ *	of bytes received, or an error.
+ */
+
 static inline int sock_recvmsg_nosec(struct socket *sock, struct msghdr *msg,
 				     int flags)
 {
@@ -804,20 +868,21 @@ int sock_recvmsg(struct socket *sock, struct msghdr *msg, int flags)
 EXPORT_SYMBOL(sock_recvmsg);
 
 /**
- * kernel_recvmsg - Receive a message from a socket (kernel space)
- * @sock:       The socket to receive the message from
- * @msg:        Received message
- * @vec:        Input s/g array for message data
- * @num:        Size of input s/g array
- * @size:       Number of bytes to read
- * @flags:      Message flags (MSG_DONTWAIT, etc...)
+ *	kernel_recvmsg - Receive a message from a socket (kernel space)
+ *	@sock: The socket to receive the message from
+ *	@msg: Received message
+ *	@vec: Input s/g array for message data
+ *	@num: Size of input s/g array
+ *	@size: Number of bytes to read
+ *	@flags: Message flags (MSG_DONTWAIT, etc...)
  *
- * On return the msg structure contains the scatter/gather array passed in the
- * vec argument. The array is modified so that it consists of the unfilled
- * portion of the original array.
+ *	On return the msg structure contains the scatter/gather array passed in the
+ *	vec argument. The array is modified so that it consists of the unfilled
+ *	portion of the original array.
  *
- * The returned value is the total number of bytes received, or an error.
+ *	The returned value is the total number of bytes received, or an error.
  */
+
 int kernel_recvmsg(struct socket *sock, struct msghdr *msg,
 		   struct kvec *vec, size_t num, size_t size, int flags)
 {
@@ -983,6 +1048,13 @@ static long sock_do_ioctl(struct net *net, struct socket *sock,
  *	what to do with it - that's up to the protocol still.
  */
 
+/**
+ *	get_net_ns - increment the refcount of the network namespace
+ *	@ns: common namespace (net)
+ *
+ *	Returns the net's common namespace.
+ */
+
 struct ns_common *get_net_ns(struct ns_common *ns)
 {
 	return &get_net(container_of(ns, struct net, ns))->ns;
@@ -1077,6 +1149,19 @@ static long sock_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 	return err;
 }
 
+/**
+ *	sock_create_lite - creates a socket
+ *	@family: protocol family (AF_INET, ...)
+ *	@type: communication type (SOCK_STREAM, ...)
+ *	@protocol: protocol (0, ...)
+ *	@res: new socket
+ *
+ *	Creates a new socket and assigns it to @res, passing through LSM.
+ *	The new socket initialization is not complete, see kernel_accept().
+ *	Returns 0 or an error. On failure @res is set to %NULL.
+ *	This function internally uses GFP_KERNEL.
+ */
+
 int sock_create_lite(int family, int type, int protocol, struct socket **res)
 {
 	int err;
@@ -1202,6 +1287,21 @@ int sock_wake_async(struct socket_wq *wq, int how, int band)
 }
 EXPORT_SYMBOL(sock_wake_async);
 
+/**
+ *	__sock_create - creates a socket
+ *	@net: net namespace
+ *	@family: protocol family (AF_INET, ...)
+ *	@type: communication type (SOCK_STREAM, ...)
+ *	@protocol: protocol (0, ...)
+ *	@res: new socket
+ *	@kern: boolean for kernel space sockets
+ *
+ *	Creates a new socket and assigns it to @res, passing through LSM.
+ *	Returns 0 or an error. On failure @res is set to %NULL. @kern must
+ *	be set to true if the socket resides in kernel space.
+ *	This function internally uses GFP_KERNEL.
+ */
+
 int __sock_create(struct net *net, int family, int type, int protocol,
 			 struct socket **res, int kern)
 {
@@ -1311,12 +1411,35 @@ int __sock_create(struct net *net, int family, int type, int protocol,
 }
 EXPORT_SYMBOL(__sock_create);
 
+/**
+ *	sock_create - creates a socket
+ *	@family: protocol family (AF_INET, ...)
+ *	@type: communication type (SOCK_STREAM, ...)
+ *	@protocol: protocol (0, ...)
+ *	@res: new socket
+ *
+ *	A wrapper around __sock_create().
+ *	Returns 0 or an error. This function internally uses GFP_KERNEL.
+ */
+
 int sock_create(int family, int type, int protocol, struct socket **res)
 {
 	return __sock_create(current->nsproxy->net_ns, family, type, protocol, res, 0);
 }
 EXPORT_SYMBOL(sock_create);
 
+/**
+ *	sock_create_kern - creates a socket (kernel space)
+ *	@net: net namespace
+ *	@family: protocol family (AF_INET, ...)
+ *	@type: communication type (SOCK_STREAM, ...)
+ *	@protocol: protocol (0, ...)
+ *	@res: new socket
+ *
+ *	A wrapper around __sock_create().
+ *	Returns 0 or an error. This function internally uses GFP_KERNEL.
+ */
+
 int sock_create_kern(struct net *net, int family, int type, int protocol, struct socket **res)
 {
 	return __sock_create(net, family, type, protocol, res, 1);
@@ -3273,18 +3396,46 @@ static long compat_sock_ioctl(struct file *file, unsigned int cmd,
 }
 #endif
 
+/**
+ *	kernel_bind - bind an address to a socket (kernel space)
+ *	@sock: socket
+ *	@addr: address
+ *	@addrlen: length of address
+ *
+ *	Returns 0 or an error.
+ */
+
 int kernel_bind(struct socket *sock, struct sockaddr *addr, int addrlen)
 {
 	return sock->ops->bind(sock, addr, addrlen);
 }
 EXPORT_SYMBOL(kernel_bind);
 
+/**
+ *	kernel_listen - move socket to listening state (kernel space)
+ *	@sock: socket
+ *	@backlog: pending connections queue size
+ *
+ *	Returns 0 or an error.
+ */
+
 int kernel_listen(struct socket *sock, int backlog)
 {
 	return sock->ops->listen(sock, backlog);
 }
 EXPORT_SYMBOL(kernel_listen);
 
+/**
+ *	kernel_accept - accept a connection (kernel space)
+ *	@sock: listening socket
+ *	@newsock: new connected socket
+ *	@flags: flags
+ *
+ *	@flags must be SOCK_CLOEXEC, SOCK_NONBLOCK or 0.
+ *	If it fails, @newsock is guaranteed to be %NULL.
+ *	Returns 0 or an error.
+ */
+
 int kernel_accept(struct socket *sock, struct socket **newsock, int flags)
 {
 	struct sock *sk = sock->sk;
@@ -3310,6 +3461,19 @@ int kernel_accept(struct socket *sock, struct socket **newsock, int flags)
 }
 EXPORT_SYMBOL(kernel_accept);
 
+/**
+ *	kernel_connect - connect a socket (kernel space)
+ *	@sock: socket
+ *	@addr: address
+ *	@addrlen: address length
+ *	@flags: flags (O_NONBLOCK, ...)
+ *
+ *	For datagram sockets, @addr is the addres to which datagrams are sent
+ *	by default, and the only address from which datagrams are received.
+ *	For stream sockets, attempts to connect to @addr.
+ *	Returns 0 or an error code.
+ */
+
 int kernel_connect(struct socket *sock, struct sockaddr *addr, int addrlen,
 		   int flags)
 {
@@ -3317,18 +3481,48 @@ int kernel_connect(struct socket *sock, struct sockaddr *addr, int addrlen,
 }
 EXPORT_SYMBOL(kernel_connect);
 
+/**
+ *	kernel_getsockname - get the address which the socket is bound (kernel space)
+ *	@sock: socket
+ *	@addr: address holder
+ *
+ * 	Fills the @addr pointer with the address which the socket is bound.
+ *	Returns 0 or an error code.
+ */
+
 int kernel_getsockname(struct socket *sock, struct sockaddr *addr)
 {
 	return sock->ops->getname(sock, addr, 0);
 }
 EXPORT_SYMBOL(kernel_getsockname);
 
+/**
+ *	kernel_peername - get the address which the socket is connected (kernel space)
+ *	@sock: socket
+ *	@addr: address holder
+ *
+ * 	Fills the @addr pointer with the address which the socket is connected.
+ *	Returns 0 or an error code.
+ */
+
 int kernel_getpeername(struct socket *sock, struct sockaddr *addr)
 {
 	return sock->ops->getname(sock, addr, 1);
 }
 EXPORT_SYMBOL(kernel_getpeername);
 
+/**
+ *	kernel_getsockopt - get a socket option (kernel space)
+ *	@sock: socket
+ *	@level: API level (SOL_SOCKET, ...)
+ *	@optname: option tag
+ *	@optval: option value
+ *	@optlen: option length
+ *
+ *	Assigns the option length to @optlen.
+ *	Returns 0 or an error.
+ */
+
 int kernel_getsockopt(struct socket *sock, int level, int optname,
 			char *optval, int *optlen)
 {
@@ -3351,6 +3545,17 @@ int kernel_getsockopt(struct socket *sock, int level, int optname,
 }
 EXPORT_SYMBOL(kernel_getsockopt);
 
+/**
+ *	kernel_setsockopt - set a socket option (kernel space)
+ *	@sock: socket
+ *	@level: API level (SOL_SOCKET, ...)
+ *	@optname: option tag
+ *	@optval: option value
+ *	@optlen: option length
+ *
+ *	Returns 0 or an error.
+ */
+
 int kernel_setsockopt(struct socket *sock, int level, int optname,
 			char *optval, unsigned int optlen)
 {
@@ -3371,6 +3576,17 @@ int kernel_setsockopt(struct socket *sock, int level, int optname,
 }
 EXPORT_SYMBOL(kernel_setsockopt);
 
+/**
+ *	kernel_sendpage - send a &page through a socket (kernel space)
+ *	@sock: socket
+ *	@page: page
+ *	@offset: page offset
+ *	@size: total size in bytes
+ *	@flags: flags (MSG_DONTWAIT, ...)
+ *
+ *	Returns the total amount sent in bytes or an error.
+ */
+
 int kernel_sendpage(struct socket *sock, struct page *page, int offset,
 		    size_t size, int flags)
 {
@@ -3381,6 +3597,18 @@ int kernel_sendpage(struct socket *sock, struct page *page, int offset,
 }
 EXPORT_SYMBOL(kernel_sendpage);
 
+/**
+ *	kernel_sendpage_locked - send a &page through the locked sock (kernel space)
+ *	@sk: sock
+ *	@page: page
+ *	@offset: page offset
+ *	@size: total size in bytes
+ *	@flags: flags (MSG_DONTWAIT, ...)
+ *
+ *	Returns the total amount sent in bytes or an error.
+ *	Caller must hold @sk.
+ */
+
 int kernel_sendpage_locked(struct sock *sk, struct page *page, int offset,
 			   size_t size, int flags)
 {
@@ -3394,17 +3622,30 @@ int kernel_sendpage_locked(struct sock *sk, struct page *page, int offset,
 }
 EXPORT_SYMBOL(kernel_sendpage_locked);
 
+/**
+ *	kernel_shutdown - shut down part of a full-duplex connection (kernel space)
+ *	@sock: socket
+ *	@how: connection part
+ *
+ *	Returns 0 or an error.
+ */
+
 int kernel_sock_shutdown(struct socket *sock, enum sock_shutdown_cmd how)
 {
 	return sock->ops->shutdown(sock, how);
 }
 EXPORT_SYMBOL(kernel_sock_shutdown);
 
-/* This routine returns the IP overhead imposed by a socket i.e.
- * the length of the underlying IP header, depending on whether
- * this is an IPv4 or IPv6 socket and the length from IP options turned
- * on at the socket. Assumes that the caller has a lock on the socket.
+/**
+ *	kernel_sock_ip_overhead - returns the IP overhead imposed by a socket
+ *	@sk: socket
+ *
+ *	This routine returns the IP overhead imposed by a socket i.e.
+ *	the length of the underlying IP header, depending on whether
+ *	this is an IPv4 or IPv6 socket and the length from IP options turned
+ *	on at the socket. Assumes that the caller has a lock on the socket.
  */
+
 u32 kernel_sock_ip_overhead(struct sock *sk)
 {
 	struct inet_sock *inet;
-- 
2.30.2

