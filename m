Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10A1466761E
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:29:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236366AbjALO3A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:29:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237273AbjALO2C (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:28:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96D9358339
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:19:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3582D60C01
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:19:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C033C433F1;
        Thu, 12 Jan 2023 14:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533148;
        bh=eiyuaj8byxfRgAUFTJQGLTputhXg+4zE8p2pXqcnAvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a/jlpahZpngyEM84ln+G6KyFVn12CmtD2Lze1bvz12wv1RMcb6fS/HIbiJ+JE5OtP
         aN+AVUWQVHiHRs3ppdr2R4blwr3163xrpNvdpSJxj5m7pxTGcyOezohGzsQKWOPJm3
         5CMzESYbrwvqCYeSgiWyE1ZjVqe8sV62HZXK4efQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 386/783] gpiolib: Get rid of redundant else
Date:   Thu, 12 Jan 2023 14:51:42 +0100
Message-Id: <20230112135542.198228645@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 1cef8b5019769d46725932eeace7a383bca97905 ]

In the snippets like the following

	if (...)
		return / goto / break / continue ...;
	else
		...

the 'else' is redundant. Get rid of it. In case of IOCTLs use
switch-case pattern that seems the usual in such cases.

While at it, clarify necessity of else in gpiod_direction_output()
by attaching else if to the closing curly brace on a previous line.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Stable-dep-of: 533aae7c94db ("gpiolib: cdev: fix NULL-pointer dereferences")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-cdev.c | 66 ++++++++++++++++++++-----------------
 drivers/gpio/gpiolib.c      | 12 +++----
 2 files changed, 40 insertions(+), 38 deletions(-)

