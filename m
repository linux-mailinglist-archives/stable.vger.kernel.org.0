Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACDCA1187E5
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 13:17:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbfLJMRA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 07:17:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:36154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727310AbfLJMRA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 07:17:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E47882073D;
        Tue, 10 Dec 2019 12:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575980219;
        bh=6kBE/46g4NFqHbUY3rmT0YB2F7IeWJQ/P23fDJG8P9o=;
        h=Subject:To:From:Date:From;
        b=wECgCkjY6sr2aEbdDtwhjitAQAkv6NDgoKn1afh/1pyo1jAThdWQzwC2PXClOL6Gw
         CNFFB8bxAxFzFB9x3R4KkR+hGp3iZnZcJP+L24cmGaz8dP1/QD75+0mf547HdwC9F0
         yM1ugcT1skTsg430BIdyDhgbeZizq441Xsp4oYKI=
Subject: patch "USB: idmouse: fix interface sanity checks" added to usb-linus
To:     johan@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 10 Dec 2019 13:16:44 +0100
Message-ID: <1575980204238202@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: idmouse: fix interface sanity checks

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 59920635b89d74b9207ea803d5e91498d39e8b69 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Tue, 10 Dec 2019 12:26:00 +0100
Subject: USB: idmouse: fix interface sanity checks

Make sure to use the current alternate setting when verifying the
interface descriptors to avoid binding to an invalid interface.

Failing to do so could cause the driver to misbehave or trigger a WARN()
in usb_submit_urb() that kernels with panic_on_warn set would choke on.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191210112601.3561-4-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/idmouse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/misc/idmouse.c b/drivers/usb/misc/idmouse.c
index 4afb5ddfd361..e9437a176518 100644
--- a/drivers/usb/misc/idmouse.c
+++ b/drivers/usb/misc/idmouse.c
@@ -322,7 +322,7 @@ static int idmouse_probe(struct usb_interface *interface,
 	int result;
 
 	/* check if we have gotten the data or the hid interface */
-	iface_desc = &interface->altsetting[0];
+	iface_desc = interface->cur_altsetting;
 	if (iface_desc->desc.bInterfaceClass != 0x0A)
 		return -ENODEV;
 
-- 
2.24.0


