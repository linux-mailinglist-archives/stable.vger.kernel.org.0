Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7B247D387
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 15:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245670AbhLVOUz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 09:20:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237093AbhLVOUx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Dec 2021 09:20:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A9DC061574;
        Wed, 22 Dec 2021 06:20:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6F2B61AE4;
        Wed, 22 Dec 2021 14:20:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B735C36AEC;
        Wed, 22 Dec 2021 14:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640182852;
        bh=GH8ZhuVCZyxWDQtV2NsW9yVCJnRzBkxIGGv9E/ld4eQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pA0JFQIOx/0bkHM6KmThO17osjriKyZev8M4Z9JwbCfIHyup7y3DVHOeNwcotJNuo
         dtG1+h4yfhm3Vl3bzvskkmGkmEkl3ucrTzdAjHGaFhLws/WUHmPxoafnpzb95HHDHd
         1nSjmt6WKQZExdF9xAbr2k9Rmru2wNNsAcVUhtf3cfUIfEd+vfGmSDW9znB1B4YaQs
         crPy24YcFjnma5NHn1LyHHr/vha9MxXUtKyDtxJBr3/OcZGXruAWlIUmlS9dQ/kd6q
         xXSYVN7tC25tUaqvEXDk+poZcMTCEN1bh+0TD6iBL3eXC+tzZq5rtiSEUNYyvnIsVx
         80aB1yXzpV+mA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1n02U0-0007uo-RF; Wed, 22 Dec 2021 15:20:44 +0100
From:   Johan Hovold <johan@kernel.org>
To:     "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 3/4] media: davinci: vpif: fix use-after-free on driver unbind
Date:   Wed, 22 Dec 2021 15:20:24 +0100
Message-Id: <20211222142025.30364-4-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211222142025.30364-1-johan@kernel.org>
References: <20211222142025.30364-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The driver allocates and registers two platform device structures during
probe, but the devices were never deregistered on driver unbind.

This results in a use-after-free on driver unbind as the device
structures were allocated using devres and would be freed by driver
core when remove() returns.

Fix this by adding the missing deregistration calls to the remove()
callback and failing probe on registration errors.

Note that the platform device structures must be freed using a proper
release callback to avoid leaking associated resources like device
names.

Fixes: 479f7a118105 ("[media] davinci: vpif: adaptions for DT support")
Cc: stable@vger.kernel.org      # 4.12
Cc: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/media/platform/davinci/vpif.c | 97 ++++++++++++++++++++-------
 1 file changed, 71 insertions(+), 26 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif.c b/drivers/media/platform/davinci/vpif.c
index 1f5eacf48580..4a260f4ed236 100644
--- a/drivers/media/platform/davinci/vpif.c
+++ b/drivers/media/platform/davinci/vpif.c
@@ -41,6 +41,11 @@ MODULE_ALIAS("platform:" VPIF_DRIVER_NAME);
 #define VPIF_CH2_MAX_MODES	15
 #define VPIF_CH3_MAX_MODES	2
 
+struct vpif_data {
+	struct platform_device *capture;
+	struct platform_device *display;
+};
+
 DEFINE_SPINLOCK(vpif_lock);
 EXPORT_SYMBOL_GPL(vpif_lock);
 
@@ -423,17 +428,31 @@ int vpif_channel_getfid(u8 channel_id)
 }
 EXPORT_SYMBOL(vpif_channel_getfid);
 
+static void vpif_pdev_release(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+
+	kfree(pdev);
+}
+
 static int vpif_probe(struct platform_device *pdev)
 {
 	static struct resource *res_irq;
 	struct platform_device *pdev_capture, *pdev_display;
 	struct device_node *endpoint = NULL;
+	struct vpif_data *data;
 	int ret;
 
 	vpif_base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(vpif_base))
 		return PTR_ERR(vpif_base);
 
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, data);
+
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_get(&pdev->dev);
 
