Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC7C26E5DA
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 21:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727550AbgIQOny (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 10:43:54 -0400
Received: from aibo.runbox.com ([91.220.196.211]:55470 "EHLO aibo.runbox.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727648AbgIQOmS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 10:42:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
         s=selector2; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To
        :Message-Id:Date:Subject:Cc:To:From;
        bh=WaCu4zldHM3wFml3XoeYbHVyOElXbVex+B6UOeOoYQs=; b=K5nbWtU2dkwkGPzspMmSTpOjNX
        lXlAcg9cV3ApcaEGvrjC/EaeltW8ObTwpXDVerxkdpOMJFeHdnaJSkZwzGW0gr3Fm3YSRljTAohW2
        H6K+q/asalUdLPBBh9zmyqt+1rDaieydvu8fD4IJPy2RMzNuVa4BOLf9HZsTpixmh6TgALK3aIqPq
        bYd5tMkGTS0+gB2/gyuK3nD7WSrLhFKc0OKW4/EkXTb/qj4cWj6RagaVXI26mGVa4AGLNQttj3Dot
        nAM0gtLKF3aq2NQBGa9f5uar92GpNBZVx26DOLyBoa5a6n5IOPOPv9Hirnq+wazpNNSAhMFkCKHNV
        /lqiI7QQ==;
Received: from [10.9.9.72] (helo=submission01.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <m.v.b@runbox.com>)
        id 1kIv6z-0007ku-MD; Thu, 17 Sep 2020 16:42:13 +0200
Received: by submission01.runbox with esmtpsa  [Authenticated alias (536975)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1kIv6m-0002ee-8o; Thu, 17 Sep 2020 16:42:00 +0200
From:   "M. Vefa Bicakci" <m.v.b@runbox.com>
To:     linux-usb@vger.kernel.org
Cc:     "M. Vefa Bicakci" <m.v.b@runbox.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Bastien Nocera <hadess@hadess.net>, syzkaller@googlegroups.com
Subject: [PATCH 1/3] usbcore/driver: Fix specific driver selection
Date:   Thu, 17 Sep 2020 17:41:49 +0300
Message-Id: <20200917144151.355848-1-m.v.b@runbox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <a6e14983a8849d5f75a43f403c7cc721b6e4a420.camel@hadess.net>
References: <a6e14983a8849d5f75a43f403c7cc721b6e4a420.camel@hadess.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

This bug was found by code inspection and instrumentation after
Andrey Konovalov's report indicating USB/IP subsystem's misbehaviour
with the generic USB device driver matching code.

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
 drivers/usb/core/driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/core/driver.c b/drivers/usb/core/driver.c
index c976ea9f9582..950044a6e77f 100644
--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -924,7 +924,7 @@ static int __usb_bus_reprobe_drivers(struct device *dev, void *data)
 
 	udev = to_usb_device(dev);
 	if (usb_device_match_id(udev, new_udriver->id_table) == NULL &&
-	    (!new_udriver->match || new_udriver->match(udev) != 0))
+	    (!new_udriver->match || new_udriver->match(udev) == 0))
 		return 0;
 
 	ret = device_reprobe(dev);

base-commit: 871e6496207c6aa94134448779c77631a11bfa2e
-- 
2.26.2

