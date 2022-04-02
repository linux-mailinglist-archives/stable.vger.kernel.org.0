Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82D614F01B1
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 14:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354780AbiDBMyz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 08:54:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237323AbiDBMyy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 08:54:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E7818C0C9
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 05:53:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54C20B80159
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 12:53:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0C22C340EC;
        Sat,  2 Apr 2022 12:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648903980;
        bh=I2PCNsiBQeP6Y/QHcCOTAGg63r/Q4SvsOO7aaqPAg84=;
        h=Subject:To:Cc:From:Date:From;
        b=LCgFUj3PmnBFcqn2G8jA0z1iNVa/hS4meBH4zJPo89+12sbbjm8OOUXALQJYxocia
         LO0vj+ScJCImsV1H03rfEGTDcukLHuG5p8qdnAzTRG3l/HQSYD55UPsBiZFnrQGAwN
         0ZoYoRECoWmqYVivjIjC0YrHbkE5bJq4u9VWP8Nc=
Subject: FAILED: patch "[PATCH] media: davinci: vpif: fix use-after-free on driver unbind" failed to apply to 5.4-stable tree
To:     johan@kernel.org, hverkuil-cisco@xs4all.nl, khilman@baylibre.com,
        mchehab@kernel.org, prabhakar.csengg@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 02 Apr 2022 14:52:47 +0200
Message-ID: <1648903967249162@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 43acb728bbc40169d2e2425e84a80068270974be Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Wed, 22 Dec 2021 15:20:24 +0100
Subject: [PATCH] media: davinci: vpif: fix use-after-free on driver unbind

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
 

