Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86238157B00
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728468AbgBJMgk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:36:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:56504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728143AbgBJMgj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:36:39 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D8092051A;
        Mon, 10 Feb 2020 12:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338198;
        bh=DwlVUYRsxY52GqJ7OR6aQKRN9VoxxlU/3g86icYD6mo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HCbbtRuo1sCpJBNfDgU5aSy1ggPnTnu/xUwSnF+uBMqb+/nPHj4xGi9rjqIujbOto
         ZCyWARIzH+nLepvDBwdQ/RR8ww8/WRbZo39siPw1mwzgyHuhTF0foWN/HtMkFwDr/F
         WKJi8h5jmYUG8U1UUQXPde1OqH+s4r1anewvkkuY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: [PATCH 5.4 012/309] rxrpc: Fix missing active use pinning of rxrpc_local object
Date:   Mon, 10 Feb 2020 04:29:28 -0800
Message-Id: <20200210122407.211171405@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 04d36d748fac349b068ef621611f454010054c58 ]

The introduction of a split between the reference count on rxrpc_local
objects and the usage count didn't quite go far enough.  A number of kernel
work items need to make use of the socket to perform transmission.  These
also need to get an active count on the local object to prevent the socket
from being closed.

Fix this by getting the active count in those places.

Also split out the raw active count get/put functions as these places tend
to hold refs on the rxrpc_local object already, so getting and putting an
extra object ref is just a waste of time.

The problem can lead to symptoms like:

    BUG: kernel NULL pointer dereference, address: 0000000000000018
    ..
    CPU: 2 PID: 818 Comm: kworker/u9:0 Not tainted 5.5.0-fscache+ #51
    ...
    RIP: 0010:selinux_socket_sendmsg+0x5/0x13
    ...
    Call Trace:
     security_socket_sendmsg+0x2c/0x3e
     sock_sendmsg+0x1a/0x46
     rxrpc_send_keepalive+0x131/0x1ae
     rxrpc_peer_keepalive_worker+0x219/0x34b
     process_one_work+0x18e/0x271
     worker_thread+0x1a3/0x247
     kthread+0xe6/0xeb
     ret_from_fork+0x1f/0x30

Fixes: 730c5fd42c1e ("rxrpc: Fix local endpoint refcounting")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/af_rxrpc.c     |    2 ++
 net/rxrpc/ar-internal.h  |   10 ++++++++++
 net/rxrpc/conn_event.c   |   30 ++++++++++++++++++++----------
 net/rxrpc/local_object.c |   18 +++++++-----------
 net/rxrpc/peer_event.c   |   40 ++++++++++++++++++++++------------------
 5 files changed, 61 insertions(+), 39 deletions(-)

