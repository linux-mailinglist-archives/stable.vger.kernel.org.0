Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2DA274062
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 13:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbgIVLHf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 07:07:35 -0400
Received: from aibo.runbox.com ([91.220.196.211]:40220 "EHLO aibo.runbox.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726533AbgIVLHf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Sep 2020 07:07:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
         s=selector2; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To
        :Message-Id:Date:Subject:Cc:To:From;
        bh=8csiEGr24be+WDvlGFb8o+D++Lm8+TY5ZC6fpXtGTsg=; b=OdOavOZgMqBPM0+1EPG9BX0Rpv
        dslBV3UscSPvJt384cqAIJDV8vBvGDL3NQrfCnKRdYU3jqc2P1PlSCp+pszhdmrz24dqFqsKHxn6p
        7ICdp/6oinZ/81NPfUqMNtWXT1P5KWRcACxAn5uBZCL6mnSaCo/SV/6X53eQ72aghP+JGw0Gfsppe
        EXPB+Ta6l4kwk4B3L6QGQVuD5i/qwkJk8fkPZHNURuAnnMhXtvBXpGjS52O4VkSBI4cKv8rvyzC4k
        1/0K0KlJkpVJrP9+7wylwZh915mMMLTtDonMuKdLoLGZDiHwy+2PUDCSp17uedequvHB9yRIk1l+F
        yOnF19fg==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <m.v.b@runbox.com>)
        id 1kKg8z-00053H-6V; Tue, 22 Sep 2020 13:07:33 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated alias (536975)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1kKg8w-0000QD-MX; Tue, 22 Sep 2020 13:07:31 +0200
From:   "M. Vefa Bicakci" <m.v.b@runbox.com>
To:     linux-usb@vger.kernel.org
Cc:     "M. Vefa Bicakci" <m.v.b@runbox.com>, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Bastien Nocera <hadess@hadess.net>,
        Shuah Khan <shuah@kernel.org>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        syzkaller@googlegroups.com
Subject: [PATCH v3 3/4] usbcore/driver: Fix incorrect downcast
Date:   Tue, 22 Sep 2020 14:07:02 +0300
Message-Id: <20200922110703.720960-4-m.v.b@runbox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200922110703.720960-1-m.v.b@runbox.com>
References: <20200922110703.720960-1-m.v.b@runbox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This commit resolves a minor bug in the selection/discovery of more
specific USB device drivers for devices that are currently bound to
generic USB device drivers.

The bug is related to the way a candidate USB device driver is
compared against the generic USB device driver. The code in
is_dev_usb_generic_driver() assumes that the device driver in question
is a USB device driver by calling to_usb_device_driver(dev->driver)
to downcast; however I have observed that this assumption is not always
true, through code instrumentation.

This commit avoids the incorrect downcast altogether by comparing
the USB device's driver (i.e., dev->driver) to the generic USB
device driver directly. This method was suggested by Alan Stern.

This bug was found while investigating Andrey Konovalov's report
indicating usbip device driver misbehaviour with the recently merged
generic USB device driver selection feature. The report is linked
below.

Fixes: d5643d2249 ("USB: Fix device driver race")
Link: https://lore.kernel.org/linux-usb/CAAeHK+zOrHnxjRFs=OE8T=O9208B9HP_oo8RZpyVOZ9AJ54pAA@mail.gmail.com/
Cc: <stable@vger.kernel.org> # 5.8
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Bastien Nocera <hadess@hadess.net>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Valentina Manea <valentina.manea.m@gmail.com>
Cc: <syzkaller@googlegroups.com>
Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>

---
v3: Simplify the device driver pointer comparison to avoid incorrect
    downcast, as suggested by Alan Stern. Minor edits to the commit
    message.

v2: Following Bastien Nocera's code review comment, use is_usb_device()
    to verify that a device is bound to a USB device driver (as opposed
    to, e.g., a USB interface driver) to avoid incorrect downcast.
---
 drivers/usb/core/driver.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/core/driver.c b/drivers/usb/core/driver.c
index 950044a6e77f..7d90cbe063ec 100644
--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -905,21 +905,14 @@ static int usb_uevent(struct device *dev, struct kobj_uevent_env *env)
 	return 0;
 }
 
-static bool is_dev_usb_generic_driver(struct device *dev)
-{
-	struct usb_device_driver *udd = dev->driver ?
-		to_usb_device_driver(dev->driver) : NULL;
-
-	return udd == &usb_generic_driver;
-}
-
 static int __usb_bus_reprobe_drivers(struct device *dev, void *data)
 {
 	struct usb_device_driver *new_udriver = data;
 	struct usb_device *udev;
 	int ret;
 
-	if (!is_dev_usb_generic_driver(dev))
+	/* Don't reprobe if current driver isn't usb_generic_driver */
+	if (dev->driver != &usb_generic_driver.drvwrap.driver)
 		return 0;
 
 	udev = to_usb_device(dev);
-- 
2.26.2

