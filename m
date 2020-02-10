Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECBC71578AF
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729171AbgBJNJ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:09:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:36864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729396AbgBJMjU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:39:20 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FD8320838;
        Mon, 10 Feb 2020 12:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338359;
        bh=jfL2xgB0OH2/+eAWEFRux8QQXzIUfua+Ga5fmgvbbVM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UEb9bzMKWKhezXVFAQCLgJhm7A2apnWYmVDVZivdAbpdsJZSeHUSCZYgDJvthodbK
         v60+dNi0me8DHEeRFA35u1H8pkvKnUCNhZf8rO0/WyQirdEDL7PaS1J9h3FiiDKXSh
         LgPgH0BtIeTYikJakUssyYqrdd/jQI4oMp1FS5F0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: [PATCH 5.5 019/367] rxrpc: Fix NULL pointer deref due to call->conn being cleared on disconnect
Date:   Mon, 10 Feb 2020 04:28:52 -0800
Message-Id: <20200210122425.650886277@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
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
 net/rxrpc/output.c      |   27 +++++++++------------------
 5 files changed, 15 insertions(+), 24 deletions(-)

--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -490,6 +490,7 @@ enum rxrpc_call_flag {
 	RXRPC_CALL_RX_HEARD,		/* The peer responded at least once to this call */
 	RXRPC_CALL_RX_UNDERRUN,		/* Got data underrun */
 	RXRPC_CALL_IS_INTR,		/* The call is interruptible */
+	RXRPC_CALL_DISCONNECTED,	/* The call has been disconnected */
 };
 
 /*
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -493,7 +493,7 @@ void rxrpc_release_call(struct rxrpc_soc
 
 	_debug("RELEASE CALL %p (%d CONN %p)", call, call->debug_id, conn);
 
-	if (conn)
+	if (conn && !test_bit(RXRPC_CALL_DISCONNECTED, &call->flags))
 		rxrpc_disconnect_call(call);
 	if (call->security)
 		call->security->free_call_crypto(call);
@@ -569,6 +569,7 @@ static void rxrpc_rcu_destroy_call(struc
 	struct rxrpc_call *call = container_of(rcu, struct rxrpc_call, rcu);
 	struct rxrpc_net *rxnet = call->rxnet;
 
+	rxrpc_put_connection(call->conn);
 	rxrpc_put_peer(call->peer);
 	kfree(call->rxtx_buffer);
 	kfree(call->rxtx_annotations);
@@ -590,7 +591,6 @@ void rxrpc_cleanup_call(struct rxrpc_cal
 
 	ASSERTCMP(call->state, ==, RXRPC_CALL_COMPLETE);
 	ASSERT(test_bit(RXRPC_CALL_RELEASED, &call->flags));
-	ASSERTCMP(call->conn, ==, NULL);
 
 	rxrpc_cleanup_ring(call);
 	rxrpc_free_skb(call->tx_pending, rxrpc_skb_cleaned);
--- a/net/rxrpc/conn_client.c
+++ b/net/rxrpc/conn_client.c
@@ -785,6 +785,7 @@ void rxrpc_disconnect_client_call(struct
 	u32 cid;
 
 	spin_lock(&conn->channel_lock);
+	set_bit(RXRPC_CALL_DISCONNECTED, &call->flags);
 
 	cid = call->cid;
 	if (cid) {
@@ -792,7 +793,6 @@ void rxrpc_disconnect_client_call(struct
 		chan = &conn->channels[channel];
 	}
 	trace_rxrpc_client(conn, channel, rxrpc_client_chan_disconnect);
-	call->conn = NULL;
 
 	/* Calls that have never actually been assigned a channel can simply be
 	 * discarded.  If the conn didn't get used either, it will follow
@@ -908,7 +908,6 @@ out:
 	spin_unlock(&rxnet->client_conn_cache_lock);
 out_2:
 	spin_unlock(&conn->channel_lock);
-	rxrpc_put_connection(conn);
 	_leave("");
 	return;
 
--- a/net/rxrpc/conn_object.c
+++ b/net/rxrpc/conn_object.c
@@ -171,6 +171,8 @@ void __rxrpc_disconnect_call(struct rxrp
 
 	_enter("%d,%x", conn->debug_id, call->cid);
 
+	set_bit(RXRPC_CALL_DISCONNECTED, &call->flags);
+
 	if (rcu_access_pointer(chan->call) == call) {
 		/* Save the result of the call so that we can repeat it if necessary
 		 * through the channel, whilst disposing of the actual call record.
@@ -223,9 +225,7 @@ void rxrpc_disconnect_call(struct rxrpc_
 	__rxrpc_disconnect_call(conn, call);
 	spin_unlock(&conn->channel_lock);
 
-	call->conn = NULL;
 	conn->idle_timestamp = jiffies;
-	rxrpc_put_connection(conn);
 }
 
 /*
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -129,7 +129,7 @@ static size_t rxrpc_fill_out_ack(struct
 int rxrpc_send_ack_packet(struct rxrpc_call *call, bool ping,
 			  rxrpc_serial_t *_serial)
 {
-	struct rxrpc_connection *conn = NULL;
+	struct rxrpc_connection *conn;
 	struct rxrpc_ack_buffer *pkt;
 	struct msghdr msg;
 	struct kvec iov[2];
@@ -139,18 +139,14 @@ int rxrpc_send_ack_packet(struct rxrpc_c
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
@@ -244,7 +240,6 @@ int rxrpc_send_ack_packet(struct rxrpc_c
 	}
 
 out:
-	rxrpc_put_connection(conn);
 	kfree(pkt);
 	return ret;
 }
@@ -254,7 +249,7 @@ out:
  */
 int rxrpc_send_abort_packet(struct rxrpc_call *call)
 {
-	struct rxrpc_connection *conn = NULL;
+	struct rxrpc_connection *conn;
 	struct rxrpc_abort_buffer pkt;
 	struct msghdr msg;
 	struct kvec iov[1];
@@ -271,13 +266,11 @@ int rxrpc_send_abort_packet(struct rxrpc
 	    test_bit(RXRPC_CALL_TX_LAST, &call->flags))
 		return 0;
 
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
@@ -312,8 +305,6 @@ int rxrpc_send_abort_packet(struct rxrpc
 		trace_rxrpc_tx_packet(call->debug_id, &pkt.whdr,
 				      rxrpc_tx_point_call_abort);
 	rxrpc_tx_backoff(call, ret);
-
-	rxrpc_put_connection(conn);
 	return ret;
 }
 


