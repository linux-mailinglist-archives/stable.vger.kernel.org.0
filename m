Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 646A2F2C05
	for <lists+stable@lfdr.de>; Thu,  7 Nov 2019 11:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387831AbfKGKTm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Nov 2019 05:19:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:35154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388081AbfKGKTl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Nov 2019 05:19:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC6C72084D;
        Thu,  7 Nov 2019 10:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573121980;
        bh=E96zVpP7+S/JUPxV7vnJX+TGEGx4w9XM8oiWJs1dKbE=;
        h=Subject:To:From:Date:From;
        b=lSuBfjdsov9wF2w75nGrLDCB5XFiugiBKxmQ81GGvyOIPFxrzenbpzkwj0vchOD15
         lU/9h2hNQT8RrT0bAvHvJop41aPc/J794hqsbARpy/czmu+be/9WXa8MlCCwYozo7x
         kTWT0faHxNZHs7btpPg20M9RsaBDeA51Ukk//VMI=
Subject: patch "appledisplay: fix error handling in the scheduled work" added to usb-testing
To:     oneukum@suse.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 07 Nov 2019 11:19:37 +0100
Message-ID: <15731219775934@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    appledisplay: fix error handling in the scheduled work

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 91feb01596e5efc0cc922cc73f5583114dccf4d2 Mon Sep 17 00:00:00 2001
From: Oliver Neukum <oneukum@suse.com>
Date: Wed, 6 Nov 2019 13:49:01 +0100
Subject: appledisplay: fix error handling in the scheduled work

The work item can operate on

1. stale memory left over from the last transfer
the actual length of the data transfered needs to be checked
2. memory already freed
the error handling in appledisplay_probe() needs
to cancel the work in that case

Reported-and-tested-by: syzbot+495dab1f175edc9c2f13@syzkaller.appspotmail.com
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191106124902.7765-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/appledisplay.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/misc/appledisplay.c b/drivers/usb/misc/appledisplay.c
index ac92725458b5..ba1eaabc7796 100644
--- a/drivers/usb/misc/appledisplay.c
+++ b/drivers/usb/misc/appledisplay.c
@@ -164,7 +164,12 @@ static int appledisplay_bl_get_brightness(struct backlight_device *bd)
 		0,
 		pdata->msgdata, 2,
 		ACD_USB_TIMEOUT);
-	brightness = pdata->msgdata[1];
+	if (retval < 2) {
+		if (retval >= 0)
+			retval = -EMSGSIZE;
+	} else {
+		brightness = pdata->msgdata[1];
+	}
 	mutex_unlock(&pdata->sysfslock);
 
 	if (retval < 0)
@@ -299,6 +304,7 @@ static int appledisplay_probe(struct usb_interface *iface,
 	if (pdata) {
 		if (pdata->urb) {
 			usb_kill_urb(pdata->urb);
+			cancel_delayed_work_sync(&pdata->work);
 			if (pdata->urbdata)
 				usb_free_coherent(pdata->udev, ACD_URB_BUFFER_LEN,
 					pdata->urbdata, pdata->urb->transfer_dma);
-- 
2.23.0


