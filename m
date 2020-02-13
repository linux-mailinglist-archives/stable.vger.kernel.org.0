Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E38C15C5C3
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728787AbgBMPYs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:24:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:39102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728771AbgBMPYr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:24:47 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88D7424693;
        Thu, 13 Feb 2020 15:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607486;
        bh=axkzjAVqLhMmmBO+eVTMGQ/6LdJuBAFn24vBXIHaDHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2cWEcezUVI0LlL6R1WjFHRmccGTiNWoJ35yLppHaSSEWbEueS61V4Jdbb1hVriJFR
         o7MlcC2E4oHMYAeV0vGuknwfouzLEgqaslkiJIV+7CLr9Z1XJ0TGdbqa3Tl8KGVJ0q
         c8tpfde8a/XVLqbBGp7apTBIbCCg4OHYNjZ8z44s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: [PATCH 4.14 017/173] rxrpc: Fix NULL pointer deref due to call->conn being cleared on disconnect
Date:   Thu, 13 Feb 2020 07:18:40 -0800
Message-Id: <20200213151937.337219002@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151931.677980430@linuxfoundation.org>
References: <20200213151931.677980430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 5273a191dca65a675dc0bcf3909e59c6933e2831 ]

When a call is disconnected, the connection pointer from the call is
cleared to make sure it isn't used again and to prevent further attempted
transmission for the call.  Unfortunately, there might be a daemon trying
to use it at the same time to transmit a packet.

Fix this by keeping call->conn set, but setting a flag on the call to
indicate disconnection instead.

Remove also the bits in the transmission functions where the conn pointer is
checked and a ref taken under spinlock as this is now redundant.

Fixes: 8d94aa381dab ("rxrpc: Calls shouldn't hold socket refs")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/ar-internal.h |    1 +
 net/rxrpc/call_object.c |    4 ++--
 net/rxrpc/conn_client.c |    3 +--
 net/rxrpc/conn_object.c |    4 ++--
 net/rxrpc/output.c      |   26 +++++++++-----------------
 5 files changed, 15 insertions(+), 23 deletions(-)

--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -451,6 +451,7 @@ enum rxrpc_call_flag {
 	RXRPC_CALL_SEND_PING,		/* A ping will need to be sent */
 	RXRPC_CALL_PINGING,		/* Ping in process */
 	RXRPC_CALL_RETRANS_TIMEOUT,	/* Retransmission due to timeout occurred */
+	RXRPC_CALL_DISCONNECTED,	/* The call has been disconnected */
 };
 
 /*
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -505,7 +505,7 @@ void rxrpc_release_call(struct rxrpc_soc
 
 	_debug("RELEASE CALL %p (%d CONN %p)", call, call->debug_id, conn);
 
-	if (conn)
+	if (conn && !test_bit(RXRPC_CALL_DISCONNECTED, &call->flags))
 		rxrpc_disconnect_call(call);
 
 	for (i = 0; i < RXRPC_RXTX_BUFF_SIZE; i++) {
@@ -639,6 +639,7 @@ static void rxrpc_rcu_destroy_call(struc
 {
 	struct rxrpc_call *call = container_of(rcu, struct rxrpc_call, rcu);
 
+	rxrpc_put_connection(call->conn);
 	rxrpc_put_peer(call->peer);
 	kfree(call->rxtx_buffer);
 	kfree(call->rxtx_annotations);
@@ -660,7 +661,6 @@ void rxrpc_cleanup_call(struct rxrpc_cal
 
 	ASSERTCMP(call->state, ==, RXRPC_CALL_COMPLETE);
 	ASSERT(test_bit(RXRPC_CALL_RELEASED, &call->flags));
-	ASSERTCMP(call->conn, ==, NULL);
 
 	/* Clean up the Rx/Tx buffer */
 	for (i = 0; i < RXRPC_RXTX_BUFF_SIZE; i++)
