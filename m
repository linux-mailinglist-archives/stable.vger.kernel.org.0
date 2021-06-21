Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41B4D3AF277
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 19:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232125AbhFURys (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 13:54:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:38662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231929AbhFURyc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 13:54:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F1A061206;
        Mon, 21 Jun 2021 17:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624297938;
        bh=zwjrpBQ7o0x2xqtiyXHPgA7MFvj9vARlzFvp3O45wJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nWCfkzlcmfMnNTCo0ZMvPy9lP7yka1yL3QaaA0TDkTgwhU1RhUA4zezoTvLlqK+Dr
         Oymw3FQNTjgb1zGaIJs+iMCq73SHEce0zjK3pTmG1nDOoRlAuEfUCeuX/XEt7WwWrs
         J7RNN7+m7LxJP+OL+xs0znHfssnoinbS4SUktk9zQ0NBnMrdYbRgYC17TPJKgb0z0k
         5CxDquj+tTbxeH1W1oOvHsAAWGGBR4kaq2sxHOCVuoUst7NDFLJ5tSVesWq4oDLC3w
         FZyJH1gEXeFDzlnRkQldhuAhBLJgxB59tXA4kIXeo/4LzBXdDoOcSJHwNy7wNvQKUF
         goCFvedYxFeXg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guillaume Ranquet <granquet@baylibre.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.12 12/39] dmaengine: mediatek: use GFP_NOWAIT instead of GFP_ATOMIC in prep_dma
Date:   Mon, 21 Jun 2021 13:51:28 -0400
Message-Id: <20210621175156.735062-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175156.735062-1-sashal@kernel.org>
References: <20210621175156.735062-1-sashal@kernel.org>
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
index a09ab2dd3b46..375e7e647df6 100644
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

