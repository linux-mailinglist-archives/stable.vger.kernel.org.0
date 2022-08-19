Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6E80599FFD
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352493AbiHSQVH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352070AbiHSQTK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:19:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECBB611847D;
        Fri, 19 Aug 2022 09:01:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A7D2616B3;
        Fri, 19 Aug 2022 16:01:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 476C7C433C1;
        Fri, 19 Aug 2022 16:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924861;
        bh=mZdDAXadWmFIttx25Wr5E6+vtakiqgoPmNDTMADLk1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PK51UMTC4KyueqAX06S2EXIGubf38x7Np7bw+DYAx/Hi1LHoJzq7jKj+OCGUH4PcH
         5tKmiuwfT7kJTRbWIHGvJ8t1/X8HAK0ksjNJGbq2FvUqsrxI5TEzXvnq374qkMH7rM
         jfvFUh+aSf5rmu/irKcBkLZFJa/ev4PerDtlFjPc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Austin Kim <austin.kim@lge.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 306/545] dmaengine: sf-pdma: apply proper spinlock flags in sf_pdma_prep_dma_memcpy()
Date:   Fri, 19 Aug 2022 17:41:16 +0200
Message-Id: <20220819153843.043321900@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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

From: Austin Kim <austin.kim@lge.com>

[ Upstream commit 94b4cd7c5fc0dd6858a046b00ca729fb0512b9ba ]

The second parameter of spinlock_irq[save/restore] function is flags,
which is the last input parameter of sf_pdma_prep_dma_memcpy().

So declare local variable 'iflags' to be used as the second parameter of
spinlock_irq[save/restore] function.

Signed-off-by: Austin Kim <austin.kim@lge.com>
Link: https://lore.kernel.org/r/20210611065336.GA1121@raspberrypi
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/sf-pdma/sf-pdma.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/sf-pdma/sf-pdma.c b/drivers/dma/sf-pdma/sf-pdma.c
index 528deb5d9f31..1cd2d7df9715 100644
--- a/drivers/dma/sf-pdma/sf-pdma.c
+++ b/drivers/dma/sf-pdma/sf-pdma.c
@@ -94,6 +94,7 @@ sf_pdma_prep_dma_memcpy(struct dma_chan *dchan,	dma_addr_t dest, dma_addr_t src,
 {
 	struct sf_pdma_chan *chan = to_sf_pdma_chan(dchan);
 	struct sf_pdma_desc *desc;
+	unsigned long iflags;
 
 	if (chan && (!len || !dest || !src)) {
 		dev_err(chan->pdma->dma_dev.dev,
@@ -109,10 +110,10 @@ sf_pdma_prep_dma_memcpy(struct dma_chan *dchan,	dma_addr_t dest, dma_addr_t src,
 	desc->dirn = DMA_MEM_TO_MEM;
 	desc->async_tx = vchan_tx_prep(&chan->vchan, &desc->vdesc, flags);
 
-	spin_lock_irqsave(&chan->vchan.lock, flags);
+	spin_lock_irqsave(&chan->vchan.lock, iflags);
 	chan->desc = desc;
 	sf_pdma_fill_desc(desc, dest, src, len);
-	spin_unlock_irqrestore(&chan->vchan.lock, flags);
+	spin_unlock_irqrestore(&chan->vchan.lock, iflags);
 
 	return desc->async_tx;
 }
-- 
2.35.1



