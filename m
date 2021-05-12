Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E780E37CB60
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242641AbhELQfT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:35:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:44582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241718AbhELQ1z (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:27:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B87A61920;
        Wed, 12 May 2021 15:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834931;
        bh=AM3ES+W8gpWkwF/xWOlW0nH8mSKhR2ndDYBD5IEpxPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JmPjjXW/Uomho+suRqIOrL//ePqh+3uTJCGX1ZHkaJLBXrIC0ZClqnCd4PAWO84QE
         nBrGUkZOb/WRbuHptCGQlom248Iru7X2zwH+NGcUJ9BwBLfMlpRiQpca3KbqH/t2yM
         HOxzayZ1572dhoWajg2S+p/aLfvv4mXONXAL+ve8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Ceresoli <luca@lucaceresoli.net>,
        Moritz Fischer <mdf@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 140/677] fpga: fpga-mgr: xilinx-spi: fix error messages on -EPROBE_DEFER
Date:   Wed, 12 May 2021 16:43:06 +0200
Message-Id: <20210512144841.893182448@linuxfoundation.org>
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

From: Luca Ceresoli <luca@lucaceresoli.net>

[ Upstream commit 484a58607a808c3721917f5ca5fba7eff809e4df ]

The current code produces an error message on devm_gpiod_get() errors even
when the error is -EPROBE_DEFER, which should be silent.

This has been observed producing a significant amount of messages like:

    xlnx-slave-spi spi1.1: Failed to get PROGRAM_B gpio: -517

Fix and simplify code by using the dev_err_probe() helper function.

Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
Fixes: dd2784c01d93 ("fpga manager: xilinx-spi: check INIT_B pin during write_init")
Fixes: 061c97d13f1a ("fpga manager: Add Xilinx slave serial SPI driver")
Signed-off-by: Moritz Fischer <mdf@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/fpga/xilinx-spi.c | 24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/drivers/fpga/xilinx-spi.c b/drivers/fpga/xilinx-spi.c
index 27defa98092d..fee4d0abf6bf 100644
--- a/drivers/fpga/xilinx-spi.c
+++ b/drivers/fpga/xilinx-spi.c
@@ -233,25 +233,19 @@ static int xilinx_spi_probe(struct spi_device *spi)
 
 	/* PROGRAM_B is active low */
 	conf->prog_b = devm_gpiod_get(&spi->dev, "prog_b", GPIOD_OUT_LOW);
-	if (IS_ERR(conf->prog_b)) {
-		dev_err(&spi->dev, "Failed to get PROGRAM_B gpio: %ld\n",
-			PTR_ERR(conf->prog_b));
-		return PTR_ERR(conf->prog_b);
-	}
+	if (IS_ERR(conf->prog_b))
+		return dev_err_probe(&spi->dev, PTR_ERR(conf->prog_b),
+				     "Failed to get PROGRAM_B gpio\n");
 
 	conf->init_b = devm_gpiod_get_optional(&spi->dev, "init-b", GPIOD_IN);
-	if (IS_ERR(conf->init_b)) {
-		dev_err(&spi->dev, "Failed to get INIT_B gpio: %ld\n",
-			PTR_ERR(conf->init_b));
-		return PTR_ERR(conf->init_b);
-	}
+	if (IS_ERR(conf->init_b))
+		return dev_err_probe(&spi->dev, PTR_ERR(conf->init_b),
+				     "Failed to get INIT_B gpio\n");
 
 	conf->done = devm_gpiod_get(&spi->dev, "done", GPIOD_IN);
-	if (IS_ERR(conf->done)) {
-		dev_err(&spi->dev, "Failed to get DONE gpio: %ld\n",
-			PTR_ERR(conf->done));
-		return PTR_ERR(conf->done);
-	}
+	if (IS_ERR(conf->done))
+		return dev_err_probe(&spi->dev, PTR_ERR(conf->done),
+				     "Failed to get DONE gpio\n");
 
 	mgr = devm_fpga_mgr_create(&spi->dev,
 				   "Xilinx Slave Serial FPGA Manager",
-- 
2.30.2



