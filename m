Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14C5831D31
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729390AbfFAN1f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:27:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:60008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729971AbfFAN1e (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:27:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55E3C2682F;
        Sat,  1 Jun 2019 13:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395653;
        bh=r/7vLAlkRTjytkbN+7T/W1FSg0HRxAQTCVp6B0goSd8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p30agdJsj5BWsqGhEQF1UidwlB0Qxi4NWZVnV7bNwp3vD4U5M8fn28M8swa5RCfCO
         e39whttQc7mCoc3puxtsMuEcw53gsy/QpjxQn9OQ4lnNfvLyCGdEjaNn2rCHLqOn5J
         xlYpYzaBQ/f7m+PNTztiVDEfRObKMYvXLQTyRb0Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 52/56] dmaengine: idma64: Use actual device for DMA transfers
Date:   Sat,  1 Jun 2019 09:25:56 -0400
Message-Id: <20190601132600.27427-52-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601132600.27427-1-sashal@kernel.org>
References: <20190601132600.27427-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 5ba846b1ee0792f5a596b9b0b86d6e8cdebfab06 ]

Intel IOMMU, when enabled, tries to find the domain of the device,
assuming it's a PCI one, during DMA operations, such as mapping or
unmapping. Since we are splitting the actual PCI device to couple of
children via MFD framework (see drivers/mfd/intel-lpss.c for details),
the DMA device appears to be a platform one, and thus not an actual one
that performs DMA. In a such situation IOMMU can't find or allocate
a proper domain for its operations. As a result, all DMA operations are
failed.

In order to fix this, supply parent of the platform device
to the DMA engine framework and fix filter functions accordingly.

We may rely on the fact that parent is a real PCI device, because no
other configuration is present in the wild.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Mark Brown <broonie@kernel.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org> [for tty parts]
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idma64.c              | 6 ++++--
 drivers/dma/idma64.h              | 2 ++
 drivers/spi/spi-pxa2xx.c          | 7 +------
 drivers/tty/serial/8250/8250_dw.c | 4 ++--
 4 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/dma/idma64.c b/drivers/dma/idma64.c
index 7d56b47e4fcfd..25e25b64bc89d 100644
--- a/drivers/dma/idma64.c
+++ b/drivers/dma/idma64.c
@@ -594,7 +594,7 @@ static int idma64_probe(struct idma64_chip *chip)
 	idma64->dma.directions = BIT(DMA_DEV_TO_MEM) | BIT(DMA_MEM_TO_DEV);
 	idma64->dma.residue_granularity = DMA_RESIDUE_GRANULARITY_BURST;
 
-	idma64->dma.dev = chip->dev;
+	idma64->dma.dev = chip->sysdev;
 
 	ret = dma_async_device_register(&idma64->dma);
 	if (ret)
@@ -632,6 +632,7 @@ static int idma64_platform_probe(struct platform_device *pdev)
 {
 	struct idma64_chip *chip;
 	struct device *dev = &pdev->dev;
+	struct device *sysdev = dev->parent;
 	struct resource *mem;
 	int ret;
 
@@ -648,11 +649,12 @@ static int idma64_platform_probe(struct platform_device *pdev)
 	if (IS_ERR(chip->regs))
 		return PTR_ERR(chip->regs);
 
-	ret = dma_coerce_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	ret = dma_coerce_mask_and_coherent(sysdev, DMA_BIT_MASK(64));
 	if (ret)
 		return ret;
 
 	chip->dev = dev;
+	chip->sysdev = sysdev;
 
 	ret = idma64_probe(chip);
 	if (ret)
diff --git a/drivers/dma/idma64.h b/drivers/dma/idma64.h
index f6aeff0af8a52..e40c69bd1fb52 100644
--- a/drivers/dma/idma64.h
+++ b/drivers/dma/idma64.h
@@ -215,12 +215,14 @@ static inline void idma64_writel(struct idma64 *idma64, int offset, u32 value)
 /**
  * struct idma64_chip - representation of iDMA 64-bit controller hardware
  * @dev:		struct device of the DMA controller
+ * @sysdev:		struct device of the physical device that does DMA
  * @irq:		irq line
  * @regs:		memory mapped I/O space
  * @idma64:		struct idma64 that is filed by idma64_probe()
  */
 struct idma64_chip {
 	struct device	*dev;
+	struct device	*sysdev;
 	int		irq;
 	void __iomem	*regs;
 	struct idma64	*idma64;
diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
index 3cac73e4c3e4a..29c0c135fa6f9 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -1367,12 +1367,7 @@ static const struct pci_device_id pxa2xx_spi_pci_compound_match[] = {
 
 static bool pxa2xx_spi_idma_filter(struct dma_chan *chan, void *param)
 {
-	struct device *dev = param;
-
-	if (dev != chan->device->dev->parent)
-		return false;
-
-	return true;
+	return param == chan->device->dev;
 }
 
 static struct pxa2xx_spi_master *
diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
index a30d68c4b6897..039837db65fcc 100644
--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -258,7 +258,7 @@ static bool dw8250_fallback_dma_filter(struct dma_chan *chan, void *param)
 
 static bool dw8250_idma_filter(struct dma_chan *chan, void *param)
 {
-	return param == chan->device->dev->parent;
+	return param == chan->device->dev;
 }
 
 static void dw8250_quirks(struct uart_port *p, struct dw8250_data *data)
@@ -290,7 +290,7 @@ static void dw8250_quirks(struct uart_port *p, struct dw8250_data *data)
 		data->uart_16550_compatible = true;
 	}
 
-	/* Platforms with iDMA */
+	/* Platforms with iDMA 64-bit */
 	if (platform_get_resource_byname(to_platform_device(p->dev),
 					 IORESOURCE_MEM, "lpss_priv")) {
 		p->set_termios = dw8250_set_termios;
-- 
2.20.1

