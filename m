Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87FA84D5CE
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727193AbfFTSBP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:01:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:50646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbfFTSBP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:01:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DDA8208CA;
        Thu, 20 Jun 2019 18:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561053673;
        bh=fi14v7tY+Dj4HzGpzONsHg+GQLBzTS2h/TjDT3U62m4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=arZHjE9xBAz1qSrGyiO01hXDRCdstccaHRUBvnj7cTvJj2QqDrCQeHkJLnbb0SYPg
         j7F2o1DlSvBwfbg3ZEsiIHYbTYiv+z+XJCCc3rdy28CaLy0lAcbHL05v3An0j5BVc2
         22Et5HlNn690055SKHxEj7S+o/7YXq9iiYifEEPQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mark Brown <broonie@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 33/84] dmaengine: idma64: Use actual device for DMA transfers
Date:   Thu, 20 Jun 2019 19:56:30 +0200
Message-Id: <20190620174343.057167055@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174337.538228162@linuxfoundation.org>
References: <20190620174337.538228162@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 7d56b47e4fcf..25e25b64bc89 100644
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
index f6aeff0af8a5..e40c69bd1fb5 100644
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
index e87b6fc9f4c6..193aa3da5033 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -1371,12 +1371,7 @@ static const struct pci_device_id pxa2xx_spi_pci_compound_match[] = {
 
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
index a30d68c4b689..039837db65fc 100644
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



