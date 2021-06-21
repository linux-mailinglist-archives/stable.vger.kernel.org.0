Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4870C3AF365
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 19:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233728AbhFUSA4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 14:00:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:39160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233243AbhFUR6z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 13:58:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BEC461360;
        Mon, 21 Jun 2021 17:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624298055;
        bh=0EfZd7DYiKHVWO3GhjofK8wxYjHRVA4dvSvIY09L6tw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b/oBD4F7tgD1nC+gKISEpAIguh8dmTc5/SgdEI2Z1b5ujYx9v4S3uUV9MeEbBDZ7M
         1Sr5KpNyD7rq0/mRMR3YGk5I6tYZAE6XpJZd9bqJddZtm+FRNqfyBZ3g4xqjp1NXRn
         LclnbA9ZSiD8jNI3K0GvmkP21Z2U1Ogo3it5EGN86K24KooKDTO1UQpLAlSxJ6sKpp
         5UPzWpNRMdHRteiLB2198cWLkpsIGk+Ra1ip5BXGBpRp82m43RrOvyMRHtMRw4L5Wh
         wp6zhUcC627Jq/esb3lFl3uwCTITHqg4vREv8Cx0I4HpbWm/JEYw/A+yIS+bo/lkgo
         zGVssskaYdEoA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guillaume Ranquet <granquet@baylibre.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 08/26] dmaengine: mediatek: use GFP_NOWAIT instead of GFP_ATOMIC in prep_dma
Date:   Mon, 21 Jun 2021 13:53:41 -0400
Message-Id: <20210621175400.735800-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175400.735800-1-sashal@kernel.org>
References: <20210621175400.735800-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Ranquet <granquet@baylibre.com>

[ Upstream commit 9041575348b21ade1fb74d790f1aac85d68198c7 ]

As recommended by the doc in:
Documentation/drivers-api/dmaengine/provider.rst

Use GFP_NOWAIT to not deplete the emergency pool.

Signed-off-by: Guillaume Ranquet <granquet@baylibre.com>

Link: https://lore.kernel.org/r/20210513192642.29446-4-granquet@baylibre.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/mediatek/mtk-uart-apdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/mediatek/mtk-uart-apdma.c b/drivers/dma/mediatek/mtk-uart-apdma.c
index e420e9f72b3d..9c0ea13ca788 100644
--- a/drivers/dma/mediatek/mtk-uart-apdma.c
+++ b/drivers/dma/mediatek/mtk-uart-apdma.c
@@ -349,7 +349,7 @@ static struct dma_async_tx_descriptor *mtk_uart_apdma_prep_slave_sg
 		return NULL;
 
 	/* Now allocate and setup the descriptor */
-	d = kzalloc(sizeof(*d), GFP_ATOMIC);
+	d = kzalloc(sizeof(*d), GFP_NOWAIT);
 	if (!d)
 		return NULL;
 
-- 
2.30.2

