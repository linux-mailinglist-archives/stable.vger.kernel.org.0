Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BAB7451297
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346953AbhKOTh4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:37:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:43994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244903AbhKOTSL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:18:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 017B363283;
        Mon, 15 Nov 2021 18:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000723;
        bh=zjJ+h3wOFBt7imgOdQ4hPI/rIOiXUiMO0kH/8s2vxfo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aeTQi90HGf/BldQqBDSkD7wSiGwVe9/vqe0zJZJ/BbxLmQs356WaGVK1gwgcK9enH
         saFZMWrY3yW/0mJK5aARCuM3wNyv51kwMuCO28KTqoC5o+fkuUjR6jjxxMQ80La/h3
         LZfI+fioLcoDp4k8CexTdq2VfKEcv4s452pqk2pU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Amelie Delaunay <amelie.delaunay@foss.st.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 767/849] dmaengine: stm32-dma: fix burst in case of unaligned memory address
Date:   Mon, 15 Nov 2021 18:04:10 +0100
Message-Id: <20211115165446.207691468@linuxfoundation.org>
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

From: Amelie Delaunay <amelie.delaunay@foss.st.com>

[ Upstream commit af229d2c2557b5cf2a3b1eb39847ec1de7446873 ]

Theorically, address pointers used by STM32 DMA must be chosen so as to
ensure that all transfers within a burst block are aligned on the address
boundary equal to the size of the transfer.
If this is always the case for peripheral addresses on STM32, it is not for
memory addresses if the user doesn't respect this alignment constraint.
To avoid a weird behavior of the DMA controller in this case (no error
triggered but data are not transferred as expected), force no burst.

Signed-off-by: Amelie Delaunay <amelie.delaunay@foss.st.com>
Link: https://lore.kernel.org/r/20211011094259.315023-4-amelie.delaunay@foss.st.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/stm32-dma.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/stm32-dma.c b/drivers/dma/stm32-dma.c
index a5dab5510e625..1b2063fb3d1d6 100644
--- a/drivers/dma/stm32-dma.c
+++ b/drivers/dma/stm32-dma.c
@@ -750,8 +750,14 @@ static int stm32_dma_set_xfer_param(struct stm32_dma_chan *chan,
 		if (src_bus_width < 0)
 			return src_bus_width;
 
-		/* Set memory burst size */
-		src_maxburst = STM32_DMA_MAX_BURST;
+		/*
+		 * Set memory burst size - burst not possible if address is not aligned on
+		 * the address boundary equal to the size of the transfer
+		 */
+		if (buf_addr % buf_len)
+			src_maxburst = 1;
+		else
+			src_maxburst = STM32_DMA_MAX_BURST;
 		src_best_burst = stm32_dma_get_best_burst(buf_len,
 							  src_maxburst,
 							  fifoth,
@@ -800,8 +806,14 @@ static int stm32_dma_set_xfer_param(struct stm32_dma_chan *chan,
 		if (dst_bus_width < 0)
 			return dst_bus_width;
 
-		/* Set memory burst size */
-		dst_maxburst = STM32_DMA_MAX_BURST;
+		/*
+		 * Set memory burst size - burst not possible if address is not aligned on
+		 * the address boundary equal to the size of the transfer
+		 */
+		if (buf_addr % buf_len)
+			dst_maxburst = 1;
+		else
+			dst_maxburst = STM32_DMA_MAX_BURST;
 		dst_best_burst = stm32_dma_get_best_burst(buf_len,
 							  dst_maxburst,
 							  fifoth,
-- 
2.33.0



