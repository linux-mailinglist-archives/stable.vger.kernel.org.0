Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1C533AA63
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731327AbfFIQwM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:52:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:52864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732137AbfFIQwL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:52:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 582AC206DF;
        Sun,  9 Jun 2019 16:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099130;
        bh=amxF0ukhMKyB0rc4C9BAZQTUT+r86YpNfg4bhxsSct8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e9q9XJMGYF4sdB4CHTdL4Wz3eIGBRRyX+lhLwcWs9Vmwrx9RiPS21iS/hUMvkP6nQ
         iGJxk5/kp8/U5phX7pZsM9PYSTMKacSYKHnUncB8fSE3QaZOiRhA7he7c/bBMZVMQa
         6nBxhVZNuN83W6zS9zKzZDLA6M7b8bezZgsTMXiI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Henry Lin <henryl@nvidia.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 4.9 20/83] xhci: update bounce buffer with correct sg num
Date:   Sun,  9 Jun 2019 18:41:50 +0200
Message-Id: <20190609164129.226846275@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.843327870@linuxfoundation.org>
References: <20190609164127.843327870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Henry Lin <henryl@nvidia.com>

commit 597c56e372dab2c7f79b8d700aad3a5deebf9d1b upstream.

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
 drivers/usb/host/xhci-ring.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -678,6 +678,7 @@ void xhci_unmap_td_bounce_buffer(struct
 	struct device *dev = xhci_to_hcd(xhci)->self.controller;
 	struct xhci_segment *seg = td->bounce_seg;
 	struct urb *urb = td->urb;
+	size_t len;
 
 	if (!seg || !urb)
 		return;
@@ -688,11 +689,14 @@ void xhci_unmap_td_bounce_buffer(struct
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
@@ -3163,6 +3167,7 @@ static int xhci_align_td(struct xhci_hcd
 	unsigned int unalign;
 	unsigned int max_pkt;
 	u32 new_buff_len;
+	size_t len;
 
 	max_pkt = GET_MAX_PACKET(usb_endpoint_maxp(&urb->ep->desc));
 	unalign = (enqd_len + *trb_buff_len) % max_pkt;
@@ -3193,8 +3198,12 @@ static int xhci_align_td(struct xhci_hcd
 
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


