Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AFA0111FB0
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:16:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727584AbfLCWh1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:37:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:45704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727272AbfLCWh0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:37:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 578592073C;
        Tue,  3 Dec 2019 22:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412645;
        bh=du14ndf91YLkHmlHu5bNi99zWW8kirSW/m0S6cMn+1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B6hM0ecQN3E5XdRJSA4RWLLxCKZKMVp/GGVKLDCMsCIZrWICeU9Hy046E5UJocrOt
         1CQ/gSnNGAFB5b8ayzCAvSy+sfDZOkvAChs5fXEP7bSOPhFuWrfaG9A9lSkSqGc3hr
         Mpk0mD3HXCh+izmFFb3ry75r0BHXKm70HhB4DZbQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 02/46] net: separate out the msghdr copy from ___sys_{send,recv}msg()
Date:   Tue,  3 Dec 2019 23:35:22 +0100
Message-Id: <20191203212707.559208192@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203212705.175425505@linuxfoundation.org>
References: <20191203212705.175425505@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 4257c8ca13b084550574b8c9a667d9c90ff746eb ]

This is in preparation for enabling the io_uring helpers for sendmsg
and recvmsg to first copy the header for validation before continuing
with the operation.

There should be no functional changes in this patch.

Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/socket.c | 141 ++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 95 insertions(+), 46 deletions(-)

diff --git a/net/socket.c b/net/socket.c
index 6a9ab7a8b1d2c..fbe08d7df7732 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2232,15 +2232,10 @@ static int copy_msghdr_from_user(struct msghdr *kmsg,
 	return err < 0 ? err : 0;
 }
 
