Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 869EB47B71E
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 02:58:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232372AbhLUB6M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 20:58:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53128 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232285AbhLUB6L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 20:58:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CCAD6135A;
        Tue, 21 Dec 2021 01:58:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F4BBC36AEC;
        Tue, 21 Dec 2021 01:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640051889;
        bh=KPVOu2AWP/ZP+N90LND8m1+C1rNv2jCenSaaArn28R4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qu/+hgG7WwM3/6UZxUUdVy9IihTuWaygJOiMnXA/jj2eVm/jlfOfN9TiLNt+8D+kD
         /KublgD5cgCCTk4lH7cIZC5CKHbFhzHWzrb9CfPutedRujGfQ0V7Ts60sUQAQgk8ah
         99lxmUdnVtxjkj9+XIAITlmC4W6PsNscU/ZCqF/VIXD97JLWGZJZRMKYKOdu7Bdh7X
         dvBG+6L8nBE/RgmB1MkixAcBJtuN8Kclz7PhdpszIazyNHMtzlEjilN2YgnPNqPA/X
         QgT0BVVEXEIbNc6PNiKhVIxlYncpv8W0fl8ANS24HuwluCo4u2DvUeVkVpCvYXgAQp
         osllL3+YMZioA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vignesh Raghavendra <vigneshr@ti.com>, Nishanth Menon <nm@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 11/29] dmaengine: ti: k3-udma: Fix smatch warnings
Date:   Mon, 20 Dec 2021 20:57:32 -0500
Message-Id: <20211221015751.116328-11-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211221015751.116328-1-sashal@kernel.org>
References: <20211221015751.116328-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vignesh Raghavendra <vigneshr@ti.com>

[ Upstream commit 80936d68665be88dc3bf60884a71f2694eb6b1f1 ]

Smatch reports below warnings [1] wrt dereferencing rm_res when it can
potentially be ERR_PTR(). This is possible when entire range is
allocated to Linux
Fix this case by making sure, there is no deference of rm_res when its
ERR_PTR().

[1]:
 drivers/dma/ti/k3-udma.c:4524 udma_setup_resources() error: 'rm_res' dereferencing possible ERR_PTR()
 drivers/dma/ti/k3-udma.c:4537 udma_setup_resources() error: 'rm_res' dereferencing possible ERR_PTR()
 drivers/dma/ti/k3-udma.c:4681 bcdma_setup_resources() error: 'rm_res' dereferencing possible ERR_PTR()
 drivers/dma/ti/k3-udma.c:4696 bcdma_setup_resources() error: 'rm_res' dereferencing possible ERR_PTR()
 drivers/dma/ti/k3-udma.c:4711 bcdma_setup_resources() error: 'rm_res' dereferencing possible ERR_PTR()
 drivers/dma/ti/k3-udma.c:4848 pktdma_setup_resources() error: 'rm_res' dereferencing possible ERR_PTR()
 drivers/dma/ti/k3-udma.c:4861 pktdma_setup_resources() error: 'rm_res' dereferencing possible ERR_PTR()

Reported-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Acked-by: Peter Ujfalusi <peter.ujfalusi@gmail.com>
Link: https://lore.kernel.org/r/20211209180957.29036-1-vigneshr@ti.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ti/k3-udma.c | 157 ++++++++++++++++++++++++++-------------
 1 file changed, 107 insertions(+), 50 deletions(-)

diff --git a/drivers/dma/ti/k3-udma.c b/drivers/dma/ti/k3-udma.c
index 041d8e32d6300..6e56d1cef5eee 100644
--- a/drivers/dma/ti/k3-udma.c
+++ b/drivers/dma/ti/k3-udma.c
@@ -4534,45 +4534,60 @@ static int udma_setup_resources(struct udma_dev *ud)
 	rm_res = tisci_rm->rm_ranges[RM_RANGE_TCHAN];
 	if (IS_ERR(rm_res)) {
 		bitmap_zero(ud->tchan_map, ud->tchan_cnt);
+		irq_res.sets = 1;
 	} else {
 		bitmap_fill(ud->tchan_map, ud->tchan_cnt);
 		for (i = 0; i < rm_res->sets; i++)
 			udma_mark_resource_ranges(ud, ud->tchan_map,
 						  &rm_res->desc[i], "tchan");
+		irq_res.sets = rm_res->sets;
 	}
-	irq_res.sets = rm_res->sets;
 
 	/* rchan and matching default flow ranges */
 	rm_res = tisci_rm->rm_ranges[RM_RANGE_RCHAN];
 	if (IS_ERR(rm_res)) {
 		bitmap_zero(ud->rchan_map, ud->rchan_cnt);
+		irq_res.sets++;
 	} else {
 		bitmap_fill(ud->rchan_map, ud->rchan_cnt);
 		for (i = 0; i < rm_res->sets; i++)
 			udma_mark_resource_ranges(ud, ud->rchan_map,
 						  &rm_res->desc[i], "rchan");
+		irq_res.sets += rm_res->sets;
 	}
 
-	irq_res.sets += rm_res->sets;
 	irq_res.desc = kcalloc(irq_res.sets, sizeof(*irq_res.desc), GFP_KERNEL);
+	if (!irq_res.desc)
+		return -ENOMEM;
 	rm_res = tisci_rm->rm_ranges[RM_RANGE_TCHAN];
-	for (i = 0; i < rm_res->sets; i++) {
-		irq_res.desc[i].start = rm_res->desc[i].start;
-		irq_res.desc[i].num = rm_res->desc[i].num;
-		irq_res.desc[i].start_sec = rm_res->desc[i].start_sec;
-		irq_res.desc[i].num_sec = rm_res->desc[i].num_sec;
+	if (IS_ERR(rm_res)) {
+		irq_res.desc[0].start = 0;
+		irq_res.desc[0].num = ud->tchan_cnt;
+		i = 1;
+	} else {
+		for (i = 0; i < rm_res->sets; i++) {
+			irq_res.desc[i].start = rm_res->desc[i].start;
+			irq_res.desc[i].num = rm_res->desc[i].num;
+			irq_res.desc[i].start_sec = rm_res->desc[i].start_sec;
+			irq_res.desc[i].num_sec = rm_res->desc[i].num_sec;
+		}
 	}
 	rm_res = tisci_rm->rm_ranges[RM_RANGE_RCHAN];
-	for (j = 0; j < rm_res->sets; j++, i++) {
-		if (rm_res->desc[j].num) {
-			irq_res.desc[i].start = rm_res->desc[j].start +
-					ud->soc_data->oes.udma_rchan;
-			irq_res.desc[i].num = rm_res->desc[j].num;
-		}
-		if (rm_res->desc[j].num_sec) {
-			irq_res.desc[i].start_sec = rm_res->desc[j].start_sec +
-					ud->soc_data->oes.udma_rchan;
-			irq_res.desc[i].num_sec = rm_res->desc[j].num_sec;
+	if (IS_ERR(rm_res)) {
+		irq_res.desc[i].start = 0;
+		irq_res.desc[i].num = ud->rchan_cnt;
+	} else {
+		for (j = 0; j < rm_res->sets; j++, i++) {
+			if (rm_res->desc[j].num) {
+				irq_res.desc[i].start = rm_res->desc[j].start +
+						ud->soc_data->oes.udma_rchan;
+				irq_res.desc[i].num = rm_res->desc[j].num;
+			}
+			if (rm_res->desc[j].num_sec) {
+				irq_res.desc[i].start_sec = rm_res->desc[j].start_sec +
+						ud->soc_data->oes.udma_rchan;
+				irq_res.desc[i].num_sec = rm_res->desc[j].num_sec;
+			}
 		}
 	}
 	ret = ti_sci_inta_msi_domain_alloc_irqs(ud->dev, &irq_res);
@@ -4690,14 +4705,15 @@ static int bcdma_setup_resources(struct udma_dev *ud)
 		rm_res = tisci_rm->rm_ranges[RM_RANGE_BCHAN];
 		if (IS_ERR(rm_res)) {
 			bitmap_zero(ud->bchan_map, ud->bchan_cnt);
+			irq_res.sets++;
 		} else {
 			bitmap_fill(ud->bchan_map, ud->bchan_cnt);
 			for (i = 0; i < rm_res->sets; i++)
 				udma_mark_resource_ranges(ud, ud->bchan_map,
 							  &rm_res->desc[i],
 							  "bchan");
+			irq_res.sets += rm_res->sets;
 		}
-		irq_res.sets += rm_res->sets;
 	}
 
 	/* tchan ranges */
@@ -4705,14 +4721,15 @@ static int bcdma_setup_resources(struct udma_dev *ud)
 		rm_res = tisci_rm->rm_ranges[RM_RANGE_TCHAN];
 		if (IS_ERR(rm_res)) {
 			bitmap_zero(ud->tchan_map, ud->tchan_cnt);
+			irq_res.sets += 2;
 		} else {
 			bitmap_fill(ud->tchan_map, ud->tchan_cnt);
 			for (i = 0; i < rm_res->sets; i++)
 				udma_mark_resource_ranges(ud, ud->tchan_map,
 							  &rm_res->desc[i],
 							  "tchan");
+			irq_res.sets += rm_res->sets * 2;
 		}
-		irq_res.sets += rm_res->sets * 2;
 	}
 
 	/* rchan ranges */
@@ -4720,47 +4737,72 @@ static int bcdma_setup_resources(struct udma_dev *ud)
 		rm_res = tisci_rm->rm_ranges[RM_RANGE_RCHAN];
 		if (IS_ERR(rm_res)) {
 			bitmap_zero(ud->rchan_map, ud->rchan_cnt);
+			irq_res.sets += 2;
 		} else {
 			bitmap_fill(ud->rchan_map, ud->rchan_cnt);
 			for (i = 0; i < rm_res->sets; i++)
 				udma_mark_resource_ranges(ud, ud->rchan_map,
 							  &rm_res->desc[i],
 							  "rchan");
+			irq_res.sets += rm_res->sets * 2;
 		}
-		irq_res.sets += rm_res->sets * 2;
 	}
 
 	irq_res.desc = kcalloc(irq_res.sets, sizeof(*irq_res.desc), GFP_KERNEL);
