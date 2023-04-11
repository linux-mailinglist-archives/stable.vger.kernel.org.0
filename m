Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2A96DD598
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 10:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230446AbjDKIb4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 04:31:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbjDKIbz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 04:31:55 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5022D172C
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 01:31:52 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id x3-20020a170902ec8300b001a1a5f6f272so4697982plg.1
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 01:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1681201912;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zVZa8iiDBE0PpkMkB5PA8G0RGtm/FlyaCAntJJ2YIOQ=;
        b=cDpsj3H+xWOEtctnZ6Qbjh9+3xxi7Ck1yT3sgXeq8OXdv/LYwSoAF2ok7JHEU9MGIE
         QWPiMEMss8w3WDdI/U3+SmaHMoUenmyYDfrJhFI7BvhXb6nmGIt5INhJfCJQBK5JWLI2
         2SVkTGP5l3NjUDvy30lev7X7xFCPjx4vzGhOs7u/2qrvkBNx3qqXtAi3F20e763mm4Kb
         u+PhrsGlqa3AyrNyssOc82S+K1GcVg6WT6ZQACqSt3v9hemy7JRcV5Tiv1EEFl8Ye20S
         Ct0r0bVSVHaRxwVzMdKT2jslsdPTWeIn9P2idjb9QoanGUpvR7p75eHaZAwHY1+6LR+Q
         no+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681201912;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zVZa8iiDBE0PpkMkB5PA8G0RGtm/FlyaCAntJJ2YIOQ=;
        b=AQCmL5IIe/YouIzkQ2MHrNcqdXhxfp0x9Nim/ZgEJoHOxh86hYr0V+lplMcO8YKxQp
         kR6FFDHXz+CaesyHNUMTummplBQHsOGDWu8rr5m/VEfVFHpBbM9EU9SBHiO4aOIef5ti
         BUYcXPHm1UxuNgzVnWbEYBTvX3NBvzs6tf6JOS4/VJjoMf7BA7if6Pmh1ot58ICGBD9m
         UrOlww7CR6hSSPFXpEZ1Xrf8pybC0xL65ftyhfAyzo1yC6mFpwt+RgxBsCoq+Omvy+2y
         KFOipOwyHW7NZwve6WGmOo0pIXzhXiMK06OWs7nVPOnGrVxd2eAU6Rb/+j615aVsdp8s
         qfPA==
X-Gm-Message-State: AAQBX9d4iX8/BLD6fmo10+41srjoy5J3ishAQ/010qdoFmdQ7SVABUns
        94rtgqsSrS/20opVYJUfVXJHnWVKaR8=
X-Google-Smtp-Source: AKy350YoK4eeP0dsaY0OoM4tiioUCEUoT13Uio+p9zFhn+FUM6wEIAYHdArmQZkKcIomtQfA9KVyWVQGRLk=
X-Received: from hhhuuu.c.googlers.com ([fda3:e722:ac3:cc00:3:22c1:c0a8:c80])
 (user=hhhuuu job=sendgmr) by 2002:a17:90a:72c2:b0:244:9ef4:9a25 with SMTP id
 l2-20020a17090a72c200b002449ef49a25mr3054772pjk.4.1681201911814; Tue, 11 Apr
 2023 01:31:51 -0700 (PDT)
Date:   Tue, 11 Apr 2023 08:31:45 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230411083145.2214105-1-hhhuuu@google.com>
Subject: [PATCH] usb: core: hub: Disable autosuspend for VIA VL813 USB3.0 hub
From:   Jimmy Hu <hhhuuu@google.com>
To:     stern@rowland.harvard.edu, gregkh@linuxfoundation.org
Cc:     badhri@google.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jimmy Hu <hhhuuu@google.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The VIA VL813 USB3.0 hub appears to have an issue with autosuspend and
detecting USB3 devices. This can be reproduced by connecting a USB3
device to the hub after the hub enters autosuspend mode.

//connect the hub
[  106.854204] usb 2-1: new SuperSpeed Gen 1 USB device number 2 using xhci-hcd
[  107.084993] usb 2-1: New USB device found, idVendor=2109, idProduct=0813, bcdDevice=90.15
[  107.094520] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[  107.111836] usb 2-1: Product: USB3.0 Hub
[  107.116835] usb 2-1: Manufacturer: VIA Labs, Inc.
[  107.314230] hub 2-1:1.0: USB hub found
[  107.321356] hub 2-1:1.0: 4 ports detected

//the hub enters autosuspend mode
[  107.738873] hub 2-1:1.0: hub_suspend
[  107.922097] usb 2-1: usb auto-suspend, wakeup 1

//connect a USB3 device
[  133.120060] usb 2-1: usb wakeup-resume
[  133.160033] usb 2-1: Waited 0ms for CONNECT
[  133.165423] usb 2-1: finish resume
[  133.176919] hub 2-1:1.0: hub_resume
[  133.188026] usb 2-1-port3: status 0263 change 0041
[  133.323585] hub 2-1:1.0: state 7 ports 4 chg 0008 evt 0008
[  133.342423] usb 2-1-port3: link state change
[  133.358154] usb 2-1-port3: status 0263, change 0040, 5.0 Gb/s
[  133.875150] usb 2-1-port3: not reset yet, waiting 10ms
[  133.895502] usb 2-1-port3: not reset yet, waiting 10ms
[  133.918239] usb 2-1-port3: not reset yet, waiting 200ms
[  134.139529] usb 2-1-port3: not reset yet, waiting 200ms
[  134.365296] usb 2-1-port3: not reset yet, waiting 200ms
[  134.590185] usb 2-1-port3: not reset yet, waiting 200ms
[  134.641330] hub 2-1:1.0: state 7 ports 4 chg 0000 evt 0008
[  134.658880] hub 2-1:1.0: hub_suspend
[  134.792908] usb 2-1: usb auto-suspend, wakeup 1

Disabling autosuspend for this hub resolves the issue.

Signed-off-by: Jimmy Hu <hhhuuu@google.com>
Cc: stable@vger.kernel.org
---
 drivers/usb/core/hub.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 97a0f8faea6e..5c6455224d9d 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -47,6 +47,8 @@
 #define USB_VENDOR_TEXAS_INSTRUMENTS		0x0451
 #define USB_PRODUCT_TUSB8041_USB3		0x8140
 #define USB_PRODUCT_TUSB8041_USB2		0x8142
+#define USB_VENDOR_VIA				0x2109
+#define USB_PRODUCT_VL813_USB3			0x0813
 #define HUB_QUIRK_CHECK_PORT_AUTOSUSPEND	0x01
 #define HUB_QUIRK_DISABLE_AUTOSUSPEND		0x02
 
@@ -5866,6 +5868,11 @@ static const struct usb_device_id hub_id_table[] = {
       .idVendor = USB_VENDOR_TEXAS_INSTRUMENTS,
       .idProduct = USB_PRODUCT_TUSB8041_USB3,
       .driver_info = HUB_QUIRK_DISABLE_AUTOSUSPEND},
+    { .match_flags = USB_DEVICE_ID_MATCH_VENDOR
+			| USB_DEVICE_ID_MATCH_PRODUCT,
+      .idVendor = USB_VENDOR_VIA,
+      .idProduct = USB_PRODUCT_VL813_USB3,
+      .driver_info = HUB_QUIRK_DISABLE_AUTOSUSPEND},
     { .match_flags = USB_DEVICE_ID_MATCH_DEV_CLASS,
       .bDeviceClass = USB_CLASS_HUB},
     { .match_flags = USB_DEVICE_ID_MATCH_INT_CLASS,
-- 
2.40.0.577.gac1e443424-goog

