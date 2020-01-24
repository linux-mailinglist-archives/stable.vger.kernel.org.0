Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEDB2147BC0
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732436AbgAXJmD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:42:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:39644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730970AbgAXJmC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:42:02 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBBD920718;
        Fri, 24 Jan 2020 09:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858921;
        bh=PVQMQOdwGtcvWT7OyJMk9BAnoc/ujh46Vtd+oTDdsjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EBrxZ8hZyEWt782Mt2fjbEZ8SYyR0cwOA9EeJ55OzdnmiBDqffugi9UJiZKKTO/Ze
         7lWmudqWIW/dfyQx+BbnkfJzLoDlqI14+W01Uf11+EwEs5N2Zz4k00FLRL/fNME+TD
         wC2YyH/pg+pN7BM5wsXSqKu+C2zeRBrmHCD1nvwo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alain Volmat <alain.volmat@st.com>,
        Pierre-Yves MORDRET <pierre-yves.mordret@st.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 080/102] i2c: stm32f7: report dma error during probe
Date:   Fri, 24 Jan 2020 10:31:21 +0100
Message-Id: <20200124092818.734096685@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092806.004582306@linuxfoundation.org>
References: <20200124092806.004582306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alain Volmat <alain.volmat@st.com>

[ Upstream commit d77eceb2de99f5d7e0c645bad15511fe1af59e09 ]

Distinguish between the case where dma information is not provided
within the DT and the case of an error during the dma init.
Exit the probe with error in case of an error during dma init.

Fixes: bb8822cbbc53 ("i2c: i2c-stm32: Add generic DMA API")
Signed-off-by: Alain Volmat <alain.volmat@st.com>
Reviewed-by: Pierre-Yves MORDRET <pierre-yves.mordret@st.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-stm32.c   | 16 ++++++++--------
 drivers/i2c/busses/i2c-stm32f7.c |  9 +++++++++
 2 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/i2c/busses/i2c-stm32.c b/drivers/i2c/busses/i2c-stm32.c
index 07d5dfce68d4c..1da347e6a3586 100644
--- a/drivers/i2c/busses/i2c-stm32.c
+++ b/drivers/i2c/busses/i2c-stm32.c
@@ -20,13 +20,13 @@ struct stm32_i2c_dma *stm32_i2c_dma_request(struct device *dev,
 
 	dma = devm_kzalloc(dev, sizeof(*dma), GFP_KERNEL);
 	if (!dma)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	/* Request and configure I2C TX dma channel */
-	dma->chan_tx = dma_request_slave_channel(dev, "tx");
-	if (!dma->chan_tx) {
+	dma->chan_tx = dma_request_chan(dev, "tx");
+	if (IS_ERR(dma->chan_tx)) {
 		dev_dbg(dev, "can't request DMA tx channel\n");
-		ret = -EINVAL;
+		ret = PTR_ERR(dma->chan_tx);
 		goto fail_al;
 	}
 
@@ -42,10 +42,10 @@ struct stm32_i2c_dma *stm32_i2c_dma_request(struct device *dev,
 	}
 
 	/* Request and configure I2C RX dma channel */
-	dma->chan_rx = dma_request_slave_channel(dev, "rx");
-	if (!dma->chan_rx) {
+	dma->chan_rx = dma_request_chan(dev, "rx");
+	if (IS_ERR(dma->chan_rx)) {
 		dev_err(dev, "can't request DMA rx channel\n");
-		ret = -EINVAL;
+		ret = PTR_ERR(dma->chan_rx);
 		goto fail_tx;
 	}
 
@@ -75,7 +75,7 @@ fail_al:
 	devm_kfree(dev, dma);
 	dev_info(dev, "can't use DMA\n");
 
-	return NULL;
+	return ERR_PTR(ret);
 }
 
 void stm32_i2c_dma_free(struct stm32_i2c_dma *dma)
diff --git a/drivers/i2c/busses/i2c-stm32f7.c b/drivers/i2c/busses/i2c-stm32f7.c
index b88fc9d79287b..b2634afe066d3 100644
--- a/drivers/i2c/busses/i2c-stm32f7.c
+++ b/drivers/i2c/busses/i2c-stm32f7.c
@@ -1955,6 +1955,15 @@ static int stm32f7_i2c_probe(struct platform_device *pdev)
 	i2c_dev->dma = stm32_i2c_dma_request(i2c_dev->dev, phy_addr,
 					     STM32F7_I2C_TXDR,
 					     STM32F7_I2C_RXDR);
+	if (PTR_ERR(i2c_dev->dma) == -ENODEV)
+		i2c_dev->dma = NULL;
+	else if (IS_ERR(i2c_dev->dma)) {
+		ret = PTR_ERR(i2c_dev->dma);
+		if (ret != -EPROBE_DEFER)
+			dev_err(&pdev->dev,
+				"Failed to request dma error %i\n", ret);
+		goto clk_free;
+	}
 
 	platform_set_drvdata(pdev, i2c_dev);
 
-- 
2.20.1



