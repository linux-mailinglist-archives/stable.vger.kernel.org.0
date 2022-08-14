Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8C335921A3
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240894AbiHNPiv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240901AbiHNPg7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:36:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C6E420188;
        Sun, 14 Aug 2022 08:32:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C29F60C98;
        Sun, 14 Aug 2022 15:32:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46C4FC43140;
        Sun, 14 Aug 2022 15:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660491133;
        bh=Hz4IDQ1JODRnQj2XRHBXSjJFvRrsRauABgljRV7KOqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uGA/AFmOL+9luENALRfA8LD9KwEYHJNGO+uwImHC3w7upCeqddpJL5cCLuTCmZnpe
         LrkCg5Cq+gZfS6peyl4WjfATLf6C4hyTn5HuFtxR1oP/BH+VKEAKaOzYG3pLsYmUGw
         lPr2RFMTvqygiySiKLRTnWywnsJfB/8kvRKDXX+8dxOiBF0mMYaChnJA1VofOqgVh0
         Gamf1UOSVbNewVBWwge6tkGnPor5Mutp8OrilM6XZDJOMNKisa8N193o5m6/ELuUtm
         hR7gw9vxRAOotmzuv6N8lGLMs94X/ilcOf9yuGopAwh479PrtvTvx4ENJcimvrV4Ga
         gY5g7Sentfwvw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ben Dooks <ben.dooks@sifive.com>, Vinod Koul <vkoul@kernel.org>,
        Sasha Levin <sashal@kernel.org>, Eugeniy.Paltsev@synopsys.com,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 40/56] dmaengine: dw-axi-dmac: ignore interrupt if no descriptor
Date:   Sun, 14 Aug 2022 11:30:10 -0400
Message-Id: <20220814153026.2377377-40-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814153026.2377377-1-sashal@kernel.org>
References: <20220814153026.2377377-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Dooks <ben.dooks@sifive.com>

[ Upstream commit 820f5ce999d2f99961e88c16d65cd26764df0590 ]

If the channel has no descriptor and the interrupt is raised then the
kernel will OOPS. Check the result of vchan_next_desc() in the handler
axi_chan_block_xfer_complete() to avoid the error happening.

Signed-off-by: Ben Dooks <ben.dooks@sifive.com>
Link: https://lore.kernel.org/r/20220708170153.269991-4-ben.dooks@sifive.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
index 41583f01a360..a183d93bd7e2 100644
--- a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
+++ b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
@@ -1054,6 +1054,11 @@ static void axi_chan_block_xfer_complete(struct axi_dma_chan *chan)
 
 	/* The completed descriptor currently is in the head of vc list */
 	vd = vchan_next_desc(&chan->vc);
+	if (!vd) {
+		dev_err(chan2dev(chan), "BUG: %s, IRQ with no descriptors\n",
+			axi_chan_name(chan));
+		goto out;
+	}
 
 	if (chan->cyclic) {
 		desc = vd_to_axi_desc(vd);
@@ -1083,6 +1088,7 @@ static void axi_chan_block_xfer_complete(struct axi_dma_chan *chan)
 		axi_chan_start_first_queued(chan);
 	}
 
+out:
 	spin_unlock_irqrestore(&chan->vc.lock, flags);
 }
 
-- 
2.35.1

