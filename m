Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 418673D0991
	for <lists+stable@lfdr.de>; Wed, 21 Jul 2021 09:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234875AbhGUGgE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Jul 2021 02:36:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:56958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235119AbhGUGfd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Jul 2021 02:35:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4572E61175;
        Wed, 21 Jul 2021 07:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626851767;
        bh=1nrDlPRhL3DGLp39ZZob+TX98E0e1xL1fQzBIfrxd9U=;
        h=Subject:To:From:Date:From;
        b=X8+HugTLmvejUJ08K1cAWRXV/Iv6MoTn4FVc2PHqRkMwjn59BY8VpepCCUmYpknZg
         dpQLv+ShHr8AHtH7kj+q8ocmD0ayoEKM4w2hOHnQ2xV9I5XJ0fQovHidUHSdp1v700
         qfBlosuPbZc3eDyT2zn47ZTkLHDw1H+Cxg8tr4G8=
Subject: patch "USB: usb-storage: Add LaCie Rugged USB3-FW to IGNORE_UAS" added to usb-linus
To:     belegdol@gmail.com, belegdol+github@gmail.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 21 Jul 2021 09:16:05 +0200
Message-ID: <162685176526155@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: usb-storage: Add LaCie Rugged USB3-FW to IGNORE_UAS

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 6abf2fe6b4bf6e5256b80c5817908151d2d33e9f Mon Sep 17 00:00:00 2001
From: Julian Sikorski <belegdol@gmail.com>
Date: Tue, 20 Jul 2021 19:19:10 +0200
Subject: USB: usb-storage: Add LaCie Rugged USB3-FW to IGNORE_UAS

LaCie Rugged USB3-FW appears to be incompatible with UAS. It generates
errors like:
[ 1151.582598] sd 14:0:0:0: tag#16 uas_eh_abort_handler 0 uas-tag 1 inflight: IN
[ 1151.582602] sd 14:0:0:0: tag#16 CDB: Report supported operation codes a3 0c 01 12 00 00 00 00 02 00 00 00
[ 1151.588594] scsi host14: uas_eh_device_reset_handler start
[ 1151.710482] usb 2-4: reset SuperSpeed Gen 1 USB device number 2 using xhci_hcd
[ 1151.741398] scsi host14: uas_eh_device_reset_handler success
[ 1181.785534] scsi host14: uas_eh_device_reset_handler start

Signed-off-by: Julian Sikorski <belegdol+github@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210720171910.36497-1-belegdol+github@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/unusual_uas.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/unusual_uas.h
index f9677a5ec31b..c35a6db993f1 100644
--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -45,6 +45,13 @@ UNUSUAL_DEV(0x059f, 0x105f, 0x0000, 0x9999,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_NO_REPORT_OPCODES | US_FL_NO_SAME),
 
+/* Reported-by: Julian Sikorski <belegdol@gmail.com> */
+UNUSUAL_DEV(0x059f, 0x1061, 0x0000, 0x9999,
+		"LaCie",
+		"Rugged USB3-FW",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_IGNORE_UAS),
+
 /*
  * Apricorn USB3 dongle sometimes returns "USBSUSBSUSBS" in response to SCSI
  * commands in UAS mode.  Observed with the 1.28 firmware; are there others?
-- 
2.32.0


