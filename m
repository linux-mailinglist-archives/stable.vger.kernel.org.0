Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95C1B681112
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237172AbjA3OKA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:10:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237184AbjA3OJ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:09:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A1CA3B658
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:09:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96EDD6108A
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:09:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98F6BC4339C;
        Mon, 30 Jan 2023 14:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087792;
        bh=U72pPCZV2lrwQaUZXzcx+/mAkHFkSN3oaE0EcKSMo4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=llY7lDgKc29p6A3SWy4WBze663rbR3B7gO2bah/5+XWqjkFMgRyW59mXmV31OJvDy
         OxKC0qOL+8MkLUsQNezqqdlNr80BJNfB01RRSNb0fVwJi4XlEjk4OL/ZEwjmU1vXWB
         83OAg219Z0ZdWQHrkgcUXYWuz0Fe/NyoCx1NzmH4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jayesh Choudhary <j-choudhary@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 004/204] dmaengine: ti: k3-udma: Do conditional decrement of UDMA_CHAN_RT_PEER_BCNT_REG
Date:   Mon, 30 Jan 2023 14:49:29 +0100
Message-Id: <20230130134316.509649230@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jayesh Choudhary <j-choudhary@ti.com>

[ Upstream commit efab25894a41a920d9581183741e7fadba00719c ]

PSIL_EP_NATIVE endpoints may not have PEER registers for BCNT and thus
udma_decrement_byte_counters() should not try to decrement these counters.
This fixes the issue of crypto IPERF testing where the client side (EVM)
hangs without transfer of packets to the server side, seen since this
function was added.

Fixes: 7c94dcfa8fcf ("dmaengine: ti: k3-udma: Reset UDMA_CHAN_RT byte counters to prevent overflow")
Signed-off-by: Jayesh Choudhary <j-choudhary@ti.com>
Acked-by: Peter Ujfalusi <peter.ujfalusi@gmail.com>
Link: https://lore.kernel.org/r/20221128085005.489964-1-j-choudhary@ti.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ti/k3-udma.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/ti/k3-udma.c b/drivers/dma/ti/k3-udma.c
index 75f2a0006c73..d796e50dfe99 100644
--- a/drivers/dma/ti/k3-udma.c
+++ b/drivers/dma/ti/k3-udma.c
@@ -760,11 +760,12 @@ static void udma_decrement_byte_counters(struct udma_chan *uc, u32 val)
 	if (uc->desc->dir == DMA_DEV_TO_MEM) {
 		udma_rchanrt_write(uc, UDMA_CHAN_RT_BCNT_REG, val);
 		udma_rchanrt_write(uc, UDMA_CHAN_RT_SBCNT_REG, val);
-		udma_rchanrt_write(uc, UDMA_CHAN_RT_PEER_BCNT_REG, val);
+		if (uc->config.ep_type != PSIL_EP_NATIVE)
+			udma_rchanrt_write(uc, UDMA_CHAN_RT_PEER_BCNT_REG, val);
 	} else {
 		udma_tchanrt_write(uc, UDMA_CHAN_RT_BCNT_REG, val);
 		udma_tchanrt_write(uc, UDMA_CHAN_RT_SBCNT_REG, val);
-		if (!uc->bchan)
+		if (!uc->bchan && uc->config.ep_type != PSIL_EP_NATIVE)
 			udma_tchanrt_write(uc, UDMA_CHAN_RT_PEER_BCNT_REG, val);
 	}
 }
-- 
2.39.0



