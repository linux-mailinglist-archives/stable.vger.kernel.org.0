Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF3F57F30E
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406312AbfHBJxl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:53:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:59916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406300AbfHBJxl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:53:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CE7821726;
        Fri,  2 Aug 2019 09:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739618;
        bh=IDYDA6Z3E1Q1YO1qQsH6mYmERk7i8uVQiB31DbTzeow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g8/hgBUHwkOkIGgG+Wx8G5SjBU6hRbf+0NMeeM8tZ87o+uRJTNq9fY0aTRd+5EmNi
         VL2LqQ8DyIxz6m3sW7VMWMnWMq7lUSdYn3NAk387GFRy0uOhoKQmA5sxJuY/jk5nHz
         1NclHQewPv9azycJ0tmzEOLXZw6ygaE95LULpbis=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH 4.14 01/25] VSOCK: use TCP state constants for sk_state
Date:   Fri,  2 Aug 2019 11:39:33 +0200
Message-Id: <20190802092058.902764946@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092058.428079740@linuxfoundation.org>
References: <20190802092058.428079740@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Hajnoczi <stefanha@redhat.com>

commit 3b4477d2dcf2709d0be89e2a8dced3d0f4a017f2 upstream.

There are two state fields: socket->state and sock->sk_state.  The
socket->state field uses SS_UNCONNECTED, SS_CONNECTED, etc while the
sock->sk_state typically uses values that match TCP state constants
(TCP_CLOSE, TCP_ESTABLISHED).  AF_VSOCK does not follow this convention
and instead uses SS_* constants for both fields.

The sk_state field will be exposed to userspace through the vsock_diag
interface for ss(8), netstat(8), and other programs.

This patch switches sk_state to TCP state constants so that the meaning
of this field is consistent with other address families.  Not just
AF_INET and AF_INET6 use the TCP constants, AF_UNIX and others do too.

The following mapping was used to convert the code:

  SS_FREE -> TCP_CLOSE
  SS_UNCONNECTED -> TCP_CLOSE
  SS_CONNECTING -> TCP_SYN_SENT
  SS_CONNECTED -> TCP_ESTABLISHED
  SS_DISCONNECTING -> TCP_CLOSING
  VSOCK_SS_LISTEN -> TCP_LISTEN

In __vsock_create() the sk_state initialization was dropped because
sock_init_data() already initializes sk_state to TCP_CLOSE.

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[Adjusted net/vmw_vsock/hyperv_transport.c since the commit
b4562ca7925a ("hv_sock: add locking in the open/close/release code paths")
and the commit
c9d3fe9da094 ("VSOCK: fix outdated sk_state value in hvs_release()")
were backported before 3b4477d2dcf2.]
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/af_vsock.h                       |    3 -
 net/vmw_vsock/af_vsock.c                     |   46 +++++++++++++++------------
 net/vmw_vsock/hyperv_transport.c             |   12 +++----
 net/vmw_vsock/virtio_transport.c             |    2 -
 net/vmw_vsock/virtio_transport_common.c      |   22 ++++++------
 net/vmw_vsock/vmci_transport.c               |   34 +++++++++----------
 net/vmw_vsock/vmci_transport_notify.c        |    2 -
 net/vmw_vsock/vmci_transport_notify_qstate.c |    2 -
 8 files changed, 64 insertions(+), 59 deletions(-)

--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -22,9 +22,6 @@
 
 #include "vsock_addr.h"
 
-/* vsock-specific sock->sk_state constants */
-#define VSOCK_SS_LISTEN 255
-
 #define LAST_RESERVED_PORT 1023
 
 #define vsock_sk(__sk)    ((struct vsock_sock *)__sk)
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -36,7 +36,7 @@
  * not support simultaneous connects (two "client" sockets connecting).
  *
  * - "Server" sockets are referred to as listener sockets throughout this
- * implementation because they are in the VSOCK_SS_LISTEN state.  When a
+ * implementation because they are in the TCP_LISTEN state.  When a
  * connection request is received (the second kind of socket mentioned above),
  * we create a new socket and refer to it as a pending socket.  These pending
  * sockets are placed on the pending connection list of the listener socket.
