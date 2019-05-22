Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC1F262F8
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 13:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728638AbfEVLbj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 07:31:39 -0400
Received: from mga14.intel.com ([192.55.52.115]:39534 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728335AbfEVLbj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 07:31:39 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 May 2019 04:31:38 -0700
X-ExtLoop1: 1
Received: from mattu-haswell.fi.intel.com ([10.237.72.164])
  by orsmga003.jf.intel.com with ESMTP; 22 May 2019 04:31:37 -0700
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>, Henry Lin <henryl@nvidia.com>,
        "# v4 . 8+" <stable@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 1/5] xhci: update bounce buffer with correct sg num
Date:   Wed, 22 May 2019 14:33:57 +0300
Message-Id: <1558524841-25397-2-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558524841-25397-1-git-send-email-mathias.nyman@linux.intel.com>
References: <1558524841-25397-1-git-send-email-mathias.nyman@linux.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Henry Lin <henryl@nvidia.com>

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
---
 drivers/usb/host/xhci-ring.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index fed3385..ef7c869 100644
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
2.7.4

