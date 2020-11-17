Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B38E2B62D8
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:32:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732283AbgKQNcZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:32:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:42186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732281AbgKQNcY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:32:24 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1055921534;
        Tue, 17 Nov 2020 13:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619944;
        bh=dkRwpKXwy2eTlaHkL6Jm41ZcWLDhLrIkd73ToWLlGhQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wzpvcE8tB2uC5oD6MOrbro/sEl9Gx16K1cwbWDuz1ytxgOPxJgtkKuBiaPlGUyu3i
         dgDIcR7fK59Mv3JwqPsKy3ewdYYCJJy/VRuNAx4N+QfwNOxZTf4HVhMFgQeWVFGEdP
         FfZo2d5+govJ0BQHwc8bAkAWUvQTc4NFzZmJ4xlM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 055/255] can: peak_canfd: pucan_handle_can_rx(): fix echo management when loopback is on
Date:   Tue, 17 Nov 2020 14:03:15 +0100
Message-Id: <20201117122141.631471433@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
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
index 10aa3e457c33d..40c33b8a5fda3 100644
--- a/drivers/net/can/peak_canfd/peak_canfd.c
+++ b/drivers/net/can/peak_canfd/peak_canfd.c
@@ -262,8 +262,7 @@ static int pucan_handle_can_rx(struct peak_canfd_priv *priv,
 		cf_len = get_can_dlc(pucan_msg_get_dlc(msg));
 
 	/* if this frame is an echo, */
-	if ((rx_msg_flags & PUCAN_MSG_LOOPED_BACK) &&
-	    !(rx_msg_flags & PUCAN_MSG_SELF_RECEIVE)) {
+	if (rx_msg_flags & PUCAN_MSG_LOOPED_BACK) {
 		unsigned long flags;
 
 		spin_lock_irqsave(&priv->echo_lock, flags);
@@ -277,7 +276,13 @@ static int pucan_handle_can_rx(struct peak_canfd_priv *priv,
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