-static int ___sys_sendmsg(struct socket *sock, struct user_msghdr __user *msg,
-			 struct msghdr *msg_sys, unsigned int flags,
-			 struct used_address *used_address,
-			 unsigned int allowed_msghdr_flags)
+static int ____sys_sendmsg(struct socket *sock, struct msghdr *msg_sys,
+			   unsigned int flags, struct used_address *used_address,
+			   unsigned int allowed_msghdr_flags)
 {
-	struct compat_msghdr __user *msg_compat =
-	    (struct compat_msghdr __user *)msg;
-	struct sockaddr_storage address;
-	struct iovec iovstack[UIO_FASTIOV], *iov = iovstack;
 	unsigned char ctl[sizeof(struct cmsghdr) + 20]
 				__aligned(sizeof(__kernel_size_t));
 	/* 20 is size of ipv6_pktinfo */
@@ -2248,19 +2243,10 @@ static int ___sys_sendmsg(struct socket *sock, struct user_msghdr __user *msg,
 	int ctl_len;
 	ssize_t err;
 
-	msg_sys->msg_name = &address;
-
-	if (MSG_CMSG_COMPAT & flags)
-		err = get_compat_msghdr(msg_sys, msg_compat, NULL, &iov);
-	else
-		err = copy_msghdr_from_user(msg_sys, msg, NULL, &iov);
-	if (err < 0)
-		return err;
-
 	err = -ENOBUFS;
 
 	if (msg_sys->msg_controllen > INT_MAX)
-		goto out_freeiov;
+		goto out;
 	flags |= (msg_sys->msg_flags & allowed_msghdr_flags);
 	ctl_len = msg_sys->msg_controllen;
 	if ((MSG_CMSG_COMPAT & flags) && ctl_len) {
@@ -2268,7 +2254,7 @@ static int ___sys_sendmsg(struct socket *sock, struct user_msghdr __user *msg,
 		    cmsghdr_from_user_compat_to_kern(msg_sys, sock->sk, ctl,
 						     sizeof(ctl));
 		if (err)
-			goto out_freeiov;
+			goto out;
 		ctl_buf = msg_sys->msg_control;
 		ctl_len = msg_sys->msg_controllen;
 	} else if (ctl_len) {
@@ -2277,7 +2263,7 @@ static int ___sys_sendmsg(struct socket *sock, struct user_msghdr __user *msg,
 		if (ctl_len > sizeof(ctl)) {
 			ctl_buf = sock_kmalloc(sock->sk, ctl_len, GFP_KERNEL);
 			if (ctl_buf == NULL)
-				goto out_freeiov;
+				goto out;
 		}
 		err = -EFAULT;
 		/*
@@ -2323,7 +2309,47 @@ static int ___sys_sendmsg(struct socket *sock, struct user_msghdr __user *msg,
 out_freectl:
 	if (ctl_buf != ctl)
 		sock_kfree_s(sock->sk, ctl_buf, ctl_len);
-out_freeiov:
+out:
+	return err;
+}
+
+static int sendmsg_copy_msghdr(struct msghdr *msg,
+			       struct user_msghdr __user *umsg, unsigned flags,
+			       struct iovec **iov)
+{
+	int err;
+
+	if (flags & MSG_CMSG_COMPAT) {
+		struct compat_msghdr __user *msg_compat;
+
+		msg_compat = (struct compat_msghdr __user *) umsg;
+		err = get_compat_msghdr(msg, msg_compat, NULL, iov);
+	} else {
+		err = copy_msghdr_from_user(msg, umsg, NULL, iov);
+	}
+	if (err < 0)
+		return err;
+
+	return 0;
+}
+
+static int ___sys_sendmsg(struct socket *sock, struct user_msghdr __user *msg,
+			 struct msghdr *msg_sys, unsigned int flags,
+			 struct used_address *used_address,
+			 unsigned int allowed_msghdr_flags)
+{
+	struct sockaddr_storage address;
+	struct iovec iovstack[UIO_FASTIOV], *iov = iovstack;
+	ssize_t err;
+
+	msg_sys->msg_name = &address;
+
+	err = sendmsg_copy_msghdr(msg_sys, msg, flags, &iov);
+	if (err < 0)
+		return err;
+
+	err = ____sys_sendmsg(sock, msg_sys, flags, used_address,
+				allowed_msghdr_flags);
 	kfree(iov);
 	return err;
 }
@@ -2442,33 +2468,41 @@ SYSCALL_DEFINE4(sendmmsg, int, fd, struct mmsghdr __user *, mmsg,
 	return __sys_sendmmsg(fd, mmsg, vlen, flags, true);
 }
 
-static int ___sys_recvmsg(struct socket *sock, struct user_msghdr __user *msg,
-			 struct msghdr *msg_sys, unsigned int flags, int nosec)
+static int recvmsg_copy_msghdr(struct msghdr *msg,
+			       struct user_msghdr __user *umsg, unsigned flags,
+			       struct sockaddr __user **uaddr,
+			       struct iovec **iov)
 {
-	struct compat_msghdr __user *msg_compat =
-	    (struct compat_msghdr __user *)msg;
-	struct iovec iovstack[UIO_FASTIOV];
-	struct iovec *iov = iovstack;
-	unsigned long cmsg_ptr;
-	int len;
 	ssize_t err;
 
-	/* kernel mode address */
-	struct sockaddr_storage addr;
-
-	/* user mode address pointers */
-	struct sockaddr __user *uaddr;
-	int __user *uaddr_len = COMPAT_NAMELEN(msg);
-
-	msg_sys->msg_name = &addr;
+	if (MSG_CMSG_COMPAT & flags) {
+		struct compat_msghdr __user *msg_compat;
 
-	if (MSG_CMSG_COMPAT & flags)
-		err = get_compat_msghdr(msg_sys, msg_compat, &uaddr, &iov);
-	else
-		err = copy_msghdr_from_user(msg_sys, msg, &uaddr, &iov);
+		msg_compat = (struct compat_msghdr __user *) umsg;
+		err = get_compat_msghdr(msg, msg_compat, uaddr, iov);
+	} else {
+		err = copy_msghdr_from_user(msg, umsg, uaddr, iov);
+	}
 	if (err < 0)
 		return err;
 
+	return 0;
+}
+
+static int ____sys_recvmsg(struct socket *sock, struct msghdr *msg_sys,
+			   struct user_msghdr __user *msg,
+			   struct sockaddr __user *uaddr,
+			   unsigned int flags, int nosec)
+{
+	struct compat_msghdr __user *msg_compat =
+					(struct compat_msghdr __user *) msg;
+	int __user *uaddr_len = COMPAT_NAMELEN(msg);
+	struct sockaddr_storage addr;
+	unsigned long cmsg_ptr;
+	int len;
+	ssize_t err;
+
+	msg_sys->msg_name = &addr;
 	cmsg_ptr = (unsigned long)msg_sys->msg_control;
 	msg_sys->msg_flags = flags & (MSG_CMSG_CLOEXEC|MSG_CMSG_COMPAT);
 
@@ -2479,7 +2513,7 @@ static int ___sys_recvmsg(struct socket *sock, struct user_msghdr __user *msg,
 		flags |= MSG_DONTWAIT;
 	err = (nosec ? sock_recvmsg_nosec : sock_recvmsg)(sock, msg_sys, flags);
 	if (err < 0)
-		goto out_freeiov;
+		goto out;
 	len = err;
 
 	if (uaddr != NULL) {
@@ -2487,12 +2521,12 @@ static int ___sys_recvmsg(struct socket *sock, struct user_msghdr __user *msg,
 					msg_sys->msg_namelen, uaddr,
 					uaddr_len);
 		if (err < 0)
-			goto out_freeiov;
+			goto out;
 	}
 	err = __put_user((msg_sys->msg_flags & ~MSG_CMSG_COMPAT),
 			 COMPAT_FLAGS(msg));
 	if (err)
-		goto out_freeiov;
+		goto out;
 	if (MSG_CMSG_COMPAT & flags)
 		err = __put_user((unsigned long)msg_sys->msg_control - cmsg_ptr,
 				 &msg_compat->msg_controllen);
@@ -2500,10 +2534,25 @@ static int ___sys_recvmsg(struct socket *sock, struct user_msghdr __user *msg,
 		err = __put_user((unsigned long)msg_sys->msg_control - cmsg_ptr,
 				 &msg->msg_controllen);
 	if (err)
-		goto out_freeiov;
+		goto out;
 	err = len;
+out:
+	return err;
+}
+
+static int ___sys_recvmsg(struct socket *sock, struct user_msghdr __user *msg,
+			 struct msghdr *msg_sys, unsigned int flags, int nosec)
+{
+	struct iovec iovstack[UIO_FASTIOV], *iov = iovstack;
+	/* user mode address pointers */
+	struct sockaddr __user *uaddr;
+	ssize_t err;
+
+	err = recvmsg_copy_msghdr(msg_sys, msg, flags, &uaddr, &iov);
+	if (err < 0)
+		return err;
 
-out_freeiov:
+	err = ____sys_recvmsg(sock, msg_sys, msg, uaddr, flags, nosec);
 	kfree(iov);
 	return err;
 }
-- 
2.20.1



