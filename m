Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98BF16AEADD
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:38:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231730AbjCGRiC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:38:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231731AbjCGRh1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:37:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AA8C8483F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:33:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 270A76150E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:33:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20471C4339C;
        Tue,  7 Mar 2023 17:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210408;
        bh=9m15ma9Ry7fVbi0COTk9hlqb6TcyuDNFbdcgq6uTU6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UR6M833xZCcDawxf8HBSDMABGKibJCtBZQNF/dXqJVRhdfPYRDnTflPa7JAsWsSEg
         sB/Xh0p1iOij54xX7kVx0vAseinN9ikNB+XzvD5jk4lFDolX7s7J4KXSYzqmotSRP+
         DhxBAIfizyYIhpaAe9l3oCe3JHQ/PEnZnbeSLzdQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0532/1001] dmaengine: dw-edma: Fix missing src/dst address of interleaved xfers
Date:   Tue,  7 Mar 2023 17:55:04 +0100
Message-Id: <20230307170044.539847443@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Serge Semin <Sergey.Semin@baikalelectronics.ru>

[ Upstream commit 13b6299cf66165a442089fa895a7f70250703584 ]

Interleaved DMA transfer support was added by 85e7518f42c8 ("dmaengine:
dw-edma: Add device_prep_interleave_dma() support"), but depending on the
selected channel, either source or destination address are left
uninitialized which was obviously wrong.

Initialize the destination address of the eDMA burst descriptors for
DEV_TO_MEM interleaved operations and the source address for MEM_TO_DEV
operations.

Link: https://lore.kernel.org/r/20230113171409.30470-5-Sergey.Semin@baikalelectronics.ru
Fixes: 85e7518f42c8 ("dmaengine: dw-edma: Add device_prep_interleave_dma() support")
Tested-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Acked-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dw-edma/dw-edma-core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/dma/dw-edma/dw-edma-core.c b/drivers/dma/dw-edma/dw-edma-core.c
index c54b24ff5206a..52bdf04aff511 100644
--- a/drivers/dma/dw-edma/dw-edma-core.c
+++ b/drivers/dma/dw-edma/dw-edma-core.c
@@ -455,6 +455,8 @@ dw_edma_device_transfer(struct dw_edma_transfer *xfer)
 				 * and destination addresses are increased
 				 * by the same portion (data length)
 				 */
+			} else if (xfer->type == EDMA_XFER_INTERLEAVED) {
+				burst->dar = dst_addr;
 			}
 		} else {
 			burst->dar = dst_addr;
@@ -470,6 +472,8 @@ dw_edma_device_transfer(struct dw_edma_transfer *xfer)
 				 * and destination addresses are increased
 				 * by the same portion (data length)
 				 */
+			}  else if (xfer->type == EDMA_XFER_INTERLEAVED) {
+				burst->sar = src_addr;
 			}
 		}
 
-- 
2.39.2



