Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61BC99E15C
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731571AbfH0IAo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:00:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:56010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730430AbfH0IAo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:00:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0DB82186A;
        Tue, 27 Aug 2019 08:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892843;
        bh=no8piTO3xePC6Vh1NhVdjYETxtEoZd0eRE4FrbET4nk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q4j+7gp43uHWcwlzizNOafkpGq+vZUjdtjVUC003HKlXQEOJmPt7NY3UGxXYTF3Zf
         nbTvPPAAW1xPft8V46gWgn3SuDWEXJd/m+4BivHeA8OCid8QRIHFWqX82EQt7Bk07y
         DBn/e3AgzVvFJ/OOBmy2bLll7focQyZGKV7oiOh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Weitao Hou <houweitaoo@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Sean Nyekjaer <sean@geanix.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 033/162] can: mcp251x: add error check when wq alloc failed
Date:   Tue, 27 Aug 2019 09:49:21 +0200
Message-Id: <20190827072739.442241347@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 375f755899b8fc21196197e02aab26257df26e85 ]

add error check when workqueue alloc failed, and remove redundant code
to make it clear.

Fixes: e0000163e30e ("can: Driver for the Microchip MCP251x SPI CAN controllers")
Signed-off-by: Weitao Hou <houweitaoo@gmail.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Tested-by: Sean Nyekjaer <sean@geanix.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/spi/mcp251x.c | 49 ++++++++++++++++-------------------
 1 file changed, 22 insertions(+), 27 deletions(-)

diff --git a/drivers/net/can/spi/mcp251x.c b/drivers/net/can/spi/mcp251x.c
index 44e99e3d71348..2aec934fab0cd 100644
--- a/drivers/net/can/spi/mcp251x.c
+++ b/drivers/net/can/spi/mcp251x.c
@@ -664,17 +664,6 @@ static int mcp251x_power_enable(struct regulator *reg, int enable)
 		return regulator_disable(reg);
 }
 
-static void mcp251x_open_clean(struct net_device *net)
-{
-	struct mcp251x_priv *priv = netdev_priv(net);
-	struct spi_device *spi = priv->spi;
-
-	free_irq(spi->irq, priv);
-	mcp251x_hw_sleep(spi);
-	mcp251x_power_enable(priv->transceiver, 0);
-	close_candev(net);
-}
-
 static int mcp251x_stop(struct net_device *net)
 {
 	struct mcp251x_priv *priv = netdev_priv(net);
@@ -940,37 +929,43 @@ static int mcp251x_open(struct net_device *net)
 				   flags | IRQF_ONESHOT, DEVICE_NAME, priv);
 	if (ret) {
 		dev_err(&spi->dev, "failed to acquire irq %d\n", spi->irq);
-		mcp251x_power_enable(priv->transceiver, 0);
-		close_candev(net);
-		goto open_unlock;
+		goto out_close;
 	}
 
 	priv->wq = alloc_workqueue("mcp251x_wq", WQ_FREEZABLE | WQ_MEM_RECLAIM,
 				   0);
+	if (!priv->wq) {
+		ret = -ENOMEM;
+		goto out_clean;
+	}
 	INIT_WORK(&priv->tx_work, mcp251x_tx_work_handler);
 	INIT_WORK(&priv->restart_work, mcp251x_restart_work_handler);
 
 	ret = mcp251x_hw_reset(spi);
-	if (ret) {
-		mcp251x_open_clean(net);
-		goto open_unlock;
-	}
+	if (ret)
+		goto out_free_wq;
 	ret = mcp251x_setup(net, spi);
-	if (ret) {
-		mcp251x_open_clean(net);
-		goto open_unlock;
-	}
+	if (ret)
+		goto out_free_wq;
 	ret = mcp251x_set_normal_mode(spi);
-	if (ret) {
-		mcp251x_open_clean(net);
-		goto open_unlock;
-	}
+	if (ret)
+		goto out_free_wq;
 
 	can_led_event(net, CAN_LED_EVENT_OPEN);
 
 	netif_wake_queue(net);
+	mutex_unlock(&priv->mcp_lock);
 
-open_unlock:
+	return 0;
+
+out_free_wq:
+	destroy_workqueue(priv->wq);
+out_clean:
+	free_irq(spi->irq, priv);
+	mcp251x_hw_sleep(spi);
+out_close:
+	mcp251x_power_enable(priv->transceiver, 0);
+	close_candev(net);
 	mutex_unlock(&priv->mcp_lock);
 	return ret;
 }
-- 
2.20.1



