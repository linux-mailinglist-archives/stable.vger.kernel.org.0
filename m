Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 492A53D5F9C
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236293AbhGZPSe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:18:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:53272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236685AbhGZPMX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:12:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC75760F42;
        Mon, 26 Jul 2021 15:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314756;
        bh=maLKI/2FAvlrlgPA5ZYTH4/igSjRXwoR9wsBtk6/opo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IKP5d2OBIqvOJuIUo2NwQRhHZEg2+Lvf55SO6D/ISyjGom1+2ZgxS4UQIKfOLN+n1
         JeeWhGbwRX63OdwTTd20FqeUfLif2Je2arxmEVMjUN1wq+g6/YojGTcPwuLnrkcwBa
         GCPKMjLxd+j5S8c/YXt4o3UfT2x9Rntn2NNoSEOs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 081/120] spi: cadence: Correct initialisation of runtime PM again
Date:   Mon, 26 Jul 2021 17:38:53 +0200
Message-Id: <20210726153834.985887531@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153832.339431936@linuxfoundation.org>
References: <20210726153832.339431936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit 56912da7a68c8356df6a6740476237441b0b792a ]

The original implementation of RPM handling in probe() was mostly
correct, except it failed to call pm_runtime_get_*() to activate the
hardware. The subsequent fix, 734882a8bf98 ("spi: cadence: Correct
initialisation of runtime PM"), breaks the implementation further,
to the point where the system using this hard IP on ZynqMP hangs on
boot, because it accesses hardware which is gated off.

Undo 734882a8bf98 ("spi: cadence: Correct initialisation of runtime
PM") and instead add missing pm_runtime_get_noresume() and move the
RPM disabling all the way to the end of probe(). That makes ZynqMP
not hang on boot yet again.

Fixes: 734882a8bf98 ("spi: cadence: Correct initialisation of runtime PM")
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Charles Keepax <ckeepax@opensource.cirrus.com>
Cc: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20210716182133.218640-1-marex@denx.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/spi/spi-cadence.c b/drivers/spi/spi-cadence.c
index f5055ceb7529..91f83683c15a 100644
--- a/drivers/spi/spi-cadence.c
+++ b/drivers/spi/spi-cadence.c
@@ -585,6 +585,12 @@ static int cdns_spi_probe(struct platform_device *pdev)
 		goto clk_dis_apb;
 	}
 
+	pm_runtime_use_autosuspend(&pdev->dev);
+	pm_runtime_set_autosuspend_delay(&pdev->dev, SPI_AUTOSUSPEND_TIMEOUT);
+	pm_runtime_get_noresume(&pdev->dev);
+	pm_runtime_set_active(&pdev->dev);
+	pm_runtime_enable(&pdev->dev);
+
 	ret = of_property_read_u32(pdev->dev.of_node, "num-cs", &num_cs);
 	if (ret < 0)
 		master->num_chipselect = CDNS_SPI_DEFAULT_NUM_CS;
@@ -599,11 +605,6 @@ static int cdns_spi_probe(struct platform_device *pdev)
 	/* SPI controller initializations */
 	cdns_spi_init_hw(xspi);
 
-	pm_runtime_set_active(&pdev->dev);
-	pm_runtime_enable(&pdev->dev);
-	pm_runtime_use_autosuspend(&pdev->dev);
-	pm_runtime_set_autosuspend_delay(&pdev->dev, SPI_AUTOSUSPEND_TIMEOUT);
-
 	irq = platform_get_irq(pdev, 0);
 	if (irq <= 0) {
 		ret = -ENXIO;
@@ -636,6 +637,9 @@ static int cdns_spi_probe(struct platform_device *pdev)
 
 	master->bits_per_word_mask = SPI_BPW_MASK(8);
 
+	pm_runtime_mark_last_busy(&pdev->dev);
+	pm_runtime_put_autosuspend(&pdev->dev);
+
 	ret = spi_register_master(master);
 	if (ret) {
 		dev_err(&pdev->dev, "spi_register_master failed\n");
-- 
2.30.2



