Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5EDCB702
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 11:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730423AbfJDJEc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 05:04:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:34866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbfJDJEc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Oct 2019 05:04:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4D1A207FF;
        Fri,  4 Oct 2019 09:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570179871;
        bh=E26K2FRiqtXZQYf4D80AofVKB4j2w6lfNBVurLBb8no=;
        h=Subject:To:From:Date:From;
        b=sh8xthX3QDyYopePOLccwIl6HKWEg8oL3kVv5rwFWkYNAP2V6xB4+zQc+A8tzFz/+
         PXFgkbaPsgVTvEE+ysd49H2JGGiglGhQtLQ1dmNw6m+PZbnqDUC0PMl3bbvj1qCmaN
         9Y/Q3TI/Wyvf959r5gKMnS9C8IZ387EGnnI2+ZE4=
Subject: patch "USB: yurex: Don't retry on unexpected errors" added to usb-linus
To:     stern@rowland.harvard.edu, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, tomoki.sekiyama@gmail.com
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 04 Oct 2019 11:04:12 +0200
Message-ID: <157017985216627@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: yurex: Don't retry on unexpected errors

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 32a0721c6620b77504916dac0cea8ad497c4878a Mon Sep 17 00:00:00 2001
From: Alan Stern <stern@rowland.harvard.edu>
Date: Tue, 17 Sep 2019 12:47:23 -0400
Subject: USB: yurex: Don't retry on unexpected errors

According to Greg KH, it has been generally agreed that when a USB
driver encounters an unknown error (or one it can't handle directly),
it should just give up instead of going into a potentially infinite
retry loop.

The three codes -EPROTO, -EILSEQ, and -ETIME fall into this category.
They can be caused by bus errors such as packet loss or corruption,
attempting to communicate with a disconnected device, or by malicious
firmware.  Nowadays the extent of packet loss or corruption is
negligible, so it should be safe for a driver to give up whenever one
of these errors occurs.

Although the yurex driver handles -EILSEQ errors in this way, it
doesn't do the same for -EPROTO (as discovered by the syzbot fuzzer)
or other unrecognized errors.  This patch adjusts the driver so that
it doesn't log an error message for -EPROTO or -ETIME, and it doesn't
retry after any errors.

Reported-and-tested-by: syzbot+b24d736f18a1541ad550@syzkaller.appspotmail.com
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: Tomoki Sekiyama <tomoki.sekiyama@gmail.com>
CC: <stable@vger.kernel.org>

Link: https://lore.kernel.org/r/Pine.LNX.4.44L0.1909171245410.1590-100000@iolanthe.rowland.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/yurex.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/misc/yurex.c b/drivers/usb/misc/yurex.c
index 6715a128e6c8..8d52d4336c29 100644
--- a/drivers/usb/misc/yurex.c
+++ b/drivers/usb/misc/yurex.c
@@ -132,6 +132,7 @@ static void yurex_interrupt(struct urb *urb)
 	switch (status) {
 	case 0: /*success*/
 		break;
+	/* The device is terminated or messed up, give up */
 	case -EOVERFLOW:
 		dev_err(&dev->interface->dev,
 			"%s - overflow with length %d, actual length is %d\n",
@@ -140,12 +141,13 @@ static void yurex_interrupt(struct urb *urb)
 	case -ENOENT:
 	case -ESHUTDOWN:
 	case -EILSEQ:
-		/* The device is terminated, clean up */
+	case -EPROTO:
+	case -ETIME:
 		return;
 	default:
 		dev_err(&dev->interface->dev,
 			"%s - unknown status received: %d\n", __func__, status);
-		goto exit;
+		return;
 	}
 
 	/* handle received message */
@@ -177,7 +179,6 @@ static void yurex_interrupt(struct urb *urb)
 		break;
 	}
 
-exit:
 	retval = usb_submit_urb(dev->urb, GFP_ATOMIC);
 	if (retval) {
 		dev_err(&dev->interface->dev, "%s - usb_submit_urb failed: %d\n",
-- 
2.23.0


