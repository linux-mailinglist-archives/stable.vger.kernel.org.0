Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E986D475EC2
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:26:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245492AbhLORYZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:24:25 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44652 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234660AbhLORX6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:23:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 438AE619DD;
        Wed, 15 Dec 2021 17:23:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A8B5C36AE3;
        Wed, 15 Dec 2021 17:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639589037;
        bh=7nfrDWaJfCPiO3lAwswAj5ZbLTewMnU2tdwfUmRCoCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ogLerrs/v8J+rwpzT4p5CAX3NtefjE4N0J7iJ2KAIul8blaN0hysIeu7/hNOOrDRm
         75+HKECO2VGkXFsU0wmvUHQCL+I/MGFQ+KKLhj5RfgExzGKVvVJl+zmyOYJ7Drv9we
         LMIxpjd2Z97Mm/2GqUeT2XN0PbR+uSlRRouR5QV8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nikita Yushchenko <nikita.yoush@cogentembedded.com>
Subject: [PATCH 5.15 40/42] staging: most: dim2: use device release method
Date:   Wed, 15 Dec 2021 18:21:21 +0100
Message-Id: <20211215172028.015339773@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211215172026.641863587@linuxfoundation.org>
References: <20211215172026.641863587@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikita Yushchenko <nikita.yoush@cogentembedded.com>

commit d445aa402d60014a37a199fae2bba379696b007d upstream.

Commit 723de0f9171e ("staging: most: remove device from interface
structure") moved registration of driver-provided struct device to
the most subsystem. This updated dim2 driver as well.

However, struct device passed to register_device() becomes refcounted,
and must not be explicitly deallocated, but must provide release method
instead. Which is incompatible with managing it via devres.

This patch makes the device structure allocated without devres, adds
device release method, and moves device destruction there.

Fixes: 723de0f9171e ("staging: most: remove device from interface structure")
Signed-off-by: Nikita Yushchenko <nikita.yoush@cogentembedded.com>
Link: https://lore.kernel.org/r/20211005143448.8660-2-nikita.yoush@cogentembedded.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/most/dim2/dim2.c |   55 +++++++++++++++++++++------------------
 1 file changed, 30 insertions(+), 25 deletions(-)

--- a/drivers/staging/most/dim2/dim2.c
+++ b/drivers/staging/most/dim2/dim2.c
@@ -726,6 +726,23 @@ static int get_dim2_clk_speed(const char
 	return -EINVAL;
 }
 
+static void dim2_release(struct device *d)
+{
+	struct dim2_hdm *dev = container_of(d, struct dim2_hdm, dev);
+	unsigned long flags;
+
+	kthread_stop(dev->netinfo_task);
+
+	spin_lock_irqsave(&dim_lock, flags);
+	dim_shutdown();
+	spin_unlock_irqrestore(&dim_lock, flags);
+
+	if (dev->disable_platform)
+		dev->disable_platform(to_platform_device(d->parent));
+
+	kfree(dev);
+}
+
 /*
  * dim2_probe - dim2 probe handler
  * @pdev: platform device structure
@@ -746,7 +763,7 @@ static int dim2_probe(struct platform_de
 
 	enum { MLB_INT_IDX, AHB0_INT_IDX };
 
-	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 	if (!dev)
 		return -ENOMEM;
 
@@ -758,25 +775,27 @@ static int dim2_probe(struct platform_de
 				      "microchip,clock-speed", &clock_speed);
 	if (ret) {
 		dev_err(&pdev->dev, "missing dt property clock-speed\n");
-		return ret;
+		goto err_free_dev;
 	}
 
 	ret = get_dim2_clk_speed(clock_speed, &dev->clk_speed);
 	if (ret) {
 		dev_err(&pdev->dev, "bad dt property clock-speed\n");
-		return ret;
+		goto err_free_dev;
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	dev->io_base = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(dev->io_base))
-		return PTR_ERR(dev->io_base);
+	if (IS_ERR(dev->io_base)) {
+		ret = PTR_ERR(dev->io_base);
+		goto err_free_dev;
+	}
 
 	of_id = of_match_node(dim2_of_match, pdev->dev.of_node);
 	pdata = of_id->data;
 	ret = pdata && pdata->enable ? pdata->enable(pdev) : 0;
 	if (ret)
-		return ret;
+		goto err_free_dev;
 
 	dev->disable_platform = pdata ? pdata->disable : NULL;
 
@@ -867,24 +886,19 @@ static int dim2_probe(struct platform_de
 	dev->most_iface.request_netinfo = request_netinfo;
 	dev->most_iface.driver_dev = &pdev->dev;
 	dev->most_iface.dev = &dev->dev;
-	dev->dev.init_name = "dim2_state";
+	dev->dev.init_name = dev->name;
 	dev->dev.parent = &pdev->dev;
+	dev->dev.release = dim2_release;
 
-	ret = most_register_interface(&dev->most_iface);
-	if (ret) {
-		dev_err(&pdev->dev, "failed to register MOST interface\n");
-		goto err_stop_thread;
-	}
-
-	return 0;
+	return most_register_interface(&dev->most_iface);
 
-err_stop_thread:
-	kthread_stop(dev->netinfo_task);
 err_shutdown_dim:
 	dim_shutdown();
 err_disable_platform:
 	if (dev->disable_platform)
 		dev->disable_platform(pdev);
+err_free_dev:
+	kfree(dev);
 
 	return ret;
 }
@@ -898,17 +912,8 @@ err_disable_platform:
 static int dim2_remove(struct platform_device *pdev)
 {
 	struct dim2_hdm *dev = platform_get_drvdata(pdev);
-	unsigned long flags;
 
 	most_deregister_interface(&dev->most_iface);
-	kthread_stop(dev->netinfo_task);
-
-	spin_lock_irqsave(&dim_lock, flags);
-	dim_shutdown();
-	spin_unlock_irqrestore(&dim_lock, flags);
-
-	if (dev->disable_platform)
-		dev->disable_platform(pdev);
 
 	return 0;
 }


