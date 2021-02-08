Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33DB33136AA
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233356AbhBHPOB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:14:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:56488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233239AbhBHPK4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:10:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40BE864EE9;
        Mon,  8 Feb 2021 15:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612796878;
        bh=YPTrPnGbcbtD4w5d1jyrYJ5SnGmTeFsDRVy5D6VDXvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YfY7UwYkWl/wiio8c4HDxliOShqmTkgtk7aH/Y8WBrrjsm6jp6mJhJeJEPNQ+x/Jp
         vtlJvyIalfplX3pBrJyyz5hqFYfPyaAWRjAq/bAYW35ryECugGaUhWeg1WbFeMGMVJ
         pV4UifzQhkaJk1I54KNjVuYsC2tJVaJF18+KehzQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andreas Hartmann <andihartmann@01019freenet.de>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 4.19 20/38] xhci: fix bounce buffer usage for non-sg list case
Date:   Mon,  8 Feb 2021 16:01:07 +0100
Message-Id: <20210208145806.954111765@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145806.141056364@linuxfoundation.org>
References: <20210208145806.141056364@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit d4a610635400ccc382792f6be69427078541c678 upstream.

xhci driver may in some special cases need to copy small amounts
of payload data to a bounce buffer in order to meet the boundary
and alignment restrictions set by the xHCI specification.

In the majority of these cases the data is in a sg list, and
driver incorrectly assumed data is always in urb->sg when using
the bounce buffer.

If data instead is contiguous, and in urb->transfer_buffer, we may still
need to bounce buffer a small part if data starts very close (less than
packet size) to a 64k boundary.

Check if sg list is used before copying data to/from it.

Fixes: f9c589e142d0 ("xhci: TD-fragment, align the unsplittable case with a bounce buffer")
Cc: stable@vger.kernel.org
Reported-by: Andreas Hartmann <andihartmann@01019freenet.de>
Tested-by: Andreas Hartmann <andihartmann@01019freenet.de>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20210203113702.436762-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-ring.c |   31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -670,11 +670,16 @@ static void xhci_unmap_td_bounce_buffer(
 	dma_unmap_single(dev, seg->bounce_dma, ring->bounce_buf_len,
 			 DMA_FROM_DEVICE);
 	/* for in tranfers we need to copy the data from bounce to sg */
-	len = sg_pcopy_from_buffer(urb->sg, urb->num_sgs, seg->bounce_buf,
-			     seg->bounce_len, seg->bounce_offs);
-	if (len != seg->bounce_len)
-		xhci_warn(xhci, "WARN Wrong bounce buffer read length: %zu != %d\n",
-				len, seg->bounce_len);
+	if (urb->num_sgs) {
+		len = sg_pcopy_from_buffer(urb->sg, urb->num_sgs, seg->bounce_buf,
+					   seg->bounce_len, seg->bounce_offs);
+		if (len != seg->bounce_len)
+			xhci_warn(xhci, "WARN Wrong bounce buffer read length: %zu != %d\n",
+				  len, seg->bounce_len);
+	} else {
+		memcpy(urb->transfer_buffer + seg->bounce_offs, seg->bounce_buf,
+		       seg->bounce_len);
+	}
 	seg->bounce_len = 0;
 	seg->bounce_offs = 0;
 }
@@ -3180,12 +3185,16 @@ static int xhci_align_td(struct xhci_hcd
 
 	/* create a max max_pkt sized bounce buffer pointed to by last trb */
 	if (usb_urb_dir_out(urb)) {
-		len = sg_pcopy_to_buffer(urb->sg, urb->num_sgs,
-				   seg->bounce_buf, new_buff_len, enqd_len);
-		if (len != new_buff_len)
-			xhci_warn(xhci,
-				"WARN Wrong bounce buffer write length: %zu != %d\n",
-				len, new_buff_len);
+		if (urb->num_sgs) {
+			len = sg_pcopy_to_buffer(urb->sg, urb->num_sgs,
+						 seg->bounce_buf, new_buff_len, enqd_len);
+			if (len != new_buff_len)
+				xhci_warn(xhci, "WARN Wrong bounce buffer write length: %zu != %d\n",
+					  len, new_buff_len);
+		} else {
+			memcpy(seg->bounce_buf, urb->transfer_buffer + enqd_len, new_buff_len);
+		}
+
 		seg->bounce_dma = dma_map_single(dev, seg->bounce_buf,
 						 max_pkt, DMA_TO_DEVICE);
 	} else {


