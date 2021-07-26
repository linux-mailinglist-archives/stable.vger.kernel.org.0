Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4EF3D6209
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234941AbhGZPeC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:34:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:49582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233477AbhGZPcz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:32:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79A8F60F5D;
        Mon, 26 Jul 2021 16:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627316004;
        bh=SxQffA4RCMBq+iFwtYtOSme/ywGd6w1uoHDyzguM2BM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SJ9PT+q2i2Wn+aRl6aZBITkY5JiiKtKeLyMGgwRxKRCbKM1R6h5+/0kWSY82ZhD1U
         aIL3tfujb+Bx21LolZRzcLFrrS3c7hCA/n49W1zcXoA63VT3S3ivzg5XjXOJTO/tf/
         uO1oW/BzCxbp6STksEdlg8KdFiJC19eUAfGL/9kA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 115/223] spi: spi-bcm2835: Fix deadlock
Date:   Mon, 26 Jul 2021 17:38:27 +0200
Message-Id: <20210726153850.035394678@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandru Tachici <alexandru.tachici@analog.com>

[ Upstream commit c45c1e82bba130db4f19d9dbc1deefcf4ea994ed ]

The bcm2835_spi_transfer_one function can create a deadlock
if it is called while another thread already has the
CCF lock.

Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
Fixes: f8043872e796 ("spi: add driver for BCM2835")
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20210716210245.13240-2-alexandru.tachici@analog.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm2835.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/spi/spi-bcm2835.c b/drivers/spi/spi-bcm2835.c
index fe40626e45aa..61cbcc7e2121 100644
--- a/drivers/spi/spi-bcm2835.c
+++ b/drivers/spi/spi-bcm2835.c
@@ -84,6 +84,7 @@ MODULE_PARM_DESC(polling_limit_us,
  * struct bcm2835_spi - BCM2835 SPI controller
  * @regs: base address of register map
  * @clk: core clock, divided to calculate serial clock
+ * @clk_hz: core clock cached speed
  * @irq: interrupt, signals TX FIFO empty or RX FIFO ¾ full
  * @tfr: SPI transfer currently processed
  * @ctlr: SPI controller reverse lookup
@@ -124,6 +125,7 @@ MODULE_PARM_DESC(polling_limit_us,
 struct bcm2835_spi {
 	void __iomem *regs;
 	struct clk *clk;
+	unsigned long clk_hz;
 	int irq;
 	struct spi_transfer *tfr;
 	struct spi_controller *ctlr;
@@ -1082,19 +1084,18 @@ static int bcm2835_spi_transfer_one(struct spi_controller *ctlr,
 				    struct spi_transfer *tfr)
 {
 	struct bcm2835_spi *bs = spi_controller_get_devdata(ctlr);
-	unsigned long spi_hz, clk_hz, cdiv;
+	unsigned long spi_hz, cdiv;
 	unsigned long hz_per_byte, byte_limit;
 	u32 cs = bs->prepare_cs[spi->chip_select];
 
 	/* set clock */
 	spi_hz = tfr->speed_hz;
-	clk_hz = clk_get_rate(bs->clk);
 
-	if (spi_hz >= clk_hz / 2) {
+	if (spi_hz >= bs->clk_hz / 2) {
 		cdiv = 2; /* clk_hz/2 is the fastest we can go */
 	} else if (spi_hz) {
 		/* CDIV must be a multiple of two */
-		cdiv = DIV_ROUND_UP(clk_hz, spi_hz);
+		cdiv = DIV_ROUND_UP(bs->clk_hz, spi_hz);
 		cdiv += (cdiv % 2);
 
 		if (cdiv >= 65536)
@@ -1102,7 +1103,7 @@ static int bcm2835_spi_transfer_one(struct spi_controller *ctlr,
 	} else {
 		cdiv = 0; /* 0 is the slowest we can go */
 	}
-	tfr->effective_speed_hz = cdiv ? (clk_hz / cdiv) : (clk_hz / 65536);
+	tfr->effective_speed_hz = cdiv ? (bs->clk_hz / cdiv) : (bs->clk_hz / 65536);
 	bcm2835_wr(bs, BCM2835_SPI_CLK, cdiv);
 
 	/* handle all the 3-wire mode */
@@ -1320,6 +1321,7 @@ static int bcm2835_spi_probe(struct platform_device *pdev)
 		return bs->irq ? bs->irq : -ENODEV;
 
 	clk_prepare_enable(bs->clk);
+	bs->clk_hz = clk_get_rate(bs->clk);
 
 	err = bcm2835_dma_init(ctlr, &pdev->dev, bs);
 	if (err)
-- 
2.30.2



