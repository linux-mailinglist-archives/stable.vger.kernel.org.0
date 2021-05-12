Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC3D137CC99
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244401AbhELQpu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:45:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:56992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239416AbhELQjK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:39:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B47E61CD7;
        Wed, 12 May 2021 16:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835386;
        bh=A35gpf8c/+t6ovEsnfyPUuPfk8a2uomFRWHTgMBLdio=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vjb9l2xsfklQD7ZBm0WuKKDheQk+9cPg41g+/AtFUSrwBeRh7XlS21NQCcCqVu+96
         bUbuEcJ2WLzutpHtwCOnBAUtNkE33KKNYQ2mc+ZKahkPBQBZtU0OBRuW4uJ2o0LCNg
         /H6r+5lquIJKFG8CZ+gBCqoLIHsRiHGNKG6LIIc4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Quanyang Wang <quanyang.wang@windriver.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 323/677] spi: spi-zynqmp-gqspi: fix hang issue when suspend/resume
Date:   Wed, 12 May 2021 16:46:09 +0200
Message-Id: <20210512144847.969635256@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quanyang Wang <quanyang.wang@windriver.com>

[ Upstream commit 799f923f0a66a9c99f0a3eaa078b306db7a8b33a ]

After calling platform_set_drvdata(pdev, xqspi) in probe, the return
value of dev_get_drvdata(dev) is a pointer to struct zynqmp_qspi but
not struct spi_controller. A wrong structure type passing to the
functions spi_controller_suspend/resume will hang the system.

And we should check the return value of spi_controller_suspend, if
an error is returned, return it to PM subsystem to stop suspend.

Also, GQSPI_EN_MASK should be written to GQSPI_EN_OFST to enable
the spi controller in zynqmp_qspi_resume since it was disabled in
zynqmp_qspi_suspend before.

Fixes: 1c26372e5aa9 ("spi: spi-zynqmp-gqspi: Update driver to use spi-mem framework")
Signed-off-by: Quanyang Wang <quanyang.wang@windriver.com>
Link: https://lore.kernel.org/r/20210416004652.2975446-3-quanyang.wang@windriver.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-zynqmp-gqspi.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/spi-zynqmp-gqspi.c b/drivers/spi/spi-zynqmp-gqspi.c
index f9056f0a480c..1146359528b9 100644
--- a/drivers/spi/spi-zynqmp-gqspi.c
+++ b/drivers/spi/spi-zynqmp-gqspi.c
@@ -157,6 +157,7 @@ enum mode_type {GQSPI_MODE_IO, GQSPI_MODE_DMA};
  * @data_completion:	completion structure
  */
 struct zynqmp_qspi {
+	struct spi_controller *ctlr;
 	void __iomem *regs;
 	struct clk *refclk;
 	struct clk *pclk;
@@ -827,10 +828,13 @@ static void zynqmp_qspi_read_op(struct zynqmp_qspi *xqspi, u8 rx_nbits,
  */
 static int __maybe_unused zynqmp_qspi_suspend(struct device *dev)
 {
-	struct spi_controller *ctlr = dev_get_drvdata(dev);
-	struct zynqmp_qspi *xqspi = spi_controller_get_devdata(ctlr);
+	struct zynqmp_qspi *xqspi = dev_get_drvdata(dev);
+	struct spi_controller *ctlr = xqspi->ctlr;
+	int ret;
 
-	spi_controller_suspend(ctlr);
+	ret = spi_controller_suspend(ctlr);
+	if (ret)
+		return ret;
 
 	zynqmp_gqspi_write(xqspi, GQSPI_EN_OFST, 0x0);
 
@@ -848,7 +852,10 @@ static int __maybe_unused zynqmp_qspi_suspend(struct device *dev)
  */
 static int __maybe_unused zynqmp_qspi_resume(struct device *dev)
 {
-	struct spi_controller *ctlr = dev_get_drvdata(dev);
+	struct zynqmp_qspi *xqspi = dev_get_drvdata(dev);
+	struct spi_controller *ctlr = xqspi->ctlr;
+
+	zynqmp_gqspi_write(xqspi, GQSPI_EN_OFST, GQSPI_EN_MASK);
 
 	spi_controller_resume(ctlr);
 
@@ -865,7 +872,7 @@ static int __maybe_unused zynqmp_qspi_resume(struct device *dev)
  */
 static int __maybe_unused zynqmp_runtime_suspend(struct device *dev)
 {
-	struct zynqmp_qspi *xqspi = (struct zynqmp_qspi *)dev_get_drvdata(dev);
+	struct zynqmp_qspi *xqspi = dev_get_drvdata(dev);
 
 	clk_disable_unprepare(xqspi->refclk);
 	clk_disable_unprepare(xqspi->pclk);
@@ -883,7 +890,7 @@ static int __maybe_unused zynqmp_runtime_suspend(struct device *dev)
  */
 static int __maybe_unused zynqmp_runtime_resume(struct device *dev)
 {
-	struct zynqmp_qspi *xqspi = (struct zynqmp_qspi *)dev_get_drvdata(dev);
+	struct zynqmp_qspi *xqspi = dev_get_drvdata(dev);
 	int ret;
 
 	ret = clk_prepare_enable(xqspi->pclk);
@@ -1090,6 +1097,7 @@ static int zynqmp_qspi_probe(struct platform_device *pdev)
 
 	xqspi = spi_controller_get_devdata(ctlr);
 	xqspi->dev = dev;
+	xqspi->ctlr = ctlr;
 	platform_set_drvdata(pdev, xqspi);
 
 	xqspi->regs = devm_platform_ioremap_resource(pdev, 0);
-- 
2.30.2



