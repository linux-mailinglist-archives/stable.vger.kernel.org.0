Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B33B623B8
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732434AbfGHPb5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:31:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:33332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390006AbfGHPbz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:31:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 750992177B;
        Mon,  8 Jul 2019 15:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599914;
        bh=ekdSFvh+SN6mN3zxQKPas/iAAKLnnIvSvZUc6aY/3Wk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bKXLkfhXjQEPOTr3WB+2ZpZ1U3o2daacUl8vSpO1Sqk8ayiD8igX/dVy7DJntrwl9
         iBO/23H2OLUz1ZvwvJJRqBztLsnbmVfRG7fqbUFuZYcuTtygPokgdBRWjEbmcG+guR
         sqXi13imnmO+jbYo5PrTNPyOBMWiVyFKdL7CbSTA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Minas Harutyunyan <hminas@synopsys.com>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 30/96] usb: gadget: dwc2: fix zlp handling
Date:   Mon,  8 Jul 2019 17:13:02 +0200
Message-Id: <20190708150528.178999528@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150526.234572443@linuxfoundation.org>
References: <20190708150526.234572443@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 066cfd0770aba8a9ac79b59d99530653885d919d ]

The patch 10209abe87f5ebfd482a00323f5236d6094d0865
usb: dwc2: gadget: Add scatter-gather mode

avoided a NULL pointer dereference (hs_ep->req == NULL) by
calling dwc2_gadget_fill_nonisoc_xfer_dma_one() directly instead of through
the dwc2_gadget_config_nonisoc_xfer_ddma() wrapper, which unconditionally
dereferenced the said pointer.

However, this was based on an incorrect assumption that in the context of
dwc2_hsotg_program_zlp() the pointer is always NULL, which is not the case.
The result were SB CV MSC tests failing starting from Test Case 6.

Instead, this patch reverts to calling the wrapper and adds a check for
the pointer being NULL inside the wrapper.

Fixes: 10209abe87f5 (usb: dwc2: gadget: Add scatter-gather mode)
Acked-by: Minas Harutyunyan <hminas@synopsys.com>
Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc2/gadget.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index a749de7604c6..c99ef9753930 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -833,19 +833,22 @@ static void dwc2_gadget_fill_nonisoc_xfer_ddma_one(struct dwc2_hsotg_ep *hs_ep,
  * with corresponding information based on transfer data.
  */
 static void dwc2_gadget_config_nonisoc_xfer_ddma(struct dwc2_hsotg_ep *hs_ep,
-						 struct usb_request *ureq,
-						 unsigned int offset,
+						 dma_addr_t dma_buff,
 						 unsigned int len)
 {
+	struct usb_request *ureq = NULL;
 	struct dwc2_dma_desc *desc = hs_ep->desc_list;
 	struct scatterlist *sg;
 	int i;
 	u8 desc_count = 0;
 
+	if (hs_ep->req)
+		ureq = &hs_ep->req->req;
+
 	/* non-DMA sg buffer */
-	if (!ureq->num_sgs) {
+	if (!ureq || !ureq->num_sgs) {
 		dwc2_gadget_fill_nonisoc_xfer_ddma_one(hs_ep, &desc,
-			ureq->dma + offset, len, true);
+			dma_buff, len, true);
 		return;
 	}
 
@@ -1133,7 +1136,7 @@ static void dwc2_hsotg_start_req(struct dwc2_hsotg *hsotg,
 			offset = ureq->actual;
 
 		/* Fill DDMA chain entries */
-		dwc2_gadget_config_nonisoc_xfer_ddma(hs_ep, ureq, offset,
+		dwc2_gadget_config_nonisoc_xfer_ddma(hs_ep, ureq->dma + offset,
 						     length);
 
 		/* write descriptor chain address to control register */
@@ -2026,12 +2029,13 @@ static void dwc2_hsotg_program_zlp(struct dwc2_hsotg *hsotg,
 		dev_dbg(hsotg->dev, "Receiving zero-length packet on ep%d\n",
 			index);
 	if (using_desc_dma(hsotg)) {
+		/* Not specific buffer needed for ep0 ZLP */
+		dma_addr_t dma = hs_ep->desc_list_dma;
+
 		if (!index)
 			dwc2_gadget_set_ep0_desc_chain(hsotg, hs_ep);
 
-		/* Not specific buffer needed for ep0 ZLP */
-		dwc2_gadget_fill_nonisoc_xfer_ddma_one(hs_ep, &hs_ep->desc_list,
-			hs_ep->desc_list_dma, 0, true);
+		dwc2_gadget_config_nonisoc_xfer_ddma(hs_ep, dma, 0);
 	} else {
 		dwc2_writel(hsotg, DXEPTSIZ_MC(1) | DXEPTSIZ_PKTCNT(1) |
 			    DXEPTSIZ_XFERSIZE(0),
-- 
2.20.1



