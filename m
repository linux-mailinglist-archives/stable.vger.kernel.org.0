Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4486220F89E
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 17:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389638AbgF3Pmk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 11:42:40 -0400
Received: from mxout03.lancloud.ru ([89.108.73.187]:43326 "EHLO
        mxout03.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389639AbgF3Pmj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jun 2020 11:42:39 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout03.lancloud.ru 06A7820A5394
Received: from LanCloud
Received: from LanCloud
Received: by spb1wst017.omp.ru (Postfix, from userid 10000)
        id 7B56CBA1D4A; Tue, 30 Jun 2020 18:36:41 +0300 (MSK)
From:   Denis Grigorev <d.grigorev@omprussia.ru>
To:     <stable@vger.kernel.org>
CC:     <ben@decadent.org.uk>
Subject: [PATCH 3.16 03/10] Bluetooth: L2CAP ERTM shutdown protect sk and chan
Date:   Tue, 30 Jun 2020 18:36:34 +0300
Message-ID: <20200630153641.21004-4-d.grigorev@omprussia.ru>
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

During execution of l2cap_sock_shutdown() which might
sleep, the sk and chan structures can be in an unlocked
condition which potentially allows the structures to be
freed by other running threads. Therefore, there is a
possibility of a malfunction or memory reuse after being
freed.

Keep the sk and chan structures alive during the
execution of l2cap_sock_shutdown() by using their
respective hold and put functions. This allows the structures
to be freeable at the end of l2cap_sock_shutdown().

Signed-off-by: Kautuk Consul <Kautuk_Consul@mentor.com>
Signed-off-by: Dean Jenkins <Dean_Jenkins@mentor.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
---
 net/bluetooth/l2cap_sock.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index 071d35c9f3b4..e56d34f027dd 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1092,7 +1092,12 @@ static int l2cap_sock_shutdown(struct socket *sock, int how)
 	if (!sk)
 		return 0;
 
+	/* prevent sk structure from being freed whilst unlocked */
+	sock_hold(sk);
+
 	chan = l2cap_pi(sk)->chan;
+	/* prevent chan structure from being freed whilst unlocked */
+	l2cap_chan_hold(chan);
 	conn = chan->conn;
 
 	if (conn)
@@ -1126,6 +1131,9 @@ static int l2cap_sock_shutdown(struct socket *sock, int how)
 	if (conn)
 		mutex_unlock(&conn->chan_lock);
 
+	l2cap_chan_put(chan);
+	sock_put(sk);
+
 	return err;
 }
 
-- 
2.17.1

