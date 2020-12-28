Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4302E3EAD
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503621AbgL1OaQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:30:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:37894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503841AbgL1OaL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:30:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19A2120739;
        Mon, 28 Dec 2020 14:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165795;
        bh=5CxXwJsHIVYiELt/5s2GbBgoikOIqhH7B9YSoH+EbJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vbMY4lKIG7aF1dgAy9BQBfKhjReqq7luIULCkSuAQHZILShz01xHYGaGCWyppvL2A
         QyqQeIC9A/WM5SOmgs/oT1QRdd2ub7oBmdItlj5s8XvX3MELOpoZEW8AJBwdCCZ251
         N+EMV/Ju+DxUXwmoYYjjypx9syjsp0B514L8C2bM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Masahisa Kojima <masahisa.kojima@linaro.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 658/717] spi: synquacer: Disable clock in probe error path
Date:   Mon, 28 Dec 2020 13:50:56 +0100
Message-Id: <20201228125052.482933315@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit 8853b2503014aca5c793d2c7f0aabc990b32bdad upstream.

If the calls to platform_get_irq() or devm_request_irq() fail on probe
of the SynQuacer SPI driver, the clock "sspi->clk" is erroneously not
unprepared and disabled.

If the clock rate "master->max_speed_hz" cannot be determined, the same
happens and in addition the spi_master struct is not freed.

Fix it.

Fixes: b0823ee35cf9 ("spi: Add spi driver for Socionext SynQuacer platform")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: <stable@vger.kernel.org> # v5.3+
Cc: Masahisa Kojima <masahisa.kojima@linaro.org>
Link: https://lore.kernel.org/r/232281df1ab91d8f0f553a62d5f97fc264ace4da.1604874488.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-synquacer.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/drivers/spi/spi-synquacer.c
+++ b/drivers/spi/spi-synquacer.c
@@ -657,7 +657,8 @@ static int synquacer_spi_probe(struct pl
 
 	if (!master->max_speed_hz) {
 		dev_err(&pdev->dev, "missing clock source\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto disable_clk;
 	}
 	master->min_speed_hz = master->max_speed_hz / 254;
 
@@ -670,7 +671,7 @@ static int synquacer_spi_probe(struct pl
 	rx_irq = platform_get_irq(pdev, 0);
 	if (rx_irq <= 0) {
 		ret = rx_irq;
-		goto put_spi;
+		goto disable_clk;
 	}
 	snprintf(sspi->rx_irq_name, SYNQUACER_HSSPI_IRQ_NAME_MAX, "%s-rx",
 		 dev_name(&pdev->dev));
@@ -678,13 +679,13 @@ static int synquacer_spi_probe(struct pl
 				0, sspi->rx_irq_name, sspi);
 	if (ret) {
 		dev_err(&pdev->dev, "request rx_irq failed (%d)\n", ret);
-		goto put_spi;
+		goto disable_clk;
 	}
 
 	tx_irq = platform_get_irq(pdev, 1);
 	if (tx_irq <= 0) {
 		ret = tx_irq;
-		goto put_spi;
+		goto disable_clk;
 	}
 	snprintf(sspi->tx_irq_name, SYNQUACER_HSSPI_IRQ_NAME_MAX, "%s-tx",
 		 dev_name(&pdev->dev));
@@ -692,7 +693,7 @@ static int synquacer_spi_probe(struct pl
 				0, sspi->tx_irq_name, sspi);
 	if (ret) {
 		dev_err(&pdev->dev, "request tx_irq failed (%d)\n", ret);
-		goto put_spi;
+		goto disable_clk;
 	}
 
 	master->dev.of_node = np;
@@ -710,7 +711,7 @@ static int synquacer_spi_probe(struct pl
 
 	ret = synquacer_spi_enable(master);
 	if (ret)
-		goto fail_enable;
+		goto disable_clk;
 
 	pm_runtime_set_active(sspi->dev);
 	pm_runtime_enable(sspi->dev);
@@ -723,7 +724,7 @@ static int synquacer_spi_probe(struct pl
 
 disable_pm:
 	pm_runtime_disable(sspi->dev);
-fail_enable:
+disable_clk:
 	clk_disable_unprepare(sspi->clk);
 put_spi:
 	spi_master_put(master);


