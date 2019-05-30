Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 080752EBDD
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730711AbfE3DQc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:16:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:42842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730700AbfE3DQa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:16:30 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2ED56245E2;
        Thu, 30 May 2019 03:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186190;
        bh=3QVzWclzo9H5FqhP9I14efu6cVzIX/VK2e7Ulx5gLJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hiNF2Eqamx76WtdK+a5q6cq3hmh70tJsaTSbZauaELf9sXvqz9Dvxu+eneNu/Fqlj
         TRLNMh59lXVImrNFV8QH7k6KmZuSdb89/s7722o5HhT0kf2THzyFaVM1nsq1PEAtGU
         4ZDN8xjrXBhTwDLCuFz+bjYgp9c9x+5aW3WRaFWE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Minas Harutyunyan <hminas@synopsys.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 059/276] usb: dwc2: gadget: Increase descriptors count for ISOCs
Date:   Wed, 29 May 2019 20:03:37 -0700
Message-Id: <20190530030529.237507288@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 220c0f9b89b0b..03614ef64ca47 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -675,13 +675,11 @@ static unsigned int dwc2_gadget_get_chain_limit(struct dwc2_hsotg_ep *hs_ep)
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
@@ -864,7 +862,7 @@ static int dwc2_gadget_fill_isoc_desc(struct dwc2_hsotg_ep *hs_ep,
 
 	/* Update index of last configured entry in the chain */
 	hs_ep->next_desc++;
-	if (hs_ep->next_desc >= MAX_DMA_DESC_NUM_GENERIC)
+	if (hs_ep->next_desc >= MAX_DMA_DESC_NUM_HS_ISOC)
 		hs_ep->next_desc = 0;
 
 	return 0;
@@ -896,7 +894,7 @@ static void dwc2_gadget_start_isoc_ddma(struct dwc2_hsotg_ep *hs_ep)
 	}
 
 	/* Initialize descriptor chain by Host Busy status */
-	for (i = 0; i < MAX_DMA_DESC_NUM_GENERIC; i++) {
+	for (i = 0; i < MAX_DMA_DESC_NUM_HS_ISOC; i++) {
 		desc = &hs_ep->desc_list[i];
 		desc->status = 0;
 		desc->status |= (DEV_DMA_BUFF_STS_HBUSY
@@ -2083,7 +2081,7 @@ static void dwc2_gadget_complete_isoc_request_ddma(struct dwc2_hsotg_ep *hs_ep)
 		dwc2_hsotg_complete_request(hsotg, hs_ep, hs_req, 0);
 
 		hs_ep->compl_desc++;
-		if (hs_ep->compl_desc > (MAX_DMA_DESC_NUM_GENERIC - 1))
+		if (hs_ep->compl_desc > (MAX_DMA_DESC_NUM_HS_ISOC - 1))
 			hs_ep->compl_desc = 0;
 		desc_sts = hs_ep->desc_list[hs_ep->compl_desc].status;
 	}
@@ -3779,6 +3777,7 @@ static int dwc2_hsotg_ep_enable(struct usb_ep *ep,
 	unsigned int i, val, size;
 	int ret = 0;
 	unsigned char ep_type;
+	int desc_num;
 
 	dev_dbg(hsotg->dev,
 		"%s: ep %s: a 0x%02x, attr 0x%02x, mps 0x%04x, intr %d\n",
@@ -3825,11 +3824,15 @@ static int dwc2_hsotg_ep_enable(struct usb_ep *ep,
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
@@ -3971,7 +3974,7 @@ static int dwc2_hsotg_ep_enable(struct usb_ep *ep,
 
 error2:
 	if (ret && using_desc_dma(hsotg) && hs_ep->desc_list) {
-		dmam_free_coherent(hsotg->dev, MAX_DMA_DESC_NUM_GENERIC *
+		dmam_free_coherent(hsotg->dev, desc_num *
 			sizeof(struct dwc2_dma_desc),
 			hs_ep->desc_list, hs_ep->desc_list_dma);
 		hs_ep->desc_list = NULL;
-- 
2.20.1



