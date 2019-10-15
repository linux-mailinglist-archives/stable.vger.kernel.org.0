Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A13DFD7ED9
	for <lists+stable@lfdr.de>; Tue, 15 Oct 2019 20:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389024AbfJOSYh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Oct 2019 14:24:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:43824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729413AbfJOSYh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Oct 2019 14:24:37 -0400
Received: from localhost (unknown [38.98.37.135])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D6642086A;
        Tue, 15 Oct 2019 18:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571163876;
        bh=gCPXjOjavlF4EyG4QTDZd/zt1YoeIuVKx6npFEyEHHg=;
        h=Subject:To:From:Date:From;
        b=ucEUfNIoy/wt4muQX34M9TQ64DJUrsnQTa/fK7oNLHB4IYjBkA/0MfNphdFTPPqwH
         m0CN0SHAA6JqXl54vh7VqblPw5t50ujHIACb6X+cMGUAfYAC0McQonqXlRZ3oMuaKi
         aH/9Yn1VZiLdp6ZBdA2ohaNhBpyUKMeVg38/s5D0=
Subject: patch "USB: usblp: fix use-after-free on disconnect" added to usb-linus
To:     johan@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 15 Oct 2019 20:19:42 +0200
Message-ID: <15711635821100@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: usblp: fix use-after-free on disconnect

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 7a759197974894213621aa65f0571b51904733d6 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Tue, 15 Oct 2019 19:55:22 +0200
Subject: USB: usblp: fix use-after-free on disconnect

A recent commit addressing a runtime PM use-count regression, introduced
a use-after-free by not making sure we held a reference to the struct
usb_interface for the lifetime of the driver data.

Fixes: 9a31535859bf ("USB: usblp: fix runtime PM after driver unbind")
Cc: stable <stable@vger.kernel.org>
Reported-by: syzbot+cd24df4d075c319ebfc5@syzkaller.appspotmail.com
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191015175522.18490-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/usblp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/class/usblp.c b/drivers/usb/class/usblp.c
index fb8bd60c83f4..0d8e3f3804a3 100644
--- a/drivers/usb/class/usblp.c
+++ b/drivers/usb/class/usblp.c
@@ -445,6 +445,7 @@ static void usblp_cleanup(struct usblp *usblp)
 	kfree(usblp->readbuf);
 	kfree(usblp->device_id_string);
 	kfree(usblp->statusbuf);
+	usb_put_intf(usblp->intf);
 	kfree(usblp);
 }
 
@@ -1113,7 +1114,7 @@ static int usblp_probe(struct usb_interface *intf,
 	init_waitqueue_head(&usblp->wwait);
 	init_usb_anchor(&usblp->urbs);
 	usblp->ifnum = intf->cur_altsetting->desc.bInterfaceNumber;
-	usblp->intf = intf;
+	usblp->intf = usb_get_intf(intf);
 
 	/* Malloc device ID string buffer to the largest expected length,
 	 * since we can re-query it on an ioctl and a dynamic string
@@ -1198,6 +1199,7 @@ static int usblp_probe(struct usb_interface *intf,
 	kfree(usblp->readbuf);
 	kfree(usblp->statusbuf);
 	kfree(usblp->device_id_string);
+	usb_put_intf(usblp->intf);
 	kfree(usblp);
 abort_ret:
 	return retval;
-- 
2.23.0


