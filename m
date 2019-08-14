Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C65F78DBB3
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728172AbfHNR1K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:27:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:52622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729036AbfHNRDx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:03:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E66321721;
        Wed, 14 Aug 2019 17:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802233;
        bh=7oC41y1/DvvtuaK/R0aXPzmQz9Z45akuQkvn+dDeXj4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cWYytbReroHPVcsn+MvFHhHwST7A/uYDaMO3cOfcf+bkYUlEYwi/S1EleqM9+I65N
         gt5DonQB0aG83BvRT9NMjU5ZsNqjIsiCt2lFbW6OBv6L+aaZFHg5wmRyejvIoU+70b
         66+t8JVPmrNWb529ubu7s+UJVmSQTZdHmi7s9Xfg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: [PATCH 5.2 046/144] can: flexcan: fix stop mode acknowledgment
Date:   Wed, 14 Aug 2019 19:00:02 +0200
Message-Id: <20190814165801.752037420@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165759.466811854@linuxfoundation.org>
References: <20190814165759.466811854@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joakim Zhang <qiangqing.zhang@nxp.com>

commit 5f186c257fa4808bb7f14e643b9fba3e11f08a30 upstream.

To enter stop mode, the CPU should manually assert a global Stop Mode
request and check the acknowledgment asserted by FlexCAN. The CPU must
only consider the FlexCAN in stop mode when both request and
acknowledgment conditions are satisfied.

Fixes: de3578c198c6 ("can: flexcan: add self wakeup support")
Reported-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Cc: linux-stable <stable@vger.kernel.org> # >= v5.0
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/flexcan.c |   31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -400,9 +400,10 @@ static void flexcan_enable_wakeup_irq(st
 	priv->write(reg_mcr, &regs->mcr);
 }
 
-static inline void flexcan_enter_stop_mode(struct flexcan_priv *priv)
+static inline int flexcan_enter_stop_mode(struct flexcan_priv *priv)
 {
 	struct flexcan_regs __iomem *regs = priv->regs;
+	unsigned int ackval;
 	u32 reg_mcr;
 
 	reg_mcr = priv->read(&regs->mcr);
@@ -412,20 +413,37 @@ static inline void flexcan_enter_stop_mo
 	/* enable stop request */
 	regmap_update_bits(priv->stm.gpr, priv->stm.req_gpr,
 			   1 << priv->stm.req_bit, 1 << priv->stm.req_bit);
+
+	/* get stop acknowledgment */
+	if (regmap_read_poll_timeout(priv->stm.gpr, priv->stm.ack_gpr,
+				     ackval, ackval & (1 << priv->stm.ack_bit),
+				     0, FLEXCAN_TIMEOUT_US))
+		return -ETIMEDOUT;
+
+	return 0;
 }
 
-static inline void flexcan_exit_stop_mode(struct flexcan_priv *priv)
+static inline int flexcan_exit_stop_mode(struct flexcan_priv *priv)
 {
 	struct flexcan_regs __iomem *regs = priv->regs;
+	unsigned int ackval;
 	u32 reg_mcr;
 
 	/* remove stop request */
 	regmap_update_bits(priv->stm.gpr, priv->stm.req_gpr,
 			   1 << priv->stm.req_bit, 0);
 
+	/* get stop acknowledgment */
+	if (regmap_read_poll_timeout(priv->stm.gpr, priv->stm.ack_gpr,
+				     ackval, !(ackval & (1 << priv->stm.ack_bit)),
+				     0, FLEXCAN_TIMEOUT_US))
+		return -ETIMEDOUT;
+
 	reg_mcr = priv->read(&regs->mcr);
 	reg_mcr &= ~FLEXCAN_MCR_SLF_WAK;
 	priv->write(reg_mcr, &regs->mcr);
+
+	return 0;
 }
 
 static inline void flexcan_error_irq_enable(const struct flexcan_priv *priv)
@@ -1612,7 +1630,9 @@ static int __maybe_unused flexcan_suspen
 		 */
 		if (device_may_wakeup(device)) {
 			enable_irq_wake(dev->irq);
-			flexcan_enter_stop_mode(priv);
+			err = flexcan_enter_stop_mode(priv);
+			if (err)
+				return err;
 		} else {
 			err = flexcan_chip_disable(priv);
 			if (err)
@@ -1662,10 +1682,13 @@ static int __maybe_unused flexcan_noirq_
 {
 	struct net_device *dev = dev_get_drvdata(device);
 	struct flexcan_priv *priv = netdev_priv(dev);
+	int err;
 
 	if (netif_running(dev) && device_may_wakeup(device)) {
 		flexcan_enable_wakeup_irq(priv, false);
-		flexcan_exit_stop_mode(priv);
+		err = flexcan_exit_stop_mode(priv);
+		if (err)
+			return err;
 	}
 
 	return 0;


