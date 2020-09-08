Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF13261B95
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731498AbgIHTEw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:04:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:52182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731270AbgIHQH0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:07:26 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B68F923E52;
        Tue,  8 Sep 2020 15:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599580031;
        bh=6atoX8XP8FftWBIJU03GqQ6Sc/P+z9fAOVR09T3a6kQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CNK4e6AhwBBjG+VWbLhxMdODC7SQlQpDRClQ+62w3oVlh3fgW49xcCGNDdXN3Yc0P
         HswaSYRVj5T7ytCBrpxw0fOIc2hn7vJ15Eza0rk1fg3Z+jEFIw9Paq8NPFsng+MJ5l
         APX2TNqpDkUUtM7nUS8qYTTCy+RKzjaY5DdQJBvU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gustavo Pimentel <gustavo.pimentel@synopsys.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.4 111/129] dmaengine: dw-edma: Fix scatter-gather address calculation
Date:   Tue,  8 Sep 2020 17:25:52 +0200
Message-Id: <20200908152235.387749205@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152229.689878733@linuxfoundation.org>
References: <20200908152229.689878733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gustavo Pimentel <Gustavo.Pimentel@synopsys.com>

commit 05655541c9503bfd01af4e6cbd7f5a29ac748e6c upstream.

Fix the source and destination physical address calculation of a
peripheral device on scatter-gather implementation.

This issue manifested during tests using a 64 bits architecture system.
The abnormal behavior wasn't visible before due to all previous tests
were done using 32 bits architecture system, that masked his effect.

Fixes: e63d79d1ffcd ("dmaengine: Add Synopsys eDMA IP core driver")
Cc: stable@vger.kernel.org
Signed-off-by: Gustavo Pimentel <gustavo.pimentel@synopsys.com>
Link: https://lore.kernel.org/r/8d3ab7e2ba96563fe3495b32f60077fffb85307d.1597327623.git.gustavo.pimentel@synopsys.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/dw-edma/dw-edma-core.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/dma/dw-edma/dw-edma-core.c
+++ b/drivers/dma/dw-edma/dw-edma-core.c
@@ -391,7 +391,7 @@ dw_edma_device_transfer(struct dw_edma_t
 			if (xfer->cyclic) {
 				burst->dar = xfer->xfer.cyclic.paddr;
 			} else {
-				burst->dar = sg_dma_address(sg);
+				burst->dar = dst_addr;
 				/* Unlike the typical assumption by other
 				 * drivers/IPs the peripheral memory isn't
 				 * a FIFO memory, in this case, it's a
@@ -399,14 +399,13 @@ dw_edma_device_transfer(struct dw_edma_t
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
@@ -414,12 +413,14 @@ dw_edma_device_transfer(struct dw_edma_t
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