--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -194,6 +194,7 @@ static int rxrpc_bind(struct socket *soc
 service_in_use:
 	write_unlock(&local->services_lock);
 	rxrpc_unuse_local(local);
+	rxrpc_put_local(local);
 	ret = -EADDRINUSE;
 error_unlock:
 	release_sock(&rx->sk);
@@ -899,6 +900,7 @@ static int rxrpc_release_sock(struct soc
 	rxrpc_purge_queue(&sk->sk_receive_queue);
 
 	rxrpc_unuse_local(rx->local);
+	rxrpc_put_local(rx->local);
 	rx->local = NULL;
 	key_put(rx->key);
 	rx->key = NULL;
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -1021,6 +1021,16 @@ void rxrpc_unuse_local(struct rxrpc_loca
 void rxrpc_queue_local(struct rxrpc_local *);
 void rxrpc_destroy_all_locals(struct rxrpc_net *);
 
+static inline bool __rxrpc_unuse_local(struct rxrpc_local *local)
+{
+	return atomic_dec_return(&local->active_users) == 0;
+}
+
+static inline bool __rxrpc_use_local(struct rxrpc_local *local)
+{
+	return atomic_fetch_add_unless(&local->active_users, 1, 0) != 0;
+}
+
 /*
  * misc.c
  */
--- a/net/rxrpc/conn_event.c
+++ b/net/rxrpc/conn_event.c
@@ -438,16 +438,12 @@ again:
 /*
  * connection-level event processor
  */
-void rxrpc_process_connection(struct work_struct *work)
+static void rxrpc_do_process_connection(struct rxrpc_connection *conn)
 {
-	struct rxrpc_connection *conn =
-		container_of(work, struct rxrpc_connection, processor);
 	struct sk_buff *skb;
 	u32 abort_code = RX_PROTOCOL_ERROR;
 	int ret;
 
-	rxrpc_see_connection(conn);
-
 	if (test_and_clear_bit(RXRPC_CONN_EV_CHALLENGE, &conn->events))
 		rxrpc_secure_connection(conn);
 
@@ -475,18 +471,32 @@ void rxrpc_process_connection(struct wor
 		}
 	}
 
-out:
-	rxrpc_put_connection(conn);
-	_leave("");
 	return;
 
 requeue_and_leave:
 	skb_queue_head(&conn->rx_queue, skb);
-	goto out;
+	return;
 
 protocol_error:
 	if (rxrpc_abort_connection(conn, ret, abort_code) < 0)
 		goto requeue_and_leave;
 	rxrpc_free_skb(skb, rxrpc_skb_freed);
-	goto out;
+	return;
+}
+
+void rxrpc_process_connection(struct work_struct *work)
+{
+	struct rxrpc_connection *conn =
+		container_of(work, struct rxrpc_connection, processor);
+
+	rxrpc_see_connection(conn);
+
+	if (__rxrpc_use_local(conn->params.local)) {
+		rxrpc_do_process_connection(conn);
+		rxrpc_unuse_local(conn->params.local);
+	}
+
+	rxrpc_put_connection(conn);
+	_leave("");
+	return;
 }
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -383,14 +383,11 @@ void rxrpc_put_local(struct rxrpc_local
  */
 struct rxrpc_local *rxrpc_use_local(struct rxrpc_local *local)
 {
-	unsigned int au;
-
 	local = rxrpc_get_local_maybe(local);
 	if (!local)
 		return NULL;
 
-	au = atomic_fetch_add_unless(&local->active_users, 1, 0);
-	if (au == 0) {
+	if (!__rxrpc_use_local(local)) {
 		rxrpc_put_local(local);
 		return NULL;
 	}
@@ -404,14 +401,11 @@ struct rxrpc_local *rxrpc_use_local(stru
  */
 void rxrpc_unuse_local(struct rxrpc_local *local)
 {
-	unsigned int au;
-
 	if (local) {
-		au = atomic_dec_return(&local->active_users);
-		if (au == 0)
+		if (__rxrpc_unuse_local(local)) {
+			rxrpc_get_local(local);
 			rxrpc_queue_local(local);
-		else
-			rxrpc_put_local(local);
+		}
 	}
 }
 
@@ -468,7 +462,7 @@ static void rxrpc_local_processor(struct
 
 	do {
 		again = false;
-		if (atomic_read(&local->active_users) == 0) {
+		if (!__rxrpc_use_local(local)) {
 			rxrpc_local_destroyer(local);
 			break;
 		}
@@ -482,6 +476,8 @@ static void rxrpc_local_processor(struct
 			rxrpc_process_local_events(local);
 			again = true;
 		}
+
+		__rxrpc_unuse_local(local);
 	} while (again);
 
 	rxrpc_put_local(local);
--- a/net/rxrpc/peer_event.c
+++ b/net/rxrpc/peer_event.c
@@ -364,27 +364,31 @@ static void rxrpc_peer_keepalive_dispatc
 		if (!rxrpc_get_peer_maybe(peer))
 			continue;
 
-		spin_unlock_bh(&rxnet->peer_hash_lock);
+		if (__rxrpc_use_local(peer->local)) {
+			spin_unlock_bh(&rxnet->peer_hash_lock);
 
-		keepalive_at = peer->last_tx_at + RXRPC_KEEPALIVE_TIME;
-		slot = keepalive_at - base;
-		_debug("%02x peer %u t=%d {%pISp}",
-		       cursor, peer->debug_id, slot, &peer->srx.transport);
+			keepalive_at = peer->last_tx_at + RXRPC_KEEPALIVE_TIME;
+			slot = keepalive_at - base;
+			_debug("%02x peer %u t=%d {%pISp}",
+			       cursor, peer->debug_id, slot, &peer->srx.transport);
 
-		if (keepalive_at <= base ||
-		    keepalive_at > base + RXRPC_KEEPALIVE_TIME) {
-			rxrpc_send_keepalive(peer);
-			slot = RXRPC_KEEPALIVE_TIME;
-		}
+			if (keepalive_at <= base ||
+			    keepalive_at > base + RXRPC_KEEPALIVE_TIME) {
+				rxrpc_send_keepalive(peer);
+				slot = RXRPC_KEEPALIVE_TIME;
+			}
 
-		/* A transmission to this peer occurred since last we examined
-		 * it so put it into the appropriate future bucket.
-		 */
-		slot += cursor;
-		slot &= mask;
-		spin_lock_bh(&rxnet->peer_hash_lock);
-		list_add_tail(&peer->keepalive_link,
-			      &rxnet->peer_keepalive[slot & mask]);
+			/* A transmission to this peer occurred since last we
+			 * examined it so put it into the appropriate future
+			 * bucket.
+			 */
+			slot += cursor;
+			slot &= mask;
+			spin_lock_bh(&rxnet->peer_hash_lock);
+			list_add_tail(&peer->keepalive_link,
+				      &rxnet->peer_keepalive[slot & mask]);
+			rxrpc_unuse_local(peer->local);
+		}
 		rxrpc_put_peer_locked(peer);
 	}
 


