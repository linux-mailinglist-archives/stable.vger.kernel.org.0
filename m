Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A541BEEC5B
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 22:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388347AbfKDV4V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:56:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:51878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388330AbfKDV4U (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:56:20 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 017B92184C;
        Mon,  4 Nov 2019 21:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904578;
        bh=L0ho6bf5l8Xbz1j6S+ejSKfLn7v+U53NaIoYXmrjc+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yMb+ZRgnqwtS+waTJ40uhP0rPQXvDgmW4BgKqOzM49u7Krfr0rjuor0UgtnfPe/SF
         T2XW4eAPTVGrecu0JbQ5nWH8Q8HXNkIaN+UOunvf/EGiqp20g89ulo46ceK25AYPUK
         VWt8bNq+D74budsDzbvYsnQ/oEbyoUSaU9sN5/sQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 91/95] sctp: fix the issue that flags are ignored when using kernel_connect
Date:   Mon,  4 Nov 2019 22:45:29 +0100
Message-Id: <20191104212124.113952695@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212038.056365853@linuxfoundation.org>
References: <20191104212038.056365853@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

commit 644fbdeacf1d3edd366e44b8ba214de9d1dd66a9 upstream.

Now sctp uses inet_dgram_connect as its proto_ops .connect, and the flags
param can't be passed into its proto .connect where this flags is really
needed.

sctp works around it by getting flags from socket file in __sctp_connect.
It works for connecting from userspace, as inherently the user sock has
socket file and it passes f_flags as the flags param into the proto_ops
.connect.

However, the sock created by sock_create_kern doesn't have a socket file,
and it passes the flags (like O_NONBLOCK) by using the flags param in
kernel_connect, which calls proto_ops .connect later.

So to fix it, this patch defines a new proto_ops .connect for sctp,
sctp_inet_connect, which calls __sctp_connect() directly with this
flags param. After this, the sctp's proto .connect can be removed.

Note that sctp_inet_connect doesn't need to do some checks that are not
needed for sctp, which makes thing better than with inet_dgram_connect.

Suggested-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Reviewed-by: Michal Kubecek <mkubecek@suse.cz>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/net/sctp/sctp.h |    2 +
 net/sctp/ipv6.c         |    2 -
 net/sctp/protocol.c     |    2 -
 net/sctp/socket.c       |   56 ++++++++++++++++++++++++++++++++----------------
 4 files changed, 42 insertions(+), 20 deletions(-)

