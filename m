Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7655370D19
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233120AbhEBOIh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:08:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:51334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232770AbhEBOH7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:07:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BD9B613C1;
        Sun,  2 May 2021 14:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964391;
        bh=v3Vd59VNV4GZOB3OwVKyYi0vtm3tkcdj3lsakjlC4Ug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cFo3g4j90RUvuJZFWYPB7Wp9y/ISddLagHtPWqqVC6NP2iXUOjrA4k2+boffNl9ZK
         4z++Nyl79gUDruBC0zOm460whNbwobjt62NTKMiAVX3HFtXXRWfVFNLP8vhY0ZoQtL
         qRjxhV1EMmGD8yZ4AZv7rojTD+zlfUyEHNbKJyZQo/F4Whbsl+trbsgD+iY+LHX5l/
         AOVn/RbDnJEkgdEkE29lIE1geqkOSERpQ/0fQF0cj9+ndG01yNjEAU+0lyO3mEFVYf
         IkkTb6zBIGlXRBwyF/A+5zyb2Smj7a0AV3ZJkkDQl2cwDQ/xDyLSA4Z6jZHcqTV7ie
         uZSna657amxZQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 06/10] spi: omap-100k: Fix reference leak to master
Date:   Sun,  2 May 2021 10:06:18 -0400
Message-Id: <20210502140623.2720479-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140623.2720479-1-sashal@kernel.org>
References: <20210502140623.2720479-1-sashal@kernel.org>
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
index 76a8425be227..1eccdc4a4581 100644
--- a/drivers/spi/spi-omap-100k.c
+++ b/drivers/spi/spi-omap-100k.c
@@ -435,7 +435,7 @@ static int omap1_spi100k_probe(struct platform_device *pdev)
 
 static int omap1_spi100k_remove(struct platform_device *pdev)
 {
-	struct spi_master *master = spi_master_get(platform_get_drvdata(pdev));
+	struct spi_master *master = platform_get_drvdata(pdev);
 	struct omap1_spi100k *spi100k = spi_master_get_devdata(master);
 
 	pm_runtime_disable(&pdev->dev);
@@ -449,7 +449,7 @@ static int omap1_spi100k_remove(struct platform_device *pdev)
 #ifdef CONFIG_PM
 static int omap1_spi100k_runtime_suspend(struct device *dev)
 {
-	struct spi_master *master = spi_master_get(dev_get_drvdata(dev));
+	struct spi_master *master = dev_get_drvdata(dev);
 	struct omap1_spi100k *spi100k = spi_master_get_devdata(master);
 
 	clk_disable_unprepare(spi100k->ick);
@@ -460,7 +460,7 @@ static int omap1_spi100k_runtime_suspend(struct device *dev)
 
 static int omap1_spi100k_runtime_resume(struct device *dev)
 {
-	struct spi_master *master = spi_master_get(dev_get_drvdata(dev));
+	struct spi_master *master = dev_get_drvdata(dev);
 	struct omap1_spi100k *spi100k = spi_master_get_devdata(master);
 	int ret;
 
-- 
2.30.2

