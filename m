Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 912AD29B88E
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:09:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368759AbgJ0Pln (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:41:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:53598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1800148AbgJ0PfM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:35:12 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAB6B22275;
        Tue, 27 Oct 2020 15:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812910;
        bh=964bskyV8O3WcSQSOdmYBeLQY8q6cD1nKh/KLDJ0QcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fJeJQ06mXnKBu5GCj3N47lT7CeXGzRL86fZ3eZOTx6V/T0PPzO06fflANJhRUoMIt
         OskhwTC6sh9g9zvDOVagVYXGo8cPqXgHD2xw/H4Zo+k8U7PWUJcjkFD0ij/4H+60+g
         kPpMIDK1t+nLCOICZrdRa/v3Ot2R8vSzapQOp6g0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Minas Harutyunyan <hminas@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 371/757] usb: dwc2: Fix INTR OUT transfers in DDMA mode.
Date:   Tue, 27 Oct 2020 14:50:21 +0100
Message-Id: <20201027135507.968665671@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>

[ Upstream commit b2c586eb07efab982419f32b7c3bd96829bc8bcd ]

In DDMA mode if INTR OUT transfers mps not multiple of 4 then single packet
corresponds to single descriptor.

Descriptor limit set to mps and desc chain limit set to mps *
MAX_DMA_DESC_NUM_GENERIC. On that descriptors complete, to calculate
transfer size should be considered correction value for each descriptor.

In start request function, if "continue" is true then dma buffer address
should be incremmented by offset for all type of transfers, not only for
Control DATA_OUT transfers.

Fixes: cf77b5fb9b394 ("usb: dwc2: gadget: Transfer length limit checking for DDMA")
Fixes: e02f9aa6119e0 ("usb: dwc2: gadget: EP 0 specific DDMA programming")
Fixes: aa3e8bc81311e ("usb: dwc2: gadget: DDMA transfer start and complete")

Signed-off-by: Minas Harutyunyan <hminas@synopsys.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc2/gadget.c | 40 ++++++++++++++++++++++++++++++++-------
 1 file changed, 33 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index 5b9d23991c99d..d367da4c6f850 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -713,8 +713,11 @@ static u32 dwc2_hsotg_read_frameno(struct dwc2_hsotg *hsotg)
  */
 static unsigned int dwc2_gadget_get_chain_limit(struct dwc2_hsotg_ep *hs_ep)
 {
+	const struct usb_endpoint_descriptor *ep_desc = hs_ep->ep.desc;
 	int is_isoc = hs_ep->isochronous;
 	unsigned int maxsize;
+	u32 mps = hs_ep->ep.maxpacket;
+	int dir_in = hs_ep->dir_in;
 
 	if (is_isoc)
 		maxsize = (hs_ep->dir_in ? DEV_DMA_ISOC_TX_NBYTES_LIMIT :
@@ -723,6 +726,11 @@ static unsigned int dwc2_gadget_get_chain_limit(struct dwc2_hsotg_ep *hs_ep)
 	else
 		maxsize = DEV_DMA_NBYTES_LIMIT * MAX_DMA_DESC_NUM_GENERIC;
 
+	/* Interrupt OUT EP with mps not multiple of 4 */
+	if (hs_ep->index)
+		if (usb_endpoint_xfer_int(ep_desc) && !dir_in && (mps % 4))
+			maxsize = mps * MAX_DMA_DESC_NUM_GENERIC;
+
 	return maxsize;
 }
 
@@ -738,11 +746,14 @@ static unsigned int dwc2_gadget_get_chain_limit(struct dwc2_hsotg_ep *hs_ep)
  * Isochronous - descriptor rx/tx bytes bitfield limit,
  * Control In/Bulk/Interrupt - multiple of mps. This will allow to not
  * have concatenations from various descriptors within one packet.
+ * Interrupt OUT - if mps not multiple of 4 then a single packet corresponds
+ * to a single descriptor.
  *
  * Selects corresponding mask for RX/TX bytes as well.
  */
 static u32 dwc2_gadget_get_desc_params(struct dwc2_hsotg_ep *hs_ep, u32 *mask)
 {
+	const struct usb_endpoint_descriptor *ep_desc = hs_ep->ep.desc;
 	u32 mps = hs_ep->ep.maxpacket;
 	int dir_in = hs_ep->dir_in;
 	u32 desc_size = 0;
@@ -766,6 +777,13 @@ static u32 dwc2_gadget_get_desc_params(struct dwc2_hsotg_ep *hs_ep, u32 *mask)
 		desc_size -= desc_size % mps;
 	}
 
+	/* Interrupt OUT EP with mps not multiple of 4 */
+	if (hs_ep->index)
+		if (usb_endpoint_xfer_int(ep_desc) && !dir_in && (mps % 4)) {
+			desc_size = mps;
+			*mask = DEV_DMA_NBYTES_MASK;
+		}
+
 	return desc_size;
 }
 
@@ -1123,13 +1141,7 @@ static void dwc2_hsotg_start_req(struct dwc2_hsotg *hsotg,
 				length += (mps - (length % mps));
 		}
 
-		/*
-		 * If more data to send, adjust DMA for EP0 out data stage.
-		 * ureq->dma stays unchanged, hence increment it by already
-		 * passed passed data count before starting new transaction.
-		 */
-		if (!index && hsotg->ep0_state == DWC2_EP0_DATA_OUT &&
-		    continuing)
+		if (continuing)
 			offset = ureq->actual;
 
 		/* Fill DDMA chain entries */
@@ -2320,22 +2332,36 @@ static void dwc2_hsotg_change_ep_iso_parity(struct dwc2_hsotg *hsotg,
  */
 static unsigned int dwc2_gadget_get_xfersize_ddma(struct dwc2_hsotg_ep *hs_ep)
 {
+	const struct usb_endpoint_descriptor *ep_desc = hs_ep->ep.desc;
 	struct dwc2_hsotg *hsotg = hs_ep->parent;
 	unsigned int bytes_rem = 0;
+	unsigned int bytes_rem_correction = 0;
 	struct dwc2_dma_desc *desc = hs_ep->desc_list;
 	int i;
 	u32 status;
+	u32 mps = hs_ep->ep.maxpacket;
+	int dir_in = hs_ep->dir_in;
 
 	if (!desc)
 		return -EINVAL;
 
+	/* Interrupt OUT EP with mps not multiple of 4 */
+	if (hs_ep->index)
+		if (usb_endpoint_xfer_int(ep_desc) && !dir_in && (mps % 4))
+			bytes_rem_correction = 4 - (mps % 4);
+
 	for (i = 0; i < hs_ep->desc_count; ++i) {
 		status = desc->status;
 		bytes_rem += status & DEV_DMA_NBYTES_MASK;
+		bytes_rem -= bytes_rem_correction;
 
 		if (status & DEV_DMA_STS_MASK)
 			dev_err(hsotg->dev, "descriptor %d closed with %x\n",
 				i, status & DEV_DMA_STS_MASK);
+
+		if (status & DEV_DMA_L)
+			break;
+
 		desc++;
 	}
 
-- 
2.25.1



