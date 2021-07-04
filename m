Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C07C3BAFE0
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbhGDXHL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:07:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:45084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229947AbhGDXHI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:07:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C407613E5;
        Sun,  4 Jul 2021 23:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625439872;
        bh=WoXSq2ICM3efq+BWozC2CMUcabEJzzaMVOvVVaY7IjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aREna3O+4UGJW9FKim2GJlkyvP9+rDlSC8kQrTFjn3X8iZfany1Az8CR9qAl4vVMc
         RZPRWogWyVX8BxQqrsXVc3g3oKGGQYd4x0PZo2Dy5OVTYjnh0jX8Gl1y6FH/f7kVA8
         EbZnmXsdzA37BUDJUDnzQ0PCxPA5lSz4uRBDmj2qufifQQFBUIu9zvn1iK1SLwbk/2
         9aDXPtqNAUg08nSO8WrS4Nd5kc3SK7Ny7DGOUZVJqla3o9rDiQCRyjZlF104asrDTH
         tmgI6v+9VO/6VKyI9wKkWW1CdCZsE8s/JfxgirIKPWcpPVnLgTMqHHGDxtOCjiSH8L
         Hi3IFt8f3KeZw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 08/85] media: am437x: fix pm_runtime_get_sync() usage count
Date:   Sun,  4 Jul 2021 19:03:03 -0400
Message-Id: <20210704230420.1488358-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230420.1488358-1-sashal@kernel.org>
References: <20210704230420.1488358-1-sashal@kernel.org>
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

