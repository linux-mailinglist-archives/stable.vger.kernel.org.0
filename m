Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C563C419A27
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236046AbhI0RHH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:07:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:46024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236051AbhI0RGf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:06:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 707A0611CE;
        Mon, 27 Sep 2021 17:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762295;
        bh=FuBLvPZOaNDqtLiQ6Jkd1Gd1oxqwHc0IZGNzQGqzgOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xGhwoXyDJIsdl/iDPO/vBAMl/m9aJAlMYYvW60kDUNkD86ySO+wW4szMgJWR6s7ab
         UpvIdoQLSXzKIS1DilyZqsqI5lqUuwquVmD+d1RAJExroozOxjAz74m6POv5fk/pWS
         huFrzcKYTOjnMElWcrPemkh4pabS0iXpNpDcakSo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Ondrej Zary <linux@zary.sk>
Subject: [PATCH 5.4 08/68] usb-storage: Add quirk for ScanLogic SL11R-IDE older than 2.6c
Date:   Mon, 27 Sep 2021 19:02:04 +0200
Message-Id: <20210927170220.201199071@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170219.901812470@linuxfoundation.org>
References: <20210927170219.901812470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ondrej Zary <linux@zary.sk>

commit b55d37ef6b7db3eda9b4495a8d9b0a944ee8c67d upstream.

ScanLogic SL11R-IDE with firmware older than 2.6c (the latest one) has
broken tag handling, preventing the device from working at all:
usb 1-1: new full-speed USB device number 2 using uhci_hcd
usb 1-1: New USB device found, idVendor=04ce, idProduct=0002, bcdDevice= 2.60
usb 1-1: New USB device strings: Mfr=1, Product=1, SerialNumber=0
usb 1-1: Product: USB Device
usb 1-1: Manufacturer: USB Device
usb-storage 1-1:1.0: USB Mass Storage device detected
scsi host2: usb-storage 1-1:1.0
usbcore: registered new interface driver usb-storage
usb 1-1: reset full-speed USB device number 2 using uhci_hcd
usb 1-1: reset full-speed USB device number 2 using uhci_hcd
usb 1-1: reset full-speed USB device number 2 using uhci_hcd
usb 1-1: reset full-speed USB device number 2 using uhci_hcd

Add US_FL_BULK_IGNORE_TAG to fix it. Also update my e-mail address.

2.6c is the only firmware that claims Linux compatibility.
The firmware can be upgraded using ezotgdbg utility:
https://github.com/asciilifeform/ezotgdbg

Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Ondrej Zary <linux@zary.sk>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210913210106.12717-1-linux@zary.sk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/unusual_devs.h |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -416,9 +416,16 @@ UNUSUAL_DEV(  0x04cb, 0x0100, 0x0000, 0x
 		USB_SC_UFI, USB_PR_DEVICE, NULL, US_FL_FIX_INQUIRY | US_FL_SINGLE_LUN),
 
 /*
- * Reported by Ondrej Zary <linux@rainbow-software.org>
+ * Reported by Ondrej Zary <linux@zary.sk>
  * The device reports one sector more and breaks when that sector is accessed
+ * Firmwares older than 2.6c (the latest one and the only that claims Linux
+ * support) have also broken tag handling
  */
+UNUSUAL_DEV(  0x04ce, 0x0002, 0x0000, 0x026b,
+		"ScanLogic",
+		"SL11R-IDE",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_FIX_CAPACITY | US_FL_BULK_IGNORE_TAG),
 UNUSUAL_DEV(  0x04ce, 0x0002, 0x026c, 0x026c,
 		"ScanLogic",
 		"SL11R-IDE",


