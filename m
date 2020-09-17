Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18D3426E5DB
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 21:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727687AbgIQOng (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 10:43:36 -0400
Received: from aibo.runbox.com ([91.220.196.211]:44960 "EHLO aibo.runbox.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727641AbgIQOmQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 10:42:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
         s=selector2; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To
        :Message-Id:Date:Subject:Cc:To:From;
        bh=jYC5vfpyAOB01Xz9fU7PjyTQCLGjlSBNPFV1rX8wF80=; b=UdIyK5YcbcJK/sE20vl9eIdY+0
        7Yuwn/2NTwL2mPvPbiwx+wmxKwJ/2E3jSMUZ48DFehw6Sr1pkR4vPZN24T+Smi+iTkCS185isl9V9
        VpV7avfNrKsAPgUHUZAJTiQt7ucOtwFlM7A7nq6E7MXaLuMZiQ1b9FiFfIt7vml6PJ0wLYwwdX/kK
        pS4kw/8+Ezf6SPMhEZffiohd8jKkWR0JU4l/1clxSvCvtgxf31OkwUhsk39hV3fk+lWrdBR+qKWSz
        oPJm/avtxGWfBCJw9Ovupm0nWEmMJ6lvr8wX0dCK0+s4qtBD3VwMAo1T3WkH8JpyWgfRMPDwGbSJc
        GYIag1lA==;
Received: from [10.9.9.72] (helo=submission01.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <m.v.b@runbox.com>)
        id 1kIv6y-0001Ko-KU; Thu, 17 Sep 2020 16:42:12 +0200
Received: by submission01.runbox with esmtpsa  [Authenticated alias (536975)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1kIv6p-0002ee-CS; Thu, 17 Sep 2020 16:42:03 +0200
From:   "M. Vefa Bicakci" <m.v.b@runbox.com>
To:     linux-usb@vger.kernel.org
Cc:     "M. Vefa Bicakci" <m.v.b@runbox.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        stable@vger.kernel.org, Bastien Nocera <hadess@hadess.net>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        syzkaller@googlegroups.com
Subject: [PATCH 3/3] usbip: Make the driver's match function specific
Date:   Thu, 17 Sep 2020 17:41:51 +0300
Message-Id: <20200917144151.355848-3-m.v.b@runbox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200917144151.355848-1-m.v.b@runbox.com>
References: <a6e14983a8849d5f75a43f403c7cc721b6e4a420.camel@hadess.net>
 <20200917144151.355848-1-m.v.b@runbox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Prior to this commit, the USB-IP subsystem's USB device driver match
function used to match all USB devices (by returning true
unconditionally). Unfortunately, this is not correct behaviour and is
likely the root cause of the bug reported by Andrey Konovalov.

USB-IP should only match USB devices that the user-space asked the kernel
to handle via USB-IP, by writing to the match_busid sysfs file, which is
what this commit aims to achieve. This is done by making the match
function check that the passed in USB device was indeed requested by the
user-space to be handled by USB-IP.

Reported-by: Andrey Konovalov <andreyknvl@google.com>
Fixes: 7a2f2974f2 ("usbip: Implement a match function to fix usbip")
Link: https://lore.kernel.org/linux-usb/CAAeHK+zOrHnxjRFs=OE8T=O9208B9HP_oo8RZpyVOZ9AJ54pAA@mail.gmail.com/
Cc: <stable@vger.kernel.org> # 5.8
Cc: Bastien Nocera <hadess@hadess.net>
Cc: Valentina Manea <valentina.manea.m@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: <syzkaller@googlegroups.com>
Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>
---
 drivers/usb/usbip/stub_dev.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/usbip/stub_dev.c b/drivers/usb/usbip/stub_dev.c
index 9d7d642022d1..3d9c8ff6762e 100644
--- a/drivers/usb/usbip/stub_dev.c
+++ b/drivers/usb/usbip/stub_dev.c
@@ -463,7 +463,20 @@ static void stub_disconnect(struct usb_device *udev)
 
 static bool usbip_match(struct usb_device *udev)
 {
-	return true;
+	bool match;
+	struct bus_id_priv *busid_priv;
+	const char *udev_busid = dev_name(&udev->dev);
+
+	busid_priv = get_busid_priv(udev_busid);
+	if (!busid_priv)
+		return false;
+
+	match = (busid_priv->status != STUB_BUSID_REMOV &&
+		 busid_priv->status != STUB_BUSID_OTHER);
+
+	put_busid_priv(busid_priv);
+
+	return match;
 }
 
 #ifdef CONFIG_PM
-- 
2.26.2

