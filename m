Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35B0759D98C
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349034AbiHWJWb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:22:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349727AbiHWJU6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:20:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0D1D8A1E9;
        Tue, 23 Aug 2022 01:34:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D721DB81BF8;
        Tue, 23 Aug 2022 08:33:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 442FFC433D6;
        Tue, 23 Aug 2022 08:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243598;
        bh=Hz4IDQ1JODRnQj2XRHBXSjJFvRrsRauABgljRV7KOqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t9HnqP0Hh5QUSJWsKFjVhqkgVZe95VhiBMzixt0Q6vYTsyogARRs+ffphbsa+lk3B
         ktkzaZpscqlRCF87H7EJ79OpjlbOPd7LlYqr8TMoHa5uOo6B+ZvF5JLdgwoMqrHYwT
         u2MZYBmtuB/dxKlUpbmB/NHiHL51EHv0GJElzZak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Dooks <ben.dooks@sifive.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 300/365] dmaengine: dw-axi-dmac: ignore interrupt if no descriptor
Date:   Tue, 23 Aug 2022 10:03:21 +0200
Message-Id: <20220823080130.725787493@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



