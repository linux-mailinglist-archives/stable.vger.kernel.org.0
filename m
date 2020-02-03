Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 769C1150AD9
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:21:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbgBCQVe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:21:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:33472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727479AbgBCQVb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:21:31 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5879A21582;
        Mon,  3 Feb 2020 16:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580746890;
        bh=wScm5YKGNaarcOFHKq6onNe035vienkBX63O9+T/m2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RGOzOcteBK5Db6se2W8r4Z4pjgT9XAaWb8wGLYJsyOb5U+1Mw5oZrU/TG8X6vOvxk
         jMtcwoDhyl4SLaj4kkvIKgIIYGPwTzFcESifHVGDMGL3f0YghB0Y2OsXAI3ZWqJrAf
         PWLC7Vzr/cGCm9h+qskXjvJENyTq6D776jarcmKA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stan Johnson <userm57@yahoo.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 50/53] net/sonic: Quiesce SONIC before re-initializing descriptor memory
Date:   Mon,  3 Feb 2020 16:19:42 +0000
Message-Id: <20200203161911.659587424@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161902.714326084@linuxfoundation.org>
References: <20200203161902.714326084@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

[ Upstream commit 3f4b7e6a2be982fd8820a2b54d46dd9c351db899 ]

Make sure the SONIC's DMA engine is idle before altering the transmit
and receive descriptors. Add a helper for this as it will be needed
again.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/natsemi/sonic.c | 25 +++++++++++++++++++++++++
 drivers/net/ethernet/natsemi/sonic.h |  3 +++
 2 files changed, 28 insertions(+)

diff --git a/drivers/net/ethernet/natsemi/sonic.c b/drivers/net/ethernet/natsemi/sonic.c
index 21766ec12ef20..712be59251f51 100644
--- a/drivers/net/ethernet/natsemi/sonic.c
+++ b/drivers/net/ethernet/natsemi/sonic.c
@@ -103,6 +103,24 @@ static int sonic_open(struct net_device *dev)
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
@@ -120,6 +138,9 @@ static int sonic_close(struct net_device *dev)
 	/*
 	 * stop the SONIC, disable interrupts
 	 */
+	SONIC_WRITE(SONIC_CMD, SONIC_CR_RXDIS);
+	sonic_quiesce(dev, SONIC_CR_ALL);
+
 	SONIC_WRITE(SONIC_IMR, 0);
 	SONIC_WRITE(SONIC_ISR, 0x7fff);
 	SONIC_WRITE(SONIC_CMD, SONIC_CR_RST);
@@ -159,6 +180,9 @@ static void sonic_tx_timeout(struct net_device *dev)
 	 * put the Sonic into software-reset mode and
 	 * disable all interrupts before releasing DMA buffers
 	 */
+	SONIC_WRITE(SONIC_CMD, SONIC_CR_RXDIS);
+	sonic_quiesce(dev, SONIC_CR_ALL);
+
 	SONIC_WRITE(SONIC_IMR, 0);
 	SONIC_WRITE(SONIC_ISR, 0x7fff);
 	SONIC_WRITE(SONIC_CMD, SONIC_CR_RST);
@@ -638,6 +662,7 @@ static int sonic_init(struct net_device *dev)
 	 */
 	SONIC_WRITE(SONIC_CMD, 0);
 	SONIC_WRITE(SONIC_CMD, SONIC_CR_RXDIS);
+	sonic_quiesce(dev, SONIC_CR_ALL);
 
 	/*
 	 * initialize the receive resource area
diff --git a/drivers/net/ethernet/natsemi/sonic.h b/drivers/net/ethernet/natsemi/sonic.h
index d9f8ceb5353a4..7dcf913d7395a 100644
--- a/drivers/net/ethernet/natsemi/sonic.h
+++ b/drivers/net/ethernet/natsemi/sonic.h
@@ -109,6 +109,9 @@
 #define SONIC_CR_TXP            0x0002
 #define SONIC_CR_HTX            0x0001
 
+#define SONIC_CR_ALL (SONIC_CR_LCAM | SONIC_CR_RRRA | \
+		      SONIC_CR_RXEN | SONIC_CR_TXP)
+
 /*
  * SONIC data configuration bits
  */
-- 
2.20.1



