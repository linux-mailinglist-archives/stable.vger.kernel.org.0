Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6F2426D8D8
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 12:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbgIQKXM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 06:23:12 -0400
Received: from aibo.runbox.com ([91.220.196.211]:49674 "EHLO aibo.runbox.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726547AbgIQKWz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 06:22:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
         s=selector2; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To
        :Message-Id:Date:Subject:Cc:To:From;
        bh=kpt1sggtJASaMvrimJ66PNXLqT9hiDnQLE2RQbWv6IU=; b=FvvCPINQe5ac7bv8thM9SsRBF9
        7i3WJlwygaQXlZg2VmSKad8Yzhai4IrTP9BPv/oFksqgLtz5cYUv/459p4hjOHhhg85swzHqUvgDU
        7aDIUEr0Ys0jKHNmWwmDj3k+DsGef8NXkjE5y9mqb4cCTmyLFH+dIGjkLyYCxCpAJoP1owi8aqCBj
        JqR1O18XaWMVopxKgMRliwt4OPMIvLo4v2xE1XEKcraB9UPOW0x/kxxV3icBTbvjXsCYA/NwIIUMz
        digk/ePuq6hpwPA+nXlW5lwoY+6YGUliNSLPwTb7QF+jcMh6F51ycu7JlzhiE10Ga50V50p05ES6f
        qnsL2aUw==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <m.v.b@runbox.com>)
        id 1kIqiB-0007AO-7P; Thu, 17 Sep 2020 12:00:22 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated alias (536975)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1kIqi6-00076h-VT; Thu, 17 Sep 2020 12:00:15 +0200
From:   "M. Vefa Bicakci" <m.v.b@runbox.com>
To:     linux-usb@vger.kernel.org
Cc:     "M. Vefa Bicakci" <m.v.b@runbox.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Bastien Nocera <hadess@hadess.net>, syzkaller@googlegroups.com
Subject: [PATCH 1/2] usbcore/driver: Fix specific driver selection
Date:   Thu, 17 Sep 2020 12:59:58 +0300
Message-Id: <20200917095959.174378-1-m.v.b@runbox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <359d080c-5cbb-250a-0ebd-aaba5f5c530d@runbox.com>
References: <359d080c-5cbb-250a-0ebd-aaba5f5c530d@runbox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This commit resolves two minor bugs in the selection/discovery of more
specific USB device drivers for devices that are currently bound to
generic USB device drivers.

The first bug is related to the way a candidate USB device driver is
compared against the generic USB device driver. The code in
is_dev_usb_generic_driver() used to unconditionally use
to_usb_device_driver() on each device driver, without verifying that
the device driver in question is a USB device driver (as opposed to a
USB interface driver).

The second bug is related to the logic that determines whether a device
currently bound to a generic USB device driver should be re-probed by a
more specific USB device driver or not. The code in
__usb_bus_reprobe_drivers() used to have the following lines:

  if (usb_device_match_id(udev, new_udriver->id_table) == NULL &&
      (!new_udriver->match || new_udriver->match(udev) != 0))
 		return 0;

  ret = device_reprobe(dev);

As the reader will notice, the code checks whether the USB device in
consideration matches the identifier table (id_table) of a specific
USB device_driver (new_udriver), followed by a similar check, but this
time with the USB device driver's match function. However, the match
function's return value is not checked correctly. When match() returns
zero, it means that the specific USB device driver is *not* applicable
to the USB device in question, but the code then goes on to reprobe the
device with the new USB device driver under consideration. All this to
say, the logic is inverted.

This commit resolves both of the bugs, which were found by code
inspection and instrumentation after Andrey Konovalov's report
indicating USB/IP subsystem's misbehaviour with the generic USB device
driver matching code.

Reported-by: Andrey Konovalov <andreyknvl@google.com>
Fixes: d5643d2249 ("USB: Fix device driver race")
Link: https://lore.kernel.org/linux-usb/CAAeHK+zOrHnxjRFs=OE8T=O9208B9HP_oo8RZpyVOZ9AJ54pAA@mail.gmail.com/
Cc: <stable@vger.kernel.org> # 5.8
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Bastien Nocera <hadess@hadess.net>
Cc: <syzkaller@googlegroups.com>
Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>
---
 drivers/usb/core/driver.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/core/driver.c b/drivers/usb/core/driver.c
index c976ea9f9582..509bb0d5fa4f 100644
--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -907,10 +907,18 @@ static int usb_uevent(struct device *dev, struct kobj_uevent_env *env)
 
 static bool is_dev_usb_generic_driver(struct device *dev)
 {
-	struct usb_device_driver *udd = dev->driver ?
-		to_usb_device_driver(dev->driver) : NULL;
+	/* A non-existing driver can never be equal to &usb_generic_driver. */
+	if (!dev->driver)
+		return 0;
+
+	/* Check whether the driver is a USB interface driver, which is not
+	 * a USB device driver, and hence cannot be &usb_generic_driver.
+	 * (Plus, to_usb_device_driver is only valid for USB device drivers.)
+	 */
+	if (!is_usb_device_driver(dev->driver))
+		return 0;
 
-	return udd == &usb_generic_driver;
+	return to_usb_device_driver(dev->driver) == &usb_generic_driver;
 }
 
 static int __usb_bus_reprobe_drivers(struct device *dev, void *data)
@@ -924,7 +932,7 @@ static int __usb_bus_reprobe_drivers(struct device *dev, void *data)
 
 	udev = to_usb_device(dev);
 	if (usb_device_match_id(udev, new_udriver->id_table) == NULL &&
-	    (!new_udriver->match || new_udriver->match(udev) != 0))
+	    (!new_udriver->match || new_udriver->match(udev) == 0))
 		return 0;
 
 	ret = device_reprobe(dev);

base-commit: 871e6496207c6aa94134448779c77631a11bfa2e
-- 
2.26.2

