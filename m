Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 096D36E63C9
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231893AbjDRMn0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231927AbjDRMnV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:43:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D2321444D
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:43:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BF1A63354
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:43:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 506D8C433D2;
        Tue, 18 Apr 2023 12:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821791;
        bh=8YUJalr43YpmpfEaz8yWBdBI4sfRtGFKgUpH/UCuEDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EZXCVnh5JB5vC+9idd05wud0Vj5lTnW9iuL4CM+phT+Gfcgrs3QBl1L1DgmPDGWTu
         rYrC/lVihnTvrNWYUg1T2VYt3zgEQGQ5IgcfJxUfxM9OfZnlLvoSbiVW+W2WEWhf5u
         BVpuYepFUiNRRN42sTSpUp91vpgbOmeUnqPm5xHo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Martin=20Povi=C5=A1er?= <povik+lin@cutebit.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 041/134] dmaengine: apple-admac: Handle global interrupt flags
Date:   Tue, 18 Apr 2023 14:21:37 +0200
Message-Id: <20230418120314.370705292@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Povišer <povik+lin@cutebit.org>

[ Upstream commit a288fd158fbf85c06a9ac01cecabf97ac5d962e7 ]

In addition to TX channel and RX channel interrupt flags there's
another class of 'global' interrupt flags with unknown semantics. Those
weren't being handled up to now, and they are the suspected cause of
stuck IRQ states that have been sporadically occurring. Check the global
flags and clear them if raised.

Fixes: b127315d9a78 ("dmaengine: apple-admac: Add Apple ADMAC driver")
Signed-off-by: Martin Povišer <povik+lin@cutebit.org>
Link: https://lore.kernel.org/r/20230224152222.26732-1-povik+lin@cutebit.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/apple-admac.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/apple-admac.c b/drivers/dma/apple-admac.c
index 90f28bda29c8b..00cbfafe0ed9d 100644
--- a/drivers/dma/apple-admac.c
+++ b/drivers/dma/apple-admac.c
@@ -75,6 +75,7 @@
 
 #define REG_TX_INTSTATE(idx)		(0x0030 + (idx) * 4)
 #define REG_RX_INTSTATE(idx)		(0x0040 + (idx) * 4)
+#define REG_GLOBAL_INTSTATE(idx)	(0x0050 + (idx) * 4)
 #define REG_CHAN_INTSTATUS(ch, idx)	(0x8010 + (ch) * 0x200 + (idx) * 4)
 #define REG_CHAN_INTMASK(ch, idx)	(0x8020 + (ch) * 0x200 + (idx) * 4)
 
@@ -672,13 +673,14 @@ static void admac_handle_chan_int(struct admac_data *ad, int no)
 static irqreturn_t admac_interrupt(int irq, void *devid)
 {
 	struct admac_data *ad = devid;
-	u32 rx_intstate, tx_intstate;
+	u32 rx_intstate, tx_intstate, global_intstate;
 	int i;
 
 	rx_intstate = readl_relaxed(ad->base + REG_RX_INTSTATE(ad->irq_index));
 	tx_intstate = readl_relaxed(ad->base + REG_TX_INTSTATE(ad->irq_index));
+	global_intstate = readl_relaxed(ad->base + REG_GLOBAL_INTSTATE(ad->irq_index));
 
-	if (!tx_intstate && !rx_intstate)
+	if (!tx_intstate && !rx_intstate && !global_intstate)
 		return IRQ_NONE;
 
 	for (i = 0; i < ad->nchannels; i += 2) {
@@ -693,6 +695,12 @@ static irqreturn_t admac_interrupt(int irq, void *devid)
 		rx_intstate >>= 1;
 	}
 
+	if (global_intstate) {
+		dev_warn(ad->dev, "clearing unknown global interrupt flag: %x\n",
+			 global_intstate);
+		writel_relaxed(~(u32) 0, ad->base + REG_GLOBAL_INTSTATE(ad->irq_index));
+	}
+
 	return IRQ_HANDLED;
 }
 
-- 
2.39.2



