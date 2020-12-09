Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 421632D49AC
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 20:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387426AbgLITAI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 14:00:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:50416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729345AbgLITAG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Dec 2020 14:00:06 -0500
Subject: patch "USB: UAS: introduce a quirk to set no_write_same" added to usb-testing
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607540365;
        bh=nfHCLiiRe1f0qNBa13nF77KMPFJwUHSE50mQ0xWIkRA=;
        h=To:From:Date:From;
        b=jIpzP3pAZY54NPcDSucsOiZxb5LdWC7UgXMgTrM2lDiPQJu479GWJMSUEMpVqicnl
         CK/mn9TbokXXANsGIKeKodk9fetckEJ0S+83l5idbQ0tKipEHi6nXWJNrhb6pwRZlx
         RmOEH1Ncb9KsSRXRuszbUlvEYDmWcbqRDaiI+IT4=
To:     oneukum@suse.com, david.partridge@perdrix.co.uk,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 09 Dec 2020 20:00:42 +0100
Message-ID: <1607540442190155@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: UAS: introduce a quirk to set no_write_same

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 8010622c86ca5bb44bc98492f5968726fc7c7a21 Mon Sep 17 00:00:00 2001
From: Oliver Neukum <oneukum@suse.com>
Date: Wed, 9 Dec 2020 16:26:39 +0100
Subject: USB: UAS: introduce a quirk to set no_write_same

UAS does not share the pessimistic assumption storage is making that
devices cannot deal with WRITE_SAME.  A few devices supported by UAS,
are reported to not deal well with WRITE_SAME. Those need a quirk.

Add it to the device that needs it.

Reported-by: David C. Partridge <david.partridge@perdrix.co.uk>
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201209152639.9195-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/kernel-parameters.txt | 1 +
 drivers/usb/storage/uas.c                       | 3 +++
 drivers/usb/storage/unusual_uas.h               | 7 +++++--
 drivers/usb/storage/usb.c                       | 3 +++
 include/linux/usb_usual.h                       | 2 ++
 5 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 44fde25bb221..f6a1513dfb76 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -5663,6 +5663,7 @@
 					device);
 				j = NO_REPORT_LUNS (don't use report luns
 					command, uas only);
+				k = NO_SAME (do not use WRITE_SAME, uas only)
 				l = NOT_LOCKABLE (don't try to lock and
 					unlock ejectable media, not on uas);
 				m = MAX_SECTORS_64 (don't transfer more
diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 56422c4b4ff3..bef89c6bd1d7 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -868,6 +868,9 @@ static int uas_slave_configure(struct scsi_device *sdev)
 	if (devinfo->flags & US_FL_NO_READ_CAPACITY_16)
 		sdev->no_read_capacity_16 = 1;
 
+	/* Some disks cannot handle WRITE_SAME */
+	if (devinfo->flags & US_FL_NO_SAME)
+		sdev->no_write_same = 1;
 	/*
 	 * Some disks return the total number of blocks in response
 	 * to READ CAPACITY rather than the highest block number.
diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/unusual_uas.h
index 711ab240058c..870e9cf3d5dc 100644
--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -35,12 +35,15 @@ UNUSUAL_DEV(0x054c, 0x087d, 0x0000, 0x9999,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_NO_REPORT_OPCODES),
 
-/* Reported-by: Julian Groß <julian.g@posteo.de> */
+/*
+ *  Initially Reported-by: Julian Groß <julian.g@posteo.de>
+ *  Further reports David C. Partridge <david.partridge@perdrix.co.uk>
+ */
 UNUSUAL_DEV(0x059f, 0x105f, 0x0000, 0x9999,
 		"LaCie",
 		"2Big Quadra USB3",
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
-		US_FL_NO_REPORT_OPCODES),
+		US_FL_NO_REPORT_OPCODES | US_FL_NO_SAME),
 
 /*
  * Apricorn USB3 dongle sometimes returns "USBSUSBSUSBS" in response to SCSI
diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index 94a64729dc27..90aa9c12ffac 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -541,6 +541,9 @@ void usb_stor_adjust_quirks(struct usb_device *udev, unsigned long *fflags)
 		case 'j':
 			f |= US_FL_NO_REPORT_LUNS;
 			break;
+		case 'k':
+			f |= US_FL_NO_SAME;
+			break;
 		case 'l':
 			f |= US_FL_NOT_LOCKABLE;
 			break;
diff --git a/include/linux/usb_usual.h b/include/linux/usb_usual.h
index 4a19ac3f24d0..6b03fdd69d27 100644
--- a/include/linux/usb_usual.h
+++ b/include/linux/usb_usual.h
@@ -84,6 +84,8 @@
 		/* Cannot handle REPORT_LUNS */			\
 	US_FLAG(ALWAYS_SYNC, 0x20000000)			\
 		/* lies about caching, so always sync */	\
+	US_FLAG(NO_SAME, 0x40000000)				\
+		/* Cannot handle WRITE_SAME */			\
 
 #define US_FLAG(name, value)	US_FL_##name = value ,
 enum { US_DO_ALL_FLAGS };
-- 
2.29.2


