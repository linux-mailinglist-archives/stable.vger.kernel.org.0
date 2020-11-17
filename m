Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13F1E2B60E1
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728652AbgKQNNm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:13:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:44290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729715AbgKQNNl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:13:41 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D7C12151B;
        Tue, 17 Nov 2020 13:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605618820;
        bh=P6y/MZJeOHmtfCSicfP14D/aI3qrhisrOfJiC6mnawI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AqrnH31Oo7YwhUcc85FPfNHrUH4o+Df2dnMpp7goqRiQE1cYjuVB+4PYPTVAW2jwQ
         fqqls2wRvTgQNsGaricHaMvlKG0lmQjjhN4si6aw1whWzkuoj8kz3TwofJeMjn+CwU
         TIZr9VEKVUIQ/J/79mUDbYFJg0B9m3Z8Iyj051bQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 19/85] can: peak_canfd: pucan_handle_can_rx(): fix echo management when loopback is on
Date:   Tue, 17 Nov 2020 14:04:48 +0100
Message-Id: <20201117122111.983987766@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122111.018425544@linuxfoundation.org>
References: <20201117122111.018425544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephane Grosjean <s.grosjean@peak-system.com>

[ Upstream commit 93ef65e5a6357cc7381f85fcec9283fe29970045 ]

Echo management is driven by PUCAN_MSG_LOOPED_BACK bit, while loopback
frames are identified with PUCAN_MSG_SELF_RECEIVE bit. Those bits are set
for each outgoing frame written to the IP core so that a copy of each one
will be placed into the rx path. Thus,

- when PUCAN_MSG_LOOPED_BACK is set then the rx frame is an echo of a
  previously sent frame,
- when PUCAN_MSG_LOOPED_BACK+PUCAN_MSG_SELF_RECEIVE are set, then the rx
  frame is an echo AND a loopback frame. Therefore, this frame must be
  put into the socket rx path too.

This patch fixes how CAN frames are handled when these are sent while the
can interface is configured in "loopback on" mode.

Signed-off-by: Stephane Grosjean <s.grosjean@peak-system.com>
Link: https://lore.kernel.org/r/20201013153947.28012-1-s.grosjean@peak-system.com
Fixes: 8ac8321e4a79 ("can: peak: add support for PEAK PCAN-PCIe FD CAN-FD boards")
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/peak_canfd/peak_canfd.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/peak_canfd/peak_canfd.c b/drivers/net/can/peak_canfd/peak_canfd.c
index ed8561d4a90f4..a38dc6d9c9787 100644
--- a/drivers/net/can/peak_canfd/peak_canfd.c
+++ b/drivers/net/can/peak_canfd/peak_canfd.c
@@ -256,8 +256,7 @@ static int pucan_handle_can_rx(struct peak_canfd_priv *priv,
 		cf_len = get_can_dlc(pucan_msg_get_dlc(msg));
 
 	/* if this frame is an echo, */
-	if ((rx_msg_flags & PUCAN_MSG_LOOPED_BACK) &&
-	    !(rx_msg_flags & PUCAN_MSG_SELF_RECEIVE)) {
+	if (rx_msg_flags & PUCAN_MSG_LOOPED_BACK) {
 		unsigned long flags;
 
 		spin_lock_irqsave(&priv->echo_lock, flags);
@@ -271,7 +270,13 @@ static int pucan_handle_can_rx(struct peak_canfd_priv *priv,
 		netif_wake_queue(priv->ndev);
 
 		spin_unlock_irqrestore(&priv->echo_lock, flags);
-		return 0;
+
+		/* if this frame is only an echo, stop here. Otherwise,
+		 * continue to push this application self-received frame into
+		 * its own rx queue.
+		 */
+		if (!(rx_msg_flags & PUCAN_MSG_SELF_RECEIVE))
+			return 0;
 	}
 
 	/* otherwise, it should be pushed into rx fifo */
-- 
2.27.0



