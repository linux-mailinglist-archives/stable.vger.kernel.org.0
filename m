Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF95120F87A
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 17:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389403AbgF3Pgp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 11:36:45 -0400
Received: from mxout04.lancloud.ru ([89.108.124.63]:47962 "EHLO
        mxout04.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389571AbgF3Pgo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jun 2020 11:36:44 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout04.lancloud.ru 61C5D208B9E1
Received: from LanCloud
Received: from LanCloud
Received: by spb1wst017.omp.ru (Postfix, from userid 10000)
        id 84EFEBA1D59; Tue, 30 Jun 2020 18:36:41 +0300 (MSK)
From:   Denis Grigorev <d.grigorev@omprussia.ru>
To:     <stable@vger.kernel.org>
CC:     <ben@decadent.org.uk>
Subject: [PATCH 3.16 06/10] Bluetooth: __l2cap_wait_ack() use msecs_to_jiffies()
Date:   Tue, 30 Jun 2020 18:36:37 +0300
Message-ID: <20200630153641.21004-7-d.grigorev@omprussia.ru>
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

Use msecs_to_jiffies() instead of using HZ so that it
is easier to specify the time in milliseconds.

Also add a #define L2CAP_WAIT_ACK_POLL_PERIOD to specify the 200ms
polling period so that it is defined in a single place.

Signed-off-by: Dean Jenkins <Dean_Jenkins@mentor.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
---
 include/net/bluetooth/l2cap.h | 1 +
 net/bluetooth/l2cap_sock.c    | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/net/bluetooth/l2cap.h b/include/net/bluetooth/l2cap.h
index 4abdcb220e3a..430381ba7e5e 100644
--- a/include/net/bluetooth/l2cap.h
+++ b/include/net/bluetooth/l2cap.h
@@ -54,6 +54,7 @@
 #define L2CAP_INFO_TIMEOUT		msecs_to_jiffies(4000)
 #define L2CAP_MOVE_TIMEOUT		msecs_to_jiffies(4000)
 #define L2CAP_MOVE_ERTX_TIMEOUT		msecs_to_jiffies(60000)
+#define L2CAP_WAIT_ACK_POLL_PERIOD	msecs_to_jiffies(200)
 
 #define L2CAP_A2MP_DEFAULT_MTU		670
 
diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index 662835fe0e95..0bd277fba24e 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1052,7 +1052,7 @@ static int __l2cap_wait_ack(struct sock *sk, struct l2cap_chan *chan)
 {
 	DECLARE_WAITQUEUE(wait, current);
 	int err = 0;
-	int timeo = HZ/5;
+	int timeo = L2CAP_WAIT_ACK_POLL_PERIOD;
 
 	add_wait_queue(sk_sleep(sk), &wait);
 	set_current_state(TASK_INTERRUPTIBLE);
@@ -1060,7 +1060,7 @@ static int __l2cap_wait_ack(struct sock *sk, struct l2cap_chan *chan)
 		BT_DBG("Waiting for %d ACKs", chan->unacked_frames);
 
 		if (!timeo)
-			timeo = HZ/5;
+			timeo = L2CAP_WAIT_ACK_POLL_PERIOD;
 
 		if (signal_pending(current)) {
 			err = sock_intr_errno(timeo);
-- 
2.17.1