diff --git a/drivers/gpio/gpiolib-cdev.c b/drivers/gpio/gpiolib-cdev.c
index 381cfa26a4a1..b51b4d7a611e 100644
--- a/drivers/gpio/gpiolib-cdev.c
+++ b/drivers/gpio/gpiolib-cdev.c
@@ -197,16 +197,15 @@ static long linehandle_ioctl(struct file *file, unsigned int cmd,
 	void __user *ip = (void __user *)arg;
 	struct gpiohandle_data ghd;
 	DECLARE_BITMAP(vals, GPIOHANDLES_MAX);
-	int i;
+	unsigned int i;
+	int ret;
 
-	if (cmd == GPIOHANDLE_GET_LINE_VALUES_IOCTL) {
-		/* NOTE: It's ok to read values of output lines. */
-		int ret = gpiod_get_array_value_complex(false,
-							true,
-							lh->num_descs,
-							lh->descs,
-							NULL,
-							vals);
+	switch (cmd) {
+	case GPIOHANDLE_GET_LINE_VALUES_IOCTL:
+		/* NOTE: It's okay to read values of output lines */
+		ret = gpiod_get_array_value_complex(false, true,
+						    lh->num_descs, lh->descs,
+						    NULL, vals);
 		if (ret)
 			return ret;
 
@@ -218,7 +217,7 @@ static long linehandle_ioctl(struct file *file, unsigned int cmd,
 			return -EFAULT;
 
 		return 0;
-	} else if (cmd == GPIOHANDLE_SET_LINE_VALUES_IOCTL) {
+	case GPIOHANDLE_SET_LINE_VALUES_IOCTL:
 		/*
 		 * All line descriptors were created at once with the same
 		 * flags so just check if the first one is really output.
@@ -240,10 +239,11 @@ static long linehandle_ioctl(struct file *file, unsigned int cmd,
 						     lh->descs,
 						     NULL,
 						     vals);
-	} else if (cmd == GPIOHANDLE_SET_CONFIG_IOCTL) {
+	case GPIOHANDLE_SET_CONFIG_IOCTL:
 		return linehandle_set_config(lh, ip);
+	default:
+		return -EINVAL;
 	}
-	return -EINVAL;
 }
 
 #ifdef CONFIG_COMPAT
@@ -1165,14 +1165,16 @@ static long linereq_ioctl(struct file *file, unsigned int cmd,
 	struct linereq *lr = file->private_data;
 	void __user *ip = (void __user *)arg;
 
-	if (cmd == GPIO_V2_LINE_GET_VALUES_IOCTL)
+	switch (cmd) {
+	case GPIO_V2_LINE_GET_VALUES_IOCTL:
 		return linereq_get_values(lr, ip);
-	else if (cmd == GPIO_V2_LINE_SET_VALUES_IOCTL)
+	case GPIO_V2_LINE_SET_VALUES_IOCTL:
 		return linereq_set_values(lr, ip);
-	else if (cmd == GPIO_V2_LINE_SET_CONFIG_IOCTL)
+	case GPIO_V2_LINE_SET_CONFIG_IOCTL:
 		return linereq_set_config(lr, ip);
-
-	return -EINVAL;
+	default:
+		return -EINVAL;
+	}
 }
 
 #ifdef CONFIG_COMPAT
@@ -2095,28 +2097,30 @@ static long gpio_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		return -ENODEV;
 
 	/* Fill in the struct and pass to userspace */
-	if (cmd == GPIO_GET_CHIPINFO_IOCTL) {
+	switch (cmd) {
+	case GPIO_GET_CHIPINFO_IOCTL:
 		return chipinfo_get(cdev, ip);
 #ifdef CONFIG_GPIO_CDEV_V1
-	} else if (cmd == GPIO_GET_LINEHANDLE_IOCTL) {
+	case GPIO_GET_LINEHANDLE_IOCTL:
 		return linehandle_create(gdev, ip);
-	} else if (cmd == GPIO_GET_LINEEVENT_IOCTL) {
+	case GPIO_GET_LINEEVENT_IOCTL:
 		return lineevent_create(gdev, ip);
-	} else if (cmd == GPIO_GET_LINEINFO_IOCTL ||
-		   cmd == GPIO_GET_LINEINFO_WATCH_IOCTL) {
-		return lineinfo_get_v1(cdev, ip,
-				       cmd == GPIO_GET_LINEINFO_WATCH_IOCTL);
+	case GPIO_GET_LINEINFO_IOCTL:
+		return lineinfo_get_v1(cdev, ip, false);
+	case GPIO_GET_LINEINFO_WATCH_IOCTL:
+		return lineinfo_get_v1(cdev, ip, true);
 #endif /* CONFIG_GPIO_CDEV_V1 */
-	} else if (cmd == GPIO_V2_GET_LINEINFO_IOCTL ||
-		   cmd == GPIO_V2_GET_LINEINFO_WATCH_IOCTL) {
-		return lineinfo_get(cdev, ip,
-				    cmd == GPIO_V2_GET_LINEINFO_WATCH_IOCTL);
-	} else if (cmd == GPIO_V2_GET_LINE_IOCTL) {
+	case GPIO_V2_GET_LINEINFO_IOCTL:
+		return lineinfo_get(cdev, ip, false);
+	case GPIO_V2_GET_LINEINFO_WATCH_IOCTL:
+		return lineinfo_get(cdev, ip, true);
+	case GPIO_V2_GET_LINE_IOCTL:
 		return linereq_create(gdev, ip);
-	} else if (cmd == GPIO_GET_LINEINFO_UNWATCH_IOCTL) {
+	case GPIO_GET_LINEINFO_UNWATCH_IOCTL:
 		return lineinfo_unwatch(cdev, ip);
+	default:
+		return -EINVAL;
 	}
-	return -EINVAL;
 }
 
 #ifdef CONFIG_COMPAT
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 59d8affad343..3e01a3ac652d 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -186,9 +186,8 @@ static int gpiochip_find_base(int ngpio)
 		/* found a free space? */
 		if (gdev->base + gdev->ngpio <= base)
 			break;
-		else
-			/* nope, check the space right before the chip */
-			base = gdev->base - ngpio;
+		/* nope, check the space right before the chip */
+		base = gdev->base - ngpio;
 	}
 
 	if (gpio_is_valid(base)) {
@@ -2481,8 +2480,7 @@ int gpiod_direction_output(struct gpio_desc *desc, int value)
 			ret = gpiod_direction_input(desc);
 			goto set_output_flag;
 		}
-	}
-	else if (test_bit(FLAG_OPEN_SOURCE, &desc->flags)) {
+	} else if (test_bit(FLAG_OPEN_SOURCE, &desc->flags)) {
 		ret = gpio_set_config(desc, PIN_CONFIG_DRIVE_OPEN_SOURCE);
 		if (!ret)
 			goto set_output_value;
@@ -2656,9 +2654,9 @@ static int gpiod_get_raw_value_commit(const struct gpio_desc *desc)
 static int gpio_chip_get_multiple(struct gpio_chip *gc,
 				  unsigned long *mask, unsigned long *bits)
 {
-	if (gc->get_multiple) {
+	if (gc->get_multiple)
 		return gc->get_multiple(gc, mask, bits);
-	} else if (gc->get) {
+	if (gc->get) {
 		int i, value;
 
 		for_each_set_bit(i, mask, gc->ngpio) {
-- 
2.35.1



