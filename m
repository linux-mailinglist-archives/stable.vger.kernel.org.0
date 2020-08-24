Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28DAB24F46A
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbgHXIgH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:36:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:47550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728184AbgHXIfz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:35:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4E89207D3;
        Mon, 24 Aug 2020 08:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258154;
        bh=dXM8ebUwK/gOG6BlRks6/cnXzv5LRwXZ/MAjWYPQJ0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KvuqzGzRHcj6GkD3DOPgZ8tvgb+EhO+PHAXgaLryeEZr/bMQOx1Li8yW8/b0EcpFr
         MWQA4NvrzyQzrVUPl1ODXTJmWKmKMdBPYjhsUojr92MBKgdEp3PZNDHlN3lqO6t6c6
         KBNvHavVWnXJ/0PtXErNeSP/oyswxm/wIOC0BFeI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 095/148] can: j1939: add rxtimer for multipacket broadcast session
Date:   Mon, 24 Aug 2020 10:29:53 +0200
Message-Id: <20200824082418.597330180@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082413.900489417@linuxfoundation.org>
References: <20200824082413.900489417@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit 0ae18a82686f9b9965a8ce0dd81371871b306ffe ]

According to SAE J1939/21 (Chapter 5.12.3 and APPENDIX C), for transmit side
the required time interval between packets of a multipacket broadcast message
is 50 to 200 ms, the responder shall use a timeout of 250ms (provides margin
allowing for the maximumm spacing of 200ms). For receive side a timeout will
occur when a time of greater than 750 ms elapsed between two message packets
when more packets were expected.

So this patch fix and add rxtimer for multipacket broadcast session.

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Link: https://lore.kernel.org/r/1596599425-5534-5-git-send-email-zhangchangzhong@huawei.com
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/j1939/transport.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index e3167619b196f..dbd215cbc53d8 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -723,10 +723,12 @@ static int j1939_session_tx_rts(struct j1939_session *session)
 		return ret;
 
 	session->last_txcmd = dat[0];
-	if (dat[0] == J1939_TP_CMD_BAM)
+	if (dat[0] == J1939_TP_CMD_BAM) {
 		j1939_tp_schedule_txtimer(session, 50);
-
-	j1939_tp_set_rxtimeout(session, 1250);
+		j1939_tp_set_rxtimeout(session, 250);
+	} else {
+		j1939_tp_set_rxtimeout(session, 1250);
+	}
 
 	netdev_dbg(session->priv->ndev, "%s: 0x%p\n", __func__, session);
 
@@ -1687,11 +1689,15 @@ static void j1939_xtp_rx_rts(struct j1939_priv *priv, struct sk_buff *skb,
 	}
 	session->last_cmd = cmd;
 
-	j1939_tp_set_rxtimeout(session, 1250);
-
-	if (cmd != J1939_TP_CMD_BAM && !session->transmission) {
-		j1939_session_txtimer_cancel(session);
-		j1939_tp_schedule_txtimer(session, 0);
+	if (cmd == J1939_TP_CMD_BAM) {
+		if (!session->transmission)
+			j1939_tp_set_rxtimeout(session, 750);
+	} else {
+		if (!session->transmission) {
+			j1939_session_txtimer_cancel(session);
+			j1939_tp_schedule_txtimer(session, 0);
+		}
+		j1939_tp_set_rxtimeout(session, 1250);
 	}
 
 	j1939_session_put(session);
@@ -1742,6 +1748,7 @@ static void j1939_xtp_rx_dat_one(struct j1939_session *session,
 	int offset;
 	int nbytes;
 	bool final = false;
+	bool remain = false;
 	bool do_cts_eoma = false;
 	int packet;
 
@@ -1804,6 +1811,8 @@ static void j1939_xtp_rx_dat_one(struct j1939_session *session,
 	    j1939_cb_is_broadcast(&session->skcb)) {
 		if (session->pkt.rx >= session->pkt.total)
 			final = true;
+		else
+			remain = true;
 	} else {
 		/* never final, an EOMA must follow */
 		if (session->pkt.rx >= session->pkt.last)
@@ -1813,6 +1822,9 @@ static void j1939_xtp_rx_dat_one(struct j1939_session *session,
 	if (final) {
 		j1939_session_timers_cancel(session);
 		j1939_session_completed(session);
+	} else if (remain) {
+		if (!session->transmission)
+			j1939_tp_set_rxtimeout(session, 750);
 	} else if (do_cts_eoma) {
 		j1939_tp_set_rxtimeout(session, 1250);
 		if (!session->transmission)
-- 
2.25.1



