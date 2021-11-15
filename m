Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68192451E65
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:33:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244062AbhKPAfz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:35:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:45394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344864AbhKOTZh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9ADF633E8;
        Mon, 15 Nov 2021 19:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003142;
        bh=Cf6z/Ij3iuscSZD3q8tQBFiZJ4Qvzg0vi+xJHVZWXsE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hntzXPtOxGA26s2PL/xpY/7v6fpOd2+knJACk/9IuRBjp7gfjy7J3M45dJM1E4gTu
         XQzgIWDTFbEEDNh5M/KDMYkTg24wzCjH4S4V+l/BD0CJlxqvKu5T+mRwjUznk5qruu
         gQOlbpoDwEHHTT9Dc0Ss7EQNOPJrcImprhn54mbs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Amelie Delaunay <amelie.delaunay@foss.st.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 826/917] dmaengine: stm32-dma: avoid 64-bit division in stm32_dma_get_max_width
Date:   Mon, 15 Nov 2021 18:05:21 +0100
Message-Id: <20211115165457.065564669@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 2498363310e9b5e5de0e104709adc35c9f3ff7d9 ]

Using the % operator on a 64-bit variable is expensive and can
cause a link failure:

arm-linux-gnueabi-ld: drivers/dma/stm32-dma.o: in function `stm32_dma_get_max_width':
stm32-dma.c:(.text+0x170): undefined reference to `__aeabi_uldivmod'
arm-linux-gnueabi-ld: drivers/dma/stm32-dma.o: in function `stm32_dma_set_xfer_param':
stm32-dma.c:(.text+0x1cd4): undefined reference to `__aeabi_uldivmod'

As we know that we just want to check the alignment in
stm32_dma_get_max_width(), there is no need for a full division, and
using a simple mask is a faster replacement.

Same in stm32_dma_set_xfer_param(), change this to only allow burst
transfers if the address is a multiple of the length.
stm32_dma_get_best_burst just after will take buf_len into account to fix
burst in case of misalignment.

Fixes: b20fd5fa310c ("dmaengine: stm32-dma: fix stm32_dma_get_max_width")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Amelie Delaunay <amelie.delaunay@foss.st.com>
Link: https://lore.kernel.org/r/20211103153312.41483-1-amelie.delaunay@foss.st.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/stm32-dma.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/stm32-dma.c b/drivers/dma/stm32-dma.c
index c276a39aa7930..7dfc743ac4338 100644
--- a/drivers/dma/stm32-dma.c
+++ b/drivers/dma/stm32-dma.c
@@ -280,7 +280,7 @@ static enum dma_slave_buswidth stm32_dma_get_max_width(u32 buf_len,
 	       max_width > DMA_SLAVE_BUSWIDTH_1_BYTE)
 		max_width = max_width >> 1;
 
-	if (buf_addr % max_width)
+	if (buf_addr & (max_width - 1))
 		max_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
 
 	return max_width;
@@ -756,7 +756,7 @@ static int stm32_dma_set_xfer_param(struct stm32_dma_chan *chan,
 		 * Set memory burst size - burst not possible if address is not aligned on
 		 * the address boundary equal to the size of the transfer
 		 */
-		if (buf_addr % buf_len)
+		if (buf_addr & (buf_len - 1))
 			src_maxburst = 1;
 		else
 			src_maxburst = STM32_DMA_MAX_BURST;
@@ -812,7 +812,7 @@ static int stm32_dma_set_xfer_param(struct stm32_dma_chan *chan,
 		 * Set memory burst size - burst not possible if address is not aligned on
 		 * the address boundary equal to the size of the transfer
 		 */
-		if (buf_addr % buf_len)
+		if (buf_addr & (buf_len - 1))
 			dst_maxburst = 1;
 		else
 			dst_maxburst = STM32_DMA_MAX_BURST;
-- 
2.33.0



