Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67FE1F5582
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730139AbfKHTCz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:02:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:60706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387796AbfKHTCy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:02:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A78A20650;
        Fri,  8 Nov 2019 19:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239773;
        bh=jHGnj6Pen2DqLZH29Nhk0FLpIUw6mQ0Ff6tDdW/GZe0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WAKzCbBs0tp73FQinYbWb+ZvZyu62c5qcGuWk4AdGXVieP17wkBxMQGtDOEOeeO8c
         IqQ/+EPrkUV9osyYC+UJL0/MSlPBoNLL2GSu3m5U4JKYzq0k2CPb9t6gmVP31Dz4B9
         7Z3D6aKytTB1txDYKx8eQynBqgUD6XvJ9Irf6SIM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 56/79] net: use skb_queue_empty_lockless() in poll() handlers
Date:   Fri,  8 Nov 2019 19:50:36 +0100
Message-Id: <20191108174819.208207951@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174745.495640141@linuxfoundation.org>
References: <20191108174745.495640141@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 3ef7cf57c72f32f61e97f8fa401bc39ea1f1a5d4 ]

Many poll() handlers are lockless. Using skb_queue_empty_lockless()
instead of skb_queue_empty() is more appropriate.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/isdn/capi/capi.c     |    2 +-
 net/atm/common.c             |    2 +-
 net/bluetooth/af_bluetooth.c |    4 ++--
 net/caif/caif_socket.c       |    2 +-
 net/core/datagram.c          |    4 ++--
 net/decnet/af_decnet.c       |    2 +-
 net/ipv4/tcp.c               |    2 +-
 net/ipv4/udp.c               |    2 +-
 net/nfc/llcp_sock.c          |    4 ++--
 net/phonet/socket.c          |    4 ++--
 net/sctp/socket.c            |    4 ++--
 net/tipc/socket.c            |    4 ++--
 net/unix/af_unix.c           |    6 +++---
 net/vmw_vsock/af_vsock.c     |    2 +-
 14 files changed, 22 insertions(+), 22 deletions(-)

--- a/drivers/isdn/capi/capi.c
+++ b/drivers/isdn/capi/capi.c
@@ -744,7 +744,7 @@ capi_poll(struct file *file, poll_table
 
 	poll_wait(file, &(cdev->recvwait), wait);
 	mask = EPOLLOUT | EPOLLWRNORM;
-	if (!skb_queue_empty(&cdev->recvqueue))
+	if (!skb_queue_empty_lockless(&cdev->recvqueue))
 		mask |= EPOLLIN | EPOLLRDNORM;
 	return mask;
 }
