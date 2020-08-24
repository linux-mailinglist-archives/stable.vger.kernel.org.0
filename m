Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD5B724F47A
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbgHXIhK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:37:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:50312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727917AbgHXIhJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:37:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9014A207DF;
        Mon, 24 Aug 2020 08:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258228;
        bh=Szw6jA3d8Pxqmf1JA6WaAVW8AEfSzqqzAAso5Yu42xk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lNXWp9MmqoCFO4+S0pJqmyayntlFVIjNPVYLMPM3eakXEY62iMh2DRQeYm3SsOJiG
         9gNvox+UKBduvYZW4/0EAU0/v8FJr+5LcYy3f2xuLH7Y3pzlXW2U13QlHX7BbBF1NA
         h6sBVQU8q6V9Tu7xeMnd0bVBxhU1AHw0kcAuXOpg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 092/148] can: j1939: fix support for multipacket broadcast message
Date:   Mon, 24 Aug 2020 10:29:50 +0200
Message-Id: <20200824082418.452898742@linuxfoundation.org>
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

[ Upstream commit f4fd77fd87e9b214c26bb2ebd4f90055eaea5ade ]

Currently j1939_tp_im_involved_anydir() in j1939_tp_recv() check the previously
set flags J1939_ECU_LOCAL_DST and J1939_ECU_LOCAL_SRC of incoming skb, thus
multipacket broadcast message was aborted by receive side because it may come
from remote ECUs and have no exact dst address. Similarly, j1939_tp_cmd_recv()
and j1939_xtp_rx_dat() didn't process broadcast message.

So fix it by checking and process broadcast message in j1939_tp_recv(),
j1939_tp_cmd_recv() and j1939_xtp_rx_dat().

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Link: https://lore.kernel.org/r/1596599425-5534-2-git-send-email-zhangchangzhong@huawei.com
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/j1939/transport.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index 90a2baac8a4aa..67189b4c482c5 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -1673,8 +1673,12 @@ static void j1939_xtp_rx_rts(struct j1939_priv *priv, struct sk_buff *skb,
 			return;
 		}
 		session = j1939_xtp_rx_rts_session_new(priv, skb);
-		if (!session)
+		if (!session) {
+			if (cmd == J1939_TP_CMD_BAM && j1939_sk_recv_match(priv, skcb))
+				netdev_info(priv->ndev, "%s: failed to create TP BAM session\n",
+					    __func__);
 			return;
+		}
 	} else {
 		if (j1939_xtp_rx_rts_session_active(session, skb)) {
 			j1939_session_put(session);
@@ -1852,6 +1856,13 @@ static void j1939_xtp_rx_dat(struct j1939_priv *priv, struct sk_buff *skb)
 		else
 			j1939_xtp_rx_dat_one(session, skb);
 	}
+
+	if (j1939_cb_is_broadcast(skcb)) {
+		session = j1939_session_get_by_addr(priv, &skcb->addr, false,
+						    false);
+		if (session)
+			j1939_xtp_rx_dat_one(session, skb);
+	}
 }
 
 /* j1939 main intf */
@@ -1943,7 +1954,7 @@ static void j1939_tp_cmd_recv(struct j1939_priv *priv, struct sk_buff *skb)
 		if (j1939_tp_im_transmitter(skcb))
 			j1939_xtp_rx_rts(priv, skb, true);
 
-		if (j1939_tp_im_receiver(skcb))
+		if (j1939_tp_im_receiver(skcb) || j1939_cb_is_broadcast(skcb))
 			j1939_xtp_rx_rts(priv, skb, false);
 
 		break;
@@ -2007,7 +2018,7 @@ int j1939_tp_recv(struct j1939_priv *priv, struct sk_buff *skb)
 {
 	struct j1939_sk_buff_cb *skcb = j1939_skb_to_cb(skb);
 
-	if (!j1939_tp_im_involved_anydir(skcb))
+	if (!j1939_tp_im_involved_anydir(skcb) && !j1939_cb_is_broadcast(skcb))
 		return 0;
 
 	switch (skcb->addr.pgn) {
-- 
2.25.1



