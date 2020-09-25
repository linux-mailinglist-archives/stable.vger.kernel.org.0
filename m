Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6060278B44
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 16:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728858AbgIYOxF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 10:53:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:35772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728731AbgIYOxF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 10:53:05 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB45722B2D;
        Fri, 25 Sep 2020 14:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601045584;
        bh=U8lK+p6jU+KBMSgCRhzeb4YlQw9D+5ZyYsPx+6q24ho=;
        h=Subject:To:From:Date:From;
        b=RwveHSLeQxeDn3XTYEgegJLURAhbAN3uoTTLuRc2py5gVumHjOmzb2NEW2cJhMiD2
         Ntp3edDxI+FoHf4CEIpBjBzad2yBRyRjlVEs6+rWxbAekZe9LmaIsg6ppTI8QBF9Pz
         gDuLRFtVjFPakTyLCIm/8N+AnOMqWAg7y0nkZZLA=
Subject: patch "usbcore/driver: Fix specific driver selection" added to usb-linus
To:     m.v.b@runbox.com, andreyknvl@google.com,
        gregkh@linuxfoundation.org, hadess@hadess.net, shuah@kernel.org,
        stable@vger.kernel.org, stern@rowland.harvard.edu,
        syzkaller@googlegroups.com, valentina.manea.m@gmail.com
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 25 Sep 2020 16:53:15 +0200
Message-ID: <1601045595132125@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usbcore/driver: Fix specific driver selection

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From aea850cd35ae3d266fe6f93fb9edb25e4a555230 Mon Sep 17 00:00:00 2001
From: "M. Vefa Bicakci" <m.v.b@runbox.com>
Date: Tue, 22 Sep 2020 14:07:01 +0300
Subject: usbcore/driver: Fix specific driver selection

This commit resolves a bug in the selection/discovery of more
specific USB device drivers for devices that are currently bound to
generic USB device drivers.

The bug is in the logic that determines whether a device currently
bound to a generic USB device driver should be re-probed by a
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

This bug was found by code inspection and instrumentation while
investigating the root cause of the issue reported by Andrey Konovalov,
where usbip took over syzkaller's virtual USB devices in an undesired
manner. The report is linked below.

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
Link: https://lore.kernel.org/r/20200922110703.720960-3-m.v.b@runbox.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/core/driver.c b/drivers/usb/core/driver.c
index 7e73e989645b..715782995428 100644
--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -924,7 +924,7 @@ static int __usb_bus_reprobe_drivers(struct device *dev, void *data)
 
 	udev = to_usb_device(dev);
 	if (usb_device_match_id(udev, new_udriver->id_table) == NULL &&
-	    (!new_udriver->match || new_udriver->match(udev) != 0))
+	    (!new_udriver->match || new_udriver->match(udev) == 0))
 		return 0;
 
 	ret = device_reprobe(dev);
-- 
2.28.0


