Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2668B39C37
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 11:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbfFHJl1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jun 2019 05:41:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:37362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726638AbfFHJl1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Jun 2019 05:41:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8562D214AF;
        Sat,  8 Jun 2019 09:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559986886;
        bh=+oj4oDZNcfJQthfeiapxKLeVEF2xc3OEkBqUsmy2Xek=;
        h=Subject:To:From:Date:From;
        b=p7EBGI6ujZyfUm+2lnFFYHZ4Eq9eV/2cYYWIpVb8jquj1gHYHCjK3hppsfj4xi+r3
         zuU/8u2DAEPGv5+nLV35o5ud2lONDp33w+N9xOWFqt4lQcqrUZJmZYXnBER6CjKifM
         5ekttSwOd6jRVCIGZw6S23DtcqUtLlof3+GvXJ38=
Subject: patch "usb: dwc2: Fix DMA cache alignment issues" added to usb-linus
To:     ms@dev.tdt.de, dianders@chromium.org, felipe.balbi@linux.intel.com,
        hminas@synopsys.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 08 Jun 2019 11:41:15 +0200
Message-ID: <155998687527209@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc2: Fix DMA cache alignment issues

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 4a4863bf2e7932e584a3a462d3c6daf891142ddc Mon Sep 17 00:00:00 2001
From: Martin Schiller <ms@dev.tdt.de>
Date: Mon, 18 Feb 2019 07:37:30 +0100
Subject: usb: dwc2: Fix DMA cache alignment issues

Insert a padding between data and the stored_xfer_buffer pointer to
ensure they are not on the same cache line.

Otherwise, the stored_xfer_buffer gets corrupted for IN URBs on
non-cache-coherent systems. (In my case: Lantiq xRX200 MIPS)

Fixes: 3bc04e28a030 ("usb: dwc2: host: Get aligned DMA in a more supported way")
Fixes: 56406e017a88 ("usb: dwc2: Fix DMA alignment to start at allocated boundary")
Cc: <stable@vger.kernel.org>
Tested-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Acked-by: Minas Harutyunyan <hminas@synopsys.com>
Signed-off-by: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
---
 drivers/usb/dwc2/hcd.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/dwc2/hcd.c b/drivers/usb/dwc2/hcd.c
index 5c51bf5506d1..2192a2873c7c 100644
--- a/drivers/usb/dwc2/hcd.c
+++ b/drivers/usb/dwc2/hcd.c
@@ -2480,8 +2480,10 @@ static void dwc2_free_dma_aligned_buffer(struct urb *urb)
 		return;
 
 	/* Restore urb->transfer_buffer from the end of the allocated area */
-	memcpy(&stored_xfer_buffer, urb->transfer_buffer +
-	       urb->transfer_buffer_length, sizeof(urb->transfer_buffer));
+	memcpy(&stored_xfer_buffer,
+	       PTR_ALIGN(urb->transfer_buffer + urb->transfer_buffer_length,
+			 dma_get_cache_alignment()),
+	       sizeof(urb->transfer_buffer));
 
 	if (usb_urb_dir_in(urb)) {
 		if (usb_pipeisoc(urb->pipe))
@@ -2513,6 +2515,7 @@ static int dwc2_alloc_dma_aligned_buffer(struct urb *urb, gfp_t mem_flags)
 	 * DMA
 	 */
 	kmalloc_size = urb->transfer_buffer_length +
+		(dma_get_cache_alignment() - 1) +
 		sizeof(urb->transfer_buffer);
 
 	kmalloc_ptr = kmalloc(kmalloc_size, mem_flags);
@@ -2523,7 +2526,8 @@ static int dwc2_alloc_dma_aligned_buffer(struct urb *urb, gfp_t mem_flags)
 	 * Position value of original urb->transfer_buffer pointer to the end
 	 * of allocation for later referencing
 	 */
-	memcpy(kmalloc_ptr + urb->transfer_buffer_length,
+	memcpy(PTR_ALIGN(kmalloc_ptr + urb->transfer_buffer_length,
+			 dma_get_cache_alignment()),
 	       &urb->transfer_buffer, sizeof(urb->transfer_buffer));
 
 	if (usb_urb_dir_out(urb))
-- 
2.21.0


