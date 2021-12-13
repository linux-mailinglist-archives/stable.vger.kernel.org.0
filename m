Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0424733B9
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 19:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241489AbhLMSOC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 13:14:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240069AbhLMSOC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 13:14:02 -0500
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6BF3C061574
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 10:14:01 -0800 (PST)
Received: by mail-lj1-x242.google.com with SMTP id u22so24888472lju.7
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 10:14:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zaib0DC5AMB+kONLt161AeYReUJW8kK/6r16KtYxd8o=;
        b=h6I7nCwf6huxCzCdKBoPxyLB7gObeO9FBjaQPGardPcX9dybJyxEaQWtttzBAkXatY
         lcF5cNEb26G7E4FlYXspWUsOTindhKjuyUUZo5kexgxFcHEbE/FR+2x2aFGj+s5brrOj
         l0n7ROKySzIMb4uVvslNx7Jp6QGGVl/V4OpRHbrcpUg3GFogt3b87MWumcMqORQ0LcAg
         tS80LIoHsB3jw94PLClpFNm5zfBi/M6qzNLyGT1h3xu6GPHfIR0zvn1A0pjJLO0esbnI
         nytIrTaGXWuK80cbeL8Sq7aFbylgK6+OasH19fPu84HkFU56N6QulWgczmHO0Gdsd5wm
         azMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zaib0DC5AMB+kONLt161AeYReUJW8kK/6r16KtYxd8o=;
        b=QwzOQMIFyUnnkSzSbv3IKyddDrTzCx1kkdofe2NBxwuBCKxrCq50XGD9E2GWfOMOFJ
         RwRf6TkjlW1ofcV2LlzgEIAUGi5ruWc1qExGkl9sZD8oPi+Dqm8TG6ZKTVkb+dKcqNCo
         dw5WpMI87/XqQA8rTzYz+mfD+mU7YqPE7/iqxho7TrZ7juQ3fsGtf0SUFe6GnJ8RQ+Wk
         YXB64htxanzfqX1qiu7XLvMMNX73j0UxwH9xCznomL7ZOxbVZUocJPneB0Awms2vshfD
         MFPmbqMgsc36Phzsg8BYyvCb0mrLHOaBRb+YoL3Wy4+/kNXn01q7ktVFsr6KAez2hXhD
         yjkQ==
X-Gm-Message-State: AOAM533W3H8iD8EevV1vqB8DGUma14mjm0ptOwkXbFAb1YUXTCRTYfdr
        6R6JFjJpTpQ69dxJZYumjMsqZn2IiIvRUynI
X-Google-Smtp-Source: ABdhPJzxG6yvsZL3W3ztsVmh9ywJz8g5AezaPD0gfWOHuqUWEfeolUamhlvOAncYcN0lVIaeEJpREw==
X-Received: by 2002:a2e:8502:: with SMTP id j2mr121670lji.191.1639419239917;
        Mon, 13 Dec 2021 10:13:59 -0800 (PST)
Received: from cobook.home (nikaet.starlink.ru. [94.141.168.29])
        by smtp.gmail.com with ESMTPSA id p20sm1514388lfu.151.2021.12.13.10.13.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 10:13:59 -0800 (PST)
From:   Nikita Yushchenko <nikita.yoush@cogentembedded.com>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, nikita.yoush@cogentembedded.com
Subject: [PATCH 5.15] staging: most: dim2: use device release method
Date:   Mon, 13 Dec 2021 21:13:46 +0300
Message-Id: <20211213181346.989171-1-nikita.yoush@cogentembedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <163774098420119@kroah.com>
References: <163774098420119@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Upstream commit d445aa402d60014a37a199fae2bba379696b007d.

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
 drivers/staging/most/dim2/dim2.c | 55 +++++++++++++++++---------------
 1 file changed, 30 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/most/dim2/dim2.c b/drivers/staging/most/dim2/dim2.c
index b72d7b9b45ea..81e062009d27 100644
--- a/drivers/staging/most/dim2/dim2.c
+++ b/drivers/staging/most/dim2/dim2.c
@@ -726,6 +726,23 @@ static int get_dim2_clk_speed(const char *clock_speed, u8 *val)
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
@@ -746,7 +763,7 @@ static int dim2_probe(struct platform_device *pdev)
 
 	enum { MLB_INT_IDX, AHB0_INT_IDX };
 
-	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 	if (!dev)
 		return -ENOMEM;
 
@@ -758,25 +775,27 @@ static int dim2_probe(struct platform_device *pdev)
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
 
@@ -867,24 +886,19 @@ static int dim2_probe(struct platform_device *pdev)
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
@@ -898,17 +912,8 @@ static int dim2_probe(struct platform_device *pdev)
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
-- 
2.30.2

