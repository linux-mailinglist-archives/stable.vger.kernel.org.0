Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABEB03137AB
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbhBHP3D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:29:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:36400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231769AbhBHPYn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:24:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8239664EB8;
        Mon,  8 Feb 2021 15:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797295;
        bh=GoW/9O9cNjlzdIf3oMZObP/PxFY753fJ58IUR99Fxog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rsBNSjqCYV2kmy/AAjh+pNU3yIvTB351l9vizaVdwostU+L+HyoqVfKlhB+Nf3v1K
         Eb2j3ny6dev2pVQqbmyCequPiOc/8Cp88inboPkKLM0Q+6Ers3NuGdlxnn8JIkc54H
         yZ9oXbhHfArobndesdgKhSylMRtWmDWMetpI3EaA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Quanyang Wang <quanyang.wang@windriver.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 5.10 058/120] gpiolib: free device name on error path to fix kmemleak
Date:   Mon,  8 Feb 2021 16:00:45 +0100
Message-Id: <20210208145820.738503145@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quanyang Wang <quanyang.wang@windriver.com>

commit c351bb64cbe67029c68dea3adbec1b9508c6ff0f upstream.

In gpiochip_add_data_with_key, we should check the return value of
dev_set_name to ensure that device name is allocated successfully
and then add a label on the error path to free device name to fix
kmemleak as below:

unreferenced object 0xc2d6fc40 (size 64):
  comm "kworker/0:1", pid 16, jiffies 4294937425 (age 65.120s)
  hex dump (first 32 bytes):
    67 70 69 6f 63 68 69 70 30 00 1a c0 54 63 1a c0  gpiochip0...Tc..
    0c ed 84 c0 48 ed 84 c0 3c ee 84 c0 10 00 00 00  ....H...<.......
  backtrace:
    [<962810f7>] kobject_set_name_vargs+0x2c/0xa0
    [<f50797e6>] dev_set_name+0x2c/0x5c
    [<94abbca9>] gpiochip_add_data_with_key+0xfc/0xce8
    [<5c4193e0>] omap_gpio_probe+0x33c/0x68c
    [<3402f137>] platform_probe+0x58/0xb8
    [<7421e210>] really_probe+0xec/0x3b4
    [<000f8ada>] driver_probe_device+0x58/0xb4
    [<67e0f7f7>] bus_for_each_drv+0x80/0xd0
    [<4de545dc>] __device_attach+0xe8/0x15c
    [<2e4431e7>] bus_probe_device+0x84/0x8c
    [<c18b1de9>] device_add+0x384/0x7c0
    [<5aff2995>] of_platform_device_create_pdata+0x8c/0xb8
    [<061c3483>] of_platform_bus_create+0x198/0x230
    [<5ee6d42a>] of_platform_populate+0x60/0xb8
    [<2647300f>] sysc_probe+0xd18/0x135c
    [<3402f137>] platform_probe+0x58/0xb8

Signed-off-by: Quanyang Wang <quanyang.wang@windriver.com>
Cc: stable@vger.kernel.org
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -602,7 +602,11 @@ int gpiochip_add_data_with_key(struct gp
 		ret = gdev->id;
 		goto err_free_gdev;
 	}
-	dev_set_name(&gdev->dev, GPIOCHIP_NAME "%d", gdev->id);
+
+	ret = dev_set_name(&gdev->dev, GPIOCHIP_NAME "%d", gdev->id);
+	if (ret)
+		goto err_free_ida;
+
 	device_initialize(&gdev->dev);
 	dev_set_drvdata(&gdev->dev, gdev);
 	if (gc->parent && gc->parent->driver)
@@ -616,7 +620,7 @@ int gpiochip_add_data_with_key(struct gp
 	gdev->descs = kcalloc(gc->ngpio, sizeof(gdev->descs[0]), GFP_KERNEL);
 	if (!gdev->descs) {
 		ret = -ENOMEM;
-		goto err_free_ida;
+		goto err_free_dev_name;
 	}
 
 	if (gc->ngpio == 0) {
@@ -767,6 +771,8 @@ err_free_label:
 	kfree_const(gdev->label);
 err_free_descs:
 	kfree(gdev->descs);
+err_free_dev_name:
+	kfree(dev_name(&gdev->dev));
 err_free_ida:
 	ida_free(&gpio_ida, gdev->id);
 err_free_gdev:


