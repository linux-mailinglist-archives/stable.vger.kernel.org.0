Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 410AA43516C
	for <lists+stable@lfdr.de>; Wed, 20 Oct 2021 19:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbhJTRjM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 13:39:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:41070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230376AbhJTRjL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Oct 2021 13:39:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E44160F57;
        Wed, 20 Oct 2021 17:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634751417;
        bh=D4e7ZPnHQMO2vaguLwF9vMFU5AT6wrpu3YfVoXubllI=;
        h=Subject:To:From:Date:From;
        b=gSHPlwe4fuVJWXPIJV8Tg3GXBUwt2D7p5MJ8H6r0m1nQRCRglSukq5BMMr8GQjgnF
         T8I5IpCv1RHjI9l/lsEkjAWGqiLYRjU3axu0ja8rBJYFeMnS6h9a4jwU3hriYj2I2m
         ioDfj2z7GcdHUTPj9O1FgcVRekoUqvd31TtA0KLc=
Subject: patch "staging: rtl8712: fix use-after-free in rtl8712_dl_fw" added to staging-testing
To:     paskripkin@gmail.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 20 Oct 2021 19:36:49 +0200
Message-ID: <16347514092631@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: rtl8712: fix use-after-free in rtl8712_dl_fw

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the staging-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From c052cc1a069c3e575619cf64ec427eb41176ca70 Mon Sep 17 00:00:00 2001
From: Pavel Skripkin <paskripkin@gmail.com>
Date: Wed, 20 Oct 2021 00:17:18 +0300
Subject: staging: rtl8712: fix use-after-free in rtl8712_dl_fw

Syzbot reported use-after-free in rtl8712_dl_fw(). The problem was in
race condition between r871xu_dev_remove() ->ndo_open() callback.

It's easy to see from crash log, that driver accesses released firmware
in ->ndo_open() callback. It may happen, since driver was releasing
firmware _before_ unregistering netdev. Fix it by moving
unregister_netdev() before cleaning up resources.

Call Trace:
...
 rtl871x_open_fw drivers/staging/rtl8712/hal_init.c:83 [inline]
 rtl8712_dl_fw+0xd95/0xe10 drivers/staging/rtl8712/hal_init.c:170
 rtl8712_hal_init drivers/staging/rtl8712/hal_init.c:330 [inline]
 rtl871x_hal_init+0xae/0x180 drivers/staging/rtl8712/hal_init.c:394
 netdev_open+0xe6/0x6c0 drivers/staging/rtl8712/os_intfs.c:380
 __dev_open+0x2bc/0x4d0 net/core/dev.c:1484

Freed by task 1306:
...
 release_firmware+0x1b/0x30 drivers/base/firmware_loader/main.c:1053
 r871xu_dev_remove+0xcc/0x2c0 drivers/staging/rtl8712/usb_intf.c:599
 usb_unbind_interface+0x1d8/0x8d0 drivers/usb/core/driver.c:458

Fixes: 8c213fa59199 ("staging: r8712u: Use asynchronous firmware loading")
Cc: stable <stable@vger.kernel.org>
Reported-and-tested-by: syzbot+c55162be492189fb4f51@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Link: https://lore.kernel.org/r/20211019211718.26354-1-paskripkin@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8712/usb_intf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8712/usb_intf.c b/drivers/staging/rtl8712/usb_intf.c
index 17e705411e64..ee4c61f85a07 100644
--- a/drivers/staging/rtl8712/usb_intf.c
+++ b/drivers/staging/rtl8712/usb_intf.c
@@ -595,12 +595,12 @@ static void r871xu_dev_remove(struct usb_interface *pusb_intf)
 
 	/* never exit with a firmware callback pending */
 	wait_for_completion(&padapter->rtl8712_fw_ready);
+	if (pnetdev->reg_state != NETREG_UNINITIALIZED)
+		unregister_netdev(pnetdev); /* will call netdev_close() */
 	usb_set_intfdata(pusb_intf, NULL);
 	release_firmware(padapter->fw);
 	if (drvpriv.drv_registered)
 		padapter->surprise_removed = true;
-	if (pnetdev->reg_state != NETREG_UNINITIALIZED)
-		unregister_netdev(pnetdev); /* will call netdev_close() */
 	r8712_flush_rwctrl_works(padapter);
 	r8712_flush_led_works(padapter);
 	udelay(1);
-- 
2.33.1


