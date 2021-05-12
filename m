Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEFD437C16C
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 16:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231872AbhELPAF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:00:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:46196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231453AbhELO6M (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 10:58:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A16326143C;
        Wed, 12 May 2021 14:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831359;
        bh=V+zRJns6/Pnp7to6Ws9ps4uD32QHQZQr80zkSJFlhcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uTd5kMTIhtU/nhITebhCScGkovfW2sdr7k2fzp0IJcp8Usg93uhLPPokQaQUggTUI
         Fe4Qfo14u3aaLFqDV/MYG50zIMMjywv3F+cKCKZqztX02UgdZxiraZ4wYW1HGDbigD
         TYvsUT7K7Of9L7SGgOp0SXkINBjyGw/mZvk8yAHw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Antonio Borneo <antonio.borneo@foss.st.com>,
        Alain Volmat <alain.volmat@foss.st.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 081/244] spi: stm32: drop devres version of spi_register_master
Date:   Wed, 12 May 2021 16:47:32 +0200
Message-Id: <20210512144745.624780437@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Antonio Borneo <antonio.borneo@foss.st.com>

[ Upstream commit 8d559a64f00b59af9cc02b803ff52f6e6880a651 ]

A call to spi_unregister_master() triggers calling remove()
for all the spi devices binded to the spi master.

Some spi device driver requires to "talk" with the spi device
during the remove(), e.g.:
- a LCD panel like drivers/gpu/drm/panel/panel-lg-lg4573.c
  will turn off the backlighting sending a command over spi.
This implies that the spi master must be fully functional when
spi_unregister_master() is called, either if it is called
explicitly in the master's remove() code or implicitly by the
devres framework.

Devres calls devres_release_all() to release all the resources
"after" the remove() of the spi master driver (check code of
__device_release_driver() in drivers/base/dd.c).
If the spi master driver has an empty remove() then there would
be no issue; the devres_release_all() will release everything
in reverse order w.r.t. probe().
But if code in spi master driver remove() disables the spi or
makes it not functional (like in this spi-stm32), then devres
cannot be used safely for unregistering the spi master and the
binded spi devices.

Replace devm_spi_register_master() with spi_register_master()
and add spi_unregister_master() as first action in remove().

Fixes: dcbe0d84dfa5 ("spi: add driver for STM32 SPI controller")

Signed-off-by: Antonio Borneo <antonio.borneo@foss.st.com>
Signed-off-by: Alain Volmat <alain.volmat@foss.st.com>
Link: https://lore.kernel.org/r/1615545286-5395-1-git-send-email-alain.volmat@foss.st.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-stm32.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-stm32.c b/drivers/spi/spi-stm32.c
index 9e7a6de3c43d..3af6a5a3a4b2 100644
--- a/drivers/spi/spi-stm32.c
+++ b/drivers/spi/spi-stm32.c
@@ -1926,7 +1926,7 @@ static int stm32_spi_probe(struct platform_device *pdev)
 	pm_runtime_set_active(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
 
-	ret = devm_spi_register_master(&pdev->dev, master);
+	ret = spi_register_master(master);
 	if (ret) {
 		dev_err(&pdev->dev, "spi master registration failed: %d\n",
 			ret);
@@ -1980,6 +1980,7 @@ static int stm32_spi_remove(struct platform_device *pdev)
 	struct spi_master *master = platform_get_drvdata(pdev);
 	struct stm32_spi *spi = spi_master_get_devdata(master);
 
+	spi_unregister_master(master);
 	spi->cfg->disable(spi);
 
 	if (master->dma_tx)
-- 
2.30.2



