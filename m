Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69682188174
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728014AbgCQLCu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:02:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:42656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728010AbgCQLCu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:02:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C807620735;
        Tue, 17 Mar 2020 11:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584442969;
        bh=aV1Z3DLMqttPDw4STbAY8xwYfR9ZcIogrCRPvIl+k6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1uKAyfAJWY4V8oCtSIzYCA+MNUnAr3e8pDvljiFbD5XTHeGw0qK+tEMMVuldU+kQt
         v9H5TJgxjgR4ZSquVtVzJ906wyDOn8Q/3SIDrN6C1QUcWdhhsBXXFrdwrpSr5ZcZP3
         89GULzp2fI2yg9GJDvYbgwWr0hGV20tabkqwPNic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 051/123] net: phy: avoid clearing PHY interrupts twice in irq handler
Date:   Tue, 17 Mar 2020 11:54:38 +0100
Message-Id: <20200317103312.932195839@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103307.343627747@linuxfoundation.org>
References: <20200317103307.343627747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 249bc9744e165abe74ae326f43e9d70bad54c3b7 ]

On all PHY drivers that implement did_interrupt() reading the interrupt
status bits clears them. This means we may loose an interrupt that
is triggered between calling did_interrupt() and phy_clear_interrupt().
As part of the fix make it a requirement that did_interrupt() clears
the interrupt.

The Fixes tag refers to the first commit where the patch applies
cleanly.

Fixes: 49644e68f472 ("net: phy: add callback for custom interrupt handler to struct phy_driver")
Reported-by: Michael Walle <michael@walle.cc>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/phy.c |    3 ++-
 include/linux/phy.h   |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -761,7 +761,8 @@ static irqreturn_t phy_interrupt(int irq
 		phy_trigger_machine(phydev);
 	}
 
-	if (phy_clear_interrupt(phydev))
+	/* did_interrupt() may have cleared the interrupt already */
+	if (!phydev->drv->did_interrupt && phy_clear_interrupt(phydev))
 		goto phy_err;
 	return IRQ_HANDLED;
 
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -524,6 +524,7 @@ struct phy_driver {
 	/*
 	 * Checks if the PHY generated an interrupt.
 	 * For multi-PHY devices with shared PHY interrupt pin
+	 * Set interrupt bits have to be cleared.
 	 */
 	int (*did_interrupt)(struct phy_device *phydev);
 


