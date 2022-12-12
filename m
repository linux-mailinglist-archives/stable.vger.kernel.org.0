Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7F9464A1C0
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232611AbiLLNo7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:44:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232592AbiLLNoP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:44:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D7A55B6
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:44:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 295E8B80D50
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:44:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5657AC433D2;
        Mon, 12 Dec 2022 13:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852644;
        bh=C2canFqoMkY1D87FUHYDVUCmr1Z6HfxWpBysO4bcYp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G2OFysfN/0c7acRtw+VQdRp01jdQTQpMsRRKWIvcYu3Z6/vPA3+jl8vv0gsQLE8Vz
         z1c8zfiFqTnbz2E23JKXgjj45gngb4hSBnjJ5Urh93jghNgp/3ggRbk3C0w2+JWyR9
         W4UCt2mDuqSHICX+81jI6vkKTeCtasn29HnXHZOk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zeng Heng <zengheng4@huawei.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 087/157] gpiolib: fix memory leak in gpiochip_setup_dev()
Date:   Mon, 12 Dec 2022 14:17:15 +0100
Message-Id: <20221212130938.291105250@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
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

From: Zeng Heng <zengheng4@huawei.com>

[ Upstream commit ec851b23084b3a0af8bf0f5e51d33a8d678bdc49 ]

Here is a backtrace report about memory leak detected in
gpiochip_setup_dev():

unreferenced object 0xffff88810b406400 (size 512):
  comm "python3", pid 1682, jiffies 4295346908 (age 24.090s)
  backtrace:
    kmalloc_trace
    device_add		device_private_init at drivers/base/core.c:3361
			(inlined by) device_add at drivers/base/core.c:3411
    cdev_device_add
    gpiolib_cdev_register
    gpiochip_setup_dev
    gpiochip_add_data_with_key

gcdev_register() & gcdev_unregister() would call device_add() &
device_del() (no matter CONFIG_GPIO_CDEV is enabled or not) to
register/unregister device.

However, if device_add() succeeds, some resource (like
struct device_private allocated by device_private_init())
is not released by device_del().

Therefore, after device_add() succeeds by gcdev_register(), it
needs to call put_device() to release resource in the error handle
path.

Here we move forward the register of release function, and let it
release every piece of resource by put_device() instead of kfree().

While at it, fix another subtle issue, i.e. when gc->ngpio is equal
to 0, we still call kcalloc() and, in case of further error, kfree()
on the ZERO_PTR pointer, which is not NULL. It's not a bug per se,
but rather waste of the resources and potentially wrong expectation
about contents of the gdev->descs variable.

Fixes: 159f3cd92f17 ("gpiolib: Defer gpio device setup until after gpiolib initialization")
Signed-off-by: Zeng Heng <zengheng4@huawei.com>
Co-developed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 42 ++++++++++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 16 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index cc9c0a12259e..eb7d00608c7f 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -526,12 +526,13 @@ static int gpiochip_setup_dev(struct gpio_device *gdev)
 	if (ret)
 		return ret;
 
+	/* From this point, the .release() function cleans up gpio_device */
+	gdev->dev.release = gpiodevice_release;
+
 	ret = gpiochip_sysfs_register(gdev);
 	if (ret)
 		goto err_remove_device;
 
-	/* From this point, the .release() function cleans up gpio_device */
-	gdev->dev.release = gpiodevice_release;
 	dev_dbg(&gdev->dev, "registered GPIOs %d to %d on %s\n", gdev->base,
 		gdev->base + gdev->ngpio - 1, gdev->chip->label ? : "generic");
 
@@ -597,10 +598,10 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
 	struct fwnode_handle *fwnode = NULL;
 	struct gpio_device *gdev;
 	unsigned long flags;
-	int base = gc->base;
 	unsigned int i;
+	u32 ngpios = 0;
+	int base = 0;
 	int ret = 0;
-	u32 ngpios;
 
 	if (gc->fwnode)
 		fwnode = gc->fwnode;
@@ -647,17 +648,12 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
 	else
 		gdev->owner = THIS_MODULE;
 
-	gdev->descs = kcalloc(gc->ngpio, sizeof(gdev->descs[0]), GFP_KERNEL);
-	if (!gdev->descs) {
-		ret = -ENOMEM;
-		goto err_free_dev_name;
-	}
-
 	/*
 	 * Try the device properties if the driver didn't supply the number
 	 * of GPIO lines.
 	 */
-	if (gc->ngpio == 0) {
+	ngpios = gc->ngpio;
+	if (ngpios == 0) {
 		ret = device_property_read_u32(&gdev->dev, "ngpios", &ngpios);
 		if (ret == -ENODATA)
 			/*
@@ -668,7 +664,7 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
 			 */
 			ngpios = 0;
 		else if (ret)
-			goto err_free_descs;
+			goto err_free_dev_name;
 
 		gc->ngpio = ngpios;
 	}
@@ -676,13 +672,19 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
 	if (gc->ngpio == 0) {
 		chip_err(gc, "tried to insert a GPIO chip with zero lines\n");
 		ret = -EINVAL;
-		goto err_free_descs;
+		goto err_free_dev_name;
 	}
 
 	if (gc->ngpio > FASTPATH_NGPIO)
 		chip_warn(gc, "line cnt %u is greater than fast path cnt %u\n",
 			  gc->ngpio, FASTPATH_NGPIO);
 
+	gdev->descs = kcalloc(gc->ngpio, sizeof(*gdev->descs), GFP_KERNEL);
+	if (!gdev->descs) {
+		ret = -ENOMEM;
+		goto err_free_dev_name;
+	}
+
 	gdev->label = kstrdup_const(gc->label ?: "unknown", GFP_KERNEL);
 	if (!gdev->label) {
 		ret = -ENOMEM;
@@ -701,11 +703,13 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
 	 * it may be a pipe dream. It will not happen before we get rid
 	 * of the sysfs interface anyways.
 	 */
+	base = gc->base;
 	if (base < 0) {
 		base = gpiochip_find_base(gc->ngpio);
 		if (base < 0) {
-			ret = base;
 			spin_unlock_irqrestore(&gpio_lock, flags);
+			ret = base;
+			base = 0;
 			goto err_free_label;
 		}
 		/*
@@ -816,6 +820,11 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
 err_free_gpiochip_mask:
 	gpiochip_remove_pin_ranges(gc);
 	gpiochip_free_valid_mask(gc);
+	if (gdev->dev.release) {
+		/* release() has been registered by gpiochip_setup_dev() */
+		put_device(&gdev->dev);
+		goto err_print_message;
+	}
 err_remove_from_list:
 	spin_lock_irqsave(&gpio_lock, flags);
 	list_del(&gdev->list);
@@ -829,13 +838,14 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
 err_free_ida:
 	ida_free(&gpio_ida, gdev->id);
 err_free_gdev:
+	kfree(gdev);
+err_print_message:
 	/* failures here can mean systems won't boot... */
 	if (ret != -EPROBE_DEFER) {
 		pr_err("%s: GPIOs %d..%d (%s) failed to register, %d\n", __func__,
-		       gdev->base, gdev->base + gdev->ngpio - 1,
+		       base, base + (int)ngpios - 1,
 		       gc->label ? : "generic", ret);
 	}
-	kfree(gdev);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(gpiochip_add_data_with_key);
-- 
2.35.1



