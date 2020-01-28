Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 159F214B93C
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:33:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733304AbgA1O3Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:29:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:57834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387474AbgA1O3Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:29:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAB4824688;
        Tue, 28 Jan 2020 14:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221763;
        bh=bQ/AA0JQydPMYBGepLSJ5xP31TfC9NHGuv1NYNG3yfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ka4iYbJjpMasn3xzwmmZgkDHu+BytNMtKyoD9+/2sjDIUWAm0yzb4S9R30+QnDawn
         MX1KpTat8xs2uTG+LKFBThKkHMPI0kdolzPSWXgPlErJf8XO2xnpgQhYV67X+93Wpy
         0T5aRG/v+kqGsxKuhw5lB6fqgYiwo+VFldpm78Fw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stan Johnson <userm57@yahoo.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 54/92] net/sonic: Fix CAM initialization
Date:   Tue, 28 Jan 2020 15:08:22 +0100
Message-Id: <20200128135816.119647041@linuxfoundation.org>
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

commit 772f66421d5aa0b9f256056f513bbc38ac132271 upstream.

Section 4.3.1 of the datasheet says,

    This bit [TXP] must not be set if a Load CAM operation is in
    progress (LCAM is set). The SONIC will lock up if both bits are
    set simultaneously.

Testing has shown that the driver sometimes attempts to set LCAM
while TXP is set. Avoid this by waiting for command completion
before and after giving the LCAM command.

After issuing the Load CAM command, poll for !SONIC_CR_LCAM rather than
SONIC_INT_LCD, because the SONIC_CR_TXP bit can't be used until
!SONIC_CR_LCAM.

When in reset mode, take the opportunity to reset the CAM Enable
register.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/natsemi/sonic.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

--- a/drivers/net/ethernet/natsemi/sonic.c
+++ b/drivers/net/ethernet/natsemi/sonic.c
@@ -633,6 +633,8 @@ static void sonic_multicast_list(struct
 		    (netdev_mc_count(dev) > 15)) {
 			rcr |= SONIC_RCR_AMC;
 		} else {
+			unsigned long flags;
+
 			netif_dbg(lp, ifup, dev, "%s: mc_count %d\n", __func__,
 				  netdev_mc_count(dev));
 			sonic_set_cam_enable(dev, 1);  /* always enable our own address */
@@ -646,9 +648,14 @@ static void sonic_multicast_list(struct
 				i++;
 			}
 			SONIC_WRITE(SONIC_CDC, 16);
-			/* issue Load CAM command */
 			SONIC_WRITE(SONIC_CDP, lp->cda_laddr & 0xffff);
+
+			/* LCAM and TXP commands can't be used simultaneously */
+			spin_lock_irqsave(&lp->lock, flags);
+			sonic_quiesce(dev, SONIC_CR_TXP);
 			SONIC_WRITE(SONIC_CMD, SONIC_CR_LCAM);
+			sonic_quiesce(dev, SONIC_CR_LCAM);
+			spin_unlock_irqrestore(&lp->lock, flags);
 		}
 	}
 
@@ -674,6 +681,9 @@ static int sonic_init(struct net_device
 	SONIC_WRITE(SONIC_ISR, 0x7fff);
 	SONIC_WRITE(SONIC_CMD, SONIC_CR_RST);
 
+	/* While in reset mode, clear CAM Enable register */
+	SONIC_WRITE(SONIC_CE, 0);
+
 	/*
 	 * clear software reset flag, disable receiver, clear and
 	 * enable interrupts, then completely initialize the SONIC
@@ -784,14 +794,7 @@ static int sonic_init(struct net_device
 	 * load the CAM
 	 */
 	SONIC_WRITE(SONIC_CMD, SONIC_CR_LCAM);
-
-	i = 0;
-	while (i++ < 100) {
-		if (SONIC_READ(SONIC_ISR) & SONIC_INT_LCD)
-			break;
-	}
-	netif_dbg(lp, ifup, dev, "%s: CMD=%x, ISR=%x, i=%d\n", __func__,
-		  SONIC_READ(SONIC_CMD), SONIC_READ(SONIC_ISR), i);
+	sonic_quiesce(dev, SONIC_CR_LCAM);
 
 	/*
 	 * enable receiver, disable loopback


