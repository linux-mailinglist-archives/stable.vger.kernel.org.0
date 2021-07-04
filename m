Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE793BB0D7
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231689AbhGDXJl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:09:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:47378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231702AbhGDXJD (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:09:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DEFE8613D2;
        Sun,  4 Jul 2021 23:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625439987;
        bh=WoXSq2ICM3efq+BWozC2CMUcabEJzzaMVOvVVaY7IjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rGISyhGcyW1TlPWZ8oa2hPaJ4lu4NunFuN/POpYLqqGA12Xuq0Vwahkc6yrEx/54J
         9HcUIw2btYeZqOHR3gvDc9jnq+Lupq6pTyiTRwem6jakNZ6pySPaEDgKfyoevo/R78
         72vtMZhrEMqh72kL2aJp8yDDT4ayTvjXA54g4HNduZ20+aHK/wm1q/NGv97nJY4MxR
         paTM4Bdf869dQBXRCB7gnzQx1yRiwIkRo16bjpZvnKlyFG5fkR10tKESZpAQJZ5gq9
         m2yQVkzFFplzyJy5KgkT0mhlUN9U9EPI0PkmCIxdqbP3xPOrtEhsPHfX1M0sSBXnbl
         OC9uEGnHgtMGg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 08/80] media: am437x: fix pm_runtime_get_sync() usage count
Date:   Sun,  4 Jul 2021 19:05:04 -0400
Message-Id: <20210704230616.1489200-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230616.1489200-1-sashal@kernel.org>
References: <20210704230616.1489200-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit c41e02493334985cca1a22efd5ca962ce3abb061 ]

The pm_runtime_get_sync() internally increments the
dev->power.usage_count without decrementing it, even on errors.
Replace it by the new pm_runtime_resume_and_get(), introduced by:
commit dd8088d5a896 ("PM: runtime: Add pm_runtime_resume_and_get to deal with usage counter")
in order to properly decrement the usage counter, avoiding
a potential PM usage counter leak.

While here, ensure that the driver will check if PM runtime
resumed at vpfe_initialize_device().

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/am437x/am437x-vpfe.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
index 6cdc77dda0e4..1c9cb9e05fdf 100644
--- a/drivers/media/platform/am437x/am437x-vpfe.c
+++ b/drivers/media/platform/am437x/am437x-vpfe.c
@@ -1021,7 +1021,9 @@ static int vpfe_initialize_device(struct vpfe_device *vpfe)
 	if (ret)
 		return ret;
 
-	pm_runtime_get_sync(vpfe->pdev);
+	ret = pm_runtime_resume_and_get(vpfe->pdev);
+	if (ret < 0)
+		return ret;
 
 	vpfe_config_enable(&vpfe->ccdc, 1);
 
@@ -2443,7 +2445,11 @@ static int vpfe_probe(struct platform_device *pdev)
 	pm_runtime_enable(&pdev->dev);
 
 	/* for now just enable it here instead of waiting for the open */
-	pm_runtime_get_sync(&pdev->dev);
+	ret = pm_runtime_resume_and_get(&pdev->dev);
+	if (ret < 0) {
+		vpfe_err(vpfe, "Unable to resume device.\n");
+		goto probe_out_v4l2_unregister;
+	}
 
 	vpfe_ccdc_config_defaults(ccdc);
 
@@ -2530,6 +2536,11 @@ static int vpfe_suspend(struct device *dev)
 
 	/* only do full suspend if streaming has started */
 	if (vb2_start_streaming_called(&vpfe->buffer_queue)) {
+		/*
+		 * ignore RPM resume errors here, as it is already too late.
+		 * A check like that should happen earlier, either at
+		 * open() or just before start streaming.
+		 */
 		pm_runtime_get_sync(dev);
 		vpfe_config_enable(ccdc, 1);
 
-- 
2.30.2

