Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C303A8604B
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 12:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbfHHKnh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 06:43:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:37888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731839AbfHHKng (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 06:43:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D4662084D;
        Thu,  8 Aug 2019 10:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565261015;
        bh=pTMgT2+jISMvwig0rgnybBNKaQv2EiluveHjJyy9Ljs=;
        h=Subject:To:From:Date:From;
        b=Ls05l4CdHhze+Fyhm2NYFLjYglhszD7lkmwlRqBFxYlAGJQyIB6RtNUXr4Hl/r4Qk
         S+9gNczdHwJNVehOu2sMNlfuDGyh1MNjvYjIFGwU/gdXvHwsUJOho+kPNjxq1PHgrR
         dl2NbaxO2U/JpzcMQOHqWd/tBC3/raalo0PKqjIo=
Subject: patch "usb: iowarrior: fix deadlock on disconnect" added to usb-linus
To:     oneukum@suse.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 08 Aug 2019 12:43:25 +0200
Message-ID: <1565261005223225@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: iowarrior: fix deadlock on disconnect

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From c468a8aa790e0dfe0a7f8a39db282d39c2c00b46 Mon Sep 17 00:00:00 2001
From: Oliver Neukum <oneukum@suse.com>
Date: Thu, 8 Aug 2019 11:27:28 +0200
Subject: usb: iowarrior: fix deadlock on disconnect

We have to drop the mutex before we close() upon disconnect()
as close() needs the lock. This is safe to do by dropping the
mutex as intfdata is already set to NULL, so open() will fail.

Fixes: 03f36e885fc26 ("USB: open disconnect race in iowarrior")
Reported-by: syzbot+a64a382964bf6c71a9c0@syzkaller.appspotmail.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20190808092728.23417-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/iowarrior.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/misc/iowarrior.c b/drivers/usb/misc/iowarrior.c
index ba05dd80a020..f5bed9f29e56 100644
--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -866,19 +866,20 @@ static void iowarrior_disconnect(struct usb_interface *interface)
 	dev = usb_get_intfdata(interface);
 	mutex_lock(&iowarrior_open_disc_lock);
 	usb_set_intfdata(interface, NULL);
+	/* prevent device read, write and ioctl */
+	dev->present = 0;
 
 	minor = dev->minor;
+	mutex_unlock(&iowarrior_open_disc_lock);
+	/* give back our minor - this will call close() locks need to be dropped at this point*/
 
-	/* give back our minor */
 	usb_deregister_dev(interface, &iowarrior_class);
 
 	mutex_lock(&dev->mutex);
 
 	/* prevent device read, write and ioctl */
-	dev->present = 0;
 
 	mutex_unlock(&dev->mutex);
-	mutex_unlock(&iowarrior_open_disc_lock);
 
 	if (dev->opened) {
 		/* There is a process that holds a filedescriptor to the device ,
-- 
2.22.0


