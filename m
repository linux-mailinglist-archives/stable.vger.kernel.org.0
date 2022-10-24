Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDEE660A2EE
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 13:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbiJXLtn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 07:49:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231876AbiJXLtI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 07:49:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 067FA6D860;
        Mon, 24 Oct 2022 04:43:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF9C9B81181;
        Mon, 24 Oct 2022 11:40:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46393C433D7;
        Mon, 24 Oct 2022 11:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666611628;
        bh=zBzveb6Rt/VegdNsHPwco7gQy8Syv60pycr/MYw/PxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hLyBQEf87xzTD7Gi2SfhnfMh42/DsHIq7ebuqZlEMYt8myeiYVXFqQoSGl+FPQtz0
         cGdU2R8E9gTqxZRn9XK+s0LnerXYVlbUAsawx6Q0GbaxWjrpL17yvx6L0qgQPvu/Z+
         vdWrk2lTjuH00KUx/cOwjmM0Vw3yOXqXDNJWCuEk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Swati Agarwal <swati.agarwal@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 020/159] dmaengine: xilinx_dma: Report error in case of dma_set_mask_and_coherent API failure
Date:   Mon, 24 Oct 2022 13:29:34 +0200
Message-Id: <20221024112950.122771999@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112949.358278806@linuxfoundation.org>
References: <20221024112949.358278806@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Swati Agarwal <swati.agarwal@xilinx.com>

[ Upstream commit 8f2b6bc79c32f0fa60df000ae387a790ec80eae9 ]

The driver does not handle the failure case while calling
dma_set_mask_and_coherent API.

In case of failure, capture the return value of API and then report an
error.

Addresses-coverity: Unchecked return value (CHECKED_RETURN)

Signed-off-by: Swati Agarwal <swati.agarwal@xilinx.com>
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Link: https://lore.kernel.org/r/20220817061125.4720-4-swati.agarwal@xilinx.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/xilinx_dma.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/xilinx/xilinx_dma.c b/drivers/dma/xilinx/xilinx_dma.c
index c0ee6859cdfc..12e26dd8d442 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -2578,7 +2578,11 @@ static int xilinx_dma_probe(struct platform_device *pdev)
 		xdev->ext_addr = false;
 
 	/* Set the dma mask bits */
-	dma_set_mask_and_coherent(xdev->dev, DMA_BIT_MASK(addr_width));
+	err = dma_set_mask_and_coherent(xdev->dev, DMA_BIT_MASK(addr_width));
+	if (err < 0) {
+		dev_err(xdev->dev, "DMA mask error %d\n", err);
+		goto disable_clks;
+	}
 
 	/* Initialize the DMA engine */
 	xdev->common.dev = &pdev->dev;
-- 
2.35.1



