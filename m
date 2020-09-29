Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8308927C936
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731696AbgI2MIi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:08:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:50310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730221AbgI2Lhf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC84123AA9;
        Tue, 29 Sep 2020 11:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379348;
        bh=LIYKJ8kSKjtFaZbJgWXEshKpbPDdcvP8cxjVf+dMYTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Py76Q83md8y3U8lv1554vnd4BvGH4QMeGMHB+mFGjQb/U9/q3G06OlZThcouzOAOc
         Qc8MVfBwNsZG9lll1FtIFmS5S9bX8RsQl8dgUFnIO4Z/YCCgMRTmsHWEluGwSNiwRp
         hQrsrDS0relN1mA4y3MA+ub2ArEDL2fH11Ql5ZgU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thierry Reding <treding@nvidia.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 092/388] i2c: tegra: Prevent interrupt triggering after transfer timeout
Date:   Tue, 29 Sep 2020 12:57:03 +0200
Message-Id: <20200929110014.933515800@linuxfoundation.org>
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

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit b5d5605ca3cebb9b16c4f251635ef171ad18b80d ]

Potentially it is possible that interrupt may fire after transfer timeout.
That may not end up well for the next transfer because interrupt handling
may race with hardware resetting.

This is very unlikely to happen in practice, but anyway let's prevent the
potential problem by enabling interrupt only at the moments when it is
actually necessary to get some interrupt event.

