Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7C9E25969F
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730474AbgIAQFB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:05:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:54066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731461AbgIAPll (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:41:41 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC2AA2064B;
        Tue,  1 Sep 2020 15:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974901;
        bh=k3sLFeyZTzrCfkRSumuFDZjdrcsEaxOYzrV5Z7HyN04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k2S3Bac97nZWyiOBV4pnwwLLnypGeehhJaBDPF21kdFDkSm/OTpMh/nYaZnXX8RGO
         2aqviVgnegEU7Dg3Bb8NdSouEVqWjMO6g4WbQkzdWkFrqRRtjiI0MORkJ0Y53Jb7ML
         f9vNzq91qVrMD48RBLoazfKAO0EIvluHVuaJQAl8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 134/255] can: j1939: transport: j1939_xtp_rx_dat_one(): compare own packets to detect corruptions
Date:   Tue,  1 Sep 2020 17:09:50 +0200
Message-Id: <20200901151007.136796033@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit e052d0540298bfe0f6cbbecdc7e2ea9b859575b2 ]

Since the stack relays on receiving own packets, it was overwriting own
transmit buffer from received packets.

At least theoretically, the received echo buffer can be corrupt or
changed and the session partner can request to resend previous data. In
this case we will re-send bad data.

With this patch we will stop to overwrite own TX buffer and use it for
sanity checking.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://lore.kernel.org/r/20200807105200.26441-6-o.rempel@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/j1939/transport.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index dbd215cbc53d8..a8dd956b5e8e1 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -1803,7 +1803,20 @@ static void j1939_xtp_rx_dat_one(struct j1939_session *session,
 	}
 
 	tpdat = se_skb->data;
-	memcpy(&tpdat[offset], &dat[1], nbytes);
+	if (!session->transmission) {
+		memcpy(&tpdat[offset], &dat[1], nbytes);
+	} else {
+		int err;
+
+		err = memcmp(&tpdat[offset], &dat[1], nbytes);
+		if (err)
+			netdev_err_once(priv->ndev,
+					"%s: 0x%p: Data of RX-looped back packet (%*ph) doesn't match TX data (%*ph)!\n",
+					__func__, session,
+					nbytes, &dat[1],
+					nbytes, &tpdat[offset]);
+	}
+
 	if (packet == session->pkt.rx)
 		session->pkt.rx++;
 
-- 
2.25.1



