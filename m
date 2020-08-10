Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E578D240A7B
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbgHJPTf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:19:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:49546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727018AbgHJPTe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:19:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82E60207BB;
        Mon, 10 Aug 2020 15:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597072774;
        bh=PvXo4XK8AZRqUTr2CoG0DPYsgX5nyXoeG9ZFRmeqqhI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ivalbHb+4oj30WiXHAf+KbIwdW+VYffT8JSpgUFT3ZvXXtp8YiGessBDkzC8hB6aE
         CN2i8ID/pId9X39WbBYiv6TNVLwjYZ6MVTsd0EDd6veVt8xuo4CTpWN1xfF2jEy+PY
         O+4lFlqPx7MimmMIiy5l4NBOyZDEY6CLauRjsKeA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+80899a8a8efe8968cde7@syzkaller.appspotmail.com,
        Rustam Kovhaev <rkovhaev@gmail.com>
Subject: [PATCH 5.8 13/38] staging: rtl8712: handle firmware load failure
Date:   Mon, 10 Aug 2020 17:19:03 +0200
Message-Id: <20200810151804.549924311@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151803.920113428@linuxfoundation.org>
References: <20200810151803.920113428@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rustam Kovhaev <rkovhaev@gmail.com>

commit b4383c971bc5263efe2b0915ba67ebf2bf3f1ee5 upstream.

when firmware fails to load we should not call unregister_netdev()
this patch fixes a race condition between rtl871x_load_fw_cb() and
r871xu_dev_remove() and fixes the bug reported by syzbot

Reported-by: syzbot+80899a8a8efe8968cde7@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=80899a8a8efe8968cde7
Signed-off-by: Rustam Kovhaev <rkovhaev@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200716151324.1036204-1-rkovhaev@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/rtl8712/hal_init.c |    3 ++-
 drivers/staging/rtl8712/usb_intf.c |   11 ++++++++---
 2 files changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/staging/rtl8712/hal_init.c
+++ b/drivers/staging/rtl8712/hal_init.c
@@ -33,7 +33,6 @@ static void rtl871x_load_fw_cb(const str
 {
 	struct _adapter *adapter = context;
 
-	complete(&adapter->rtl8712_fw_ready);
 	if (!firmware) {
 		struct usb_device *udev = adapter->dvobjpriv.pusbdev;
 		struct usb_interface *usb_intf = adapter->pusb_intf;
@@ -41,11 +40,13 @@ static void rtl871x_load_fw_cb(const str
 		dev_err(&udev->dev, "r8712u: Firmware request failed\n");
 		usb_put_dev(udev);
 		usb_set_intfdata(usb_intf, NULL);
+		complete(&adapter->rtl8712_fw_ready);
 		return;
 	}
 	adapter->fw = firmware;
 	/* firmware available - start netdev */
 	register_netdev(adapter->pnetdev);
+	complete(&adapter->rtl8712_fw_ready);
 }
 
 static const char firmware_file[] = "rtlwifi/rtl8712u.bin";
--- a/drivers/staging/rtl8712/usb_intf.c
+++ b/drivers/staging/rtl8712/usb_intf.c
@@ -595,13 +595,17 @@ static void r871xu_dev_remove(struct usb
 	if (pnetdev) {
 		struct _adapter *padapter = netdev_priv(pnetdev);
 
-		usb_set_intfdata(pusb_intf, NULL);
-		release_firmware(padapter->fw);
 		/* never exit with a firmware callback pending */
 		wait_for_completion(&padapter->rtl8712_fw_ready);
+		pnetdev = usb_get_intfdata(pusb_intf);
+		usb_set_intfdata(pusb_intf, NULL);
+		if (!pnetdev)
+			goto firmware_load_fail;
+		release_firmware(padapter->fw);
 		if (drvpriv.drv_registered)
 			padapter->surprise_removed = true;
-		unregister_netdev(pnetdev); /* will call netdev_close() */
+		if (pnetdev->reg_state != NETREG_UNINITIALIZED)
+			unregister_netdev(pnetdev); /* will call netdev_close() */
 		flush_scheduled_work();
 		udelay(1);
 		/* Stop driver mlme relation timer */
@@ -614,6 +618,7 @@ static void r871xu_dev_remove(struct usb
 		 */
 		usb_put_dev(udev);
 	}
+firmware_load_fail:
 	/* If we didn't unplug usb dongle and remove/insert module, driver
 	 * fails on sitesurvey for the first time when device is up.
 	 * Reset usb port for sitesurvey fail issue.


