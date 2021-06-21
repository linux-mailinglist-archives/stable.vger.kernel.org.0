Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 252583AF318
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 19:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232409AbhFUR7I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 13:59:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:39062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232888AbhFUR4M (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 13:56:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BADBC61380;
        Mon, 21 Jun 2021 17:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624297997;
        bh=zwjrpBQ7o0x2xqtiyXHPgA7MFvj9vARlzFvp3O45wJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sdb+N3G5AVaUAotaq0eKMI+IGHViFyorcmkVg4B7BnynU2Xpxr8B6rg0s5Hp2CGJQ
         vdsiArlhKC1sRg5cFDszCS0NQcLOJXhjl5R1LQa/9M1hNLoqQAm41N2h+utQyxZMgc
         8Er8kd3cdbOAuS9uMtM3cT+8hTyQLN3UVQ60NArw53b9QZIkKc6k5KR9cCnbQObpzS
         InbjR3LJwt36K+BKMJGJ+rL70B6T8yNRXI834yAdNarWkeKKl0MylyFQwUzptiOeQD
         lXYcc9cfV3iIu8j5yJVlK2LVB1nhEtHzHr3ESaIkPx3GIdUP03B2C5hCLvpwhJt4xF
         fN+y3cn7SRkjg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guillaume Ranquet <granquet@baylibre.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 11/35] dmaengine: mediatek: use GFP_NOWAIT instead of GFP_ATOMIC in prep_dma
Date:   Mon, 21 Jun 2021 13:52:36 -0400
Message-Id: <20210621175300.735437-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175300.735437-1-sashal@kernel.org>
References: <20210621175300.735437-1-sashal@kernel.org>
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

