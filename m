Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB203835D1
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239691AbhEQPZ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:25:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:40630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244842AbhEQPWK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:22:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5969461C99;
        Mon, 17 May 2021 14:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262091;
        bh=GA5rW2YBXHrEsnKe09LXzWQNnw5qsL3A30/m4epHsIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1PdDHCeWYD88nhwrfuJjkKR3o0DQ1GRCkyAQA9UGJucSbsuKjW2DLt4L2E/tfRCEv
         AjgZLxlaxyNguPGZMpX8rKmExbXs5BmHb8D61fed7EAKrd17JlpKFMILxl9sJugDdo
         X8nnXWkvnPfnsBcdU9B4+1M+F0W4o3GAaoBEXYSM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 214/329] can: mcp251x: fix resume from sleep before interface was brought up
Date:   Mon, 17 May 2021 16:02:05 +0200
Message-Id: <20210517140309.371299309@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frieder Schrempf <frieder.schrempf@kontron.de>

[ Upstream commit 03c427147b2d3e503af258711af4fc792b89b0af ]

Since 8ce8c0abcba3 the driver queues work via priv->restart_work when
resuming after suspend, even when the interface was not previously
enabled. This causes a null dereference error as the workqueue is only
allocated and initialized in mcp251x_open().

To fix this we move the workqueue init to mcp251x_can_probe() as there
is no reason to do it later and repeat it whenever mcp251x_open() is
called.

Fixes: 8ce8c0abcba3 ("can: mcp251x: only reset hardware as required")
Link: https://lore.kernel.org/r/17d5d714-b468-482f-f37a-482e3d6df84e@kontron.de
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
[mkl: fix error handling in mcp251x_stop()]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/spi/mcp251x.c | 35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/net/can/spi/mcp251x.c b/drivers/net/can/spi/mcp251x.c
index e7be36dc2159..24ae221c2f10 100644
--- a/drivers/net/can/spi/mcp251x.c
+++ b/drivers/net/can/spi/mcp251x.c
@@ -956,8 +956,6 @@ static int mcp251x_stop(struct net_device *net)
 
 	priv->force_quit = 1;
 	free_irq(spi->irq, priv);
-	destroy_workqueue(priv->wq);
-	priv->wq = NULL;
 
 	mutex_lock(&priv->mcp_lock);
 
@@ -1224,24 +1222,15 @@ static int mcp251x_open(struct net_device *net)
 		goto out_close;
 	}
 
-	priv->wq = alloc_workqueue("mcp251x_wq", WQ_FREEZABLE | WQ_MEM_RECLAIM,
-				   0);
-	if (!priv->wq) {
-		ret = -ENOMEM;
-		goto out_clean;
-	}
-	INIT_WORK(&priv->tx_work, mcp251x_tx_work_handler);
-	INIT_WORK(&priv->restart_work, mcp251x_restart_work_handler);
-
 	ret = mcp251x_hw_wake(spi);
 	if (ret)
-		goto out_free_wq;
+		goto out_free_irq;
 	ret = mcp251x_setup(net, spi);
 	if (ret)
-		goto out_free_wq;
+		goto out_free_irq;
 	ret = mcp251x_set_normal_mode(spi);
 	if (ret)
-		goto out_free_wq;
+		goto out_free_irq;
 
 	can_led_event(net, CAN_LED_EVENT_OPEN);
 
@@ -1250,9 +1239,7 @@ static int mcp251x_open(struct net_device *net)
 
 	return 0;
 
-out_free_wq:
-	destroy_workqueue(priv->wq);
-out_clean:
+out_free_irq:
 	free_irq(spi->irq, priv);
 	mcp251x_hw_sleep(spi);
 out_close:
@@ -1373,6 +1360,15 @@ static int mcp251x_can_probe(struct spi_device *spi)
 	if (ret)
 		goto out_clk;
 
+	priv->wq = alloc_workqueue("mcp251x_wq", WQ_FREEZABLE | WQ_MEM_RECLAIM,
+				   0);
+	if (!priv->wq) {
+		ret = -ENOMEM;
+		goto out_clk;
+	}
+	INIT_WORK(&priv->tx_work, mcp251x_tx_work_handler);
+	INIT_WORK(&priv->restart_work, mcp251x_restart_work_handler);
+
 	priv->spi = spi;
 	mutex_init(&priv->mcp_lock);
 
@@ -1417,6 +1413,8 @@ static int mcp251x_can_probe(struct spi_device *spi)
 	return 0;
 
 error_probe:
+	destroy_workqueue(priv->wq);
+	priv->wq = NULL;
 	mcp251x_power_enable(priv->power, 0);
 
 out_clk:
@@ -1438,6 +1436,9 @@ static int mcp251x_can_remove(struct spi_device *spi)
 
 	mcp251x_power_enable(priv->power, 0);
 
+	destroy_workqueue(priv->wq);
+	priv->wq = NULL;
+
 	clk_disable_unprepare(priv->clk);
 
 	free_candev(net);
-- 
2.30.2



