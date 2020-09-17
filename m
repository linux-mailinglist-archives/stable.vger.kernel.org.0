Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6660A26D8D9
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 12:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbgIQKXN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 06:23:13 -0400
Received: from aibo.runbox.com ([91.220.196.211]:49604 "EHLO aibo.runbox.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726755AbgIQKWY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 06:22:24 -0400
X-Greylist: delayed 1318 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 06:22:23 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
         s=selector2; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To
        :Message-Id:Date:Subject:Cc:To:From;
        bh=jYC5vfpyAOB01Xz9fU7PjyTQCLGjlSBNPFV1rX8wF80=; b=lS9/tnSpcaYmdNgHqULwAOivIF
        ODW6rbCdbp0yYAMYyog3a8a3r/2B3iUmFZ+Z295E0i5n5owjJZHhcdc4Aqy2QJxPtdnJL1DSchERi
        2NReIXuzEJ8x+rBoh+VG1MyrY02Y/pCubTZkSLPuN16rGx0HwTCfZ7enwu9HTHa7sbroKouEOcl6u
        DNrwvH49EfBK9L0kuRAYxDylCND6BbwYwF71C3WKv/4r4mIF3NQTSXBGUEew4w6VSx0o2zmPZ+/tU
        2+prygvxHHgGBtDEeYW7NDHOP9jiYW+d27zYhfOFCCBSBZ2uxwxvhvwOe0bhHrbAtpaqhgPF+0KS8
        HgOlzLYQ==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <m.v.b@runbox.com>)
        id 1kIqi8-00078t-Qt; Thu, 17 Sep 2020 12:00:17 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated alias (536975)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1kIqi8-00076h-3J; Thu, 17 Sep 2020 12:00:16 +0200
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
Subject: [PATCH 2/2] usbip: Make the driver's match function specific
Date:   Thu, 17 Sep 2020 12:59:59 +0300
Message-Id: <20200917095959.174378-2-m.v.b@runbox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200917095959.174378-1-m.v.b@runbox.com>
References: <359d080c-5cbb-250a-0ebd-aaba5f5c530d@runbox.com>
 <20200917095959.174378-1-m.v.b@runbox.com>
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

