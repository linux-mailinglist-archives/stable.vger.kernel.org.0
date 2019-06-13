Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C91B643F71
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 17:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388804AbfFMP51 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 11:57:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:38216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731506AbfFMIum (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:50:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C8FD206BA;
        Thu, 13 Jun 2019 08:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415840;
        bh=i9i+5lPjRX58U2ShSlbCwreQPAWVt/6O5ZhwZ9c7GYw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gqNJDlstcczg9DxNmaRPS4TiNZw24Vf41cXngt8XLi1/k8O4xUCBJ0QOVib+CRVri
         3JvCSLtzvvjS1q+AeUBes1ob9Mh2Jg1BkNRSLBohNA9teQgBvRM2oa2AD7ESwHof+a
         ild25F30QhEnZagGVscDwU+E3T7CHi8usMXGQgdk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mark Brown <broonie@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 141/155] dmaengine: idma64: Use actual device for DMA transfers
Date:   Thu, 13 Jun 2019 10:34:13 +0200
Message-Id: <20190613075700.573386416@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
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
index 0baf9797cc09..83796a33dc16 100644
--- a/drivers/dma/idma64.c
+++ b/drivers/dma/idma64.c
@@ -592,7 +592,7 @@ static int idma64_probe(struct idma64_chip *chip)
 	idma64->dma.directions = BIT(DMA_DEV_TO_MEM) | BIT(DMA_MEM_TO_DEV);
 	idma64->dma.residue_granularity = DMA_RESIDUE_GRANULARITY_BURST;
 
-	idma64->dma.dev = chip->dev;
+	idma64->dma.dev = chip->sysdev;
 
 	dma_set_max_seg_size(idma64->dma.dev, IDMA64C_CTLH_BLOCK_TS_MASK);
 
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
index 6b816878e5e7..baa32e1425de 100644
--- a/drivers/dma/idma64.h
+++ b/drivers/dma/idma64.h
@@ -216,12 +216,14 @@ static inline void idma64_writel(struct idma64 *idma64, int offset, u32 value)
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
index d2076f2f468f..a1a63b617ae1 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -1491,12 +1491,7 @@ static int pxa2xx_spi_get_port_id(struct acpi_device *adev)
 
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
 
 #endif /* CONFIG_PCI */
diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
index d31b975dd3fd..284e8d052fc3 100644
--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -365,7 +365,7 @@ static bool dw8250_fallback_dma_filter(struct dma_chan *chan, void *param)
 
 static bool dw8250_idma_filter(struct dma_chan *chan, void *param)
 {
-	return param == chan->device->dev->parent;
+	return param == chan->device->dev;
 }
 
 /*
@@ -434,7 +434,7 @@ static void dw8250_quirks(struct uart_port *p, struct dw8250_data *data)
 		data->uart_16550_compatible = true;
 	}
 
-	/* Platforms with iDMA */
+	/* Platforms with iDMA 64-bit */
 	if (platform_get_resource_byname(to_platform_device(p->dev),
 					 IORESOURCE_MEM, "lpss_priv")) {
 		data->dma.rx_param = p->dev->parent;
-- 
2.20.1



