Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 800E233BA3B
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235165AbhCOOIh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:08:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:49350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234062AbhCOOCx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:02:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BC3F64EED;
        Mon, 15 Mar 2021 14:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816972;
        bh=IvsItkjW/gMBGmCudavZrmUOENIZH6+DGkeJsg1nkHA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u5/Bq8afxW3xBsgaDunwyYsXD8srkJFrZB1iJP4+BJ0Alr0EsNuMq/upTmyB2YkRD
         JY/SJR/6DyBUbRFyL7fRrtuEo3mYtcQ1A7YwyXBZTBpcPHU3p5lrfuuthUAC8anx0w
         DvgQIcorIBeAKcncs+qSY2d0VexfIhlpvrdq82UI=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sven Schuchmann <schuchmann@schleissheimer.de>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 238/306] net: phy: ti: take into account all possible interrupt sources
Date:   Mon, 15 Mar 2021 14:55:01 +0100
Message-Id: <20210315135515.689176826@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Ioana Ciornei <ioana.ciornei@nxp.com>

[ Upstream commit 73f476aa1975bae6a792b340f5b26ffcfba869a6 ]

The previous implementation of .handle_interrupt() did not take into
account the fact that all the interrupt status registers should be
acknowledged since multiple interrupt sources could be asserted.

Fix this by reading all the status registers before exiting with
IRQ_NONE or triggering the PHY state machine.

Fixes: 1d1ae3c6ca3f ("net: phy: ti: implement generic .handle_interrupt() callback")
Reported-by: Sven Schuchmann <schuchmann@schleissheimer.de>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Link: https://lore.kernel.org/r/20210226153020.867852-1-ciorneiioana@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/dp83822.c   |  9 +++++----
 drivers/net/phy/dp83tc811.c | 11 ++++++-----
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
index fff371ca1086..423952cb9e1c 100644
--- a/drivers/net/phy/dp83822.c
+++ b/drivers/net/phy/dp83822.c
@@ -290,6 +290,7 @@ static int dp83822_config_intr(struct phy_device *phydev)
 
 static irqreturn_t dp83822_handle_interrupt(struct phy_device *phydev)
 {
+	bool trigger_machine = false;
 	int irq_status;
 
 	/* The MISR1 and MISR2 registers are holding the interrupt status in
@@ -305,7 +306,7 @@ static irqreturn_t dp83822_handle_interrupt(struct phy_device *phydev)
 		return IRQ_NONE;
 	}
 	if (irq_status & ((irq_status & GENMASK(7, 0)) << 8))
-		goto trigger_machine;
+		trigger_machine = true;
 
 	irq_status = phy_read(phydev, MII_DP83822_MISR2);
 	if (irq_status < 0) {
@@ -313,11 +314,11 @@ static irqreturn_t dp83822_handle_interrupt(struct phy_device *phydev)
 		return IRQ_NONE;
 	}
 	if (irq_status & ((irq_status & GENMASK(7, 0)) << 8))
-		goto trigger_machine;
+		trigger_machine = true;
 
-	return IRQ_NONE;
+	if (!trigger_machine)
+		return IRQ_NONE;
 
-trigger_machine:
 	phy_trigger_machine(phydev);
 
 	return IRQ_HANDLED;
diff --git a/drivers/net/phy/dp83tc811.c b/drivers/net/phy/dp83tc811.c
index 688fadffb249..7ea32fb77190 100644
--- a/drivers/net/phy/dp83tc811.c
+++ b/drivers/net/phy/dp83tc811.c
@@ -264,6 +264,7 @@ static int dp83811_config_intr(struct phy_device *phydev)
 
 static irqreturn_t dp83811_handle_interrupt(struct phy_device *phydev)
 {
+	bool trigger_machine = false;
 	int irq_status;
 
 	/* The INT_STAT registers 1, 2 and 3 are holding the interrupt status
@@ -279,7 +280,7 @@ static irqreturn_t dp83811_handle_interrupt(struct phy_device *phydev)
 		return IRQ_NONE;
 	}
 	if (irq_status & ((irq_status & GENMASK(7, 0)) << 8))
-		goto trigger_machine;
+		trigger_machine = true;
 
 	irq_status = phy_read(phydev, MII_DP83811_INT_STAT2);
 	if (irq_status < 0) {
@@ -287,7 +288,7 @@ static irqreturn_t dp83811_handle_interrupt(struct phy_device *phydev)
 		return IRQ_NONE;
 	}
 	if (irq_status & ((irq_status & GENMASK(7, 0)) << 8))
-		goto trigger_machine;
+		trigger_machine = true;
 
 	irq_status = phy_read(phydev, MII_DP83811_INT_STAT3);
 	if (irq_status < 0) {
@@ -295,11 +296,11 @@ static irqreturn_t dp83811_handle_interrupt(struct phy_device *phydev)
 		return IRQ_NONE;
 	}
 	if (irq_status & ((irq_status & GENMASK(7, 0)) << 8))
-		goto trigger_machine;
+		trigger_machine = true;
 
-	return IRQ_NONE;
+	if (!trigger_machine)
+		return IRQ_NONE;
 
-trigger_machine:
 	phy_trigger_machine(phydev);
 
 	return IRQ_HANDLED;
-- 
2.30.1



