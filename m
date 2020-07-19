Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECAE92250DA
	for <lists+stable@lfdr.de>; Sun, 19 Jul 2020 11:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbgGSJUH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Jul 2020 05:20:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:52554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725988AbgGSJUG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 19 Jul 2020 05:20:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71785207FC;
        Sun, 19 Jul 2020 09:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595150406;
        bh=fuNpv81Fw2JuJDTtpSlmf8gUP+TmhbosBCh7mKghI+g=;
        h=Subject:To:From:Date:From;
        b=0Me7VQaS8rOZfoDdq6GKmIoh7QffNqF2kz9QlRXSqheOMI7kDmhuxTyr6P4YC+7jp
         avkCUw0QOBN8ONmpyLceROVIi2tnAYtMkNFZvsuAXYIa+DQSu8Au2tyLcirbeTYoZa
         zpVqKb3F+h4zn1EF/K76drpAMVT35W60n3nDccRM=
Subject: patch "staging: rtl8712: handle firmware load failure" added to staging-next
To:     rkovhaev@gmail.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 19 Jul 2020 11:16:29 +0200
Message-ID: <1595150189130138@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: rtl8712: handle firmware load failure

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From b4383c971bc5263efe2b0915ba67ebf2bf3f1ee5 Mon Sep 17 00:00:00 2001
From: Rustam Kovhaev <rkovhaev@gmail.com>
Date: Thu, 16 Jul 2020 08:13:26 -0700
Subject: staging: rtl8712: handle firmware load failure

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
 drivers/staging/rtl8712/hal_init.c |  3 ++-
 drivers/staging/rtl8712/usb_intf.c | 11 ++++++++---
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8712/hal_init.c b/drivers/staging/rtl8712/hal_init.c
index ed51023b85a0..715f1fe8b472 100644
--- a/drivers/staging/rtl8712/hal_init.c
+++ b/drivers/staging/rtl8712/hal_init.c
@@ -33,7 +33,6 @@ static void rtl871x_load_fw_cb(const struct firmware *firmware, void *context)
 {
 	struct _adapter *adapter = context;
 
-	complete(&adapter->rtl8712_fw_ready);
 	if (!firmware) {
 		struct usb_device *udev = adapter->dvobjpriv.pusbdev;
 		struct usb_interface *usb_intf = adapter->pusb_intf;
@@ -41,11 +40,13 @@ static void rtl871x_load_fw_cb(const struct firmware *firmware, void *context)
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
diff --git a/drivers/staging/rtl8712/usb_intf.c b/drivers/staging/rtl8712/usb_intf.c
index a87562f632a7..2fcd65260f4c 100644
--- a/drivers/staging/rtl8712/usb_intf.c
+++ b/drivers/staging/rtl8712/usb_intf.c
@@ -595,13 +595,17 @@ static void r871xu_dev_remove(struct usb_interface *pusb_intf)
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
@@ -614,6 +618,7 @@ static void r871xu_dev_remove(struct usb_interface *pusb_intf)
 		 */
 		usb_put_dev(udev);
 	}
+firmware_load_fail:
 	/* If we didn't unplug usb dongle and remove/insert module, driver
 	 * fails on sitesurvey for the first time when device is up.
 	 * Reset usb port for sitesurvey fail issue.
-- 
2.27.0


