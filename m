Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC87A64A0D2
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:31:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232273AbiLLNbZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:31:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232318AbiLLNbS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:31:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B19713E27
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:31:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3196661042
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:31:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 331F9C433EF;
        Mon, 12 Dec 2022 13:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670851875;
        bh=rwpmwtCPBQZdTgXQZ2WqnqQyg00bXiA8h07ip+z0kKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lxn2x1FhGv08y0PxPEDGKfGIinBiHOzBFXYjNlR0oTr2P5RfWB4Yg37TxnIDp8LdQ
         EbuTDqgh1ZMyx6cuEy59pnjPD08tCwyyb/7Mzd4UG6fDyrJaAzO3rTCQ8UC29HHZXM
         kggE5x+hHO2E5GZLuSXVq1zhajEdkt3AcOqEf2rs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Bartosz Golaszewski <brgl@bgdev.pl>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 061/123] gpiolib: check the ngpios property in core gpiolib code
Date:   Mon, 12 Dec 2022 14:17:07 +0100
Message-Id: <20221212130929.496490427@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130926.811961601@linuxfoundation.org>
References: <20221212130926.811961601@linuxfoundation.org>
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

From: Bartosz Golaszewski <brgl@bgdev.pl>

[ Upstream commit 9dbd1ab20509e85cd3fac9479a00c59e83c08196 ]

Several drivers read the 'ngpios' device property on their own, but
since it's defined as a standard GPIO property in the device tree bindings
anyway, it's a good candidate for generalization. If the driver didn't
set its gc->ngpio, try to read the 'ngpios' property from the GPIO
device's firmware node before bailing out.

Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Suggested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Stable-dep-of: ec851b23084b ("gpiolib: fix memory leak in gpiochip_setup_dev()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index a87c4cd94f7a..b7b5fe151e1a 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -599,6 +599,7 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
 	int base = gc->base;
 	unsigned int i;
 	int ret = 0;
+	u32 ngpios;
 
 	/*
 	 * First: allocate and populate the internal stat container, and
@@ -646,6 +647,26 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
 		goto err_free_dev_name;
 	}
 
+	/*
+	 * Try the device properties if the driver didn't supply the number
+	 * of GPIO lines.
+	 */
+	if (gc->ngpio == 0) {
+		ret = device_property_read_u32(&gdev->dev, "ngpios", &ngpios);
+		if (ret == -ENODATA)
+			/*
+			 * -ENODATA means that there is no property found and
+			 * we want to issue the error message to the user.
+			 * Besides that, we want to return different error code
+			 * to state that supplied value is not valid.
+			 */
+			ngpios = 0;
+		else if (ret)
+			goto err_free_descs;
+
+		gc->ngpio = ngpios;
+	}
+
 	if (gc->ngpio == 0) {
 		chip_err(gc, "tried to insert a GPIO chip with zero lines\n");
 		ret = -EINVAL;
-- 
2.35.1



