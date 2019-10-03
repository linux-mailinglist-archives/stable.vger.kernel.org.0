Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEF9CCAD35
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732344AbfJCRg7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 13:36:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:49682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729985AbfJCQEB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:04:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 815B2207FF;
        Thu,  3 Oct 2019 16:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118640;
        bh=iw2RiHJuQkS8MmiAI+Oheb6nqhnVOozxDjGK6U5Lmy8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lhFmFXTRChAt0n0ugtyXDva3bDhHU/nh5Z90VtFvyL5V9GH5HgG40ujRlmfNvVFzo
         Pzf4Y9eJKdDHuKOB1SwNKRZts67juPlXuBM1Cavw/TmzTkrBmV96ir/8EmpN156rJU
         9tPGIz2f6SU5GYoWOq3+iChTfafRenmAYGx1g89Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 085/129] dmaengine: ti: edma: Do not reset reserved paRAM slots
Date:   Thu,  3 Oct 2019 17:53:28 +0200
Message-Id: <20191003154357.581377596@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154318.081116689@linuxfoundation.org>
References: <20191003154318.081116689@linuxfoundation.org>
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
 drivers/dma/edma.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index 57962bff75324..72f31e837b1d5 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -2268,9 +2268,6 @@ static int edma_probe(struct platform_device *pdev)
 
 	ecc->default_queue = info->default_queue;
 
-	for (i = 0; i < ecc->num_slots; i++)
-		edma_write_slot(ecc, i, &dummy_paramset);
-
 	if (info->rsv) {
 		/* Set the reserved slots in inuse list */
 		rsv_slots = info->rsv->rsv_slots;
@@ -2283,6 +2280,12 @@ static int edma_probe(struct platform_device *pdev)
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



