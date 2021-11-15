Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E86474526BD
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241339AbhKPCKV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:10:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:40766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239149AbhKOR7Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:59:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B560B632D6;
        Mon, 15 Nov 2021 17:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997756;
        bh=87E0V5LZpsiXLhMwGfoL4pLLJyRMVICCu2xh+yOUbLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mePaA3FIOvU6cSMQQSV6QFB8GI3CE65cVf1EPZLpf3iKiM5JfeEUeunEu6d0QO4Pa
         tZGwhKAn19LyXRe3S1T3vC8y7NHOf+9S9LOkgKhxogpL6W9jKTiyGaUt3j6gJOjKz9
         HinIN4us1CinVLvgQPY3kH9yjuT3wzO5zZ9cNvA8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aleksander Jan Bajkowski <olek2@wp.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 264/575] MIPS: lantiq: dma: fix burst length for DEU
Date:   Mon, 15 Nov 2021 17:59:49 +0100
Message-Id: <20211115165352.902025555@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
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
index e45077aecf83a..ab13e257132af 100644
--- a/arch/mips/lantiq/xway/dma.c
+++ b/arch/mips/lantiq/xway/dma.c
@@ -40,7 +40,11 @@
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
 
@@ -191,7 +195,8 @@ ltq_dma_init_port(int p)
 		break;
 
 	case DMA_PORT_DEU:
-		ltq_dma_w32((DMA_2W_BURST << 4) | (DMA_2W_BURST << 2),
+		ltq_dma_w32((DMA_PCTRL_2W_BURST << DMA_TX_BURST_SHIFT) |
+			(DMA_PCTRL_2W_BURST << DMA_RX_BURST_SHIFT),
 			LTQ_DMA_PCTRL);
 		break;
 
-- 
2.33.0



