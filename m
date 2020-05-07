Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD3FA1C8F12
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 16:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728475AbgEGO3N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 10:29:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:56552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728466AbgEGO3M (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 10:29:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7929E20A8B;
        Thu,  7 May 2020 14:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588861751;
        bh=mKuQExT/XtGq4HcwCYsGAbbI38P9Ix+FvVyT7xS0ZcU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VszrsqY7GJ0p9HcCzdvI5xI/OIMdMMv6/HWpq/JKxdP9cwBWaSXP8LBlFBtYm9CkK
         O7CQnzna3jH5GaIwCke8Tx2dMLNKe7Z9swKeRUM3Z17r/dt82LK4mwacU++RODkF2I
         MuzMwrH9Nw7S1au6+dr466gzX9LVYjgG77puT5cY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     ryan_chen <ryan_chen@aspeedtech.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <sashal@kernel.org>, linux-i2c@vger.kernel.org,
        openbmc@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.4 32/35] i2c: aspeed: Avoid i2c interrupt status clear race condition.
Date:   Thu,  7 May 2020 10:28:26 -0400
Message-Id: <20200507142830.26239-32-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200507142830.26239-1-sashal@kernel.org>
References: <20200507142830.26239-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: ryan_chen <ryan_chen@aspeedtech.com>

[ Upstream commit c926c87b8e36dcc0ea5c2a0a0227ed4f32d0516a ]

In AST2600 there have a slow peripheral bus between CPU and i2c
controller. Therefore GIC i2c interrupt status clear have delay timing,
when CPU issue write clear i2c controller interrupt status. To avoid
this issue, the driver need have read after write clear at i2c ISR.

Fixes: f327c686d3ba ("i2c: aspeed: added driver for Aspeed I2C")
Signed-off-by: ryan_chen <ryan_chen@aspeedtech.com>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
[wsa: added Fixes tag]
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-aspeed.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-aspeed.c b/drivers/i2c/busses/i2c-aspeed.c
index 7b098ff5f5dd3..dad6e432de89f 100644
--- a/drivers/i2c/busses/i2c-aspeed.c
+++ b/drivers/i2c/busses/i2c-aspeed.c
@@ -603,6 +603,7 @@ static irqreturn_t aspeed_i2c_bus_irq(int irq, void *dev_id)
 	/* Ack all interrupts except for Rx done */
 	writel(irq_received & ~ASPEED_I2CD_INTR_RX_DONE,
 	       bus->base + ASPEED_I2C_INTR_STS_REG);
+	readl(bus->base + ASPEED_I2C_INTR_STS_REG);
 	irq_remaining = irq_received;
 
 #if IS_ENABLED(CONFIG_I2C_SLAVE)
@@ -645,9 +646,11 @@ static irqreturn_t aspeed_i2c_bus_irq(int irq, void *dev_id)
 			irq_received, irq_handled);
 
 	/* Ack Rx done */
-	if (irq_received & ASPEED_I2CD_INTR_RX_DONE)
+	if (irq_received & ASPEED_I2CD_INTR_RX_DONE) {
 		writel(ASPEED_I2CD_INTR_RX_DONE,
 		       bus->base + ASPEED_I2C_INTR_STS_REG);
+		readl(bus->base + ASPEED_I2C_INTR_STS_REG);
+	}
 	spin_unlock(&bus->lock);
 	return irq_remaining ? IRQ_NONE : IRQ_HANDLED;
 }
-- 
2.20.1

