Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E33363217A
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 12:58:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbiKUL6j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 06:58:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbiKUL6h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 06:58:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD06117E2C
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 03:58:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70AE8B80ECF
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 11:58:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD7AFC433C1;
        Mon, 21 Nov 2022 11:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669031912;
        bh=huSWNV/OrKXcLBrnGy8zAp9aJBV80XZXLMOxejooiZw=;
        h=Subject:To:Cc:From:Date:From;
        b=aYB7LGK3JAE6t7lzlPGr5yYWZ4bF6ptn5Z9Pn46lisbuzWnAiMLU9RffUISEXGNzV
         jDxviHTID5JFv1D3ueDlVvwDlt4IKasS7frkzDzoVjqvD+46gQCLPSwHIyFxvVdpzf
         Vm8CdaR1CC98MYG79CHNbwj0KEF4qrxZ/xEpTug4=
Subject: FAILED: patch "[PATCH] USB: bcma: Make GPIO explicitly optional" failed to apply to 5.4-stable tree
To:     linus.walleij@linaro.org, gregkh@linuxfoundation.org,
        hslester96@gmail.com, rafal@milecki.pl, stable@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 21 Nov 2022 12:58:20 +0100
Message-ID: <1669031900107254@kroah.com>
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


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

cd136706b4f9 ("USB: bcma: Make GPIO explicitly optional")
d91adc5322ab ("Revert "USB: bcma: Add a check for devm_gpiod_get"")
f3de5d857bb2 ("USB: bcma: Add a check for devm_gpiod_get")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From cd136706b4f925aa5d316642543babac90d45910 Mon Sep 17 00:00:00 2001
From: Linus Walleij <linus.walleij@linaro.org>
Date: Mon, 7 Nov 2022 10:07:53 +0100
Subject: [PATCH] USB: bcma: Make GPIO explicitly optional
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

What the code does is to not check the return value from
devm_gpiod_get() and then avoid using an erroneous GPIO descriptor
with IS_ERR_OR_NULL().

This will miss real errors from the GPIO core that should not be
ignored, such as probe deferral.

Instead request the GPIO as explicitly optional, which means that
if it doesn't exist, the descriptor returned will be NULL.

Then we can add error handling and also avoid just doing this on
the device tree path, and simplify the site where the optional
GPIO descriptor is used.

There were some problems with cleaning up this GPIO descriptor
use in the past, but this is the proper way to deal with it.

Cc: Rafał Miłecki <rafal@milecki.pl>
Cc: Chuhong Yuan <hslester96@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20221107090753.1404679-1-linus.walleij@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/host/bcma-hcd.c b/drivers/usb/host/bcma-hcd.c
index 2df52f75f6b3..7558cc4d90cc 100644
--- a/drivers/usb/host/bcma-hcd.c
+++ b/drivers/usb/host/bcma-hcd.c
@@ -285,7 +285,7 @@ static void bcma_hci_platform_power_gpio(struct bcma_device *dev, bool val)
 {
 	struct bcma_hcd_device *usb_dev = bcma_get_drvdata(dev);
 
-	if (IS_ERR_OR_NULL(usb_dev->gpio_desc))
+	if (!usb_dev->gpio_desc)
 		return;
 
 	gpiod_set_value(usb_dev->gpio_desc, val);
@@ -406,9 +406,11 @@ static int bcma_hcd_probe(struct bcma_device *core)
 		return -ENOMEM;
 	usb_dev->core = core;
 
-	if (core->dev.of_node)
-		usb_dev->gpio_desc = devm_gpiod_get(&core->dev, "vcc",
-						    GPIOD_OUT_HIGH);
+	usb_dev->gpio_desc = devm_gpiod_get_optional(&core->dev, "vcc",
+						     GPIOD_OUT_HIGH);
+	if (IS_ERR(usb_dev->gpio_desc))
+		return dev_err_probe(&core->dev, PTR_ERR(usb_dev->gpio_desc),
+				     "error obtaining VCC GPIO");
 
 	switch (core->id.id) {
 	case BCMA_CORE_USB20_HOST:

