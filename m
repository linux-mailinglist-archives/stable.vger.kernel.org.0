Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F78F11A59A
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 09:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbfLKIJW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 03:09:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:60318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726543AbfLKIJW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 03:09:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 320802077B;
        Wed, 11 Dec 2019 08:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576051761;
        bh=zEeUurU1aSr6ZYP5oj+6Efgka5tRAnGhEEVsMu0bnL0=;
        h=Subject:To:From:Date:From;
        b=0oUyvo38cob1vzycY3MH9MjlrqZQOTg8Hp5j3B3ARbx7Eu1tZGDE4122xObWv7xD4
         WWj6IeY40NaLn49c9EhLtsNVB+LA87v0KpItRrP4sm0eKYKzoLKifBX1/Pbe/YO6Ae
         uhIZJ9AICrjkOoLPbQ3uBLm45wVi2YkPS01yh9BM=
Subject: patch "USB: Fix incorrect DMA allocations for local memory pool drivers" added to usb-linus
To:     noring@nocrew.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 11 Dec 2019 09:09:18 +0100
Message-ID: <1576051758171126@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: Fix incorrect DMA allocations for local memory pool drivers

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From f8c63edfd78905320e86b6b2be2b7a5ac768fa4e Mon Sep 17 00:00:00 2001
From: Fredrik Noring <noring@nocrew.org>
Date: Tue, 10 Dec 2019 18:29:05 +0100
Subject: USB: Fix incorrect DMA allocations for local memory pool drivers

Fix commit 7b81cb6bddd2 ("usb: add a HCD_DMA flag instead of
guestimating DMA capabilities") where local memory USB drivers
erroneously allocate DMA memory instead of pool memory, causing

	OHCI Unrecoverable Error, disabled
	HC died; cleaning up

The order between hcd_uses_dma() and hcd->localmem_pool is now
arranged as in hcd_buffer_alloc() and hcd_buffer_free(), with the
test for hcd->localmem_pool placed first.

As an alternative, one might consider adjusting hcd_uses_dma() with

 static inline bool hcd_uses_dma(struct usb_hcd *hcd)
 {
-	return IS_ENABLED(CONFIG_HAS_DMA) && (hcd->driver->flags & HCD_DMA);
+	return IS_ENABLED(CONFIG_HAS_DMA) &&
+		(hcd->driver->flags & HCD_DMA) &&
+		(hcd->localmem_pool == NULL);
 }

One can also consider unsetting HCD_DMA for local memory pool drivers.

Fixes: 7b81cb6bddd2 ("usb: add a HCD_DMA flag instead of guestimating DMA capabilities")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Fredrik Noring <noring@nocrew.org>
Link: https://lore.kernel.org/r/20191210172905.GA52526@sx9
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hcd.c         | 42 +++++++++++++++++-----------------
 drivers/usb/storage/scsiglue.c |  3 ++-
 2 files changed, 23 insertions(+), 22 deletions(-)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 281568d464f9..aa45840d8273 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -1409,7 +1409,17 @@ int usb_hcd_map_urb_for_dma(struct usb_hcd *hcd, struct urb *urb,
 	if (usb_endpoint_xfer_control(&urb->ep->desc)) {
 		if (hcd->self.uses_pio_for_control)
 			return ret;
-		if (hcd_uses_dma(hcd)) {
+		if (hcd->localmem_pool) {
+			ret = hcd_alloc_coherent(
+					urb->dev->bus, mem_flags,
+					&urb->setup_dma,
+					(void **)&urb->setup_packet,
+					sizeof(struct usb_ctrlrequest),
+					DMA_TO_DEVICE);
+			if (ret)
+				return ret;
+			urb->transfer_flags |= URB_SETUP_MAP_LOCAL;
+		} else if (hcd_uses_dma(hcd)) {
 			if (object_is_on_stack(urb->setup_packet)) {
 				WARN_ONCE(1, "setup packet is on stack\n");
 				return -EAGAIN;
@@ -1424,23 +1434,22 @@ int usb_hcd_map_urb_for_dma(struct usb_hcd *hcd, struct urb *urb,
 						urb->setup_dma))
 				return -EAGAIN;
 			urb->transfer_flags |= URB_SETUP_MAP_SINGLE;
-		} else if (hcd->localmem_pool) {
-			ret = hcd_alloc_coherent(
-					urb->dev->bus, mem_flags,
-					&urb->setup_dma,
-					(void **)&urb->setup_packet,
-					sizeof(struct usb_ctrlrequest),
-					DMA_TO_DEVICE);
-			if (ret)
-				return ret;
-			urb->transfer_flags |= URB_SETUP_MAP_LOCAL;
 		}
 	}
 
 	dir = usb_urb_dir_in(urb) ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
 	if (urb->transfer_buffer_length != 0
 	    && !(urb->transfer_flags & URB_NO_TRANSFER_DMA_MAP)) {
-		if (hcd_uses_dma(hcd)) {
+		if (hcd->localmem_pool) {
+			ret = hcd_alloc_coherent(
+					urb->dev->bus, mem_flags,
+					&urb->transfer_dma,
+					&urb->transfer_buffer,
+					urb->transfer_buffer_length,
+					dir);
+			if (ret == 0)
+				urb->transfer_flags |= URB_MAP_LOCAL;
+		} else if (hcd_uses_dma(hcd)) {
 			if (urb->num_sgs) {
 				int n;
 
@@ -1491,15 +1500,6 @@ int usb_hcd_map_urb_for_dma(struct usb_hcd *hcd, struct urb *urb,
 				else
 					urb->transfer_flags |= URB_DMA_MAP_SINGLE;
 			}
-		} else if (hcd->localmem_pool) {
-			ret = hcd_alloc_coherent(
-					urb->dev->bus, mem_flags,
-					&urb->transfer_dma,
-					&urb->transfer_buffer,
-					urb->transfer_buffer_length,
-					dir);
-			if (ret == 0)
-				urb->transfer_flags |= URB_MAP_LOCAL;
 		}
 		if (ret && (urb->transfer_flags & (URB_SETUP_MAP_SINGLE |
 				URB_SETUP_MAP_LOCAL)))
diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index 66a4dcbbb1fc..f4c2359abb1b 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -135,7 +135,8 @@ static int slave_configure(struct scsi_device *sdev)
 	 * For such controllers we need to make sure the block layer sets
 	 * up bounce buffers in addressable memory.
 	 */
-	if (!hcd_uses_dma(bus_to_hcd(us->pusb_dev->bus)))
+	if (!hcd_uses_dma(bus_to_hcd(us->pusb_dev->bus)) ||
+			(bus_to_hcd(us->pusb_dev->bus)->localmem_pool != NULL))
 		blk_queue_bounce_limit(sdev->request_queue, BLK_BOUNCE_HIGH);
 
 	/*
-- 
2.24.0


