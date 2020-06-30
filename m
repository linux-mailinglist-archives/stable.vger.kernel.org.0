Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4734F20F87B
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 17:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389567AbgF3Pgp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 11:36:45 -0400
Received: from mxout04.lancloud.ru ([89.108.124.63]:47980 "EHLO
        mxout04.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389573AbgF3Pgo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jun 2020 11:36:44 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout04.lancloud.ru AC27D208C03C
Received: from LanCloud
Received: from LanCloud
Received: by spb1wst017.omp.ru (Postfix, from userid 10000)
        id A3DBDBA1E5A; Tue, 30 Jun 2020 18:36:41 +0300 (MSK)
From:   Denis Grigorev <d.grigorev@omprussia.ru>
To:     <stable@vger.kernel.org>
CC:     <ben@decadent.org.uk>
Subject: [PATCH 3.16 10/10] Bluetooth: l2cap_disconnection_req priority over shutdown
Date:   Tue, 30 Jun 2020 18:36:41 +0300
Message-ID: <20200630153641.21004-11-d.grigorev@omprussia.ru>
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

There is a L2CAP protocol race between the local peer and
the remote peer demanding disconnection of the L2CAP link.

When L2CAP ERTM is used, l2cap_sock_shutdown() can be called
from userland to disconnect L2CAP. However, there can be a
delay introduced by waiting for ACKs. During this waiting
period, the remote peer may have sent a Disconnection Request.
Therefore, recheck the shutdown status of the socket
after waiting for ACKs because there is no need to do
further processing if the connection has gone.

Signed-off-by: Dean Jenkins <Dean_Jenkins@mentor.com>
Signed-off-by: Harish Jenny K N <harish_kandiga@mentor.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
---
 net/bluetooth/l2cap_sock.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index efc0326f6823..e01f1557e1cc 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1123,9 +1123,17 @@ static int l2cap_sock_shutdown(struct socket *sock, int how)
 
 	if (chan->mode == L2CAP_MODE_ERTM &&
 	    chan->unacked_frames > 0 &&
-	    chan->state == BT_CONNECTED)
+	    chan->state == BT_CONNECTED) {
 		err = __l2cap_wait_ack(sk, chan);
 
+		/* After waiting for ACKs, check whether shutdown
+		 * has already been actioned to close the L2CAP
+		 * link such as by l2cap_disconnection_req().
+		 */
+		if (sk->sk_shutdown)
+			goto has_shutdown;
+	}
+
 	sk->sk_shutdown = SHUTDOWN_MASK;
 	release_sock(sk);
 
@@ -1156,6 +1164,7 @@ static int l2cap_sock_shutdown(struct socket *sock, int how)
 		err = bt_sock_wait_state(sk, BT_CLOSED,
 					 sk->sk_lingertime);
 
+has_shutdown:
 	l2cap_chan_put(chan);
 	sock_put(sk);
 
-- 
2.17.1

