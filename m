Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 278BED2768
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 12:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbfJJKoE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 06:44:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:45590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbfJJKoE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 06:44:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 333C120B7C;
        Thu, 10 Oct 2019 10:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570704243;
        bh=uYhuiDJl9cZwoY+g26jUfYI25k7MZ0Hl8lFruiwhIeI=;
        h=Subject:To:From:Date:From;
        b=Xrf4l4jj6kjmuaqmPHMPchuOc+tJ0VfBpNTNk3IJof9WZi2EZrcrO7MLeE3VGabz8
         Uxx/w+u3V/iautEdPICJKyATGDadbtWjGwh5z05EMPX6clrUFpLpmor9HTk4oxiLkD
         N+g9TF+SJdOeJD0dKtnJnqsaw0Ina6inRK/Xvsg4=
Subject: patch "USB: adutux: fix use-after-free on release" added to usb-linus
To:     johan@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 10 Oct 2019 12:43:53 +0200
Message-ID: <157070423317341@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: adutux: fix use-after-free on release

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 123a0f125fa3d2104043697baa62899d9e549272 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Wed, 9 Oct 2019 17:38:44 +0200
Subject: USB: adutux: fix use-after-free on release

The driver was accessing its struct usb_device in its release()
callback without holding a reference. This would lead to a
use-after-free whenever the device was disconnected while the character
device was still open.

Fixes: 66d4bc30d128 ("USB: adutux: remove custom debug macro")
Cc: stable <stable@vger.kernel.org>     # 3.12
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191009153848.8664-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/adutux.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/misc/adutux.c b/drivers/usb/misc/adutux.c
index f9efec719359..6f5edb9fc61e 100644
--- a/drivers/usb/misc/adutux.c
+++ b/drivers/usb/misc/adutux.c
@@ -149,6 +149,7 @@ static void adu_delete(struct adu_device *dev)
 	kfree(dev->read_buffer_secondary);
 	kfree(dev->interrupt_in_buffer);
 	kfree(dev->interrupt_out_buffer);
+	usb_put_dev(dev->udev);
 	kfree(dev);
 }
 
@@ -664,7 +665,7 @@ static int adu_probe(struct usb_interface *interface,
 
 	mutex_init(&dev->mtx);
 	spin_lock_init(&dev->buflock);
-	dev->udev = udev;
+	dev->udev = usb_get_dev(udev);
 	init_waitqueue_head(&dev->read_wait);
 	init_waitqueue_head(&dev->write_wait);
 
-- 
2.23.0


