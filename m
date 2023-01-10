Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0CB664777
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 18:33:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234472AbjAJRdF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 12:33:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234308AbjAJRc7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 12:32:59 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1F325B15C
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 09:32:58 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id n126so541180iod.7
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 09:32:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2WglFD8vrQmflspPOJQOiyJdpFr/DrUWVK6xL71FE/s=;
        b=h+Jx3Wt1+stYfeew4k9Zc6l0xTu35n7g5OprwCCJHzoJNIyN8fWJMBNXBnMzFjBym2
         QSPQfAAN5DNE7nmx7jsgQjJ9CvMYrYxpOYmeOTJRcgU3Q7N0ZGPssAgf4y1hJ2IfqIlv
         dMRyZxY9GssiBFrOVwzCvZvgbJufTbMvAOR68=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2WglFD8vrQmflspPOJQOiyJdpFr/DrUWVK6xL71FE/s=;
        b=g4XQdCUn33pX86FiUC7Sqqk5HuAuQgA+kCWOKGsCvDeWIvd4GOySQSuBPjNgDpqLte
         T6ORpbJXPWgRIRnKFDztUZbL1AcIsLeM9s17x3oRm4XfQs2iV/lC3Dc/HL7kcmZJCyd5
         wmwsDQ/sPtCpjZT9Y6GOJuWoKLWQP/e7p4FwYRj6RFkPhc0cHQ0AG2HPaxMZuZMicUjF
         N6WSM9g0km8iRK/yDAASHB/cPrir2Z0A/8UPkHScJdOoK5J3fH98wNKDlx+u3smob0gT
         +WF02S093bRqKvQqaNsllyOVfhmhGGeb8FubTAmJefYpl2yxdGoLZhI5JwEK7kovClIh
         FbOA==
X-Gm-Message-State: AFqh2kqeuWdO3iUj/TADPTxmzsu23g+sc+3OUayuxIY6zLRvthltUJbb
        pP5iie9a5SjlZ+jSy3mEpuZLqg==
X-Google-Smtp-Source: AMrXdXvCag/yv2jYixjCgU1I2FqjFssXU34NC/8jslwPn/DflH79Q2heRz5OtoWlxIMyifOOys6Qbg==
X-Received: by 2002:a5e:a817:0:b0:6ec:c7a1:d597 with SMTP id c23-20020a5ea817000000b006ecc7a1d597mr49886778ioa.2.1673371978057;
        Tue, 10 Jan 2023 09:32:58 -0800 (PST)
Received: from localhost (30.23.70.34.bc.googleusercontent.com. [34.70.23.30])
        by smtp.gmail.com with UTF8SMTPSA id l131-20020a6b3e89000000b006ccc36c963fsm4342016ioa.43.2023.01.10.09.32.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Jan 2023 09:32:57 -0800 (PST)
From:   Matthias Kaehlcke <mka@chromium.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Icenowy Zheng <uwu@icenowy.me>, stable@vger.kernel.org,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        linux-usb@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        linux-kernel@vger.kernel.org,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Douglas Anderson <dianders@chromium.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Ravi Chandra Sadineni <ravisadineni@chromium.org>
Subject: [PATCH v2 2/2] usb: misc: onboard_hub: Move 'attach' work to the driver
Date:   Tue, 10 Jan 2023 17:32:53 +0000
Message-Id: <20230110172954.v2.2.I16b51f32db0c32f8a8532900bfe1c70c8572881a@changeid>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
In-Reply-To: <20230110172954.v2.1.I75494ebee7027a50235ce4b1e930fa73a578fbe2@changeid>
References: <20230110172954.v2.1.I75494ebee7027a50235ce4b1e930fa73a578fbe2@changeid>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently each onboard_hub platform device owns an 'attach' work,
which is scheduled when the device probes. With this deadlocks
have been reported on a Raspberry Pi 3 B+ [1], which has nested
onboard hubs.

The flow of the deadlock is something like this (with the onboard_hub
driver built as a module) [2]:

- USB root hub is instantiated
- core hub driver calls onboard_hub_create_pdevs(), which creates the
  'raw' platform device for the 1st level hub
- 1st level hub is probed by the core hub driver
- core hub driver calls onboard_hub_create_pdevs(), which creates
  the 'raw' platform device for the 2nd level hub

- onboard_hub platform driver is registered
- platform device for 1st level hub is probed
  - schedules 'attach' work
- platform device for 2nd level hub is probed
  - schedules 'attach' work

