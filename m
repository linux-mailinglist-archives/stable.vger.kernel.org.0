Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 585BD499FAE
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:20:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1842010AbiAXXAf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:00:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1835930AbiAXWhs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:37:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A846C02B86F;
        Mon, 24 Jan 2022 12:59:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27FDC61317;
        Mon, 24 Jan 2022 20:59:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D51D4C340E5;
        Mon, 24 Jan 2022 20:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057987;
        bh=WZ3y8zEoAZCa0dRNCAuVij8BF5EdE9FA38K3vuCAJqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JkszGgGnFvjZPy0qaamFfoJWYt47ArtFGWJgizq334c0rGXbjnMDxdMZ0EuzAPq4l
         37Pr3x3tshQ8BoO03EmGzR66LOY7PXyGF6cSVYRquoecNeq01+fhAVqOAh8CqJW/Gs
         AjShAvv4UuXT5AjiXu3fmmQOR0o8wNbqIuPzchmQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, oujiefeng <oujiefeng@huawei.com>,
        Jay Fang <f.fangjian@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0144/1039] spi: hisi-kunpeng: Fix the debugfs directory name incorrect
Date:   Mon, 24 Jan 2022 19:32:13 +0100
Message-Id: <20220124184130.014248113@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: oujiefeng <oujiefeng@huawei.com>

[ Upstream commit 40fafc8eca3f0d41b9dade5c10afb2dad723aad7 ]

Change the debugfs directory name from hisi_spi65535 to hisi_spi0.

Fixes: 2b2142f247eb ("spi: hisi-kunpeng: Add debugfs support")
Signed-off-by: oujiefeng <oujiefeng@huawei.com>
Signed-off-by: Jay Fang <f.fangjian@huawei.com>
Link: https://lore.kernel.org/r/20211117012119.55558-1-f.fangjian@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-hisi-kunpeng.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/spi/spi-hisi-kunpeng.c b/drivers/spi/spi-hisi-kunpeng.c
index 58b823a16fc4d..525cc0143a305 100644
--- a/drivers/spi/spi-hisi-kunpeng.c
+++ b/drivers/spi/spi-hisi-kunpeng.c
@@ -127,7 +127,6 @@ struct hisi_spi {
 	void __iomem		*regs;
 	int			irq;
 	u32			fifo_len; /* depth of the FIFO buffer */
-	u16			bus_num;
 
 	/* Current message transfer state info */
 	const void		*tx;
@@ -165,7 +164,10 @@ static int hisi_spi_debugfs_init(struct hisi_spi *hs)
 {
 	char name[32];
 
-	snprintf(name, 32, "hisi_spi%d", hs->bus_num);
+	struct spi_controller *master;
+
+	master = container_of(hs->dev, struct spi_controller, dev);
+	snprintf(name, 32, "hisi_spi%d", master->bus_num);
 	hs->debugfs = debugfs_create_dir(name, NULL);
 	if (!hs->debugfs)
 		return -ENOMEM;
@@ -467,7 +469,6 @@ static int hisi_spi_probe(struct platform_device *pdev)
 	hs = spi_controller_get_devdata(master);
 	hs->dev = dev;
 	hs->irq = irq;
-	hs->bus_num = pdev->id;
 
 	hs->regs = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(hs->regs))
@@ -490,7 +491,7 @@ static int hisi_spi_probe(struct platform_device *pdev)
 	master->use_gpio_descriptors = true;
 	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_CS_HIGH | SPI_LOOP;
 	master->bits_per_word_mask = SPI_BPW_RANGE_MASK(4, 32);
-	master->bus_num = hs->bus_num;
+	master->bus_num = pdev->id;
 	master->setup = hisi_spi_setup;
 	master->cleanup = hisi_spi_cleanup;
 	master->transfer_one = hisi_spi_transfer_one;
@@ -506,15 +507,15 @@ static int hisi_spi_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	if (hisi_spi_debugfs_init(hs))
-		dev_info(dev, "failed to create debugfs dir\n");
-
 	ret = spi_register_controller(master);
 	if (ret) {
 		dev_err(dev, "failed to register spi master, ret=%d\n", ret);
 		return ret;
 	}
 
+	if (hisi_spi_debugfs_init(hs))
+		dev_info(dev, "failed to create debugfs dir\n");
+
 	dev_info(dev, "hw version:0x%x max-freq:%u kHz\n",
 		readl(hs->regs + HISI_SPI_VERSION),
 		master->max_speed_hz / 1000);
-- 
2.34.1



