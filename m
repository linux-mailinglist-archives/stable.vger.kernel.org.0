Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 840C814B68B
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:06:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728212AbgA1OFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:05:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:52526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727256AbgA1OFF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:05:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B37A205F4;
        Tue, 28 Jan 2020 14:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220304;
        bh=bucInDruqaGQKC1x8FrO5m2lqx7YtfBmjnFP0D1ziuI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SG3zzIiub4DYTYK1lcH+f2QWC6NoLuVxEzE9GXjvFQvBN05RYzqTMPd8Jsdhoizli
         hzvXPJAwlE88T4qCb8THd2ME9ixEcei+q/LgJ24wA3F+ag/lsd2C3mFt0V/AuL2XBa
         9jl3qYVJusSPIm0UHqMXHQ6pv78pX682xjK6YBgY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stan Johnson <userm57@yahoo.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 098/104] net/sonic: Prevent tx watchdog timeout
Date:   Tue, 28 Jan 2020 15:00:59 +0100
Message-Id: <20200128135830.489263558@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135817.238524998@linuxfoundation.org>
References: <20200128135817.238524998@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

commit 686f85d71d095f1d26b807e23b0f0bfd22042c45 upstream.

Section 5.5.3.2 of the datasheet says,

    If FIFO Underrun, Byte Count Mismatch, Excessive Collision, or
    Excessive Deferral (if enabled) errors occur, transmission ceases.

In this situation, the chip asserts a TXER interrupt rather than TXDN.
But the handler for the TXDN is the only way that the transmit queue
gets restarted. Hence, an aborted transmission can result in a watchdog
timeout.

This problem can be reproduced on congested link, as that can result in
excessive transmitter collisions. Another way to reproduce this is with
a FIFO Underrun, which may be caused by DMA latency.

In event of a TXER interrupt, prevent a watchdog timeout by restarting
transmission.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/natsemi/sonic.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/natsemi/sonic.c
+++ b/drivers/net/ethernet/natsemi/sonic.c
@@ -415,10 +415,19 @@ static irqreturn_t sonic_interrupt(int i
 			lp->stats.rx_missed_errors += 65536;
 
 		/* transmit error */
-		if (status & SONIC_INT_TXER)
-			if (SONIC_READ(SONIC_TCR) & SONIC_TCR_FU)
-				netif_dbg(lp, tx_err, dev, "%s: tx fifo underrun\n",
-					  __func__);
+		if (status & SONIC_INT_TXER) {
+			u16 tcr = SONIC_READ(SONIC_TCR);
+
+			netif_dbg(lp, tx_err, dev, "%s: TXER intr, TCR %04x\n",
+				  __func__, tcr);
+
+			if (tcr & (SONIC_TCR_EXD | SONIC_TCR_EXC |
+				   SONIC_TCR_FU | SONIC_TCR_BCM)) {
+				/* Aborted transmission. Try again. */
+				netif_stop_queue(dev);
+				SONIC_WRITE(SONIC_CMD, SONIC_CR_TXP);
+			}
+		}
 
 		/* bus retry */
 		if (status & SONIC_INT_BR) {


