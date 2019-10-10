Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2607D2767
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 12:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbfJJKn4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 06:43:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:45550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726201AbfJJKnz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 06:43:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A786920B7C;
        Thu, 10 Oct 2019 10:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570704235;
        bh=K4t7elmGxrWYR8lTznXJr0dKYUbFCmXGkmBDy6A9zU4=;
        h=Subject:To:From:Date:From;
        b=CcuSbh+QNsWG5Pr4mQlGtpPSRohZiaD+Rs8bTLUT070F1CYvf39wJr6gB5mIbePDx
         EhHcMlvftsNWFzqM2cvy6BSEaUoGyNKqiSS1559A1ccgIWHmbIXRc3CJbelDn8B+AG
         V2XquGtYO+e505C38oiENmmwKEBJWoH3WT7ENJvE=
Subject: patch "USB: legousbtower: fix use-after-free on release" added to usb-linus
To:     johan@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 10 Oct 2019 12:43:52 +0200
Message-ID: <15707042327410@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: legousbtower: fix use-after-free on release

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 726b55d0e22ca72c69c947af87785c830289ddbc Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Wed, 9 Oct 2019 17:38:47 +0200
Subject: USB: legousbtower: fix use-after-free on release

The driver was accessing its struct usb_device in its release()
callback without holding a reference. This would lead to a
use-after-free whenever the device was disconnected while the character
device was still open.

Fixes: fef526cae700 ("USB: legousbtower: remove custom debug macro")
Cc: stable <stable@vger.kernel.org>     # 3.12
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191009153848.8664-5-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/legousbtower.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/misc/legousbtower.c b/drivers/usb/misc/legousbtower.c
index 44d6a3381804..9d4c52a7ebe0 100644
--- a/drivers/usb/misc/legousbtower.c
+++ b/drivers/usb/misc/legousbtower.c
@@ -296,6 +296,7 @@ static inline void tower_delete (struct lego_usb_tower *dev)
 	kfree (dev->read_buffer);
 	kfree (dev->interrupt_in_buffer);
 	kfree (dev->interrupt_out_buffer);
+	usb_put_dev(dev->udev);
 	kfree (dev);
 }
 
@@ -810,7 +811,7 @@ static int tower_probe (struct usb_interface *interface, const struct usb_device
 
 	mutex_init(&dev->lock);
 
-	dev->udev = udev;
+	dev->udev = usb_get_dev(udev);
 	dev->open_count = 0;
 	dev->disconnected = 0;
 
-- 
2.23.0


