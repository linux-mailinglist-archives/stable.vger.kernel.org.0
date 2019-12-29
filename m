Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB6712C8A5
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733127AbfL2R4t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:56:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:46784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733123AbfL2R4t (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:56:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BF04222C3;
        Sun, 29 Dec 2019 17:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642208;
        bh=c1FQrMMv8I7o3y+VLYP45P+pAFjvh2uqwH/WJErZ/Eo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lzivx37GoMPZxbE83qMDm7WyhL7NbjTleRsm+YdflGjUscCQcEM3KAHystoRcyP7q
         HA5QVrZwl7YqFknwPOQ+l2vdpYXhkqFk41S0oikhgaCxxMwBzWKqKjBhkD/W0irq16
         HRwoNwJIubQGTBMYL1wAiLceQuaE2ftaCkCG0hwI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Nyekjaer <sean@geanix.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 388/434] can: flexcan: add low power enter/exit acknowledgment helper
Date:   Sun, 29 Dec 2019 18:27:21 +0100
Message-Id: <20191229172728.013499830@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joakim Zhang <qiangqing.zhang@nxp.com>

[ Upstream commit b7603d080ffcf8689ec91ca300caf84d8dbed317 ]

The MCR[LPMACK] read-only bit indicates that FlexCAN is in a lower-power
mode (Disabled mode, Doze mode, Stop mode).

The CPU can poll this bit to know when FlexCAN has actually entered low
power mode. The low power enter/exit acknowledgment helper will reduce
code duplication for disabled mode, doze mode and stop mode.

Tested-by: Sean Nyekjaer <sean@geanix.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/flexcan.c | 46 +++++++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 16 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 99b3492ea130..e5c207ad3c77 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -389,6 +389,34 @@ static struct flexcan_mb __iomem *flexcan_get_mb(const struct flexcan_priv *priv
 		(&priv->regs->mb[bank][priv->mb_size * mb_index]);
 }
 
+static int flexcan_low_power_enter_ack(struct flexcan_priv *priv)
+{
+	struct flexcan_regs __iomem *regs = priv->regs;
+	unsigned int timeout = FLEXCAN_TIMEOUT_US / 10;
+
+	while (timeout-- && !(priv->read(&regs->mcr) & FLEXCAN_MCR_LPM_ACK))
+		udelay(10);
+
+	if (!(priv->read(&regs->mcr) & FLEXCAN_MCR_LPM_ACK))
+		return -ETIMEDOUT;
+
+	return 0;
+}
+
+static int flexcan_low_power_exit_ack(struct flexcan_priv *priv)
+{
+	struct flexcan_regs __iomem *regs = priv->regs;
+	unsigned int timeout = FLEXCAN_TIMEOUT_US / 10;
+
+	while (timeout-- && (priv->read(&regs->mcr) & FLEXCAN_MCR_LPM_ACK))
+		udelay(10);
+
+	if (priv->read(&regs->mcr) & FLEXCAN_MCR_LPM_ACK)
+		return -ETIMEDOUT;
+
+	return 0;
+}
+
 static void flexcan_enable_wakeup_irq(struct flexcan_priv *priv, bool enable)
 {
 	struct flexcan_regs __iomem *regs = priv->regs;
@@ -493,39 +521,25 @@ static inline int flexcan_transceiver_disable(const struct flexcan_priv *priv)
 static int flexcan_chip_enable(struct flexcan_priv *priv)
 {
 	struct flexcan_regs __iomem *regs = priv->regs;
-	unsigned int timeout = FLEXCAN_TIMEOUT_US / 10;
 	u32 reg;
 
 	reg = priv->read(&regs->mcr);
 	reg &= ~FLEXCAN_MCR_MDIS;
 	priv->write(reg, &regs->mcr);
 
-	while (timeout-- && (priv->read(&regs->mcr) & FLEXCAN_MCR_LPM_ACK))
-		udelay(10);
-
-	if (priv->read(&regs->mcr) & FLEXCAN_MCR_LPM_ACK)
-		return -ETIMEDOUT;
-
-	return 0;
+	return flexcan_low_power_exit_ack(priv);
 }
 
 static int flexcan_chip_disable(struct flexcan_priv *priv)
 {
 	struct flexcan_regs __iomem *regs = priv->regs;
-	unsigned int timeout = FLEXCAN_TIMEOUT_US / 10;
 	u32 reg;
 
 	reg = priv->read(&regs->mcr);
 	reg |= FLEXCAN_MCR_MDIS;
 	priv->write(reg, &regs->mcr);
 
-	while (timeout-- && !(priv->read(&regs->mcr) & FLEXCAN_MCR_LPM_ACK))
-		udelay(10);
-
-	if (!(priv->read(&regs->mcr) & FLEXCAN_MCR_LPM_ACK))
-		return -ETIMEDOUT;
-
-	return 0;
+	return flexcan_low_power_enter_ack(priv);
 }
 
 static int flexcan_chip_freeze(struct flexcan_priv *priv)
-- 
2.20.1



