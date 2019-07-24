Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D251F732F6
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 17:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728120AbfGXPnw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 11:43:52 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:39683 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728051AbfGXPnv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jul 2019 11:43:51 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 65D8B21AFB;
        Wed, 24 Jul 2019 11:43:50 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 24 Jul 2019 11:43:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=0UTo8Z
        pK6pozVRVY7pM8PZOC3dplPvxyL/vhF9h07r8=; b=P/n3Vtmc5mdLvJHnkQ53Y9
        sViYcvjEOiPd4yI1WUGusd4DO3wbOPu/MfppeaJfZVsQFv75Gzy4Glm3pE2yfnR6
        MLwJxtRS3s35OUCm2u01I1nxF/jZv6dX/Lx9CFPyLXQFPxqcrwXr379G7o1+3dWH
        /RnNqc6T9uvAOFdjgEm/xbeCl6ILodAfUeq3O8aLYoWzKywWjpsCKKBQeuvinkoS
        RD18DdFODFVmSfGmtAauut/+k+dfdHCdePiqyjflHat83986EQjYx2sK/xe1hwUq
        TFwQZfggFXLdgGrMx0Kxt/7uVm/BNXOvQ7+uTxJoyAIk4bJ54rHaUcaxtVvlNjwA
        ==
X-ME-Sender: <xms:tXw4Xfrbxtb_mbCbANfPm4gPooZsznYKbVrjveqng72tyNvEVx7G_w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrkedtgdekiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:tXw4XUNTsCAOV9BZNgPRHcrdn1ZhykTrX2HgicUl7snc_x0eiukVDg>
    <xmx:tXw4XYyzxQoee3Opq2_RFU3Ir-1vRD2JZim7C-xAvikg4A5PMzPJpQ>
    <xmx:tXw4XVtwzs_EfKFQByDbUnvcw0uL_-u2HV3ffUEdEtdVMkptH_m6cw>
    <xmx:tnw4Xf5vPyIiZJgq-665IJZY8cmn8vBMyZ1BKLCe_6WdBY6jG_RC4A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E0F49380087;
        Wed, 24 Jul 2019 11:43:48 -0400 (EDT)
Subject: FAILED: patch "[PATCH] xhci: Fix immediate data transfer if buffer is already DMA" failed to apply to 5.2-stable tree
To:     mathias.nyman@linux.intel.com, gregkh@linuxfoundation.org,
        m.szyprowski@samsung.com, nsaenzjulienne@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 24 Jul 2019 17:43:47 +0200
Message-ID: <1563983027111159@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.2-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 13b82b746310b51b064bc855993a1c84bf862726 Mon Sep 17 00:00:00 2001
From: Mathias Nyman <mathias.nyman@linux.intel.com>
Date: Wed, 22 May 2019 14:34:00 +0300
Subject: [PATCH] xhci: Fix immediate data transfer if buffer is already DMA
 mapped

xhci immediate data transfer (IDT) support in 5.2-rc1 caused regression
on various Samsung Exynos boards with ASIX USB 2.0 ethernet dongle.

If the transfer buffer in the URB is already DMA mapped then IDT should
not be used. urb->transfer_dma will already contain a valid dma address,
and there is no guarantee the data in urb->transfer_buffer is valid.

The IDT support patch used urb->transfer_dma as a temporary storage,
copying data from urb->transfer_buffer into it.

Issue was solved by preventing IDT if transfer buffer is already dma
mapped, and by not using urb->transfer_dma as temporary storage.

Fixes: 33e39350ebd2 ("usb: xhci: add Immediate Data Transfer support")
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
CC: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index ef7c8698772e..88392aa65722 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -3432,11 +3432,14 @@ int xhci_queue_ctrl_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
 
 	if (urb->transfer_buffer_length > 0) {
 		u32 length_field, remainder;
+		u64 addr;
 
 		if (xhci_urb_suitable_for_idt(urb)) {
-			memcpy(&urb->transfer_dma, urb->transfer_buffer,
+			memcpy(&addr, urb->transfer_buffer,
 			       urb->transfer_buffer_length);
 			field |= TRB_IDT;
+		} else {
+			addr = (u64) urb->transfer_dma;
 		}
 
 		remainder = xhci_td_remainder(xhci, 0,
@@ -3449,8 +3452,8 @@ int xhci_queue_ctrl_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
 		if (setup->bRequestType & USB_DIR_IN)
 			field |= TRB_DIR_IN;
 		queue_trb(xhci, ep_ring, true,
-				lower_32_bits(urb->transfer_dma),
-				upper_32_bits(urb->transfer_dma),
+				lower_32_bits(addr),
+				upper_32_bits(addr),
 				length_field,
 				field | ep_ring->cycle_state);
 	}
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index a450a99e90eb..7f8b950d1a73 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -2160,7 +2160,8 @@ static inline bool xhci_urb_suitable_for_idt(struct urb *urb)
 {
 	if (!usb_endpoint_xfer_isoc(&urb->ep->desc) && usb_urb_dir_out(urb) &&
 	    usb_endpoint_maxp(&urb->ep->desc) >= TRB_IDT_MAX_SIZE &&
-	    urb->transfer_buffer_length <= TRB_IDT_MAX_SIZE)
+	    urb->transfer_buffer_length <= TRB_IDT_MAX_SIZE &&
+	    !(urb->transfer_flags & URB_NO_TRANSFER_DMA_MAP))
 		return true;
 
 	return false;

