Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B301345B621
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 09:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240965AbhKXIGQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 03:06:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:59042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240972AbhKXIGQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 03:06:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8221160F5B;
        Wed, 24 Nov 2021 08:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637740987;
        bh=eUUTb4MA++G0X8hJsDBH+pQHmF9U6FlkfNB24uMyvGY=;
        h=Subject:To:Cc:From:Date:From;
        b=aNFxJnqUtUbW5lKo+tk9CR2d6GdVIqoQYrlzceNLfc9wvvzbmEhVLpb4G+k8J+0yf
         9Bb522kmLcwfifCqtqHl89RiDqDJ4eStwlk4Ode3HU2lbMg9mvR2ctJLLtCEbEoLtv
         iwezOdbYgac5n+nHD+GzeZ/LhdIXs3ReXgM8d6Rk=
Subject: FAILED: patch "[PATCH] staging: most: dim2: use device release method" failed to apply to 5.15-stable tree
To:     nikita.yoush@cogentembedded.com, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 24 Nov 2021 09:03:04 +0100
Message-ID: <163774098420119@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d445aa402d60014a37a199fae2bba379696b007d Mon Sep 17 00:00:00 2001
From: Nikita Yushchenko <nikita.yoush@cogentembedded.com>
Date: Tue, 5 Oct 2021 17:34:50 +0300
Subject: [PATCH] staging: most: dim2: use device release method

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

diff --git a/drivers/staging/most/dim2/dim2.c b/drivers/staging/most/dim2/dim2.c
index 96cb5280a385..bd102329d8c8 100644
--- a/drivers/staging/most/dim2/dim2.c
+++ b/drivers/staging/most/dim2/dim2.c
@@ -727,6 +727,23 @@ static int get_dim2_clk_speed(const char *clock_speed, u8 *val)
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
@@ -748,7 +765,7 @@ static int dim2_probe(struct platform_device *pdev)
 
 	enum { MLB_INT_IDX, AHB0_INT_IDX };
 
-	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 	if (!dev)
 		return -ENOMEM;
 
@@ -760,19 +777,21 @@ static int dim2_probe(struct platform_device *pdev)
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
@@ -780,7 +799,7 @@ static int dim2_probe(struct platform_device *pdev)
 		if (pdata->enable) {
 			ret = pdata->enable(pdev);
 			if (ret)
-				return ret;
+				goto err_free_dev;
 		}
 		dev->disable_platform = pdata->disable;
 		if (pdata->fcnt)
@@ -875,24 +894,19 @@ static int dim2_probe(struct platform_device *pdev)
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
@@ -906,17 +920,8 @@ static int dim2_probe(struct platform_device *pdev)
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

