Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50EDC14B666
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbgA1OEq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:04:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:52024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727244AbgA1OEn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:04:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC5ED24683;
        Tue, 28 Jan 2020 14:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220282;
        bh=Nvp3bUGtgP1P4W8Mlre5TyRP6RPYKSUv8nTLTNx+zXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ku1QJO0hqIkmwGWY8Bc5xvZUJoA54PWBqZEBBMP0WU6GG0fiV+WPYe7DfAkP3Odkk
         oSx04sDczWZsaqmjek+BP+veiKHfyeTzQuIlpKt6SKrxa2marPgAITT50qEQifjUTW
         Jra7HBSGo+JfEaMs75yYKPbc9SrmB5PcOdMuMYck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stan Johnson <userm57@yahoo.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 090/104] net/sonic: Fix interface error stats collection
Date:   Tue, 28 Jan 2020 15:00:51 +0100
Message-Id: <20200128135829.519792131@linuxfoundation.org>
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

commit 427db97df1ee721c20bdc9a66db8a9e1da719855 upstream.

The tx_aborted_errors statistic should count packets flagged with EXD,
EXC, FU, or BCM bits because those bits denote an aborted transmission.
That corresponds to the bitmask 0x0446, not 0x0642. Use macros for these
constants to avoid mistakes. Better to leave out FIFO Underruns (FU) as
there's a separate counter for that purpose.

Don't lump all these errors in with the general tx_errors counter as
that's used for tx timeout events.

On the rx side, don't count RDE and RBAE interrupts as dropped packets.
These interrupts don't indicate a lost packet, just a lack of resources.
When a lack of resources results in a lost packet, this gets reported
in the rx_missed_errors counter (along with RFO events).

Don't double-count rx_frame_errors and rx_crc_errors.

Don't use the general rx_errors counter for events that already have
special counters.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/natsemi/sonic.c |   21 +++++++--------------
 drivers/net/ethernet/natsemi/sonic.h |    1 +
 2 files changed, 8 insertions(+), 14 deletions(-)

--- a/drivers/net/ethernet/natsemi/sonic.c
+++ b/drivers/net/ethernet/natsemi/sonic.c
@@ -330,18 +330,19 @@ static irqreturn_t sonic_interrupt(int i
 				if ((td_status = sonic_tda_get(dev, entry, SONIC_TD_STATUS)) == 0)
 					break;
 
-				if (td_status & 0x0001) {
+				if (td_status & SONIC_TCR_PTX) {
 					lp->stats.tx_packets++;
 					lp->stats.tx_bytes += sonic_tda_get(dev, entry, SONIC_TD_PKTSIZE);
 				} else {
-					lp->stats.tx_errors++;
-					if (td_status & 0x0642)
+					if (td_status & (SONIC_TCR_EXD |
+					    SONIC_TCR_EXC | SONIC_TCR_BCM))
 						lp->stats.tx_aborted_errors++;
-					if (td_status & 0x0180)
+					if (td_status &
+					    (SONIC_TCR_NCRS | SONIC_TCR_CRLS))
 						lp->stats.tx_carrier_errors++;
-					if (td_status & 0x0020)
+					if (td_status & SONIC_TCR_OWC)
 						lp->stats.tx_window_errors++;
-					if (td_status & 0x0004)
+					if (td_status & SONIC_TCR_FU)
 						lp->stats.tx_fifo_errors++;
 				}
 
@@ -371,17 +372,14 @@ static irqreturn_t sonic_interrupt(int i
 		if (status & SONIC_INT_RFO) {
 			netif_dbg(lp, rx_err, dev, "%s: rx fifo overrun\n",
 				  __func__);
-			lp->stats.rx_fifo_errors++;
 		}
 		if (status & SONIC_INT_RDE) {
 			netif_dbg(lp, rx_err, dev, "%s: rx descriptors exhausted\n",
 				  __func__);
-			lp->stats.rx_dropped++;
 		}
 		if (status & SONIC_INT_RBAE) {
 			netif_dbg(lp, rx_err, dev, "%s: rx buffer area exceeded\n",
 				  __func__);
-			lp->stats.rx_dropped++;
 		}
 
 		/* counter overruns; all counters are 16bit wide */
@@ -473,11 +471,6 @@ static void sonic_rx(struct net_device *
 			sonic_rra_put(dev, entry, SONIC_RR_BUFADR_H, bufadr_h);
 		} else {
 			/* This should only happen, if we enable accepting broken packets. */
-			lp->stats.rx_errors++;
-			if (status & SONIC_RCR_FAER)
-				lp->stats.rx_frame_errors++;
-			if (status & SONIC_RCR_CRCR)
-				lp->stats.rx_crc_errors++;
 		}
 		if (status & SONIC_RCR_LPKT) {
 			/*
--- a/drivers/net/ethernet/natsemi/sonic.h
+++ b/drivers/net/ethernet/natsemi/sonic.h
@@ -175,6 +175,7 @@
 #define SONIC_TCR_NCRS          0x0100
 #define SONIC_TCR_CRLS          0x0080
 #define SONIC_TCR_EXC           0x0040
+#define SONIC_TCR_OWC           0x0020
 #define SONIC_TCR_PMB           0x0008
 #define SONIC_TCR_FU            0x0004
 #define SONIC_TCR_BCM           0x0002


