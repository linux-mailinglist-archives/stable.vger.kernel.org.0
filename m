Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 123E914B962
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387573AbgA1ObM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:31:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:56158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387459AbgA1O2O (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:28:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C035B20716;
        Tue, 28 Jan 2020 14:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221693;
        bh=EhEWfSDQNUaSQ8Oa938cJt2aXPh7TJsM7rdbWnQ5AGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aUeMnchXx6ikCwlJ3XRXr9e9H9wXPa1PwpdqRB1dvrvQACxw3Jsing/LyadCM69gK
         p/asJ1HuHmoqtIODNkjIeBZLIFET/0jbgcX6JTtrAYaSPpx8R9fq0sfGG/jAgNl0Sc
         cm+xtxdIPmP/qg2fURklT1uFm0PjCyNOVHYyRBZc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stan Johnson <userm57@yahoo.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 52/92] net/sonic: Quiesce SONIC before re-initializing descriptor memory
Date:   Tue, 28 Jan 2020 15:08:20 +0100
Message-Id: <20200128135815.818407182@linuxfoundation.org>
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

commit 3f4b7e6a2be982fd8820a2b54d46dd9c351db899 upstream.

Make sure the SONIC's DMA engine is idle before altering the transmit
and receive descriptors. Add a helper for this as it will be needed
again.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/natsemi/sonic.c |   25 +++++++++++++++++++++++++
 drivers/net/ethernet/natsemi/sonic.h |    3 +++
 2 files changed, 28 insertions(+)

--- a/drivers/net/ethernet/natsemi/sonic.c
+++ b/drivers/net/ethernet/natsemi/sonic.c
@@ -115,6 +115,24 @@ static int sonic_open(struct net_device
 	return 0;
 }
 
+/* Wait for the SONIC to become idle. */
+static void sonic_quiesce(struct net_device *dev, u16 mask)
+{
+	struct sonic_local * __maybe_unused lp = netdev_priv(dev);
+	int i;
+	u16 bits;
+
+	for (i = 0; i < 1000; ++i) {
+		bits = SONIC_READ(SONIC_CMD) & mask;
+		if (!bits)
+			return;
+		if (irqs_disabled() || in_interrupt())
+			udelay(20);
+		else
+			usleep_range(100, 200);
+	}
+	WARN_ONCE(1, "command deadline expired! 0x%04x\n", bits);
+}
 
 /*
  * Close the SONIC device
@@ -131,6 +149,9 @@ static int sonic_close(struct net_device
 	/*
 	 * stop the SONIC, disable interrupts
 	 */
+	SONIC_WRITE(SONIC_CMD, SONIC_CR_RXDIS);
+	sonic_quiesce(dev, SONIC_CR_ALL);
+
 	SONIC_WRITE(SONIC_IMR, 0);
 	SONIC_WRITE(SONIC_ISR, 0x7fff);
 	SONIC_WRITE(SONIC_CMD, SONIC_CR_RST);
@@ -170,6 +191,9 @@ static void sonic_tx_timeout(struct net_
 	 * put the Sonic into software-reset mode and
 	 * disable all interrupts before releasing DMA buffers
 	 */
+	SONIC_WRITE(SONIC_CMD, SONIC_CR_RXDIS);
+	sonic_quiesce(dev, SONIC_CR_ALL);
+
 	SONIC_WRITE(SONIC_IMR, 0);
 	SONIC_WRITE(SONIC_ISR, 0x7fff);
 	SONIC_WRITE(SONIC_CMD, SONIC_CR_RST);
@@ -657,6 +681,7 @@ static int sonic_init(struct net_device
 	 */
 	SONIC_WRITE(SONIC_CMD, 0);
 	SONIC_WRITE(SONIC_CMD, SONIC_CR_RXDIS);
+	sonic_quiesce(dev, SONIC_CR_ALL);
 
 	/*
 	 * initialize the receive resource area
--- a/drivers/net/ethernet/natsemi/sonic.h
+++ b/drivers/net/ethernet/natsemi/sonic.h
@@ -110,6 +110,9 @@
 #define SONIC_CR_TXP            0x0002
 #define SONIC_CR_HTX            0x0001
 
+#define SONIC_CR_ALL (SONIC_CR_LCAM | SONIC_CR_RRRA | \
+		      SONIC_CR_RXEN | SONIC_CR_TXP)
+
 /*
  * SONIC data configuration bits
  */