--- a/net/rxrpc/conn_client.c
+++ b/net/rxrpc/conn_client.c
@@ -762,9 +762,9 @@ void rxrpc_disconnect_client_call(struct
 	struct rxrpc_net *rxnet = rxrpc_net(sock_net(&call->socket->sk));
 
 	trace_rxrpc_client(conn, channel, rxrpc_client_chan_disconnect);
-	call->conn = NULL;
 
 	spin_lock(&conn->channel_lock);
+	set_bit(RXRPC_CALL_DISCONNECTED, &call->flags);
 
 	/* Calls that have never actually been assigned a channel can simply be
 	 * discarded.  If the conn didn't get used either, it will follow
@@ -863,7 +863,6 @@ out:
 	spin_unlock(&rxnet->client_conn_cache_lock);
 out_2:
 	spin_unlock(&conn->channel_lock);
-	rxrpc_put_connection(conn);
 	_leave("");
 	return;
 
--- a/net/rxrpc/conn_object.c
+++ b/net/rxrpc/conn_object.c
@@ -163,6 +163,8 @@ void __rxrpc_disconnect_call(struct rxrp
 
 	_enter("%d,%x", conn->debug_id, call->cid);
 
+	set_bit(RXRPC_CALL_DISCONNECTED, &call->flags);
+
 	if (rcu_access_pointer(chan->call) == call) {
 		/* Save the result of the call so that we can repeat it if necessary
 		 * through the channel, whilst disposing of the actual call record.
@@ -207,9 +209,7 @@ void rxrpc_disconnect_call(struct rxrpc_
 	__rxrpc_disconnect_call(conn, call);
 	spin_unlock(&conn->channel_lock);
 
-	call->conn = NULL;
 	conn->idle_timestamp = jiffies;
-	rxrpc_put_connection(conn);
 }
 
 /*
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -96,7 +96,7 @@ static size_t rxrpc_fill_out_ack(struct
  */
 int rxrpc_send_ack_packet(struct rxrpc_call *call, bool ping)
 {
-	struct rxrpc_connection *conn = NULL;
+	struct rxrpc_connection *conn;
 	struct rxrpc_ack_buffer *pkt;
 	struct msghdr msg;
 	struct kvec iov[2];
@@ -106,18 +106,14 @@ int rxrpc_send_ack_packet(struct rxrpc_c
 	int ret;
 	u8 reason;
 
-	spin_lock_bh(&call->lock);
-	if (call->conn)
-		conn = rxrpc_get_connection_maybe(call->conn);
-	spin_unlock_bh(&call->lock);
-	if (!conn)
+	if (test_bit(RXRPC_CALL_DISCONNECTED, &call->flags))
 		return -ECONNRESET;
 
 	pkt = kzalloc(sizeof(*pkt), GFP_KERNEL);
-	if (!pkt) {
-		rxrpc_put_connection(conn);
+	if (!pkt)
 		return -ENOMEM;
-	}
+
+	conn = call->conn;
 
 	msg.msg_name	= &call->peer->srx.transport;
 	msg.msg_namelen	= call->peer->srx.transport_len;
@@ -204,7 +200,6 @@ int rxrpc_send_ack_packet(struct rxrpc_c
 	}
 
 out:
-	rxrpc_put_connection(conn);
 	kfree(pkt);
 	return ret;
 }
@@ -214,20 +209,18 @@ out:
  */
 int rxrpc_send_abort_packet(struct rxrpc_call *call)
 {
-	struct rxrpc_connection *conn = NULL;
+	struct rxrpc_connection *conn;
 	struct rxrpc_abort_buffer pkt;
 	struct msghdr msg;
 	struct kvec iov[1];
 	rxrpc_serial_t serial;
 	int ret;
 
-	spin_lock_bh(&call->lock);
-	if (call->conn)
-		conn = rxrpc_get_connection_maybe(call->conn);
-	spin_unlock_bh(&call->lock);
-	if (!conn)
+	if (test_bit(RXRPC_CALL_DISCONNECTED, &call->flags))
 		return -ECONNRESET;
 
+	conn = call->conn;
+
 	msg.msg_name	= &call->peer->srx.transport;
 	msg.msg_namelen	= call->peer->srx.transport_len;
 	msg.msg_control	= NULL;
@@ -255,7 +248,6 @@ int rxrpc_send_abort_packet(struct rxrpc
 	ret = kernel_sendmsg(conn->params.local->socket,
 			     &msg, iov, 1, sizeof(pkt));
 
-	rxrpc_put_connection(conn);
 	return ret;
 }
 


