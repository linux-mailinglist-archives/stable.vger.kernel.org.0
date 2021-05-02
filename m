Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B522A370C78
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233140AbhEBOG0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:06:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:50118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232951AbhEBOFx (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:05:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20793613C7;
        Sun,  2 May 2021 14:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964301;
        bh=1UL2/FKNYl0/Dd8NPU5uUkfcupyJWvFe2/i8sYdvXr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OWn5Mg3WuYp0qHsKoZlvEg4qDaFvqi4uY3K7wI+CgIbgKhTT4fnqJp2RP+79ubYET
         8bRg4xPbwb+7a0C0it0lt2LPCmVR53vgHfYr290SxpUYIElbNxeKCXLr0An0zi4heG
         eXkFGw/LxMDEBL4gxvm7ci7tqcW6GN9n8vkCEOpJyOgNeBMSyW0UJ9RQ9UAtEoK9Dh
         1MJ719wsCJBsPVgEveSmWTVlhGBCD8hLNmK/+HCyml3nthaoafIXUdEZs1yWC8dKPX
         L/kW/1z/+kZPCNTRmtV+9RLz9aRRKTx4iysWbDM3KKhCmv18QBR5Ol5Vrd4iEkNsyG
         PUU5BbzJ/nutw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 22/34] spi: omap-100k: Fix reference leak to master
Date:   Sun,  2 May 2021 10:04:22 -0400
Message-Id: <20210502140434.2719553-22-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140434.2719553-1-sashal@kernel.org>
References: <20210502140434.2719553-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit a23faea76d4cf5f75decb574491e66f9ecd707e7 ]

Call spi_master_get() holds the reference count to master device, thus
we need an additional spi_master_put() call to reduce the reference
count, otherwise we will leak a reference to master.

This commit fix it by removing the unnecessary spi_master_get().

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Link: https://lore.kernel.org/r/20210409082954.2906933-1-weiyongjun1@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-omap-100k.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-omap-100k.c b/drivers/spi/spi-omap-100k.c
index b955ca8796d2..b8e201c09484 100644
--- a/drivers/spi/spi-omap-100k.c
+++ b/drivers/spi/spi-omap-100k.c
@@ -426,7 +426,7 @@ static int omap1_spi100k_probe(struct platform_device *pdev)
 
 static int omap1_spi100k_remove(struct platform_device *pdev)
 {
-	struct spi_master *master = spi_master_get(platform_get_drvdata(pdev));
+	struct spi_master *master = platform_get_drvdata(pdev);
 	struct omap1_spi100k *spi100k = spi_master_get_devdata(master);
 
 	pm_runtime_disable(&pdev->dev);
@@ -440,7 +440,7 @@ static int omap1_spi100k_remove(struct platform_device *pdev)
 #ifdef CONFIG_PM
 static int omap1_spi100k_runtime_suspend(struct device *dev)
 {
-	struct spi_master *master = spi_master_get(dev_get_drvdata(dev));
+	struct spi_master *master = dev_get_drvdata(dev);
 	struct omap1_spi100k *spi100k = spi_master_get_devdata(master);
 
 	clk_disable_unprepare(spi100k->ick);
@@ -451,7 +451,7 @@ static int omap1_spi100k_runtime_suspend(struct device *dev)
 
 static int omap1_spi100k_runtime_resume(struct device *dev)
 {
-	struct spi_master *master = spi_master_get(dev_get_drvdata(dev));
+	struct spi_master *master = dev_get_drvdata(dev);
 	struct omap1_spi100k *spi100k = spi_master_get_devdata(master);
 	int ret;
 
-- 
2.30.2

