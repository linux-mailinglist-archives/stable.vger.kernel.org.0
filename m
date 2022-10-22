Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99F3B608AAB
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 11:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231302AbiJVJEV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 05:04:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235090AbiJVJD1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 05:03:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95EE52FACF4;
        Sat, 22 Oct 2022 01:18:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13DA260B39;
        Sat, 22 Oct 2022 08:06:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06459C433D6;
        Sat, 22 Oct 2022 08:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666426006;
        bh=M+GQYKj7W9Q9eqQVTrqZvdk+oerpuJZZbVXvQ6MtdVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hFZI1nF9mVHWZOEz8hQ2MZcejhXv/TpTeQte8aGQDMH0uycwmr+fG77wlX/YJTYIA
         BFRxYtn+x7kYh5y9gd4jJuypJSUuM57u+L+z1OSJajDp9F2OwxNSApn76ht/zxwwDP
         hDmoCo9iczHC54QvgS9H5lcW3vq9rtIeMDKQsOIA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vaishnav Achath <vaishnav.a@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 658/717] dmaengine: ti: k3-udma: Reset UDMA_CHAN_RT byte counters to prevent overflow
Date:   Sat, 22 Oct 2022 09:28:57 +0200
Message-Id: <20221022072527.497849815@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 2f0d2c68c93c..fcfcde947b30 100644
--- a/drivers/dma/ti/k3-udma.c
+++ b/drivers/dma/ti/k3-udma.c
@@ -300,8 +300,6 @@ struct udma_chan {
 
 	struct udma_tx_drain tx_drain;
 
-	u32 bcnt; /* number of bytes completed since the start of the channel */
-
 	/* Channel configuration parameters */
 	struct udma_chan_config config;
 
@@ -757,6 +755,20 @@ static void udma_reset_rings(struct udma_chan *uc)
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
@@ -790,8 +802,6 @@ static void udma_reset_counters(struct udma_chan *uc)
 		val = udma_rchanrt_read(uc, UDMA_CHAN_RT_PEER_BCNT_REG);
 		udma_rchanrt_write(uc, UDMA_CHAN_RT_PEER_BCNT_REG, val);
 	}
-
-	uc->bcnt = 0;
 }
 
 static int udma_reset_chan(struct udma_chan *uc, bool hard)
@@ -1115,7 +1125,7 @@ static void udma_check_tx_completion(struct work_struct *work)
 		if (uc->desc) {
 			struct udma_desc *d = uc->desc;
 
-			uc->bcnt += d->residue;
+			udma_decrement_byte_counters(uc, d->residue);
 			udma_start(uc);
 			vchan_cookie_complete(&d->vd);
 			break;
@@ -1168,7 +1178,7 @@ static irqreturn_t udma_ring_irq_handler(int irq, void *data)
 				vchan_cyclic_callback(&d->vd);
 			} else {
 				if (udma_is_desc_really_done(uc, d)) {
-					uc->bcnt += d->residue;
+					udma_decrement_byte_counters(uc, d->residue);
 					udma_start(uc);
 					vchan_cookie_complete(&d->vd);
 				} else {
@@ -1204,7 +1214,7 @@ static irqreturn_t udma_udma_irq_handler(int irq, void *data)
 			vchan_cyclic_callback(&d->vd);
 		} else {
 			/* TODO: figure out the real amount of data */
-			uc->bcnt += d->residue;
+			udma_decrement_byte_counters(uc, d->residue);
 			udma_start(uc);
 			vchan_cookie_complete(&d->vd);
 		}
@@ -3809,7 +3819,6 @@ static enum dma_status udma_tx_status(struct dma_chan *chan,
 			bcnt = udma_tchanrt_read(uc, UDMA_CHAN_RT_BCNT_REG);
 		}
 
-		bcnt -= uc->bcnt;
 		if (bcnt && !(bcnt % uc->desc->residue))
 			residue = 0;
 		else
-- 
2.35.1



