Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE65DF6228
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 03:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbfKJCkf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:40:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:33742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726927AbfKJCke (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:40:34 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7014A222CB;
        Sun, 10 Nov 2019 02:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353633;
        bh=YqZWzUQJTKdmC1hV7IUxf49LhrQKLeopy1rzr6WQcL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q4yU7ws9aAGoFBBRcTQ4OIhcxzn06ZTHpHFQ79+H8UPHO0o6xJTsRWF6NzVS+/ZJJ
         wbmFsKD4Xp9tiiVRwQzlk4rc6GAbdqBnHqLx5kYIz4eXunZD2ckl8H/iuXy8KiT2jO
         hNToqWmCUMHbJc5FtXeM9rJgiKFr/vYioGYbGOgA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jonas Gorski <jonas.gorski@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 016/191] spi/bcm63xx-hsspi: keep pll clk enabled
Date:   Sat,  9 Nov 2019 21:37:18 -0500
Message-Id: <20191110024013.29782-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit 0fd85869c2a9c8723a98bc1f56a876e8383649f4 ]

If the pll clock needs to be enabled to get its rate, it will also need
to be enabled to provide it. So ensure it is kept enabled through the
lifetime of the device.

Fixes: 0d7412ed1f5dc ("spi/bcm63xx-hspi: Enable the clock before calling clk_get_rate().")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm63xx-hsspi.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-bcm63xx-hsspi.c b/drivers/spi/spi-bcm63xx-hsspi.c
index c23849f7aa7bc..9a06ffdb73b88 100644
--- a/drivers/spi/spi-bcm63xx-hsspi.c
+++ b/drivers/spi/spi-bcm63xx-hsspi.c
@@ -101,6 +101,7 @@ struct bcm63xx_hsspi {
 
 	struct platform_device *pdev;
 	struct clk *clk;
+	struct clk *pll_clk;
 	void __iomem *regs;
 	u8 __iomem *fifo;
 
@@ -332,7 +333,7 @@ static int bcm63xx_hsspi_probe(struct platform_device *pdev)
 	struct resource *res_mem;
 	void __iomem *regs;
 	struct device *dev = &pdev->dev;
-	struct clk *clk;
+	struct clk *clk, *pll_clk = NULL;
 	int irq, ret;
 	u32 reg, rate, num_cs = HSSPI_SPI_MAX_CS;
 
@@ -358,7 +359,7 @@ static int bcm63xx_hsspi_probe(struct platform_device *pdev)
 
 	rate = clk_get_rate(clk);
 	if (!rate) {
-		struct clk *pll_clk = devm_clk_get(dev, "pll");
+		pll_clk = devm_clk_get(dev, "pll");
 
 		if (IS_ERR(pll_clk)) {
 			ret = PTR_ERR(pll_clk);
@@ -373,19 +374,20 @@ static int bcm63xx_hsspi_probe(struct platform_device *pdev)
 		clk_disable_unprepare(pll_clk);
 		if (!rate) {
 			ret = -EINVAL;
-			goto out_disable_clk;
+			goto out_disable_pll_clk;
 		}
 	}
 
 	master = spi_alloc_master(&pdev->dev, sizeof(*bs));
 	if (!master) {
 		ret = -ENOMEM;
-		goto out_disable_clk;
+		goto out_disable_pll_clk;
 	}
 
 	bs = spi_master_get_devdata(master);
 	bs->pdev = pdev;
 	bs->clk = clk;
+	bs->pll_clk = pll_clk;
 	bs->regs = regs;
 	bs->speed_hz = rate;
 	bs->fifo = (u8 __iomem *)(bs->regs + HSSPI_FIFO_REG(0));
@@ -440,6 +442,8 @@ static int bcm63xx_hsspi_probe(struct platform_device *pdev)
 
 out_put_master:
 	spi_master_put(master);
+out_disable_pll_clk:
+	clk_disable_unprepare(pll_clk);
 out_disable_clk:
 	clk_disable_unprepare(clk);
 	return ret;
@@ -453,6 +457,7 @@ static int bcm63xx_hsspi_remove(struct platform_device *pdev)
 
 	/* reset the hardware and block queue progress */
 	__raw_writel(0, bs->regs + HSSPI_INT_MASK_REG);
+	clk_disable_unprepare(bs->pll_clk);
 	clk_disable_unprepare(bs->clk);
 
 	return 0;
@@ -465,6 +470,7 @@ static int bcm63xx_hsspi_suspend(struct device *dev)
 	struct bcm63xx_hsspi *bs = spi_master_get_devdata(master);
 
 	spi_master_suspend(master);
+	clk_disable_unprepare(bs->pll_clk);
 	clk_disable_unprepare(bs->clk);
 
 	return 0;
@@ -480,6 +486,12 @@ static int bcm63xx_hsspi_resume(struct device *dev)
 	if (ret)
 		return ret;
 
+	if (bs->pll_clk) {
+		ret = clk_prepare_enable(bs->pll_clk);
+		if (ret)
+			return ret;
+	}
+
 	spi_master_resume(master);
 
 	return 0;
-- 
2.20.1

