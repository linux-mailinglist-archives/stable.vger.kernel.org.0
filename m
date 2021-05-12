Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C151737C5F2
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235287AbhELPoj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:44:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:57176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236602AbhELPk6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:40:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 858B86101B;
        Wed, 12 May 2021 15:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832882;
        bh=cBtYXJ/ed3+R8re53TUA0HqSCkwS+TTEGW/GYTTRJEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kzQ4Dfx64IzstIGdwScY/lB64yy7aaqV6vnLhDkZ2GRVmRzQmyN/lTvzFxZmlSzsn
         jziao8/RXDf6wWEQ4Q34Juxz4EcaJvFnnjfTJxg9ZB02EGZD76l28NudJU6U/cBiw2
         BvkZMr1/6e5wFKhYStbFMTm2rPxMCPP+/GXx7sqA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qii Wang <qii.wang@mediatek.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 461/530] i2c: mediatek: Fix wrong dma sync flag
Date:   Wed, 12 May 2021 16:49:31 +0200
Message-Id: <20210512144834.909107393@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qii Wang <qii.wang@mediatek.com>

[ Upstream commit 3186b880447ad3cc9b6487fa626a71d64b831524 ]

The right flag is apdma_sync when apdma remove hand-shake signel.

Fixes: 05f6f7271a38 ("i2c: mediatek: Fix apdma and i2c hand-shake timeout")
Signed-off-by: Qii Wang <qii.wang@mediatek.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-mt65xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-mt65xx.c b/drivers/i2c/busses/i2c-mt65xx.c
index 2ffd2f354d0a..86f70c751319 100644
--- a/drivers/i2c/busses/i2c-mt65xx.c
+++ b/drivers/i2c/busses/i2c-mt65xx.c
@@ -479,7 +479,7 @@ static void mtk_i2c_init_hw(struct mtk_i2c *i2c)
 {
 	u16 control_reg;
 
-	if (i2c->dev_comp->dma_sync) {
+	if (i2c->dev_comp->apdma_sync) {
 		writel(I2C_DMA_WARM_RST, i2c->pdmabase + OFFSET_RST);
 		udelay(10);
 		writel(I2C_DMA_CLR_FLAG, i2c->pdmabase + OFFSET_RST);
-- 
2.30.2



