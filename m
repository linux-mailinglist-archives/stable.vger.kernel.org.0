Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62DE22CF061
	for <lists+stable@lfdr.de>; Fri,  4 Dec 2020 16:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729608AbgLDPIp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Dec 2020 10:08:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:33168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725923AbgLDPIp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Dec 2020 10:08:45 -0500
Subject: patch "usb: gadget: f_fs: Use local copy of descriptors for userspace copy" added to usb-linus
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607094485;
        bh=wb3raoFa0mkYqM915HmIG2GXcjs2fUTK7RQe8gL4sVU=;
        h=To:From:Date:From;
        b=w8OmrJ/zvYzwWz+PjlnKoN3u2E+EBi7qdQhOcEbfJhOq2mK5fLNsW3E66y7SzfMYs
         ol3GKEUbJ3M7y+Gba2fj5oIrgyetYpb8MjouHbeL+MtYFZdSQ2QNKwMmGxgA5CmbUR
         k+lxiz4f1foaEyxlTvQ2+9XgZZmKrcRP/PeFdtkI=
To:     vskrishn@codeaurora.org, gregkh@linuxfoundation.org,
        jackp@codeaurora.org, peter.chen@nxp.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 04 Dec 2020 16:09:21 +0100
Message-ID: <16070945614182@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: gadget: f_fs: Use local copy of descriptors for userspace copy

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From a4b98a7512f18534ce33a7e98e49115af59ffa00 Mon Sep 17 00:00:00 2001
From: Vamsi Krishna Samavedam <vskrishn@codeaurora.org>
Date: Mon, 30 Nov 2020 12:34:53 -0800
Subject: usb: gadget: f_fs: Use local copy of descriptors for userspace copy

The function may be unbound causing the ffs_ep and its descriptors
to be freed while userspace is in the middle of an ioctl requesting
the same descriptors. Avoid dangling pointer reference by first
making a local copy of desctiptors before releasing the spinlock.

Fixes: c559a3534109 ("usb: gadget: f_fs: add ioctl returning ep descriptor")
Reviewed-by: Peter Chen <peter.chen@nxp.com>
Signed-off-by: Vamsi Krishna Samavedam <vskrishn@codeaurora.org>
Signed-off-by: Jack Pham <jackp@codeaurora.org>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201130203453.28154-1-jackp@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_fs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 046f770a76da..c727cb5de871 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1324,7 +1324,7 @@ static long ffs_epfile_ioctl(struct file *file, unsigned code,
 	case FUNCTIONFS_ENDPOINT_DESC:
 	{
 		int desc_idx;
-		struct usb_endpoint_descriptor *desc;
+		struct usb_endpoint_descriptor desc1, *desc;
 
 		switch (epfile->ffs->gadget->speed) {
 		case USB_SPEED_SUPER:
@@ -1336,10 +1336,12 @@ static long ffs_epfile_ioctl(struct file *file, unsigned code,
 		default:
 			desc_idx = 0;
 		}
+
 		desc = epfile->ep->descs[desc_idx];
+		memcpy(&desc1, desc, desc->bLength);
 
 		spin_unlock_irq(&epfile->ffs->eps_lock);
-		ret = copy_to_user((void __user *)value, desc, desc->bLength);
+		ret = copy_to_user((void __user *)value, &desc1, desc1.bLength);
 		if (ret)
 			ret = -EFAULT;
 		return ret;
-- 
2.29.2


