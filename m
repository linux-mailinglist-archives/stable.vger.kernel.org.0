Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 724067969A
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403961AbfG2Tx2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:53:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:45786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390767AbfG2Tx0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:53:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5EF2E2054F;
        Mon, 29 Jul 2019 19:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564430005;
        bh=Tf9pv3jmi3sgVFMBLfygf4O+o/wGdfYJHtYUPKMetng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i2KehgazyPQVWW/Z+KVYOsfhrKcMBoI8VvS+2/szHYw0x5z979CyC1Ext8fZO9zD9
         V2NKP35YxI+Y18m9dpw2ug40Ed4TI2H1tPJyuKJIzeiCMuJlRDDRhKeEY6oZ5FSN93
         hSdJzsm6FrEPFVH0mWOccIJNXBHY51reJEr0IUSo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maik Stohn <maik.stohn@seal-one.com>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.2 167/215] xhci: Fix crash if scatter gather is used with Immediate Data Transfer (IDT).
Date:   Mon, 29 Jul 2019 21:22:43 +0200
Message-Id: <20190729190808.779029683@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit d39b5bad8658d6d94cb2d98a44a7e159db4f5030 upstream.

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
 drivers/usb/host/xhci.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -2170,7 +2170,8 @@ static inline bool xhci_urb_suitable_for
 	if (!usb_endpoint_xfer_isoc(&urb->ep->desc) && usb_urb_dir_out(urb) &&
 	    usb_endpoint_maxp(&urb->ep->desc) >= TRB_IDT_MAX_SIZE &&
 	    urb->transfer_buffer_length <= TRB_IDT_MAX_SIZE &&
-	    !(urb->transfer_flags & URB_NO_TRANSFER_DMA_MAP))
+	    !(urb->transfer_flags & URB_NO_TRANSFER_DMA_MAP) &&
+	    !urb->num_sgs)
 		return true;
 
 	return false;


