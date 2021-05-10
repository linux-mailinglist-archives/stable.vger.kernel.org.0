Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3531378E7D
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 15:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242737AbhEJN3X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 09:29:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:58066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351274AbhEJNFw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 09:05:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66313611BD;
        Mon, 10 May 2021 13:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620651887;
        bh=it2lUmrJ5gE7E+NsrXgzBC87kNm8qGvZMOSNG19Cf6Y=;
        h=Subject:To:From:Date:From;
        b=d91RLD7z+IXxiz32lJ3SEj6ApQJmJIBsQYysamEVsaBDw6nKUnCszzuxvticwzxsy
         ItkbqOeKljZIOdRvTF3QNjRJQnxDodyM57MvyGNB7aHuNvbW+KiGhssog+X1PJBYW+
         DSg98V2UYVN6fJ28l9yJvwTwfhrGln5fs8+Vk2qc=
Subject: patch "usb: dwc3: omap: improve extcon initialization" added to usb-linus
To:     marcel@solidxs.se, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 May 2021 15:04:45 +0200
Message-ID: <1620651885163209@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc3: omap: improve extcon initialization

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From e17b02d4970913233d543c79c9c66e72cac05bdd Mon Sep 17 00:00:00 2001
From: Marcel Hamer <marcel@solidxs.se>
Date: Tue, 27 Apr 2021 14:21:18 +0200
Subject: usb: dwc3: omap: improve extcon initialization

When extcon is used in combination with dwc3, it is assumed that the dwc3
registers are untouched and as such are only configured if VBUS is valid
or ID is tied to ground.

In case VBUS is not valid or ID is floating, the registers are not
configured as such during driver initialization, causing a wrong
default state during boot.

If the registers are not in a default state, because they are for
instance touched by a boot loader, this can cause for a kernel error.

Signed-off-by: Marcel Hamer <marcel@solidxs.se>
Link: https://lore.kernel.org/r/20210427122118.1948340-1-marcel@solidxs.se
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-omap.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
index 3db17806e92e..e196673f5c64 100644
--- a/drivers/usb/dwc3/dwc3-omap.c
+++ b/drivers/usb/dwc3/dwc3-omap.c
@@ -437,8 +437,13 @@ static int dwc3_omap_extcon_register(struct dwc3_omap *omap)
 
 		if (extcon_get_state(edev, EXTCON_USB) == true)
 			dwc3_omap_set_mailbox(omap, OMAP_DWC3_VBUS_VALID);
+		else
+			dwc3_omap_set_mailbox(omap, OMAP_DWC3_VBUS_OFF);
+
 		if (extcon_get_state(edev, EXTCON_USB_HOST) == true)
 			dwc3_omap_set_mailbox(omap, OMAP_DWC3_ID_GROUND);
+		else
+			dwc3_omap_set_mailbox(omap, OMAP_DWC3_ID_FLOAT);
 
 		omap->edev = edev;
 	}
-- 
2.31.1


