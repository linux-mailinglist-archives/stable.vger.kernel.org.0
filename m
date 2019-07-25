Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5F5274964
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 10:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389868AbfGYIxL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 04:53:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:22618 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388889AbfGYIxL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 04:53:11 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Jul 2019 01:53:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,306,1559545200"; 
   d="scan'208";a="253871913"
Received: from mattu-haswell.fi.intel.com ([10.237.72.164])
  by orsmga001.jf.intel.com with ESMTP; 25 Jul 2019 01:53:08 -0700
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "# v5 . 2" <stable@vger.kernel.org>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Subject: [PATCH] xhci: Fix crash if scatter gather is used with Immediate Data Transfer (IDT).
Date:   Thu, 25 Jul 2019 11:54:21 +0300
Message-Id: <1564044861-1445-1-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/usb/host/xhci.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 7a26496..f5c4144 100644
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
2.7.4

