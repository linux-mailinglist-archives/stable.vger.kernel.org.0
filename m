Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EED83BA869
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728542AbfIVTDZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:03:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:38294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395345AbfIVTB6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 15:01:58 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 091212070C;
        Sun, 22 Sep 2019 19:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178917;
        bh=n5gj2Hdae2Hdoc1sUt7oWb1wv6BAKbPyC4gdc9lKEK0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ucrm8CrR48KGqv7pJjY29Zj+M/o4t4MvcbE2siWHfBK38iWDBA87f/zje+PB5BuJr
         TGDUk1Ip7mVwGlJrwvqCE4w+lQ0XVZJesOfeQ2LY/GZXG79nxbSW0fa0K/i/aKrckW
         pGmFmSutzStteuObAi0eZ1oD8LBCROR96Ld12wvI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 35/44] dmaengine: ti: edma: Do not reset reserved paRAM slots
Date:   Sun, 22 Sep 2019 15:00:53 -0400
Message-Id: <20190922190103.4906-35-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922190103.4906-1-sashal@kernel.org>
References: <20190922190103.4906-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Ujfalusi <peter.ujfalusi@ti.com>

[ Upstream commit c5dbe60664b3660f5ac5854e21273ea2e7ff698f ]

Skip resetting paRAM slots marked as reserved as they might be used by
other cores.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Link: https://lore.kernel.org/r/20190823125618.8133-2-peter.ujfalusi@ti.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/edma.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index 85674a8d04368..e508c8c5f3fde 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -2218,9 +2218,6 @@ static int edma_probe(struct platform_device *pdev)
 
 	ecc->default_queue = info->default_queue;
 
-	for (i = 0; i < ecc->num_slots; i++)
-		edma_write_slot(ecc, i, &dummy_paramset);
-
 	if (info->rsv) {
 		/* Set the reserved slots in inuse list */
 		rsv_slots = info->rsv->rsv_slots;
@@ -2233,6 +2230,12 @@ static int edma_probe(struct platform_device *pdev)
 		}
 	}
 
+	for (i = 0; i < ecc->num_slots; i++) {
+		/* Reset only unused - not reserved - paRAM slots */
+		if (!test_bit(i, ecc->slot_inuse))
+			edma_write_slot(ecc, i, &dummy_paramset);
+	}
+
 	/* Clear the xbar mapped channels in unused list */
 	xbar_chans = info->xbar_chans;
 	if (xbar_chans) {
-- 
2.20.1

