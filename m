Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8F933F9F9
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 21:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233269AbhCQUbg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 16:31:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:34450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233427AbhCQUbQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Mar 2021 16:31:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BEF1264D79;
        Wed, 17 Mar 2021 20:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616013076;
        bh=pg+FlV3i0wWhZ7cK2XtkKDsfEvN335Ojzlodb00VhPA=;
        h=Subject:To:From:Date:From;
        b=ZdNeH2fD3ScmHh4CYAi+jEjkYJvvmY/MF1e9w4u6MXLPtUFUyefN91duHyYYYMcqM
         mJxPfpL4MYjIx0DN/jNI5ckL31jYkZdfEZyqrzgwMyEWjA8pzgiy2DCQM8pKLRvsqd
         NSgU0umMGziSZqLL9TgGoBtC9C6bo3Rw9+LXBDP8=
Subject: patch "usb-storage: Add quirk to defeat Kindle's automatic unload" added to usb-linus
To:     stern@rowland.harvard.edu, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, zzam@gentoo.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 17 Mar 2021 21:31:02 +0100
Message-ID: <16160130623026@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb-storage: Add quirk to defeat Kindle's automatic unload

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 546aa0e4ea6ed81b6c51baeebc4364542fa3f3a7 Mon Sep 17 00:00:00 2001
From: Alan Stern <stern@rowland.harvard.edu>
Date: Wed, 17 Mar 2021 15:06:54 -0400
Subject: usb-storage: Add quirk to defeat Kindle's automatic unload

Matthias reports that the Amazon Kindle automatically removes its
emulated media if it doesn't receive another SCSI command within about
one second after a SYNCHRONIZE CACHE.  It does so even when the host
has sent a PREVENT MEDIUM REMOVAL command.  The reason for this
behavior isn't clear, although it's not hard to make some guesses.

At any rate, the results can be unexpected for anyone who tries to
access the Kindle in an unusual fashion, and in theory they can lead
to data loss (for example, if one file is closed and synchronized
while other files are still in the middle of being written).

To avoid such problems, this patch creates a new usb-storage quirks
flag telling the driver always to issue a REQUEST SENSE following a
SYNCHRONIZE CACHE command, and adds an unusual_devs entry for the
Kindle with the flag set.  This is sufficient to prevent the Kindle
from doing its automatic unload, without interfering with proper
operation.

Another possible way to deal with this would be to increase the
frequency of TEST UNIT READY polling that the kernel normally carries
out for removable-media storage devices.  However that would increase
the overall load on the system and it is not as reliable, because the
user can override the polling interval.  Changing the driver's
behavior is safer and has minimal overhead.

CC: <stable@vger.kernel.org>
Reported-and-tested-by: Matthias Schwarzott <zzam@gentoo.org>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20210317190654.GA497856@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/transport.c    |  7 +++++++
 drivers/usb/storage/unusual_devs.h | 12 ++++++++++++
 include/linux/usb_usual.h          |  2 ++
 3 files changed, 21 insertions(+)

diff --git a/drivers/usb/storage/transport.c b/drivers/usb/storage/transport.c
index 5eb895b19c55..f4304ce69350 100644
--- a/drivers/usb/storage/transport.c
+++ b/drivers/usb/storage/transport.c
@@ -656,6 +656,13 @@ void usb_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 		need_auto_sense = 1;
 	}
 
+	/* Some devices (Kindle) require another command after SYNC CACHE */
+	if ((us->fflags & US_FL_SENSE_AFTER_SYNC) &&
+			srb->cmnd[0] == SYNCHRONIZE_CACHE) {
+		usb_stor_dbg(us, "-- sense after SYNC CACHE\n");
+		need_auto_sense = 1;
+	}
+
 	/*
 	 * If we have a failure, we're going to do a REQUEST_SENSE 
 	 * automatically.  Note that we differentiate between a command
diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index 5732e9691f08..efa972be2ee3 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -2211,6 +2211,18 @@ UNUSUAL_DEV( 0x1908, 0x3335, 0x0200, 0x0200,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_NO_READ_DISC_INFO ),
 
+/*
+ * Reported by Matthias Schwarzott <zzam@gentoo.org>
+ * The Amazon Kindle treats SYNCHRONIZE CACHE as an indication that
+ * the host may be finished with it, and automatically ejects its
+ * emulated media unless it receives another command within one second.
+ */
+UNUSUAL_DEV( 0x1949, 0x0004, 0x0000, 0x9999,
+		"Amazon",
+		"Kindle",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_SENSE_AFTER_SYNC ),
+
 /*
  * Reported by Oliver Neukum <oneukum@suse.com>
  * This device morphes spontaneously into another device if the access
diff --git a/include/linux/usb_usual.h b/include/linux/usb_usual.h
index 6b03fdd69d27..712363c7a2e8 100644
--- a/include/linux/usb_usual.h
+++ b/include/linux/usb_usual.h
@@ -86,6 +86,8 @@
 		/* lies about caching, so always sync */	\
 	US_FLAG(NO_SAME, 0x40000000)				\
 		/* Cannot handle WRITE_SAME */			\
+	US_FLAG(SENSE_AFTER_SYNC, 0x80000000)			\
+		/* Do REQUEST_SENSE after SYNCHRONIZE_CACHE */	\
 
 #define US_FLAG(name, value)	US_FL_##name = value ,
 enum { US_DO_ALL_FLAGS };
-- 
2.30.2


