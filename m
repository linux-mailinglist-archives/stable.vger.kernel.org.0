Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEA1E5F26BC
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 00:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbiJBW7a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Oct 2022 18:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230511AbiJBW6m (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Oct 2022 18:58:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5103A40BC7;
        Sun,  2 Oct 2022 15:56:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CFAD60F30;
        Sun,  2 Oct 2022 22:53:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DAB8C433D6;
        Sun,  2 Oct 2022 22:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664751228;
        bh=zBzveb6Rt/VegdNsHPwco7gQy8Syv60pycr/MYw/PxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z/h4BXFgU3+J0aog0HuOOj1bJecwFVhPArRyi2YDFPowNaiRXFKe651BR6kEwre3S
         oXT/ZCelF5olmz5xlYUF9CnkbOMCDVxOiRlJVJdl9hJkEDGIDqSAtkYv6RP7gALvWx
         Rq9zgPAvbxvf5fgC+Dn61+QxK9PEvrvMaBPhCTRsGZLIG3pJm9dxl52Y7QuTO82pWE
         Xi1PzYDZ5XPY/qyl6KzHhG3qJM5Wiyy1t4WtX8jueHOsiMZWQasRsXTUDzPtO4L3II
         DJWYPLM3ETgjvbSNT9ZXu5pORT+fhGbZC+o0uzCfL054steF66UxHotgQf2VRJ6AgW
         ngMs3as9wqxgw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Swati Agarwal <swati.agarwal@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        michal.simek@xilinx.com, lars@metafoo.de, adrianml@alumnos.upm.es,
        shravya.kumbham@xilinx.com, dmaengine@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.9 2/6] dmaengine: xilinx_dma: Report error in case of dma_set_mask_and_coherent API failure
Date:   Sun,  2 Oct 2022 18:53:36 -0400
Message-Id: <20221002225342.240258-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221002225342.240258-1-sashal@kernel.org>
References: <20221002225342.240258-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

