Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2911A283A1B
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbgJEPbT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:31:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:58120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727855AbgJEPbR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:31:17 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CB5920637;
        Mon,  5 Oct 2020 15:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911876;
        bh=0GjEP2suzy0wB6utPip3sV2xYtrHHvjSr4BqU5jp9Zw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=akMlBtIsNU/ynzVlbIMoOUyPiiqzBwaSisaTITN1GGe4nvxswL1oafXpIrvHsrgpZ
         4bbo0uTPkMiSZiOa9yhBI43QwEvXGscHtITTwo+gfaEOgMzWtsatlwi5/UeXk9z2pk
         6vGtN8znFbG4WNP1VJhjJXNEb25Kgg1wHYNV5PX4=
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
Subject: [PATCH 5.8 06/85] usbcore/driver: Fix specific driver selection
Date:   Mon,  5 Oct 2020 17:26:02 +0200
Message-Id: <20201005142115.051069935@linuxfoundation.org>
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

commit aea850cd35ae3d266fe6f93fb9edb25e4a555230 upstream.

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
 drivers/usb/core/driver.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -924,7 +924,7 @@ static int __usb_bus_reprobe_drivers(str
 
 	udev = to_usb_device(dev);
 	if (usb_device_match_id(udev, new_udriver->id_table) == NULL &&
-	    (!new_udriver->match || new_udriver->match(udev) != 0))
+	    (!new_udriver->match || new_udriver->match(udev) == 0))
 		return 0;
 
 	ret = device_reprobe(dev);


