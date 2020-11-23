Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7B52C098A
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388463AbgKWNJA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:09:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:33624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732836AbgKWMsk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:48:40 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58F4220657;
        Mon, 23 Nov 2020 12:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135682;
        bh=PeGGLeZWDd1bXuKd/S9QaIkZt9wKXhUajYTdgQ2IT4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WHQIjx37ZeszOZB+QDDYj4KuH56wHOHurXhbUJZfBIuV8rlgowPgBnlgI7ZiD3TRf
         x5KakmOZVHfuYM/CLOuYrQkgTSYE0vDws+7RHO35sW/GZPT0mlR2zj5vaDoo5GWadn
         CxZcmQ2WoM6/Wkrr3SH6Y/5Ux0vwB3YxgYPTsT5M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 158/252] can: flexcan: flexcan_chip_start(): fix erroneous flexcan_transceiver_enable() during bus-off recovery
Date:   Mon, 23 Nov 2020 13:21:48 +0100
Message-Id: <20201123121843.215496069@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit cd9f13c59461351d7a5fd07924264fb49b287359 ]

If the CAN controller goes into bus off, the do_set_mode() callback with
CAN_MODE_START can be used to recover the controller, which then calls
flexcan_chip_start(). If configured, this is done automatically by the
framework or manually by the user.

In flexcan_chip_start() there is an explicit call to
flexcan_transceiver_enable(), which does a regulator_enable() on the
transceiver regulator. This results in a net usage counter increase, as there
is no corresponding flexcan_transceiver_disable() in the bus off code path.
This further leads to the transceiver stuck enabled, even if the CAN interface
is shut down.

To fix this problem the
flexcan_transceiver_enable()/flexcan_transceiver_disable() are moved out of
flexcan_chip_start()/flexcan_chip_stop() into flexcan_open()/flexcan_close().

Fixes: e955cead0311 ("CAN: Add Flexcan CAN controller driver")
Link: https://lore.kernel.org/r/20201118150148.2664024-1-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/flexcan.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 20a56f389c20c..4cbe8889f546f 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -1229,14 +1229,10 @@ static int flexcan_chip_start(struct net_device *dev)
 		priv->write(reg_mecr, &regs->mecr);
 	}
 
-	err = flexcan_transceiver_enable(priv);
-	if (err)
-		goto out_chip_disable;
-
 	/* synchronize with the can bus */
 	err = flexcan_chip_unfreeze(priv);
 	if (err)
-		goto out_transceiver_disable;
+		goto out_chip_disable;
 
 	priv->can.state = CAN_STATE_ERROR_ACTIVE;
 
@@ -1254,8 +1250,6 @@ static int flexcan_chip_start(struct net_device *dev)
 
 	return 0;
 
- out_transceiver_disable:
-	flexcan_transceiver_disable(priv);
  out_chip_disable:
 	flexcan_chip_disable(priv);
 	return err;
@@ -1285,7 +1279,6 @@ static int __flexcan_chip_stop(struct net_device *dev, bool disable_on_error)
 	priv->write(priv->reg_ctrl_default & ~FLEXCAN_CTRL_ERR_ALL,
 		    &regs->ctrl);
 
-	flexcan_transceiver_disable(priv);
 	priv->can.state = CAN_STATE_STOPPED;
 
 	return 0;
@@ -1321,10 +1314,14 @@ static int flexcan_open(struct net_device *dev)
 	if (err)
 		goto out_runtime_put;
 
-	err = request_irq(dev->irq, flexcan_irq, IRQF_SHARED, dev->name, dev);
+	err = flexcan_transceiver_enable(priv);
 	if (err)
 		goto out_close;
 
+	err = request_irq(dev->irq, flexcan_irq, IRQF_SHARED, dev->name, dev);
+	if (err)
+		goto out_transceiver_disable;
+
 	priv->mb_size = sizeof(struct flexcan_mb) + CAN_MAX_DLEN;
 	priv->mb_count = (sizeof(priv->regs->mb[0]) / priv->mb_size) +
 			 (sizeof(priv->regs->mb[1]) / priv->mb_size);
@@ -1373,6 +1370,8 @@ static int flexcan_open(struct net_device *dev)
 	can_rx_offload_del(&priv->offload);
  out_free_irq:
 	free_irq(dev->irq, dev);
+ out_transceiver_disable:
+	flexcan_transceiver_disable(priv);
  out_close:
 	close_candev(dev);
  out_runtime_put:
@@ -1391,6 +1390,7 @@ static int flexcan_close(struct net_device *dev)
 
 	can_rx_offload_del(&priv->offload);
 	free_irq(dev->irq, dev);
+	flexcan_transceiver_disable(priv);
 
 	close_candev(dev);
 	pm_runtime_put(priv->dev);
-- 
2.27.0



