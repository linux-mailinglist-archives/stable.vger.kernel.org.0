Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85DA2283ADC
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728275AbgJEPiA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:38:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:58840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727913AbgJEPbq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:31:46 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26896207BC;
        Mon,  5 Oct 2020 15:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911904;
        bh=qUHYvowFTc6VgKgdgfvmPG3eH3Tb8DqV7oXBKGYS0Rs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C49z7JDZWCmo0zfeWKzrrtfaqZb45ThHe8dSwnGdQWJfVUEnfKCT9UwTP8ZXzf2pA
         m7c0YfPABxFPATnZ3WOgj5eG9GRigYcM6PZ8Ar6YYmjVYROwG/3Q75L2XjwKYH++Fr
         /lM5g9yHRXjh4oiCLoF9HW6g9Ze91ROUpEVsrK10=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Bastien Nocera <hadess@hadess.net>,
        Shuah Khan <shuah@kernel.org>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        syzkaller@googlegroups.com,
        Andrey Konovalov <andreyknvl@google.com>,
        "M. Vefa Bicakci" <m.v.b@runbox.com>
Subject: [PATCH 5.8 07/85] usbcore/driver: Fix incorrect downcast
Date:   Mon,  5 Oct 2020 17:26:03 +0200
Message-Id: <20201005142115.093187347@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142114.732094228@linuxfoundation.org>
References: <20201005142114.732094228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: M. Vefa Bicakci <m.v.b@runbox.com>

commit 4df30e7603432704380b12fe40a604ee7f66746d upstream.

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
 drivers/usb/core/driver.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -905,21 +905,14 @@ static int usb_uevent(struct device *dev
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


