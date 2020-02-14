Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C65815F385
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:22:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393284AbgBNSMb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 13:12:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:60486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729825AbgBNPxI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:53:08 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E44FF24649;
        Fri, 14 Feb 2020 15:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695587;
        bh=g0H+3ovq4kYtjGmq5NPbNijrKDqg75LfmPzzqNKWwBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xrZgLHSdXOpgDiJAqDNAgJLfhvz2hf2Lkc7OZ8yyBVXVDmQIDXbjr8S1FJVAkZtdE
         J2xZmFqLHrIrzDwhv7G4iVjJD5hpHUh/9k9Y0k3IbEHfyr2OQ7wXDfesdqhVzbujU8
         YZomBiR5V+NFpe2kiQUAYQjVNBpafgP225B8K5Wg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chuhong Yuan <hslester96@gmail.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 195/542] dmaengine: axi-dmac: add a check for devm_regmap_init_mmio
Date:   Fri, 14 Feb 2020 10:43:07 -0500
Message-Id: <20200214154854.6746-195-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

[ Upstream commit a5b982af953bcc838cd198b0434834cc1dff14ec ]

The driver misses checking the result of devm_regmap_init_mmio().
Add a check to fix it.

Fixes: fc15be39a827 ("dmaengine: axi-dmac: add regmap support")
Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Reviewed-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Link: https://lore.kernel.org/r/20191209085711.16001-1-hslester96@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dma-axi-dmac.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/dma-axi-dmac.c b/drivers/dma/dma-axi-dmac.c
index a0ee404b736ed..f1d149e328395 100644
--- a/drivers/dma/dma-axi-dmac.c
+++ b/drivers/dma/dma-axi-dmac.c
@@ -830,6 +830,7 @@ static int axi_dmac_probe(struct platform_device *pdev)
 	struct dma_device *dma_dev;
 	struct axi_dmac *dmac;
 	struct resource *res;
+	struct regmap *regmap;
 	int ret;
 
 	dmac = devm_kzalloc(&pdev->dev, sizeof(*dmac), GFP_KERNEL);
@@ -921,10 +922,17 @@ static int axi_dmac_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, dmac);
 
-	devm_regmap_init_mmio(&pdev->dev, dmac->base, &axi_dmac_regmap_config);
+	regmap = devm_regmap_init_mmio(&pdev->dev, dmac->base,
+		 &axi_dmac_regmap_config);
+	if (IS_ERR(regmap)) {
+		ret = PTR_ERR(regmap);
+		goto err_free_irq;
+	}
 
 	return 0;
 
+err_free_irq:
+	free_irq(dmac->irq, dmac);
 err_unregister_of:
 	of_dma_controller_free(pdev->dev.of_node);
 err_unregister_device:
-- 
2.20.1

