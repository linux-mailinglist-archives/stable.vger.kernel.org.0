Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3C834429C
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231833AbhCVMoJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:44:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:35528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231797AbhCVMlS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:41:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11B11619AA;
        Mon, 22 Mar 2021 12:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416771;
        bh=gKFKmJmz7gWC8mnLNoc9cdcCFERF3Ke9B1hJzweRw6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dTq7z7kb6QVm5aC4LQfz/i7yZA0x89vYMGPRj4afOmZRuhg6kcqTf1ERrTmeGQivd
         qxMv4dKCtYKCryTI98DjY49H3rOX0zWXEVGF5LOR8ht2RRgy6thZHRaqarjt/VJ9Ye
         q5lsRlfatDj5zEpC/p712BGwcd4pZ9U8IQmH/aCo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH 5.10 116/157] usb-storage: Add quirk to defeat Kindles automatic unload
Date:   Mon, 22 Mar 2021 13:27:53 +0100
Message-Id: <20210322121937.449778980@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

commit 546aa0e4ea6ed81b6c51baeebc4364542fa3f3a7 upstream.

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
 drivers/usb/storage/transport.c    |    7 +++++++
 drivers/usb/storage/unusual_devs.h |   12 ++++++++++++
 include/linux/usb_usual.h          |    2 ++
 3 files changed, 21 insertions(+)

--- a/drivers/usb/storage/transport.c
+++ b/drivers/usb/storage/transport.c
@@ -651,6 +651,13 @@ void usb_stor_invoke_transport(struct sc
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
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -2212,6 +2212,18 @@ UNUSUAL_DEV( 0x1908, 0x3335, 0x0200, 0x0
 		US_FL_NO_READ_DISC_INFO ),
 
 /*
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
+/*
  * Reported by Oliver Neukum <oneukum@suse.com>
  * This device morphes spontaneously into another device if the access
  * pattern of Windows isn't followed. Thus writable media would be dirty
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