Tested-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-tegra.c | 70 +++++++++++++++++-----------------
 1 file changed, 36 insertions(+), 34 deletions(-)

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index 331f7cca9babe..5ca72fb0b406c 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -16,6 +16,7 @@
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/iopoll.h>
+#include <linux/irq.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/of_device.h>
@@ -230,7 +231,6 @@ struct tegra_i2c_hw_feature {
  * @base_phys: physical base address of the I2C controller
  * @cont_id: I2C controller ID, used for packet header
  * @irq: IRQ number of transfer complete interrupt
- * @irq_disabled: used to track whether or not the interrupt is enabled
  * @is_dvc: identifies the DVC I2C controller, has a different register layout
  * @msg_complete: transfer completion notifier
  * @msg_err: error code for completed message
@@ -240,7 +240,6 @@ struct tegra_i2c_hw_feature {
  * @bus_clk_rate: current I2C bus clock rate
  * @clk_divisor_non_hs_mode: clock divider for non-high-speed modes
  * @is_multimaster_mode: track if I2C controller is in multi-master mode
- * @xfer_lock: lock to serialize transfer submission and processing
  * @tx_dma_chan: DMA transmit channel
  * @rx_dma_chan: DMA receive channel
  * @dma_phys: handle to DMA resources
@@ -260,7 +259,6 @@ struct tegra_i2c_dev {
 	phys_addr_t base_phys;
 	int cont_id;
 	int irq;
-	bool irq_disabled;
 	int is_dvc;
 	struct completion msg_complete;
 	int msg_err;
@@ -270,8 +268,6 @@ struct tegra_i2c_dev {
 	u32 bus_clk_rate;
 	u16 clk_divisor_non_hs_mode;
 	bool is_multimaster_mode;
-	/* xfer_lock: lock to serialize transfer submission and processing */
-	spinlock_t xfer_lock;
 	struct dma_chan *tx_dma_chan;
 	struct dma_chan *rx_dma_chan;
 	dma_addr_t dma_phys;
@@ -790,11 +786,6 @@ static int tegra_i2c_init(struct tegra_i2c_dev *i2c_dev, bool clk_reinit)
 	if (err)
 		return err;
 
-	if (i2c_dev->irq_disabled) {
-		i2c_dev->irq_disabled = false;
-		enable_irq(i2c_dev->irq);
-	}
-
 	return 0;
 }
 
@@ -825,18 +816,12 @@ static irqreturn_t tegra_i2c_isr(int irq, void *dev_id)
 
 	status = i2c_readl(i2c_dev, I2C_INT_STATUS);
 
-	spin_lock(&i2c_dev->xfer_lock);
 	if (status == 0) {
 		dev_warn(i2c_dev->dev, "irq status 0 %08x %08x %08x\n",
 			 i2c_readl(i2c_dev, I2C_PACKET_TRANSFER_STATUS),
 			 i2c_readl(i2c_dev, I2C_STATUS),
 			 i2c_readl(i2c_dev, I2C_CNFG));
 		i2c_dev->msg_err |= I2C_ERR_UNKNOWN_INTERRUPT;
-
-		if (!i2c_dev->irq_disabled) {
-			disable_irq_nosync(i2c_dev->irq);
-			i2c_dev->irq_disabled = true;
-		}
 		goto err;
 	}
 
@@ -925,7 +910,6 @@ err:
 
 	complete(&i2c_dev->msg_complete);
 done:
-	spin_unlock(&i2c_dev->xfer_lock);
 	return IRQ_HANDLED;
 }
 
@@ -999,6 +983,30 @@ out:
 	i2c_writel(i2c_dev, val, reg);
 }
 
+static unsigned long
+tegra_i2c_wait_completion_timeout(struct tegra_i2c_dev *i2c_dev,
+				  struct completion *complete,
+				  unsigned int timeout_ms)
+{
+	unsigned long ret;
+
+	enable_irq(i2c_dev->irq);
+	ret = wait_for_completion_timeout(complete,
+					  msecs_to_jiffies(timeout_ms));
+	disable_irq(i2c_dev->irq);
+
+	/*
+	 * There is a chance that completion may happen after IRQ
+	 * synchronization, which is done by disable_irq().
+	 */
+	if (ret == 0 && completion_done(complete)) {
+		dev_warn(i2c_dev->dev, "completion done after timeout\n");
+		ret = 1;
+	}
+
+	return ret;
+}
+
 static int tegra_i2c_issue_bus_clear(struct i2c_adapter *adap)
 {
 	struct tegra_i2c_dev *i2c_dev = i2c_get_adapdata(adap);
@@ -1020,8 +1028,8 @@ static int tegra_i2c_issue_bus_clear(struct i2c_adapter *adap)
 	i2c_writel(i2c_dev, reg, I2C_BUS_CLEAR_CNFG);
 	tegra_i2c_unmask_irq(i2c_dev, I2C_INT_BUS_CLR_DONE);
 
-	time_left = wait_for_completion_timeout(&i2c_dev->msg_complete,
-						msecs_to_jiffies(50));
+	time_left = tegra_i2c_wait_completion_timeout(
+			i2c_dev, &i2c_dev->msg_complete, 50);
 	if (time_left == 0) {
 		dev_err(i2c_dev->dev, "timed out for bus clear\n");
 		return -ETIMEDOUT;
@@ -1044,7 +1052,6 @@ static int tegra_i2c_xfer_msg(struct tegra_i2c_dev *i2c_dev,
 	u32 packet_header;
 	u32 int_mask;
 	unsigned long time_left;
-	unsigned long flags;
 	size_t xfer_size;
 	u32 *buffer = NULL;
 	int err = 0;
@@ -1075,7 +1082,6 @@ static int tegra_i2c_xfer_msg(struct tegra_i2c_dev *i2c_dev,
 	 */
 	xfer_time += DIV_ROUND_CLOSEST(((xfer_size * 9) + 2) * MSEC_PER_SEC,
 					i2c_dev->bus_clk_rate);
-	spin_lock_irqsave(&i2c_dev->xfer_lock, flags);
 
 	int_mask = I2C_INT_NO_ACK | I2C_INT_ARBITRATION_LOST;
 	tegra_i2c_unmask_irq(i2c_dev, int_mask);
@@ -1090,7 +1096,7 @@ static int tegra_i2c_xfer_msg(struct tegra_i2c_dev *i2c_dev,
 				dev_err(i2c_dev->dev,
 					"starting RX DMA failed, err %d\n",
 					err);
-				goto unlock;
+				return err;
 			}
 
 		} else {
@@ -1149,7 +1155,7 @@ static int tegra_i2c_xfer_msg(struct tegra_i2c_dev *i2c_dev,
 				dev_err(i2c_dev->dev,
 					"starting TX DMA failed, err %d\n",
 					err);
-				goto unlock;
+				return err;
 			}
 		} else {
 			tegra_i2c_fill_tx_fifo(i2c_dev);
@@ -1169,15 +1175,10 @@ static int tegra_i2c_xfer_msg(struct tegra_i2c_dev *i2c_dev,
 	dev_dbg(i2c_dev->dev, "unmasked irq: %02x\n",
 		i2c_readl(i2c_dev, I2C_INT_MASK));
 
-unlock:
-	spin_unlock_irqrestore(&i2c_dev->xfer_lock, flags);
-
 	if (dma) {
-		if (err)
-			return err;
+		time_left = tegra_i2c_wait_completion_timeout(
+				i2c_dev, &i2c_dev->dma_complete, xfer_time);
 
-		time_left = wait_for_completion_timeout(&i2c_dev->dma_complete,
-							msecs_to_jiffies(xfer_time));
 		if (time_left == 0) {
 			dev_err(i2c_dev->dev, "DMA transfer timeout\n");
 			dmaengine_terminate_sync(i2c_dev->msg_read ?
@@ -1202,13 +1203,13 @@ unlock:
 					      i2c_dev->tx_dma_chan);
 	}
 
-	time_left = wait_for_completion_timeout(&i2c_dev->msg_complete,
-						msecs_to_jiffies(xfer_time));
+	time_left = tegra_i2c_wait_completion_timeout(
+			i2c_dev, &i2c_dev->msg_complete, xfer_time);
+
 	tegra_i2c_mask_irq(i2c_dev, int_mask);
 
 	if (time_left == 0) {
 		dev_err(i2c_dev->dev, "i2c transfer timed out\n");
-
 		tegra_i2c_init(i2c_dev, true);
 		return -ETIMEDOUT;
 	}
@@ -1568,7 +1569,6 @@ static int tegra_i2c_probe(struct platform_device *pdev)
 				I2C_PACKET_HEADER_SIZE;
 	init_completion(&i2c_dev->msg_complete);
 	init_completion(&i2c_dev->dma_complete);
-	spin_lock_init(&i2c_dev->xfer_lock);
 
 	if (!i2c_dev->hw->has_single_clk_source) {
 		fast_clk = devm_clk_get(&pdev->dev, "fast-clk");
@@ -1644,6 +1644,8 @@ static int tegra_i2c_probe(struct platform_device *pdev)
 		goto release_dma;
 	}
 
+	irq_set_status_flags(i2c_dev->irq, IRQ_NOAUTOEN);
+
 	ret = devm_request_irq(&pdev->dev, i2c_dev->irq,
 			       tegra_i2c_isr, 0, dev_name(&pdev->dev), i2c_dev);
 	if (ret) {
-- 
2.25.1



