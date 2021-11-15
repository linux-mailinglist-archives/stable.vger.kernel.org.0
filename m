Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBD8F451E2E
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348673AbhKPAfU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:35:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:45220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344637AbhKOTZK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05B2D63354;
        Mon, 15 Nov 2021 19:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002880;
        bh=M7Ejnyu+C91jtdf0w6kIO7mmSOv60oYyPFb91OywY8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vXplyhDX65P2RepElAu1ogltL6QD9hukxBaqwOaEVbUuiQeOu5U049mf8A/A8YQ1E
         m/AwH59Z1U9B2QVNexfmyk9B4/E11p/FNVt/0wFwQlaR4hcuadPFKLnWqIAQgF2b6A
         RSaV8A1m0a0HrIwN/Ud9gI6hw24+SdPegqhKkOEM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Amelie Delaunay <amelie.delaunay@foss.st.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 729/917] dmaengine: stm32-dma: fix stm32_dma_get_max_width
Date:   Mon, 15 Nov 2021 18:03:44 +0100
Message-Id: <20211115165453.636730032@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amelie Delaunay <amelie.delaunay@foss.st.com>

[ Upstream commit b20fd5fa310cbf7ec367f263a34382a24c4cee73 ]

buf_addr parameter of stm32_dma_set_xfer_param function is a dma_addr_t.
We only need to check the remainder of buf_addr/max_width, so, no need to
use do_div and extra u64 addr. Use '%' instead.

Fixes: e0ebdbdcb42a ("dmaengine: stm32-dma: take address into account when computing max width")
Signed-off-by: Amelie Delaunay <amelie.delaunay@foss.st.com>
Link: https://lore.kernel.org/r/20211011094259.315023-3-amelie.delaunay@foss.st.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/stm32-dma.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/dma/stm32-dma.c b/drivers/dma/stm32-dma.c
index 9063c727962ed..fdda916555ec5 100644
--- a/drivers/dma/stm32-dma.c
+++ b/drivers/dma/stm32-dma.c
@@ -270,7 +270,6 @@ static enum dma_slave_buswidth stm32_dma_get_max_width(u32 buf_len,
 						       u32 threshold)
 {
 	enum dma_slave_buswidth max_width;
-	u64 addr = buf_addr;
 
 	if (threshold == STM32_DMA_FIFO_THRESHOLD_FULL)
 		max_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
@@ -281,7 +280,7 @@ static enum dma_slave_buswidth stm32_dma_get_max_width(u32 buf_len,
 	       max_width > DMA_SLAVE_BUSWIDTH_1_BYTE)
 		max_width = max_width >> 1;
 
-	if (do_div(addr, max_width))
+	if (buf_addr % max_width)
 		max_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
 
 	return max_width;
-- 
2.33.0



