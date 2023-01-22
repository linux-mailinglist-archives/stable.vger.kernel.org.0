Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4528676FB3
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:24:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbjAVPYU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:24:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231350AbjAVPYT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:24:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DEE91D904
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:24:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D536560C43
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:24:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E54EEC433EF;
        Sun, 22 Jan 2023 15:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674401057;
        bh=cO6buxaUIreiRYGGM0G/C24BzCAcWYlo++sgh83J5rA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UhH0u74uDsgDIRhYW5YtDxc9+rU5the7GG3XP/sVMKr4ew6cRy/vA4j7u00fD0qtb
         uXxqVAB82MbuFBPpcsJYR5ptjBMNVlT5NzLrSAeiRYr9OmAvpEkem30i/wPrpGgdWt
         sWHIf8IXwbJBLmmMXextDxPYCq1Zdo3Eli10/vsg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Matthias Kaehlcke <mka@chromium.org>,
        Stefan Wahren <stefan.wahren@i2se.com>
Subject: [PATCH 6.1 066/193] usb: misc: onboard_hub: Invert driver registration order
Date:   Sun, 22 Jan 2023 16:03:15 +0100
Message-Id: <20230122150249.372553054@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthias Kaehlcke <mka@chromium.org>

commit e5854355d76b8d768cea8e4fc3ce6dfdba25518a upstream.

The onboard_hub 'driver' consists of two drivers, a platform
driver and a USB driver. Currently when the onboard hub driver
is initialized it first registers the platform driver, then the
USB driver. This results in a race condition when the 'attach'
work is executed, which is scheduled when the platform device
is probed. The purpose of fhe 'attach' work is to bind elegible
USB hub devices to the onboard_hub USB driver. This fails if
the work runs before the USB driver has been registered.

Register the USB driver first, then the platform driver. This
increases the chances that the onboard_hub USB devices are probed
before their corresponding platform device, which the USB driver
tries to locate in _probe(). The driver already handles this
situation and defers probing if the onboard hub platform device
doesn't exist yet.

Cc: stable@vger.kernel.org
Fixes: 8bc063641ceb ("usb: misc: Add onboard_usb_hub driver")
Link: https://lore.kernel.org/lkml/Y6W00vQm3jfLflUJ@hovoldconsulting.com/T/#m0d64295f017942fd988f7c53425db302d61952b4
Reported-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
Tested-by: Stefan Wahren <stefan.wahren@i2se.com>
Link: https://lore.kernel.org/r/20230110172954.v2.1.I75494ebee7027a50235ce4b1e930fa73a578fbe2@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/onboard_usb_hub.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/misc/onboard_usb_hub.c
+++ b/drivers/usb/misc/onboard_usb_hub.c
@@ -431,13 +431,13 @@ static int __init onboard_hub_init(void)
 {
 	int ret;
 
-	ret = platform_driver_register(&onboard_hub_driver);
+	ret = usb_register_device_driver(&onboard_hub_usbdev_driver, THIS_MODULE);
 	if (ret)
 		return ret;
 
-	ret = usb_register_device_driver(&onboard_hub_usbdev_driver, THIS_MODULE);
+	ret = platform_driver_register(&onboard_hub_driver);
 	if (ret)
-		platform_driver_unregister(&onboard_hub_driver);
+		usb_deregister_device_driver(&onboard_hub_usbdev_driver);
 
 	return ret;
 }


