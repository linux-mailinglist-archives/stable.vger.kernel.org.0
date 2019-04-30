Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7BBF71F
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729130AbfD3Lt0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:49:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:35962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730981AbfD3LtZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:49:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 167A22054F;
        Tue, 30 Apr 2019 11:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624965;
        bh=BdQhIG9wILFo7eLEILQEvL3B4jrM0QzUfDXwLdG2Sgg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xQf5uGBi4QkLZXS2VapUUTrwSgQrwKRmDDpNYxxNykRS79STCJqyLvBrAzNmmSx4J
         utnFAyWhFh2OWIio85PRQ02LoN/mEWbs4dKlcN5pJtkKK4HEGTIXO30dD6ebICLzYI
         JN5fL0/Vv2C8LxX0zx7Zw3x3IVtGQcmc5zhxJjiA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shun-Chih Yu <shun-chih.yu@mediatek.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.0 39/89] dmaengine: mediatek-cqdma: fix wrong register usage in mtk_cqdma_start
Date:   Tue, 30 Apr 2019 13:38:30 +0200
Message-Id: <20190430113611.648834954@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113609.741196396@linuxfoundation.org>
References: <20190430113609.741196396@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shun-Chih Yu <shun-chih.yu@mediatek.com>

commit 5bb5c3a3ac102158b799bf5eda871223aa5e9c25 upstream.

This patch fixes wrong register usage in the mtk_cqdma_start. The
destination register should be MTK_CQDMA_DST2 instead.

Fixes: b1f01e48df5a ("dmaengine: mediatek: Add MediaTek Command-Queue DMA controller for MT6765 SoC")
Signed-off-by: Shun-Chih Yu <shun-chih.yu@mediatek.com>
Cc: stable@vger.kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/mediatek/mtk-cqdma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dma/mediatek/mtk-cqdma.c
+++ b/drivers/dma/mediatek/mtk-cqdma.c
@@ -253,7 +253,7 @@ static void mtk_cqdma_start(struct mtk_c
 #ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
 	mtk_dma_set(pc, MTK_CQDMA_DST2, cvd->dest >> MTK_CQDMA_ADDR2_SHFIT);
 #else
-	mtk_dma_set(pc, MTK_CQDMA_SRC2, 0);
+	mtk_dma_set(pc, MTK_CQDMA_DST2, 0);
 #endif
 
 	/* setup the length */


