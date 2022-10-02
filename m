Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6F685F262D
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 00:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbiJBWuv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Oct 2022 18:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbiJBWuW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Oct 2022 18:50:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DE2911474;
        Sun,  2 Oct 2022 15:49:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80B47B80DA0;
        Sun,  2 Oct 2022 22:49:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3253AC4314C;
        Sun,  2 Oct 2022 22:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664750986;
        bh=2eEzG9gMoeCDqrQE6PVnB7Na/A3URZNcMUiHeCsODx0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uuKsNBf3s+7QewDOYu5Y2Aie7rtp5Nhhm2U8Jzg2BuqQ+AmcD6N60qZ1KyVjqn24H
         CZXnuNeRPtSZwVbJgilMP0MFLYjQ+L1wXrBbTWnzsKsFxB3YH0qY8t3t0ZM9vt3cpV
         MLaznyvfZUUj7E7B/yaY3duql1npihMuNxr4HftyD3nCkm05wozxBpZTeDXlHFhS/M
         WKrMdy7MZ4hhuvxorDGzjKJLKTDlG5NFkSSO3Gha6/mPlKwjuCWMN/REXDFHEuwtfM
         znqNRlK6i/zos+le+yXYLhiTbjaN0q+kWyKXsRaCI5aQCnsV3mvXPWEmm7u5Cf2PU9
         RI2tmO5JtNCHA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Swati Agarwal <swati.agarwal@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        michal.simek@xilinx.com, lars@metafoo.de,
        shravya.kumbham@xilinx.com, adrianml@alumnos.upm.es,
        dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.19 08/29] dmaengine: xilinx_dma: Report error in case of dma_set_mask_and_coherent API failure
Date:   Sun,  2 Oct 2022 18:49:01 -0400
Message-Id: <20221002224922.238837-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221002224922.238837-1-sashal@kernel.org>
References: <20221002224922.238837-1-sashal@kernel.org>
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
index f63ec9d862ff..7ce8bb160a59 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -3211,7 +3211,11 @@ static int xilinx_dma_probe(struct platform_device *pdev)
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

