Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7103726DE96
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 16:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbgIQOoA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 10:44:00 -0400
Received: from aibo.runbox.com ([91.220.196.211]:44958 "EHLO aibo.runbox.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727635AbgIQOmR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 10:42:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
         s=selector2; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To
        :Message-Id:Date:Subject:Cc:To:From;
        bh=Acb83lDQUxJQj91yQAdseCCeGfKFWuDFFfIoGna9aek=; b=n0DkPng3dG+8RcJuA5zwIacHb1
        TXe5LLPwDoZwWp8ela6FZimISCPatyIPhmJc/s9ol5h9NfkPzofrC5/T5Id0AWZGO4g1QfR3zfMOR
        LW7IQ891IP5ALTcxuisRUYWBpgC2EeTm3qsddzP8WN5+PS/kctuEMxarZUmyVpoCbwZWJPYYRxJKW
        xL1mFhcpbxrPGzVyF23657tvhv0vvg6+Sh2ycarDYQw8MgCLnPErMP3QAhtZjhrw9T5VCZkL3JZI8
        1HKAcrhnG6pseVbqREsGVrPNsmHJO0lo+HnbdY2XVqHxowAKGn2NvJx+dnDMfwt/3i86mVVNqMNk5
        Tn/WK/Zw==;
Received: from [10.9.9.72] (helo=submission01.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <m.v.b@runbox.com>)
        id 1kIv6z-0001Ks-3U; Thu, 17 Sep 2020 16:42:13 +0200
Received: by submission01.runbox with esmtpsa  [Authenticated alias (536975)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1kIv6o-0002ee-Bs; Thu, 17 Sep 2020 16:42:02 +0200
From:   "M. Vefa Bicakci" <m.v.b@runbox.com>
To:     linux-usb@vger.kernel.org
Cc:     "M. Vefa Bicakci" <m.v.b@runbox.com>, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Bastien Nocera <hadess@hadess.net>,
        Andrey Konovalov <andreyknvl@google.com>,
        syzkaller@googlegroups.com
Subject: [PATCH 2/3] usbcore/driver: Fix incorrect downcast
Date:   Thu, 17 Sep 2020 17:41:50 +0300
Message-Id: <20200917144151.355848-2-m.v.b@runbox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200917144151.355848-1-m.v.b@runbox.com>
References: <a6e14983a8849d5f75a43f403c7cc721b6e4a420.camel@hadess.net>
 <20200917144151.355848-1-m.v.b@runbox.com>
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

Given that USB device drivers are bound to struct device instances with
of the type &usb_device_type, this commit checks the return value of
is_usb_device() before the call to is_dev_usb_generic_driver(), and
therefore ensures that incorrect type downcasts do not occur. The use
of is_usb_device() was suggested by Bastien Nocera.

This bug was found while investigating Andrey Konovalov's report
indicating USB/IP subsystem's misbehaviour with the generic USB device
driver matching code.

Fixes: d5643d2249 ("USB: Fix device driver race")
Link: https://lore.kernel.org/linux-usb/CAAeHK+zOrHnxjRFs=OE8T=O9208B9HP_oo8RZpyVOZ9AJ54pAA@mail.gmail.com/
Cc: <stable@vger.kernel.org> # 5.8
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Bastien Nocera <hadess@hadess.net>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: <syzkaller@googlegroups.com>
Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>
---
 drivers/usb/core/driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/core/driver.c b/drivers/usb/core/driver.c
index 950044a6e77f..ba7acd6e7cc4 100644
--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -919,7 +919,7 @@ static int __usb_bus_reprobe_drivers(struct device *dev, void *data)
 	struct usb_device *udev;
 	int ret;
 
-	if (!is_dev_usb_generic_driver(dev))
+	if (!is_usb_device(dev) || !is_dev_usb_generic_driver(dev))
 		return 0;
 
 	udev = to_usb_device(dev);
-- 
2.26.2

