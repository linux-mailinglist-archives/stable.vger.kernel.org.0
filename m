Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAFB4188096
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729284AbgCQLLb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:11:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:54728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727262AbgCQLLb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:11:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4796B205ED;
        Tue, 17 Mar 2020 11:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443488;
        bh=jKoh/0gWTpU8pqmtazb46og6tWbqPSg17eo+ScGHD0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O+7aKeOXEEThV7okSuNZ4fhYvOir/lY+wQvtQhvnx+qCKDk61Q4jLBjj+1J/my8hA
         um4wIYm/1u/eB1BC1IJP8044hY86O+mnjKydxceRUMc8BreaZ9+7J67LADRuq3djW6
         iQDT6ioxRwtQwM3XheLqW1iTf1qe0mRy8YW3Y3As=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 062/151] net: phy: avoid clearing PHY interrupts twice in irq handler
Date:   Tue, 17 Mar 2020 11:54:32 +0100
Message-Id: <20200317103330.937760725@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103326.593639086@linuxfoundation.org>
References: <20200317103326.593639086@linuxfoundation.org>
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
@@ -702,7 +702,8 @@ static irqreturn_t phy_interrupt(int irq
 		phy_trigger_machine(phydev);
 	}
 
-	if (phy_clear_interrupt(phydev))
+	/* did_interrupt() may have cleared the interrupt already */
+	if (!phydev->drv->did_interrupt && phy_clear_interrupt(phydev))
 		goto phy_err;
 	return IRQ_HANDLED;
 
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -531,6 +531,7 @@ struct phy_driver {
 	/*
 	 * Checks if the PHY generated an interrupt.
 	 * For multi-PHY devices with shared PHY interrupt pin
+	 * Set interrupt bits have to be cleared.
 	 */
 	int (*did_interrupt)(struct phy_device *phydev);
 


