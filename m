Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF6720F89F
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 17:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389639AbgF3Pmk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 11:42:40 -0400
Received: from mxout03.lancloud.ru ([89.108.73.187]:43306 "EHLO
        mxout03.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389636AbgF3Pmk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jun 2020 11:42:40 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout03.lancloud.ru 0D0EE20A5399
Received: from LanCloud
Received: from LanCloud
Received: by spb1wst017.omp.ru (Postfix, from userid 10000)
        id 7E459BA1D4B; Tue, 30 Jun 2020 18:36:41 +0300 (MSK)
From:   Denis Grigorev <d.grigorev@omprussia.ru>
To:     <stable@vger.kernel.org>
CC:     <ben@decadent.org.uk>
Subject: [PATCH 3.16 04/10] Bluetooth: Make __l2cap_wait_ack more efficient
Date:   Tue, 30 Jun 2020 18:36:35 +0300
Message-ID: <20200630153641.21004-5-d.grigorev@omprussia.ru>
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

Use chan->state instead of chan->conn because waiting
for ACK's is only possible in the BT_CONNECTED state.
Also avoids reference to the conn structure so makes
locking easier.

Only call __l2cap_wait_ack() when the needed condition
of chan->unacked_frames > 0 && chan->state == BT_CONNECTED
is true and convert the while loop to a do while loop.

__l2cap_wait_ack() change the function prototype to
pass in the chan variable as chan is already available
in the calling function l2cap_sock_shutdown(). Avoids
locking issues.

Signed-off-by: Dean Jenkins <Dean_Jenkins@mentor.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
---
 net/bluetooth/l2cap_sock.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index e56d34f027dd..6c351b43bb42 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1048,16 +1048,15 @@ static void l2cap_sock_kill(struct sock *sk)
 	sock_put(sk);
 }
 
-static int __l2cap_wait_ack(struct sock *sk)
+static int __l2cap_wait_ack(struct sock *sk, struct l2cap_chan *chan)
 {
-	struct l2cap_chan *chan = l2cap_pi(sk)->chan;
 	DECLARE_WAITQUEUE(wait, current);
 	int err = 0;
 	int timeo = HZ/5;
 
 	add_wait_queue(sk_sleep(sk), &wait);
 	set_current_state(TASK_INTERRUPTIBLE);
-	while (chan->unacked_frames > 0 && chan->conn) {
+	do {
 		if (!timeo)
 			timeo = HZ/5;
 
@@ -1074,7 +1073,10 @@ static int __l2cap_wait_ack(struct sock *sk)
 		err = sock_error(sk);
 		if (err)
 			break;
-	}
+
+	} while (chan->unacked_frames > 0 &&
+		 chan->state == BT_CONNECTED);
+
 	set_current_state(TASK_RUNNING);
 	remove_wait_queue(sk_sleep(sk), &wait);
 	return err;
@@ -1107,8 +1109,10 @@ static int l2cap_sock_shutdown(struct socket *sock, int how)
 	lock_sock(sk);
 
 	if (!sk->sk_shutdown) {
-		if (chan->mode == L2CAP_MODE_ERTM)
-			err = __l2cap_wait_ack(sk);
+		if (chan->mode == L2CAP_MODE_ERTM &&
+		    chan->unacked_frames > 0 &&
+		    chan->state == BT_CONNECTED)
+			err = __l2cap_wait_ack(sk, chan);
 
 		sk->sk_shutdown = SHUTDOWN_MASK;
 
-- 
2.17.1

