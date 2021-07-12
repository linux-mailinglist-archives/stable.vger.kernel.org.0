Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 990263C4C65
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240492AbhGLHDq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:03:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:38850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238740AbhGLHDP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:03:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 807F261179;
        Mon, 12 Jul 2021 07:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073226;
        bh=WoXSq2ICM3efq+BWozC2CMUcabEJzzaMVOvVVaY7IjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f7OWhYsolup26BykEvAQaEm32zt65pTK+6XxrEuYJcm3X/zDyxxEnbDnywuzjwn3V
         IuJiDBfc+ezVNwki1vzLbAmnsOFzmGB0W2esAk1fxWCltSFLEiWUtZmi0S/lIqepEh
         oe4Rso5AbBj5tj6bvgS//RaTuLbS83qLs3OA0/ZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 126/700] media: am437x: fix pm_runtime_get_sync() usage count
Date:   Mon, 12 Jul 2021 08:03:29 +0200
Message-Id: <20210712060942.896282067@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



