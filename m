Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3039C63571B
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:38:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238060AbiKWJh6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:37:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237945AbiKWJh0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:37:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 295216164
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:35:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BACCE61B29
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:35:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B06D8C433C1;
        Wed, 23 Nov 2022 09:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196126;
        bh=mCmpBwT8Ioz8zoxuf/jc5cRTM5dhY4OjpjcHwzkIS2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p4V5Zu/V3QgnBNK5NATv8hkrrfVSbF8ESd58lbC7KMRQ8mUcEa4akep6dEX2r5Nbc
         iq4fVaGAXejx6U/O0C3sIOR44ZyF6opX/Xo4JdfRMGUZy6kHdFh/NYBPX4uhThLgZo
         77XyU0OByuyyQxEy7o6AgTObTPRgKHEyaOxm4PcA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Chuhong Yuan <hslester96@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        stable <stable@kernel.org>
Subject: [PATCH 5.15 125/181] USB: bcma: Make GPIO explicitly optional
Date:   Wed, 23 Nov 2022 09:51:28 +0100
Message-Id: <20221123084607.779061889@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
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

From: Linus Walleij <linus.walleij@linaro.org>

commit cd136706b4f925aa5d316642543babac90d45910 upstream.

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
---
 drivers/usb/host/bcma-hcd.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/usb/host/bcma-hcd.c
+++ b/drivers/usb/host/bcma-hcd.c
@@ -285,7 +285,7 @@ static void bcma_hci_platform_power_gpio
 {
 	struct bcma_hcd_device *usb_dev = bcma_get_drvdata(dev);
 
-	if (IS_ERR_OR_NULL(usb_dev->gpio_desc))
+	if (!usb_dev->gpio_desc)
 		return;
 
 	gpiod_set_value(usb_dev->gpio_desc, val);
@@ -406,9 +406,11 @@ static int bcma_hcd_probe(struct bcma_de
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