+	if (!irq_res.desc)
+		return -ENOMEM;
 	if (ud->bchan_cnt) {
 		rm_res = tisci_rm->rm_ranges[RM_RANGE_BCHAN];
-		for (i = 0; i < rm_res->sets; i++) {
-			irq_res.desc[i].start = rm_res->desc[i].start +
-						oes->bcdma_bchan_ring;
-			irq_res.desc[i].num = rm_res->desc[i].num;
+		if (IS_ERR(rm_res)) {
+			irq_res.desc[0].start = oes->bcdma_bchan_ring;
+			irq_res.desc[0].num = ud->bchan_cnt;
+			i = 1;
+		} else {
+			for (i = 0; i < rm_res->sets; i++) {
+				irq_res.desc[i].start = rm_res->desc[i].start +
+							oes->bcdma_bchan_ring;
+				irq_res.desc[i].num = rm_res->desc[i].num;
+			}
 		}
 	}
 	if (ud->tchan_cnt) {
 		rm_res = tisci_rm->rm_ranges[RM_RANGE_TCHAN];
-		for (j = 0; j < rm_res->sets; j++, i += 2) {
-			irq_res.desc[i].start = rm_res->desc[j].start +
-						oes->bcdma_tchan_data;
-			irq_res.desc[i].num = rm_res->desc[j].num;
-
-			irq_res.desc[i + 1].start = rm_res->desc[j].start +
-						oes->bcdma_tchan_ring;
-			irq_res.desc[i + 1].num = rm_res->desc[j].num;
+		if (IS_ERR(rm_res)) {
+			irq_res.desc[i].start = oes->bcdma_tchan_data;
+			irq_res.desc[i].num = ud->tchan_cnt;
+			irq_res.desc[i + 1].start = oes->bcdma_tchan_ring;
+			irq_res.desc[i + 1].num = ud->tchan_cnt;
+			i += 2;
+		} else {
+			for (j = 0; j < rm_res->sets; j++, i += 2) {
+				irq_res.desc[i].start = rm_res->desc[j].start +
+							oes->bcdma_tchan_data;
+				irq_res.desc[i].num = rm_res->desc[j].num;
+
+				irq_res.desc[i + 1].start = rm_res->desc[j].start +
+							oes->bcdma_tchan_ring;
+				irq_res.desc[i + 1].num = rm_res->desc[j].num;
+			}
 		}
 	}
 	if (ud->rchan_cnt) {
 		rm_res = tisci_rm->rm_ranges[RM_RANGE_RCHAN];
-		for (j = 0; j < rm_res->sets; j++, i += 2) {
-			irq_res.desc[i].start = rm_res->desc[j].start +
-						oes->bcdma_rchan_data;
-			irq_res.desc[i].num = rm_res->desc[j].num;
-
-			irq_res.desc[i + 1].start = rm_res->desc[j].start +
-						oes->bcdma_rchan_ring;
-			irq_res.desc[i + 1].num = rm_res->desc[j].num;
+		if (IS_ERR(rm_res)) {
+			irq_res.desc[i].start = oes->bcdma_rchan_data;
+			irq_res.desc[i].num = ud->rchan_cnt;
+			irq_res.desc[i + 1].start = oes->bcdma_rchan_ring;
+			irq_res.desc[i + 1].num = ud->rchan_cnt;
+			i += 2;
+		} else {
+			for (j = 0; j < rm_res->sets; j++, i += 2) {
+				irq_res.desc[i].start = rm_res->desc[j].start +
+							oes->bcdma_rchan_data;
+				irq_res.desc[i].num = rm_res->desc[j].num;
+
+				irq_res.desc[i + 1].start = rm_res->desc[j].start +
+							oes->bcdma_rchan_ring;
+				irq_res.desc[i + 1].num = rm_res->desc[j].num;
+			}
 		}
 	}
 
@@ -4858,39 +4900,54 @@ static int pktdma_setup_resources(struct udma_dev *ud)
 	if (IS_ERR(rm_res)) {
 		/* all rflows are assigned exclusively to Linux */
 		bitmap_zero(ud->rflow_in_use, ud->rflow_cnt);
+		irq_res.sets = 1;
 	} else {
 		bitmap_fill(ud->rflow_in_use, ud->rflow_cnt);
 		for (i = 0; i < rm_res->sets; i++)
 			udma_mark_resource_ranges(ud, ud->rflow_in_use,
 						  &rm_res->desc[i], "rflow");
+		irq_res.sets = rm_res->sets;
 	}
-	irq_res.sets = rm_res->sets;
 
 	/* tflow ranges */
 	rm_res = tisci_rm->rm_ranges[RM_RANGE_TFLOW];
 	if (IS_ERR(rm_res)) {
 		/* all tflows are assigned exclusively to Linux */
 		bitmap_zero(ud->tflow_map, ud->tflow_cnt);
+		irq_res.sets++;
 	} else {
 		bitmap_fill(ud->tflow_map, ud->tflow_cnt);
 		for (i = 0; i < rm_res->sets; i++)
 			udma_mark_resource_ranges(ud, ud->tflow_map,
 						  &rm_res->desc[i], "tflow");
+		irq_res.sets += rm_res->sets;
 	}
-	irq_res.sets += rm_res->sets;
 
 	irq_res.desc = kcalloc(irq_res.sets, sizeof(*irq_res.desc), GFP_KERNEL);
+	if (!irq_res.desc)
+		return -ENOMEM;
 	rm_res = tisci_rm->rm_ranges[RM_RANGE_TFLOW];
-	for (i = 0; i < rm_res->sets; i++) {
-		irq_res.desc[i].start = rm_res->desc[i].start +
-					oes->pktdma_tchan_flow;
-		irq_res.desc[i].num = rm_res->desc[i].num;
+	if (IS_ERR(rm_res)) {
+		irq_res.desc[0].start = oes->pktdma_tchan_flow;
+		irq_res.desc[0].num = ud->tflow_cnt;
+		i = 1;
+	} else {
+		for (i = 0; i < rm_res->sets; i++) {
+			irq_res.desc[i].start = rm_res->desc[i].start +
+						oes->pktdma_tchan_flow;
+			irq_res.desc[i].num = rm_res->desc[i].num;
+		}
 	}
 	rm_res = tisci_rm->rm_ranges[RM_RANGE_RFLOW];
-	for (j = 0; j < rm_res->sets; j++, i++) {
-		irq_res.desc[i].start = rm_res->desc[j].start +
-					oes->pktdma_rchan_flow;
-		irq_res.desc[i].num = rm_res->desc[j].num;
+	if (IS_ERR(rm_res)) {
+		irq_res.desc[i].start = oes->pktdma_rchan_flow;
+		irq_res.desc[i].num = ud->rflow_cnt;
+	} else {
+		for (j = 0; j < rm_res->sets; j++, i++) {
+			irq_res.desc[i].start = rm_res->desc[j].start +
+						oes->pktdma_rchan_flow;
+			irq_res.desc[i].num = rm_res->desc[j].num;
+		}
 	}
 	ret = ti_sci_inta_msi_domain_alloc_irqs(ud->dev, &irq_res);
 	kfree(irq_res.desc);
-- 
2.34.1

