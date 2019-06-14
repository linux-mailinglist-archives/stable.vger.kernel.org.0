Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB9946B08
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 22:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727755AbfFNUjW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 16:39:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:50466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726393AbfFNU2v (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jun 2019 16:28:51 -0400
Received: from sasha-vm.mshome.net (unknown [131.107.159.134])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05B4421848;
        Fri, 14 Jun 2019 20:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560544131;
        bh=EGJ5b7wgv3N9IuHk6sFXpBIJQl97aOdOMqmObwWV09w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y6t2HJuM+I+Dis0ZYLVJhftx49RhgShdMwPJ6yLg2W2iZb9S2hfstsfIJazHRaVmn
         8m+nqWGDGExnBmKbqk7yWp8YAMp2XSDKlygfY68AbJl8peis0j+BJ5PMyGwKIJMpxh
         97NwiGBqGm2ayKSoca50lznF7n85wEaZ59S18IYk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Long <eric.long@unisoc.com>,
        Baolin Wang <baolin.wang@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 08/59] dmaengine: sprd: Fix the incorrect start for 2-stage destination channels
Date:   Fri, 14 Jun 2019 16:27:52 -0400
Message-Id: <20190614202843.26941-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190614202843.26941-1-sashal@kernel.org>
References: <20190614202843.26941-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Long <eric.long@unisoc.com>

[ Upstream commit 3d626a97f0303e9c30d063434b749de3f0f91fb5 ]

The 2-stage destination channel will be triggered by source channel
automatically, which means we should not trigger it by software request.

Signed-off-by: Eric Long <eric.long@unisoc.com>
Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/sprd-dma.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/sprd-dma.c b/drivers/dma/sprd-dma.c
index 431e289d59a5..0f92e60529d1 100644
--- a/drivers/dma/sprd-dma.c
+++ b/drivers/dma/sprd-dma.c
@@ -510,7 +510,9 @@ static void sprd_dma_start(struct sprd_dma_chn *schan)
 	sprd_dma_set_uid(schan);
 	sprd_dma_enable_chn(schan);
 
-	if (schan->dev_id == SPRD_DMA_SOFTWARE_UID)
+	if (schan->dev_id == SPRD_DMA_SOFTWARE_UID &&
+	    schan->chn_mode != SPRD_DMA_DST_CHN0 &&
+	    schan->chn_mode != SPRD_DMA_DST_CHN1)
 		sprd_dma_soft_request(schan);
 }
 
-- 
2.20.1

