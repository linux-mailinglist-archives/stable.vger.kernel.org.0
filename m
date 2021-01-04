Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88EFB2E9934
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 16:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbhADPwi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 10:52:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:34306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726616AbhADPwi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 10:52:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF4A82242A;
        Mon,  4 Jan 2021 15:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609775517;
        bh=h+3eE+mfkNx7Le0Yi3rklopasESOZEXGaMVpGYYTFKE=;
        h=Subject:To:From:Date:From;
        b=zHS8qCDxAzesSAx6A17cE0e4QJc0s8GNGtAFIrpDHv9iWvD0lRZqa0dHiXQaI/HMm
         4tfl3GMGUX43fGbaKGpBkkGDqwFaMM8vt9O/oTsuyo3GqXTul17jFNsCRroHBtvBTJ
         fXKNy2wSmrrLm9bfpxmZvt2cY+F5vuoPlQJ4Rbcc=
Subject: patch "usb: usbip: vhci_hcd: protect shift size" added to usb-linus
To:     rdunlap@infradead.org, gregkh@linuxfoundation.org,
        shuahkh@osg.samsung.com, stable@vger.kernel.org,
        yuyang.du@intel.com
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 Jan 2021 16:53:15 +0100
Message-ID: <1609775595900@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: usbip: vhci_hcd: protect shift size

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 718bf42b119de652ebcc93655a1f33a9c0d04b3c Mon Sep 17 00:00:00 2001
From: Randy Dunlap <rdunlap@infradead.org>
Date: Mon, 28 Dec 2020 23:13:09 -0800
Subject: usb: usbip: vhci_hcd: protect shift size

Fix shift out-of-bounds in vhci_hcd.c:

  UBSAN: shift-out-of-bounds in ../drivers/usb/usbip/vhci_hcd.c:399:41
  shift exponent 768 is too large for 32-bit type 'int'

Fixes: 03cd00d538a6 ("usbip: vhci-hcd: Set the vhci structure up to work")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: syzbot+297d20e437b79283bf6d@syzkaller.appspotmail.com
Cc: Yuyang Du <yuyang.du@intel.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201229071309.18418-1-rdunlap@infradead.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/usbip/vhci_hcd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/usbip/vhci_hcd.c b/drivers/usb/usbip/vhci_hcd.c
index 66cde5e5f796..3209b5ddd30c 100644
--- a/drivers/usb/usbip/vhci_hcd.c
+++ b/drivers/usb/usbip/vhci_hcd.c
@@ -396,6 +396,8 @@ static int vhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 		default:
 			usbip_dbg_vhci_rh(" ClearPortFeature: default %x\n",
 					  wValue);
+			if (wValue >= 32)
+				goto error;
 			vhci_hcd->port_status[rhport] &= ~(1 << wValue);
 			break;
 		}
-- 
2.30.0


