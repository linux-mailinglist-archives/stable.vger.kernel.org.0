Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6EDC3D604B
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236569AbhGZPVk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:21:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:35766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236599AbhGZPVc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:21:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3DB460E09;
        Mon, 26 Jul 2021 16:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315320;
        bh=uOX4OaURtWMQzPsBzVLUPfZ+2s99oQaxC0K7nUTWB5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=skHuA5jNdte9dhUpCbsqxyZd7TmQBeBML+4E0EdDbnKswqItJmtue1Fqd2sbx0FCS
         91cfaj+x2mcaXv+CLNBGQex5RG3fe6Z/MBvGqTTFW6HHCDV7rAU/g6Zdsca5zX3ZHU
         C5n/2I8pFfiRNA3XMcNDJJB51eYxX7XY5UghZW20=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Amelie Delaunay <amelie.delaunay@foss.st.com>,
        Alain Volmat <alain.volmat@foss.st.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 050/167] spi: stm32: fixes pm_runtime calls in probe/remove
Date:   Mon, 26 Jul 2021 17:38:03 +0200
Message-Id: <20210726153841.075969290@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alain Volmat <alain.volmat@foss.st.com>

[ Upstream commit 7999d2555c9f879d006ea8469d74db9cdb038af0 ]

Add pm_runtime calls in probe/probe error path and remove
in order to be consistent in all places in ordering and
ensure that pm_runtime is disabled prior to resources used
by the SPI controller.

This patch also fixes the 2 following warnings on driver remove:
WARNING: CPU: 0 PID: 743 at drivers/clk/clk.c:594 clk_core_disable_lock+0x18/0x24
WARNING: CPU: 0 PID: 743 at drivers/clk/clk.c:476 clk_unprepare+0x24/0x2c

Fixes: 038ac869c9d2 ("spi: stm32: add runtime PM support")

Signed-off-by: Amelie Delaunay <amelie.delaunay@foss.st.com>
Signed-off-by: Alain Volmat <alain.volmat@foss.st.com>
Link: https://lore.kernel.org/r/1625646426-5826-2-git-send-email-alain.volmat@foss.st.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-stm32.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-stm32.c b/drivers/spi/spi-stm32.c
index 0318f02d6212..8f91f8705eee 100644
--- a/drivers/spi/spi-stm32.c
+++ b/drivers/spi/spi-stm32.c
@@ -1946,6 +1946,7 @@ static int stm32_spi_probe(struct platform_device *pdev)
 		master->can_dma = stm32_spi_can_dma;
 
 	pm_runtime_set_active(&pdev->dev);
+	pm_runtime_get_noresume(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
 
 	ret = spi_register_master(master);
@@ -1967,6 +1968,8 @@ static int stm32_spi_probe(struct platform_device *pdev)
 
 err_pm_disable:
 	pm_runtime_disable(&pdev->dev);
+	pm_runtime_put_noidle(&pdev->dev);
+	pm_runtime_set_suspended(&pdev->dev);
 err_dma_release:
 	if (spi->dma_tx)
 		dma_release_channel(spi->dma_tx);
@@ -1983,9 +1986,14 @@ static int stm32_spi_remove(struct platform_device *pdev)
 	struct spi_master *master = platform_get_drvdata(pdev);
 	struct stm32_spi *spi = spi_master_get_devdata(master);
 
+	pm_runtime_get_sync(&pdev->dev);
+
 	spi_unregister_master(master);
 	spi->cfg->disable(spi);
 
+	pm_runtime_disable(&pdev->dev);
+	pm_runtime_put_noidle(&pdev->dev);
+	pm_runtime_set_suspended(&pdev->dev);
 	if (master->dma_tx)
 		dma_release_channel(master->dma_tx);
 	if (master->dma_rx)
@@ -1993,7 +2001,6 @@ static int stm32_spi_remove(struct platform_device *pdev)
 
 	clk_disable_unprepare(spi->clk);
 
-	pm_runtime_disable(&pdev->dev);
 
 	pinctrl_pm_select_sleep_state(&pdev->dev);
 
-- 
2.30.2