--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -103,6 +103,8 @@ void sctp_addr_wq_mgmt(struct net *, str
 /*
  * sctp/socket.c
  */
+int sctp_inet_connect(struct socket *sock, struct sockaddr *uaddr,
+		      int addr_len, int flags);
 int sctp_backlog_rcv(struct sock *sk, struct sk_buff *skb);
 int sctp_inet_listen(struct socket *sock, int backlog);
 void sctp_write_space(struct sock *sk);
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -974,7 +974,7 @@ static const struct proto_ops inet6_seqp
 	.owner		   = THIS_MODULE,
 	.release	   = inet6_release,
 	.bind		   = inet6_bind,
-	.connect	   = inet_dgram_connect,
+	.connect	   = sctp_inet_connect,
 	.socketpair	   = sock_no_socketpair,
 	.accept		   = inet_accept,
 	.getname	   = sctp_getname,
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1019,7 +1019,7 @@ static const struct proto_ops inet_seqpa
 	.owner		   = THIS_MODULE,
 	.release	   = inet_release,	/* Needs to be wrapped... */
 	.bind		   = inet_bind,
-	.connect	   = inet_dgram_connect,
+	.connect	   = sctp_inet_connect,
 	.socketpair	   = sock_no_socketpair,
 	.accept		   = inet_accept,
 	.getname	   = inet_getname,	/* Semantics are different.  */
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1076,7 +1076,7 @@ out:
  */
 static int __sctp_connect(struct sock *sk,
 			  struct sockaddr *kaddrs,
-			  int addrs_size,
+			  int addrs_size, int flags,
 			  sctp_assoc_t *assoc_id)
 {
 	struct net *net = sock_net(sk);
@@ -1094,7 +1094,6 @@ static int __sctp_connect(struct sock *s
 	union sctp_addr *sa_addr = NULL;
 	void *addr_buf;
 	unsigned short port;
-	unsigned int f_flags = 0;
 
 	sp = sctp_sk(sk);
 	ep = sp->ep;
@@ -1244,13 +1243,7 @@ static int __sctp_connect(struct sock *s
 	sp->pf->to_sk_daddr(sa_addr, sk);
 	sk->sk_err = 0;
 
-	/* in-kernel sockets don't generally have a file allocated to them
-	 * if all they do is call sock_create_kern().
-	 */
-	if (sk->sk_socket->file)
-		f_flags = sk->sk_socket->file->f_flags;
-
-	timeo = sock_sndtimeo(sk, f_flags & O_NONBLOCK);
+	timeo = sock_sndtimeo(sk, flags & O_NONBLOCK);
 
 	if (assoc_id)
 		*assoc_id = asoc->assoc_id;
@@ -1345,7 +1338,7 @@ static int __sctp_setsockopt_connectx(st
 {
 	struct sockaddr *kaddrs;
 	gfp_t gfp = GFP_KERNEL;
-	int err = 0;
+	int err = 0, flags = 0;
 
 	pr_debug("%s: sk:%p addrs:%p addrs_size:%d\n",
 		 __func__, sk, addrs, addrs_size);
@@ -1365,11 +1358,18 @@ static int __sctp_setsockopt_connectx(st
 		return -ENOMEM;
 
 	if (__copy_from_user(kaddrs, addrs, addrs_size)) {
-		err = -EFAULT;
-	} else {
-		err = __sctp_connect(sk, kaddrs, addrs_size, assoc_id);
+		kfree(kaddrs);
+		return -EFAULT;
 	}
 
+	/* in-kernel sockets don't generally have a file allocated to them
+	 * if all they do is call sock_create_kern().
+	 */
+	if (sk->sk_socket->file)
+		flags = sk->sk_socket->file->f_flags;
+
+	err = __sctp_connect(sk, kaddrs, addrs_size, flags, assoc_id);
+
 	kfree(kaddrs);
 
 	return err;
@@ -4166,16 +4166,26 @@ out_nounlock:
  * len: the size of the address.
  */
 static int sctp_connect(struct sock *sk, struct sockaddr *addr,
-			int addr_len)
+			int addr_len, int flags)
 {
-	int err = 0;
+	struct inet_sock *inet = inet_sk(sk);
 	struct sctp_af *af;
+	int err = 0;
 
 	lock_sock(sk);
 
 	pr_debug("%s: sk:%p, sockaddr:%p, addr_len:%d\n", __func__, sk,
 		 addr, addr_len);
 
+	/* We may need to bind the socket. */
+	if (!inet->inet_num) {
+		if (sk->sk_prot->get_port(sk, 0)) {
+			release_sock(sk);
+			return -EAGAIN;
+		}
+		inet->inet_sport = htons(inet->inet_num);
+	}
+
 	/* Validate addr_len before calling common connect/connectx routine. */
 	af = sctp_get_af_specific(addr->sa_family);
 	if (!af || addr_len < af->sockaddr_len) {
@@ -4184,13 +4194,25 @@ static int sctp_connect(struct sock *sk,
 		/* Pass correct addr len to common routine (so it knows there
 		 * is only one address being passed.
 		 */
-		err = __sctp_connect(sk, addr, af->sockaddr_len, NULL);
+		err = __sctp_connect(sk, addr, af->sockaddr_len, flags, NULL);
 	}
 
 	release_sock(sk);
 	return err;
 }
 
+int sctp_inet_connect(struct socket *sock, struct sockaddr *uaddr,
+		      int addr_len, int flags)
+{
+	if (addr_len < sizeof(uaddr->sa_family))
+		return -EINVAL;
+
+	if (uaddr->sa_family == AF_UNSPEC)
+		return -EOPNOTSUPP;
+
+	return sctp_connect(sock->sk, uaddr, addr_len, flags);
+}
+
 /* FIXME: Write comments. */
 static int sctp_disconnect(struct sock *sk, int flags)
 {
@@ -8298,7 +8320,6 @@ struct proto sctp_prot = {
 	.name        =	"SCTP",
 	.owner       =	THIS_MODULE,
 	.close       =	sctp_close,
-	.connect     =	sctp_connect,
 	.disconnect  =	sctp_disconnect,
 	.accept      =	sctp_accept,
 	.ioctl       =	sctp_ioctl,
@@ -8337,7 +8358,6 @@ struct proto sctpv6_prot = {
 	.name		= "SCTPv6",
 	.owner		= THIS_MODULE,
 	.close		= sctp_close,
-	.connect	= sctp_connect,
 	.disconnect	= sctp_disconnect,
 	.accept		= sctp_accept,
 	.ioctl		= sctp_ioctl,


