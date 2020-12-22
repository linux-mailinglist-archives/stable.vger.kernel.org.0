Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC2BD2DEF4F
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 14:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726732AbgLSNCW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 08:02:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:45442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727978AbgLSM7F (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Dec 2020 07:59:05 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "David C. Partridge" <david.partridge@perdrix.co.uk>,
        Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 5.9 42/49] USB: UAS: introduce a quirk to set no_write_same
Date:   Sat, 19 Dec 2020 13:58:46 +0100
Message-Id: <20201219125346.724240327@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201219125344.671832095@linuxfoundation.org>
References: <20201219125344.671832095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

commit 8010622c86ca5bb44bc98492f5968726fc7c7a21 upstream.

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
 Documentation/admin-guide/kernel-parameters.txt |    1 +
 drivers/usb/storage/uas.c                       |    3 +++
 drivers/usb/storage/unusual_uas.h               |    7 +++++--
 drivers/usb/storage/usb.c                       |    3 +++
 include/linux/usb_usual.h                       |    2 ++
 5 files changed, 14 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -5521,6 +5521,7 @@
 					device);
 				j = NO_REPORT_LUNS (don't use report luns
 					command, uas only);
+				k = NO_SAME (do not use WRITE_SAME, uas only)
 				l = NOT_LOCKABLE (don't try to lock and
 					unlock ejectable media, not on uas);
 				m = MAX_SECTORS_64 (don't transfer more
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -867,6 +867,9 @@ static int uas_slave_configure(struct sc
 	if (devinfo->flags & US_FL_NO_READ_CAPACITY_16)
 		sdev->no_read_capacity_16 = 1;
 
+	/* Some disks cannot handle WRITE_SAME */
+	if (devinfo->flags & US_FL_NO_SAME)
+		sdev->no_write_same = 1;
 	/*
 	 * Some disks return the total number of blocks in response
 	 * to READ CAPACITY rather than the highest block number.
--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -35,12 +35,15 @@ UNUSUAL_DEV(0x054c, 0x087d, 0x0000, 0x99
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
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -541,6 +541,9 @@ void usb_stor_adjust_quirks(struct usb_d
 		case 'j':
 			f |= US_FL_NO_REPORT_LUNS;
 			break;
+		case 'k':
+			f |= US_FL_NO_SAME;
+			break;
 		case 'l':
 			f |= US_FL_NOT_LOCKABLE;
 			break;
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


