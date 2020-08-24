Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24C9724F8B6
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729566AbgHXIsf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:48:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:49762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729559AbgHXIsd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:48:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6EBC204FD;
        Mon, 24 Aug 2020 08:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258912;
        bh=I2rc69Oc47pz8Ily187amhLgZCDrNoxj7kJnj5evJDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1w9tJSMa+v+JCpYVHSHYyOj6k62o57nVjHu1z1B501Vqo6cOxpDja1/GcH01+NrsV
         9e/ypZ7iQrV8K1R/nM4OGxnqFPaKUfLD5bfVJtkwaGJvyYX/QueFxcuh05gcK1aYXN
         nD9bENFilcKkQpZ6jKuz/dZKkfinR5hxfb09flGA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Henrique Figueira <henrislip@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 072/107] can: j1939: transport: add j1939_session_skb_find_by_offset() function
Date:   Mon, 24 Aug 2020 10:30:38 +0200
Message-Id: <20200824082408.687314889@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082405.020301642@linuxfoundation.org>
References: <20200824082405.020301642@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit 840835c9281215341d84966a8855f267a971e6a3 ]

Sometimes it makes no sense to search the skb by pkt.dpo, since we need
next the skb within the transaction block. This may happen if we have an
ETP session with CTS set to less than 255 packets.

After this patch, we will be able to work with ETP sessions where the
block size (ETP.CM_CTS byte 2) is less than 255 packets.

Reported-by: Henrique Figueira <henrislip@gmail.com>
Reported-by: https://github.com/linux-can/can-utils/issues/228
Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://lore.kernel.org/r/20200807105200.26441-5-o.rempel@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/j1939/transport.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index 30957c9a8eb7a..90a2baac8a4aa 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -352,17 +352,16 @@ void j1939_session_skb_queue(struct j1939_session *session,
 	skb_queue_tail(&session->skb_queue, skb);
 }
 
-static struct sk_buff *j1939_session_skb_find(struct j1939_session *session)
+static struct
+sk_buff *j1939_session_skb_find_by_offset(struct j1939_session *session,
+					  unsigned int offset_start)
 {
 	struct j1939_priv *priv = session->priv;
+	struct j1939_sk_buff_cb *do_skcb;
 	struct sk_buff *skb = NULL;
 	struct sk_buff *do_skb;
-	struct j1939_sk_buff_cb *do_skcb;
-	unsigned int offset_start;
 	unsigned long flags;
 
-	offset_start = session->pkt.dpo * 7;
-
 	spin_lock_irqsave(&session->skb_queue.lock, flags);
 	skb_queue_walk(&session->skb_queue, do_skb) {
 		do_skcb = j1939_skb_to_cb(do_skb);
@@ -382,6 +381,14 @@ static struct sk_buff *j1939_session_skb_find(struct j1939_session *session)
 	return skb;
 }
 
+static struct sk_buff *j1939_session_skb_find(struct j1939_session *session)
+{
+	unsigned int offset_start;
+
+	offset_start = session->pkt.dpo * 7;
+	return j1939_session_skb_find_by_offset(session, offset_start);
+}
+
 /* see if we are receiver
  * returns 0 for broadcasts, although we will receive them
  */
@@ -766,7 +773,7 @@ static int j1939_session_tx_dat(struct j1939_session *session)
 	int ret = 0;
 	u8 dat[8];
 
-	se_skb = j1939_session_skb_find(session);
+	se_skb = j1939_session_skb_find_by_offset(session, session->pkt.tx * 7);
 	if (!se_skb)
 		return -ENOBUFS;
 
@@ -1765,7 +1772,8 @@ static void j1939_xtp_rx_dat_one(struct j1939_session *session,
 			    __func__, session);
 		goto out_session_cancel;
 	}
-	se_skb = j1939_session_skb_find(session);
+
+	se_skb = j1939_session_skb_find_by_offset(session, packet * 7);
 	if (!se_skb) {
 		netdev_warn(priv->ndev, "%s: 0x%p: no skb found\n", __func__,
 			    session);
-- 
2.25.1



