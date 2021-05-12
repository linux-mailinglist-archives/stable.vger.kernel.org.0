Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFC2037C8DD
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237327AbhELQNS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:13:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:34634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239235AbhELQHh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:07:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF8E761D16;
        Wed, 12 May 2021 15:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833814;
        bh=JsJiWstIsSPp/unCPBmaU/bOK5cDK9cuN3cHAiuLIM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fnZJc+oszutxpXJ0Oya/jL6F9xykpGGLVyOrAhM8L8MVnPxfLwE2GdpNojxojg0TI
         4W2nHaTtzcK5Sqc9eFteRoB0x2BXi8ogmijmCnTSf5oTKDP0euwYsR6dTlp1FJgvu+
         LuIGaMTEJIDjZsgnDKj/tllFC4cqXrLxECP6nrN4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Quanyang Wang <quanyang.wang@windriver.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 292/601] spi: spi-zynqmp-gqspi: fix clk_enable/disable imbalance issue
Date:   Wed, 12 May 2021 16:46:09 +0200
Message-Id: <20210512144837.424029123@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quanyang Wang <quanyang.wang@windriver.com>

[ Upstream commit c6bdae08012b2ca3e94f3a41ef4ca8cfe7c9ab6f ]

The clks "pclk" and "ref_clk" are enabled twice during the probe. The
first time is in the function zynqmp_qspi_probe and the second time is
in zynqmp_qspi_setup_op which is called by devm_spi_register_controller.
Then calling zynqmp_qspi_remove (rmmod this module) to disable these clks
will trigger a warning as below:

[  309.124604] Unpreparing enabled qspi_ref
[  309.128641] WARNING: CPU: 1 PID: 537 at drivers/clk/clk.c:824 clk_core_unprepare+0x108/0x110

Since pm_runtime works now, clks can be enabled/disabled by calling
zynqmp_runtime_suspend/resume. So we don't need to enable these clks
explicitly in zynqmp_qspi_setup_op. Remove them to fix this issue.

And remove clk enabling/disabling in zynqmp_qspi_resume because there is
no spi transfer operation so enabling ref_clk is redundant meanwhile pclk
is not disabled for it is shared with other peripherals.

Furthermore replace clk_enable/disable with clk_prepare_enable and
clk_disable_unprepare in runtime_suspend/resume functions.

Fixes: 1c26372e5aa9 ("spi: spi-zynqmp-gqspi: Update driver to use spi-mem framework")
Signed-off-by: Quanyang Wang <quanyang.wang@windriver.com>
Link: https://lore.kernel.org/r/20210416004652.2975446-2-quanyang.wang@windriver.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-zynqmp-gqspi.c | 47 ++++++----------------------------
 1 file changed, 8 insertions(+), 39 deletions(-)

diff --git a/drivers/spi/spi-zynqmp-gqspi.c b/drivers/spi/spi-zynqmp-gqspi.c
index 408e348382c5..31d266cfbb4c 100644
--- a/drivers/spi/spi-zynqmp-gqspi.c
+++ b/drivers/spi/spi-zynqmp-gqspi.c
@@ -487,24 +487,10 @@ static int zynqmp_qspi_setup_op(struct spi_device *qspi)
 {
 	struct spi_controller *ctlr = qspi->master;
 	struct zynqmp_qspi *xqspi = spi_controller_get_devdata(ctlr);
-	struct device *dev = &ctlr->dev;
-	int ret;
 
 	if (ctlr->busy)
 		return -EBUSY;
 
-	ret = clk_enable(xqspi->refclk);
-	if (ret) {
-		dev_err(dev, "Cannot enable device clock.\n");
-		return ret;
-	}
-
-	ret = clk_enable(xqspi->pclk);
-	if (ret) {
-		dev_err(dev, "Cannot enable APB clock.\n");
-		clk_disable(xqspi->refclk);
-		return ret;
-	}
 	zynqmp_gqspi_write(xqspi, GQSPI_EN_OFST, GQSPI_EN_MASK);
 
 	return 0;
@@ -863,26 +849,9 @@ static int __maybe_unused zynqmp_qspi_suspend(struct device *dev)
 static int __maybe_unused zynqmp_qspi_resume(struct device *dev)
 {
 	struct spi_controller *ctlr = dev_get_drvdata(dev);
-	struct zynqmp_qspi *xqspi = spi_controller_get_devdata(ctlr);
-	int ret = 0;
-
-	ret = clk_enable(xqspi->pclk);
-	if (ret) {
-		dev_err(dev, "Cannot enable APB clock.\n");
-		return ret;
-	}
-
-	ret = clk_enable(xqspi->refclk);
-	if (ret) {
-		dev_err(dev, "Cannot enable device clock.\n");
-		clk_disable(xqspi->pclk);
-		return ret;
-	}
 
 	spi_controller_resume(ctlr);
 
-	clk_disable(xqspi->refclk);
-	clk_disable(xqspi->pclk);
 	return 0;
 }
 
@@ -898,8 +867,8 @@ static int __maybe_unused zynqmp_runtime_suspend(struct device *dev)
 {
 	struct zynqmp_qspi *xqspi = (struct zynqmp_qspi *)dev_get_drvdata(dev);
 
-	clk_disable(xqspi->refclk);
-	clk_disable(xqspi->pclk);
+	clk_disable_unprepare(xqspi->refclk);
+	clk_disable_unprepare(xqspi->pclk);
 
 	return 0;
 }
@@ -917,16 +886,16 @@ static int __maybe_unused zynqmp_runtime_resume(struct device *dev)
 	struct zynqmp_qspi *xqspi = (struct zynqmp_qspi *)dev_get_drvdata(dev);
 	int ret;
 
-	ret = clk_enable(xqspi->pclk);
+	ret = clk_prepare_enable(xqspi->pclk);
 	if (ret) {
 		dev_err(dev, "Cannot enable APB clock.\n");
 		return ret;
 	}
 
-	ret = clk_enable(xqspi->refclk);
+	ret = clk_prepare_enable(xqspi->refclk);
 	if (ret) {
 		dev_err(dev, "Cannot enable device clock.\n");
-		clk_disable(xqspi->pclk);
+		clk_disable_unprepare(xqspi->pclk);
 		return ret;
 	}
 
@@ -1136,13 +1105,11 @@ static int zynqmp_qspi_probe(struct platform_device *pdev)
 		goto remove_master;
 	}
 
-	init_completion(&xqspi->data_completion);
-
 	xqspi->refclk = devm_clk_get(&pdev->dev, "ref_clk");
 	if (IS_ERR(xqspi->refclk)) {
 		dev_err(dev, "ref_clk clock not found.\n");
 		ret = PTR_ERR(xqspi->refclk);
-		goto clk_dis_pclk;
+		goto remove_master;
 	}
 
 	ret = clk_prepare_enable(xqspi->pclk);
@@ -1157,6 +1124,8 @@ static int zynqmp_qspi_probe(struct platform_device *pdev)
 		goto clk_dis_pclk;
 	}
 
+	init_completion(&xqspi->data_completion);
+
 	mutex_init(&xqspi->op_lock);
 
 	pm_runtime_use_autosuspend(&pdev->dev);
-- 
2.30.2



