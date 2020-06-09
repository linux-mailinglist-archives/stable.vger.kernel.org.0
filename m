Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4897B1F451E
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388428AbgFISLy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 14:11:54 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41232 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388130AbgFISF5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 14:05:57 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidF-0001oe-9B; Tue, 09 Jun 2020 19:05:53 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidE-006VvG-Jl; Tue, 09 Jun 2020 19:05:52 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Alan Stern" <stern@rowland.harvard.edu>,
        "David Mosberger" <davidm@egauge.net>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date:   Tue, 09 Jun 2020 19:04:08 +0100
Message-ID: <lsq.1591725832.694160445@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 17/61] drivers: usb: core: Minimize irq disabling in
 usb_sg_cancel()
In-Reply-To: <lsq.1591725831.850867383@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.85-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: David Mosberger <davidm@egauge.net>

commit 5f2e5fb873e269fcb806165715d237f0de4ecf1d upstream.

Restructure usb_sg_cancel() so we don't have to disable interrupts
while cancelling the URBs.

Suggested-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: David Mosberger <davidm@egauge.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/core/message.c | 37 +++++++++++++++++--------------------
 1 file changed, 17 insertions(+), 20 deletions(-)

--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -581,31 +581,28 @@ EXPORT_SYMBOL_GPL(usb_sg_wait);
 void usb_sg_cancel(struct usb_sg_request *io)
 {
 	unsigned long flags;
+	int i, retval;
 
 	spin_lock_irqsave(&io->lock, flags);
+	if (io->status) {
+		spin_unlock_irqrestore(&io->lock, flags);
+		return;
+	}
+	/* shut everything down */
+	io->status = -ECONNRESET;
+	spin_unlock_irqrestore(&io->lock, flags);
 
-	/* shut everything down, if it didn't already */
-	if (!io->status) {
-		int i;
-
-		io->status = -ECONNRESET;
-		spin_unlock(&io->lock);
-		for (i = 0; i < io->entries; i++) {
-			int retval;
-
-			usb_block_urb(io->urbs[i]);
+	for (i = io->entries - 1; i >= 0; --i) {
+		usb_block_urb(io->urbs[i]);
 
-			retval = usb_unlink_urb(io->urbs[i]);
-			if (retval != -EINPROGRESS
-					&& retval != -ENODEV
-					&& retval != -EBUSY
-					&& retval != -EIDRM)
-				dev_warn(&io->dev->dev, "%s, unlink --> %d\n",
-					__func__, retval);
-		}
-		spin_lock(&io->lock);
+		retval = usb_unlink_urb(io->urbs[i]);
+		if (retval != -EINPROGRESS
+		    && retval != -ENODEV
+		    && retval != -EBUSY
+		    && retval != -EIDRM)
+			dev_warn(&io->dev->dev, "%s, unlink --> %d\n",
+				 __func__, retval);
 	}
-	spin_unlock_irqrestore(&io->lock, flags);
 }
 EXPORT_SYMBOL_GPL(usb_sg_cancel);
 

