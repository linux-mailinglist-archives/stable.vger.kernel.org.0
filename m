Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEA0A5920EE
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240608AbiHNPcN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231731AbiHNPbg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:31:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99FDF1ADBF;
        Sun, 14 Aug 2022 08:29:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9BA5DB80B7E;
        Sun, 14 Aug 2022 15:29:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97664C43142;
        Sun, 14 Aug 2022 15:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660490982;
        bh=Hz4IDQ1JODRnQj2XRHBXSjJFvRrsRauABgljRV7KOqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UPK2418E/KuMH2gtRrux649RXk29tzU8xUnfu9VmhH3sBzRLkJZ4xQgFNd74BnxUY
         GW1lZBusHuFItxhPoAiFweMIFVM8h9iOEN4PunOHyIDOkCJegjyhkqJAHAmQE/b4aS
         DEn+Ypfi5CsWREU4i6F6hNb9SeT4Zt8DKQXQ1m04431i3lPQ/j2k7obwi/mxr1Zi6M
         SZhJEqbjp360zAIh44BRx+47LRI5/Ck/c48Dz5hlLetzKSLklVmVCofRNFwj5Soq0J
         CLflJ6njQfVGYkVojOrGQIO1XI3W/0e7I5lds24+lzcPXsMD5yTEzngmkAHTl6ownN
         Fxxflznapekhw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ben Dooks <ben.dooks@sifive.com>, Vinod Koul <vkoul@kernel.org>,
        Sasha Levin <sashal@kernel.org>, Eugeniy.Paltsev@synopsys.com,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 45/64] dmaengine: dw-axi-dmac: ignore interrupt if no descriptor
Date:   Sun, 14 Aug 2022 11:24:18 -0400
Message-Id: <20220814152437.2374207-45-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814152437.2374207-1-sashal@kernel.org>
References: <20220814152437.2374207-1-sashal@kernel.org>
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

