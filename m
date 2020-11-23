Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE00B2C084C
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:16:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732339AbgKWMr2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:47:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:32818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732815AbgKWMrX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:47:23 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0514720857;
        Mon, 23 Nov 2020 12:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135642;
        bh=GpfMuDe+FIyCB2g+2cyMSG+RPA4VicK44w1raySvIaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l10t7hruIIeOOxZFn8voLFOEiq84Er7peyxdGLrZHqAEiamz9g27e7DzM3RsxRB2o
         FBvmqrTJbegG8u3VGIsCFHAqcLVGf19Ayy9v54Yqy5mFAbIUg91pi2wyiS9qGdY0Al
         GiXlESPmofPkY8z0zYH/SfYv/mK1c6vWshVeGs0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Dan Murphy <dmurphy@ti.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 141/252] can: m_can: Fix freeing of can device from peripherials
Date:   Mon, 23 Nov 2020 13:21:31 +0100
Message-Id: <20201123121842.402937056@linuxfoundation.org>
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

From: Dan Murphy <dmurphy@ti.com>

[ Upstream commit 85816aba460ceebed0047381395615891df68c8f ]

Fix leaking netdev device from peripherial devices. The call to allocate the
netdev device is made from and managed by the peripherial.

Fixes: f524f829b75a ("can: m_can: Create a m_can platform framework")
Reported-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Dan Murphy <dmurphy@ti.com>
Link: http://lore.kernel.org/r/20200227183829.21854-2-dmurphy@ti.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/m_can.c          |  3 ---
 drivers/net/can/m_can/m_can_platform.c | 23 +++++++++++++++--------
 drivers/net/can/m_can/tcan4x5x.c       | 26 ++++++++++++++++++--------
 3 files changed, 33 insertions(+), 19 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index f2c87b76e5692..645101d19989b 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1856,7 +1856,6 @@ pm_runtime_fail:
 	if (ret) {
 		if (m_can_dev->pm_clock_support)
 			pm_runtime_disable(m_can_dev->dev);
-		free_candev(m_can_dev->net);
 	}
 
 	return ret;
@@ -1914,8 +1913,6 @@ void m_can_class_unregister(struct m_can_classdev *m_can_dev)
 	unregister_candev(m_can_dev->net);
 
 	m_can_clk_stop(m_can_dev);
-
-	free_candev(m_can_dev->net);
 }
 EXPORT_SYMBOL_GPL(m_can_class_unregister);
 
diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can/m_can/m_can_platform.c
index e6d0cb9ee02f0..161cb9be018c0 100644
--- a/drivers/net/can/m_can/m_can_platform.c
+++ b/drivers/net/can/m_can/m_can_platform.c
@@ -67,32 +67,36 @@ static int m_can_plat_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
-	if (!priv)
-		return -ENOMEM;
+	if (!priv) {
+		ret = -ENOMEM;
+		goto probe_fail;
+	}
 
 	mcan_class->device_data = priv;
 
-	m_can_class_get_clocks(mcan_class);
+	ret = m_can_class_get_clocks(mcan_class);
+	if (ret)
+		goto probe_fail;
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "m_can");
 	addr = devm_ioremap_resource(&pdev->dev, res);
 	irq = platform_get_irq_byname(pdev, "int0");
 	if (IS_ERR(addr) || irq < 0) {
 		ret = -EINVAL;
-		goto failed_ret;
+		goto probe_fail;
 	}
 
 	/* message ram could be shared */
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "message_ram");
 	if (!res) {
 		ret = -ENODEV;
-		goto failed_ret;
+		goto probe_fail;
 	}
 
 	mram_addr = devm_ioremap(&pdev->dev, res->start, resource_size(res));
 	if (!mram_addr) {
 		ret = -ENOMEM;
-		goto failed_ret;
+		goto probe_fail;
 	}
 
 	priv->base = addr;
@@ -111,9 +115,10 @@ static int m_can_plat_probe(struct platform_device *pdev)
 
 	m_can_init_ram(mcan_class);
 
-	ret = m_can_class_register(mcan_class);
+	return m_can_class_register(mcan_class);
 
-failed_ret:
+probe_fail:
+	m_can_class_free_dev(mcan_class->net);
 	return ret;
 }
 
@@ -134,6 +139,8 @@ static int m_can_plat_remove(struct platform_device *pdev)
 
 	m_can_class_unregister(mcan_class);
 
+	m_can_class_free_dev(mcan_class->net);
+
 	platform_set_drvdata(pdev, NULL);
 
 	return 0;
diff --git a/drivers/net/can/m_can/tcan4x5x.c b/drivers/net/can/m_can/tcan4x5x.c
index 4fdb7121403ab..e5d7d85e0b6d1 100644
--- a/drivers/net/can/m_can/tcan4x5x.c
+++ b/drivers/net/can/m_can/tcan4x5x.c
@@ -440,14 +440,18 @@ static int tcan4x5x_can_probe(struct spi_device *spi)
 		return -ENOMEM;
 
 	priv = devm_kzalloc(&spi->dev, sizeof(*priv), GFP_KERNEL);
-	if (!priv)
-		return -ENOMEM;
+	if (!priv) {
+		ret = -ENOMEM;
+		goto out_m_can_class_free_dev;
+	}
 
 	priv->power = devm_regulator_get_optional(&spi->dev, "vsup");
-	if (PTR_ERR(priv->power) == -EPROBE_DEFER)
-		return -EPROBE_DEFER;
-	else
+	if (PTR_ERR(priv->power) == -EPROBE_DEFER) {
+		ret = -EPROBE_DEFER;
+		goto out_m_can_class_free_dev;
+	} else {
 		priv->power = NULL;
+	}
 
 	mcan_class->device_data = priv;
 
@@ -460,8 +464,10 @@ static int tcan4x5x_can_probe(struct spi_device *spi)
 	}
 
 	/* Sanity check */
-	if (freq < 20000000 || freq > TCAN4X5X_EXT_CLK_DEF)
-		return -ERANGE;
+	if (freq < 20000000 || freq > TCAN4X5X_EXT_CLK_DEF) {
+		ret = -ERANGE;
+		goto out_m_can_class_free_dev;
+	}
 
 	priv->reg_offset = TCAN4X5X_MCAN_OFFSET;
 	priv->mram_start = TCAN4X5X_MRAM_START;
@@ -518,8 +524,10 @@ out_clk:
 		clk_disable_unprepare(mcan_class->cclk);
 		clk_disable_unprepare(mcan_class->hclk);
 	}
-
+ out_m_can_class_free_dev:
+	m_can_class_free_dev(mcan_class->net);
 	dev_err(&spi->dev, "Probe failed, err=%d\n", ret);
+
 	return ret;
 }
 
@@ -531,6 +539,8 @@ static int tcan4x5x_can_remove(struct spi_device *spi)
 
 	tcan4x5x_power_enable(priv->power, 0);
 
+	m_can_class_free_dev(priv->mcan_dev->net);
+
 	return 0;
 }
 
-- 
2.27.0