@@ -82,6 +82,15 @@
  * argument, we must ensure the reference count is increased to ensure the
  * socket isn't freed before the function is run; the deferred function will
  * then drop the reference.
+ *
+ * - sk->sk_state uses the TCP state constants because they are widely used by
+ * other address families and exposed to userspace tools like ss(8):
+ *
+ *   TCP_CLOSE - unconnected
+ *   TCP_SYN_SENT - connecting
+ *   TCP_ESTABLISHED - connected
+ *   TCP_CLOSING - disconnecting
+ *   TCP_LISTEN - listening
  */
 
 #include <linux/types.h>
@@ -485,7 +494,7 @@ static void vsock_pending_work(struct wo
 	if (vsock_in_connected_table(vsk))
 		vsock_remove_connected(vsk);
 
-	sk->sk_state = SS_FREE;
+	sk->sk_state = TCP_CLOSE;
 
 out:
 	release_sock(sk);
@@ -626,7 +635,6 @@ struct sock *__vsock_create(struct net *
 
 	sk->sk_destruct = vsock_sk_destruct;
 	sk->sk_backlog_rcv = vsock_queue_rcv_skb;
-	sk->sk_state = 0;
 	sock_reset_flag(sk, SOCK_DONE);
 
 	INIT_LIST_HEAD(&vsk->bound_table);
@@ -902,7 +910,7 @@ static unsigned int vsock_poll(struct fi
 		/* Listening sockets that have connections in their accept
 		 * queue can be read.
 		 */
-		if (sk->sk_state == VSOCK_SS_LISTEN
+		if (sk->sk_state == TCP_LISTEN
 		    && !vsock_is_accept_queue_empty(sk))
 			mask |= POLLIN | POLLRDNORM;
 
@@ -931,7 +939,7 @@ static unsigned int vsock_poll(struct fi
 		}
 
 		/* Connected sockets that can produce data can be written. */
-		if (sk->sk_state == SS_CONNECTED) {
+		if (sk->sk_state == TCP_ESTABLISHED) {
 			if (!(sk->sk_shutdown & SEND_SHUTDOWN)) {
 				bool space_avail_now = false;
 				int ret = transport->notify_poll_out(
@@ -953,7 +961,7 @@ static unsigned int vsock_poll(struct fi
 		 * POLLOUT|POLLWRNORM when peer is closed and nothing to read,
 		 * but local send is not shutdown.
 		 */
-		if (sk->sk_state == SS_UNCONNECTED) {
+		if (sk->sk_state == TCP_CLOSE) {
 			if (!(sk->sk_shutdown & SEND_SHUTDOWN))
 				mask |= POLLOUT | POLLWRNORM;
 
@@ -1123,9 +1131,9 @@ static void vsock_connect_timeout(struct
 	sk = sk_vsock(vsk);
 
 	lock_sock(sk);
-	if (sk->sk_state == SS_CONNECTING &&
+	if (sk->sk_state == TCP_SYN_SENT &&
 	    (sk->sk_shutdown != SHUTDOWN_MASK)) {
-		sk->sk_state = SS_UNCONNECTED;
+		sk->sk_state = TCP_CLOSE;
 		sk->sk_err = ETIMEDOUT;
 		sk->sk_error_report(sk);
 		cancel = 1;
@@ -1171,7 +1179,7 @@ static int vsock_stream_connect(struct s
 		err = -EALREADY;
 		break;
 	default:
-		if ((sk->sk_state == VSOCK_SS_LISTEN) ||
+		if ((sk->sk_state == TCP_LISTEN) ||
 		    vsock_addr_cast(addr, addr_len, &remote_addr) != 0) {
 			err = -EINVAL;
 			goto out;
@@ -1194,7 +1202,7 @@ static int vsock_stream_connect(struct s
 		if (err)
 			goto out;
 
-		sk->sk_state = SS_CONNECTING;
+		sk->sk_state = TCP_SYN_SENT;
 
 		err = transport->connect(vsk);
 		if (err < 0)
@@ -1214,7 +1222,7 @@ static int vsock_stream_connect(struct s
 	timeout = vsk->connect_timeout;
 	prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
 
-	while (sk->sk_state != SS_CONNECTED && sk->sk_err == 0) {
+	while (sk->sk_state != TCP_ESTABLISHED && sk->sk_err == 0) {
 		if (flags & O_NONBLOCK) {
 			/* If we're not going to block, we schedule a timeout
 			 * function to generate a timeout on the connection
@@ -1235,13 +1243,13 @@ static int vsock_stream_connect(struct s
 
 		if (signal_pending(current)) {
 			err = sock_intr_errno(timeout);
-			sk->sk_state = SS_UNCONNECTED;
+			sk->sk_state = TCP_CLOSE;
 			sock->state = SS_UNCONNECTED;
 			vsock_transport_cancel_pkt(vsk);
 			goto out_wait;
 		} else if (timeout == 0) {
 			err = -ETIMEDOUT;
-			sk->sk_state = SS_UNCONNECTED;
+			sk->sk_state = TCP_CLOSE;
 			sock->state = SS_UNCONNECTED;
 			vsock_transport_cancel_pkt(vsk);
 			goto out_wait;
@@ -1252,7 +1260,7 @@ static int vsock_stream_connect(struct s
 
 	if (sk->sk_err) {
 		err = -sk->sk_err;
-		sk->sk_state = SS_UNCONNECTED;
+		sk->sk_state = TCP_CLOSE;
 		sock->state = SS_UNCONNECTED;
 	} else {
 		err = 0;
@@ -1285,7 +1293,7 @@ static int vsock_accept(struct socket *s
 		goto out;
 	}
 
-	if (listener->sk_state != VSOCK_SS_LISTEN) {
+	if (listener->sk_state != TCP_LISTEN) {
 		err = -EINVAL;
 		goto out;
 	}
@@ -1375,7 +1383,7 @@ static int vsock_listen(struct socket *s
 	}
 
 	sk->sk_max_ack_backlog = backlog;
-	sk->sk_state = VSOCK_SS_LISTEN;
+	sk->sk_state = TCP_LISTEN;
 
 	err = 0;
 
@@ -1555,7 +1563,7 @@ static int vsock_stream_sendmsg(struct s
 
 	/* Callers should not provide a destination with stream sockets. */
 	if (msg->msg_namelen) {
-		err = sk->sk_state == SS_CONNECTED ? -EISCONN : -EOPNOTSUPP;
+		err = sk->sk_state == TCP_ESTABLISHED ? -EISCONN : -EOPNOTSUPP;
 		goto out;
 	}
 
@@ -1566,7 +1574,7 @@ static int vsock_stream_sendmsg(struct s
 		goto out;
 	}
 
-	if (sk->sk_state != SS_CONNECTED ||
+	if (sk->sk_state != TCP_ESTABLISHED ||
 	    !vsock_addr_bound(&vsk->local_addr)) {
 		err = -ENOTCONN;
 		goto out;
@@ -1690,7 +1698,7 @@ vsock_stream_recvmsg(struct socket *sock
 
 	lock_sock(sk);
 
-	if (sk->sk_state != SS_CONNECTED) {
+	if (sk->sk_state != TCP_ESTABLISHED) {
 		/* Recvmsg is supposed to return 0 if a peer performs an
 		 * orderly shutdown. Differentiate between that case and when a
 		 * peer has not connected or a local shutdown occured with the
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -297,7 +297,7 @@ static void hvs_close_connection(struct
 
 	lock_sock(sk);
 
-	sk->sk_state = SS_UNCONNECTED;
+	sk->sk_state = TCP_CLOSE;
 	sock_set_flag(sk, SOCK_DONE);
 	vsk->peer_shutdown |= SEND_SHUTDOWN | RCV_SHUTDOWN;
 
@@ -336,8 +336,8 @@ static void hvs_open_connection(struct v
 
 	lock_sock(sk);
 
-	if ((conn_from_host && sk->sk_state != VSOCK_SS_LISTEN) ||
-	    (!conn_from_host && sk->sk_state != SS_CONNECTING))
+	if ((conn_from_host && sk->sk_state != TCP_LISTEN) ||
+	    (!conn_from_host && sk->sk_state != TCP_SYN_SENT))
 		goto out;
 
 	if (conn_from_host) {
@@ -349,7 +349,7 @@ static void hvs_open_connection(struct v
 		if (!new)
 			goto out;
 
-		new->sk_state = SS_CONNECTING;
+		new->sk_state = TCP_SYN_SENT;
 		vnew = vsock_sk(new);
 		hvs_new = vnew->trans;
 		hvs_new->chan = chan;
@@ -383,7 +383,7 @@ static void hvs_open_connection(struct v
 	hvs_set_channel_pending_send_size(chan);
 
 	if (conn_from_host) {
-		new->sk_state = SS_CONNECTED;
+		new->sk_state = TCP_ESTABLISHED;
 		sk->sk_ack_backlog++;
 
 		hvs_addr_init(&vnew->local_addr, if_type);
@@ -396,7 +396,7 @@ static void hvs_open_connection(struct v
 
 		vsock_enqueue_accept(sk, new);
 	} else {
-		sk->sk_state = SS_CONNECTED;
+		sk->sk_state = TCP_ESTABLISHED;
 		sk->sk_socket->state = SS_CONNECTED;
 
 		vsock_insert_connected(vsock_sk(sk));
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -417,7 +417,7 @@ static void virtio_vsock_event_fill(stru
 static void virtio_vsock_reset_sock(struct sock *sk)
 {
 	lock_sock(sk);
-	sk->sk_state = SS_UNCONNECTED;
+	sk->sk_state = TCP_CLOSE;
 	sk->sk_err = ECONNRESET;
 	sk->sk_error_report(sk);
 	release_sock(sk);
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -716,7 +716,7 @@ static void virtio_transport_do_close(st
 	sock_set_flag(sk, SOCK_DONE);
 	vsk->peer_shutdown = SHUTDOWN_MASK;
 	if (vsock_stream_has_data(vsk) <= 0)
-		sk->sk_state = SS_DISCONNECTING;
+		sk->sk_state = TCP_CLOSING;
 	sk->sk_state_change(sk);
 
 	if (vsk->close_work_scheduled &&
@@ -756,8 +756,8 @@ static bool virtio_transport_close(struc
 {
 	struct sock *sk = &vsk->sk;
 
-	if (!(sk->sk_state == SS_CONNECTED ||
-	      sk->sk_state == SS_DISCONNECTING))
+	if (!(sk->sk_state == TCP_ESTABLISHED ||
+	      sk->sk_state == TCP_CLOSING))
 		return true;
 
 	/* Already received SHUTDOWN from peer, reply with RST */
@@ -816,7 +816,7 @@ virtio_transport_recv_connecting(struct
 
 	switch (le16_to_cpu(pkt->hdr.op)) {
 	case VIRTIO_VSOCK_OP_RESPONSE:
-		sk->sk_state = SS_CONNECTED;
+		sk->sk_state = TCP_ESTABLISHED;
 		sk->sk_socket->state = SS_CONNECTED;
 		vsock_insert_connected(vsk);
 		sk->sk_state_change(sk);
@@ -836,7 +836,7 @@ virtio_transport_recv_connecting(struct
 
 destroy:
 	virtio_transport_reset(vsk, pkt);
-	sk->sk_state = SS_UNCONNECTED;
+	sk->sk_state = TCP_CLOSE;
 	sk->sk_err = skerr;
 	sk->sk_error_report(sk);
 	return err;
@@ -872,7 +872,7 @@ virtio_transport_recv_connected(struct s
 			vsk->peer_shutdown |= SEND_SHUTDOWN;
 		if (vsk->peer_shutdown == SHUTDOWN_MASK &&
 		    vsock_stream_has_data(vsk) <= 0)
-			sk->sk_state = SS_DISCONNECTING;
+			sk->sk_state = TCP_CLOSING;
 		if (le32_to_cpu(pkt->hdr.flags))
 			sk->sk_state_change(sk);
 		break;
@@ -943,7 +943,7 @@ virtio_transport_recv_listen(struct sock
 
 	lock_sock_nested(child, SINGLE_DEPTH_NESTING);
 
-	child->sk_state = SS_CONNECTED;
+	child->sk_state = TCP_ESTABLISHED;
 
 	vchild = vsock_sk(child);
 	vsock_addr_init(&vchild->local_addr, le64_to_cpu(pkt->hdr.dst_cid),
@@ -1031,18 +1031,18 @@ void virtio_transport_recv_pkt(struct vi
 		sk->sk_write_space(sk);
 
 	switch (sk->sk_state) {
-	case VSOCK_SS_LISTEN:
+	case TCP_LISTEN:
 		virtio_transport_recv_listen(sk, pkt);
 		virtio_transport_free_pkt(pkt);
 		break;
-	case SS_CONNECTING:
+	case TCP_SYN_SENT:
 		virtio_transport_recv_connecting(sk, pkt);
 		virtio_transport_free_pkt(pkt);
 		break;
-	case SS_CONNECTED:
+	case TCP_ESTABLISHED:
 		virtio_transport_recv_connected(sk, pkt);
 		break;
-	case SS_DISCONNECTING:
+	case TCP_CLOSING:
 		virtio_transport_recv_disconnecting(sk, pkt);
 		virtio_transport_free_pkt(pkt);
 		break;
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -776,7 +776,7 @@ static int vmci_transport_recv_stream_cb
 		/* The local context ID may be out of date, update it. */
 		vsk->local_addr.svm_cid = dst.svm_cid;
 
-		if (sk->sk_state == SS_CONNECTED)
+		if (sk->sk_state == TCP_ESTABLISHED)
 			vmci_trans(vsk)->notify_ops->handle_notify_pkt(
 					sk, pkt, true, &dst, &src,
 					&bh_process_pkt);
@@ -834,7 +834,9 @@ static void vmci_transport_handle_detach
 		 * left in our consume queue.
 		 */
 		if (vsock_stream_has_data(vsk) <= 0) {
-			if (sk->sk_state == SS_CONNECTING) {
+			sk->sk_state = TCP_CLOSE;
+
+			if (sk->sk_state == TCP_SYN_SENT) {
 				/* The peer may detach from a queue pair while
 				 * we are still in the connecting state, i.e.,
 				 * if the peer VM is killed after attaching to
@@ -843,12 +845,10 @@ static void vmci_transport_handle_detach
 				 * event like a reset.
 				 */
 
-				sk->sk_state = SS_UNCONNECTED;
 				sk->sk_err = ECONNRESET;
 				sk->sk_error_report(sk);
 				return;
 			}
-			sk->sk_state = SS_UNCONNECTED;
 		}
 		sk->sk_state_change(sk);
 	}
@@ -916,17 +916,17 @@ static void vmci_transport_recv_pkt_work
 	vsock_sk(sk)->local_addr.svm_cid = pkt->dg.dst.context;
 
 	switch (sk->sk_state) {
-	case VSOCK_SS_LISTEN:
+	case TCP_LISTEN:
 		vmci_transport_recv_listen(sk, pkt);
 		break;
-	case SS_CONNECTING:
+	case TCP_SYN_SENT:
 		/* Processing of pending connections for servers goes through
 		 * the listening socket, so see vmci_transport_recv_listen()
 		 * for that path.
 		 */
 		vmci_transport_recv_connecting_client(sk, pkt);
 		break;
-	case SS_CONNECTED:
+	case TCP_ESTABLISHED:
 		vmci_transport_recv_connected(sk, pkt);
 		break;
 	default:
@@ -975,7 +975,7 @@ static int vmci_transport_recv_listen(st
 		vsock_sk(pending)->local_addr.svm_cid = pkt->dg.dst.context;
 
 		switch (pending->sk_state) {
-		case SS_CONNECTING:
+		case TCP_SYN_SENT:
 			err = vmci_transport_recv_connecting_server(sk,
 								    pending,
 								    pkt);
@@ -1105,7 +1105,7 @@ static int vmci_transport_recv_listen(st
 	vsock_add_pending(sk, pending);
 	sk->sk_ack_backlog++;
 
-	pending->sk_state = SS_CONNECTING;
+	pending->sk_state = TCP_SYN_SENT;
 	vmci_trans(vpending)->produce_size =
 		vmci_trans(vpending)->consume_size = qp_size;
 	vmci_trans(vpending)->queue_pair_size = qp_size;
@@ -1229,11 +1229,11 @@ vmci_transport_recv_connecting_server(st
 	 * the socket will be valid until it is removed from the queue.
 	 *
 	 * If we fail sending the attach below, we remove the socket from the
-	 * connected list and move the socket to SS_UNCONNECTED before
+	 * connected list and move the socket to TCP_CLOSE before
 	 * releasing the lock, so a pending slow path processing of an incoming
 	 * packet will not see the socket in the connected state in that case.
 	 */
-	pending->sk_state = SS_CONNECTED;
+	pending->sk_state = TCP_ESTABLISHED;
 
 	vsock_insert_connected(vpending);
 
@@ -1264,7 +1264,7 @@ vmci_transport_recv_connecting_server(st
 
 destroy:
 	pending->sk_err = skerr;
-	pending->sk_state = SS_UNCONNECTED;
+	pending->sk_state = TCP_CLOSE;
 	/* As long as we drop our reference, all necessary cleanup will handle
 	 * when the cleanup function drops its reference and our destruct
 	 * implementation is called.  Note that since the listen handler will
@@ -1302,7 +1302,7 @@ vmci_transport_recv_connecting_client(st
 		 * accounting (it can already be found since it's in the bound
 		 * table).
 		 */
-		sk->sk_state = SS_CONNECTED;
+		sk->sk_state = TCP_ESTABLISHED;
 		sk->sk_socket->state = SS_CONNECTED;
 		vsock_insert_connected(vsk);
 		sk->sk_state_change(sk);
@@ -1370,7 +1370,7 @@ vmci_transport_recv_connecting_client(st
 destroy:
 	vmci_transport_send_reset(sk, pkt);
 
-	sk->sk_state = SS_UNCONNECTED;
+	sk->sk_state = TCP_CLOSE;
 	sk->sk_err = skerr;
 	sk->sk_error_report(sk);
 	return err;
@@ -1558,7 +1558,7 @@ static int vmci_transport_recv_connected
 		sock_set_flag(sk, SOCK_DONE);
 		vsk->peer_shutdown = SHUTDOWN_MASK;
 		if (vsock_stream_has_data(vsk) <= 0)
-			sk->sk_state = SS_DISCONNECTING;
+			sk->sk_state = TCP_CLOSING;
 
 		sk->sk_state_change(sk);
 		break;
@@ -1826,7 +1826,7 @@ static int vmci_transport_connect(struct
 		err = vmci_transport_send_conn_request(
 			sk, vmci_trans(vsk)->queue_pair_size);
 		if (err < 0) {
-			sk->sk_state = SS_UNCONNECTED;
+			sk->sk_state = TCP_CLOSE;
 			return err;
 		}
 	} else {
@@ -1836,7 +1836,7 @@ static int vmci_transport_connect(struct
 				sk, vmci_trans(vsk)->queue_pair_size,
 				supported_proto_versions);
 		if (err < 0) {
-			sk->sk_state = SS_UNCONNECTED;
+			sk->sk_state = TCP_CLOSE;
 			return err;
 		}
 
--- a/net/vmw_vsock/vmci_transport_notify.c
+++ b/net/vmw_vsock/vmci_transport_notify.c
@@ -355,7 +355,7 @@ vmci_transport_notify_pkt_poll_in(struct
 		 * queue. Ask for notifications when there is something to
 		 * read.
 		 */
-		if (sk->sk_state == SS_CONNECTED) {
+		if (sk->sk_state == TCP_ESTABLISHED) {
 			if (!send_waiting_read(sk, 1))
 				return -1;
 
--- a/net/vmw_vsock/vmci_transport_notify_qstate.c
+++ b/net/vmw_vsock/vmci_transport_notify_qstate.c
@@ -176,7 +176,7 @@ vmci_transport_notify_pkt_poll_in(struct
 		 * queue. Ask for notifications when there is something to
 		 * read.
 		 */
-		if (sk->sk_state == SS_CONNECTED)
+		if (sk->sk_state == TCP_ESTABLISHED)
 			vsock_block_update_write_window(sk);
 		*data_ready_now = false;
 	}


