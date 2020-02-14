Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0EE15EE96
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:41:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389702AbgBNQDh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:03:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:50946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389697AbgBNQDh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:03:37 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E84B52082F;
        Fri, 14 Feb 2020 16:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696216;
        bh=WuG/B6lmBEnh3GUKDiqWFqR3zitCFb14UJnbGdNR6mY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BkFOzB6hZAlLBqKg2uWvbLleEtoAy6M8wQAmuyYqfsNig30v2bvRxSMmE657Ehh5+
         09v68FqzPUaTB7/zoxRphtAy7pz5PoYy3KlH0124DG8y+rmeU4UN4/fawBYOLUHZ59
         eN2h67XwlKoK5rWGG2+UZpy8CEELcgFNHiLr2ueo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chen Zhou <chenzhou10@huawei.com>, Peng Ma <peng.ma@nxp.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 080/459] dmaengine: fsl-qdma: fix duplicated argument to &&
Date:   Fri, 14 Feb 2020 10:55:30 -0500
Message-Id: <20200214160149.11681-80-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Zhou <chenzhou10@huawei.com>

[ Upstream commit 4b048178854da11656596d36a107577d66fd1e08 ]

There is duplicated argument to && in function fsl_qdma_free_chan_resources,
which looks like a typo, pointer fsl_queue->desc_pool also needs NULL check,
fix it.
Detected with coccinelle.

Fixes: b092529e0aa0 ("dmaengine: fsl-qdma: Add qDMA controller driver for Layerscape SoCs")
Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
Reviewed-by: Peng Ma <peng.ma@nxp.com>
Tested-by: Peng Ma <peng.ma@nxp.com>
Link: https://lore.kernel.org/r/20200120125843.34398-1-chenzhou10@huawei.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/fsl-qdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/fsl-qdma.c b/drivers/dma/fsl-qdma.c
index 89792083d62c5..95cc0256b3878 100644
--- a/drivers/dma/fsl-qdma.c
+++ b/drivers/dma/fsl-qdma.c
@@ -304,7 +304,7 @@ static void fsl_qdma_free_chan_resources(struct dma_chan *chan)
 
 	vchan_dma_desc_free_list(&fsl_chan->vchan, &head);
 
-	if (!fsl_queue->comp_pool && !fsl_queue->comp_pool)
+	if (!fsl_queue->comp_pool && !fsl_queue->desc_pool)
 		return;
 
 	list_for_each_entry_safe(comp_temp, _comp_temp,
-- 
2.20.1

