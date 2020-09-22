Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71A04274066
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 13:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbgIVLHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 07:07:36 -0400
Received: from aibo.runbox.com ([91.220.196.211]:51622 "EHLO aibo.runbox.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726340AbgIVLHg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Sep 2020 07:07:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
         s=selector2; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To
        :Message-Id:Date:Subject:Cc:To:From;
        bh=J9tHTJNHwgpZ+uiXbuJyprpeAr/tHIoXWflEBxP+l6w=; b=gSVHNrVRxOhK9vtDhSrARqze4+
        vG88XGkfylxvPet48bO/a/YoP4yLI11JrIZ+t7ilbQq8QjdDulPH6LKZMuH+qYsl2TBPIkmVo9Xn/
        IOr12TBkh2iGbklEytSBd2LHfc0WdShYO2FK1vsSITI0SV/uONNIkDLFnPnQyPYJW1JtLGdK9DI8T
        SSqVoWXTrR5TJRZ/hMUNZspj/ftO/DWZOn1iDUzxwO4ieNJsZztByLHHWkMtrb5+MyqcK8k8SdHhc
        FkW57ONhvTS/W7Rbs/v8YrZMgon6Ug92F06+kz5InuV/mlYF3W9ay3zMX+ZKV6OLpxracq0EzB+gX
        OsZUKDNA==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <m.v.b@runbox.com>)
        id 1kKg8z-0005ve-1s; Tue, 22 Sep 2020 13:07:33 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated alias (536975)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1kKg8q-0000Pz-3x; Tue, 22 Sep 2020 13:07:24 +0200
From:   "M. Vefa Bicakci" <m.v.b@runbox.com>
To:     linux-usb@vger.kernel.org
Cc:     "M. Vefa Bicakci" <m.v.b@runbox.com>, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Bastien Nocera <hadess@hadess.net>,
        Shuah Khan <shuah@kernel.org>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        syzkaller@googlegroups.com
Subject: [PATCH v3 2/4] usbcore/driver: Fix specific driver selection
Date:   Tue, 22 Sep 2020 14:07:01 +0300
Message-Id: <20200922110703.720960-3-m.v.b@runbox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200922110703.720960-1-m.v.b@runbox.com>
References: <20200922110703.720960-1-m.v.b@runbox.com>
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

This bug was found by code inspection and instrumentation while
investigating the root cause of the issue reported by Andrey Konovalov,
where usbip took over syzkaller's virtual USB devices in an undesired
manner. The report is linked below.

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
v3: No functional changes; only commit message changes.
v2: Following Bastien Nocera's suggestion, this is a new patch,
    split from the patch published at:
      https://lore.kernel.org/linux-usb/20200917095959.174378-1-m.v.b@runbox.com/
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
-- 
2.26.2

