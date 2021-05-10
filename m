Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3310C3785C6
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233696AbhEJLBs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:01:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:52738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234621AbhEJK4m (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:56:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB9C3619A2;
        Mon, 10 May 2021 10:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643664;
        bh=FttGwYaSIgG6fv2sUVh7IrDsD4nL5zQvyWLAq59Tb/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QgsLRdvh75+9P2f1IcaJdo7m2sQQj4XfHtp/fM0PEj1l7aOR5+K/x7UhUXyqgZh9E
         288CsQiqwaNRyb4paQtdYSCE9JtaYeyhZ+GqEmkek3EHt9IdetmmZd2uZLv+entTPc
         s7gwcLx/3A1ISrLFIX0Z614+R7X0mVBLfutmv6Ak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 108/342] spi: omap-100k: Fix reference leak to master
Date:   Mon, 10 May 2021 12:18:18 +0200
Message-Id: <20210510102013.660688703@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 36a4922a134a..ccd817ee4917 100644
--- a/drivers/spi/spi-omap-100k.c
+++ b/drivers/spi/spi-omap-100k.c
@@ -424,7 +424,7 @@ err:
 
 static int omap1_spi100k_remove(struct platform_device *pdev)
 {
-	struct spi_master *master = spi_master_get(platform_get_drvdata(pdev));
+	struct spi_master *master = platform_get_drvdata(pdev);
 	struct omap1_spi100k *spi100k = spi_master_get_devdata(master);
 
 	pm_runtime_disable(&pdev->dev);
@@ -438,7 +438,7 @@ static int omap1_spi100k_remove(struct platform_device *pdev)
 #ifdef CONFIG_PM
 static int omap1_spi100k_runtime_suspend(struct device *dev)
 {
-	struct spi_master *master = spi_master_get(dev_get_drvdata(dev));
+	struct spi_master *master = dev_get_drvdata(dev);
 	struct omap1_spi100k *spi100k = spi_master_get_devdata(master);
 
 	clk_disable_unprepare(spi100k->ick);
@@ -449,7 +449,7 @@ static int omap1_spi100k_runtime_suspend(struct device *dev)
 
 static int omap1_spi100k_runtime_resume(struct device *dev)
 {
-	struct spi_master *master = spi_master_get(dev_get_drvdata(dev));
+	struct spi_master *master = dev_get_drvdata(dev);
 	struct omap1_spi100k *spi100k = spi_master_get_devdata(master);
 	int ret;
 
-- 
2.30.2



