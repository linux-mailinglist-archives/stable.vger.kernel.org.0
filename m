Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F95520F87D
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 17:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389569AbgF3Pgp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 11:36:45 -0400
Received: from mxout04.lancloud.ru ([89.108.124.63]:47986 "EHLO
        mxout04.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389575AbgF3Pgp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jun 2020 11:36:45 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout04.lancloud.ru A3949208BA01
Received: from LanCloud
Received: from LanCloud
Received: by spb1wst017.omp.ru (Postfix, from userid 10000)
        id 8C220BA1D5A; Tue, 30 Jun 2020 18:36:41 +0300 (MSK)
From:   Denis Grigorev <d.grigorev@omprussia.ru>
To:     <stable@vger.kernel.org>
CC:     <ben@decadent.org.uk>
Subject: [PATCH 3.16 07/10] Bluetooth: __l2cap_wait_ack() add defensive timeout
Date:   Tue, 30 Jun 2020 18:36:38 +0300
Message-ID: <20200630153641.21004-8-d.grigorev@omprussia.ru>
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

Add a timeout to prevent the do while loop running in an
infinite loop. This ensures that the channel will be
instructed to close within 10 seconds so prevents
l2cap_sock_shutdown() getting stuck forever.

Returns -ENOLINK when the timeout is reached. The channel
will be subequently closed and not all data will be ACK'ed.

Signed-off-by: Dean Jenkins <Dean_Jenkins@mentor.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
---
 include/net/bluetooth/l2cap.h |  1 +
 net/bluetooth/l2cap_sock.c    | 11 ++++++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/include/net/bluetooth/l2cap.h b/include/net/bluetooth/l2cap.h
index 430381ba7e5e..7bdf16944df3 100644
--- a/include/net/bluetooth/l2cap.h
+++ b/include/net/bluetooth/l2cap.h
@@ -55,6 +55,7 @@
 #define L2CAP_MOVE_TIMEOUT		msecs_to_jiffies(4000)
 #define L2CAP_MOVE_ERTX_TIMEOUT		msecs_to_jiffies(60000)
 #define L2CAP_WAIT_ACK_POLL_PERIOD	msecs_to_jiffies(200)
+#define L2CAP_WAIT_ACK_TIMEOUT		msecs_to_jiffies(10000)
 
 #define L2CAP_A2MP_DEFAULT_MTU		670
 
diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index 0bd277fba24e..00b43f008941 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1053,11 +1053,15 @@ static int __l2cap_wait_ack(struct sock *sk, struct l2cap_chan *chan)
 	DECLARE_WAITQUEUE(wait, current);
 	int err = 0;
 	int timeo = L2CAP_WAIT_ACK_POLL_PERIOD;
+	/* Timeout to prevent infinite loop */
+	unsigned long timeout = jiffies + L2CAP_WAIT_ACK_TIMEOUT;
 
 	add_wait_queue(sk_sleep(sk), &wait);
 	set_current_state(TASK_INTERRUPTIBLE);
 	do {
-		BT_DBG("Waiting for %d ACKs", chan->unacked_frames);
+		BT_DBG("Waiting for %d ACKs, timeout %04d ms",
+		       chan->unacked_frames, time_after(jiffies, timeout) ? 0 :
+		       jiffies_to_msecs(timeout - jiffies));
 
 		if (!timeo)
 			timeo = L2CAP_WAIT_ACK_POLL_PERIOD;
@@ -1076,6 +1080,11 @@ static int __l2cap_wait_ack(struct sock *sk, struct l2cap_chan *chan)
 		if (err)
 			break;
 
+		if (time_after(jiffies, timeout)) {
+			err = -ENOLINK;
+			break;
+		}
+
 	} while (chan->unacked_frames > 0 &&
 		 chan->state == BT_CONNECTED);
 
-- 
2.17.1

