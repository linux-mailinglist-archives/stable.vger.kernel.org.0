Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3B3D14B8DF
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387478AbgA1O2R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:28:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:56214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387475AbgA1O2R (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:28:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40508207FD;
        Tue, 28 Jan 2020 14:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221695;
        bh=O0yBQ5DYF7rB/yI0dJffhdORoXmFPMV03S1Gh524xXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cR4sty6T8dBG/j3rc1CNSMYE9Bl/jVhEmG+Q0HA9iYINPoHNiXR/mFnk1+wjsZ1sH
         bjg4ikmfLFNZILyJEUFIOCoc+bRNpgFM7DESr5solmqpaNAhtC4bajFXsRoix2hh/p
         d7q1E3d3Nm29NOyHscynU+si+ud4uCmIDGdDjb4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stan Johnson <userm57@yahoo.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 53/92] net/sonic: Fix command register usage
Date:   Tue, 28 Jan 2020 15:08:21 +0100
Message-Id: <20200128135815.971043592@linuxfoundation.org>
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

commit 27e0c31c5f27c1d1a1d9d135c123069f60dcf97b upstream.

There are several issues relating to command register usage during
chip initialization.

Firstly, the SONIC sometimes comes out of software reset with the
Start Timer bit set. This gets logged as,

    macsonic macsonic eth0: sonic_init: status=24, i=101

Avoid this by giving the Stop Timer command earlier than later.

Secondly, the loop that waits for the Read RRA command to complete has
the break condition inverted. That's why the for loop iterates until
its termination condition. Call the helper for this instead.

Finally, give the Receiver Enable command after clearing interrupts,
not before, to avoid the possibility of losing an interrupt.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/natsemi/sonic.c |   18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

--- a/drivers/net/ethernet/natsemi/sonic.c
+++ b/drivers/net/ethernet/natsemi/sonic.c
@@ -663,7 +663,6 @@ static void sonic_multicast_list(struct
  */
 static int sonic_init(struct net_device *dev)
 {
-	unsigned int cmd;
 	struct sonic_local *lp = netdev_priv(dev);
 	int i;
 
@@ -680,7 +679,7 @@ static int sonic_init(struct net_device
 	 * enable interrupts, then completely initialize the SONIC
 	 */
 	SONIC_WRITE(SONIC_CMD, 0);
-	SONIC_WRITE(SONIC_CMD, SONIC_CR_RXDIS);
+	SONIC_WRITE(SONIC_CMD, SONIC_CR_RXDIS | SONIC_CR_STP);
 	sonic_quiesce(dev, SONIC_CR_ALL);
 
 	/*
@@ -710,14 +709,7 @@ static int sonic_init(struct net_device
 	netif_dbg(lp, ifup, dev, "%s: issuing RRRA command\n", __func__);
 
 	SONIC_WRITE(SONIC_CMD, SONIC_CR_RRRA);
-	i = 0;
-	while (i++ < 100) {
-		if (SONIC_READ(SONIC_CMD) & SONIC_CR_RRRA)
-			break;
-	}
-
-	netif_dbg(lp, ifup, dev, "%s: status=%x, i=%d\n", __func__,
-		  SONIC_READ(SONIC_CMD), i);
+	sonic_quiesce(dev, SONIC_CR_RRRA);
 
 	/*
 	 * Initialize the receive descriptors so that they
@@ -805,15 +797,11 @@ static int sonic_init(struct net_device
 	 * enable receiver, disable loopback
 	 * and enable all interrupts
 	 */
-	SONIC_WRITE(SONIC_CMD, SONIC_CR_RXEN | SONIC_CR_STP);
 	SONIC_WRITE(SONIC_RCR, SONIC_RCR_DEFAULT);
 	SONIC_WRITE(SONIC_TCR, SONIC_TCR_DEFAULT);
 	SONIC_WRITE(SONIC_ISR, 0x7fff);
 	SONIC_WRITE(SONIC_IMR, SONIC_IMR_DEFAULT);
-
-	cmd = SONIC_READ(SONIC_CMD);
-	if ((cmd & SONIC_CR_RXEN) == 0 || (cmd & SONIC_CR_STP) == 0)
-		printk(KERN_ERR "sonic_init: failed, status=%x\n", cmd);
+	SONIC_WRITE(SONIC_CMD, SONIC_CR_RXEN);
 
 	netif_dbg(lp, ifup, dev, "%s: new status=%x\n", __func__,
 		  SONIC_READ(SONIC_CMD));


