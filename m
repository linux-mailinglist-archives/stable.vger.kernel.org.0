Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09F682B6305
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732155AbgKQNeP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:34:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:44610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731780AbgKQNeN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:34:13 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D876E2465E;
        Tue, 17 Nov 2020 13:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620052;
        bh=Lquq9XnuQLwRDy9GSr/mGzKBOJC2SPeDjTowVCurCv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1/IJTYBrGGHQDCW7UtWDN28lEttJYoQMwITSlVx4oixIqWFSBVmgf+mEy2wJaD33n
         h3rtwhu1NpXSrnBpPe74z4GyJdri18v1qyJJnRdOeMnBsK3p2a0ekWKp1E5qH93FH5
         yBg9L8siOC5TIr+OjPOlp1uRWPhCosRqs0AH5u58=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhao Qiang <qiang.zhao@nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 062/255] spi: fsl-dspi: fix wrong pointer in suspend/resume
Date:   Tue, 17 Nov 2020 14:03:22 +0100
Message-Id: <20201117122141.969939199@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhao Qiang <qiang.zhao@nxp.com>

[ Upstream commit 9bd77a9ce31dd242fece27219d14fbee5068dd85 ]

Since commit 530b5affc675 ("spi: fsl-dspi: fix use-after-free in
remove path"), this driver causes a "NULL pointer dereference"
in dspi_suspend/resume.
This is because since this commit, the drivers private data point to
"dspi" instead of "ctlr", the codes in suspend and resume func were
not modified correspondly.

Fixes: 530b5affc675 ("spi: fsl-dspi: fix use-after-free in remove path")
Signed-off-by: Zhao Qiang <qiang.zhao@nxp.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Link: https://lore.kernel.org/r/20201103020546.1822-1-qiang.zhao@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-dspi.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index 108a7d50d2c37..a96762ffb70b6 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -1106,12 +1106,11 @@ MODULE_DEVICE_TABLE(of, fsl_dspi_dt_ids);
 #ifdef CONFIG_PM_SLEEP
 static int dspi_suspend(struct device *dev)
 {
-	struct spi_controller *ctlr = dev_get_drvdata(dev);
-	struct fsl_dspi *dspi = spi_controller_get_devdata(ctlr);
+	struct fsl_dspi *dspi = dev_get_drvdata(dev);
 
 	if (dspi->irq)
 		disable_irq(dspi->irq);
-	spi_controller_suspend(ctlr);
+	spi_controller_suspend(dspi->ctlr);
 	clk_disable_unprepare(dspi->clk);
 
 	pinctrl_pm_select_sleep_state(dev);
@@ -1121,8 +1120,7 @@ static int dspi_suspend(struct device *dev)
 
 static int dspi_resume(struct device *dev)
 {
-	struct spi_controller *ctlr = dev_get_drvdata(dev);
-	struct fsl_dspi *dspi = spi_controller_get_devdata(ctlr);
+	struct fsl_dspi *dspi = dev_get_drvdata(dev);
 	int ret;
 
 	pinctrl_pm_select_default_state(dev);
@@ -1130,7 +1128,7 @@ static int dspi_resume(struct device *dev)
 	ret = clk_prepare_enable(dspi->clk);
 	if (ret)
 		return ret;
-	spi_controller_resume(ctlr);
+	spi_controller_resume(dspi->ctlr);
 	if (dspi->irq)
 		enable_irq(dspi->irq);
 
-- 
2.27.0



