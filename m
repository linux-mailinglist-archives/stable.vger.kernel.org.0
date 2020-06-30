Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 567F820F89B
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 17:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389640AbgF3Pmj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 11:42:39 -0400
Received: from mxout03.lancloud.ru ([89.108.73.187]:43312 "EHLO
        mxout03.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389635AbgF3Pmj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jun 2020 11:42:39 -0400
X-Greylist: delayed 355 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Jun 2020 11:42:38 EDT
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout03.lancloud.ru AB4CB20A539E
Received: from LanCloud
Received: from LanCloud
Received: by spb1wst017.omp.ru (Postfix, from userid 10000)
        id 82949BA1D4F; Tue, 30 Jun 2020 18:36:41 +0300 (MSK)
From:   Denis Grigorev <d.grigorev@omprussia.ru>
To:     <stable@vger.kernel.org>
CC:     <ben@decadent.org.uk>
Subject: [PATCH 3.16 05/10] Bluetooth: Add BT_DBG to l2cap_sock_shutdown()
Date:   Tue, 30 Jun 2020 18:36:36 +0300
Message-ID: <20200630153641.21004-6-d.grigorev@omprussia.ru>
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

Add helpful BT_DBG debug to l2cap_sock_shutdown()
and __l2cap_wait_ack() so that the code flow can
be analysed.

Signed-off-by: Dean Jenkins <Dean_Jenkins@mentor.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
---
 net/bluetooth/l2cap_sock.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index 6c351b43bb42..662835fe0e95 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1057,6 +1057,8 @@ static int __l2cap_wait_ack(struct sock *sk, struct l2cap_chan *chan)
 	add_wait_queue(sk_sleep(sk), &wait);
 	set_current_state(TASK_INTERRUPTIBLE);
 	do {
+		BT_DBG("Waiting for %d ACKs", chan->unacked_frames);
+
 		if (!timeo)
 			timeo = HZ/5;
 
@@ -1138,6 +1140,8 @@ static int l2cap_sock_shutdown(struct socket *sock, int how)
 	l2cap_chan_put(chan);
 	sock_put(sk);
 
+	BT_DBG("err: %d", err);
+
 	return err;
 }
 
-- 
2.17.1

