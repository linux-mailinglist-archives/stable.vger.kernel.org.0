Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8319820F8A1
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 17:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389637AbgF3Pmm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 11:42:42 -0400
Received: from mxout03.lancloud.ru ([89.108.73.187]:43462 "EHLO
        mxout03.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389641AbgF3Pmm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jun 2020 11:42:42 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout03.lancloud.ru 9D97120A538E
Received: from LanCloud
Received: from LanCloud
Received: by spb1wst017.omp.ru (Postfix, from userid 10000)
        id 9C754BA1D77; Tue, 30 Jun 2020 18:36:41 +0300 (MSK)
From:   Denis Grigorev <d.grigorev@omprussia.ru>
To:     <stable@vger.kernel.org>
CC:     <ben@decadent.org.uk>
Subject: [PATCH 3.16 09/10] Bluetooth: Reorganize mutex lock in l2cap_sock_shutdown()
Date:   Tue, 30 Jun 2020 18:36:40 +0300
Message-ID: <20200630153641.21004-10-d.grigorev@omprussia.ru>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200630153641.21004-1-d.grigorev@omprussia.ru>
References: <20200630153641.21004-1-d.grigorev@omprussia.ru>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [81.3.167.34]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To LFEX09.lancloud.ru
 (fd00:f066::59)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dean Jenkins <Dean_Jenkins@mentor.com>

This commit reorganizes the mutex lock and is now
only protecting l2cap_chan_close(). This is now consistent
with other places where l2cap_chan_close() is called.

If a conn connection exists, call
mutex_lock(&conn->chan_lock) before calling l2cap_chan_close()
to ensure other L2CAP protocol operations do not interfere.

Note that the conn structure has to be protected from being
freed as it is possible for the connection to be disconnected
whilst the locks are not held. This solution allows the mutex
lock to be used even when the connection has just been
disconnected.

This commit also reduces the scope of chan locking.

The only place where chan locking is needed is the call to
l2cap_chan_close(chan, 0) which if necessary closes the channel.
Therefore, move the l2cap_chan_lock(chan) and
l2cap_chan_lock(chan) locking calls to around
l2cap_chan_close(chan, 0).

This allows __l2cap_wait_ack(sk, chan) to be called with no
chan locks being held so L2CAP messaging over the ACL link
can be done unimpaired.

Signed-off-by: Dean Jenkins <Dean_Jenkins@mentor.com>
Signed-off-by: Harish Jenny K N <harish_kandiga@mentor.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
---
 net/bluetooth/l2cap_sock.c | 44 ++++++++++++++++++++++++--------------
 1 file changed, 28 insertions(+), 16 deletions(-)

diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index 01e52bea698c..efc0326f6823 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1105,6 +1105,8 @@ static int l2cap_sock_shutdown(struct socket *sock, int how)
 	if (!sk)
 		return 0;
 
+	lock_sock(sk);
+
 	if (sk->sk_shutdown)
 		goto shutdown_already;
 
@@ -1116,13 +1118,8 @@ static int l2cap_sock_shutdown(struct socket *sock, int how)
 	chan = l2cap_pi(sk)->chan;
 	/* prevent chan structure from being freed whilst unlocked */
 	l2cap_chan_hold(chan);
-	conn = chan->conn;
 
-	if (conn)
-		mutex_lock(&conn->chan_lock);
-
-	l2cap_chan_lock(chan);
-	lock_sock(sk);
+	BT_DBG("chan %p state %s", chan, state_to_string(chan->state));
 
 	if (chan->mode == L2CAP_MODE_ERTM &&
 	    chan->unacked_frames > 0 &&
@@ -1130,9 +1127,28 @@ static int l2cap_sock_shutdown(struct socket *sock, int how)
 		err = __l2cap_wait_ack(sk, chan);
 
 	sk->sk_shutdown = SHUTDOWN_MASK;
-
 	release_sock(sk);
+
+	l2cap_chan_lock(chan);
+	conn = chan->conn;
+	if (conn)
+		/* prevent conn structure from being freed */
+		l2cap_conn_get(conn);
+	l2cap_chan_unlock(chan);
+
+	if (conn)
+		/* mutex lock must be taken before l2cap_chan_lock() */
+		mutex_lock(&conn->chan_lock);
+
+	l2cap_chan_lock(chan);
 	l2cap_chan_close(chan, 0);
+	l2cap_chan_unlock(chan);
+
+	if (conn) {
+		mutex_unlock(&conn->chan_lock);
+		l2cap_conn_put(conn);
+	}
+
 	lock_sock(sk);
 
 	if (sock_flag(sk, SOCK_LINGER) && sk->sk_lingertime &&
@@ -1140,20 +1156,16 @@ static int l2cap_sock_shutdown(struct socket *sock, int how)
 		err = bt_sock_wait_state(sk, BT_CLOSED,
 					 sk->sk_lingertime);
 
+	l2cap_chan_put(chan);
+	sock_put(sk);
+
+shutdown_already:
 	if (!err && sk->sk_err)
 		err = -sk->sk_err;
 
 	release_sock(sk);
-	l2cap_chan_unlock(chan);
-
-	if (conn)
-		mutex_unlock(&conn->chan_lock);
 
-	l2cap_chan_put(chan);
-	sock_put(sk);
-
-shutdown_already:
-	BT_DBG("err: %d", err);
+	BT_DBG("Sock shutdown complete err: %d", err);
 
 	return err;
 }
-- 
2.17.1

