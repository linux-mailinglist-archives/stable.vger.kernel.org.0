Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3D1243B4E
	for <lists+stable@lfdr.de>; Thu, 13 Aug 2020 16:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726244AbgHMOON (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Aug 2020 10:14:13 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:36532 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726564AbgHMOOL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Aug 2020 10:14:11 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 861C6C0780;
        Thu, 13 Aug 2020 14:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1597328046; bh=Xlmlz1CXfxl0Vfg0RH3qJiq6ch33ppFptCxSiM1LcJo=;
        h=From:To:Cc:Subject:Date:From;
        b=EYrv2ED2Xl4imtENfs56TttPyiyvAbPjfs7qyedu9mt8Yw8sAgTEFgwe9B9igod+t
         Oj6dKL2MbbnVJd6gtO36r3Y5aaBzI89b+83fhq/1CBaec5W8s8B9sTcyoCeiAdFvMf
         J35EB0a3ccMIWKRHEC6gUf5CimPHhrAOl1yNvvPSI6vWStg0q99i3A6iVTnrSU2Njb
         tzqa47tsJ5pJ1KRSyVh0TEeu0ymud5RJeg8gBKNoJBCeOQpqZ9e5FOrQhlCSnzKtDb
         lGyI3WnK5nDg6Orje8fKX6CAX+oBxTuNSi7jXsvknIz7SEVZhGH2LPlBQOq2BGEiXk
         9GIHa+7rVJ56A==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 4F197A005A;
        Thu, 13 Aug 2020 14:14:05 +0000 (UTC)
X-SNPS-Relay: synopsys.com
From:   Gustavo Pimentel <Gustavo.Pimentel@synopsys.com>
To:     vkoul@kernel.org, dmaengine@vger.kernel.org
Cc:     Gustavo Pimentel <Gustavo.Pimentel@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>, stable@vger.kernel.org
Subject: [PATCH] dmaengine: dw-edma: Fix scatter-gather address calculation
Date:   Thu, 13 Aug 2020 16:14:04 +0200
Message-Id: <8d3ab7e2ba96563fe3495b32f60077fffb85307d.1597327623.git.gustavo.pimentel@synopsys.com>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix the source and destination physical address calculation of a
peripheral device on scatter-gather implementation.

This issue manifested during tests using a 64 bits architecture system.
The abnormal behavior wasn't visible before due to all previous tests
were done using 32 bits architecture system, that masked his effect.

Fixes: e63d79d1ffcd ("dmaengine: Add Synopsys eDMA IP core driver")

Cc: Joao Pinto <jpinto@synopsys.com>
Cc: stable@vger.kernel.org
Signed-off-by: Gustavo Pimentel <gustavo.pimentel@synopsys.com>
---
 drivers/dma/dw-edma/dw-edma-core.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/dw-edma/dw-edma-core.c b/drivers/dma/dw-edma/dw-edma-core.c
index ed430ad..b971505 100644
--- a/drivers/dma/dw-edma/dw-edma-core.c
+++ b/drivers/dma/dw-edma/dw-edma-core.c
@@ -405,7 +405,7 @@ dw_edma_device_transfer(struct dw_edma_transfer *xfer)
 			if (xfer->cyclic) {
 				burst->dar = xfer->xfer.cyclic.paddr;
 			} else {
-				burst->dar = sg_dma_address(sg);
+				burst->dar = dst_addr;
 				/* Unlike the typical assumption by other
 				 * drivers/IPs the peripheral memory isn't
 				 * a FIFO memory, in this case, it's a
@@ -413,14 +413,13 @@ dw_edma_device_transfer(struct dw_edma_transfer *xfer)
 				 * and destination addresses are increased
 				 * by the same portion (data length)
 				 */
-				src_addr += sg_dma_len(sg);
 			}
 		} else {
 			burst->dar = dst_addr;
 			if (xfer->cyclic) {
 				burst->sar = xfer->xfer.cyclic.paddr;
 			} else {
-				burst->sar = sg_dma_address(sg);
+				burst->sar = src_addr;
 				/* Unlike the typical assumption by other
 				 * drivers/IPs the peripheral memory isn't
 				 * a FIFO memory, in this case, it's a
@@ -428,12 +427,14 @@ dw_edma_device_transfer(struct dw_edma_transfer *xfer)
 				 * and destination addresses are increased
 				 * by the same portion (data length)
 				 */
-				dst_addr += sg_dma_len(sg);
 			}
 		}
 
-		if (!xfer->cyclic)
+		if (!xfer->cyclic) {
+			src_addr += sg_dma_len(sg);
+			dst_addr += sg_dma_len(sg);
 			sg = sg_next(sg);
+		}
 	}
 
 	return vchan_tx_prep(&chan->vc, &desc->vd, xfer->flags);
-- 
2.7.4

