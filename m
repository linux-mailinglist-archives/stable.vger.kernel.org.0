Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 858F144A213
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:15:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239541AbhKIBQT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:16:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:38994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242271AbhKIBNR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:13:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D193361A8F;
        Tue,  9 Nov 2021 01:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419926;
        bh=mDqSDRAhasWI07AIcKI0GSUOYRjeBcctGHPuXX1HRos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XeddbdiTswAN02RkLfGxHPBSaDQL301Pp5zS83ljNrgagvLYE/qLiF+PsR3DjFmjQ
         uc2xRzsjzcP1jTUzGOyElBO7xjrVY9zeqYZMbR6e85N2/+z2ZZLXkROwdJ8gyH0NEb
         OoMJR1fEGJlgbYGjIrXkWFrbIv1FljkBJCTS8rUlQjjWn6a4sHKwJC+hwrdTN9bl40
         wwkYGRz2hn9mCV12fdE+hLB68/ujhRFk2MrncJPLezcBbMxyyURAhltbcoqpFQNxSy
         8HKqzo7tnAgv997iSbajH8xJBJQj1/devyhS5ACNm9aws0u+Y+J/hRq0NHPyNxB0Ds
         39jW0W/ypjF1w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aleksander Jan Bajkowski <olek2@wp.pl>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, john@phrozen.org,
        tsbogend@alpha.franken.de, hauke@hauke-m.de, maz@kernel.org,
        linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 06/47] MIPS: lantiq: dma: reset correct number of channel
Date:   Mon,  8 Nov 2021 12:49:50 -0500
Message-Id: <20211108175031.1190422-6-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108175031.1190422-1-sashal@kernel.org>
References: <20211108175031.1190422-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit 5ca9ce2ba4d5884cd94d1a856c675ab1242cd242 ]

Different SoCs have a different number of channels, e.g .:
* amazon-se has 10 channels,
* danube+ar9 have 20 channels,
* vr9 has 28 channels,
* ar10 has 24 channels.

We can read the ID register and, depending on the reported
number of channels, reset the appropriate number of channels.

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/lantiq/xway/dma.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/mips/lantiq/xway/dma.c b/arch/mips/lantiq/xway/dma.c
index 45a622b72cd13..efee1c538a518 100644
--- a/arch/mips/lantiq/xway/dma.c
+++ b/arch/mips/lantiq/xway/dma.c
@@ -41,6 +41,7 @@
 #define LTQ_DMA_PCTRL		0x44
 #define LTQ_DMA_IRNEN		0xf4
 
+#define DMA_ID_CHNR		GENMASK(26, 20)	/* channel number */
 #define DMA_DESCPT		BIT(3)		/* descriptor complete irq */
 #define DMA_TX			BIT(8)		/* TX channel direction */
 #define DMA_CHAN_ON		BIT(0)		/* channel on / off bit */
@@ -51,7 +52,6 @@
 #define DMA_POLL		BIT(31)		/* turn on channel polling */
 #define DMA_CLK_DIV4		BIT(6)		/* polling clock divider */
 #define DMA_2W_BURST		BIT(1)		/* 2 word burst length */
-#define DMA_MAX_CHANNEL		20		/* the soc has 20 channels */
 #define DMA_ETOP_ENDIANNESS	(0xf << 8) /* endianness swap etop channels */
 #define DMA_WEIGHT	(BIT(17) | BIT(16))	/* default channel wheight */
 
@@ -218,7 +218,7 @@ ltq_dma_init(struct platform_device *pdev)
 {
 	struct clk *clk;
 	struct resource *res;
-	unsigned id;
+	unsigned int id, nchannels;
 	int i;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -240,17 +240,18 @@ ltq_dma_init(struct platform_device *pdev)
 	ltq_dma_w32(0, LTQ_DMA_IRNEN);
 
 	/* reset/configure each channel */
-	for (i = 0; i < DMA_MAX_CHANNEL; i++) {
+	id = ltq_dma_r32(LTQ_DMA_ID);
+	nchannels = ((id & DMA_ID_CHNR) >> 20);
+	for (i = 0; i < nchannels; i++) {
 		ltq_dma_w32(i, LTQ_DMA_CS);
 		ltq_dma_w32(DMA_CHAN_RST, LTQ_DMA_CCTRL);
 		ltq_dma_w32(DMA_POLL | DMA_CLK_DIV4, LTQ_DMA_CPOLL);
 		ltq_dma_w32_mask(DMA_CHAN_ON, 0, LTQ_DMA_CCTRL);
 	}
 
-	id = ltq_dma_r32(LTQ_DMA_ID);
 	dev_info(&pdev->dev,
 		"Init done - hw rev: %X, ports: %d, channels: %d\n",
-		id & 0x1f, (id >> 16) & 0xf, id >> 20);
+		id & 0x1f, (id >> 16) & 0xf, nchannels);
 
 	return 0;
 }
-- 
2.33.0

