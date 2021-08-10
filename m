Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 408833E81AC
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 20:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237213AbhHJSBT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 14:01:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:60118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238063AbhHJR7R (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:59:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66A5561181;
        Tue, 10 Aug 2021 17:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617573;
        bh=Gkv8usg/hRL6/6cAr9d4ZngDvOLRKk8GTGE5ck5X+dU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gAw7n7LH5tyQAx1YSdh7LnMNAl4mugCLa1SpP5Dz4QQR366WqYmyVv6u12e922g3l
         2iVU3+j0kmMPnC+KBzXI3as7m3YmeDXYJDHdLdZB85ZkKxlpyEonvNYCTXVJmg3H9p
         txVdKYWjobBVJqVdDXEUsqNs0QrwMIsT5KIwqVLc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+5872a520e0ce0a7c7230@syzkaller.appspotmail.com,
        syzbot+cc699626e48a6ebaf295@syzkaller.appspotmail.com
Subject: [PATCH 5.13 118/175] staging: rtl8712: error handling refactoring
Date:   Tue, 10 Aug 2021 19:30:26 +0200
Message-Id: <20210810173004.836493220@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

commit e9e6aa51b2735d83a67d9fa0119cf11abef80d99 upstream.

There was strange error handling logic in case of fw load failure. For
some reason fw loader callback was doing clean up stuff when fw is not
available. I don't see any reason behind doing this. Since this driver
doesn't have EEPROM firmware let's just disconnect it in case of fw load
failure. Doing clean up stuff in 2 different place which can run
concurently is not good idea and syzbot found 2 bugs related to this
strange approach.

So, in this pacth I deleted all clean up code from fw callback and made
a call to device_release_driver() under device_lock(parent) in case of fw
load failure. This approach is more generic and it defend driver from UAF
bugs, since all clean up code is moved to one place.

Fixes: e02a3b945816 ("staging: rtl8712: fix memory leak in rtl871x_load_fw_cb")
Fixes: 8c213fa59199 ("staging: r8712u: Use asynchronous firmware loading")
Cc: stable <stable@vger.kernel.org>
Reported-and-tested-by: syzbot+5872a520e0ce0a7c7230@syzkaller.appspotmail.com
Reported-and-tested-by: syzbot+cc699626e48a6ebaf295@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Link: https://lore.kernel.org/r/d49ecc56e97c4df181d7bd4d240b031f315eacc3.1626895918.git.paskripkin@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8712/hal_init.c |   30 +++++++++++++++--------
 drivers/staging/rtl8712/usb_intf.c |   48 ++++++++++++++++---------------------
 2 files changed, 41 insertions(+), 37 deletions(-)

--- a/drivers/staging/rtl8712/hal_init.c
+++ b/drivers/staging/rtl8712/hal_init.c
@@ -29,21 +29,31 @@
 #define FWBUFF_ALIGN_SZ 512
 #define MAX_DUMP_FWSZ (48 * 1024)
 
+static void rtl871x_load_fw_fail(struct _adapter *adapter)
+{
+	struct usb_device *udev = adapter->dvobjpriv.pusbdev;
+	struct device *dev = &udev->dev;
+	struct device *parent = dev->parent;
+
+	complete(&adapter->rtl8712_fw_ready);
+
+	dev_err(&udev->dev, "r8712u: Firmware request failed\n");
+
+	if (parent)
+		device_lock(parent);
+
+	device_release_driver(dev);
+
+	if (parent)
+		device_unlock(parent);
+}
+
 static void rtl871x_load_fw_cb(const struct firmware *firmware, void *context)
 {
 	struct _adapter *adapter = context;
 
 	if (!firmware) {
-		struct usb_device *udev = adapter->dvobjpriv.pusbdev;
-		struct usb_interface *usb_intf = adapter->pusb_intf;
-
-		dev_err(&udev->dev, "r8712u: Firmware request failed\n");
-		usb_put_dev(udev);
-		usb_set_intfdata(usb_intf, NULL);
-		r8712_free_drv_sw(adapter);
-		adapter->dvobj_deinit(adapter);
-		complete(&adapter->rtl8712_fw_ready);
-		free_netdev(adapter->pnetdev);
+		rtl871x_load_fw_fail(adapter);
 		return;
 	}
 	adapter->fw = firmware;
--- a/drivers/staging/rtl8712/usb_intf.c
+++ b/drivers/staging/rtl8712/usb_intf.c
@@ -594,36 +594,30 @@ static void r871xu_dev_remove(struct usb
 {
 	struct net_device *pnetdev = usb_get_intfdata(pusb_intf);
 	struct usb_device *udev = interface_to_usbdev(pusb_intf);
+	struct _adapter *padapter = netdev_priv(pnetdev);
 
-	if (pnetdev) {
-		struct _adapter *padapter = netdev_priv(pnetdev);
+	/* never exit with a firmware callback pending */
+	wait_for_completion(&padapter->rtl8712_fw_ready);
+	usb_set_intfdata(pusb_intf, NULL);
+	release_firmware(padapter->fw);
+	if (drvpriv.drv_registered)
+		padapter->surprise_removed = true;
+	if (pnetdev->reg_state != NETREG_UNINITIALIZED)
+		unregister_netdev(pnetdev); /* will call netdev_close() */
+	r8712_flush_rwctrl_works(padapter);
+	r8712_flush_led_works(padapter);
+	udelay(1);
+	/* Stop driver mlme relation timer */
+	r8712_stop_drv_timers(padapter);
+	r871x_dev_unload(padapter);
+	r8712_free_drv_sw(padapter);
+	free_netdev(pnetdev);
 
-		/* never exit with a firmware callback pending */
-		wait_for_completion(&padapter->rtl8712_fw_ready);
-		pnetdev = usb_get_intfdata(pusb_intf);
-		usb_set_intfdata(pusb_intf, NULL);
-		if (!pnetdev)
-			goto firmware_load_fail;
-		release_firmware(padapter->fw);
-		if (drvpriv.drv_registered)
-			padapter->surprise_removed = true;
-		if (pnetdev->reg_state != NETREG_UNINITIALIZED)
-			unregister_netdev(pnetdev); /* will call netdev_close() */
-		r8712_flush_rwctrl_works(padapter);
-		r8712_flush_led_works(padapter);
-		udelay(1);
-		/* Stop driver mlme relation timer */
-		r8712_stop_drv_timers(padapter);
-		r871x_dev_unload(padapter);
-		r8712_free_drv_sw(padapter);
-		free_netdev(pnetdev);
+	/* decrease the reference count of the usb device structure
+	 * when disconnect
+	 */
+	usb_put_dev(udev);
 
-		/* decrease the reference count of the usb device structure
-		 * when disconnect
-		 */
-		usb_put_dev(udev);
-	}
-firmware_load_fail:
 	/* If we didn't unplug usb dongle and remove/insert module, driver
 	 * fails on sitesurvey for the first time when device is up.
 	 * Reset usb port for sitesurvey fail issue.


