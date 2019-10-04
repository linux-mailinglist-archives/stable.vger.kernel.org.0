Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0DDCBA9F
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 14:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387575AbfJDMjQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 08:39:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:54890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387470AbfJDMjQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Oct 2019 08:39:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 750C020862;
        Fri,  4 Oct 2019 12:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570192756;
        bh=GMIAbZ7/BWNFbXBYasqLYhCk7iFs1uBG4YpNRvic4cw=;
        h=Subject:To:From:Date:From;
        b=tvme45RGs2OV6ezBw5LuSCUW7VLxbEMJnBmHWCVYzb+Bkn6dJjDorg723ptiSTU8G
         grXn9fCkLhr/7syzHhsOJigGLH0mK5lDy3JcnrAO++Hu4v6ebYG2spjuyYhumJyBtn
         6Pk+HFZvlmy3NER3Bx8HqAoaHBCzudBOYvJfCe60=
Subject: patch "media: stkwebcam: fix runtime PM after driver unbind" added to usb-linus
To:     johan@kernel.org, gregkh@linuxfoundation.org,
        mchehab+samsung@kernel.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 04 Oct 2019 14:39:03 +0200
Message-ID: <157019274356197@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    media: stkwebcam: fix runtime PM after driver unbind

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 30045f2174aab7fb4db7a9cf902d0aa6c75856a7 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Tue, 1 Oct 2019 10:49:08 +0200
Subject: media: stkwebcam: fix runtime PM after driver unbind

Since commit c2b71462d294 ("USB: core: Fix bug caused by duplicate
interface PM usage counter") USB drivers must always balance their
runtime PM gets and puts, including when the driver has already been
unbound from the interface.

Leaving the interface with a positive PM usage counter would prevent a
later bound driver from suspending the device.

Note that runtime PM has never actually been enabled for this driver
since the support_autosuspend flag in its usb_driver struct is not set.

Fixes: c2b71462d294 ("USB: core: Fix bug caused by duplicate interface PM usage counter")
Cc: stable <stable@vger.kernel.org>
Acked-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191001084908.2003-5-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/stkwebcam/stk-webcam.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/usb/stkwebcam/stk-webcam.c b/drivers/media/usb/stkwebcam/stk-webcam.c
index cfca3c70599b..21f90a887485 100644
--- a/drivers/media/usb/stkwebcam/stk-webcam.c
+++ b/drivers/media/usb/stkwebcam/stk-webcam.c
@@ -643,8 +643,7 @@ static int v4l_stk_release(struct file *fp)
 		dev->owner = NULL;
 	}
 
-	if (is_present(dev))
-		usb_autopm_put_interface(dev->interface);
+	usb_autopm_put_interface(dev->interface);
 	mutex_unlock(&dev->lock);
 	return v4l2_fh_release(fp);
 }
-- 
2.23.0


