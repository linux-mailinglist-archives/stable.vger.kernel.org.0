Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD93C20F87C
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 17:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389568AbgF3Pgp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 11:36:45 -0400
Received: from mxout04.lancloud.ru ([89.108.124.63]:47982 "EHLO
        mxout04.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389574AbgF3Pgp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jun 2020 11:36:45 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout04.lancloud.ru A9704208BA0F
Received: from LanCloud
Received: from LanCloud
Received: by spb1wst017.omp.ru (Postfix, from userid 10000)
        id 937C1BA1D5E; Tue, 30 Jun 2020 18:36:41 +0300 (MSK)
From:   Denis Grigorev <d.grigorev@omprussia.ru>
To:     <stable@vger.kernel.org>
CC:     <ben@decadent.org.uk>
Subject: [PATCH 3.16 08/10] Bluetooth: Unwind l2cap_sock_shutdown()
Date:   Tue, 30 Jun 2020 18:36:39 +0300
Message-ID: <20200630153641.21004-9-d.grigorev@omprussia.ru>
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

l2cap_sock_shutdown() is designed to only action shutdown
of the channel when shutdown is not already in progress.
Therefore, reorganise the code flow by adding a goto
to jump to the end of function handling when shutdown is
already being actioned. This removes one level of code
indentation and make the code more readable.

Signed-off-by: Dean Jenkins <Dean_Jenkins@mentor.com>
Signed-off-by: Harish Jenny K N <harish_kandiga@mentor.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
---
 net/bluetooth/l2cap_sock.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index 00b43f008941..01e52bea698c 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1105,6 +1105,11 @@ static int l2cap_sock_shutdown(struct socket *sock, int how)
 	if (!sk)
 		return 0;
 
+	if (sk->sk_shutdown)
+		goto shutdown_already;
+
+	BT_DBG("Handling sock shutdown");
+
 	/* prevent sk structure from being freed whilst unlocked */
 	sock_hold(sk);
 
@@ -1119,23 +1124,21 @@ static int l2cap_sock_shutdown(struct socket *sock, int how)
 	l2cap_chan_lock(chan);
 	lock_sock(sk);
 
-	if (!sk->sk_shutdown) {
-		if (chan->mode == L2CAP_MODE_ERTM &&
-		    chan->unacked_frames > 0 &&
-		    chan->state == BT_CONNECTED)
-			err = __l2cap_wait_ack(sk, chan);
+	if (chan->mode == L2CAP_MODE_ERTM &&
+	    chan->unacked_frames > 0 &&
+	    chan->state == BT_CONNECTED)
+		err = __l2cap_wait_ack(sk, chan);
 
-		sk->sk_shutdown = SHUTDOWN_MASK;
+	sk->sk_shutdown = SHUTDOWN_MASK;
 
-		release_sock(sk);
-		l2cap_chan_close(chan, 0);
-		lock_sock(sk);
+	release_sock(sk);
+	l2cap_chan_close(chan, 0);
+	lock_sock(sk);
 
-		if (sock_flag(sk, SOCK_LINGER) && sk->sk_lingertime &&
-		    !(current->flags & PF_EXITING))
-			err = bt_sock_wait_state(sk, BT_CLOSED,
-						 sk->sk_lingertime);
-	}
+	if (sock_flag(sk, SOCK_LINGER) && sk->sk_lingertime &&
+	    !(current->flags & PF_EXITING))
+		err = bt_sock_wait_state(sk, BT_CLOSED,
+					 sk->sk_lingertime);
 
 	if (!err && sk->sk_err)
 		err = -sk->sk_err;
@@ -1149,6 +1152,7 @@ static int l2cap_sock_shutdown(struct socket *sock, int how)
 	l2cap_chan_put(chan);
 	sock_put(sk);
 
+shutdown_already:
 	BT_DBG("err: %d", err);
 
 	return err;
-- 
2.17.1

