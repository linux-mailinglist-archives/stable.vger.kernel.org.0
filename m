Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B26FF38A289
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233595AbhETJm6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:42:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:41904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233264AbhETJkv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:40:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E6CF613DF;
        Thu, 20 May 2021 09:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503108;
        bh=QBZqKVw6Nhg0ITauxEPrGNp9cJHc/wNuEH+9A0vdLo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i3CtCmFXzHon4A7F2F8yspLkHWRmjzTJEAD1+tER0VlogGX3DhC6Q3+ULIU8VNTUO
         w3bfllN7AOuK0vn9nEDzF6SkXZWvLudto5nMMhdsX4upeFgbqist7GQyCoS4NWS+I8
         nyUbCniXe6FPjrTIwQnsOh6FH4IQ5uFYoaamFSVM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 038/425] spi: omap-100k: Fix reference leak to master
Date:   Thu, 20 May 2021 11:16:47 +0200
Message-Id: <20210520092132.672846295@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
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
index 76a8425be227..1eccdc4a4581 100644
--- a/drivers/spi/spi-omap-100k.c
+++ b/drivers/spi/spi-omap-100k.c
@@ -435,7 +435,7 @@ err:
 
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



