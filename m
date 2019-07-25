Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB0DA749D5
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 11:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390467AbfGYJ1J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 05:27:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:50864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390466AbfGYJ1J (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 05:27:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 616072238C;
        Thu, 25 Jul 2019 09:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564046827;
        bh=AEYMUlQQFo2J4WdYJQ4zWLsAdXHhcfoeay4PbZpuDyM=;
        h=Subject:To:From:Date:From;
        b=XRO/+qNoh+T5Goo4eSb00oG9lP7QS8YXoBW8kf0iKs7EW0StLo6TP8DmYE0l9UA4D
         Q6KYcugq/LmxSRp7GQ8MSc2mxHCWj2UtEGBYJkCInHNcZzDYmVMxl9gdshjYEBjcSV
         ASuqOwAONPpRu2kXa/YDhsAWflgnT9Dy5oXPQAIw=
Subject: patch "xhci: Fix crash if scatter gather is used with Immediate Data" added to usb-linus
To:     mathias.nyman@linux.intel.com, gregkh@linuxfoundation.org,
        maik.stohn@seal-one.com, nsaenzjulienne@suse.de,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 25 Jul 2019 11:27:05 +0200
Message-ID: <1564046825237139@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    xhci: Fix crash if scatter gather is used with Immediate Data

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From d39b5bad8658d6d94cb2d98a44a7e159db4f5030 Mon Sep 17 00:00:00 2001
From: Mathias Nyman <mathias.nyman@linux.intel.com>
Date: Thu, 25 Jul 2019 11:54:21 +0300
Subject: xhci: Fix crash if scatter gather is used with Immediate Data
 Transfer (IDT).

A second regression was found in the immediate data transfer (IDT)
support which was added to 5.2 kernel

IDT is used to transfer small amounts of data (up to 8 bytes) in the
field normally used for data dma address, thus avoiding dma mapping.

If the data was not already dma mapped, then IDT support assumed data was
in urb->transfer_buffer, and did not take into accound that even
small amounts of data (8 bytes) can be in a scatterlist instead.

This caused a NULL pointer dereference when sg_dma_len() was used
with non-dma mapped data.

Solve this by not using IDT if scatter gather buffer list is used.

Fixes: 33e39350ebd2 ("usb: xhci: add Immediate Data Transfer support")
Cc: <stable@vger.kernel.org> # v5.2
Reported-by: Maik Stohn <maik.stohn@seal-one.com>
Tested-by: Maik Stohn <maik.stohn@seal-one.com>
CC: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/1564044861-1445-1-git-send-email-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 7a264962a1a9..f5c41448d067 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -2175,7 +2175,8 @@ static inline bool xhci_urb_suitable_for_idt(struct urb *urb)
 	if (!usb_endpoint_xfer_isoc(&urb->ep->desc) && usb_urb_dir_out(urb) &&
 	    usb_endpoint_maxp(&urb->ep->desc) >= TRB_IDT_MAX_SIZE &&
 	    urb->transfer_buffer_length <= TRB_IDT_MAX_SIZE &&
-	    !(urb->transfer_flags & URB_NO_TRANSFER_DMA_MAP))
+	    !(urb->transfer_flags & URB_NO_TRANSFER_DMA_MAP) &&
+	    !urb->num_sgs)
 		return true;
 
 	return false;
-- 
2.22.0


