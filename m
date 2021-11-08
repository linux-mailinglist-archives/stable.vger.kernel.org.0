Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0354E44A049
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237223AbhKIBCy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:02:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:59062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241498AbhKIBCu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:02:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CCF06124D;
        Tue,  9 Nov 2021 01:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419605;
        bh=Ja4sfL0puwDXNS+I4ZRmUISm3QMFen7tERu64JKWy0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=THiYQdYeyj0jCW2P6cX4d3zGAJ2MeAE/TojdYG2AEGUkIukqDYDyJ4lV8Fe7+ozxG
         S8Eoey4H/w4qMszUwlQQ13DOiZBi3DWdf/IibvQc4p3Kd+KhAd+baNm9PV97RN6ilA
         SOBefX3+QM6u//LJ5kfxsxKBuo51oZj3En0/khYgt4gbKRuX4UwFNLDr+tYJpjQIRP
         o1m+XOspnpAuBN2PYx7tLJ/oRWvfRR/yV3u8CwMsuVbUrXj75ShzA2qQRPXg+gZL3s
         amGAGx2axflfkwXigusEIWtOSsL3zgzBQQPevd97VL5LTG3sXDqvhfoNWCK5WWcHUV
         9jmZZpEBkmMUA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aleksander Jan Bajkowski <olek2@wp.pl>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, john@phrozen.org,
        tsbogend@alpha.franken.de, hauke@hauke-m.de, maz@kernel.org,
        linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 013/146] MIPS: lantiq: dma: reset correct number of channel
Date:   Mon,  8 Nov 2021 12:42:40 -0500
Message-Id: <20211108174453.1187052-13-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108174453.1187052-1-sashal@kernel.org>
References: <20211108174453.1187052-1-sashal@kernel.org>
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
index 2784715933d13..364ab39eb8a41 100644
--- a/arch/mips/lantiq/xway/dma.c
+++ b/arch/mips/lantiq/xway/dma.c
@@ -31,6 +31,7 @@
 #define LTQ_DMA_PCTRL		0x44
 #define LTQ_DMA_IRNEN		0xf4
 
+#define DMA_ID_CHNR		GENMASK(26, 20)	/* channel number */
 #define DMA_DESCPT		BIT(3)		/* descriptor complete irq */
 #define DMA_TX			BIT(8)		/* TX channel direction */
 #define DMA_CHAN_ON		BIT(0)		/* channel on / off bit */
@@ -41,7 +42,6 @@
 #define DMA_POLL		BIT(31)		/* turn on channel polling */
 #define DMA_CLK_DIV4		BIT(6)		/* polling clock divider */
 #define DMA_2W_BURST		BIT(1)		/* 2 word burst length */
-#define DMA_MAX_CHANNEL		20		/* the soc has 20 channels */
 #define DMA_ETOP_ENDIANNESS	(0xf << 8) /* endianness swap etop channels */
 #define DMA_WEIGHT	(BIT(17) | BIT(16))	/* default channel wheight */
 
@@ -207,7 +207,7 @@ ltq_dma_init(struct platform_device *pdev)
 {
 	struct clk *clk;
 	struct resource *res;
-	unsigned id;
+	unsigned int id, nchannels;
 	int i;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -229,17 +229,18 @@ ltq_dma_init(struct platform_device *pdev)
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