- onboard_hub USB driver is registered
- device (and parent) lock of hub is held while the device is
  re-probed with the onboard_hub driver

- 'attach' work (running in another thread) calls driver_attach(), which
   blocks on one of the hub device locks

- onboard_hub_destroy_pdevs() is called by the core hub driver when one
  of the hubs is detached
- destroying the pdevs invokes onboard_hub_remove(), which waits for the
  'attach' work to complete
  - waits forever, since the 'attach' work can't acquire the device lock

Use a single work struct for the driver instead of having a work struct
per onboard hub platform driver instance. With that it isn't necessary
to cancel the work in onboard_hub_remove(), which fixes the deadlock.
The work is only cancelled when the driver is unloaded.

[1] https://lore.kernel.org/r/d04bcc45-3471-4417-b30b-5cf9880d785d@i2se.com/
[2] https://lore.kernel.org/all/Y6OrGbqaMy2iVDWB@google.com/

Cc: stable@vger.kernel.org
Fixes: 8bc063641ceb ("usb: misc: Add onboard_usb_hub driver")
Link: https://lore.kernel.org/r/d04bcc45-3471-4417-b30b-5cf9880d785d@i2se.com/
Link: https://lore.kernel.org/all/Y6OrGbqaMy2iVDWB@google.com/
Reported-by: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
---
Changes in v2:
- drop loop in onboard_hub_probe() to wait for an already running
  'attach' work to finish. The loop can cause deadlocks and is not
  needed.

Rationale for why the loop in onboard_hub_probe() isn't needed:

The idea behind the loop was: The currently running work might not take
into account the USB devices of the hub that is currently probed, which
should probe shortly after the hub was powered on.

The 'attach' work is only needed for USB devices that were previously
detached through device_release_driver() in onboard_hub_remove(). These
USB device objects only persist in the kernel if the hub is not powered
off (or put into reset) by onboard_hub_remove().

If onboard_hub_probe() is invoked and the USB device objects persisted,
then an already running 'attach' work should take them into account. If
they didn't persist the running work might miss them, but that wouldn't
be a problem since the newly created USB devices don't need to be
explicitly attached because they weren't detached previously.

 drivers/usb/misc/onboard_usb_hub.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/misc/onboard_usb_hub.c b/drivers/usb/misc/onboard_usb_hub.c
index db0844b30bbd..969c4c4f2ae9 100644
--- a/drivers/usb/misc/onboard_usb_hub.c
+++ b/drivers/usb/misc/onboard_usb_hub.c
@@ -27,7 +27,10 @@
 
 #include "onboard_usb_hub.h"
 
+static void onboard_hub_attach_usb_driver(struct work_struct *work);
+
 static struct usb_device_driver onboard_hub_usbdev_driver;
+static DECLARE_WORK(attach_usb_driver_work, onboard_hub_attach_usb_driver);
 
 /************************** Platform driver **************************/
 
@@ -45,7 +48,6 @@ struct onboard_hub {
 	bool is_powered_on;
 	bool going_away;
 	struct list_head udev_list;
-	struct work_struct attach_usb_driver_work;
 	struct mutex lock;
 };
 
@@ -271,8 +273,7 @@ static int onboard_hub_probe(struct platform_device *pdev)
 	 * This needs to be done deferred to avoid self-deadlocks on systems
 	 * with nested onboard hubs.
 	 */
-	INIT_WORK(&hub->attach_usb_driver_work, onboard_hub_attach_usb_driver);
-	schedule_work(&hub->attach_usb_driver_work);
+	schedule_work(&attach_usb_driver_work);
 
 	return 0;
 }
@@ -285,9 +286,6 @@ static int onboard_hub_remove(struct platform_device *pdev)
 
 	hub->going_away = true;
 
-	if (&hub->attach_usb_driver_work != current_work())
-		cancel_work_sync(&hub->attach_usb_driver_work);
-
 	mutex_lock(&hub->lock);
 
 	/* unbind the USB devices to avoid dangling references to this device */
@@ -449,6 +447,8 @@ static void __exit onboard_hub_exit(void)
 {
 	usb_deregister_device_driver(&onboard_hub_usbdev_driver);
 	platform_driver_unregister(&onboard_hub_driver);
+
+	cancel_work_sync(&attach_usb_driver_work);
 }
 module_exit(onboard_hub_exit);
 
-- 
2.39.0.314.g84b9a713c41-goog

