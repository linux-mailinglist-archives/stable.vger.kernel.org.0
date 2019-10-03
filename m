Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD0F8CA8BD
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403920AbfJCQbw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:31:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:39126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403916AbfJCQbw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:31:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC51C2070B;
        Thu,  3 Oct 2019 16:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120311;
        bh=LHr0zQNTuWMvB8KfJDg2lp4+b/SuKXqID+v+rc6sg8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PIYm7QvoAXK9cderBXH5f0Zm3oPGvSxQmgF+i2ALN6oqEhFrUJV5lmFldxmJU1Dv/
         +9iZDBAS+oMrCkXSbHJSCMwa52XhpCwNfFURDwlyK+K8QgNfXLs1D8dRm3E7lGRmMg
         X7kEi9g6yWruYlBl9P0c9xqxoafaRyV4lOJBxZrU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 176/313] dmaengine: ti: edma: Do not reset reserved paRAM slots
Date:   Thu,  3 Oct 2019 17:52:34 +0200
Message-Id: <20191003154550.329779474@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 drivers/dma/ti/edma.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/ti/edma.c b/drivers/dma/ti/edma.c
index ceabdea40ae0f..982631d4e1f8a 100644
--- a/drivers/dma/ti/edma.c
+++ b/drivers/dma/ti/edma.c
@@ -2273,9 +2273,6 @@ static int edma_probe(struct platform_device *pdev)
 
 	ecc->default_queue = info->default_queue;
 
-	for (i = 0; i < ecc->num_slots; i++)
-		edma_write_slot(ecc, i, &dummy_paramset);
-
 	if (info->rsv) {
 		/* Set the reserved slots in inuse list */
 		rsv_slots = info->rsv->rsv_slots;
@@ -2288,6 +2285,12 @@ static int edma_probe(struct platform_device *pdev)
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



