Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6A23126BC9
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbfLSSxe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:53:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:48678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730395AbfLSSxe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:53:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12707227BF;
        Thu, 19 Dec 2019 18:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781612;
        bh=EB2nvPfIkj8d84Tc6Qbg9G35n5LNc0PSNGRHzsUl68o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ClImys3Da6AEKWNkqXmigX9/SQO2dXBZKDdrV1eSmhSKP0Gvfum26PJ3yMwNiYmQ9
         yLEsFCjIoYnJgTb8TEB+Dumdy1bhS9flCA/fgRyEml+DrvRb5bVqtS/z7QBMVojepV
         O23igsbMRH8p4XHdoGmeRRXjOX5TFiWb7pe9He5s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fredrik Noring <noring@nocrew.org>
Subject: [PATCH 5.4 01/80] USB: Fix incorrect DMA allocations for local memory pool drivers
Date:   Thu, 19 Dec 2019 19:33:53 +0100
Message-Id: <20191219183032.004373296@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183031.278083125@linuxfoundation.org>
References: <20191219183031.278083125@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fredrik Noring <noring@nocrew.org>

commit f8c63edfd78905320e86b6b2be2b7a5ac768fa4e upstream.

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
 drivers/usb/core/hcd.c         |   42 ++++++++++++++++++++---------------------
 drivers/usb/storage/scsiglue.c |    3 +-
 2 files changed, 23 insertions(+), 22 deletions(-)

--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -1409,7 +1409,17 @@ int usb_hcd_map_urb_for_dma(struct usb_h
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
 			if (is_vmalloc_addr(urb->setup_packet)) {
 				WARN_ONCE(1, "setup packet is not dma capable\n");
 				return -EAGAIN;
@@ -1427,23 +1437,22 @@ int usb_hcd_map_urb_for_dma(struct usb_h
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
 
@@ -1497,15 +1506,6 @@ int usb_hcd_map_urb_for_dma(struct usb_h
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
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -135,7 +135,8 @@ static int slave_configure(struct scsi_d
 	 * For such controllers we need to make sure the block layer sets
 	 * up bounce buffers in addressable memory.
 	 */
-	if (!hcd_uses_dma(bus_to_hcd(us->pusb_dev->bus)))
+	if (!hcd_uses_dma(bus_to_hcd(us->pusb_dev->bus)) ||
+			(bus_to_hcd(us->pusb_dev->bus)->localmem_pool != NULL))
 		blk_queue_bounce_limit(sdev->request_queue, BLK_BOUNCE_HIGH);
 
 	/*


