Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0227633ADBB
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 09:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbhCOIkb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 04:40:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54001 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbhCOIkY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 04:40:24 -0400
Received: from mail-wr1-f70.google.com ([209.85.221.70])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lLilz-0003sS-5F
        for stable@vger.kernel.org; Mon, 15 Mar 2021 08:40:23 +0000
Received: by mail-wr1-f70.google.com with SMTP id i5so14770466wrp.8
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 01:40:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xf8bhCsRM0V1EuSql+vGuq0de4RoNFAV+Vhdeoi39yI=;
        b=netXNGQsdVnzeAg90ao30By2BSvsDYxdK/5/k26xiuFR99q1IXQ7+rTfR2ivOOPEy8
         tNghhqf4roeDXmSsVcUHolOMsfVRUmWhUl1guUkmuK20uvJFXhs+0ByWtnY48X6ymfgl
         gCHOQobqz8ZwvQFhx2V+Na3vKVX0XngzFrKNm6Vlga6n5jmKAP5hcggOy6Lqm8l1QyLo
         Pbf95eKI5ikeCojbWtmYizslL/V8qN/19IVJYL8TN1PlG7qaoOBSWcXRjC2GQhRw4tAl
         /lQX3xpU7wSqAywjZNJ4LudF7EOfJCgzmd93qbVSWGah8HJL5LC4CoBH0PNlQ+BxmLw7
         iTKg==
X-Gm-Message-State: AOAM533PcV37+VIdqHEsT5YGHwtWwN8lXOBzbWasaJSnd3oByHaz5zKU
        FeMrreZ19IZpmIU6r4SDEUtQYPFgPj31EtYCuPQ05y334AXgvqEsTN/daWMOtETwGa8AD7g8aqX
        9SUr/RWoiPlT/B5WOB07AC0NqyDLrpwJr7w==
X-Received: by 2002:a5d:6d06:: with SMTP id e6mr26461691wrq.425.1615797622546;
        Mon, 15 Mar 2021 01:40:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxkdtTdcU97VvWlDIUEc3ApWmCU/C8ym3hsaVFlnK0HX0ing+kBF7eFoc0TzbqgQavlEHOYAw==
X-Received: by 2002:a5d:6d06:: with SMTP id e6mr26461684wrq.425.1615797622416;
        Mon, 15 Mar 2021 01:40:22 -0700 (PDT)
Received: from localhost.localdomain (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.gmail.com with ESMTPSA id r11sm18122324wrm.26.2021.03.15.01.40.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 01:40:22 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     stable@vger.kernel.org
Cc:     Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: [PATCH stable v4.4] media: hdpvr: Fix an error handling path in hdpvr_probe()
Date:   Mon, 15 Mar 2021 09:39:43 +0100
Message-Id: <20210315083943.11685-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arvind Yadav <arvind.yadav.cs@gmail.com>

commit c0f71bbb810237a38734607ca4599632f7f5d47f upstream.

Here, hdpvr_register_videodev() is responsible for setup and
register a video device. Also defining and initializing a worker.
hdpvr_register_videodev() is calling by hdpvr_probe at last.
So no need to flush any work here.
Unregister v4l2, free buffers and memory. If hdpvr_probe() will fail.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
Reported-by: Andrey Konovalov <andreyknvl@google.com>
Tested-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
[krzk: backport to v4.4, still using single thread workqueue which
       is drained/destroyed now in proper step so it cannot be NULL]
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

---

Backport needed for v4.4. v4.9 has it already.
---
 drivers/media/usb/hdpvr/hdpvr-core.c | 33 ++++++++++++++++------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/drivers/media/usb/hdpvr/hdpvr-core.c b/drivers/media/usb/hdpvr/hdpvr-core.c
index 7b5c493f02b0..9f95b048123d 100644
--- a/drivers/media/usb/hdpvr/hdpvr-core.c
+++ b/drivers/media/usb/hdpvr/hdpvr-core.c
@@ -297,7 +297,7 @@ static int hdpvr_probe(struct usb_interface *interface,
 	/* register v4l2_device early so it can be used for printks */
 	if (v4l2_device_register(&interface->dev, &dev->v4l2_dev)) {
 		dev_err(&interface->dev, "v4l2_device_register failed\n");
-		goto error;
+		goto error_free_dev;
 	}
 
 	mutex_init(&dev->io_mutex);
@@ -306,7 +306,7 @@ static int hdpvr_probe(struct usb_interface *interface,
 	dev->usbc_buf = kmalloc(64, GFP_KERNEL);
 	if (!dev->usbc_buf) {
 		v4l2_err(&dev->v4l2_dev, "Out of memory\n");
-		goto error;
+		goto error_v4l2_unregister;
 	}
 
 	init_waitqueue_head(&dev->wait_buffer);
@@ -314,7 +314,7 @@ static int hdpvr_probe(struct usb_interface *interface,
 
 	dev->workqueue = create_singlethread_workqueue("hdpvr_buffer");
 	if (!dev->workqueue)
-		goto error;
+		goto err_free_usbc;
 
 	dev->options = hdpvr_default_options;
 
@@ -348,13 +348,13 @@ static int hdpvr_probe(struct usb_interface *interface,
 	}
 	if (!dev->bulk_in_endpointAddr) {
 		v4l2_err(&dev->v4l2_dev, "Could not find bulk-in endpoint\n");
-		goto error;
+		goto error_put_usb;
 	}
 
 	/* init the device */
 	if (hdpvr_device_init(dev)) {
 		v4l2_err(&dev->v4l2_dev, "device init failed\n");
-		goto error;
+		goto error_put_usb;
 	}
 
 	mutex_lock(&dev->io_mutex);
@@ -362,7 +362,7 @@ static int hdpvr_probe(struct usb_interface *interface,
 		mutex_unlock(&dev->io_mutex);
 		v4l2_err(&dev->v4l2_dev,
 			 "allocating transfer buffers failed\n");
-		goto error;
+		goto error_put_usb;
 	}
 	mutex_unlock(&dev->io_mutex);
 
@@ -370,7 +370,7 @@ static int hdpvr_probe(struct usb_interface *interface,
 	retval = hdpvr_register_i2c_adapter(dev);
 	if (retval < 0) {
 		v4l2_err(&dev->v4l2_dev, "i2c adapter register failed\n");
-		goto error;
+		goto error_free_buffers;
 	}
 
 	client = hdpvr_register_ir_rx_i2c(dev);
@@ -412,15 +412,20 @@ static int hdpvr_probe(struct usb_interface *interface,
 reg_fail:
 #if IS_ENABLED(CONFIG_I2C)
 	i2c_del_adapter(&dev->i2c_adapter);
+error_free_buffers:
 #endif
+	hdpvr_free_buffers(dev);
+error_put_usb:
+	usb_put_dev(dev->udev);
+	/* Destroy single thread */
+	destroy_workqueue(dev->workqueue);
+err_free_usbc:
+	kfree(dev->usbc_buf);
+error_v4l2_unregister:
+	v4l2_device_unregister(&dev->v4l2_dev);
+error_free_dev:
+	kfree(dev);
 error:
-	if (dev) {
-		/* Destroy single thread */
-		if (dev->workqueue)
-			destroy_workqueue(dev->workqueue);
-		/* this frees allocated memory */
-		hdpvr_delete(dev);
-	}
 	return retval;
 }
 
-- 
2.25.1

