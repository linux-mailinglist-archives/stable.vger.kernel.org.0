Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B78101F4490
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388146AbgFISF4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 14:05:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41202 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731897AbgFISFz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 14:05:55 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidF-0001oT-1I; Tue, 09 Jun 2020 19:05:53 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidE-006VvD-Iq; Tue, 09 Jun 2020 19:05:52 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "David Mosberger" <davidm@egauge.net>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date:   Tue, 09 Jun 2020 19:04:07 +0100
Message-ID: <lsq.1591725832.662003982@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 16/61] drivers: usb: core: Don't disable irqs in
 usb_sg_wait() during URB submit.
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

commit 98b74b0ee57af1bcb6e8b2e76e707a71c5ef8ec9 upstream.

usb_submit_urb() may take quite long to execute.  For example, a
single sg list may have 30 or more entries, possibly leading to that
many calls to DMA-map pages.  This can cause interrupt latency of
several hundred micro-seconds.

Avoid the problem by releasing the io->lock spinlock and re-enabling
interrupts before calling usb_submit_urb().  This opens races with
usb_sg_cancel() and sg_complete().  Handle those races by using
usb_block_urb() to stop URBs from being submitted after
usb_sg_cancel() or sg_complete() with error.

Note that usb_unlink_urb() is guaranteed to return -ENODEV if
!io->urbs[i]->dev and since the -ENODEV case is already handled,
we don't have to check for !io->urbs[i]->dev explicitly.

Before this change, reading 512MB from an ext3 filesystem on a USB
memory stick showed a throughput of 12 MB/s with about 500 missed
deadlines.

With this change, reading the same file gave the same throughput but
only one or two missed deadlines.

Signed-off-by: David Mosberger <davidm@egauge.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/core/message.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -306,9 +306,10 @@ static void sg_complete(struct urb *urb)
 		 */
 		spin_unlock(&io->lock);
 		for (i = 0, found = 0; i < io->entries; i++) {
-			if (!io->urbs[i] || !io->urbs[i]->dev)
+			if (!io->urbs[i])
 				continue;
 			if (found) {
+				usb_block_urb(io->urbs[i]);
 				retval = usb_unlink_urb(io->urbs[i]);
 				if (retval != -EINPROGRESS &&
 				    retval != -ENODEV &&
@@ -519,12 +520,10 @@ void usb_sg_wait(struct usb_sg_request *
 		int retval;
 
 		io->urbs[i]->dev = io->dev;
-		retval = usb_submit_urb(io->urbs[i], GFP_ATOMIC);
-
-		/* after we submit, let completions or cancellations fire;
-		 * we handshake using io->status.
-		 */
 		spin_unlock_irq(&io->lock);
+
+		retval = usb_submit_urb(io->urbs[i], GFP_NOIO);
+
 		switch (retval) {
 			/* maybe we retrying will recover */
 		case -ENXIO:	/* hc didn't queue this one */
@@ -594,8 +593,8 @@ void usb_sg_cancel(struct usb_sg_request
 		for (i = 0; i < io->entries; i++) {
 			int retval;
 
-			if (!io->urbs[i]->dev)
-				continue;
+			usb_block_urb(io->urbs[i]);
+
 			retval = usb_unlink_urb(io->urbs[i]);
 			if (retval != -EINPROGRESS
 					&& retval != -ENODEV

