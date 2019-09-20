Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72EA6B91BE
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388441AbfITOZR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:25:17 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36938 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388415AbfITOZR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:25:17 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqT-0004xy-Jl; Fri, 20 Sep 2019 15:25:13 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqE-0007tx-T1; Fri, 20 Sep 2019 15:24:58 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Ladislav Michl" <ladis@linux-mips.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Oliver Neukum" <oneukum@suse.com>
Date:   Fri, 20 Sep 2019 15:23:35 +0100
Message-ID: <lsq.1568989415.572119509@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 067/132] cdc-acm: store in and out pipes in acm structure
In-Reply-To: <lsq.1568989414.954567518@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.74-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ladislav Michl <ladis@linux-mips.org>

commit 74bccc9b71dc41d37e73fcdbcbec85310a670751 upstream.

Clearing stall needs pipe descriptor, store it in acm structure.

Signed-off-by: Ladislav Michl <ladis@linux-mips.org>
Acked-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/class/cdc-acm.c | 33 +++++++++++++++++----------------
 drivers/usb/class/cdc-acm.h |  1 +
 2 files changed, 18 insertions(+), 16 deletions(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1355,8 +1355,16 @@ made_compressed_probe:
 	spin_lock_init(&acm->read_lock);
 	mutex_init(&acm->mutex);
 	acm->is_int_ep = usb_endpoint_xfer_int(epread);
-	if (acm->is_int_ep)
+	if (acm->is_int_ep) {
 		acm->bInterval = epread->bInterval;
+		acm->in = usb_rcvintpipe(usb_dev, epread->bEndpointAddress);
+	} else {
+		acm->in = usb_rcvbulkpipe(usb_dev, epread->bEndpointAddress);
+	}
+	if (usb_endpoint_xfer_int(epwrite))
+		acm->out = usb_sndintpipe(usb_dev, epwrite->bEndpointAddress);
+	else
+		acm->out = usb_sndbulkpipe(usb_dev, epwrite->bEndpointAddress);
 	tty_port_init(&acm->port);
 	acm->port.ops = &acm_port_ops;
 	init_usb_anchor(&acm->delayed);
@@ -1401,20 +1409,15 @@ made_compressed_probe:
 		}
 		urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 		urb->transfer_dma = rb->dma;
-		if (acm->is_int_ep) {
-			usb_fill_int_urb(urb, acm->dev,
-					 usb_rcvintpipe(usb_dev, epread->bEndpointAddress),
-					 rb->base,
+		if (acm->is_int_ep)
+			usb_fill_int_urb(urb, acm->dev, acm->in, rb->base,
 					 acm->readsize,
 					 acm_read_bulk_callback, rb,
 					 acm->bInterval);
-		} else {
-			usb_fill_bulk_urb(urb, acm->dev,
-					  usb_rcvbulkpipe(usb_dev, epread->bEndpointAddress),
-					  rb->base,
+		else
+			usb_fill_bulk_urb(urb, acm->dev, acm->in, rb->base,
 					  acm->readsize,
 					  acm_read_bulk_callback, rb);
-		}
 
 		acm->read_urbs[i] = urb;
 		__set_bit(i, &acm->read_urbs_free);
@@ -1430,12 +1433,10 @@ made_compressed_probe:
 		}
 
 		if (usb_endpoint_xfer_int(epwrite))
-			usb_fill_int_urb(snd->urb, usb_dev,
-				usb_sndintpipe(usb_dev, epwrite->bEndpointAddress),
+			usb_fill_int_urb(snd->urb, usb_dev, acm->out,
 				NULL, acm->writesize, acm_write_bulk, snd, epwrite->bInterval);
 		else
-			usb_fill_bulk_urb(snd->urb, usb_dev,
-				usb_sndbulkpipe(usb_dev, epwrite->bEndpointAddress),
+			usb_fill_bulk_urb(snd->urb, usb_dev, acm->out,
 				NULL, acm->writesize, acm_write_bulk, snd);
 		snd->urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 		if (quirks & SEND_ZERO_PACKET)
@@ -1504,8 +1505,8 @@ skip_countries:
 	}
 
 	if (quirks & CLEAR_HALT_CONDITIONS) {
-		usb_clear_halt(usb_dev, usb_rcvbulkpipe(usb_dev, epread->bEndpointAddress));
-		usb_clear_halt(usb_dev, usb_sndbulkpipe(usb_dev, epwrite->bEndpointAddress));
+		usb_clear_halt(usb_dev, acm->in);
+		usb_clear_halt(usb_dev, acm->out);
 	}
 
 	return 0;
--- a/drivers/usb/class/cdc-acm.h
+++ b/drivers/usb/class/cdc-acm.h
@@ -83,6 +83,7 @@ struct acm {
 	struct usb_device *dev;				/* the corresponding usb device */
 	struct usb_interface *control;			/* control interface */
 	struct usb_interface *data;			/* data interface */
+	unsigned in, out;				/* i/o pipes */
 	struct tty_port port;			 	/* our tty port data */
 	struct urb *ctrlurb;				/* urbs */
 	u8 *ctrl_buffer;				/* buffers of urbs */

