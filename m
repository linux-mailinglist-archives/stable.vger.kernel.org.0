Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8CA27035
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 22:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730248AbfEVTWA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 15:22:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:42628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730236AbfEVTV7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:21:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64556217F9;
        Wed, 22 May 2019 19:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558552918;
        bh=cUZTCZSKkExAXaZbd+FP2itMgvfaBTYv2eqKKMroUko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i0vquc6uvxigQC+EznGF/WVC/9gH/aDGAU3obp3TYXTsahbkTFS+udW3ib3LkrJuS
         C/Ib1ulrIG78sFcfp9OvxPXGMzlHIrFPszsq9y8jHEgc94rZsSvNzP5hzIOk3GRK9E
         UDZSnzwS0eHSQ5B1t28avCbAh+1RzPMioE6FnAqE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Minas Harutyunyan <minas.harutyunyan@synopsys.com>,
        Minas Harutyunyan <hminas@synopsys.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 029/375] usb: dwc2: gadget: Increase descriptors count for ISOC's
Date:   Wed, 22 May 2019 15:15:29 -0400
Message-Id: <20190522192115.22666-29-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192115.22666-1-sashal@kernel.org>
References: <20190522192115.22666-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Minas Harutyunyan <minas.harutyunyan@synopsys.com>

[ Upstream commit 54f37f56631747075f1f9a2f0edf6ba405e3e66c ]

Some function drivers queueing more than 128 ISOC requests at a time.
To avoid "descriptor chain full" cases, increasing descriptors count
from MAX_DMA_DESC_NUM_GENERIC to MAX_DMA_DESC_NUM_HS_ISOC for ISOC's
only.

Signed-off-by: Minas Harutyunyan <hminas@synopsys.com>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc2/gadget.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index 6812a8a3a98ba..a749de7604c62 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -714,13 +714,11 @@ static unsigned int dwc2_gadget_get_chain_limit(struct dwc2_hsotg_ep *hs_ep)
 	unsigned int maxsize;
 
 	if (is_isoc)
-		maxsize = hs_ep->dir_in ? DEV_DMA_ISOC_TX_NBYTES_LIMIT :
-					   DEV_DMA_ISOC_RX_NBYTES_LIMIT;
+		maxsize = (hs_ep->dir_in ? DEV_DMA_ISOC_TX_NBYTES_LIMIT :
+					   DEV_DMA_ISOC_RX_NBYTES_LIMIT) *
+					   MAX_DMA_DESC_NUM_HS_ISOC;
 	else
-		maxsize = DEV_DMA_NBYTES_LIMIT;
-
-	/* Above size of one descriptor was chosen, multiple it */
-	maxsize *= MAX_DMA_DESC_NUM_GENERIC;
+		maxsize = DEV_DMA_NBYTES_LIMIT * MAX_DMA_DESC_NUM_GENERIC;
 
 	return maxsize;
 }
@@ -932,7 +930,7 @@ static int dwc2_gadget_fill_isoc_desc(struct dwc2_hsotg_ep *hs_ep,
 
 	/* Update index of last configured entry in the chain */
 	hs_ep->next_desc++;
-	if (hs_ep->next_desc >= MAX_DMA_DESC_NUM_GENERIC)
+	if (hs_ep->next_desc >= MAX_DMA_DESC_NUM_HS_ISOC)
 		hs_ep->next_desc = 0;
 
 	return 0;
@@ -964,7 +962,7 @@ static void dwc2_gadget_start_isoc_ddma(struct dwc2_hsotg_ep *hs_ep)
 	}
 
 	/* Initialize descriptor chain by Host Busy status */
-	for (i = 0; i < MAX_DMA_DESC_NUM_GENERIC; i++) {
+	for (i = 0; i < MAX_DMA_DESC_NUM_HS_ISOC; i++) {
 		desc = &hs_ep->desc_list[i];
 		desc->status = 0;
 		desc->status |= (DEV_DMA_BUFF_STS_HBUSY
@@ -2162,7 +2160,7 @@ static void dwc2_gadget_complete_isoc_request_ddma(struct dwc2_hsotg_ep *hs_ep)
 		dwc2_hsotg_complete_request(hsotg, hs_ep, hs_req, 0);
 
 		hs_ep->compl_desc++;
-		if (hs_ep->compl_desc > (MAX_DMA_DESC_NUM_GENERIC - 1))
+		if (hs_ep->compl_desc > (MAX_DMA_DESC_NUM_HS_ISOC - 1))
 			hs_ep->compl_desc = 0;
 		desc_sts = hs_ep->desc_list[hs_ep->compl_desc].status;
 	}
@@ -3899,6 +3897,7 @@ static int dwc2_hsotg_ep_enable(struct usb_ep *ep,
 	unsigned int i, val, size;
 	int ret = 0;
 	unsigned char ep_type;
+	int desc_num;
 
 	dev_dbg(hsotg->dev,
 		"%s: ep %s: a 0x%02x, attr 0x%02x, mps 0x%04x, intr %d\n",
@@ -3945,11 +3944,15 @@ static int dwc2_hsotg_ep_enable(struct usb_ep *ep,
 	dev_dbg(hsotg->dev, "%s: read DxEPCTL=0x%08x from 0x%08x\n",
 		__func__, epctrl, epctrl_reg);
 
+	if (using_desc_dma(hsotg) && ep_type == USB_ENDPOINT_XFER_ISOC)
+		desc_num = MAX_DMA_DESC_NUM_HS_ISOC;
+	else
+		desc_num = MAX_DMA_DESC_NUM_GENERIC;
+
 	/* Allocate DMA descriptor chain for non-ctrl endpoints */
 	if (using_desc_dma(hsotg) && !hs_ep->desc_list) {
 		hs_ep->desc_list = dmam_alloc_coherent(hsotg->dev,
-			MAX_DMA_DESC_NUM_GENERIC *
-			sizeof(struct dwc2_dma_desc),
+			desc_num * sizeof(struct dwc2_dma_desc),
 			&hs_ep->desc_list_dma, GFP_ATOMIC);
 		if (!hs_ep->desc_list) {
 			ret = -ENOMEM;
@@ -4092,7 +4095,7 @@ static int dwc2_hsotg_ep_enable(struct usb_ep *ep,
 
 error2:
 	if (ret && using_desc_dma(hsotg) && hs_ep->desc_list) {
-		dmam_free_coherent(hsotg->dev, MAX_DMA_DESC_NUM_GENERIC *
+		dmam_free_coherent(hsotg->dev, desc_num *
 			sizeof(struct dwc2_dma_desc),
 			hs_ep->desc_list, hs_ep->desc_list_dma);
 		hs_ep->desc_list = NULL;
-- 
2.20.1

