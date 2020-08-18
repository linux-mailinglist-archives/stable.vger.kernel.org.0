Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80FFC248396
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 13:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbgHRLJV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 07:09:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:34324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726391AbgHRLJU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Aug 2020 07:09:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 745C0206B5;
        Tue, 18 Aug 2020 11:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597748960;
        bh=Xj5Qggyzii75e7zwj52aqS+iGNhTRRzU9kWfF73yfAM=;
        h=Subject:To:From:Date:From;
        b=Z2JkWdwMVTLl6pdu3PlvZQbt72Fho7DF0xbySYsgq2RPQR/MX/bKw4E3I1f5GLTRF
         fWe4aGeS/kbvVFHOC2LtEPaOr5PESYLBHgxlH6NAbdubB7JhWLoQVpjZ7f/onh5C1Y
         c9VrQdZ2Fe1GWxtHgI0y/CWU4w+ilNNHxhN68jmg=
Subject: patch "USB: Also match device drivers using the ->match vfunc" added to usb-linus
To:     hadess@hadess.net, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, stern@rowland.harvard.edu
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 18 Aug 2020 13:09:43 +0200
Message-ID: <1597748983224223@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: Also match device drivers using the ->match vfunc

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From adb6e6ac20eedcf1dce19dc75b224e63c0828ea1 Mon Sep 17 00:00:00 2001
From: Bastien Nocera <hadess@hadess.net>
Date: Tue, 18 Aug 2020 13:04:43 +0200
Subject: USB: Also match device drivers using the ->match vfunc

We only ever used the ID table matching before, but we should also support
open-coded match functions.

Fixes: 88b7381a939de ("USB: Select better matching USB drivers when available")
Signed-off-by: Bastien Nocera <hadess@hadess.net>
Cc: stable <stable@vger.kernel.org>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20200818110445.509668-1-hadess@hadess.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/generic.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/core/generic.c b/drivers/usb/core/generic.c
index b6f2d4b44754..2b2f1ab6e36a 100644
--- a/drivers/usb/core/generic.c
+++ b/drivers/usb/core/generic.c
@@ -205,8 +205,9 @@ static int __check_usb_generic(struct device_driver *drv, void *data)
 	udrv = to_usb_device_driver(drv);
 	if (udrv == &usb_generic_driver)
 		return 0;
-
-	return usb_device_match_id(udev, udrv->id_table) != NULL;
+	if (usb_device_match_id(udev, udrv->id_table) != NULL)
+		return 1;
+	return (udrv->match && udrv->match(udev));
 }
 
 static bool usb_generic_driver_match(struct usb_device *udev)
-- 
2.28.0