@@ -461,49 +480,75 @@ static int vpif_probe(struct platform_device *pdev)
 		goto err_put_rpm;
 	}
 
-	pdev_capture = devm_kzalloc(&pdev->dev, sizeof(*pdev_capture),
-				    GFP_KERNEL);
-	if (pdev_capture) {
-		pdev_capture->name = "vpif_capture";
-		pdev_capture->id = -1;
-		pdev_capture->resource = res_irq;
-		pdev_capture->num_resources = 1;
-		pdev_capture->dev.dma_mask = pdev->dev.dma_mask;
-		pdev_capture->dev.coherent_dma_mask = pdev->dev.coherent_dma_mask;
-		pdev_capture->dev.parent = &pdev->dev;
-		platform_device_register(pdev_capture);
-	} else {
-		dev_warn(&pdev->dev, "Unable to allocate memory for pdev_capture.\n");
+	pdev_capture = kzalloc(sizeof(*pdev_capture), GFP_KERNEL);
+	if (!pdev_capture) {
+		ret = -ENOMEM;
+		goto err_put_rpm;
 	}
 
-	pdev_display = devm_kzalloc(&pdev->dev, sizeof(*pdev_display),
-				    GFP_KERNEL);
-	if (pdev_display) {
-		pdev_display->name = "vpif_display";
-		pdev_display->id = -1;
-		pdev_display->resource = res_irq;
-		pdev_display->num_resources = 1;
-		pdev_display->dev.dma_mask = pdev->dev.dma_mask;
-		pdev_display->dev.coherent_dma_mask = pdev->dev.coherent_dma_mask;
-		pdev_display->dev.parent = &pdev->dev;
-		platform_device_register(pdev_display);
-	} else {
-		dev_warn(&pdev->dev, "Unable to allocate memory for pdev_display.\n");
+	pdev_capture->name = "vpif_capture";
+	pdev_capture->id = -1;
+	pdev_capture->resource = res_irq;
+	pdev_capture->num_resources = 1;
+	pdev_capture->dev.dma_mask = pdev->dev.dma_mask;
+	pdev_capture->dev.coherent_dma_mask = pdev->dev.coherent_dma_mask;
+	pdev_capture->dev.parent = &pdev->dev;
+	pdev_capture->dev.release = vpif_pdev_release;
+
+	ret = platform_device_register(pdev_capture);
+	if (ret)
+		goto err_put_pdev_capture;
+
+	pdev_display = kzalloc(sizeof(*pdev_display), GFP_KERNEL);
+	if (!pdev_display) {
+		ret = -ENOMEM;
+		goto err_put_pdev_capture;
 	}
 
+	pdev_display->name = "vpif_display";
+	pdev_display->id = -1;
+	pdev_display->resource = res_irq;
+	pdev_display->num_resources = 1;
+	pdev_display->dev.dma_mask = pdev->dev.dma_mask;
+	pdev_display->dev.coherent_dma_mask = pdev->dev.coherent_dma_mask;
+	pdev_display->dev.parent = &pdev->dev;
+	pdev_display->dev.release = vpif_pdev_release;
+
+	ret = platform_device_register(pdev_display);
+	if (ret)
+		goto err_put_pdev_display;
+
+	data->capture = pdev_capture;
+	data->display = pdev_display;
+
 	return 0;
 
+err_put_pdev_display:
+	platform_device_put(pdev_display);
+err_put_pdev_capture:
+	platform_device_put(pdev_capture);
 err_put_rpm:
 	pm_runtime_put(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
+	kfree(data);
 
 	return ret;
 }
 
 static int vpif_remove(struct platform_device *pdev)
 {
+	struct vpif_data *data = platform_get_drvdata(pdev);
+
+	if (data->capture)
+		platform_device_unregister(data->capture);
+	if (data->display)
+		platform_device_unregister(data->display);
+
 	pm_runtime_put(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
+
+	kfree(data);
+
 	return 0;
 }
 
-- 
2.32.0

