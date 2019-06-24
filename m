Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89D265083C
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729877AbfFXKPm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:15:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:52968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729747AbfFXKPj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:15:39 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B79DF205ED;
        Mon, 24 Jun 2019 10:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561371339;
        bh=Qp5rodsvKjiXWqJYgjTqfZKFaoCWh2/UkvopTy/m54k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hcR/rxSQUjWK9HmVBRFGEd95kawziO4fVY1wWCc1vmbfjTYsjlSD0y7KrSDtjFA7j
         r9iKlHTp1BEPcl7yjqDc1OKVXwlOopa9uxkCoqtx3hSKf4VoXqg99+oVyQOHv6Qfi+
         khrnQ/opivMVRc0pxh/XIY1HaUAk1lJRHjk5+H80=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 035/121] dmaengine: mediatek-cqdma: sleeping in atomic context
Date:   Mon, 24 Jun 2019 17:56:07 +0800
Message-Id: <20190624092322.613626713@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
References: <20190624092320.652599624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 069b3c4214f27b130d0642f32438560db30f452e ]

The mtk_cqdma_poll_engine_done() function takes a true/false parameter
where true means it's called from atomic context.  There are a couple
places where it was set to false but it's actually in atomic context
so it should be true.

All the callers for mtk_cqdma_hard_reset() are holding a spin_lock and
in mtk_cqdma_free_chan_resources() we take a spin_lock before calling
the mtk_cqdma_poll_engine_done() function.

Fixes: b1f01e48df5a ("dmaengine: mediatek: Add MediaTek Command-Queue DMA controller for MT6765 SoC")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/mediatek/mtk-cqdma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/mediatek/mtk-cqdma.c b/drivers/dma/mediatek/mtk-cqdma.c
index 814853842e29..723b11c190b3 100644
--- a/drivers/dma/mediatek/mtk-cqdma.c
+++ b/drivers/dma/mediatek/mtk-cqdma.c
@@ -225,7 +225,7 @@ static int mtk_cqdma_hard_reset(struct mtk_cqdma_pchan *pc)
 	mtk_dma_set(pc, MTK_CQDMA_RESET, MTK_CQDMA_HARD_RST_BIT);
 	mtk_dma_clr(pc, MTK_CQDMA_RESET, MTK_CQDMA_HARD_RST_BIT);
 
-	return mtk_cqdma_poll_engine_done(pc, false);
+	return mtk_cqdma_poll_engine_done(pc, true);
 }
 
 static void mtk_cqdma_start(struct mtk_cqdma_pchan *pc,
@@ -671,7 +671,7 @@ static void mtk_cqdma_free_chan_resources(struct dma_chan *c)
 		mtk_dma_set(cvc->pc, MTK_CQDMA_FLUSH, MTK_CQDMA_FLUSH_BIT);
 
 		/* wait for the completion of flush operation */
-		if (mtk_cqdma_poll_engine_done(cvc->pc, false) < 0)
+		if (mtk_cqdma_poll_engine_done(cvc->pc, true) < 0)
 			dev_err(cqdma2dev(to_cqdma_dev(c)), "cqdma flush timeout\n");
 
 		/* clear the flush bit and interrupt flag */
-- 
2.20.1



