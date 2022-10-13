Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3D15FD045
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbiJMAZU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbiJMAYW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:24:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A63B4A285F;
        Wed, 12 Oct 2022 17:23:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3296C616F8;
        Thu, 13 Oct 2022 00:23:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD1CFC4347C;
        Thu, 13 Oct 2022 00:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620630;
        bh=opJ560Mld8QhWmSSOPieqs+ADj6zk6rs1gncd2h+GPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V+x1/iPkVPE/7Svhfsvm32DXbL7yhmzPUNqO3i5jlAyD0fV6qEwZlrFn2LVomMRFu
         i/khNVTqE4OvjJbjXI39w+Ax8V50ssVkjoxPDijB4TNw5fqb6RvKSo36imrb+eBqJ5
         ECSvn7zXyp7ZzP4UQVrg9zg+0y74MuLMSKybu7zYmngpjazplCsNEHphGWHa8RX4+d
         NAkqQGBjeJTjIwgGPXmrSBcl19PwQY/lCS4hRDhbS5rVI1bR/yBYSFVjQu3FuS8QZx
         5+biXl+xjrp/+A/YHdA8OXY5YGzgqkQfnhpnZuhQ2er9YG2xjBgCycrwYx439hWF5r
         1ckE226raTHLA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vaishnav Achath <vaishnav.a@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 06/33] dmaengine: ti: k3-udma: Reset UDMA_CHAN_RT byte counters to prevent overflow
Date:   Wed, 12 Oct 2022 20:23:05 -0400
Message-Id: <20221013002334.1894749-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013002334.1894749-1-sashal@kernel.org>
References: <20221013002334.1894749-1-sashal@kernel.org>
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

From: Vaishnav Achath <vaishnav.a@ti.com>

[ Upstream commit 7c94dcfa8fcff2dba53915f1dabfee49a3df8b88 ]

UDMA_CHAN_RT_*BCNT_REG stores the real-time channel bytecount statistics.
These registers are 32-bit hardware counters and the driver uses these
counters to monitor the operational progress status for a channel, when
transferring more than 4GB of data it was observed that these counters
overflow and completion calculation of a operation gets affected and the
transfer hangs indefinitely.

This commit adds changes to decrease the byte count for every complete
transaction so that these registers never overflow and the proper byte
count statistics is maintained for ongoing transaction by the RT counters.

Earlier uc->bcnt used to maintain a count of the completed bytes at driver
side, since the RT counters maintain the statistics of current transaction
now, the maintenance of uc->bcnt is not necessary.

Signed-off-by: Vaishnav Achath <vaishnav.a@ti.com>
Acked-by: Peter Ujfalusi <peter.ujfalusi@gmail.com>
Link: https://lore.kernel.org/r/20220802054835.19482-1-vaishnav.a@ti.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ti/k3-udma.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/dma/ti/k3-udma.c b/drivers/dma/ti/k3-udma.c
index d3902784cae2..eacc4377e4a0 100644
--- a/drivers/dma/ti/k3-udma.c
+++ b/drivers/dma/ti/k3-udma.c
@@ -235,8 +235,6 @@ struct udma_chan {
 
 	struct udma_tx_drain tx_drain;
 
-	u32 bcnt; /* number of bytes completed since the start of the channel */
-
 	/* Channel configuration parameters */
 	struct udma_chan_config config;
 
@@ -656,6 +654,20 @@ static void udma_reset_rings(struct udma_chan *uc)
 	}
 }
 
+static void udma_decrement_byte_counters(struct udma_chan *uc, u32 val)
+{
+	if (uc->desc->dir == DMA_DEV_TO_MEM) {
+		udma_rchanrt_write(uc, UDMA_CHAN_RT_BCNT_REG, val);
+		udma_rchanrt_write(uc, UDMA_CHAN_RT_SBCNT_REG, val);
+		udma_rchanrt_write(uc, UDMA_CHAN_RT_PEER_BCNT_REG, val);
+	} else {
+		udma_tchanrt_write(uc, UDMA_CHAN_RT_BCNT_REG, val);
+		udma_tchanrt_write(uc, UDMA_CHAN_RT_SBCNT_REG, val);
+		if (!uc->bchan)
+			udma_tchanrt_write(uc, UDMA_CHAN_RT_PEER_BCNT_REG, val);
+	}
+}
+
 static void udma_reset_counters(struct udma_chan *uc)
 {
 	u32 val;
@@ -687,8 +699,6 @@ static void udma_reset_counters(struct udma_chan *uc)
 		val = udma_rchanrt_read(uc, UDMA_CHAN_RT_PEER_BCNT_REG);
 		udma_rchanrt_write(uc, UDMA_CHAN_RT_PEER_BCNT_REG, val);
 	}
-
-	uc->bcnt = 0;
 }
 
 static int udma_reset_chan(struct udma_chan *uc, bool hard)
@@ -1006,7 +1016,7 @@ static void udma_check_tx_completion(struct work_struct *work)
 		if (uc->desc) {
 			struct udma_desc *d = uc->desc;
 
-			uc->bcnt += d->residue;
+			udma_decrement_byte_counters(uc, d->residue);
 			udma_start(uc);
 			vchan_cookie_complete(&d->vd);
 			break;
@@ -1060,7 +1070,7 @@ static irqreturn_t udma_ring_irq_handler(int irq, void *data)
 				vchan_cyclic_callback(&d->vd);
 			} else {
 				if (udma_is_desc_really_done(uc, d)) {
-					uc->bcnt += d->residue;
+					udma_decrement_byte_counters(uc, d->residue);
 					udma_start(uc);
 					vchan_cookie_complete(&d->vd);
 				} else {
@@ -1097,7 +1107,7 @@ static irqreturn_t udma_udma_irq_handler(int irq, void *data)
 			vchan_cyclic_callback(&d->vd);
 		} else {
 			/* TODO: figure out the real amount of data */
-			uc->bcnt += d->residue;
+			udma_decrement_byte_counters(uc, d->residue);
 			udma_start(uc);
 			vchan_cookie_complete(&d->vd);
 		}
@@ -2741,7 +2751,6 @@ static enum dma_status udma_tx_status(struct dma_chan *chan,
 			bcnt = udma_tchanrt_read(uc, UDMA_CHAN_RT_BCNT_REG);
 		}
 
-		bcnt -= uc->bcnt;
 		if (bcnt && !(bcnt % uc->desc->residue))
 			residue = 0;
 		else
-- 
2.35.1

