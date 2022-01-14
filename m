Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72F8348E6D9
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 09:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbiANIte (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 03:49:34 -0500
Received: from www.linuxtv.org ([130.149.80.248]:35578 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234110AbiANIte (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jan 2022 03:49:34 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1n8IH5-008taA-4R; Fri, 14 Jan 2022 08:49:31 +0000
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
Date:   Fri, 14 Jan 2022 08:38:21 +0000
Subject: [git:media_stage/master] media: davinci: vpif: fix use-after-free on driver unbind
To:     linuxtv-commits@linuxtv.org
Cc:     Kevin Hilman <khilman@baylibre.com>,
        Johan Hovold <johan@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Lad Prabhakar <prabhakar.csengg@gmail.com>,
        stable@vger.kernel.org
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1n8IH5-008taA-4R@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: davinci: vpif: fix use-after-free on driver unbind
Author:  Johan Hovold <johan@kernel.org>
Date:    Wed Dec 22 15:20:24 2021 +0100

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
Reviewed-by: Lad Prabhakar <prabhakar.csengg@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>

 drivers/media/platform/davinci/vpif.c | 97 +++++++++++++++++++++++++----------
 1 file changed, 71 insertions(+), 26 deletions(-)

---

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
 
