Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7C9D33109E
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 15:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbhCHOSS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 09:18:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:42138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229757AbhCHORy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 09:17:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E7CD651DC;
        Mon,  8 Mar 2021 14:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615213073;
        bh=HgwOtAvrn5rTp8q5QTATCqXskzRfM6D7p/zBOiJvnNs=;
        h=Subject:To:From:Date:From;
        b=yjFvZ3A959hisqLvxGEYcdk4YI07vjSl8rXFfKJPUrsy/loKUqB5Ut1eO/ruHeWgQ
         Pg4PK06aZsc5OU+PG4El0/bXVXPfbyEBoe74p22Guc0w+Gqk2TFDSEI4FdysBukpGP
         n1aoLx3ZIyrjcQ4x9J4T3FzNdc8XLxPsE4c7nl18=
Subject: patch "USB: usblp: fix a hang in poll() if disconnected" added to usb-linus
To:     zaitcev@redhat.com, gregkh@linuxfoundation.org,
        qiang.zhang@windriver.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 08 Mar 2021 15:17:39 +0100
Message-ID: <1615213059236174@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: usblp: fix a hang in poll() if disconnected

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 7f6f181b3e2c4d08f5d693eebe7901a28fab8666 Mon Sep 17 00:00:00 2001
From: Pete Zaitcev <zaitcev@redhat.com>
Date: Wed, 3 Mar 2021 22:10:53 -0600
Subject: USB: usblp: fix a hang in poll() if disconnected

Apparently an application that opens a device and calls select()
on it, will hang if the decice is disconnected. It's a little
surprising that we had this bug for 15 years, but apparently
nobody ever uses select() with a printer: only write() and read(),
and those work fine. Well, you can also select() with a timeout.

The fix is modeled after devio.c. A few other drivers check the
condition first, then do not add the wait queue in case the
device is disconnected. We doubt that's completely race-free.
So, this patch adds the process first, then locks properly
and checks for the disconnect.

Reviewed-by: Zqiang <qiang.zhang@windriver.com>
Signed-off-by: Pete Zaitcev <zaitcev@redhat.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210303221053.1cf3313e@suzdal.zaitcev.lan
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/usblp.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/class/usblp.c b/drivers/usb/class/usblp.c
index c9f6e9758288..f27b4aecff3d 100644
--- a/drivers/usb/class/usblp.c
+++ b/drivers/usb/class/usblp.c
@@ -494,16 +494,24 @@ static int usblp_release(struct inode *inode, struct file *file)
 /* No kernel lock - fine */
 static __poll_t usblp_poll(struct file *file, struct poll_table_struct *wait)
 {
-	__poll_t ret;
+	struct usblp *usblp = file->private_data;
+	__poll_t ret = 0;
 	unsigned long flags;
 
-	struct usblp *usblp = file->private_data;
 	/* Should we check file->f_mode & FMODE_WRITE before poll_wait()? */
 	poll_wait(file, &usblp->rwait, wait);
 	poll_wait(file, &usblp->wwait, wait);
+
+	mutex_lock(&usblp->mut);
+	if (!usblp->present)
+		ret |= EPOLLHUP;
+	mutex_unlock(&usblp->mut);
+
 	spin_lock_irqsave(&usblp->lock, flags);
-	ret = ((usblp->bidir && usblp->rcomplete) ? EPOLLIN  | EPOLLRDNORM : 0) |
-	   ((usblp->no_paper || usblp->wcomplete) ? EPOLLOUT | EPOLLWRNORM : 0);
+	if (usblp->bidir && usblp->rcomplete)
+		ret |= EPOLLIN  | EPOLLRDNORM;
+	if (usblp->no_paper || usblp->wcomplete)
+		ret |= EPOLLOUT | EPOLLWRNORM;
 	spin_unlock_irqrestore(&usblp->lock, flags);
 	return ret;
 }
-- 
2.30.1


