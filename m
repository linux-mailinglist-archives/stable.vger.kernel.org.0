Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EEC42B61F3
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730915AbgKQNX4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:23:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:58720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730959AbgKQNXx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:23:53 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 276AA2464E;
        Tue, 17 Nov 2020 13:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619432;
        bh=fppZ3tL3kEZcMIYm3/kY3tHzuFwwlhI5gKSb5OuU9fA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Su8uxiOkZYH554eYNVc6D6kISXaEyJKHkavY/rULpOg75IQBmen89Ef5qr34UZ46D
         YKOfv/2kB0TYB5z23+52Y1yKp3LETTaW+GQxx3AaO37ticLsPkxDO62OfzdYeOudp3
         DzRyHAIDSoBqrJz4jJUxR99asdr+dsRQmXAvy+5U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 036/151] can: peak_canfd: pucan_handle_can_rx(): fix echo management when loopback is on
Date:   Tue, 17 Nov 2020 14:04:26 +0100
Message-Id: <20201117122123.182892792@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
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
index 6b0c6a99fc8d6..91b156b2123a3 100644
--- a/drivers/net/can/peak_canfd/peak_canfd.c
+++ b/drivers/net/can/peak_canfd/peak_canfd.c
@@ -248,8 +248,7 @@ static int pucan_handle_can_rx(struct peak_canfd_priv *priv,
 		cf_len = get_can_dlc(pucan_msg_get_dlc(msg));
 
 	/* if this frame is an echo, */
-	if ((rx_msg_flags & PUCAN_MSG_LOOPED_BACK) &&
-	    !(rx_msg_flags & PUCAN_MSG_SELF_RECEIVE)) {
+	if (rx_msg_flags & PUCAN_MSG_LOOPED_BACK) {
 		unsigned long flags;
 
 		spin_lock_irqsave(&priv->echo_lock, flags);
@@ -263,7 +262,13 @@ static int pucan_handle_can_rx(struct peak_canfd_priv *priv,
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



