Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D989D14B931
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387534AbgA1O2h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:28:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:56602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732471AbgA1O2g (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:28:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2451720716;
        Tue, 28 Jan 2020 14:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221715;
        bh=I8/EXmNK99govKJTPSorbWrYylASCcOatF/7L9U+pUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ApLeGOCrllClwceF9CCTdESg2wRJcbsMEE0/6vYWV4B49f6YgQ+598BFl7Pde+2HH
         vSmu4eTVfxjc8tHxqRx2/VX5Ekx1D2jfu/1r7TlZ4UlvwFfcDykMr/SvzDK/JV2Sq8
         hIvo5vYzaGMA7MkJWX1Cu5/Vu/RmjgZ9G++LAN1o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stan Johnson <userm57@yahoo.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 45/92] net/sonic: Clear interrupt flags immediately
Date:   Tue, 28 Jan 2020 15:08:13 +0100
Message-Id: <20200128135814.849884762@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135809.344954797@linuxfoundation.org>
References: <20200128135809.344954797@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

commit 5fedabf5a70be26b19d7520f09f12a62274317c6 upstream.

The chip can change a packet's descriptor status flags at any time.
However, an active interrupt flag gets cleared rather late. This
allows a race condition that could theoretically lose an interrupt.
Fix this by clearing asserted interrupt flags immediately.

Fixes: efcce839360f ("[PATCH] macsonic/jazzsonic network drivers update")
Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/natsemi/sonic.c |   28 ++++++----------------------
 1 file changed, 6 insertions(+), 22 deletions(-)

--- a/drivers/net/ethernet/natsemi/sonic.c
+++ b/drivers/net/ethernet/natsemi/sonic.c
@@ -303,10 +303,11 @@ static irqreturn_t sonic_interrupt(int i
 	}
 
 	do {
+		SONIC_WRITE(SONIC_ISR, status); /* clear the interrupt(s) */
+
 		if (status & SONIC_INT_PKTRX) {
 			netif_dbg(lp, intr, dev, "%s: packet rx\n", __func__);
 			sonic_rx(dev);	/* got packet(s) */
-			SONIC_WRITE(SONIC_ISR, SONIC_INT_PKTRX); /* clear the interrupt */
 		}
 
 		if (status & SONIC_INT_TXDN) {
@@ -361,7 +362,6 @@ static irqreturn_t sonic_interrupt(int i
 			if (freed_some || lp->tx_skb[entry] == NULL)
 				netif_wake_queue(dev);  /* The ring is no longer full */
 			lp->cur_tx = entry;
-			SONIC_WRITE(SONIC_ISR, SONIC_INT_TXDN); /* clear the interrupt */
 		}
 
 		/*
@@ -371,42 +371,31 @@ static irqreturn_t sonic_interrupt(int i
 			netif_dbg(lp, rx_err, dev, "%s: rx fifo overrun\n",
 				  __func__);
 			lp->stats.rx_fifo_errors++;
-			SONIC_WRITE(SONIC_ISR, SONIC_INT_RFO); /* clear the interrupt */
 		}
 		if (status & SONIC_INT_RDE) {
 			netif_dbg(lp, rx_err, dev, "%s: rx descriptors exhausted\n",
 				  __func__);
 			lp->stats.rx_dropped++;
-			SONIC_WRITE(SONIC_ISR, SONIC_INT_RDE); /* clear the interrupt */
 		}
 		if (status & SONIC_INT_RBAE) {
 			netif_dbg(lp, rx_err, dev, "%s: rx buffer area exceeded\n",
 				  __func__);
 			lp->stats.rx_dropped++;
-			SONIC_WRITE(SONIC_ISR, SONIC_INT_RBAE); /* clear the interrupt */
 		}
 
 		/* counter overruns; all counters are 16bit wide */
-		if (status & SONIC_INT_FAE) {
+		if (status & SONIC_INT_FAE)
 			lp->stats.rx_frame_errors += 65536;
-			SONIC_WRITE(SONIC_ISR, SONIC_INT_FAE); /* clear the interrupt */
-		}
-		if (status & SONIC_INT_CRC) {
+		if (status & SONIC_INT_CRC)
 			lp->stats.rx_crc_errors += 65536;
-			SONIC_WRITE(SONIC_ISR, SONIC_INT_CRC); /* clear the interrupt */
-		}
-		if (status & SONIC_INT_MP) {
+		if (status & SONIC_INT_MP)
 			lp->stats.rx_missed_errors += 65536;
-			SONIC_WRITE(SONIC_ISR, SONIC_INT_MP); /* clear the interrupt */
-		}
 
 		/* transmit error */
-		if (status & SONIC_INT_TXER) {
+		if (status & SONIC_INT_TXER)
 			if (SONIC_READ(SONIC_TCR) & SONIC_TCR_FU)
 				netif_dbg(lp, tx_err, dev, "%s: tx fifo underrun\n",
 					  __func__);
-			SONIC_WRITE(SONIC_ISR, SONIC_INT_TXER); /* clear the interrupt */
-		}
 
 		/* bus retry */
 		if (status & SONIC_INT_BR) {
@@ -415,13 +404,8 @@ static irqreturn_t sonic_interrupt(int i
 			/* ... to help debug DMA problems causing endless interrupts. */
 			/* Bounce the eth interface to turn on the interrupt again. */
 			SONIC_WRITE(SONIC_IMR, 0);
-			SONIC_WRITE(SONIC_ISR, SONIC_INT_BR); /* clear the interrupt */
 		}
 
-		/* load CAM done */
-		if (status & SONIC_INT_LCD)
-			SONIC_WRITE(SONIC_ISR, SONIC_INT_LCD); /* clear the interrupt */
-
 		status = SONIC_READ(SONIC_ISR) & SONIC_IMR_DEFAULT;
 	} while (status);
 


