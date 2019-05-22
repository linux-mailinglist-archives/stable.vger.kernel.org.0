Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80D89263C8
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 14:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729278AbfEVM1e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 08:27:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:32832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728468AbfEVM1d (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 08:27:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D6BD2173C;
        Wed, 22 May 2019 12:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558528053;
        bh=+oNwII6FSMiguTuNYJVnIkpJWakTtvegUoMuV7MrEo0=;
        h=Subject:To:From:Date:From;
        b=YqOelR8EN+kAmt0jO2dliDazaQ6q5lMxcJCpDNIzOoqMS5gY+kcE2Dny2Wbqn42jW
         rFJztoEG5czivrmAmLTOIRsGwvjo4wMSPTCvECnOd866gJ12ey4eXhzd8x/10CGWi4
         E7O6gPgyVwvY9kD7V/2MrwPqg+kbqSYx74KV2Rrc=
Subject: patch "xhci: update bounce buffer with correct sg num" added to usb-linus
To:     henryl@nvidia.com, gregkh@linuxfoundation.org,
        mathias.nyman@linux.intel.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 22 May 2019 14:27:25 +0200
Message-ID: <155852804532212@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    xhci: update bounce buffer with correct sg num

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 597c56e372dab2c7f79b8d700aad3a5deebf9d1b Mon Sep 17 00:00:00 2001
From: Henry Lin <henryl@nvidia.com>
Date: Wed, 22 May 2019 14:33:57 +0300
Subject: xhci: update bounce buffer with correct sg num

This change fixes a data corruption issue occurred on USB hard disk for
the case that bounce buffer is used during transferring data.

While updating data between sg list and bounce buffer, current
implementation passes mapped sg number (urb->num_mapped_sgs) to
sg_pcopy_from_buffer() and sg_pcopy_to_buffer(). This causes data
not get copied if target buffer is located in the elements after
mapped sg elements. This change passes sg number for full list to
fix issue.

Besides, for copying data from bounce buffer, calling dma_unmap_single()
on the bounce buffer before copying data to sg list can avoid cache issue.

Fixes: f9c589e142d0 ("xhci: TD-fragment, align the unsplittable case with a bounce buffer")
Cc: <stable@vger.kernel.org> # v4.8+
Signed-off-by: Henry Lin <henryl@nvidia.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-ring.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index fed3385aeac0..ef7c8698772e 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -656,6 +656,7 @@ static void xhci_unmap_td_bounce_buffer(struct xhci_hcd *xhci,
 	struct device *dev = xhci_to_hcd(xhci)->self.controller;
 	struct xhci_segment *seg = td->bounce_seg;
 	struct urb *urb = td->urb;
+	size_t len;
 
 	if (!ring || !seg || !urb)
 		return;
@@ -666,11 +667,14 @@ static void xhci_unmap_td_bounce_buffer(struct xhci_hcd *xhci,
 		return;
 	}
 
-	/* for in tranfers we need to copy the data from bounce to sg */
-	sg_pcopy_from_buffer(urb->sg, urb->num_mapped_sgs, seg->bounce_buf,
-			     seg->bounce_len, seg->bounce_offs);
 	dma_unmap_single(dev, seg->bounce_dma, ring->bounce_buf_len,
 			 DMA_FROM_DEVICE);
+	/* for in tranfers we need to copy the data from bounce to sg */
+	len = sg_pcopy_from_buffer(urb->sg, urb->num_sgs, seg->bounce_buf,
+			     seg->bounce_len, seg->bounce_offs);
+	if (len != seg->bounce_len)
+		xhci_warn(xhci, "WARN Wrong bounce buffer read length: %ld != %d\n",
+				len, seg->bounce_len);
 	seg->bounce_len = 0;
 	seg->bounce_offs = 0;
 }
@@ -3127,6 +3131,7 @@ static int xhci_align_td(struct xhci_hcd *xhci, struct urb *urb, u32 enqd_len,
 	unsigned int unalign;
 	unsigned int max_pkt;
 	u32 new_buff_len;
+	size_t len;
 
 	max_pkt = usb_endpoint_maxp(&urb->ep->desc);
 	unalign = (enqd_len + *trb_buff_len) % max_pkt;
@@ -3157,8 +3162,12 @@ static int xhci_align_td(struct xhci_hcd *xhci, struct urb *urb, u32 enqd_len,
 
 	/* create a max max_pkt sized bounce buffer pointed to by last trb */
 	if (usb_urb_dir_out(urb)) {
-		sg_pcopy_to_buffer(urb->sg, urb->num_mapped_sgs,
+		len = sg_pcopy_to_buffer(urb->sg, urb->num_sgs,
 				   seg->bounce_buf, new_buff_len, enqd_len);
+		if (len != seg->bounce_len)
+			xhci_warn(xhci,
+				"WARN Wrong bounce buffer write length: %ld != %d\n",
+				len, seg->bounce_len);
 		seg->bounce_dma = dma_map_single(dev, seg->bounce_buf,
 						 max_pkt, DMA_TO_DEVICE);
 	} else {
-- 
2.21.0


