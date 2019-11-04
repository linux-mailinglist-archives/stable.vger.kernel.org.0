Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5B1ED863
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 06:16:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbfKDFQn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 00:16:43 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38259 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727474AbfKDFQn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Nov 2019 00:16:43 -0500
Received: by mail-pf1-f196.google.com with SMTP id c13so11356216pfp.5;
        Sun, 03 Nov 2019 21:16:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=SfisMBGH7HCGyp3QNdIXtk3uTa9VRUtaVk8bQsx7Ms4=;
        b=Im7PAAzLbxuN5/yHlJuIX1h/n8hS1E437v15iLKpruzu68+76eMNUE5Ls0fHwvBs8D
         IdPlUfEwKFIcAvC5uBXyJd5nzk4kZ5f/SPhRTeY1et4MWtpXGfDOy9hLcHlvqKlqGHlJ
         +MvuovInliu0VEClPMYqX9gMIOGia7AyX19Se+SsOEAuyG8Vi3MnWXyF5TmL2jm8qvII
         fmqdDWH1npeex9mPXwQ+YBjxIQzLvECQEP5WJstiMfk+oYG9ewJ4K4kjTgXMrQ20C1wJ
         udxp4eoPnM1tiWGmOl2XwzPrTt1o5b7J8c+in2EsBxSq/ULnRvJfuMDM0OAsgWYoP7a3
         +buw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=SfisMBGH7HCGyp3QNdIXtk3uTa9VRUtaVk8bQsx7Ms4=;
        b=aDrTd135j4KrrI+7qw24B8dbtOKTgwzT9v8bLOv/SVMk+kVb3R+B8PL4y8tLCMMDcH
         LCNrLMl9xf/0Zol1X8i7fFIb9x5VVSvzTxzk2yekqeG1iI+UtohWamXl9xZjn1xxKtwh
         P2t8lv/mqbvKf+NX4H8oVrUrWO+9jBE0xXBWPrF0ANW4VG2Hq8ajwSQpq4aimVPQuQ1W
         jHTni+gdz9y2nmCttGHcuCM/fAIP/IZG3ICp/r8VpkRPV1JD+hnR35G7A1CofRg7gjhc
         1GUeObK82ZPtYar0ocYkP9rdOwEhmF3doZXjWLZT5d5wLEG+rWaouUnF63fQcwCL45e4
         +QAg==
X-Gm-Message-State: APjAAAV+FOIxEnkq3Fpr/kyRi2IkRVLm660dh/DWHeX+6Ff0koF/+AvN
        9AQ56smahm+LqW84FJhJjRa96hJ9
X-Google-Smtp-Source: APXvYqzTrlRe0YtYw3+dtp+Z+yAX4l0Bxp06cgzl6iQfIa0h46Hy3FhkNlZPYh0ZbmNz4XTLBfvLhA==
X-Received: by 2002:a17:90a:37e4:: with SMTP id v91mr32910545pjb.8.1572844601743;
        Sun, 03 Nov 2019 21:16:41 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y36sm12835271pgk.66.2019.11.03.21.16.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 03 Nov 2019 21:16:41 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     stable@vger.kernel.org, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, sashal@kernel.org,
        gregkh@linuxfoundation.org
Subject: [PATCH linux-4.14.y 1/2] sctp: fix the issue that flags are ignored when using kernel_connect
Date:   Mon,  4 Nov 2019 13:16:25 +0800
Message-Id: <7eaa2553d3499ac18c1a667ed127920619e29ad3.1572844054.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1572844054.git.lucien.xin@gmail.com>
References: <cover.1572844054.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1572844054.git.lucien.xin@gmail.com>
References: <cover.1572844054.git.lucien.xin@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 644fbdeacf1d3edd366e44b8ba214de9d1dd66a9 ]

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
---
 include/net/sctp/sctp.h |  2 ++
 net/sctp/ipv6.c         |  2 +-
 net/sctp/protocol.c     |  2 +-
 net/sctp/socket.c       | 56 +++++++++++++++++++++++++++++++++----------------
 4 files changed, 42 insertions(+), 20 deletions(-)

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index 749a428..c713bd6 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -103,6 +103,8 @@ void sctp_addr_wq_mgmt(struct net *, struct sctp_sockaddr_entry *, int);
 /*
  * sctp/socket.c
  */
+int sctp_inet_connect(struct socket *sock, struct sockaddr *uaddr,
+		      int addr_len, int flags);
 int sctp_backlog_rcv(struct sock *sk, struct sk_buff *skb);
 int sctp_inet_listen(struct socket *sock, int backlog);
 void sctp_write_space(struct sock *sk);
diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index 7eb06fa..53a66ee 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -974,7 +974,7 @@ static const struct proto_ops inet6_seqpacket_ops = {
 	.owner		   = THIS_MODULE,
 	.release	   = inet6_release,
 	.bind		   = inet6_bind,
-	.connect	   = inet_dgram_connect,
+	.connect	   = sctp_inet_connect,
 	.socketpair	   = sock_no_socketpair,
 	.accept		   = inet_accept,
 	.getname	   = sctp_getname,
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 6af871b..01f88e9 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1019,7 +1019,7 @@ static const struct proto_ops inet_seqpacket_ops = {
 	.owner		   = THIS_MODULE,
 	.release	   = inet_release,	/* Needs to be wrapped... */
 	.bind		   = inet_bind,
-	.connect	   = inet_dgram_connect,
+	.connect	   = sctp_inet_connect,
 	.socketpair	   = sock_no_socketpair,
 	.accept		   = inet_accept,
 	.getname	   = inet_getname,	/* Semantics are different.  */
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index a18e9be..c9c23ca 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1076,7 +1076,7 @@ static int sctp_setsockopt_bindx(struct sock *sk,
  */
 static int __sctp_connect(struct sock *sk,
 			  struct sockaddr *kaddrs,
-			  int addrs_size,
+			  int addrs_size, int flags,
 			  sctp_assoc_t *assoc_id)
 {
 	struct net *net = sock_net(sk);
@@ -1094,7 +1094,6 @@ static int __sctp_connect(struct sock *sk,
 	union sctp_addr *sa_addr = NULL;
 	void *addr_buf;
 	unsigned short port;
-	unsigned int f_flags = 0;
 
 	sp = sctp_sk(sk);
 	ep = sp->ep;
@@ -1244,13 +1243,7 @@ static int __sctp_connect(struct sock *sk,
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
@@ -1345,7 +1338,7 @@ static int __sctp_setsockopt_connectx(struct sock *sk,
 {
 	struct sockaddr *kaddrs;
 	gfp_t gfp = GFP_KERNEL;
-	int err = 0;
+	int err = 0, flags = 0;
 
 	pr_debug("%s: sk:%p addrs:%p addrs_size:%d\n",
 		 __func__, sk, addrs, addrs_size);
@@ -1365,11 +1358,18 @@ static int __sctp_setsockopt_connectx(struct sock *sk,
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
@@ -4166,16 +4166,26 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
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
@@ -4184,13 +4194,25 @@ static int sctp_connect(struct sock *sk, struct sockaddr *addr,
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
-- 
2.1.0

