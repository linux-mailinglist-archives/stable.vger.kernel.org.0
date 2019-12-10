Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35AD91188AB
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 13:43:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727300AbfLJMno (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 07:43:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:53576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727242AbfLJMno (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 07:43:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A68F6207FF;
        Tue, 10 Dec 2019 12:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575981824;
        bh=1VSfOqovaCpWhw8aXhUEI9cyREB1iUPXdTdJeAHabYM=;
        h=Subject:To:From:Date:From;
        b=m5j8N0cT2GQ4K2ELzFRod1RkQHMggRj2SsvhYue3iVDMDSLCEytPDPeR4XP2NyFyX
         rxhdwDA9lJL0WH93VAtg1NYQJaUQJrK3mtCYgBZMkMWfLUaOI5j/y9vrsZsc5hBIJm
         HO7DaxWPBbnJUQc1cSGtzP00Vs6UhAbz1RDALtBA=
Subject: patch "staging: rtl8712: fix interface sanity check" added to staging-linus
To:     johan@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 10 Dec 2019 13:43:33 +0100
Message-ID: <1575981813132139@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: rtl8712: fix interface sanity check

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From c724f776f048538ecfdf53a52b7a522309f5c504 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Tue, 10 Dec 2019 12:47:51 +0100
Subject: staging: rtl8712: fix interface sanity check

Make sure to use the current alternate setting when verifying the
interface descriptors to avoid binding to an invalid interface.

Failing to do so could cause the driver to misbehave or trigger a WARN()
in usb_submit_urb() that kernels with panic_on_warn set would choke on.

Fixes: 2865d42c78a9 ("staging: r8712u: Add the new driver to the mainline kernel")
Cc: stable <stable@vger.kernel.org>     # 2.6.37
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191210114751.5119-3-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8712/usb_intf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8712/usb_intf.c b/drivers/staging/rtl8712/usb_intf.c
index ba1288297ee4..a87562f632a7 100644
--- a/drivers/staging/rtl8712/usb_intf.c
+++ b/drivers/staging/rtl8712/usb_intf.c
@@ -247,7 +247,7 @@ static uint r8712_usb_dvobj_init(struct _adapter *padapter)
 
 	pdvobjpriv->padapter = padapter;
 	padapter->eeprom_address_size = 6;
-	phost_iface = &pintf->altsetting[0];
+	phost_iface = pintf->cur_altsetting;
 	piface_desc = &phost_iface->desc;
 	pdvobjpriv->nr_endpoint = piface_desc->bNumEndpoints;
 	if (pusbd->speed == USB_SPEED_HIGH) {
-- 
2.24.0


