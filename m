Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5345F2709
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 01:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230438AbiJBXH2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Oct 2022 19:07:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230415AbiJBXHH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Oct 2022 19:07:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D31543148;
        Sun,  2 Oct 2022 16:02:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9DCDD60F27;
        Sun,  2 Oct 2022 22:53:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6381C433C1;
        Sun,  2 Oct 2022 22:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664751225;
        bh=omnBrp0Ds6pSUZeQ+zc7zo+0NlTtd4nF+pHskT6RTLs=;
        h=From:To:Cc:Subject:Date:From;
        b=Qihs5CdcfrRTBwwpnRvG2wehGGdIk7kXoL6WFNjoWXrfKgbrnp22Z9GLumW/GBV2o
         kWGk20W8TjqHjBmhO5efGDtaLJtA6dFPpM9rPBUX7f00Ypk6WTU5hwJtU6mCWmrNF+
         MMrdxClXham75FlJnNj99ZyCUqkG11Ve4oLVyHJflhcoKz1u6VndaDKPpVMOT7VxOo
         xZM835iESs7VGVo/8vcYOpClPNwslIiAxmBRh6ddS1EceHb0tS1zLU0Y1OsRQP/8hd
         ev/0UG1wDAqOGG96+/Jrn0bEwz18X+fze3QbZdI5AZ9QcLo/iMdYJRLLiw6H81RInJ
         FhF2zpYgeSjwQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Swati Agarwal <swati.agarwal@xilinx.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        michal.simek@xilinx.com, radhey.shyam.pandey@xilinx.com,
        lars@metafoo.de, adrianml@alumnos.upm.es,
        shravya.kumbham@xilinx.com, dmaengine@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.9 1/6] dmaengine: xilinx_dma: cleanup for fetching xlnx,num-fstores property
Date:   Sun,  2 Oct 2022 18:53:35 -0400
Message-Id: <20221002225342.240258-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
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

[ Upstream commit 462bce790e6a7e68620a4ce260cc38f7ed0255d5 ]

Free the allocated resources for missing xlnx,num-fstores property.

Signed-off-by: Swati Agarwal <swati.agarwal@xilinx.com>
Link: https://lore.kernel.org/r/20220817061125.4720-3-swati.agarwal@xilinx.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/xilinx_dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/xilinx/xilinx_dma.c b/drivers/dma/xilinx/xilinx_dma.c
index d88c53ff7bb6..c0ee6859cdfc 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -2558,7 +2558,7 @@ static int xilinx_dma_probe(struct platform_device *pdev)
 		if (err < 0) {
 			dev_err(xdev->dev,
 				"missing xlnx,num-fstores property\n");
-			return err;
+			goto disable_clks;
 		}
 
 		err = of_property_read_u32(node, "xlnx,flush-fsync",
-- 
2.35.1

