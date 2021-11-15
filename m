Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93FE745105F
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:44:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242310AbhKOSrU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:47:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:50350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239681AbhKOSof (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:44:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6ADCD63374;
        Mon, 15 Nov 2021 18:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999567;
        bh=l7IbL0SCAf5kl9Zwvubb+PMWofpQ2xz7GEE4JfWaloU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l+loacS7H8YMAElOCdM7IOCmCNloMfCjTZr+WSKUgS2mfyJgoA9QT/rwNpWVcxUtv
         nvRcC/FRU3gYjPaxHVaIqi0CE7XVGUy0HM3nDPWm378jbO1M7SQnI6+b4B6BHfRMv4
         LuY/LKgAL+bDb4gllsc4C7uL7zqet5HzstRfb5Po=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aleksander Jan Bajkowski <olek2@wp.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 344/849] MIPS: lantiq: dma: fix burst length for DEU
Date:   Mon, 15 Nov 2021 17:57:07 +0100
Message-Id: <20211115165431.869689049@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit 5ad74d39c51dd41b3c819f4f5396655f0629b4fd ]

The current definition of 2W burst length is invalid.
This patch fixes it. Current downstream DEU driver doesn't
use DMA. An incorrect burst length value doesn't cause any
errors. This patch also adds other burst length values.

Fixes: dfec1a827d2b ("MIPS: Lantiq: Add DMA support")
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/lantiq/xway/dma.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/mips/lantiq/xway/dma.c b/arch/mips/lantiq/xway/dma.c
index 364ab39eb8a41..53fcc672a2944 100644
--- a/arch/mips/lantiq/xway/dma.c
+++ b/arch/mips/lantiq/xway/dma.c
@@ -41,7 +41,11 @@
 #define DMA_IRQ_ACK		0x7e		/* IRQ status register */
 #define DMA_POLL		BIT(31)		/* turn on channel polling */
 #define DMA_CLK_DIV4		BIT(6)		/* polling clock divider */
-#define DMA_2W_BURST		BIT(1)		/* 2 word burst length */
+#define DMA_PCTRL_2W_BURST	0x1		/* 2 word burst length */
+#define DMA_PCTRL_4W_BURST	0x2		/* 4 word burst length */
+#define DMA_PCTRL_8W_BURST	0x3		/* 8 word burst length */
+#define DMA_TX_BURST_SHIFT	4		/* tx burst shift */
+#define DMA_RX_BURST_SHIFT	2		/* rx burst shift */
 #define DMA_ETOP_ENDIANNESS	(0xf << 8) /* endianness swap etop channels */
 #define DMA_WEIGHT	(BIT(17) | BIT(16))	/* default channel wheight */
 
@@ -192,7 +196,8 @@ ltq_dma_init_port(int p)
 		break;
 
 	case DMA_PORT_DEU:
-		ltq_dma_w32((DMA_2W_BURST << 4) | (DMA_2W_BURST << 2),
+		ltq_dma_w32((DMA_PCTRL_2W_BURST << DMA_TX_BURST_SHIFT) |
+			(DMA_PCTRL_2W_BURST << DMA_RX_BURST_SHIFT),
 			LTQ_DMA_PCTRL);
 		break;
 
-- 
2.33.0



