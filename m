Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 224FE278B45
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 16:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728966AbgIYOxI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 10:53:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:35840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728731AbgIYOxI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 10:53:08 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A621E2311D;
        Fri, 25 Sep 2020 14:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601045587;
        bh=Ag10rrc5wgxDaYASMdCsZYwt82ZGsIzQfrRyqaRoTeI=;
        h=Subject:To:From:Date:From;
        b=UA/JHiNnlySapkP+bm7yg3MsVOzdk3peiTHR7W3fHEWLcxpW12WEt2I+iCsz5pcse
         KA9kzuVG19hGowQwmU+jkvG0Cp8xqd3Ugcod7RPYFpQgKXMpqbBfYqH2D/cdZFHLMV
         ef47xx1tlAAqPeGCXQW7ttCgYNPRF8wWSn3+aRU0=
Subject: patch "usbcore/driver: Fix incorrect downcast" added to usb-linus
To:     m.v.b@runbox.com, andreyknvl@google.com,
        gregkh@linuxfoundation.org, hadess@hadess.net, shuah@kernel.org,
        stable@vger.kernel.org, stern@rowland.harvard.edu,
        syzkaller@googlegroups.com, valentina.manea.m@gmail.com
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 25 Sep 2020 16:53:17 +0200
Message-ID: <160104559744156@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usbcore/driver: Fix incorrect downcast

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 4df30e7603432704380b12fe40a604ee7f66746d Mon Sep 17 00:00:00 2001
From: "M. Vefa Bicakci" <m.v.b@runbox.com>
Date: Tue, 22 Sep 2020 14:07:02 +0300
Subject: usbcore/driver: Fix incorrect downcast

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

Fixes: d5643d2249b2 ("USB: Fix device driver race")
Cc: <stable@vger.kernel.org> # 5.8
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Bastien Nocera <hadess@hadess.net>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Valentina Manea <valentina.manea.m@gmail.com>
Cc: <syzkaller@googlegroups.com>
Tested-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>
Link: https://lore.kernel.org/r/20200922110703.720960-4-m.v.b@runbox.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/driver.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/core/driver.c b/drivers/usb/core/driver.c
index 715782995428..b00b7fb1aad1 100644
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
2.28.0


