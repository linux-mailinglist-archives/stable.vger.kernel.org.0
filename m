Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0280327C7E6
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730777AbgI2L5L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:57:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:41864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729366AbgI2Lna (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:43:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64EA920702;
        Tue, 29 Sep 2020 11:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379809;
        bh=m6VntauJMDSn9rRbPBvIGiZJuUNIY4Q+haPvrNHbwj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gb52GWlTU8ZLysxlIU6nM6WTiGaeU+hA2N/bsAOERm7nvrKcjr7xDqBvGpjXWtJGY
         CB550wszYCpUMn1rLb3RnrM3ZIVWF1K8wN4fObN0fmygaaO55NDeWTFMVwIT/uSG95
         Br39wHzQc918Ta8/SLpp43zvsC62f8xMX6ks7gtQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eddie James <eajames@linux.ibm.com>,
        Tao Ren <rentao.bupt@gmail.com>, Wolfram Sang <wsa@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 328/388] i2c: aspeed: Mask IRQ status to relevant bits
Date:   Tue, 29 Sep 2020 13:00:59 +0200
Message-Id: <20200929110026.340009628@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eddie James <eajames@linux.ibm.com>

[ Upstream commit 1a1d6db23ddacde0b15ea589e9103373e05af8de ]

Mask the IRQ status to only the bits that the driver checks. This
prevents excessive driver warnings when operating in slave mode
when additional bits are set that the driver doesn't handle.

Signed-off-by: Eddie James <eajames@linux.ibm.com>
Reviewed-by: Tao Ren <rentao.bupt@gmail.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-aspeed.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/i2c/busses/i2c-aspeed.c b/drivers/i2c/busses/i2c-aspeed.c
index dad6e432de89f..bdcc3c9d0abe5 100644
--- a/drivers/i2c/busses/i2c-aspeed.c
+++ b/drivers/i2c/busses/i2c-aspeed.c
@@ -69,6 +69,7 @@
  * These share bit definitions, so use the same values for the enable &
  * status bits.
  */
+#define ASPEED_I2CD_INTR_RECV_MASK			0xf000ffff
 #define ASPEED_I2CD_INTR_SDA_DL_TIMEOUT			BIT(14)
 #define ASPEED_I2CD_INTR_BUS_RECOVER_DONE		BIT(13)
 #define ASPEED_I2CD_INTR_SLAVE_MATCH			BIT(7)
@@ -604,6 +605,7 @@ static irqreturn_t aspeed_i2c_bus_irq(int irq, void *dev_id)
 	writel(irq_received & ~ASPEED_I2CD_INTR_RX_DONE,
 	       bus->base + ASPEED_I2C_INTR_STS_REG);
 	readl(bus->base + ASPEED_I2C_INTR_STS_REG);
+	irq_received &= ASPEED_I2CD_INTR_RECV_MASK;
 	irq_remaining = irq_received;
 
 #if IS_ENABLED(CONFIG_I2C_SLAVE)
-- 
2.25.1