--- a/net/atm/common.c
+++ b/net/atm/common.c
@@ -667,7 +667,7 @@ __poll_t vcc_poll(struct file *file, str
 		mask |= EPOLLHUP;
 
 	/* readable? */
-	if (!skb_queue_empty(&sk->sk_receive_queue))
+	if (!skb_queue_empty_lockless(&sk->sk_receive_queue))
 		mask |= EPOLLIN | EPOLLRDNORM;
 
 	/* writable? */
--- a/net/bluetooth/af_bluetooth.c
+++ b/net/bluetooth/af_bluetooth.c
@@ -460,7 +460,7 @@ __poll_t bt_sock_poll(struct file *file,
 	if (sk->sk_state == BT_LISTEN)
 		return bt_accept_poll(sk);
 
-	if (sk->sk_err || !skb_queue_empty(&sk->sk_error_queue))
+	if (sk->sk_err || !skb_queue_empty_lockless(&sk->sk_error_queue))
 		mask |= EPOLLERR |
 			(sock_flag(sk, SOCK_SELECT_ERR_QUEUE) ? EPOLLPRI : 0);
 
@@ -470,7 +470,7 @@ __poll_t bt_sock_poll(struct file *file,
 	if (sk->sk_shutdown == SHUTDOWN_MASK)
 		mask |= EPOLLHUP;
 
-	if (!skb_queue_empty(&sk->sk_receive_queue))
+	if (!skb_queue_empty_lockless(&sk->sk_receive_queue))
 		mask |= EPOLLIN | EPOLLRDNORM;
 
 	if (sk->sk_state == BT_CLOSED)
--- a/net/caif/caif_socket.c
+++ b/net/caif/caif_socket.c
@@ -953,7 +953,7 @@ static __poll_t caif_poll(struct file *f
 		mask |= EPOLLRDHUP;
 
 	/* readable? */
-	if (!skb_queue_empty(&sk->sk_receive_queue) ||
+	if (!skb_queue_empty_lockless(&sk->sk_receive_queue) ||
 		(sk->sk_shutdown & RCV_SHUTDOWN))
 		mask |= EPOLLIN | EPOLLRDNORM;
 
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -842,7 +842,7 @@ __poll_t datagram_poll(struct file *file
 	mask = 0;
 
 	/* exceptional events? */
-	if (sk->sk_err || !skb_queue_empty(&sk->sk_error_queue))
+	if (sk->sk_err || !skb_queue_empty_lockless(&sk->sk_error_queue))
 		mask |= EPOLLERR |
 			(sock_flag(sk, SOCK_SELECT_ERR_QUEUE) ? EPOLLPRI : 0);
 
@@ -852,7 +852,7 @@ __poll_t datagram_poll(struct file *file
 		mask |= EPOLLHUP;
 
 	/* readable? */
-	if (!skb_queue_empty(&sk->sk_receive_queue))
+	if (!skb_queue_empty_lockless(&sk->sk_receive_queue))
 		mask |= EPOLLIN | EPOLLRDNORM;
 
 	/* Connection-based need to check for termination and startup */
--- a/net/decnet/af_decnet.c
+++ b/net/decnet/af_decnet.c
@@ -1213,7 +1213,7 @@ static __poll_t dn_poll(struct file *fil
 	struct dn_scp *scp = DN_SK(sk);
 	__poll_t mask = datagram_poll(file, sock, wait);
 
-	if (!skb_queue_empty(&scp->other_receive_queue))
+	if (!skb_queue_empty_lockless(&scp->other_receive_queue))
 		mask |= EPOLLRDBAND;
 
 	return mask;
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -595,7 +595,7 @@ __poll_t tcp_poll(struct file *file, str
 	}
 	/* This barrier is coupled with smp_wmb() in tcp_reset() */
 	smp_rmb();
-	if (sk->sk_err || !skb_queue_empty(&sk->sk_error_queue))
+	if (sk->sk_err || !skb_queue_empty_lockless(&sk->sk_error_queue))
 		mask |= EPOLLERR;
 
 	return mask;
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2651,7 +2651,7 @@ __poll_t udp_poll(struct file *file, str
 	__poll_t mask = datagram_poll(file, sock, wait);
 	struct sock *sk = sock->sk;
 
-	if (!skb_queue_empty(&udp_sk(sk)->reader_queue))
+	if (!skb_queue_empty_lockless(&udp_sk(sk)->reader_queue))
 		mask |= EPOLLIN | EPOLLRDNORM;
 
 	/* Check for false positives due to checksum errors */
--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -566,11 +566,11 @@ static __poll_t llcp_sock_poll(struct fi
 	if (sk->sk_state == LLCP_LISTEN)
 		return llcp_accept_poll(sk);
 
-	if (sk->sk_err || !skb_queue_empty(&sk->sk_error_queue))
+	if (sk->sk_err || !skb_queue_empty_lockless(&sk->sk_error_queue))
 		mask |= EPOLLERR |
 			(sock_flag(sk, SOCK_SELECT_ERR_QUEUE) ? EPOLLPRI : 0);
 
-	if (!skb_queue_empty(&sk->sk_receive_queue))
+	if (!skb_queue_empty_lockless(&sk->sk_receive_queue))
 		mask |= EPOLLIN | EPOLLRDNORM;
 
 	if (sk->sk_state == LLCP_CLOSED)
--- a/net/phonet/socket.c
+++ b/net/phonet/socket.c
@@ -351,9 +351,9 @@ static __poll_t pn_socket_poll(struct fi
 
 	if (sk->sk_state == TCP_CLOSE)
 		return EPOLLERR;
-	if (!skb_queue_empty(&sk->sk_receive_queue))
+	if (!skb_queue_empty_lockless(&sk->sk_receive_queue))
 		mask |= EPOLLIN | EPOLLRDNORM;
-	if (!skb_queue_empty(&pn->ctrlreq_queue))
+	if (!skb_queue_empty_lockless(&pn->ctrlreq_queue))
 		mask |= EPOLLPRI;
 	if (!mask && sk->sk_state == TCP_CLOSE_WAIT)
 		return EPOLLHUP;
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -7939,7 +7939,7 @@ __poll_t sctp_poll(struct file *file, st
 	mask = 0;
 
 	/* Is there any exceptional events?  */
-	if (sk->sk_err || !skb_queue_empty(&sk->sk_error_queue))
+	if (sk->sk_err || !skb_queue_empty_lockless(&sk->sk_error_queue))
 		mask |= EPOLLERR |
 			(sock_flag(sk, SOCK_SELECT_ERR_QUEUE) ? EPOLLPRI : 0);
 	if (sk->sk_shutdown & RCV_SHUTDOWN)
@@ -7948,7 +7948,7 @@ __poll_t sctp_poll(struct file *file, st
 		mask |= EPOLLHUP;
 
 	/* Is it readable?  Reconsider this code with TCP-style support.  */
-	if (!skb_queue_empty(&sk->sk_receive_queue))
+	if (!skb_queue_empty_lockless(&sk->sk_receive_queue))
 		mask |= EPOLLIN | EPOLLRDNORM;
 
 	/* The association is either gone or not ready.  */
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -731,7 +731,7 @@ static __poll_t tipc_poll(struct file *f
 		/* fall thru' */
 	case TIPC_LISTEN:
 	case TIPC_CONNECTING:
-		if (!skb_queue_empty(&sk->sk_receive_queue))
+		if (!skb_queue_empty_lockless(&sk->sk_receive_queue))
 			revents |= EPOLLIN | EPOLLRDNORM;
 		break;
 	case TIPC_OPEN:
@@ -739,7 +739,7 @@ static __poll_t tipc_poll(struct file *f
 			revents |= EPOLLOUT;
 		if (!tipc_sk_type_connectionless(sk))
 			break;
-		if (skb_queue_empty(&sk->sk_receive_queue))
+		if (skb_queue_empty_lockless(&sk->sk_receive_queue))
 			break;
 		revents |= EPOLLIN | EPOLLRDNORM;
 		break;
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2661,7 +2661,7 @@ static __poll_t unix_poll(struct file *f
 		mask |= EPOLLRDHUP | EPOLLIN | EPOLLRDNORM;
 
 	/* readable? */
-	if (!skb_queue_empty(&sk->sk_receive_queue))
+	if (!skb_queue_empty_lockless(&sk->sk_receive_queue))
 		mask |= EPOLLIN | EPOLLRDNORM;
 
 	/* Connection-based need to check for termination and startup */
@@ -2690,7 +2690,7 @@ static __poll_t unix_dgram_poll(struct f
 	mask = 0;
 
 	/* exceptional events? */
-	if (sk->sk_err || !skb_queue_empty(&sk->sk_error_queue))
+	if (sk->sk_err || !skb_queue_empty_lockless(&sk->sk_error_queue))
 		mask |= EPOLLERR |
 			(sock_flag(sk, SOCK_SELECT_ERR_QUEUE) ? EPOLLPRI : 0);
 
@@ -2700,7 +2700,7 @@ static __poll_t unix_dgram_poll(struct f
 		mask |= EPOLLHUP;
 
 	/* readable? */
-	if (!skb_queue_empty(&sk->sk_receive_queue))
+	if (!skb_queue_empty_lockless(&sk->sk_receive_queue))
 		mask |= EPOLLIN | EPOLLRDNORM;
 
 	/* Connection-based need to check for termination and startup */
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -873,7 +873,7 @@ static __poll_t vsock_poll(struct file *
 		 * the queue and write as long as the socket isn't shutdown for
 		 * sending.
 		 */
-		if (!skb_queue_empty(&sk->sk_receive_queue) ||
+		if (!skb_queue_empty_lockless(&sk->sk_receive_queue) ||
 		    (sk->sk_shutdown & RCV_SHUTDOWN)) {
 			mask |= EPOLLIN | EPOLLRDNORM;
 		}


